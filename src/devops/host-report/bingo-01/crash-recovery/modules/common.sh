#!/usr/bin/env bash
# modules/common.sh — funções utilitárias compartilhadas
# Carregado automaticamente pelo crash-recovery.sh antes de qualquer módulo.

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
log() {
    local level="${1:-INFO}"
    shift
    printf '[%s] %s: %s\n' "$(date -Is)" "$level" "$*"
}

# ---------------------------------------------------------------------------
# Garantir que diretório exista
# ---------------------------------------------------------------------------
ensure_dir() { mkdir -p "$@"; }

# ---------------------------------------------------------------------------
# Executar comando opcionalmente (sem falhar se binário ausente)
# ---------------------------------------------------------------------------
run_cmd() {
    local out="$1"; shift
    if command -v "$1" &>/dev/null; then
        "$@" > "$out" 2>&1 || true
    else
        echo "# Comando não disponível: $1" > "$out"
    fi
}

# ---------------------------------------------------------------------------
# Copiar arquivo se existir
# ---------------------------------------------------------------------------
copy_if_exists() {
    local src="$1" dst="$2"
    if [[ -f "$src" ]]; then
        cp -a "$src" "$dst"
    elif [[ -d "$src" ]]; then
        cp -a "$src" "$dst"
    else
        echo "# $src — não encontrado" > "${dst}.missing"
    fi
}

# ---------------------------------------------------------------------------
# Cabeçalho padronizado para arquivos de relatório
# ---------------------------------------------------------------------------
report_header() {
    local title="$1"
    cat <<EOF
# ${title}
# Host:  $(hostname -f 2>/dev/null || hostname)
# Data:  $(date -Is)
# Gerado por: crash-recovery.sh
# ---------------------------------------------------------------

EOF
}

# ---------------------------------------------------------------------------
# sha256 de um arquivo (portável)
# ---------------------------------------------------------------------------
sha256_file() {
    sha256sum "$1" 2>/dev/null | awk '{print $1}'
}
