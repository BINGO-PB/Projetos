#!/usr/bin/env bash
# modules/snapshots.sh — snapshot compactado de configurações críticas

# Diretórios incluídos no snapshot de configs
SNAPSHOT_DIRS=(
    /etc/netplan
    /etc/network
    /etc/systemd/system
    /etc/docker
    /etc/jupyterhub
    /etc/openvpn
    /etc/sysctl.d
    /etc/security/limits.d
    /etc/cron.d
    /etc/cron.daily
    /etc/cron.weekly
    /etc/cron.monthly
    /etc/fstab
    /etc/hostname
    /etc/hosts
    /etc/resolv.conf
    /etc/sudoers
    /etc/sudoers.d
    /usr/local/bin
)

run_snapshots() {
    log INFO "[snapshots] gerando snapshot de configurações"
    local d="${OUT_DIR}/snapshots"
    local snap_root="${d}/etc-snapshot"
    local snap_tgz="${d}/bingo01-configs-${DATE_TAG}.tgz"

    ensure_dir "$snap_root"

    local src
    for src in "${SNAPSHOT_DIRS[@]}"; do
        [[ -e "$src" ]] || continue
        # Recriar hierarquia dentro de snap_root
        local dst_dir
        dst_dir="${snap_root}$(dirname "$src")"
        mkdir -p "$dst_dir"
        cp -a "$src" "$dst_dir/" 2>/dev/null || \
            log WARN "[snapshots] não foi possível copiar: $src"
    done

    # Snapshot do diretório de scripts devops (se dentro de /home)
    local devops_dir
    devops_dir="$(cd "${SCRIPT_DIR}/../.." && pwd)"
    if [[ "$devops_dir" == /home/* ]]; then
        tar -czf "${d}/devops-scripts-${DATE_TAG}.tgz" \
            -C "$(dirname "$devops_dir")" \
            "$(basename "$devops_dir")" \
            --exclude="*/output/*" \
            --exclude="*/archive/*" \
            --exclude="*/.git/*" \
            2>/dev/null || log WARN "[snapshots] falha ao compactar devops"
    fi

    # Compactar snapshot de /etc
    tar -czf "$snap_tgz" -C "$snap_root" . 2>/dev/null && \
        log INFO "[snapshots] snapshot: $snap_tgz" || \
        log WARN "[snapshots] falha ao gerar snapshot compactado"

    # Limpar árvore temporária
    rm -rf "$snap_root"

    log INFO "[snapshots] concluído → ${d}/"
}
