# BINGO Skarab PB

## Descrição do Problema

O SKARAB (Square Kilometer Array Reconfigurable Application Board) é uma plataforma de computação superescala baseada em FPGA, projetada pela Peralex Electronics na África do Sul, em colaboração com o SARAO para rádio astronomia. É o sucessor do ROACH2, com foco em alto desempenho, baixa latência e processamento de sinal digital. 

![Esquema da Skarab](../../00_images/skarab_esquema.png)

Este dispositivo será utilizado como backend do BINGO, é necessário:
- Determinar o processamento de sinal necessário para atingir o objetivo de ciência do BINGO, a saber, observações cosmológicas de hidrogênio neutro e fenômenos transientes.
- Determinar o transporte dos dados da SKARAB para um computador controlador.
- Construir uma pipeline no controlador para ingerir os dados da SKARAB, controlar seu comportamento e transmitir os dados downstream.

## Histórico

## Time

- UFCG
    - Luciano Barosi
    - Jordany Vieira
    - Tales
    - Gutemberg
    - Aluno de Gutemberg
    - João Vitor
- CHINA
    - Hector
- INPE
    - Cesar Strauss
    - Jorge

## Baseline

## Dificuldades Enfrentadas

## Plano de Ação

## Decisões de organização do trabalho

:::{admonition} **Computadores**
- **hven**: máquina onde será instalado *Matlab*, *Vivado* para desenvolvimento de bitstreams.
- **uirapuru**: dual boot Ubuntu 16.04 + python 2.7, conectada a Skarab para desenvolvimento do sistema de controle.
:::

### RoadMap 

:::{seealso} **Fase 0 — Preparação de Ambiente**

#### Objetivos
- Configuração dos ambientes de desenvolvimento
- Execução de exemplos básicos do CASPER

#### Tarefas

- Preparação de ambiente em *hven*
  - Equipe: Tales + Arthur
  - Milestone: execução do `casper_fft.slx`

- Preparação de ambiente em *uirapuru*
  - Equipe: Tales + João Vitor
  - Milestone: tutorial 2 CASPER

:::

:::{seealso} **Fase 1 — Fundamentos CASPER**

#### Objetivos
- Nivelamento da equipe
- Compreensão da arquitetura CASPER + FPGA

#### Tarefas

- Tutorial CASPER 4
  - Milestone: Waterfall diagram

#### Conteúdos essenciais

- Arquitetura FPGA (DSP slices, BRAM, routing)
- Representação em ponto fixo
- Pipeline de processamento
:::

:::{warning} **2 — Modelagem de Sinal**

#### Objetivos
- Construir modelos realistas antes do hardware

#### Tarefas

- Modelagem do ADC
- Modelagem de ruído
- Modelagem de RFI
- Controle de ganho (gain staging)
- Remoção de DC

:::

:::{warning} **3 — DSP Core (Pipeline FFT)**

#### Objetivos
- Desenvolvimento do espectrômetro no Simulink

#### Tarefas

1. FFT
   - Aliasing
   - Scalloping loss
   - Spectral leakage

2. Janelamento

3. Estratégia de ponto fixo
   - Definição de bit-width
   - Política de overflow (wrap vs saturate)

4. Decimação

5. Filtros FIR

6. Dynamic Range e SFDR

7. Saturação e não-linearidades

:::

:::{warning} **4 — Sistema Digital**

#### Objetivos
- Transformar o DSP em sistema embarcado funcional

#### Tarefas

- Timestamping
- Packetização (10/40 GbE)
- Channel selection
- Buffering

:::

:::{warning} **5 — Sincronização e Multi-SKARAB**

#### Objetivos
- Garantir coerência temporal e distribuição de carga

#### Tarefas

- Distribuição de clock
- Sincronização (PPS / GPSDO / White Rabbit)
- Alinhamento de timestamps
- Distribuição de canais entre placas

:::

:::{warning} **6 — Controle e Infraestrutura**

#### Objetivos
- Garantir operação reprodutível e controlada

#### Tarefas

- Upload de bitstream via `progska`
- Upload via `casperfpga`
- Containerização do ambiente
- Migração para Python > 3.8

#### DevOps

- Versionamento de bitstreams
- Registro de parâmetros de build
- Logging e monitoramento

:::

:::{warning} **7 — Validação**

#### Objetivos
- Garantir consistência entre modelo e hardware

#### Tarefas

- Testbench automatizado
- Modelo de referência em Python (NumPy)
- Comparação FPGA vs modelo
- Injeção de sinais sintéticos

:::

:::{warning} **8 — Hardware Bring-up**

#### Objetivos
- Validação em hardware real

#### Tarefas

- Loopback interno
- Teste com tone generator
- Snapshots via CASPER
- Verificação espectral
:::

:::{warning} **9 — Bitstream BINGO**

#### Objetivos
- Implementação final científica

#### Requisitos

- Pipeline DSP validado
- Sistema digital funcional

:::

:::{warning} **10 — Sistema Distribuído**

#### Objetivos
- Integração de múltiplas SKARABs

#### Tarefas

- Balanceamento de carga
- Distribuição de dados
- Análise de throughput

:::

:::{warning} **11 — Sistema Científico**

#### Objetivos
- Tradução dos requisitos científicos em sistema operacional

#### Tarefas

- Definição de requisitos científicos
- Tradução para requisitos digitais
- Pipeline de ingestão

#### Formato de dados

- HDF5
  - Estrutura com:
    - frequência
    - tempo
    - polarização
    - metadados

:::

### Roadmap de Desenvolvimento SKARAB

```{mermaid}
gantt
title Roadmap SKARAB — Execução Paralela
dateFormat  YYYY-MM-DD
axisFormat  %m/%d

section Fase 0 — Ambiente
Ambiente hven           :done,    f0a, 2026-04-01, 5d
Ambiente uirapuru       :done,    f0b, 2026-04-01, 5d

section Fase 1 — Fundamentos
Tutorial CASPER         :active,  f1, after f0a, 10d

section Fase 2 — Modelagem de Sinal
ADC + Ruído + RFI       :         f2a, after f1, 12d
Gain + DC removal       :         f2b, after f1, 10d

section Fase 3 — DSP Core
FFT + Leakage           :         f3a, after f2a, 10d
Windowing               :         f3b, after f3a, 5d
Fixed-point strategy    :         f3c, after f2b, 10d
Decimação + FIR         :         f3d, after f3a, 10d
Dynamic Range / SFDR    :         f3e, after f3c, 8d

section Fase 4 — Sistema Digital
Timestamping            :         f4a, after f3a, 8d
Packetização            :         f4b, after f3d, 10d
Channel Selection       :         f4c, after f3d, 8d

section Fase 5 — Multi-SKARAB
Clock + Sync            :crit,    f5a, after f4a, 12d
Distribuição de carga   :         f5b, after f4b, 10d

section Fase 6 — Controle
Container + progska     :         f6a, after f0b, 10d
casperfpga API          :         f6b, after f6a, 10d
Python > 3.8            :         f6c, after f6a, 12d

section Fase 7 — Validação
Testbench Python        :         f7a, after f3a, 12d
Comparação FPGA         :         f7b, after f7a, 10d

section Fase 8 — Hardware
Loopback + Snapshots    :         f8a, after f4a, 10d
Teste com sinal real    :         f8b, after f8a, 10d

section Fase 9 — Bitstream BINGO
Integração final        :         f9, after f5a, 15d

section Fase 10 — Sistema Distribuído
Multi-SKARAB pipeline   :         f10, after f9, 15d

section Fase 11 — Sistema Científico
Ingestão + formato      :         f11a, after f10, 12d
Validação científica    :         f11b, after f11a, 10d
```