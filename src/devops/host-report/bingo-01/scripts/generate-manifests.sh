#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../backup-system/scripts/backup-common.sh"

OUTPUT_DIR="${OUTPUT_DIR:-${BACKUP_SYSTEM_ROOT}/manifests}"
TARGETS=(
    "${BACKUP_SYSTEM_ROOT}/scripts"
    "${BACKUP_SYSTEM_ROOT}/excludes"
    "${SCRIPT_DIR}"
)

setup_logging "${0##*/}"
require_cmd sha256sum
require_cmd find
require_cmd sort

ensure_dir "$OUTPUT_DIR"
manifest_file="${OUTPUT_DIR}/manifest-${TS_TAG}.sha256"
: > "$manifest_file"

for target in "${TARGETS[@]}"; do
    [[ -d "$target" ]] || continue
    find "$target" -type f \( -name '*.sh' -o -name '*.default' -o -name '*.conf' \) -print0 \
        | sort -z \
        | xargs -0 sha256sum >> "$manifest_file"
done

log_info "manifest gerado: ${manifest_file}"
