#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SYSTEMD_SRC="${PROJECT_ROOT}/systemd"
SYSTEMD_DST="/etc/systemd/system"

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    exec sudo --preserve-env=SYSTEMD_SRC,SYSTEMD_DST "$0" "$@"
fi

for unit in "${SYSTEMD_SRC}"/*.{service,timer}; do
    [[ -e "$unit" ]] || continue
    install -m 0644 "$unit" "${SYSTEMD_DST}/$(basename "$unit")"
done

systemctl daemon-reload
systemctl enable --now \
    backup-home.timer \
    backup-share-code.timer \
    backup-data.timer \
    backup-jupyterhub.timer \
    backup-duplicati-monthly.timer

echo "Units instaladas em ${SYSTEMD_DST} e timers ativados."
