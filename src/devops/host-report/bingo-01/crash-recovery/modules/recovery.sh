#!/usr/bin/env bash
# modules/recovery.sh — usuários, grupos, bootstrap manifest, restore order

run_recovery() {
    log INFO "[recovery] coletando dados de recuperação"
    local d="${OUT_DIR}/recovery"
    local m="${OUT_DIR}/manifests"
    local c="${OUT_DIR}/configs"

    # Snapshot rápido de configs críticas (consumo direto em restore)
    copy_if_exists /etc/fstab                 "${c}/fstab"
    copy_if_exists /etc/hostname              "${c}/hostname"
    copy_if_exists /etc/hosts                 "${c}/hosts"
    copy_if_exists /etc/resolv.conf           "${c}/resolv.conf"
    copy_if_exists /etc/netplan               "${c}/netplan"
    copy_if_exists /etc/systemd/system        "${c}/systemd-system"
    copy_if_exists /etc/docker                "${c}/docker"
    copy_if_exists /etc/jupyterhub            "${c}/jupyterhub"
    copy_if_exists /etc/sudoers               "${c}/sudoers"
    copy_if_exists /etc/sudoers.d             "${c}/sudoers.d"

    # -----------------------------------------------------------------------
    # Usuários e grupos
    # -----------------------------------------------------------------------
    {
        report_header "Usuários do sistema (/etc/passwd)"
        getent passwd | sort -t: -k3 -n
    } > "${d}/passwd.txt"

    {
        report_header "Grupos do sistema (/etc/group)"
        getent group | sort -t: -k3 -n
    } > "${d}/group.txt"

    {
        report_header "Usuários do grupo bingopb"
        getent group bingopb 2>/dev/null | tr ',' '\n' | tail -n +1 || echo "Grupo bingopb não encontrado"
        echo
        echo "## Membros sudo/admin"
        getent group sudo 2>/dev/null || getent group wheel 2>/dev/null || true
    } > "${d}/bingopb-users.txt"

    # Usuários com shell válido (humanos)
    {
        report_header "Usuários humanos (shell não-nologin)"
        getent passwd | awk -F: '$7 !~ /nologin|false/ && $3 >= 1000 {
            printf "uid=%-6s gid=%-6s home=%-25s shell=%s name=%s\n", $3,$4,$6,$7,$5
        }' | sort -n
    } > "${d}/human-users.txt"

    # Homes com tamanho
    {
        report_header "Tamanho de /home"
        du -sh /home/*/ 2>/dev/null | sort -h || true
    } > "${d}/home-sizes.txt"

    # SSH authorized_keys
    ensure_dir "${d}/authorized-keys"
    while IFS=: read -r user _ uid _ _ home _; do
        [[ "$uid" -lt 1000 ]] && continue
        local keyfile="${home}/.ssh/authorized_keys"
        if [[ -f "$keyfile" ]]; then
            cp -a "$keyfile" "${d}/authorized-keys/${user}-authorized_keys" 2>/dev/null || true
        fi
    done < <(getent passwd)

    # -----------------------------------------------------------------------
    # Bootstrap manifest
    # -----------------------------------------------------------------------
    {
        report_header "Bootstrap Manifest — ${HOSTNAME:-$(hostname)}"
        echo "hostname:        $(hostname -f 2>/dev/null || hostname)"
        echo "kernel:          $(uname -r)"
        echo "os:              $(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2)"
        echo "arch:            $(uname -m)"
        echo "date:            $(date -Is)"
        echo
        echo "## IPs"
        ip addr | awk '/inet / && !/127\.0\.0\.1/ {print "  " $2}'
        echo
        echo "## Mounts críticos"
        findmnt -rno TARGET,SOURCE,FSTYPE | grep -Ev '^/(proc|sys|dev|run|snap)' | head -20
        echo
        echo "## Serviços críticos (enabled)"
        systemctl list-unit-files --state=enabled --no-pager --no-legend 2>/dev/null | awk '{print "  " $1}' | head -30
        echo
        echo "## Docker containers"
        docker ps -a --format "  {{.Names}} | {{.Image}} | {{.Status}}" 2>/dev/null || echo "  (docker não disponível)"
        echo
        echo "## Pacotes manuais (top 30)"
        apt-mark showmanual 2>/dev/null | sort | head -30 | awk '{print "  " $0}' || true
    } > "${m}/bootstrap-manifest.txt"

    # -----------------------------------------------------------------------
    # Restore order guide
    # -----------------------------------------------------------------------
    cat > "${d}/restore-order.md" <<'RESTORE_EOF'
# Guia de Restauração — bingo-01

## Pré-requisitos
- ISO Ubuntu instalada (mesma versão do OS)
- Acesso ao repositório de backup (NFS ou disco externo)
- Este diretório de recovery disponível

---

## Passo 1 — Instalação Base Ubuntu
1. Boot pelo ISO Ubuntu
2. Instalar com mesma versão de OS documentada em `hardware/os-release.txt`
3. Configurar usuário admin temporário
4. Configurar rede mínima (IP estático conforme `network/`)

## Passo 2 — Configuração de Rede
```bash
# Restaurar netplan
cp recovery/netplan/* /etc/netplan/
netplan apply
```

## Passo 3 — Restauração de /etc
```bash
# Restaurar fstab
cp storage/fstab.conf /etc/fstab
bash storage/replay-mounts.sh
```

## Passo 4 — Pacotes
```bash
# Reinstalar pacotes manuais
apt-mark showmanual > /tmp/manual-pkgs.txt  # já em hardware/
xargs apt-get install -y < manifests/packages-manual.txt
```

## Passo 5 — Usuários e Grupos
```bash
# Recriar grupo bingopb (verificar GID em recovery/group.txt)
groupadd -g <GID> bingopb

# Recriar usuários (verificar UIDs em recovery/human-users.txt)
# Adicionar ao bingopb conforme recovery/bingopb-users.txt
```

## Passo 6 — Docker
```bash
apt-get install -y docker.io docker-compose
cp docker/daemon.json /etc/docker/daemon.json
systemctl enable --now docker

# Recriar containers a partir dos compose files em docker/
```

## Passo 7 — JupyterHub
```bash
# Restaurar config
cp -r services/jupyterhub /etc/jupyterhub
# Reinstalar JupyterHub (ver services/detail-jupyterhub.txt)
```

## Passo 8 — Systemd Units Customizados
```bash
cp services/*.service services/*.timer /etc/systemd/system/
systemctl daemon-reload
# Habilitar conforme services/enabled.txt
```

## Passo 9 — Tuning
```bash
# sysctl
cp tuning/sysctl-custom.txt /etc/sysctl.d/99-custom.conf
sysctl -p /etc/sysctl.d/99-custom.conf

# CPU governor conforme tuning/cpu-governor.txt
```

## Passo 10 — Backups
```bash
# Restaurar sistema de backup
# Verificar backups/timers.txt para reconfigurar timers
systemctl enable --now backup-*.timer
```

## Passo 11 — Validação Final
```bash
# Verificar serviços
systemctl list-units --state=failed

# Verificar montagens
findmnt -A

# Verificar rede
ip addr && ip route

# Verificar Docker
docker ps -a
```
RESTORE_EOF

    # -----------------------------------------------------------------------
    # Pacotes manuais no manifests/
    # -----------------------------------------------------------------------
    {
        report_header "Pacotes instalados manualmente"
        apt-mark showmanual 2>/dev/null | sort || true
    } > "${m}/packages-manual.txt"

    {
        report_header "Todos os pacotes instalados"
        dpkg-query -W -f='${binary:Package}\t${Version}\n' 2>/dev/null | sort || true
    } > "${m}/packages-all.txt"

    log INFO "[recovery] concluído → ${d}/ + ${m}/"
}
