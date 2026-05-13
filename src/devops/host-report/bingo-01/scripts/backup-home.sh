#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../backup-system/scripts/backup-common.sh"

GROUP_NAME="${GROUP_NAME:-bingopb}"
SOURCE_DIR="${SOURCE_DIR:-/home}"
DEST_DIR="${DEST_DIR:-${BACKUP_ROOT}/home}"
STANDARD_EXCLUDES="${STANDARD_EXCLUDES:-${BACKUP_SYSTEM_ROOT}/excludes/home.default}"

while (($#)); do
    case "$1" in
        --apply)
            DRY_RUN=0
            ;;
        --dry-run)
            DRY_RUN=1
            ;;
        --group)
            GROUP_NAME="$2"
            shift
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
require_cmd getent
require_cmd find
require_cmd sort
require_cmd readlink
require_cmd ln

[[ -f "$STANDARD_EXCLUDES" ]] || fatal "arquivo de exclusões ausente: $STANDARD_EXCLUDES"
ensure_dir "$DEST_DIR"

mapfile -t group_users < <(getent group "$GROUP_NAME" | awk -F: '{print $4}' | tr ',' '\n' | sed '/^$/d' | sort -u)

if [[ ${#group_users[@]} -eq 0 ]]; then
    log_warn "nenhum usuário encontrado no grupo ${GROUP_NAME}"
    exit 0
fi

for user in "${group_users[@]}"; do
    home_dir="$(user_home_from_passwd "$user")"
    shell_path="$(user_shell_from_passwd "$user")"

    if [[ ! -d "$home_dir" ]]; then
        log_warn "pulando ${user}: home inexistente (${home_dir})"
        continue
    fi

    if ! is_valid_login_shell "$shell_path"; then
        log_warn "pulando ${user}: shell inválido (${shell_path})"
        continue
    fi

    if [[ ! -r "$home_dir" || ! -x "$home_dir" ]]; then
        log_warn "pulando ${user}: home sem acesso de leitura/execução (${home_dir})"
        continue
    fi

    user_dest_root="${DEST_DIR}/${user}"
    ensure_dir "$user_dest_root"
    ensure_dir "${user_dest_root}/monthly"

    snapshot_dest="${user_dest_root}/${DATE_TAG}"
    link_dest="$(current_snapshot_path "$user_dest_root")"
    user_excludes_file="$(mktemp "${TMP_DIR}/home-excludes-${user}-XXXXXX")"
    trap 'rm -f "$user_excludes_file"' EXIT

    cp "$STANDARD_EXCLUDES" "$user_excludes_file"
    if [[ -f "${home_dir}/.config/no-backups" ]]; then
        cat "${home_dir}/.config/no-backups" >> "$user_excludes_file"
    fi

    log_info "backup home para ${user}: ${home_dir} -> ${snapshot_dest}"
    run_rsync_snapshot "$home_dir" "$snapshot_dest" "$link_dest" --exclude-from="$user_excludes_file"
    update_current_symlink "$user_dest_root" "$DATE_TAG"
    rm -f "$user_excludes_file"
    trap - EXIT
    log_info "finalizado ${user}"
done
