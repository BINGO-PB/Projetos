#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../backup-system/scripts/backup-common.sh"

while (($#)); do
    case "$1" in
        --apply)
            DRY_RUN=0
            ;;
        --dry-run)
            DRY_RUN=1
            ;;
        *)
            fatal "argumento desconhecido: $1"
            ;;
    esac
    shift
 done

if [[ "$DRY_RUN" == "1" && -z "${BACKUP_ROOT_OVERRIDE:-}" ]]; then
    BACKUP_ROOT="${SCRIPT_DIR}/../.backup-target"
fi

export BACKUP_ROOT BACKUP_SYSTEM_ROOT DRY_RUN
mkdir -p "$BACKUP_ROOT"
setup_logging "${0##*/}"

log_info "executando suíte completa de backup"
"${SCRIPT_DIR}/backup-home.sh"
"${SCRIPT_DIR}/backup-share-code.sh"
"${SCRIPT_DIR}/backup-data.sh"
"${SCRIPT_DIR}/backup-jupyterhub.sh"
"${SCRIPT_DIR}/generate-manifests.sh"
"${SCRIPT_DIR}/backup-report.sh"
log_info "suíte completa finalizada"
