#!/usr/bin/env bash

set -euo pipefail

OUT_DIR="${1:-./reports}"
TS="$(date +%Y%m%d-%H%M%S)"

DISK_REPORT="${OUT_DIR}/disks_mounts_report_${TS}.txt"
FSTAB_COPY="${OUT_DIR}/fstab_${TS}.conf"
PKG_REPORT="${OUT_DIR}/packages_installed_${TS}.txt"
PKG_MANUAL_REPORT="${OUT_DIR}/packages_manual_${TS}.txt"
SERVICES_REPORT="${OUT_DIR}/services_report_${TS}.txt"
CUSTOM_SERVICES_REPORT="${OUT_DIR}/services_custom_report_${TS}.txt"
REPLAY_SCRIPT="${OUT_DIR}/replay_mounts_from_fstab_${TS}.sh"
SYSTEMD_BLAME="${OUT_DIR}/systemd_blame_${TS}.txt"
SYSTEMD_CRITICAL="${OUT_DIR}/systemd_critical_${TS}.txt"
LSCPU_REPORT="${OUT_DIR}/lscpu_${TS}.txt"
LSBLK_REPORT="${OUT_DIR}/lsblk_${TS}.txt"
FREE_REPORT="${OUT_DIR}/free_${TS}.txt"
IPADDR_REPORT="${OUT_DIR}/ip_addr_${TS}.txt"
SYSTEM_REPORT="./system_report.md"

mkdir -p "$OUT_DIR"

echo "[1/4] Gerando relatório de discos e montagens: $DISK_REPORT"
{
    mapfile -t LOCAL_SDISKS < <(ls /sys/block 2>/dev/null | grep -E '^sd[a-z]+$' | sort)

    echo "# Relatório de discos e montagens"
    echo "# Host: $(hostname -f 2>/dev/null || hostname)"
    echo "# Data: $(date -Is)"
    echo "# Escopo: discos reais /dev/sd* e montagens NFS"
    echo

    echo "## Resumo amigável (locais + NFS)"
    echo "### Montagens locais (/dev/sd*)"
    findmnt -rno SOURCE,TARGET,FSTYPE,OPTIONS | awk '$1 ~ /^\/dev\/sd/ {
        printf("- LOCAL  %-14s -> %-22s (%s)\n", $1, $2, $3)
    }'
    echo
    echo "### Montagens NFS"
    findmnt -rno SOURCE,TARGET,FSTYPE,OPTIONS | awk '$3 ~ /^nfs/ {
        printf("- NFS    %-20s -> %-22s (%s)\n", $1, $2, $3)
    }'
    echo

    echo "## lsblk (árvore de discos reais /dev/sd*)"
    if [[ "${#LOCAL_SDISKS[@]}" -gt 0 ]]; then
        lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINTS $(printf '/dev/%s ' "${LOCAL_SDISKS[@]}")
    else
        echo "Aviso: nenhum disco /dev/sd* encontrado neste host."
    fi
    echo

    echo "## df -hT (somente /dev/sd* e NFS)"
    df -hT | awk 'NR==1 || $1 ~ /^\/dev\/sd/ || $2 ~ /^nfs/'
    echo

    echo "## findmnt (somente /dev/sd* e NFS)"
    findmnt -rno SOURCE,TARGET,FSTYPE,OPTIONS | awk '$1 ~ /^\/dev\/sd/ || $3 ~ /^nfs/'
    echo

    echo "## /etc/fstab (somente /dev/sd* e NFS; sem comentários)"
    awk 'NF && $1 !~ /^#/ && ($1 ~ /^\/dev\/sd/ || $3 ~ /^nfs/)' /etc/fstab || true
} > "$DISK_REPORT"

cp -a /etc/fstab "$FSTAB_COPY"

echo "[2/4] Salvando inventário de pacotes: $PKG_REPORT e $PKG_MANUAL_REPORT"
{
    echo "# Pacotes instalados (dpkg-query)"
    echo "# Host: $(hostname -f 2>/dev/null || hostname)"
    echo "# Data: $(date -Is)"
    echo
    dpkg-query -W -f='${binary:Package}\t${Version}\n' | sort
} > "$PKG_REPORT"

{
    echo "# Pacotes marcados manualmente (apt-mark showmanual)"
    echo "# Host: $(hostname -f 2>/dev/null || hostname)"
    echo "# Data: $(date -Is)"
    echo
    apt-mark showmanual | sort
} > "$PKG_MANUAL_REPORT"

echo "[3/4] Gerando relatório de serviços: $SERVICES_REPORT"
{
    echo "# Relatório de serviços"
    echo "# Host: $(hostname -f 2>/dev/null || hostname)"
    echo "# Data: $(date -Is)"
    echo

    echo "## Serviços em execução"
    systemctl list-units --type=service --state=running --no-pager
    echo

    echo "## Serviços habilitados"
    systemctl list-unit-files --type=service --state=enabled --no-pager
    echo

    echo "## Todos os unit files de serviço (para análise)"
    systemctl list-unit-files --type=service --no-pager
} > "$SERVICES_REPORT"

echo "[4/5] Gerando relatório de serviços customizados: $CUSTOM_SERVICES_REPORT"
{
    echo "# Serviços customizados/relevantes para documentação"
    echo "# Host: $(hostname -f 2>/dev/null || hostname)"
    echo "# Data: $(date -Is)"
    echo
    echo "## Serviços enabled cujo unit file está em /etc/systemd/system"

    while read -r unit _state; do
        [[ -z "${unit:-}" ]] && continue
        fragment_path="$(systemctl show -p FragmentPath --value "$unit" 2>/dev/null || true)"
        if [[ "$fragment_path" == /etc/systemd/system/* ]]; then
            echo "$unit | $fragment_path"
        fi
    done < <(systemctl list-unit-files --type=service --state=enabled --no-legend --no-pager)

    echo
    echo "## Observações"
    echo "- Estes serviços tendem a conter customizações locais e devem ser priorizados na documentação."
    echo "- Revise também serviços de terceiros em execução (docker, webmin/usermin, openvpn, jupyterhub etc.)."
} > "$CUSTOM_SERVICES_REPORT"

echo "[5/5] Gerando script de reprodução de montagens: $REPLAY_SCRIPT"
cat > "$REPLAY_SCRIPT" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
    echo "ERRO: execute como root (sudo)."
    exit 1
fi

echo "Reaplicando pontos de montagem a partir das entradas ativas de /etc/fstab..."

# Cria diretórios de montagem de entradas UUID/LABEL com path absoluto.
while read -r src mnt fstype opts dump pass; do
    [[ -z "${src:-}" || -z "${mnt:-}" ]] && continue

    if [[ "$src" =~ ^UUID=|^LABEL= ]] && [[ "$mnt" == /* ]]; then
        mkdir -p "$mnt"
    fi
done < <(grep -Ev '^\s*#|^\s*$' /etc/fstab)

mount -a
echo "Montagens reaplicadas com sucesso ✅"
EOF

chmod +x "$REPLAY_SCRIPT"

echo "[6/6] Coletando dados do sistema e gerando $SYSTEM_REPORT"

# Coletar dados
systemd-analyze blame > "$SYSTEMD_BLAME" 2>&1 || true
systemd-analyze critical-chain > "$SYSTEMD_CRITICAL" 2>&1 || true
lscpu > "$LSCPU_REPORT" 2>&1 || true
lsblk > "$LSBLK_REPORT" 2>&1 || true
free -h > "$FREE_REPORT" 2>&1 || true
ip addr > "$IPADDR_REPORT" 2>&1 || true

# Extrair informações
HOSTNAME="$(hostname -f 2>/dev/null || hostname)"
KERNEL="$(uname -r)"
OS_PRETTY="$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo 'Unknown')"
CPU_MODEL="$(grep '^Nome do modelo:' "$LSCPU_REPORT" 2>/dev/null | cut -d':' -f2- | xargs || echo 'Unknown')"
CPU_REAL_CORES="$(grep '^Núcleo(s) por soquete:' "$LSCPU_REPORT" 2>/dev/null | awk '{print $NF}' || echo 1)"
CPU_THREADS_TOTAL="$(grep '^CPU(s):' "$LSCPU_REPORT" 2>/dev/null | awk '{print $NF}' || echo 1)"
CPU_MAX_MHZ_RAW="$(grep '^CPU MHz máx.:' "$LSCPU_REPORT" 2>/dev/null | awk '{printf "%.1f", $NF/1000}' || echo 'Unknown')"
CPU_MAX_MHZ="${CPU_MAX_MHZ_RAW} GHz"
MEM_TOTAL="$(grep '^Mem\.:' "$FREE_REPORT" 2>/dev/null | awk '{print $2}' || echo 'Unknown')"
MEM_USED="$(grep '^Mem\.:' "$FREE_REPORT" 2>/dev/null | awk '{print $3}' || echo 'Unknown')"
MEM_AVAIL="$(grep '^Mem\.:' "$FREE_REPORT" 2>/dev/null | awk '{print $NF}' || echo 'Unknown')"

# Extrair discos (removendo pipes e loops)
DISK_INFO="$(grep -E '^\s*sd[a-z]\s' "$LSBLK_REPORT" 2>/dev/null | head -5 | awk '{print $1 " (" $4 ")"}' | paste -sd, - || echo 'Unknown')"

# Extrair IPs ativos
IP_ADDRESSES="$(grep -A1 'inet ' "$IPADDR_REPORT" 2>/dev/null | grep 'inet ' | awk '{print $2}' | grep -v '^127' | paste -sd, - || echo 'Unknown')"

# Top serviços lentos (primeiro)
SLOW_SERVICES="$(head -3 "$SYSTEMD_BLAME" 2>/dev/null | awk '{print $2, "(" $1 ")"}' | paste -sd'  ' - || echo 'Unknown')"

# Gerar relatório Markdown
cat > "$SYSTEM_REPORT" <<MDEOF
# Relatório do Sistema - Host $HOSTNAME

**Data do Relatório**: $(date '+%d de %B de %Y')  
**Host**: $HOSTNAME  
**Sistema Operacional**: $OS_PRETTY  
**Kernel**: $KERNEL

---

## 📋 Sumário Executivo

| Categoria | Destaque |
|-----------|----------|
| **CPU** | $CPU_MODEL ($CPU_REAL_CORES núcleos / $CPU_THREADS_TOTAL threads @ $CPU_MAX_MHZ) |
| **Memória RAM** | $MEM_TOTAL total / $MEM_AVAIL disponível ($MEM_USED em uso) |
| **Armazenamento** | $DISK_INFO |
| **Redes** | $IP_ADDRESSES |
| **Serviços Lentos** | $SLOW_SERVICES |

---

## 🖥️ HARDWARE & SISTEMA

### Processador
- **Modelo**: $CPU_MODEL
- **Núcleos/Threads**: $CPU_REAL_CORES núcleos / $CPU_THREADS_TOTAL threads
- **Freq. Máxima**: $CPU_MAX_MHZ

📄 Detalhes completos: [reports/lscpu_${TS}.txt](reports/lscpu_${TS}.txt)

### Memória RAM
- **Total**: $MEM_TOTAL
- **Usada**: $MEM_USED
- **Disponível**: $MEM_AVAIL

📄 Detalhes: [reports/free_${TS}.txt](reports/free_${TS}.txt)

### Armazenamento (Discos)

📄 Detalhes: [reports/lsblk_${TS}.txt](reports/lsblk_${TS}.txt)

---

## 🌐 REDE

**IPs Ativos**: $IP_ADDRESSES

📄 Configuração completa: [reports/ip_addr_${TS}.txt](reports/ip_addr_${TS}.txt)

---

## ⚡ PERFORMANCE & BOOT

📄 Análise de boot:
- Serviços mais lentos: [reports/systemd_blame_${TS}.txt](reports/systemd_blame_${TS}.txt)
- Cadeia crítica: [reports/systemd_critical_${TS}.txt](reports/systemd_critical_${TS}.txt)

---

## 📝 Arquivos de Dados Disponíveis

### Relatórios Gerados
- 📄 **CPU Info**: [lscpu_${TS}.txt](reports/lscpu_${TS}.txt)
- 📄 **Memória**: [free_${TS}.txt](reports/free_${TS}.txt)
- 📄 **Discos**: [lsblk_${TS}.txt](reports/lsblk_${TS}.txt)
- 📄 **Rede**: [ip_addr_${TS}.txt](reports/ip_addr_${TS}.txt)
- 📄 **Systemd Boot Analysis**:
  - [systemd_blame_${TS}.txt](reports/systemd_blame_${TS}.txt)
  - [systemd_critical_${TS}.txt](reports/systemd_critical_${TS}.txt)

---

**Gerado em**: $(date '+%d de maio de %Y às %H:%M:%S')  
**Tipo de Relatório**: System Baseline Report  
**Status**: ✅ Completo
MDEOF

echo "✅ Relatório $SYSTEM_REPORT criado com sucesso"

echo
echo "Concluído ✅"
echo "Arquivos gerados em: $OUT_DIR"
echo "Relatório consolidado: $SYSTEM_REPORT"
