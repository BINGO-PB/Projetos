# BINGO Backend Cluster — Design D-lite

**Especificação de arquitetura e Bill of Materials (BOM)**
Datacenter do sítio — processamento em tempo real (RFI, calibração, gridding, sourcefind e detecção de FRB)

---

## 1. Contexto e requisitos de origem

Baseado na especificação "BINGO Backend Cluster" (BINGO-PB / SKARAB), com dois ajustes de escopo definidos ao longo da revisão:

- Este sistema é o **datacenter do sítio**, não a análise científica final — RFI, calibração, gridding e sourcefind rodam aqui.
- A **detecção de FRB também roda aqui**, operando como *flag* em tempo real: sinal sem FRB segue para integração normal; candidatos a FRB são sinalizados e encaminhados para análise posterior.

### Requisitos consolidados (do documento original)

| Item | Valor |
|---|---|
| Entrada | 28 SKARAB (1 por corneta), ~0,92 GB/s total (modo 1ms), ~450k pacotes/s |
| Storage | até 3,3 TB/h — necessidade de buffer + persistência |
| Compute (RFI+calib+gridding+sourcefind) | ~100 GFLOPs necessários |
| Rede | ~7 Gb/s necessários |
| Distribuição de carga | 3 servidores, split por corneta (S1: 1–10, S2: 11–20, S3: 21–28 → 9-10 cornetas/nó) |

### Achado-chave da revisão

O requisito de compute do documento original (~100 GFLOPs) cobre apenas RFI/calibração/gridding/sourcefind — **não inclui a busca de FRB**, que é bandwidth-bound e significativamente mais pesada (dedispersão incoerente varrendo um grande espaço de DM trials, via Heimdall ou equivalente). Isso motivou uma arquitetura **heterogênea**: uma GPU leve para o pipeline principal e uma GPU forte dedicada à busca de FRB — em vez de uma GPU única superdimensionada (ou subdimensionada) para as duas tarefas.

---

## 2. Arquitetura

```
                         ┌─────────────────────────────────────────┐
28x SKARAB  ──► Core     │              Servidor (x3)               │
(1 por      ──► Switch   │                                           │
 corneta)   ──► 40/100   │  NIC → Ingest/Reorder ─┬─► GPU leve (L4)  │
                GbE      │                        │   RFI+calib+     │
                         │                        │   gridding+      │
                         │                        │   sourcefind ────┼──► NVMe buffer ──► Storage persistente (NAS)
                         │                        │                  │
                         │                        └─► GPU pesada     │
                         │                            (RTX 6000 Ada) │
                         │                            dedispersão +  │
                         │                            busca FRB      │
                         │                                 │         │
                         │                         flag de candidato │
                         │                                 ▼         │
                         │                     dump de buffer de     │
                         │                     voltagem bruta ───────┼──► Storage de candidatos (curto prazo)
                         └─────────────────────────────────────────┘
```

**Split de carga:** S1 = cornetas 1–10, S2 = 11–20, S3 = 21–28 (9–10 cornetas/nó) — igual à especificação original.

**Redundância:** topologia N+1 a nível de nó — a perda de 1 dos 3 servidores reduz a capacidade em ~1/3, mas o sistema continua operando.

---

## 3. Especificação por nó de computação (×3)

| Componente | Especificação | Papel |
|---|---|---|
| Servidor | 2U dual-socket, 2× AMD EPYC 9004/9005 (24–32 cores totais), chassi com suporte a 2× GPU dual-slot, PSU redundante | Base |
| RAM | 512 GB DDR5 ECC RDIMM | Buffer de ingest + retenção de dados em torno de candidatos a FRB (dobro da especificação original de 256GB) |
| GPU leve | 1× NVIDIA L4 24GB (300 GB/s, 72W, single-slot) | Ingest/reorder + RFI + calibração + gridding + sourcefind (~100 GFLOPs necessários — folga de ~300x) |
| GPU pesada | 1× NVIDIA RTX 6000 Ada 48GB (960 GB/s, ECC, 300W) | Dedispersão + busca de FRB (Heimdall) — dedispersão é bandwidth-bound; substitui A100 com ECC mantido e ~40% de economia |
| NIC | 1× 40 GbE dual-port (QSFP+) | Uplink ao switch core |
| NVMe local (buffer) | 4× NVMe enterprise mixed-use 2–4TB, RAID10 | Absorve picos, permite replay, dump de voltagem bruta em eventos de FRB |
| Boot | 2× SSD SATA 480GB, RAID1 | Sistema operacional |

**Por que GPU heterogênea, e não uma GPU só:** a carga de RFI/calibração/gridding/sourcefind é ordens de magnitude mais leve que a busca de FRB. Usar A100 (ou equivalente) nas duas tarefas desperdiça capacidade na primeira; usar só GPU leve (L4) nas duas subdimensiona a segunda. Uma GPU por tarefa aproveita melhor o orçamento.

**Validação recomendada antes da compra:** rodar um benchmark piloto do Heimdall com os parâmetros reais de DM/canais do BINGO em 1 corneta e extrapolar ×9–10, para confirmar que a RTX 6000 Ada sustenta os jobs concorrentes por nó em tempo real.

---

## 4. Storage

### Camada 1 — Buffer NVMe (local, por nó)
Já descrita na seção 3. Função: absorver picos, desacoplar o pipeline, permitir replay, e reter dados de voltagem bruta em torno de candidatos a FRB até o dump ser processado.

### Camada 2 — Storage persistente (build DIY, ZFS/TrueNAS ou Ceph)

Substitui um NAS/SAN de marca por hardware padrão + software open-source, mantendo o mesmo nível de proteção (RAIDZ2 ≈ RAID6), a um custo menor.

| Componente | Especificação |
|---|---|
| Chassi | 4U, 24–36 baias hot-swap, fonte redundante |
| Servidor "head" | 1× CPU single-socket (Xeon/EPYC) + 256 GB RAM ECC (cache ARC do ZFS) |
| HBA | 2× controladora modo IT (passthrough), ex. LSI/Broadcom 9400-16i |
| Discos | 12× HD enterprise nearline 16TB, RAIDZ2 (2 discos de paridade) → **~160 TB úteis** |
| Rede | 1× NIC 25/100GbE dual-port |
| Software | TrueNAS SCALE ou Ceph — open-source, sem custo de licença |

**Validação de capacidade e throughput:** requisito do documento é 100–500TB úteis e ≥1 GB/s sustentado. A configuração acima entrega ~160TB (dentro da faixa) e HDDs SAS 7.2k em RAIDZ2 com 12 discos tipicamente sustentam >1,5 GB/s sequencial — atende com folga. Se o volume de dados de longo prazo crescer além de 160TB, a arquitetura escala por adição de baias/discos sem redesenho.

**Trade-off assumido:** suporte passa a ser interno (equipe de TI do sítio), não terceirizado via contrato de fabricante — economia de custo em troca de responsabilidade operacional própria.

---

## 5. Rede e infraestrutura

| Componente | Especificação |
|---|---|
| Switch core | **Novo** (não refurbished), 32 portas 40/100GbE, ≥1 Tbps de capacidade de comutação, garantia de fabricante |
| Switch de gerenciamento | 1GbE, para IPMI/BMC fora de banda |
| Cabeamento | DAC 40/100G + transceivers de fibra, kit para 3 servidores + storage + switch |
| Rack | 42U, com trilhos e organizadores de cabo |
| PDU | 2× unidades gerenciáveis redundantes (alimentação A/B) |

---

## 6. Bill of Materials (BOM) completo

*Valores em preço médio de mercado (set/2026), exceto o switch core, cotado com preço real de fornecedor.*

### 6.1 Nós de computação (×3)

| Item | Especificação | Qtd/nó | Nós | Preço médio unit. (USD) | Subtotal (USD) |
|---|---|---|---|---|---|
| Servidor 2U dual-socket EPYC | Chassi + PSU redundante + 2× AMD EPYC 9004/9005 (24–32 cores), suporte a 2× GPU dual-slot | 1 | 3 | $11.500 | $34.500 |
| RAM DDR5 ECC RDIMM | 512 GB/nó | 1 | 3 | $4.250 | $12.750 |
| GPU leve — NVIDIA L4 24GB | Pipeline principal (RFI/calib/gridding/sourcefind) | 1 | 3 | $2.750 | $8.250 |
| GPU pesada — NVIDIA RTX 6000 Ada 48GB | Dedispersão + busca FRB (Heimdall) | 1 | 3 | $7.000 | $21.000 |
| NIC 40GbE QSFP+ dual-port | Uplink ao switch core | 1 | 3 | $600 | $1.800 |
| NVMe local (buffer) — kit | 4× NVMe mixed-use 2–4TB, RAID10 | 1 | 3 | $2.200 | $6.600 |
| Boot drives (SO) | 2× SSD SATA 480GB, RAID1 | 1 | 3 | $225 | $675 |
| **Subtotal — Nós de computação (3x)** | | | | | **$85.575** |

### 6.2 Storage DIY (ZFS/TrueNAS)

| Item | Especificação | Qtd | Preço médio unit. (USD) | Subtotal (USD) |
|---|---|---|---|---|
| Chassi 4U hot-swap, 24–36 baias | P/ discos + fonte redundante | 1 | $4.000 | $4.000 |
| Servidor "head" de storage | 1× CPU single-socket + 256GB RAM ECC | 1 | $4.000 | $4.000 |
| HBA modo IT (passthrough) | Ex. LSI/Broadcom 9400-16i | 2 | $550 | $1.100 |
| HD enterprise nearline 16TB | 12 discos, RAIDZ2 — ~160TB úteis | 12 | $300 | $3.600 |
| NIC 25/100GbE dual-port | Uplink ao switch core | 1 | $700 | $700 |
| Software (TrueNAS SCALE / Ceph) | Open-source | 1 | $0 | $0 |
| **Subtotal — Storage DIY** | | | | **$13.400** |

### 6.3 Rede e infraestrutura

| Item | Especificação | Qtd | Preço médio unit. (USD) | Subtotal (USD) |
|---|---|---|---|---|
| Switch core — **NVIDIA Mellanox SN3700** (MSN3700-CS2F) | Spectrum-2, 32× 100GbE QSFP28, NVIDIA Onyx OS, 2× PSU AC, 6,4 Tb/s, **novo**, garantia de fabricante | 1 | $9.843 | $9.843 |
| Switch de gerenciamento 1GbE | IPMI/BMC | 1 | $225 | $225 |
| Cabeamento DAC 40/100G + transceivers | Kit completo | 1 | $1.150 | $1.150 |
| Rack 42U | Com trilhos e organizadores | 1 | $1.150 | $1.150 |
| PDU gerenciável redundante | 2× unidades (A/B) | 2 | $550 | $1.100 |
| **Subtotal — Rede e Infra** | | | | **$13.468** |

*Preço do switch: cotação real de mercado para NVIDIA MSN3700-CS2F novo (set/2026). Variantes de firmware (ONIE/Onyx/Cumulus) vão de ~$6.800 a ~$11.400 — usada a versão Onyx, padrão de fábrica com suporte oficial NVIDIA.*

### 6.4 Total consolidado

| Categoria | USD | BRL* |
|---|---|---|
| Nós de computação (3x) | $85.575 | R$ 453.548 |
| Storage DIY | $13.400 | R$ 71.020 |
| Rede e infraestrutura | $13.468 | R$ 71.380 |
| **TOTAL CAPEX (Design D-lite)** | **$112.443** | **R$ 595.948** |

*Cotação de referência: 1 USD ≈ R$ 5,30. Ajustar para a cotação do dia antes de fechar orçamento. Valores livres de impostos de importação (podem adicionar 40–80% sem isenção via CNPq/FAPESP/Finep).

---

## 7. Comparação com cenários anteriores

| Cenário | USD mín | USD máx | Observação |
|---|---|---|---|
| A — 3×2 A100 (proposta inicial) | $102.000 | $171.000 | GPU uniforme A100, storage NAS de marca — overkill de compute para RFI/calib/gridding |
| C — 3×2 L4 | $65.000 | $100.000 | Mais barato, mas subdimensionado — L4 sozinha não atende busca de FRB em tempo real |
| D — 3×(L4+A100) heterogêneo | $84.000 | $143.000 | Atende a demanda, sem otimização de custo de GPU/storage |
| **D-lite — 3×(L4+RTX 6000 Ada) + storage DIY + switch novo (SN3700)** | **$112.443** | (ponto único) | **Esta proposta** — mantém confiabilidade (ECC, switch novo com garantia de fabricante) e reduz custo via storage DIY e GPU RTX 6000 Ada |

---

## 8. Premissas, fontes e riscos

| Item | Nota |
|---|---|
| Preços | Todos os itens usam preço médio de mercado (set/2026), calculado como ponto médio da faixa observada — exceto o switch, cotado com preço real de fornecedor. Mercado de GPU datacenter é volátil — revalidar antes da compra. |
| Compute necessário (pipeline principal) | ~100 GFLOPs, conforme especificação original do documento. L4 entrega ~30 TFLOPS FP32 — folga de ~300x. |
| Compute de FRB (Heimdall) | Dedispersão é bandwidth-bound. Referência de literatura: GPU com ~264GB/s já processava 9 feixes em tempo real a 2000 DM trials (estudo de dimensionamento do Apertif). RTX 6000 Ada tem 960GB/s — folga esperada, mas recomenda-se benchmark piloto com parâmetros reais de DM/canais do BINGO antes de finalizar a compra. |
| RAM 512GB/nó | Dobrado em relação à especificação original (256GB) para reter buffer de voltagem bruta em torno de candidatos a FRB flagados — retenção de curto prazo, não armazenamento de longo prazo. |
| Storage DIY | Substitui NAS/SAN de marca por hardware padrão. Suporte passa a ser interno em vez de contrato de fabricante. |
| Switch core | Mantido **novo** (não refurbished), por decisão do cliente — NVIDIA Mellanox SN3700 (MSN3700-CS2F), $9.843, garantia de fabricante e suporte oficial NVIDIA. |
| Câmbio USD→BRL | Valor de referência — ajustar para a cotação do dia. |
| Placas SKARAB (28 unidades) | Fora do escopo deste orçamento — frente de recepção/digitalização já contemplada separadamente, conforme documento original. |

---

## 9. Próximos passos recomendados

1. Rodar benchmark piloto do Heimdall (1 corneta, parâmetros reais de DM) e extrapolar para confirmar dimensionamento da GPU de FRB.
2. Confirmar faixa de DM máxima e nº de DM trials esperados com quem definiu o pipeline científico.
3. Validar cotação USD/BRL atual e verificar elegibilidade de isenção fiscal (CNPq/FAPESP/Finep).
4. Definir política de retenção de candidatos a FRB (quanto tempo o buffer de voltagem bruta precisa ser mantido antes do dump/análise).
