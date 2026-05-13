#!/usr/bin/env bash
# modules/backup.sh — timers de backup, espaço em disco, snapshots existentes

# Raiz do backup (ajustar se necessário)
BACKUP_ROOT_PATH="${BACKUP_ROOT:-/backup/bingo-01}"

run_backup() {
    log INFO "[backup] coletando estado do sistema de backup"
    local d="${OUT_DIR}/backups"

    # Timers de backup
    {
        report_header "Timers de backup"
        systemctl list-timers --all --no-pager 2>/dev/null | grep -i backup || \
            echo "(nenhum timer de backup encontrado)"
    } > "${d}/timers.txt"

    # Espaço em disco no destino de backup
    {
        report_header "Espaço em ${BACKUP_ROOT_PATH}"
        df -hT "${BACKUP_ROOT_PATH}" 2>/dev/null || echo "${BACKUP_ROOT_PATH} não montado"
        echo
        echo "## Subdiretórios"
        du -sh "${BACKUP_ROOT_PATH}"/*/ 2>/dev/null | sort -h || true
    } > "${d}/backup-space.txt"

    # Snapshots Duplicati existentes
    {
        report_header "Snapshots Duplicati"
        find "${BACKUP_ROOT_PATH}" -name "*.dlist.zip.aes" 2>/dev/null | sort | \
            awk -F/ '{print $(NF-1) ": " $NF}' | sort | uniq -c | sort -k2 || \
            echo "(nenhum snapshot encontrado)"
    } > "${d}/snapshots.txt"

    # Política de retenção (baseada nos scripts de backup)
    {
        report_header "Política de retenção (grep nos scripts)"
        grep -rh 'keep-versions\|retention\|keep-time' \
            "$(dirname "$(dirname "$SCRIPT_DIR")")/bingo-01/scripts/" \
            "$(dirname "$SCRIPT_DIR")/../../bingo-01/scripts/" \
            "${SCRIPT_DIR}/../scripts/" \
            2>/dev/null | sort -u || echo "(não encontrado)"
    } > "${d}/retention-policy.txt"

    # Logs de backup mais recentes
    local log_dir
    for log_dir in \
        "${BACKUP_ROOT_PATH}/logs" \
        "${SCRIPT_DIR}/../backup-system/logs" \
        "${SCRIPT_DIR}/../../bingo-01/backup-system/logs"
    do
        if [[ -d "$log_dir" ]]; then
            ls -lt "$log_dir"/*.txt 2>/dev/null | head -5 | while read -r _ _ _ _ _ _ _ _ logf; do
                cp -a "$logf" "${d}/" 2>/dev/null || true
            done
            break
        fi
    done

    # Status do serviço Duplicati
    {
        report_header "Status duplicati.service"
        systemctl status duplicati --no-pager 2>&1 || echo "(serviço não encontrado)"
    } > "${d}/duplicati-service.txt"

    log INFO "[backup] concluído → ${d}/"
}
