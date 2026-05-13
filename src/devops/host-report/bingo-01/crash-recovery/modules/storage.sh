#!/usr/bin/env bash
# modules/storage.sh — discos, partições, fstab, UUID validation, NFS, replay script

run_storage() {
    log INFO "[storage] coletando armazenamento"
    local d="${OUT_DIR}/storage"

    run_cmd "${d}/df.txt"             df -hT
    run_cmd "${d}/findmnt.txt"        findmnt -A
    run_cmd "${d}/lsblk-full.txt"     lsblk -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINTS,MODEL,SERIAL,STATE
    run_cmd "${d}/blkid.txt"          blkid
    run_cmd "${d}/pvs.txt"            pvs
    run_cmd "${d}/vgs.txt"            vgs
    run_cmd "${d}/lvs.txt"            lvs

    copy_if_exists /etc/fstab         "${d}/fstab.conf"

    # -----------------------------------------------------------------------
    # Validação de UUIDs no fstab
    # -----------------------------------------------------------------------
    {
        report_header "Validação de UUIDs em /etc/fstab"
        echo "## Entradas com UUID"
        local uuid line dev
        while read -r line; do
            [[ "$line" =~ ^# || -z "$line" ]] && continue
            dev="$(echo "$line" | awk '{print $1}')"
            if [[ "$dev" =~ ^UUID= ]]; then
                uuid="${dev#UUID=}"
                if blkid -U "$uuid" &>/dev/null; then
                    echo "OK      UUID=${uuid}"
                else
                    echo "MISSING UUID=${uuid} — dispositivo não encontrado!"
                fi
            fi
        done < /etc/fstab
        echo
        echo "## Montagens NFS ativas"
        findmnt -rno SOURCE,TARGET,FSTYPE | awk '$3 ~ /^nfs/ {print "NFS  " $1 " -> " $2}'
    } > "${d}/mount-validation.txt"

    # -----------------------------------------------------------------------
    # Script de reprodução de montagens (disaster recovery)
    # -----------------------------------------------------------------------
    cat > "${d}/replay-mounts.sh" <<'EOF'
#!/usr/bin/env bash
# Reproduz montagens do /etc/fstab — usar após reinstalação base
set -euo pipefail
[[ "$(id -u)" -ne 0 ]] && { echo "Execute como root."; exit 1; }

echo "Recriando pontos de montagem de /etc/fstab..."
while read -r src mnt fstype opts _dump _pass; do
    [[ -z "${src:-}" || -z "${mnt:-}" ]] && continue
    if [[ "$mnt" == /* && "$mnt" != "swap" ]]; then
        mkdir -p "$mnt"
    fi
done < <(grep -Ev '^\s*#|^\s*$' /etc/fstab)

mount -a && echo "✅ Montagens reaplicadas com sucesso"
EOF
    chmod +x "${d}/replay-mounts.sh"

    # Relatório de discos locais + NFS resumido
    {
        report_header "Resumo de Discos e Montagens"
        echo "## Montagens locais (/dev/sd*)"
        findmnt -rno SOURCE,TARGET,FSTYPE,OPTIONS | awk '$1 ~ /^\/dev\/sd/ {
            printf "  LOCAL  %-14s -> %-26s (%s)\n", $1, $2, $3
        }'
        echo
        echo "## Montagens NFS"
        findmnt -rno SOURCE,TARGET,FSTYPE,OPTIONS | awk '$3 ~ /^nfs/ {
            printf "  NFS    %-20s -> %-26s (%s)\n", $1, $2, $3
        }'
        echo
        echo "## df -hT (locais + NFS)"
        df -hT | awk 'NR==1 || $1 ~ /^\/dev\/sd/ || $2 ~ /^nfs/'
    } > "${d}/disk-summary.txt"

    log INFO "[storage] concluído → ${d}/"
}
