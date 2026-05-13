#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../backup-system/scripts/backup-common.sh"

SOURCE_DIR="${SOURCE_DIR:-/data}"
DEST_DIR="${DEST_DIR:-${BACKUP_ROOT}/data}"
STANDARD_EXCLUDES="${STANDARD_EXCLUDES:-${BACKUP_SYSTEM_ROOT}/excludes/data.default}"

while (($#)); do
    case "$1" in
        --apply)
            DRY_RUN=0
            ;;
        --dry-run)
            DRY_RUN=1
            ;;
        --source-dir)
            SOURCE_DIR="$2"
            shift
            ;;
        --dest-dir)
            DEST_DIR="$2"
            shift
            ;;
        --standard-excludes)
            STANDARD_EXCLUDES="$2"
            shift
            ;;
        *)
            fatal "argumento desconhecido: $1"
            ;;
    esac
    shift
 done

setup_logging "${0##*/}"
require_cmd rsync
require_cmd readlink
require_cmd ln

if [[ ! -d "$SOURCE_DIR" ]]; then
    log_warn "pulando data: diretório de origem ausente (${SOURCE_DIR})"
    exit 0
fi
[[ -f "$STANDARD_EXCLUDES" ]] || fatal "arquivo de exclusões ausente: $STANDARD_EXCLUDES"
ensure_dir "$DEST_DIR"

snapshot_name="$DATE_TAG"
snapshot_dest="${DEST_DIR}/${snapshot_name}"
link_dest="$(current_snapshot_path "$DEST_DIR")"

log_info "backup data: ${SOURCE_DIR} -> ${snapshot_dest}"
run_rsync_snapshot "$SOURCE_DIR" "$snapshot_dest" "$link_dest" --exclude-from="$STANDARD_EXCLUDES"
update_current_symlink "$DEST_DIR" "$snapshot_name"
log_info "finalizado data"
