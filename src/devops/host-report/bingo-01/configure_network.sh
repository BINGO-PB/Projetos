#!/usr/bin/env bash

set -euo pipefail

#
# Reproduz a rede implementada no bingo-01 com parâmetros mínimos:
# - WAN IF fixa: enp5s0
# - WAN GW fixa: 150.165.37.254
# - LAN IF fixa: enx00e04c103a38
# - LAN IP fixo: 192.168.10.100/24
# - NAT/forward entre LAN e WAN
# - SSH em porta parametrizável
# - fail2ban para SSH
# - bloco gerenciado em /etc/hosts com máquinas da LAN
#
# Exemplo:
#   sudo ./configure_network.sh --wan-ip 150.165.37.54 --ssh-port 2222
#

WAN_IF="enp5s0"
WAN_GW="150.165.37.254"
LAN_IF="enx00e04c103a38"
LAN_CIDR="192.168.10.100/24"
LAN_NET="192.168.10.0/24"

WAN_IP=""
SSH_PORT="2222"
DRY_RUN=0

usage() {
    cat <<EOF
Uso: $0 --wan-ip <ipv4> [--ssh-port <porta>] [--dry-run]

Parâmetros:
  --wan-ip <ipv4>      IP IPv4 da interface WAN (${WAN_IF})
  --ssh-port <porta>   Porta do SSH (padrão: 2222)
    --dry-run            Mostra o plano de mudanças sem aplicar nada
  --help               Mostra esta ajuda
EOF
}

require_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        echo "ERRO: execute como root (sudo)."
        exit 1
    fi
}

backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        cp -a "$file" "${file}.bak.$(date +%Y%m%d-%H%M%S)"
    fi
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --wan-ip)
                WAN_IP="$2"
                shift 2
                ;;
            --ssh-port)
                SSH_PORT="$2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN=1
                shift
                ;;
            --help)
                usage
                exit 0
                ;;
            *)
                echo "Argumento desconhecido: $1"
                usage
                exit 1
                ;;
        esac
    done

    if [[ -z "$WAN_IP" ]]; then
        echo "ERRO: informe --wan-ip <ipv4>."
        usage
        exit 1
    fi

    if ! [[ "$WAN_IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "ERRO: WAN IP inválido: $WAN_IP"
        exit 1
    fi

    if ! [[ "$SSH_PORT" =~ ^[0-9]+$ ]] || [[ "$SSH_PORT" -lt 1 || "$SSH_PORT" -gt 65535 ]]; then
        echo "ERRO: porta SSH inválida: $SSH_PORT"
        exit 1
    fi
}

show_dry_run_plan() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    echo "[DRY-RUN] Nenhuma alteração será aplicada."
    echo
    echo "[1/6] Interfaces e rotas"
    echo "  - ip link set ${WAN_IF} up"
    echo "  - ip link set ${LAN_IF} up"
    echo "  - ip addr flush dev ${WAN_IF}"
    echo "  - ip addr add ${WAN_IP}/24 dev ${WAN_IF}"
    echo "  - ip addr flush dev ${LAN_IF}"
    echo "  - ip addr add ${LAN_CIDR} dev ${LAN_IF}"
    echo "  - ip route replace ${LAN_NET} dev ${LAN_IF} src 192.168.10.100 metric 100"
    echo "  - ip route replace default via ${WAN_GW} dev ${WAN_IF} metric 101"
    echo
    echo "[2/6] IPv4 forwarding"
    echo "  - sysctl -w net.ipv4.ip_forward=1"
    echo "  - escrever /etc/sysctl.d/99-bingo-forwarding.conf"
    echo "  - sysctl --system"
    echo
    echo "[3/6] iptables + persistência"
    echo "  - regra NAT MASQUERADE para ${LAN_NET} -> ${WAN_IF}"
    echo "  - regras FORWARD (${LAN_IF} -> ${WAN_IF}) e retorno RELATED,ESTABLISHED"
    echo "  - regra INPUT para SSH na porta ${SSH_PORT}"
    echo "  - apt-get install iptables-persistent"
    echo "  - netfilter-persistent save"
    echo
    echo "[4/6] SSH"
    echo "  - backup e edição de /etc/ssh/sshd_config (Port ${SSH_PORT})"
    echo "  - validação: sshd -t"
    echo "  - restart do serviço ssh/sshd"
    echo
    echo "[5/6] fail2ban"
    echo "  - apt-get install fail2ban"
    echo "  - backup e escrita de /etc/fail2ban/jail.local para porta ${SSH_PORT}"
    echo "  - systemctl enable --now fail2ban"
    echo
    echo "[6/6] Hosts LAN"
    echo "  - backup e atualização de /etc/hosts com bloco BINGO_LAN_HOSTS"
    echo "  - origem do bloco: ${script_dir}/hosts.lan"
    echo
    echo "Fim do dry-run ✅"
}

check_interface() {
    local iface="$1"
    ip link show "$iface" >/dev/null 2>&1
}

configure_interfaces_and_routes() {
    echo "[1/6] Configurando interfaces e rotas da rede implementada..."

    if ! check_interface "$WAN_IF"; then
        echo "ERRO: interface WAN '$WAN_IF' não encontrada."
        exit 1
    fi

    if ! check_interface "$LAN_IF"; then
        echo "ERRO: interface LAN '$LAN_IF' não encontrada."
        exit 1
    fi

    ip link set "$WAN_IF" up
    ip link set "$LAN_IF" up

    ip addr flush dev "$WAN_IF"
    ip addr add "${WAN_IP}/24" dev "$WAN_IF"

    ip addr flush dev "$LAN_IF"
    ip addr add "$LAN_CIDR" dev "$LAN_IF"

    ip route replace "$LAN_NET" dev "$LAN_IF" src 192.168.10.100 metric 100
    ip route replace default via "$WAN_GW" dev "$WAN_IF" metric 101
}

enable_ip_forwarding() {
    echo "[2/6] Habilitando encaminhamento IPv4..."
    sysctl -w net.ipv4.ip_forward=1 >/dev/null

    cat > /etc/sysctl.d/99-bingo-forwarding.conf <<EOF
net.ipv4.ip_forward=1
EOF

    sysctl --system >/dev/null
}

configure_iptables() {
    echo "[3/6] Aplicando NAT/forward entre LAN e WAN..."

    iptables -t nat -C POSTROUTING -s "$LAN_NET" -o "$WAN_IF" -j MASQUERADE 2>/dev/null || \
        iptables -t nat -A POSTROUTING -s "$LAN_NET" -o "$WAN_IF" -j MASQUERADE

    iptables -C FORWARD -i "$LAN_IF" -o "$WAN_IF" -s "$LAN_NET" -j ACCEPT 2>/dev/null || \
        iptables -A FORWARD -i "$LAN_IF" -o "$WAN_IF" -s "$LAN_NET" -j ACCEPT

    iptables -C FORWARD -i "$WAN_IF" -o "$LAN_IF" -d "$LAN_NET" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || \
        iptables -A FORWARD -i "$WAN_IF" -o "$LAN_IF" -d "$LAN_NET" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

    iptables -C INPUT -p tcp --dport "$SSH_PORT" -j ACCEPT 2>/dev/null || \
        iptables -A INPUT -p tcp --dport "$SSH_PORT" -j ACCEPT

    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y iptables-persistent
    netfilter-persistent save
}

configure_sshd() {
    echo "[4/6] Configurando SSH na porta ${SSH_PORT}..."

    local sshd_config="/etc/ssh/sshd_config"
    backup_file "$sshd_config"

    if grep -Eq '^[[:space:]]*#?[[:space:]]*Port[[:space:]]+[0-9]+' "$sshd_config"; then
        sed -ri "s|^[[:space:]]*#?[[:space:]]*Port[[:space:]]+[0-9]+|Port ${SSH_PORT}|" "$sshd_config"
    else
        echo "Port ${SSH_PORT}" >> "$sshd_config"
    fi

    sshd -t
    systemctl restart ssh || systemctl restart sshd
}

configure_fail2ban() {
    echo "[5/6] Instalando/configurando fail2ban..."

    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y fail2ban

    local jail_local="/etc/fail2ban/jail.local"
    backup_file "$jail_local"

    cat > "$jail_local" <<EOF
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = ${SSH_PORT}
logpath = %(sshd_log)s
backend = %(sshd_backend)s
EOF

    systemctl enable --now fail2ban
}

configure_hosts_lan() {
    echo "[6/6] Atualizando bloco gerenciado de hosts LAN em /etc/hosts..."

    local hosts_file="/etc/hosts"
    local script_dir
    local hosts_lan_file
    local begin="# BEGIN BINGO_LAN_HOSTS"
    local end="# END BINGO_LAN_HOSTS"
    local tmp

    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    hosts_lan_file="${script_dir}/hosts.lan"

    if [[ ! -f "$hosts_lan_file" ]]; then
        echo "ERRO: arquivo de hosts LAN não encontrado: $hosts_lan_file"
        exit 1
    fi

    tmp="$(mktemp)"
    backup_file "$hosts_file"

    awk -v begin="$begin" -v end="$end" '
        $0 == begin {skip=1; next}
        $0 == end {skip=0; next}
        !skip {print}
    ' "$hosts_file" > "$tmp"

    {
        cat "$tmp"
        echo "$begin"
        cat "$hosts_lan_file"
        echo "$end"
    } > "$hosts_file"

    rm -f "$tmp"
}

main() {
    parse_args "$@"

    if [[ "$DRY_RUN" -eq 1 ]]; then
        show_dry_run_plan
        return 0
    fi

    require_root
    configure_interfaces_and_routes
    enable_ip_forwarding
    configure_iptables
    configure_sshd
    configure_fail2ban
    configure_hosts_lan

    echo
    echo "Concluído ✅"
    echo "- WAN: ${WAN_IF} (${WAN_IP}/24), GW ${WAN_GW}"
    echo "- LAN: ${LAN_IF} (${LAN_CIDR})"
    echo "- SSH porta: ${SSH_PORT}"
}

main "$@"
