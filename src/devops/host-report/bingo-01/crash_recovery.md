# Estratégia de Reprodutibilidade e Disaster Recovery

## Objetivo

Garantir que o host `bingo-01` possa ser:

- recriado rapidamente
- auditado
- migrado para novo hardware
- restaurado após falha crítica
- reproduzido de forma determinística

---

# Itens que DEVEM ser preservados

# 1. Inventário do Sistema

## Pacotes instalados  ✅

## Kernel e microcode


```bash
uname -a
apt list --installed | grep microcode
```

---

## Hardware

Preservar:


- lscpu ✅
- lsblk ✅
- lspci
- lsusb
- ip addr


---

# 2. Configuração de Rede


```text
/etc/netplan/
/etc/NetworkManager/
/etc/hosts
/etc/hostname
/etc/resolv.conf
```

---

## Interfaces importantes

Registrar:

- nomes persistentes
- MACs
- MTUs
- bridges Docker
- rotas
- VPNs
- DNS

---

# 3. Filesystems e Mounts

## Preservar `/etc/fstab` ✅

---

# 4. Serviços Systemd

## Preservar

```text
/etc/systemd/system/
```

- jupyterhub.service
- anydesk.service
- callisto.service
- nfs-uirapuru.service

---

## Registrar ✅

```bash
systemctl list-unit-files
systemctl --type=service
```

---


# 5. Docker

## Preservar

```text
/etc/docker/
/var/lib/docker/volumes/
```

---

## Registrar

```bash
docker ps -a
docker images
docker volume ls
docker network ls
docker compose config
```


---

## Registrar

- chaves públicas
- regras firewall
- iptables
- fail2ban (se existir)
- OpenVPN

---

# 9. Usuários e Grupos

## Preservar

```text
/etc/passwd
/etc/group
/etc/shadow
```

---

## Registrar especialmente

- grupo `bingopb`
- UIDs/GIDs
- homes
- shells

---

# 10. Tunings de Performance

## Preservar

```text
/etc/sysctl.d/
/etc/security/limits.d/
/etc/default/
```

---

## Inclui

- tuned profiles
- sysctl networking
- hugepages
- limits realtime
- Docker tuning
- journald tuning

---

# 11. NVIDIA / GPU

## Registrar

```bash
nvidia-smi
ubuntu-drivers list
```

---

## Preservar

- versão driver
- CUDA (se existir)
- módulos kernel

---

## Registrar  

```text
/etc/udev/rules.d/
```


## Registrar

```bash
uhd_find_devices
bladeRF-cli -p
```

---

# Estratégia Recomendada de Reprodutibilidade

# 1. Repositório Git de Infraestrutura

Criar:

```text
infra-bingo01/
```

Com:

```text
infra-bingo01/
├── ansible/
├── scripts/
├── systemd/
├── netplan/
├── sysctl/
├── docker/
├── reports/
└── docs/
```

---

# 2. Snapshot periódico de configuração

Gerar automaticamente:

```bash
tar czf bingo01-config-$(date +%F).tgz \
  /etc \
  /usr/local/bin \
  /backup-system
```

---

# 3. Relatórios automatizados

Gerar periodicamente:

- pacotes
- serviços
- mounts
- Docker
- rede
- systemd
- hardware

---

# 4. Bootstrap script

Objetivo:

Permitir reinstalação rápida em novo host.

Exemplo:

```text
bootstrap-bingo01.sh
```

Funções:

- instalar pacotes
- restaurar configs
- restaurar systemd
- restaurar Docker
- restaurar tuning
- restaurar backups

---

# 5. Ordem recomendada de restauração

## Etapa 1

Instalar:

- Ubuntu LTS
- rede básica
- SSH

---

## Etapa 2

Restaurar:

- `/etc`
- systemd
- netplan
- sysctl

---

## Etapa 3

Instalar:

- Docker
- GNU Radio
- UHD
- NVIDIA

---

## Etapa 4

Restaurar:

- `/home`
- `/share`
- `/data`
- `/jupyterhub`

---

## Etapa 5

Validar:

- serviços
- mounts
- SDRs
- GPUs
- backups
- notebooks
- Docker

---

# Recomendação Final

O estado atual do `bingo-01` já está suficientemente organizado para que:

- uma reconstrução completa seja automatizável
- a configuração seja tratada como infraestrutura versionada
- a máquina possa servir como referência para futuros hosts científicos
- a recuperação operacional seja rápida e previsível

---

# Objetivo Final

Construir um sistema de backup:

- previsível
- restaurável
- incremental
- eficiente para datasets científicos
- amigável para código-fonte
- adequado para workflows GNU Radio/JupyterHub
- auditável
- simples de manter
- resiliente a erro humano

