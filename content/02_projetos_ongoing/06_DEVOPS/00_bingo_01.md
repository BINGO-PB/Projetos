# BINGO_01

`@adrielcnascimento

IP: 150.165.36.54
group: bingopb

Esta máquina é localizada na sala 24 do Laboratório de Metrologia, possui interface WAN e faz IP forwarding para a LAN.


:::{admonition} **Prioritário**
:class: important 

Os serviços jupyterhub, bingodocs_ai e docke_skarab_bingo_ai estão com problemas de portas (provavelmente configuração do nginx proxy manager)

**Consertar isto!**

Abaixo você encontra algumas informações sobre os serviços.
:::

## Task 01: Tidyng up

- [ ] Verificar se todas as partições estão montadas
- [ ] Avaliar estrutura da pasta /src/bingo-01 e verificar o que se pretende como backup e como relatório de sistema
  - [ ] Corrigir eventuais problemas com o backup
- [ ] - documentar o sistema:
  - hardware
  - linux kernel
  - linux distro
  - pacotes instalados apt
  - pacotes instalados snap
- [ ] Configuração de rece:
  - Interfaces
  - iptables
  - dhcp

- [ ] services
  - containerd.service
  - cron.service
  - docker.service
  - duplicati.service
  - jupyterhub.service
  - nfs-uirapuru.service
  - usermin.service
  - webmin.service
  - nfs-client.target

## Docker

Todos serviços docker estão em /share/system
O acesso de todos é feito via nginx proxy manager


