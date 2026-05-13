#!/usr/bin/env bash
# modules/tuning.sh — sysctl, CPU governor, hugepages, tuned, journald, Docker daemon

run_tuning() {
    log INFO "[tuning] coletando configurações de tuning"
    local d="${OUT_DIR}/tuning"

    # sysctl completo
    run_cmd "${d}/sysctl-all.txt"      sysctl -a

    # sysctl customizados (somente /etc/sysctl.d/ e /etc/sysctl.conf)
    {
        report_header "sysctl customizados"
        for f in /etc/sysctl.conf /etc/sysctl.d/*.conf; do
            [[ -f "$f" ]] || continue
            echo "## $f"
            grep -Ev '^\s*#|^\s*$' "$f" || true
            echo
        done
    } > "${d}/sysctl-custom.txt"

    # CPU governor
    {
        report_header "CPU Governor"
        for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            [[ -f "$f" ]] || continue
            printf "%-50s %s\n" "$f" "$(cat "$f")"
        done
        echo
        echo "## cpupower"
        cpupower frequency-info 2>/dev/null || true
    } > "${d}/cpu-governor.txt"

    # Hugepages
    {
        report_header "Hugepages"
        grep -i huge /proc/meminfo 2>/dev/null || true
        echo
        grep -r '' /sys/kernel/mm/hugepages/ 2>/dev/null || true
    } > "${d}/hugepages.txt"

    # tuned
    run_cmd "${d}/tuned-profile.txt"   tuned-adm active
    run_cmd "${d}/tuned-list.txt"      tuned-adm list
    copy_if_exists /etc/tuned          "${d}/tuned-etc"

    # journald
    copy_if_exists /etc/systemd/journald.conf        "${d}/journald.conf"
    copy_if_exists /etc/systemd/journald.conf.d      "${d}/journald.conf.d"

    # NUMA
    run_cmd "${d}/numactl.txt"         numactl --hardware

    # limites
    copy_if_exists /etc/security/limits.conf    "${d}/limits.conf"
    copy_if_exists /etc/security/limits.d       "${d}/limits.d"

    # Docker daemon (também aqui para referência de tuning)
    copy_if_exists /etc/docker/daemon.json      "${d}/docker-daemon.json"

    log INFO "[tuning] concluído → ${d}/"
}
