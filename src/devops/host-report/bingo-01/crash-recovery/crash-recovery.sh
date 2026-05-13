#!/usr/bin/env bash
# =============================================================================
# crash-recovery.sh — Ferramenta de disaster recovery e auditoria do bingo-01
#
# Uso:
#   bash crash-recovery.sh [--out-dir <dir>] [--no-snapshot] [--no-archive]
#                          [--only <modulo,...>] [--skip <modulo,...>]
#                          [--clean-old] [--keep-last <N>]
#
# Módulos disponíveis: system network storage docker services tuning
#                      recovery backup snapshots checksums markdown
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------
OUT_BASE="${SCRIPT_DIR}/output"
ARCHIVE_DIR="${SCRIPT_DIR}/archive"
DO_SNAPSHOT=1
DO_ARCHIVE=1
ONLY_MODULES=""
SKIP_MODULES=""
CLEAN_OLD=0
KEEP_LAST=3

# ---------------------------------------------------------------------------
# Parsear argumentos
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --out-dir)   OUT_BASE="$2";      shift 2 ;;
        --no-snapshot) DO_SNAPSHOT=0;    shift ;;
        --no-archive)  DO_ARCHIVE=0;     shift ;;
        --only)      ONLY_MODULES="$2";  shift 2 ;;
        --skip)      SKIP_MODULES="$2";  shift 2 ;;
        --clean-old) CLEAN_OLD=1;         shift ;;
        --keep-last) KEEP_LAST="$2";     shift 2 ;;
        *)  echo "Opção desconhecida: $1" >&2; exit 1 ;;
    esac
done

if ! [[ "$KEEP_LAST" =~ ^[0-9]+$ ]]; then
    echo "Valor inválido para --keep-last: ${KEEP_LAST}" >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# Timestamp e diretórios de saída
# ---------------------------------------------------------------------------
TS="$(date +%Y-%m-%d_%H%M%S)"
DATE_TAG="$(date +%Y-%m-%d)"
OUT_DIR="${OUT_BASE}/${DATE_TAG}/${TS}"
LOG_FILE="${OUT_DIR}/crash-recovery.log"

mkdir -p \
    "${OUT_DIR}/hardware" \
    "${OUT_DIR}/network" \
    "${OUT_DIR}/storage" \
    "${OUT_DIR}/docker" \
    "${OUT_DIR}/services" \
    "${OUT_DIR}/tuning" \
    "${OUT_DIR}/recovery" \
    "${OUT_DIR}/backups" \
    "${OUT_DIR}/snapshots" \
    "${OUT_DIR}/manifests" \
    "${OUT_DIR}/configs" \
    "${OUT_DIR}/markdown" \
    "${ARCHIVE_DIR}"

# Redirecionar stdout+stderr para log (sem suprimir terminal)
exec > >(tee -a "$LOG_FILE") 2>&1

# ---------------------------------------------------------------------------
# Carregar módulos
# ---------------------------------------------------------------------------
for _mod in "${SCRIPT_DIR}/modules/"*.sh; do
    # shellcheck source=/dev/null
    source "$_mod"
done

# ---------------------------------------------------------------------------
# Utilitário de seleção de módulos
# ---------------------------------------------------------------------------
should_run() {
    local name="$1"
    if [[ -n "$ONLY_MODULES" ]]; then
        [[ ",$ONLY_MODULES," == *",${name},"* ]] && return 0 || return 1
    fi
    if [[ -n "$SKIP_MODULES" ]]; then
        [[ ",$SKIP_MODULES," == *",${name},"* ]] && return 1 || return 0
    fi
    return 0
}

cleanup_old_runs() {
    local day_dir="${OUT_BASE}/${DATE_TAG}"
    [[ -d "$day_dir" ]] || return 0

    mapfile -t run_dirs < <(
        find "$day_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | \
            grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{6}$' | sort -r
    )

    local total="${#run_dirs[@]}"
    if (( total <= KEEP_LAST )); then
        log INFO "clean-old: nada a remover (runs=${total}, keep-last=${KEEP_LAST})"
        return 0
    fi

    local i dir full
    for (( i=KEEP_LAST; i<total; i++ )); do
        dir="${run_dirs[$i]}"
        full="${day_dir}/${dir}"

        # nunca remove o run atual
        [[ "$full" == "$OUT_DIR" ]] && continue
        log INFO "clean-old: removendo run antigo ${full}"
        rm -rf -- "$full"
    done
}

# ---------------------------------------------------------------------------
# Orquestração
# ---------------------------------------------------------------------------
log INFO "================================================================="
log INFO "crash-recovery iniciado — host=$(hostname) ts=${TS}"
log INFO "OUT_DIR=${OUT_DIR}"
log INFO "================================================================="

should_run system    && run_system
should_run network   && run_network
should_run storage   && run_storage
should_run docker    && run_docker
should_run services  && run_services
should_run tuning    && run_tuning
should_run recovery  && run_recovery
should_run backup    && run_backup
should_run snapshots && [[ "$DO_SNAPSHOT" -eq 1 ]] && run_snapshots
should_run checksums && run_checksums
should_run markdown  && run_markdown

if [[ "$CLEAN_OLD" -eq 1 ]]; then
    cleanup_old_runs
fi

# ---------------------------------------------------------------------------
# Arquivar saída compactada
# ---------------------------------------------------------------------------
if [[ "$DO_ARCHIVE" -eq 1 ]]; then
    ARCHIVE_FILE="${ARCHIVE_DIR}/bingo01-recovery-${DATE_TAG}.tgz"
    log INFO "Arquivando: ${ARCHIVE_FILE}"
    tar -czf "$ARCHIVE_FILE" -C "${OUT_DIR}" . 2>/dev/null || \
        log WARN "Falha ao arquivar (continuando)"
fi

log INFO "================================================================="
log INFO "crash-recovery concluído ✅"
log INFO "Relatórios: ${OUT_DIR}"
log INFO "Markdown:   ${OUT_DIR}/markdown/executive-summary.md"
[[ "$DO_ARCHIVE" -eq 1 ]] && log INFO "Arquivo:    ${ARCHIVE_DIR}/bingo01-recovery-${DATE_TAG}.tgz"
log INFO "================================================================="
