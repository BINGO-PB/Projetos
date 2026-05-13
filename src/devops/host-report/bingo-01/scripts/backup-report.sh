#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../backup-system/scripts/backup-common.sh"

BACKUP_ROOT_OVERRIDE="${BACKUP_ROOT_OVERRIDE:-${BACKUP_ROOT}}"
REPORT_DIR="${REPORT_DIR:-${LOG_DIR}}"
REPORT_FILE="${REPORT_FILE:-${REPORT_DIR}/backup-report-${TS_TAG}.txt}"

while (($#)); do
    case "$1" in
        --backup-root)
            BACKUP_ROOT_OVERRIDE="$2"
            shift
            ;;
        --report-dir)
            REPORT_DIR="$2"
            shift
            ;;
        --report-file)
            REPORT_FILE="$2"
            shift
            ;;
        *)
            fatal "argumento desconhecido: $1"
            ;;
    esac
    shift
 done

setup_logging "${0##*/}"
require_cmd find
require_cmd du
require_cmd sort
require_cmd wc
require_cmd readlink

ensure_dir "$REPORT_DIR"

{
    echo "# Relatório de backup"
    echo ""
    echo "- Host: ${BACKUP_HOST}"
    echo "- Data: $(date -Is)"
    echo "- Backup root: ${BACKUP_ROOT_OVERRIDE}"
    echo "- Sistema: ${BACKUP_SYSTEM_ROOT}"
    echo "- Modo dry-run: ${DRY_RUN}"
    echo ""

    if [[ -d "$BACKUP_ROOT_OVERRIDE" ]]; then
        echo "## Uso em disco"
        du -sh "$BACKUP_ROOT_OVERRIDE" 2>/dev/null || true
        echo ""
    else
        echo "## Uso em disco"
        echo "Backup root ausente: ${BACKUP_ROOT_OVERRIDE}"
        echo ""
    fi

    echo "## Arquivos de log"
    if compgen -G "${LOG_DIR}/*.log" >/dev/null; then
        ls -1t "${LOG_DIR}"/*.log 2>/dev/null | head -10
    else
        echo "Nenhum log encontrado"
    fi
    echo ""

    echo "## Manifestos"
    if compgen -G "${BACKUP_SYSTEM_ROOT}/manifests/*.sha256" >/dev/null; then
        ls -1t "${BACKUP_SYSTEM_ROOT}/manifests"/*.sha256 2>/dev/null | head -10
    else
        echo "Nenhum manifesto encontrado"
    fi
    echo ""

    echo "## Resumo dos snapshots"
    for area in home share/code data jupyterhub/home; do
        area_root="${BACKUP_ROOT_OVERRIDE}/${area}"
        echo "### ${area}"
        if [[ ! -d "$area_root" ]]; then
            echo "- ausente"
            echo ""
            continue
        fi

        case "$area" in
            home)
                while IFS= read -r user_dir; do
                    [[ -n "$user_dir" ]] || continue
                    current_target="$(readlink -f "${user_dir}/current" 2>/dev/null || true)"
                    snapshot_count="$(find "$user_dir" -mindepth 1 -maxdepth 1 -type d ! -name monthly | wc -l | awk '{print $1}')"
                    printf -- '- %s: %s snapshots, current=%s\n' "$(basename "$user_dir")" "$snapshot_count" "${current_target:-sem current}"
                done < <(find "$area_root" -mindepth 1 -maxdepth 1 -type d | sort)
                ;;
            *)
                current_target="$(readlink -f "${area_root}/current" 2>/dev/null || true)"
                snapshot_count="$(find "$area_root" -mindepth 1 -maxdepth 1 -type d ! -name monthly | wc -l | awk '{print $1}')"
                printf -- '- snapshots: %s, current=%s\n' "$snapshot_count" "${current_target:-sem current}"
                ;;
        esac
        echo ""
    done
} | tee "$REPORT_FILE"

log_info "relatório gerado: ${REPORT_FILE}"
