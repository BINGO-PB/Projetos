#!/usr/bin/env bash
# modules/services.sh — systemd units, serviços críticos, JupyterHub, timer list

# Serviços críticos a inspecionar individualmente
CRITICAL_SERVICES=(
    jupyterhub
    anydesk
    webmin
    usermin
    docker
    ssh
    sshd
    nfs-server
    duplicati
    backup-home.timer
    backup-data.timer
    backup-jupyterhub.timer
    backup-share-code.timer
    backup-duplicati-monthly.timer
)

run_services() {
    log INFO "[services] coletando serviços systemd"
    local d="${OUT_DIR}/services"

    # Listagens gerais
    {
        report_header "Serviços em execução"
        systemctl list-units --type=service --state=running --no-pager
    } > "${d}/running.txt"

    {
        report_header "Serviços habilitados"
        systemctl list-unit-files --type=service --state=enabled --no-pager
    } > "${d}/enabled.txt"

    {
        report_header "Todos os unit files"
        systemctl list-unit-files --no-pager
    } > "${d}/all-unit-files.txt"

    {
        report_header "Timers ativos"
        systemctl list-timers --all --no-pager
    } > "${d}/timers.txt"

    {
        report_header "Serviços falhos"
        systemctl list-units --state=failed --no-pager
    } > "${d}/failed.txt"

    # Boot analysis
    systemd-analyze          > "${d}/boot-time.txt"    2>&1 || true
    systemd-analyze blame    > "${d}/boot-blame.txt"   2>&1 || true
    systemd-analyze critical-chain > "${d}/boot-critical.txt" 2>&1 || true

    # Exportar unit files customizados (/etc/systemd/system/)
    local unit fragment
    while read -r unit _state; do
        [[ -z "${unit:-}" ]] && continue
        fragment="$(systemctl show -p FragmentPath --value "$unit" 2>/dev/null || true)"
        if [[ "$fragment" == /etc/systemd/system/* ]]; then
            cp -a "$fragment" "${d}/" 2>/dev/null || true
        fi
    done < <(systemctl list-unit-files --no-legend --no-pager 2>/dev/null)

    # Inspecionar serviços críticos individualmente
    local svc
    for svc in "${CRITICAL_SERVICES[@]}"; do
        if systemctl list-unit-files "$svc" &>/dev/null 2>&1; then
            {
                echo "# systemctl status ${svc}"
                systemctl status "$svc" --no-pager 2>&1 || true
                echo
                echo "# systemctl cat ${svc}"
                systemctl cat "$svc" 2>/dev/null || true
            } > "${d}/detail-${svc/\//-}.txt"
        fi
    done

    # JupyterHub config
    copy_if_exists /etc/jupyterhub      "${d}/jupyterhub"
    copy_if_exists /opt/jupyterhub/etc  "${d}/jupyterhub-opt"

    log INFO "[services] concluído → ${d}/"
}
