#!/usr/bin/env bash
# modules/checksums.sh — sha256 de todos os artefatos gerados

run_checksums() {
    log INFO "[checksums] calculando sha256 dos artefatos"
    local m="${OUT_DIR}/manifests"

    {
        report_header "SHA256 — artefatos gerados"
        find "${OUT_DIR}" \
            \( -name "*.tgz" -o -name "*.txt" -o -name "*.md" -o -name "*.json" -o -name "*.conf" \) \
            -not -path "*/manifests/sha256sums.txt" \
            -type f | sort | \
        while read -r f; do
            local rel
            rel="${f#${OUT_DIR}/}"
            printf "%-64s  %s\n" "$(sha256_file "$f")" "$rel"
        done
    } > "${m}/sha256sums.txt"

    log INFO "[checksums] concluído → ${m}/sha256sums.txt"
}
