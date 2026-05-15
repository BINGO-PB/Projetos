# Comparação das decisões tomadas

| Telescópio                       | Faixa            | Receptor                     | Backend digital    | Modos principais de observação                                                          | Especialidades                |
| -------------------------------- | ---------------- | ---------------------------- | ------------------ | --------------------------------------------------------------------------------------- | ----------------------------- |
| FAST                             | 70 MHz – 3 GHz   | 19-beam criogênico, wideband | FPGA + GPU         | Drift scan, pulsar timing, FRB search, spectral line, continuum, beamforming            | Pulsars, FRBs, HI cosmológico |
| Green Bank Telescope             | 0.1 – 116 GHz    | Multi-band criogênico        | VEGAS, GUPPI       | Position switching, frequency switching, OTF mapping, pulsar timing, VLBI, spectroscopy | Plataforma universal          |
| Parkes Observatory               | 0.7 – 26 GHz     | UWL + multibeam + PAF        | FPGA/GPU           | FRB triggering, pulsar timing, multibeam survey, continuum scan, transient buffering    | FRBs e surveys rápidos        |
| Sardinia Radio Telescope         | 0.3 – 115 GHz    | Multi-focus criogênico       | FFTS + VLBI        | OTF mapping, spectroscopy, VLBI, radar astronomy, pulsars                               | Alta flexibilidade            |
| Effelsberg 100-m Radio Telescope | 300 MHz – 96 GHz | Multi-band                   | FFT FPGA           | Spectral line, VLBI, pulsar timing, continuum mapping                                   | VLBI europeu                  |
| IRAM 30m Telescope               | 80 – 280 GHz     | SIS heterodyne EMIR          | Correlators FFT    | Frequency switching, wobbler switching, OTF molecular mapping, polarization             | Astroquímica                  |
| Large Millimeter Telescope       | 70 – 350 GHz     | SIS mixers                   | FPGA spectrometers | Spectral surveys, continuum mapping, OTF scans                                          | mm/sub-mm                     |
| Atacama Pathfinder Experiment    | 200 – 1500 GHz   | SIS + HEB                    | XFFTS              | Raster mapping, line surveys, atmospheric windows THz                                   | sub-mm/THz                    |
| Yebes 40m Radio Telescope        | 2 – 116 GHz      | Q/W-band criogênico          | Wideband FFTS      | Spectroscopy, molecular surveys, frequency switching                                    | Astroquímica                  |
| Nançay Radio Telescope           | 1 – 3.5 GHz      | Pulsar optimized feeds       | NUPPI              | Pulsar timing, dedispersion, transient search                                           | Física de pulsars             |



| Telescópio                       | Banda instantânea típica   | Nº de canais espectrais | Arquitetura           | Formato de dados          | Packetização    | Tratamento de RFI                          |
| -------------------------------- | -------------------------- | ----------------------: | --------------------- | ------------------------- | --------------- | ------------------------------------------ |
| FAST                             | até ~1 GHz por polarização |                4k – 1M+ | FPGA + GPU cluster    | VDIF, PSRFITS, filterbank | 10/40/100 GbE   | excisão temporal/frequencial, ML FRB/RFI   |
| Green Bank Telescope             | até 8 GHz                  |           32k – milhões | VEGAS FPGA + HPC      | FITS, GUPPI raw           | SPEAD, UDP      | thresholding, kurtosis, adaptive filtering |
| Parkes Observatory               | ~4 GHz UWL                 |                16k – 1M | FPGA + GPU            | SIGPROC filterbank        | Ethernet UDP    | FRB classifiers, dynamic masking           |
| Sardinia Radio Telescope         | centenas MHz – GHz         |               8k – 128k | FPGA FFTS             | FITS/VLBI                 | VDIF            | spectral excision                          |
| Effelsberg 100-m Radio Telescope | ~500 MHz – GHz             |              16k – 256k | FPGA spectrometers    | FITS                      | Ethernet        | median filtering                           |
| IRAM 30m Telescope               | ~4–32 GHz IF               |             até milhões | autocorrelator + FFTS | CLASS/FITS                | internal fabric | baseline/RFI subtraction                   |
| Atacama Pathfinder Experiment    | GHz-class IF               |           32k – milhões | XFFTS FPGA            | FITS                      | Ethernet        | narrowband excision                        |
| Nançay Radio Telescope           | centenas MHz               |                1k – 64k | NUPPI FPGA/GPU        | PSRFITS                   | UDP             | pulsar-aware excision                      |



| Sistema                           | Banda instantânea         |     Nº canais | Arquitetura backend    | Formato de dados                       | Packetização    | Estratégias RFI                |
| --------------------------------- | ------------------------- | ------------: | ---------------------- | -------------------------------------- | --------------- | ------------------------------ |
| FAST                              | ~500 MHz–1 GHz            |      4k – 1M+ | FPGA + GPU cluster     | PSRFITS, filterbank                    | 40/100 GbE      | ML + spectral masking          |
| Green Bank Telescope              | até 8 GHz                 | 32k – milhões | VEGAS + GUPPI          | FITS, raw baseband                     | SPEAD/UDP       | kurtosis + adaptive            |
| Parkes Observatory                | até 4 GHz                 |      16k – 1M | FPGA/GPU               | SIGPROC                                | UDP             | FRB classifiers                |
| MeerKAT                           | até 856 MHz por sub-banda |      32k – 4M | FX correlator FPGA/GPU | SPEAD, HDF5, MeerKAT Visibility Format | 40/100 GbE      | real-time flagging + AOFlagger |
| Arecibo Observatory + GUPPI/PUPPI | até ~800 MHz              |     1k – 512k | FPGA + CPU/GPU         | PSRFITS, filterbank                    | 10 GbE          | pulsar-aware excision          |
| Sardinia Radio Telescope          | centenas MHz–GHz          |     8k – 128k | FPGA FFTS              | FITS/VLBI                              | VDIF            | spectral excision              |
| IRAM 30m Telescope                | ~4–32 GHz IF              |   até milhões | FFTS/autocorrelator    | CLASS/FITS                             | internal fabric | baseline subtraction           |


| Telescópio | Diâmetro    | Frequência        |
| ---------- | ----------- | ----------------- |
| FAST       | 500 m       | 70 MHz – 3 GHz    |
| GBT        | 100 m       | 0.1 – 116 GHz     |
| Parkes     | 64 m        | 0.7 – 26 GHz      |
| MeerKAT    | 64 × 13.5 m | 580 MHz – 3.5 GHz |
| Arecibo    | 305 m       | ~300 MHz – 10 GHz |
| SRT        | 64 m        | 0.3 – 115 GHz     |
| Effelsberg | 100 m       | 300 MHz – 96 GHz  |
| IRAM 30m   | 30 m        | 80 – 280 GHz      |


| Telescópio | Diâmetro    | Frequência        |
| ---------- | ----------- | ----------------- |
| FAST       | 500 m       | 70 MHz – 3 GHz    |
| GBT        | 100 m       | 0.1 – 116 GHz     |
| Parkes     | 64 m        | 0.7 – 26 GHz      |
| MeerKAT    | 64 × 13.5 m | 580 MHz – 3.5 GHz |
| Arecibo    | 305 m       | ~300 MHz – 10 GHz |
| SRT        | 64 m        | 0.3 – 115 GHz     |
| Effelsberg | 100 m       | 300 MHz – 96 GHz  |
| IRAM 30m   | 30 m        | 80 – 280 GHz      |


| Técnica                   | Uso típico                     |
| ------------------------- | ------------------------------ |
| Spectral Kurtosis (SK)    | detecção estatística de RFI    |
| Adaptive Filtering        | cancelamento usando referência |
| Time-domain blanking      | pulsos impulsivos              |
| Thresholding FPGA         | detecção rápida                |
| Polyphase Filter Banks    | canalização robusta            |
| Cyclostationary detection | sinais telecom                 |
| Deep learning acelerado   | ainda experimental             |
| Real-time flagging        | pipelines CASPER               |


| Requisito                        | Impacto no backend            |
| -------------------------------- | ----------------------------- |
| altíssima estabilidade espectral | FFT/PFB muito limpos          |
| integração longa                 | RFI precisa ser removido cedo |
| banda larga                      | FPGA de alta taxa             |
| dynamic range alto               | ADCs melhores                 |
| foreground subtraction           | resposta instrumental estável |
| data rate enorme                 | packetization + GPUs          |



ADC
 ↓
FPGA Front-End
    ├─ DDC
    ├─ PFB
    ├─ FFT
    ├─ RFI detection
    ├─ Spectral Kurtosis
    └─ Packetizer
 ↓
100GbE
 ↓
GPU Cluster
 ↓
Correlation / Beamforming
 ↓
HI Mapping Pipeline

ADC
 ↓
Channelizer
 ↓
PFB
 ↓
FFT
 ↓
RFI Detector
 ↓
Flagging
 ↓
Integration
 ↓
Packetizer
 ↓
GPU correlator
 ↓
Map maker

| FFT    | Uso            |
| ------ | -------------- |
| 1024   | básico         |
| 4096   | comum          |
| 8192   | HI             |
| 16384+ | alta resolução |


| Experimento        | FFT típica    |
| ------------------ | ------------- |
| CHIME              | 1024–4096 PFB |
| HERA               | 4096          |
| BINGO              | 4096–8192     |
| FAST               | 16384+        |
| SETI spectrometers | 65536+        |


| Taps | Uso              |
| ---- | ---------------- |
| 2    | simples          |
| 4    | padrão           |
| 8    | alta performance |
| 16   | raro             |


# 4. Como funciona overlap no PFB (Polyphase Filter Bank)

O overlap no PFB é uma das ideias mais importantes em spectrometers modernos.

Sem overlap:

* a FFT “corta” o sinal em blocos,
* gera leakage espectral,
* produz sidelobes altos,
* e degrada observações HI.

O PFB resolve isso usando:

* FIR filtering
* overlap temporal
* windowing contínuo

---

# Intuição

## FFT pura

A FFT assume:

```text id="jlwm8u"
janela finita
```

Isso equivale a multiplicar o sinal por uma janela retangular.

No domínio da frequência:

* isso gera sinc sidelobes.

Resultado:

* energia “vaza” entre canais.

---

# PFB resolve isso

Em vez de:

```text id="j9kq7m"
FFT(bloco bruto)
```

fazemos:

```text id="jjlq5p"
Filtro FIR
+
FFT overlapada
```

---

# Estrutura do PFB

## Exemplo: 4-tap PFB

Para uma FFT de:

[
N = 1024
]

o FIR total tem:

[
4 \times 1024 = 4096
]

coeficientes.

---

# O overlap

Os blocos não são independentes.

Eles compartilham amostras.

---

## FFT comum

```text id="6tb0jh"
|----1024----|
             |----1024----|
```

Sem overlap.

---

## PFB

```text id="7gtg9g"
|----4096----|
      |----4096----|
```

Agora:

* cada FFT usa amostras anteriores,
* criando continuidade espectral.

---

# Decomposição polyphase

O FIR gigante é dividido em fases:

```text id="d7qmqe"
h0[n]
h1[n]
h2[n]
h3[n]
```

Cada fase alimenta:

* um canal FFT.

---

# Fluxo real

```text id="6w6jlr"
ADC stream
 ↓
Shift register
 ↓
Polyphase FIR
 ↓
Decimation
 ↓
FFT
 ↓
Channels
```

---

# Por que isso melhora tanto?

Porque o FIR:

* suaviza bordas temporais,
* reduz leakage,
* melhora channel isolation.

---

# Resposta espectral

## FFT pura

Sidelobes típicos:

[
-13\text{ dB}
]

Ruim.

---

## PFB 4-tap

Pode chegar:

[
-50\text{ dB}
]

ou melhor.

---

# Isso é CRÍTICO em HI cosmology

Porque foregrounds são MUITO maiores que o sinal HI.

Você precisa:

* canais extremamente limpos,
* estabilidade espectral alta,
* pouca mistura entre bins.

---

# Overlap-save vs overlap-add

Em FPGA radio astronomy:

* normalmente usa-se implementação polyphase streaming,
* parecida com overlap-save.

---

# Custos do overlap

Mais overlap significa:

| Benefício           | Custo         |
| ------------------- | ------------- |
| menos leakage       | mais DSP      |
| melhor isolamento   | mais BRAM     |
| melhor estabilidade | mais latência |

---

# Quantos taps usar?

## Regra prática

| Taps | Uso              |
| ---- | ---------------- |
| 2    | simples          |
| 4    | padrão           |
| 8    | alta performance |
| 16   | raro             |

---

# Em radio astronomy

Normalmente:

```text id="jkr5tv"
4-tap PFB
```

é o sweet spot.

---

# Implementação FPGA

Você precisa:

* shift RAM,
* FIR pipelines,
* complex multipliers,
* FFT streaming.

---

# Recursos FPGA

## Exemplo 4096 FFT + 4-tap

Você precisará:

* MUITOS DSP48,
* bastante BRAM,
* clock pipeline profundo.

---

# CASPER PFB

CASPER já possui:

* blocos prontos,
* streaming pipelines,
* integração Ethernet.

---

# Artigo importante

## Harris (clássico)

*Harris, F. J. (1978). On the use of windows for harmonic analysis with the discrete Fourier transform.*

Fundamental para entender leakage/windowing.

---

# Visualmente

## FFT pura

```text id="a3jlwm"
|    |    |    |
```

Muito leakage.

---

## PFB

```text id="6a90db"
|_| |_| |_| |_|
```

Canais muito mais isolados.

---

# 5. Latência completa de um spectrometer FPGA

A latência total é:

[
T_{total} =
T_{ADC}
+
T_{PFB}
+
T_{FFT}
+
T_{RFI}
+
T_{integration}
+
T_{network}
]

---

# Componentes típicos

# 1. ADC latency

Tipicamente:

```text id="bbd6eu"
10–100 ns
```

---

# 2. PFB latency

Grande contribuição.

Porque:

* FIR profundo,
* pipelines,
* overlap.

Tipicamente:

```text id="ub0x7i"
1–10 µs
```

---

# 3. FFT latency

Streaming FFT:

```text id="ybl1el"
~N clock cycles
```

---

## Exemplo

4096 FFT @ 250 MHz:

[
\frac{4096}{250\text{ MHz}}
\approx 16 \mu s
]

---

# 4. Power accumulation

Pequena:

```text id="z7xgmg"
100 ns – 1 µs
```

---

# 5. RFI detector

## Thresholding

Muito rápido.

---

## Spectral Kurtosis

Maior:

* acumuladores,
* divisões,
* pipelines.

Pode adicionar:

```text id="4w3e9n"
10–100 µs
```

---

# 6. Integration

A maior latência geralmente.

Exemplo:

```text id="v4vuzs"
10 ms integration
```

Então:

* saída aparece 10 ms depois.

---

# 7. Ethernet

10GbE:

* poucos µs.

---

# Exemplo completo real

## Backend HI

```text id="tmvzh3"
ADC:             50 ns
PFB:             5 µs
FFT:             15 µs
SK detector:     20 µs
Accumulator:     5 µs
Integration:     10 ms
Ethernet:        5 µs
```

Total:

[
\approx 10.05\text{ ms}
]

---

# Para RFI real-time

Às vezes:

* integração é curta,
* 100 µs–1 ms.

---

# Para cosmologia HI

Normalmente:

* integração longa,
* segundos até minutos offline.

---

# Throughput vs latency

Importante:

Radio astronomy normalmente prioriza:

```text id="h9t4r4"
throughput
```

não latência mínima.

---

# Pipeline streaming

Tudo roda continuamente:

```text id="0bz5qy"
sample in every clock
```

---

# Onde timing closure quebra

Normalmente:

## 1. PFB multipliers

---

## 2. FFT routing

---

## 3. SK divisions

---

## 4. Ethernet CDC

---

# Dica prática MUITO importante

Primeiro faça:

```text id="jlwmg4"
ADC
→ FFT
→ Power
```

Depois:

* adicione PFB,
* depois SK,
* depois Ethernet.

---

# Papers MUITO úteis

## Magro et al. 2014

GPU/FPGA backend:
[https://arxiv.org/pdf/1401.8258](https://arxiv.org/pdf/1401.8258)

---

## Thompson 2014

RFI mitigation:
[https://scholar.sun.ac.za/bitstream/10019.1/86637/1/thompson_rfi_2014.pdf](https://scholar.sun.ac.za/bitstream/10019.1/86637/1/thompson_rfi_2014.pdf)

---

## Melis 2016

Wideband instrumentation:
[https://iris.unica.it/bitstream/11584/266747/1/PhD_Thesis_Andrea_Melis.pdf](https://iris.unica.it/bitstream/11584/266747/1/PhD_Thesis_Andrea_Melis.pdf)

---

## Finger et al. 2018

Adaptive filter FPGA:
[https://arxiv.org/pdf/1805.06376](https://arxiv.org/pdf/1805.06376)

---

![ScholarGPT](https://r2.gptseek.com/pin_review_scholar.png)


| Aspecto        | CHIME                     | FAST                          |
| -------------- | ------------------------- | ----------------------------- |
| Tipo           | interferômetro cilíndrico | single dish gigante           |
| Local          | Canadá                    | China                         |
| Diâmetro       | 4 cilindros               | 500 m                         |
| Backend        | FPGA + GPU massivo        | FPGA spectrometers            |
| Beamforming    | FFT beamforming           | feeds múltiplos               |
| Correlator     | enorme                    | menor                         |
| RFI mitigation | agressiva                 | crítica                       |
| Objetivo       | cosmologia + FRBs         | HI profundo + surveys         |
| Throughput     | extremo                   | alto                          |
| Arquitetura    | packetized DSP            | spectrometer clássico moderno |


| Aspecto        | CHIME          | FAST         |
| -------------- | -------------- | ------------ |
| Arquitetura    | interferômetro | single dish  |
| FPGA role      | channelizer    | spectrometer |
| GPU dependence | enorme         | moderada     |
| Correlator     | massivo        | pequeno      |
| Beamforming    | FFT            | feeds        |
| PFB            | agressivo      | agressivo    |
| FFT size       | médio          | grande       |
| RFI complexity | extrema        | alta         |
| Throughput     | monstruoso     | alto         |
| Sensibilidade  | média          | extrema      |


| Aspecto                  | CHIME          | FAST          | GBT           |
| ------------------------ | -------------- | ------------- | ------------- |
| Tipo                     | interferômetro | single dish   | single dish   |
| Beamforming              | FFT            | limitado      | limitado      |
| FPGA role                | massivo        | spectrometer  | spectrometer  |
| GPU dependence           | enorme         | moderada      | moderada      |
| Backend famoso           | CHIME DSP      | FAST backend  | VEGAS         |
| Flexibilidade            | média          | média         | altíssima     |
| RFI mitigation           | extrema        | alta          | alta          |
| CASPER                   | sim            | parcial       | fortíssimo    |
| Melhor para estudar FPGA | correlators    | sensibilidade | spectrometers |


Minha sugestão de caminho de estudo
Etapa 1

Entenda:

FFT spectrometers,
PFB,
SK.
Etapa 2

Entenda:

CASPER,
packetized DSP,
Ethernet streaming.
Etapa 3

Entenda:

correlators,
beamforming,
GPU pipelines.
Etapa 4

Construa:

mini spectrometer RFSoC.


| Módulo        | Função         |
| ------------- | -------------- |
| ADC interface | captura        |
| CIC/DDC       | downconversion |
| FIR/PFB       | filtering      |
| FFT           | channelization |
| Power         | spectra        |
| SK            | RFI detection  |
| Accumulator   | integração     |
| UDP core      | rede           |


| Aspecto           | CASPER FFT          | Xilinx FFT IP        |
| ----------------- | ------------------- | -------------------- |
| Filosofia         | rádio astronomia    | DSP genérico         |
| Integração        | CASPER toolflow     | Vivado IP            |
| Flexibilidade     | altíssima           | alta                 |
| Facilidade        | muito boa no CASPER | muito boa no Vivado  |
| Performance bruta | boa                 | excelente            |
| Controle interno  | aberto              | parcialmente fechado |
| RFSoC             | razoável            | excelente            |
| PFB integration   | natural             | manual               |
| Packetized DSP    | natural             | manual               |
| Timing closure    | mais difícil        | melhor otimizado     |
| Uso científico    | enorme              | enorme               |


| Grupo               | Estado                 |
| ------------------- | ---------------------- |
| SARAO               | migração significativa |
| MeerKAT             | moderno                |
| CHIME               | stack próprio moderno  |
| HERA                | híbrido                |
| Breakthrough Listen | moderno                |
| GBT                 | híbrido legacy/moderno |


| Nível              | Exemplo              |
| ------------------ | -------------------- |
| FPGA local         | AXI-Stream           |
| FPGA ↔ FPGA        | Ethernet/UDP         |
| FPGA ↔ GPU cluster | UDP/RDMA             |
| Controle           | KATCP/TCP            |
| Timing             | White Rabbit/PTP/PPS |
