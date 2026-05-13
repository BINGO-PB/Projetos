#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
source "${SCRIPT_DIR}/../backup-system/scripts/backup-common.sh"

ENV_FILE="${ENV_FILE:-${PROJECT_ROOT}/.env}"
DUPLICATI_RUNNER="${DUPLICATI_RUNNER:-local}"
DUPLICATI_CLI_BIN="${DUPLICATI_CLI_BIN:-duplicati-cli}"
DUPLICATI_IMAGE="${DUPLICATI_IMAGE:-duplicati/duplicati:latest}"
DUPLICATI_DEST_BASE="${DUPLICATI_DEST_BASE:-${BACKUP_ROOT}/monthly/duplicati}"
DUPLICATI_DB_BASE="${DUPLICATI_DB_BASE:-${BACKUP_SYSTEM_ROOT}/config/duplicati/db}"
DUPLICATI_DB_BASE_LOCAL="${DUPLICATI_DB_BASE_LOCAL:-${BACKUP_SYSTEM_ROOT}/config/duplicati/db-local}"
DUPLICATI_RETENTION_POLICY="${DUPLICATI_RETENTION_POLICY:-1M:3}"

while (($#)); do
    case "$1" in
        --apply)
            DRY_RUN=0
            ;;
        --dry-run)
            DRY_RUN=1
            ;;
        --env-file)
            ENV_FILE="$2"
            shift
            ;;
        --runner)
            DUPLICATI_RUNNER="$2"
            shift
            ;;
        --cli-bin)
            DUPLICATI_CLI_BIN="$2"
            shift
            ;;
        --dest-base)
            DUPLICATI_DEST_BASE="$2"
            shift
            ;;
        --db-base)
            DUPLICATI_DB_BASE="$2"
            shift
            ;;
        --db-base-local)
            DUPLICATI_DB_BASE_LOCAL="$2"
            shift
            ;;
        --retention)
            DUPLICATI_RETENTION_POLICY="$2"
            shift
            ;;
        *)
            fatal "argumento desconhecido: $1"
            ;;
    esac
    shift
 done

setup_logging "${0##*/}"
require_cmd find
require_cmd sort

if [[ -f "$ENV_FILE" ]]; then
    set -a
    source "$ENV_FILE"
    set +a
fi

: "${DUPLICATI_ENCRYPTION_PASSPHRASE:=}"
[[ -n "$DUPLICATI_ENCRYPTION_PASSPHRASE" && "$DUPLICATI_ENCRYPTION_PASSPHRASE" != "CHANGE_ME_STRONG_PASSPHRASE" ]] \
    || fatal "defina DUPLICATI_ENCRYPTION_PASSPHRASE em ${ENV_FILE}"

case "$DUPLICATI_RUNNER" in
    local)
        require_cmd "$DUPLICATI_CLI_BIN"
        ;;
    docker)
        require_cmd docker
        ;;
    *)
        fatal "runner inválido: ${DUPLICATI_RUNNER} (use: local|docker)"
        ;;
esac

ensure_dir "$DUPLICATI_DEST_BASE"
if [[ "$DUPLICATI_RUNNER" == "local" && "$EUID" -ne 0 ]]; then
    ensure_dir "$DUPLICATI_DB_BASE_LOCAL"
else
    ensure_dir "$DUPLICATI_DB_BASE"
fi

run_scope_backup() {
    local scope_name="$1"
    shift

    local -a scope_sources=("$@")
    if [[ ${#scope_sources[@]} -eq 0 ]]; then
        log_warn "${scope_name}: nenhum source encontrado, pulando"
        return 0
    fi

    local repo_dir="${DUPLICATI_DEST_BASE}/${scope_name}"
    local db_base="$DUPLICATI_DB_BASE"
    if [[ "$DUPLICATI_RUNNER" == "local" && "$EUID" -ne 0 ]]; then
        db_base="$DUPLICATI_DB_BASE_LOCAL"
    fi
    local db_dir="${db_base}/${scope_name}"
    ensure_dir "$repo_dir"
    ensure_dir "$db_dir"

    local idx=0
    local -a resolved_sources=()
    for src in "${scope_sources[@]}"; do
        if [[ -d "$src" || -L "$src" ]]; then
            resolved_sources+=("$src")
            idx=$((idx + 1))
        fi
    done

    if [[ "$idx" -eq 0 ]]; then
        log_warn "${scope_name}: nenhum source acessível, pulando"
        return 0
    fi

    local -a common_opts=(
        "--dbpath=${db_dir}/duplicati.sqlite"
        "--encryption-module=aes"
        "--passphrase=${DUPLICATI_ENCRYPTION_PASSPHRASE}"
        "--compression-module=zip"
        "--retention-policy=${DUPLICATI_RETENTION_POLICY}"
        "--disable-module=console-password-input"
    )

    if [[ "$DRY_RUN" == "1" ]]; then
        common_opts+=("--dry-run")
    fi

    local -a cmd=()
    case "$DUPLICATI_RUNNER" in
        local)
            cmd=(
                "$DUPLICATI_CLI_BIN" backup "file://${repo_dir}"
                "${resolved_sources[@]}"
                "${common_opts[@]}"
            )
            ;;
        docker)
            cmd=(
                docker run --rm
                -v "${repo_dir}:/repo"
                -v "${db_dir}:/db"
            )

            local j=0
            while [[ "$j" -lt "$idx" ]]; do
                cmd+=( -v "${resolved_sources[$j]}:/src-${j}:ro" )
                j=$((j + 1))
            done

            cmd+=("${DUPLICATI_IMAGE}" duplicati-cli backup "file:///repo")

            j=0
            while [[ "$j" -lt "$idx" ]]; do
                cmd+=("/src-${j}")
                j=$((j + 1))
            done

            cmd+=(
                "--dbpath=/db/duplicati.sqlite"
                "${common_opts[@]:1}"
            )
            ;;
    esac

    log_info "duplicati ${scope_name}: ${idx} source(s) -> ${repo_dir} (runner=${DUPLICATI_RUNNER})"
    "${cmd[@]}"
    log_info "duplicati ${scope_name}: finalizado"
}

mapfile -t home_currents < <(find "${BACKUP_ROOT}/home" -mindepth 2 -maxdepth 2 -type l -name current -print | sort)
mapfile -t jhub_currents < <(find "${BACKUP_ROOT}/jupyterhub/home" -mindepth 2 -maxdepth 2 -type l -name current -print | sort)

share_current="${BACKUP_ROOT}/share/code/current"
data_current="${BACKUP_ROOT}/data/current"

run_scope_backup "home" "${home_currents[@]}"
[[ -d "$share_current" || -L "$share_current" ]] && run_scope_backup "share-code" "$share_current" || log_warn "share-code: current ausente"
[[ -d "$data_current" || -L "$data_current" ]] && run_scope_backup "data" "$data_current" || log_warn "data: current ausente"
run_scope_backup "jupyterhub" "${jhub_currents[@]}"

log_info "backup mensal Duplicati concluído"
