# Relatório do Sistema - Host bingo-01

**Data do Relatório**: 12 de maio de 2026  
**Host**: bingo-01  
**Sistema Operacional**: Ubuntu 24.04.4 LTS  
**Kernel**: 6.17.0-23-generic

---

## 📋 Sumário Executivo

| Categoria | Destaque |
|-----------|----------|
| **CPU** | Intel(R) Core(TM) i9-10850K CPU @ 3.60GHz (10 núcleos / 20 threads @ 5.2 GHz) |
| **Memória RAM** | 62Gi total / 58Gi disponível (4,0Gi em uso) |
| **Armazenamento** | sda (1,8T),sdb (12,7T),sdc (447,1G) |
| **Redes** | 150.165.37.54/24,192.168.10.100/24,172.17.0.1/16,172.18.0.1/16 |
| **Serviços Lentos** | docker.service (3.834s) webmin.service (2.612s) usermin.service (2.475s) |

---

## 🖥️ HARDWARE & SISTEMA

### Processador
- **Modelo**: Intel(R) Core(TM) i9-10850K CPU @ 3.60GHz
- **Núcleos/Threads**: 10 núcleos / 20 threads
- **Freq. Máxima**: 5.2 GHz

📄 Detalhes completos: [reports/lscpu_20260512-193339.txt](reports/lscpu_20260512-193339.txt)

### Memória RAM
- **Total**: 62Gi
- **Usada**: 4,0Gi
- **Disponível**: 58Gi

📄 Detalhes: [reports/free_20260512-193339.txt](reports/free_20260512-193339.txt)

### Armazenamento (Discos)

📄 Detalhes: [reports/lsblk_20260512-193339.txt](reports/lsblk_20260512-193339.txt)

---

## 🌐 REDE

**IPs Ativos**: 150.165.37.54/24,192.168.10.100/24,172.17.0.1/16,172.18.0.1/16

📄 Configuração completa: [reports/ip_addr_20260512-193339.txt](reports/ip_addr_20260512-193339.txt)

---

## ⚡ PERFORMANCE & BOOT

📄 Análise de boot:
- Serviços mais lentos: [reports/systemd_blame_20260512-193339.txt](reports/systemd_blame_20260512-193339.txt)
- Cadeia crítica: [reports/systemd_critical_20260512-193339.txt](reports/systemd_critical_20260512-193339.txt)

---

## 📝 Arquivos de Dados Disponíveis

### Relatórios Gerados
- 📄 **CPU Info**: [lscpu_20260512-193339.txt](reports/lscpu_20260512-193339.txt)
- 📄 **Memória**: [free_20260512-193339.txt](reports/free_20260512-193339.txt)
- 📄 **Discos**: [lsblk_20260512-193339.txt](reports/lsblk_20260512-193339.txt)
- 📄 **Rede**: [ip_addr_20260512-193339.txt](reports/ip_addr_20260512-193339.txt)
- 📄 **Systemd Boot Analysis**:
  - [systemd_blame_20260512-193339.txt](reports/systemd_blame_20260512-193339.txt)
  - [systemd_critical_20260512-193339.txt](reports/systemd_critical_20260512-193339.txt)

---

**Gerado em**: 12 de maio de 2026 às 19:33:42  
**Tipo de Relatório**: System Baseline Report  
**Status**: ✅ Completo
