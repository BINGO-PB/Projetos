#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export BACKUP_ROOT="${BACKUP_ROOT:-${SCRIPT_DIR}/../.backup-target}"
export BACKUP_SYSTEM_ROOT="${BACKUP_SYSTEM_ROOT:-${SCRIPT_DIR}/../backup-system}"

"${SCRIPT_DIR}/backup-home.sh" --dry-run
"${SCRIPT_DIR}/backup-share-code.sh" --dry-run
"${SCRIPT_DIR}/backup-data.sh" --dry-run
"${SCRIPT_DIR}/backup-jupyterhub.sh" --dry-run
