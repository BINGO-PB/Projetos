#!/usr/bin/env bash

set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
    echo "ERRO: execute como root (sudo)."
    exit 1
fi

echo "Reaplicando pontos de montagem a partir das entradas ativas de /etc/fstab..."

# Cria diretórios de montagem de entradas UUID/LABEL com path absoluto.
while read -r src mnt fstype opts dump pass; do
    [[ -z "${src:-}" || -z "${mnt:-}" ]] && continue

    if [[ "$src" =~ ^UUID=|^LABEL= ]] && [[ "$mnt" == /* ]]; then
        mkdir -p "$mnt"
    fi
done < <(grep -Ev '^\s*#|^\s*$' /etc/fstab)

mount -a
echo "Montagens reaplicadas com sucesso ✅"
