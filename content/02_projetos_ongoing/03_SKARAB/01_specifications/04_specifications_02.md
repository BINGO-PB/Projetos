| Item | Especificação | Qtd/nó | Nós | Preço unit. mín (USD) | Preço unit. máx (USD) | Subtotal mín (USD) | Subtotal máx (USD) |
| ---- | ------------- | ------ | --- | --------------------- | --------------------- | ------------------ | ------------------ |
| Servidor 2U dual-socket EPYC | Chassi + PSU redundante + 2x AMD EPYC 9004/9005 (24-32 cores totais), suporte a 2x GPU dual-slot | 1 | 3 | $8.000 | $15.000 | $24.000 | $45.000 |
| RAM DDR5 ECC RDIMM | 512 GB por nó — dimensionado para reter buffer de voltagem bruta em torno de candidatos a FRB | 1 | 3 | $3.500 | $5.000 | $10.500 | $15.000 |
| GPU leve — NVIDIA L4 24GB | Ingest/reorder + RFI + calibração + gridding + sourcefind (~100 GFLOPs necessários, folga ampla) | 1 | 3 | $2.500 | $3.000 | $7.500 | $9.000 |
| GPU pesada — NVIDIA RTX 6000 Ada 48GB | Dedispersão + busca de FRB (Heimdall). ECC, 960GB/s, blower — substitui A100 com ~40% de economia | 1 | 3 | $6.000 | $8.000 | $18.000 | $24.000 |
| NIC 40GbE QSFP+ dual-port | Uplink para o switch core | 1 | 3 | $400 | $800 | $1.200 | $2.400 |
| NVMe local (buffer) — kit | 4x NVMe enterprise mixed-use 2-4TB, RAID10 — absorve picos e permite replay + dump de voltagem | 1 | 3 | $1.600 | $2.800 | $4.800 | $8.400 |
| Boot drives (SO) | 2x SSD SATA 480GB RAID1 | 1 | 3 | $150 | $300 | $450 | $900 |
| SUBTOTAL — Nós de computação (3x) | | | | | | $66.450 | $104.700 |

| Item | Especificação | Qtd/nó | Nós | Preço unit. mín (USD) | Preço unit. máx (USD) | Subtotal mín (USD) | Subtotal máx (USD) |
| ---- | ------------- | ------ | --- | --------------------- | --------------------- | ------------------ | ------------------ |
| Chassi 4U hot-swap, 24-36 baias | P/ discos + fonte redundante | 1 | 1 | $3.000 | $5.000 | $3.000 | $5.000 |
| Servidor "head" de storage | 1x CPU (Xeon/EPYC single-socket) + 256GB RAM ECC (ZFS ARC cache) | 1 | 1 | $3.000 | $5.000 | $3.000 | $5.000 |
| HBA modo IT (passthrough) | Ex.: LSI/Broadcom 9400-16i — necessário p/ ZFS acessar discos diretamente | 2 | 1 | $400 | $700 | $800 | $1.400 |
| HD enterprise nearline 16TB (SAS/SATA) | 12 discos, RAIDZ2 (2 discos de paridade) — ≈160TB úteis | 12 | 1 | $250 | $350 | $3.000 | $4.200 |
| NIC 25/100GbE dual-port | Uplink ao switch core | 1 | 1 | $500 | $900 | $500 | $900 |
| Software (TrueNAS SCALE ou Ceph) | Open-source, sem custo de licença | 1 | 1 | $0 | $0 | $0 | $0 |
| SUBTOTAL — Storage DIY | | | | | | $10.300 | $16.500 |

| Item | Especificação | Qtd/nó | Nós | Preço unit. mín (USD) | Preço unit. máx (USD) | Subtotal mín (USD) | Subtotal máx (USD) |
| ---- | ------------- | ------ | --- | --------------------- | --------------------- | ------------------ | ------------------ |
| Switch core 40/100GbE (refurbished) | Ex.: Mellanox/NVIDIA SN2700, 32 portas, ≥1Tbps — mercado de segunda mão certificado | 1 | 1 | $2.500 | $5.000 | $2.500 | $5.000 |
| Switch de gerenciamento 1GbE | IPMI/BMC, fora de banda | 1 | 1 | $150 | $300 | $150 | $300 |
| Cabeamento DAC 40/100G + transceivers de fibra | Kit para conectar 3 servidores + storage + switch | 1 | 1 | $800 | $1.500 | $800 | $1.500 |
| Rack 42U | Com trilhos e organizadores de cabo | 1 | 1 | $800 | $1.500 | $800 | $1.500 |
| PDU gerenciável redundante | 2 unidades (A/B feed) | 2 | 1 | $350 | $750 | $700 | $1.500 |
| SUBTOTAL — Rede e Infra | | | | | | $4.950 | $9.800 |

Cloud GPU/HPC

R$70k
