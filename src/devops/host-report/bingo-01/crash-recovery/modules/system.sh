#!/usr/bin/env bash
# modules/system.sh — hardware: CPU, memória, discos, PCI, USB, GPU, sensores

run_system() {
    log INFO "[system] coletando hardware"
    local d="${OUT_DIR}/hardware"

    run_cmd "${d}/lscpu.txt"          lscpu
    run_cmd "${d}/lsblk.txt"          lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS,LABEL,UUID
    run_cmd "${d}/blkid.txt"          blkid
    run_cmd "${d}/lspci.txt"          lspci -vvv
    run_cmd "${d}/lsusb.txt"          lsusb -v
    run_cmd "${d}/free.txt"           free -h
    run_cmd "${d}/dmidecode.txt"      dmidecode
    run_cmd "${d}/uname.txt"          uname -a
    run_cmd "${d}/nvidia-smi.txt"     nvidia-smi
    run_cmd "${d}/sensors.txt"        sensors
    run_cmd "${d}/cpupower.txt"       cpupower frequency-info
    run_cmd "${d}/numactl.txt"        numactl --hardware

    # os-release snapshot
    copy_if_exists /etc/os-release    "${d}/os-release.txt"
    copy_if_exists /etc/hostname      "${d}/hostname.txt"
    copy_if_exists /etc/hosts         "${d}/hosts.txt"
    copy_if_exists /proc/cmdline      "${d}/kernel-cmdline.txt"
    copy_if_exists /proc/meminfo      "${d}/meminfo.txt"
    copy_if_exists /proc/cpuinfo      "${d}/cpuinfo.txt"

    log INFO "[system] concluído → ${d}/"
}
