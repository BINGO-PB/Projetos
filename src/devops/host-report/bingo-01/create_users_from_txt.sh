#!/usr/bin/env bash

set -euo pipefail

#
# Cria usuários a partir de um TXT (um usuário por linha),
# coloca todos no grupo bingopb e garante usuário de serviço 'bingo' com nologin.
#
# Formato do arquivo:
# - Linhas vazias e iniciadas com # são ignoradas
# - Cada linha válida: nomeusuario
#

GROUP_NAME="bingopb"
SERVICE_USER="bingo"
USERS_FILE=""

usage() {
    cat <<EOF
Uso: $0 --file <usuarios.txt>

Opções:
  --file <arquivo>   Arquivo TXT com usuários (um por linha)
  --help             Mostra ajuda
EOF
}

require_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        echo "ERRO: execute como root (sudo)."
        exit 1
    fi
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --file)
                USERS_FILE="$2"
                shift 2
                ;;
            --help)
                usage
                exit 0
                ;;
            *)
                echo "Argumento desconhecido: $1"
                usage
                exit 1
                ;;
        esac
    done

    if [[ -z "$USERS_FILE" ]]; then
        echo "ERRO: informe --file <usuarios.txt>."
        usage
        exit 1
    fi

    if [[ ! -f "$USERS_FILE" ]]; then
        echo "ERRO: arquivo '$USERS_FILE' não encontrado."
        exit 1
    fi
}

ensure_group() {
    if ! getent group "$GROUP_NAME" >/dev/null; then
        groupadd "$GROUP_NAME"
        echo "Grupo '$GROUP_NAME' criado."
    else
        echo "Grupo '$GROUP_NAME' já existe."
    fi
}

ensure_service_user() {
    if ! id "$SERVICE_USER" >/dev/null 2>&1; then
        useradd -m -s /usr/sbin/nologin -g "$GROUP_NAME" "$SERVICE_USER"
        passwd -l "$SERVICE_USER" >/dev/null 2>&1 || true
        echo "Usuário de serviço '$SERVICE_USER' criado (nologin)."
    else
        usermod -g "$GROUP_NAME" "$SERVICE_USER"
        usermod -s /usr/sbin/nologin "$SERVICE_USER"
        passwd -l "$SERVICE_USER" >/dev/null 2>&1 || true
        echo "Usuário de serviço '$SERVICE_USER' atualizado (nologin)."
    fi
}

create_or_update_user() {
    local username="$1"

    if ! [[ "$username" =~ ^[a-z_][a-z0-9_-]*[$]?$ ]]; then
        echo "Aviso: usuário inválido '$username' (ignorado)."
        return
    fi

    if id "$username" >/dev/null 2>&1; then
        usermod -aG "$GROUP_NAME" "$username"
        echo "Usuário '$username' já existia; adicionado ao grupo '$GROUP_NAME'."
    else
        useradd -m -s /bin/bash -G "$GROUP_NAME" "$username"
        passwd -e "$username" >/dev/null 2>&1 || true
        echo "Usuário '$username' criado e incluído em '$GROUP_NAME'."
    fi
}

process_users_file() {
    while IFS= read -r line || [[ -n "$line" ]]; do
        line="${line%%#*}"
        line="$(echo "$line" | xargs)"

        if [[ -z "$line" ]]; then
            continue
        fi

        create_or_update_user "$line"
    done < "$USERS_FILE"
}

main() {
    require_root
    parse_args "$@"
    ensure_group
    ensure_service_user
    process_users_file
    echo "Concluído ✅"
}

main "$@"
