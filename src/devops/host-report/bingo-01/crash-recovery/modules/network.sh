#!/usr/bin/env bash
# modules/network.sh — interfaces, rotas, DNS, MACs, drivers, OpenVPN, NFS

run_network() {
    log INFO "[network] coletando configuração de rede"
    local d="${OUT_DIR}/network"

    run_cmd "${d}/ip-addr.txt"        ip addr
    run_cmd "${d}/ip-route.txt"       ip route
    run_cmd "${d}/ip-rule.txt"        ip rule
    run_cmd "${d}/ip-link.txt"        ip -d link
    run_cmd "${d}/ss.txt"             ss -tulpn
    run_cmd "${d}/nmcli-dev.txt"      nmcli device status
    run_cmd "${d}/nmcli-conn.txt"     nmcli connection show
    run_cmd "${d}/resolvectl.txt"     resolvectl status
    run_cmd "${d}/iptables.txt"       iptables -L -n -v
    run_cmd "${d}/ip6tables.txt"      ip6tables -L -n -v

    # ethtool por interface
    local iface
    while read -r iface _; do
        [[ "$iface" == lo ]] && continue
        [[ -z "$iface" ]]    && continue
        run_cmd "${d}/ethtool-${iface}.txt"         ethtool "$iface"
        run_cmd "${d}/ethtool-offload-${iface}.txt" ethtool -k "$iface"
        run_cmd "${d}/ethtool-driver-${iface}.txt"  ethtool -i "$iface"
    done < <(ip -br link | awk '{print $1}' | sed 's/@.*//')

    # MACs resumo
    {
        report_header "MAC Addresses"
        ip -br link | awk '{printf "%-20s %s\n", $1, $3}'
    } > "${d}/mac-summary.txt"

    # configs netplan / network-scripts
    copy_if_exists /etc/netplan          "${d}/netplan"
    copy_if_exists /etc/network/interfaces "${d}/interfaces"
    copy_if_exists /etc/resolv.conf      "${d}/resolv.conf"

    # OpenVPN configs (sem chaves privadas embutidas — apenas .conf)
    if [[ -d /etc/openvpn ]]; then
        find /etc/openvpn -name "*.conf" -exec cp -a {} "${d}/" \; 2>/dev/null || true
    fi

    log INFO "[network] concluído → ${d}/"
}
