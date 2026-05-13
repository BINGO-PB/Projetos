#!/usr/bin/env bash
set -euo pipefail

: "${BACKUP_HOST:=bingo-01}"
: "${BACKUP_ROOT:=/backup/${BACKUP_HOST}}"

COMMON_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
: "${BACKUP_SYSTEM_ROOT:=${COMMON_ROOT}}"
: "${LOG_DIR:=${BACKUP_SYSTEM_ROOT}/logs}"
: "${TMP_DIR:=${BACKUP_SYSTEM_ROOT}/tmp}"
: "${DATE_TAG:=$(date +%F)}"
: "${TS_TAG:=$(date +%Y%m%d-%H%M%S)}"
: "${DRY_RUN:=1}"
: "${VERBOSE:=1}"

log_info() {
    printf '[%s] INFO: %s\n' "$(date -Is)" "$*"
}

log_warn() {
    printf '[%s] WARN: %s\n' "$(date -Is)" "$*" >&2
}

log_error() {
    printf '[%s] ERROR: %s\n' "$(date -Is)" "$*" >&2
}

fatal() {
    log_error "$*"
    exit 1
}

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || fatal "comando obrigatório ausente: $1"
}

ensure_dir() {
    mkdir -p "$1"
}

setup_logging() {
    local script_name="${1:-${0##*/}}"
    ensure_dir "$LOG_DIR"
    ensure_dir "$TMP_DIR"

    local log_file="${LOG_DIR}/${script_name%.sh}-${TS_TAG}.log"
    exec > >(tee -a "$log_file") 2>&1

    log_info "iniciando ${script_name}"
    log_info "BACKUP_ROOT=${BACKUP_ROOT} BACKUP_SYSTEM_ROOT=${BACKUP_SYSTEM_ROOT} DRY_RUN=${DRY_RUN} DATE_TAG=${DATE_TAG}"
}

is_valid_login_shell() {
    local shell_path="${1:-}"
    case "$shell_path" in
        ""|*/nologin|*/false)
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}

user_home_from_passwd() {
    local user="$1"
    getent passwd "$user" | awk -F: '{print $6}'
}

user_shell_from_passwd() {
    local user="$1"
    getent passwd "$user" | awk -F: '{print $7}'
}

current_snapshot_path() {
    local dest_root="$1"
    readlink -f "${dest_root}/current" 2>/dev/null || true
}

update_current_symlink() {
    local dest_root="$1"
    local snapshot_name="$2"
    ln -sfn "$snapshot_name" "${dest_root}/current"
}

build_tmp_exclude_file_from_markers() {
    local source_root="$1"
    local marker_name="$2"
    local output_file="$3"

    : > "$output_file"
    while IFS= read -r marker_dir; do
        [[ -n "$marker_dir" ]] || continue
        local rel_path="${marker_dir#${source_root}/}"
        [[ "$rel_path" == "$marker_dir" ]] && continue
        printf '%s/\n' "$rel_path" >> "$output_file"
    done < <(find "$source_root" -type f -name "$marker_name" -printf '%h\n' | sort -u)
}

run_rsync_snapshot() {
    local source_root="$1"
    local snapshot_dest="$2"
    local link_dest="${3:-}"
    shift 3 || true

    local -a rsync_args=(
        --archive
        --hard-links
        --numeric-ids
        --delete
        --delete-excluded
        --one-file-system
        --partial
        --human-readable
        --itemize-changes
        --info=stats2,progress2
    )

    if [[ "$DRY_RUN" == "1" ]]; then
        rsync_args+=(--dry-run)
    fi

    if [[ -n "$link_dest" && -d "$link_dest" ]]; then
        rsync_args+=(--link-dest="$link_dest")
    fi

    rsync_args+=("$@")
    rsync_args+=("${source_root%/}/" "${snapshot_dest%/}/")

    ensure_dir "$snapshot_dest"
    rsync "${rsync_args[@]}"
}
