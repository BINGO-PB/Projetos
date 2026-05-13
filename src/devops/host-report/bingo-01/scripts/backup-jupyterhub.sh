#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../backup-system/scripts/backup-common.sh"

SOURCE_DIR="${SOURCE_DIR:-/jupyterhub/home}"
DEST_DIR="${DEST_DIR:-${BACKUP_ROOT}/jupyterhub/home}"
STANDARD_EXCLUDES="${STANDARD_EXCLUDES:-${BACKUP_SYSTEM_ROOT}/excludes/jupyterhub.default}"

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
require_cmd find
require_cmd sort
require_cmd readlink
require_cmd ln
require_cmd mktemp

if [[ ! -d "$SOURCE_DIR" ]]; then
    log_warn "pulando jupyterhub: diretório de origem ausente (${SOURCE_DIR})"
    exit 0
fi
[[ -f "$STANDARD_EXCLUDES" ]] || fatal "arquivo de exclusões ausente: $STANDARD_EXCLUDES"
ensure_dir "$DEST_DIR"

mapfile -t hub_users < <(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

if [[ ${#hub_users[@]} -eq 0 ]]; then
    log_warn "nenhum diretório encontrado em ${SOURCE_DIR}"
    exit 0
fi

for user in "${hub_users[@]}"; do
    user_source="${SOURCE_DIR}/${user}"
    user_dest_root="${DEST_DIR}/${user}"
    ensure_dir "$user_dest_root"
    ensure_dir "${user_dest_root}/monthly"

    snapshot_dest="${user_dest_root}/${DATE_TAG}"
    link_dest="$(current_snapshot_path "$user_dest_root")"
    extra_excludes="$(mktemp "${TMP_DIR}/jupyterhub-excludes-${user}-XXXXXX")"
    trap 'rm -f "$extra_excludes"' EXIT

    cp "$STANDARD_EXCLUDES" "$extra_excludes"
    log_info "backup jupyterhub: ${user_source} -> ${snapshot_dest}"
    run_rsync_snapshot "$user_source" "$snapshot_dest" "$link_dest" --exclude-from="$extra_excludes"
    update_current_symlink "$user_dest_root" "$DATE_TAG"
    rm -f "$extra_excludes"
    trap - EXIT
    log_info "finalizado ${user}"
done
