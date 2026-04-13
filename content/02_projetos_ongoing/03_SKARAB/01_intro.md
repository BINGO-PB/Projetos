# BINGO Skarab PB

:::{admonition} # Project
:class: alert
[GitHub Project Link](https://github.com/orgs/BINGO-PB/projects/5)
:::

## Problem Description

The SKARAB (Square Kilometer Array Reconfigurable Application Board) is a superscale FPGA-based computing platform, designed by Peralex Electronics in South Africa, in collaboration with SARAO for radio astronomy. It is the successor to ROACH2, focused on high performance, low latency, and digital signal processing.

![SKARAB Diagram](../../00_images/skarab_esquema.png)

This device will be used as the BINGO backend. It is necessary to:
- Determine the signal processing required to achieve BINGO's science objective, namely cosmological observations of neutral hydrogen and transient phenomena.
- Determine data transport from SKARAB to a controller computer.
- Build a pipeline on the controller to ingest SKARAB data, control its behavior, and transmit data downstream.

## History

:::{admonition} **Team**
:class: alert dropdown

- UFCG
    - Luciano Barosi
    - Jordany Vieira
    - Tales
    - Gutemberg
    - DEE Student
    - João Vitor
- CHINA
    - Hector
- INPE
    - Cesar Strauss
    - Jorge
::: 

### Hardware

SKARAB BOARD
- FPGA Virtex-7 XC7VX690T
  - 690,000 logic cells
  - 3,600 DSP blocks
  - 53 Mb RAM
- ADC TI ADC32RF45
  - 14 bits
  - 3 GSps
- QSFP+ 40 GbE

:::{admonition} **Science Requirements**
:class: important dropdown

#### Instrument

- FWHM
$$\theta = 40 \;\mathrm{arcmin}$$
- Bandwith
$$ 980 \;\mathrm{Mhz} \ge \nu \ge 1260 \;\mathrm{Mhz}$$
- Central Frequency: 
$$1100 \;\mathrm{Mhz}$$
* λ ≈ 0.27 m
- Effective Area
$$
\theta \approx 1.2 \frac{\lambda}{D} \Rightarrow D \approx 40 \;\text{m} \\
\eta = 0.7 \\
A_{\text{eff}} \approx \eta \frac{\pi D^2}{4} \approx 0.7 \times 1256 \approx 880 \, \text{m}^2
$$
- System Temperature
$$
T_{Sys} = 40 \,\text{K}
$$
- Integration Time
$$
\tau = 1s
$$
---

#### Sky Temperature

Considering synchroton radiation:

$$
T \propto \nu^{-2.6}
$$

| Region                  | (T_A)        |
| ----------------------- | ------------ |
| high galacyiv latitude | **~3 K**     |
| low galactc latitude        | **~15–25 K** |

---


#### SEFD 

$$
SEFD = \frac{2k T_{\text{sys}}}{A_{\text{eff}}}
$$

| Region                  | SEFD        |
| ----------------------- | ------------ |
| high galacyiv latitude | **130**     |
| low galactc latitude        | **180 K** |

---

#### Sensitivity

$$
\Delta S = \frac{SEFD}{\sqrt{B \tau}}
$$

| Region                  | $\Delta S$        |
| ----------------------- | ------------ |
| high galacyiv latitude | $\approx 8\;mJy$     |
| low galactc latitude        | $\approx 11\;mJy$ |


#### Galactic Foreground 

$$
S = \frac{2kT_A}{A_{\text{eff}}}
$$

| Region                  | $ S$        |
| ----------------------- | ------------ |
| high galactic latitude | $\approx 10\;Jy$     |
| low galactic latitude        | $\approx 65\;Jy$ |
---

#### Spectral Resolution

| Canais | Δν      |
| ------ | ------- |
| 4096   | ~68 kHz |
| 8192   | ~34 kHz |

---

#### Channel Sensitivity

$$
\Delta S = \frac{SEFD}{\sqrt{\Delta\nu \tau}}
$$



- Minimum detectable signal (5σ)

| Configuração | Detectável    |
| ------------ | ------------- |
| 4096 canais  | ~2.5 – 3.5 Jy |
| 8192 canais  | ~3.5 – 5 Jy   |

---

#### Quantization

$$
DR \approx 6.02N  + 1.76
$$

| Bits | Dynamic Range (dB) | Níveis | DR linear  |
| ---- | ------------------ | ------ | ---------- |
| 12   | ~74 dB             | 4096   | ~1.6 × 10⁴ |
| 14   | ~86 dB             | 16384  | ~6.5 × 10⁴ |
| 16   | ~98 dB             | 65536  | ~2.6 × 10⁵ |


:::


### Available code

- GITHUB repository: https://github.com/BINGO-PB/BINGO_SKARAB_AI
  - This repository contains firmware and control scripts for the SKARAB platform used in the BINGO (Baryon Oscillation Spectroscopic Survey) radio telescope project. The firmware is designed to work with the SKARAB (Square Kilometre Array Reconfigurable Application Board) platform equipped with Virtex-7 FPGA and ADC mezzanine cards.
- GITHUB repository: https://github.com/BINGO-PB/bingo_skarab
  - This repository allows creating containers for developing a SKARAB control system with different library versions.

### Current best configuration

- spectrometer:
  - BW: 187.5 Mhz
  - channels: 32768
  - UDP
  - 40GB

## Challenges Encountered

## Action Plan

## Work Organization Decisions

:::{admonition} **Computers**
- **hven**: machine where *Matlab* and *Vivado* will be installed for bitstream development.
- **uirapuru**: dual boot Ubuntu 16.04 + Python 2.7, connected to SKARAB for control system development.
:::

:::{admonition} **Workflow**
- Stage 0/1 meetings - Tuesday 09:00 - ZOOM
- bi-weekly online alignment meetings
- 1-1 interactions for development and task completions
- Weekly individual short updates of progress and/or difficulties kept in GitHub.
- Task completion with small report, including validation procedure and fullfilment of requirements.
:::

### RoadMap 

:::{seealso} **Phase 0 — Computer Set Up**
:class: dropdown

#### Objectives
- Development environment setup
- Execution of basic CASPER examples

#### Tasks

- Environment setup on *hven*
  - Team: Tales + Arthur
  - Milestone: running `casper_fft.slx`

- Environment setup on *uirapuru*
  - Team: Tales + João Vitor
  - Milestone: CASPER tutorial 2

:::

:::{seealso} **Phase 1 — CASPER Fundamentals**
:class: dropdown

#### Objectives
- Team leveling
- Understanding CASPER + FPGA architecture

#### Tasks

- CASPER Tutorial 4
  - Milestone: Waterfall diagram

#### Essential Content

- FPGA Architecture (DSP slices, BRAM, routing)
- Fixed-point representation
- Processing pipeline
:::

:::{warning} **2 — Signal Modeling**
:class: dropdown

#### Objectives
- Build realistic models before hardware

#### Tasks

- ADC modeling
- Noise modeling
- RFI modeling
- Gain control (gain staging)
- DC removal

:::

:::{warning} **3 — DSP Core (FFT Pipeline)**
:class: dropdown

#### Objectives
- Spectrometer development in Simulink

#### Tasks

1. FFT
   - Aliasing
   - Scalloping loss
   - Spectral leakage

2. Windowing

3. Fixed-point strategy
   - Bit-width definition
   - Overflow policy (wrap vs saturate)

4. Decimation

5. FIR Filters

6. Dynamic Range and SFDR

7. Saturation and non-linearities

:::

:::{warning} **4 — Digital System**
:class: dropdown

#### Objectives
- Transform the DSP into a functional embedded system

#### Tasks

- Timestamping
- Packetization (40 GbE)
- Channel selection
- Buffering

:::

:::{warning} **5 — Synchronization and Multi-SKARAB**
:class: dropdown

#### Objectives
- Ensure temporal coherence and load distribution

#### Tasks

- Clock distribution
- Synchronization (PPS / GPSDO)
- Timestamp alignment
- Channel distribution across boards (probably not necessary)

:::

:::{warning} **6 — Control and Infrastructure**
:class: dropdown

#### Objectives
- Preparation for full pipeline development.

#### Tasks

- Bitstream upload via `progska`
- Upload via `casperfpga`
- Environment containerization
- Migration to Python > 3.8

#### DevOps

- Bitstream versioning
- Build parameter logging
- Logging and monitoring

:::

:::{warning} **7 — Validation**
:class: dropdown

#### Objectives
- Ensure consistency between model and hardware

#### Tasks

- Automated testbench
- Reference model in Python (NumPy)
- FPGA vs model comparison
- Synthetic signal injection

:::

:::{warning} **8 — Scientific System**
:class: dropdown

#### Objectives
- Translating scientific requirements into an operational system

#### Tasks

- Scientific requirements definition
- Translation to digital requirements
- Ingestion pipeline

#### Data Format

- HDF5
  - Structure with:
    - frequency
    - time
    - polarization
    - metadata

#### Data Transport
  - UDP, SPEAD, ...
  - metadata
:::

:::{warning} **9 — Hardware Bring-up**
:class: dropdown

#### Objectives
- Validation on real hardware

#### Tasks

- Internal loopback
- Test with tone generator
- Spectral verification
:::

:::{warning} **10 — BINGO Spectrometer**
:class: dropdown

#### Objectives
- Final scientific implementation

#### Requirements

- Validated DSP pipeline
- Functional digital system

:::

:::{warning} **11 — Scientific System**
:class: dropdown

#### Objectives
- Translating scientific requirements into an operational system

#### Tasks

- Scientific requirements definition
- Translation to digital requirements
- Ingestion pipeline

#### Data Format

- HDF5
  - Structure with:
    - frequency
    - time
    - polarization
    - metadata

#### Data Transport
  - UDP, SPEAD, ...
  - metadata
:::

:::{warning} **12 — BINGO Pseudo Correlator**
:class: dropdown

- 4 signals for each Skarab, 2 colfet and 2 polarizations.
:::


:::{warning} **13 — Use Case**
:class: dropdown

- Pulsar Search
:::


:::{warning} **14 — Time Domain**
:class: dropdown

- Assess the need to develop a time domain pipeline, for higher information during comissioning.
:::

:::{warning} **15 — Use Case - Transient + Cosmology**
:class: dropdown

- Realtime transient detection in `ms` data with buffer redirecting to further time integration or dedicated analysis of data segment. 
:::


## Roadmap Task Graph (Tentative)

```mermaid
flowchart TD
  F0["Fase 0 — Setup"]:::setup --> F1

  F1["Fase 1 — Fundamentos CASPER"]:::base

  F1 --> F2 & F3 & F6 & F8

  subgraph parallel1 ["Paralelo: Modelagem + DSP"]
    F2["Fase 2 — Modelagem de Sinal"]:::dsp
    F3["Fase 3 — DSP Core · Pipeline FFT"]:::dsp
    F2 --> F3
  end

  F3 --> F4
  F4["Fase 4 — Sistema Digital"]:::digital

  subgraph parallel2 ["Paralelo: Sincronização + Validação + Controle"]
    F5["Fase 5 — Sincronização Multi-SKARAB"]:::digital
    F7["Fase 7 — Validação"]:::digital
    F6["Fase 6 — Controle e Infraestrutura"]:::infra
  end

  F4 --> F5 & F7
  F6 --> F9

  F8["Fase 8 — Sistema Científico"]:::science

  F5 --> F9
  F7 --> F9
  F8 --> F10

  F9["Fase 9 — Hardware Bring-up"]:::hw

  F9 --> F10["Fase 10 — Espectrômetro BINGO"]:::final

  subgraph usecases ["Casos de Uso (paralelos)"]
    F12["Fase 12 — Pseudo Correlator"]:::uc
    F13["Fase 13 — Pulsar Search"]:::uc
    F14["Fase 14 — Time Domain"]:::uc
    F15["Fase 15 — Transient + Cosmology"]:::uc
  end

  F10 --> F12 & F13 & F14 & F15

  classDef setup  fill:#EEEDFE,stroke:#534AB7,color:#26215C
  classDef base   fill:#E1F5EE,stroke:#0F6E56,color:#04342C
  classDef dsp    fill:#E6F1FB,stroke:#185FA5,color:#042C53
  classDef digital fill:#FAEEDA,stroke:#854F0B,color:#412402
  classDef infra  fill:#FAECE7,stroke:#993C1D,color:#4A1B0C
  classDef science fill:#EAF3DE,stroke:#3B6D11,color:#173404
  classDef hw     fill:#FBEAF0,stroke:#993556,color:#4B1528
  classDef final  fill:#534AB7,stroke:#26215C,color:#EEEDFE
  classDef uc     fill:#F1EFE8,stroke:#5F5E5A,color:#2C2C2A
```