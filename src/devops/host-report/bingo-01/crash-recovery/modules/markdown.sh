#!/usr/bin/env bash
# modules/markdown.sh — geração dos relatórios Markdown consolidados

run_markdown() {
    log INFO "[markdown] gerando relatórios Markdown"
    local md="${OUT_DIR}/markdown"

    # -----------------------------------------------------------------------
    # Helpers de leitura
    # -----------------------------------------------------------------------
    _val()  { cat "$1" 2>/dev/null | grep -m1 "$2" | cut -d: -f2- | xargs || echo "N/D"; }
    _file() { cat "$1" 2>/dev/null || echo "(não disponível)"; }

    # -----------------------------------------------------------------------
    # Variáveis extraídas dos relatórios
    # -----------------------------------------------------------------------
    local hw="${OUT_DIR}/hardware"
    local net="${OUT_DIR}/network"
    local stor="${OUT_DIR}/storage"
    local svc="${OUT_DIR}/services"

    local HOSTNAME CPU_MODEL CPU_CORES CPU_THREADS CPU_FREQ MEM_TOTAL MEM_AVAIL
    local OS_PRETTY KERNEL DISK_SUMMARY IP_ADDRS SLOW_SERVICES

    HOSTNAME="$(hostname -f 2>/dev/null || hostname)"
    OS_PRETTY="$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo 'Unknown')"
    KERNEL="$(uname -r)"

    CPU_MODEL="$(_val "${hw}/lscpu.txt" 'Nome do modelo\|Model name')"
    CPU_CORES="$(_val "${hw}/lscpu.txt" 'Núcleo(s) por soquete\|Core(s) per socket')"
    CPU_THREADS="$(_val "${hw}/lscpu.txt" '^CPU(s):')"
    CPU_FREQ="$(_val "${hw}/lscpu.txt" 'CPU MHz máx\|CPU max MHz')"
    [[ "$CPU_FREQ" =~ ^[0-9] ]] && CPU_FREQ="$(awk "BEGIN{printf \"%.1f GHz\", ${CPU_FREQ}/1000}")" || CPU_FREQ="N/D"

    MEM_TOTAL="$(grep '^Mem' "${hw}/free.txt" 2>/dev/null | awk '{print $2}' || echo 'N/D')"
    MEM_AVAIL="$(grep '^Mem' "${hw}/free.txt" 2>/dev/null | awk '{print $NF}' || echo 'N/D')"

    DISK_SUMMARY="$(grep -E '^\s*sd[a-z]\s' "${hw}/lsblk.txt" 2>/dev/null | awk '{print $1"("$4")"}' | paste -sd', ' - || echo 'N/D')"

    IP_ADDRS="$(grep 'inet ' "${net}/ip-addr.txt" 2>/dev/null | awk '{print $2}' | grep -v '^127' | paste -sd', ' - || echo 'N/D')"

    SLOW_SERVICES="$(head -3 "${svc}/boot-blame.txt" 2>/dev/null | awk '{print $2 " (" $1 ")"}' | paste -sd'  ' - || echo 'N/D')"

    local DOCKER_STATUS
    DOCKER_STATUS="$(docker ps --format "{{.Names}} ({{.Status}})" 2>/dev/null | paste -sd', ' - || echo 'N/D')"

    # -----------------------------------------------------------------------
    # executive-summary.md
    # -----------------------------------------------------------------------
    cat > "${md}/executive-summary.md" <<MDEOF
# Relatório Executivo — ${HOSTNAME}

**Data**: $(date '+%d de %B de %Y às %H:%M')
**Host**: ${HOSTNAME}
**OS**: ${OS_PRETTY}
**Kernel**: ${KERNEL}

---

## Sumário

| Categoria | Destaque |
|-----------|----------|
| **CPU** | ${CPU_MODEL} (${CPU_CORES} núcleos / ${CPU_THREADS} threads @ ${CPU_FREQ}) |
| **Memória** | ${MEM_TOTAL} total / ${MEM_AVAIL} disponível |
| **Discos** | ${DISK_SUMMARY} |
| **IPs** | ${IP_ADDRS} |
| **Docker** | ${DOCKER_STATUS} |
| **Boot mais lento** | ${SLOW_SERVICES} |

---

## Artefatos gerados

| Módulo | Diretório |
|--------|-----------|
| Hardware | [hardware/](../hardware/) |
| Rede | [network/](../network/) |
| Armazenamento | [storage/](../storage/) |
| Docker | [docker/](../docker/) |
| Serviços | [services/](../services/) |
| Tuning | [tuning/](../tuning/) |
| Recovery | [recovery/](../recovery/) |
| Backups | [backups/](../backups/) |
| Snapshots | [snapshots/](../snapshots/) |
| Manifests | [manifests/](../manifests/) |

---

*Gerado por crash-recovery.sh — $(date -Is)*
MDEOF

    # -----------------------------------------------------------------------
    # hardware.md
    # -----------------------------------------------------------------------
    cat > "${md}/hardware.md" <<MDEOF
# Hardware — ${HOSTNAME}

**Data**: $(date -Is)

## CPU
\`\`\`
$(head -20 "${hw}/lscpu.txt" 2>/dev/null || echo "N/D")
\`\`\`

## Memória
\`\`\`
$(_file "${hw}/free.txt")
\`\`\`

## Discos (lsblk)
\`\`\`
$(head -30 "${hw}/lsblk.txt" 2>/dev/null || echo "N/D")
\`\`\`

## Kernel / OS
- **OS**: ${OS_PRETTY}
- **Kernel**: ${KERNEL}
- **Arch**: $(uname -m)
\`\`\`
$(cat /proc/cmdline 2>/dev/null || echo "N/D")
\`\`\`
MDEOF

    # -----------------------------------------------------------------------
    # network.md
    # -----------------------------------------------------------------------
    cat > "${md}/network.md" <<MDEOF
# Rede — ${HOSTNAME}

**Data**: $(date -Is)

## Interfaces e IPs
\`\`\`
$(_file "${net}/ip-addr.txt")
\`\`\`

## Rotas
\`\`\`
$(_file "${net}/ip-route.txt")
\`\`\`

## DNS
\`\`\`
$(head -20 "${net}/resolvectl.txt" 2>/dev/null || cat "${net}/resolv.conf" 2>/dev/null || echo "N/D")
\`\`\`

## MACs
\`\`\`
$(_file "${net}/mac-summary.txt")
\`\`\`

## Conexões ativas (ss)
\`\`\`
$(head -30 "${net}/ss.txt" 2>/dev/null || echo "N/D")
\`\`\`
MDEOF

    # -----------------------------------------------------------------------
    # storage.md
    # -----------------------------------------------------------------------
    cat > "${md}/storage.md" <<MDEOF
# Armazenamento — ${HOSTNAME}

**Data**: $(date -Is)

## Resumo de discos e montagens
\`\`\`
$(_file "${stor}/disk-summary.txt")
\`\`\`

## Validação de UUIDs
\`\`\`
$(_file "${stor}/mount-validation.txt")
\`\`\`

## /etc/fstab
\`\`\`
$(_file "${stor}/fstab.conf")
\`\`\`
MDEOF

    # -----------------------------------------------------------------------
    # services.md
    # -----------------------------------------------------------------------
    cat > "${md}/services.md" <<MDEOF
# Serviços — ${HOSTNAME}

**Data**: $(date -Is)

## Serviços em execução
\`\`\`
$(_file "${svc}/running.txt")
\`\`\`

## Serviços habilitados (customizados)
\`\`\`
$(grep '/etc/systemd/system' "${svc}/all-unit-files.txt" 2>/dev/null || echo "N/D")
\`\`\`

## Timers
\`\`\`
$(_file "${svc}/timers.txt")
\`\`\`

## Boot (blame top 10)
\`\`\`
$(head -12 "${svc}/boot-blame.txt" 2>/dev/null || echo "N/D")
\`\`\`

## Serviços com falha
\`\`\`
$(_file "${svc}/failed.txt")
\`\`\`
MDEOF

    # -----------------------------------------------------------------------
    # recovery-guide.md (link amigável para restore-order)
    # -----------------------------------------------------------------------
    cp "${OUT_DIR}/recovery/restore-order.md" "${md}/recovery-guide.md" 2>/dev/null || true

    # -----------------------------------------------------------------------
    # tuning.md
    # -----------------------------------------------------------------------
    local tun="${OUT_DIR}/tuning"
    cat > "${md}/tuning.md" <<MDEOF
# Tuning — ${HOSTNAME}

**Data**: $(date -Is)

## CPU Governor
\`\`\`
$(grep -v '^#' "${tun}/cpu-governor.txt" 2>/dev/null | head -20 || echo "N/D")
\`\`\`

## Hugepages
\`\`\`
$(_file "${tun}/hugepages.txt")
\`\`\`

## sysctl customizados
\`\`\`
$(grep -v '^#' "${tun}/sysctl-custom.txt" 2>/dev/null | grep -v '^$' || echo "N/D")
\`\`\`

## Tuned profile
\`\`\`
$(_file "${tun}/tuned-profile.txt")
\`\`\`
MDEOF

    log INFO "[markdown] concluído → ${md}/"
}
