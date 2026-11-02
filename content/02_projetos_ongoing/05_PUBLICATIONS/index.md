# Publications

## **PAPER** Uirapuru First Light: A Testbed for the BINGO Radiotelescope

:::{admonition} Abstract
:class: alert dropdown

| **Info** | **Choice** | **extra** |
|----------|------------|-----------|
| **journal** | [Journal of Astronomical Instrumentation](https://www.worldscientific.com/worldscinet/jai) | |
| **journal** | [RAS Techniques and Instruments](https://academic.oup.com/rasti/issue/volume/5) | |
| **repository** | | |
| **overleaf** | | |
| **author** | | |
| **data** | | |

**Context.** The experimental validation of radio telescope receiving systems requires connecting laboratory measurements of individual components to the radiometric response obtained under actual observing conditions. Uirapuru is a radio telescope developed as an experimental testbed for BINGO (Baryon Acoustic Oscillations from Integrated Neutral Gas Observations), enabling the assessment of receiver performance, calibration procedures, and observational strategies prior to their application to the full instrument.

**Aims.** We present the first-light observations of Uirapuru and a quantitative end-to-end validation of its analogue receiving chain, from the antenna to the digital acquisition system. We investigate the consistency between laboratory characterisation, measured radiometric performance, and simulated astronomical signals, with particular emphasis on receiver noise, system gain, calibration accuracy, and temporal stability.

**Methods.** We characterise the antenna, polarisation components, amplifiers, filters, and RF transmission elements using vector network analysers and spectrum analysers, determining their transmission, reflection, gain, and noise properties. These measurements are combined into a predictive model of the receiving chain. We perform continuous 24-hour observations using a SKARAB FPGA-based spectrometer, with solar radio emission providing an astronomical reference for radiometric calibration. The observed time-ordered spectra are compared quantitatively with sky simulations incorporating the antenna beam, observing geometry, and astrophysical emission. Data are recorded using the BINGO-SDHDF format.

**Results.** Laboratory measurements yield a receiver noise temperature of [TBD: value ± uncertainty] K and an effective receiving-chain gain of [TBD: value ± uncertainty] dB over [TBD: frequency interval] MHz. Solar calibration provides [TBD: calibrated response or conversion factor, with uncertainty], enabling an independent assessment of the end-to-end radiometric response. The 24-hour observations exhibit a gain stability of [TBD: metric and value] and agreement with simulated sky signals at the level of [TBD: quantitative residual or statistical metric]. Comparisons between spectrum-analyser measurements, SKARAB observations, and the predicted RF-chain response quantify the consistency of the laboratory and astronomical characterisations.

**Conclusions.** The Uirapuru first-light campaign establishes a quantitative framework for validating the complete analogue receiving chain of a radio telescope through complementary laboratory and astronomical measurements. The combination of component-level characterisation, solar radiometric calibration, continuous observations, and sky simulations provides an end-to-end assessment of instrumental performance and identifies systematic effects relevant to BINGO commissioning. Detailed descriptions of the Uirapuru architecture, SKARAB firmware and backend characterisation, and BINGO-SDHDF data format are addressed in companion publications.

<!-- ::::{admonition} **ROADMAP**
:class: important dropdown

### 1 Introduction

Motivação para a validação experimental de sistemas de recepção em radioastronomia; contexto do BINGO; papel do Uirapuru como testbed; objetivos e delimitação dos artigos complementares.

Figura: visão geral do Uirapuru e sua relação com o BINGO.

### 2 Receiving System and Measurement Configuration

Descrição sucinta da antena, polarizador, cadeias RF e backend SKARAB. Planos de referência, instrumentação, configurações experimentais, protocolos de medição e incertezas.

Figura: diagrama de blocos com pontos de medição VNA, SA e SKARAB. Tabela: parâmetros operacionais.

### 3 Laboratory Characterisation of the Analogue Frontend

Caracterização quantitativa da antena e dos componentes passivos e ativos. Parâmetros S, perdas, ganhos, figura de ruído, temperatura equivalente e orçamento de ruído da cadeia. Comparação das medidas com as especificações e previsões teóricas.

Figuras: S11/S21, espectros de potência e resposta em frequência. Tabelas: orçamento de ganho e temperatura de ruído.

### 4 Observing Campaign and Solar Radiometric Calibration

Protocolo das 24 horas, condições de observação, medidas de referência, aquisição espectral e procedimentos de calibração. Modelo de fluxo solar, resposta do feixe e conversão entre potência instrumental e temperatura de antena.

Figuras: cronograma de observação, trânsito solar e espectros calibrados. Tabela: fatores de calibração e incertezas.

### 5 Sky Simulations and Observation–Model Comparison

Modelagem da temperatura de antena em função do tempo e frequência, incluindo feixe e geometria observacional. Comparação quantitativa entre os dados observados e simulados, com análise de resíduos, transientes e dependência espectral.

Figuras: waterfall observado/simulado, séries temporais sobrepostas, resíduos e estatísticas de concordância.

### 6 End-to-End Performance and Discussion

Síntese da consistência entre as medidas VNA, SA e SKARAB; desempenho radiométrico, estabilidade temporal, sensibilidade, incertezas e efeitos sistemáticos. Implicações para os procedimentos de comissionamento do BINGO.

Tabela central: comparação entre valores previstos, medidos em laboratório e inferidos das observações, com incertezas.

### 7 Conclusions

Resultados quantitativos principais, grau de validação alcançado, limitações identificadas e aplicabilidade da metodologia ao BINGO.

### Matriz de resultados quantitativos

Esta matriz pode funcionar como checklist para a preparação das figuras e tabelas e, posteriormente, para preencher os valores do abstract.

| Grandeza                              | Instrumento ou método                                         | Comparação principal                                |
| ------------------------------------- | ------------------------------------------------------------- | --------------------------------------------------- |
| Resposta da antena, ganho e casamento | Modelagem eletromagnética, VNA e observações                  | Modelo × medidas                                    |
| S11, S21 e perdas dos passivos        | VNA                                                           | Especificação × medidas                             |
| Ganho espectral da cadeia             | SA e SKARAB                                                   | Orçamento RF × observação                           |
| Temperatura de ruído                  | Medidas hot/cold, SA e SKARAB, conforme calibração disponível | Modelo de ruído × estimativa experimental           |
| Resposta solar                        | SKARAB e modelo de fluxo solar                                | Temperatura de antena prevista × medida             |
| Estabilidade radiométrica             | Série temporal de 24 h                                        | Ganho, deriva e variabilidade                       |
| Temperatura de céu                    | SKARAB e simulações                                           | Séries temporais e espectros observados × simulados |
| Sensibilidade                         | Dados calibrados                                              | Ruído medido × equação radiométrica                 |

:::: -->

:::

## Development of BINGO Digital Backend

:::{admonition} Abstract
:class: alert dropdown

| **Info** | **Choice** | **extra** |
|----------|------------ |-----------|
| **journal** | [Journal of Astronomical Instrumentation](https://www.worldscientific.com/worldscinet/jai) | |
| **journal** | [RAS Techniques and Instruments](https://academic.oup.com/rasti/issue/volume/5) | |
| **repository** | | |
| **overleaf** | | |
| **author** | | |
| **data** | | |

**Context.** Modern radio telescopes require digital backends capable of transforming high-rate radio-frequency signals into calibrated spectral data while maintaining reliable timing, data transport, and instrument control. The BINGO radiotelescope employs a digital acquisition architecture based on the SKARAB FPGA platform, whose configuration and operational procedures must be validated for astronomical observations.

**Aims.** We describe the development and experimental validation of a SKARAB-based digital backend for BINGO, focusing on FPGA firmware, spectrometer configuration, hardware control, high-speed data transmission, and the integrity of acquired spectral products.

**Methods.** We examine the FPGA signal-processing architecture, including analogue-to-digital conversion, channelisation, spectral accumulation, packetisation, and data transmission. The system combines high-throughput 40 GbE data transport with 1 GbE control and management interfaces and UART-based serial communication for diagnostic and recovery operations. We develop software for firmware deployment, register configuration, acquisition control, and monitoring. Laboratory validation uses synthetic signals and controlled RF inputs to investigate spectral response, frequency ordering, numerical precision, integration behaviour, packet integrity, and acquisition stability. We also describe the BINGO-SDHDF data representation and its integration with the acquisition pipeline.

**Results.** The implemented backend provides [TBD: number of RF inputs and spectral products] with [TBD: channelisation configurations] over [TBD: effective bandwidth]. Experimental tests establish [TBD: spectral response and numerical accuracy], [TBD: maximum sustainable data throughput], and [TBD: packet-loss and timing performance]. Measurements with synthetic signals quantify the correspondence between expected and recovered spectral amplitudes, while extended acquisition tests assess firmware and transport reliability. The resulting data products are preserved in BINGO-SDHDF with [TBD: demonstrated metadata and data-integrity properties].

**Conclusions.** The developed backend establishes a configurable digital acquisition and control architecture for BINGO and provides reproducible procedures for validating FPGA-based astronomical spectrometers. The combination of firmware-level verification, controlled signal injection, network performance measurements, and structured data persistence supports the deployment and commissioning of SKARAB-based receiving systems.

:::

## **PAPER** Remarks on simulations of Global Navigation Satellite Signals in Radioastronomy

:::{admonition} Abstract
:class: alert dropdown

| **Info** | **Choice** | **extra** |
|----------|------------|-----------|
| **journal** | [Journal of Astronomical Instrumentation](https://www.worldscientific.com/worldscinet/jai) | |
| **journal** | [RAS Techniques and Instruments](https://academic.oup.com/rasti/issue/volume/5) | |
| **repository** | | |
| **overleaf** | | |
| **author** | | |
| **data** | | |

**Context.** Signals transmitted by Global Navigation Satellite Systems (GNSS) represent a significant source of radio-frequency interference for radio astronomical observations. Accurate predictions of their apparent positions and received power are essential for assessing contamination, planning observations, and developing interference-mitigation strategies. However, different orbital information sources and signal-power models introduce uncertainties that are not always explicitly considered in radio astronomical simulations.

**Aims.** We investigate the accuracy and limitations of GNSS signal simulations for radio astronomy, focusing on satellite position predictions and received-power estimates. We compare orbital information derived from Two-Line Elements (TLEs) and RINEX navigation data and examine the influence of transmitted-power assumptions and published antenna models on predicted interference levels.

**Methods.** We implement satellite trajectory and signal-propagation calculations using components of the RadioSkySim suite. Satellite positions derived from TLE-based propagation are compared with positions computed from broadcast navigation ephemerides obtained through RINEX data. We evaluate differences in apparent direction, range, and observing geometry for representative GNSS constellations. Received-power predictions incorporate propagation losses, satellite equivalent isotropically radiated power, transmitting antenna patterns, and telescope directional response. The results are compared with established GNSS signal models, including those discussed by Montenbruck and collaborators, to assess the sensitivity of interference estimates to modelling assumptions.

**Results.** The comparison reveals [TBD: angular-position differences] and [TBD: range or timing discrepancies] between the orbital prediction approaches over [TBD: prediction intervals and satellite constellations]. Differences in EIRP assumptions and transmitting antenna models produce variations of [TBD: received-power differences in dB] in predicted interference levels. We quantify the resulting uncertainties in antenna-weighted GNSS contamination and identify [TBD: dominant error sources and regimes].

**Conclusions.** GNSS interference simulations are sensitive to both orbital information and transmitted-signal modelling assumptions. The comparison provides a quantitative basis for selecting appropriate ephemerides and signal models in radio astronomical applications and establishes uncertainty estimates relevant to observation planning, interference forecasting, and the interpretation of measured GNSS contamination.
:::

## **PAPER** RadioSkySim: A Flexible and Scalable Python Framework for Radio-Astronomical Sky Simulation

:::{admonition} Abstract
:class: alert dropdown

| **Info** | **Choice** | **extra** |
|----------|------------|-----------|
| **journal** | [Astronomy and Computing](https://www.sciencedirect.com/journal/astronomy-and-computing) | |
| **journal** | [RAS Techniques and Instruments](https://academic.oup.com/rasti/issue/volume/5) | |
| **repository** | | |
| **overleaf** | | |
| **author** | | |
| **data** | | |

**Context.** The development and commissioning of radio telescopes increasingly depend on numerical simulations capable of combining astrophysical sky emission, realistic instrumental responses, observational geometry, and time-dependent interference sources. Existing simulation workflows often address these elements separately, limiting reproducibility, interoperability, and the systematic validation of complete observing pipelines.

**Aims.** We present RadioSkySim, a modular Python framework for generating simulated radio astronomical observations, with emphasis on extensibility, reproducibility, and scalable execution. The framework is designed to support instrument modelling, observing-strategy evaluation, calibration development, and validation of data-processing algorithms.

**Methods.** RadioSkySim adopts a domain-oriented, modular software architecture separating physical source models, antenna responses, observing geometry, simulation orchestration, and data products. The framework supports frequency-dependent and polarisation-sensitive beam models, diffuse and compact astronomical emission, and time-dependent local and satellite sources, including GNSS signals. It generates time-ordered data from the convolution of sky models with the instrumental response along prescribed observing trajectories. Numerical workflows use scientific Python tools, structured configuration, caching, and parallel execution, with interfaces for map-making and downstream analysis. We validate individual components against analytical solutions and reference calculations and evaluate computational performance using representative observing scenarios.

**Results.** Validation tests demonstrate [TBD: numerical accuracy of beam and coordinate transformations], [TBD: agreement with reference sky models], and [TBD: accuracy of simulated time-ordered signals]. Performance benchmarks quantify [TBD: execution time, memory consumption, and parallel scaling] for simulations spanning [TBD: representative numbers of time samples, frequency channels, and beam configurations]. Application examples illustrate the framework's ability to combine astronomical emission and time-dependent interference within a consistent simulation workflow.

**Conclusions.** RadioSkySim provides an extensible computational environment for modelling radio astronomical observations and connecting physical sky models with instrument-specific data products. Its modular design and reproducible workflows support systematic validation, performance studies, and the development of calibration and analysis methods for BINGO and other radio telescopes.

:::

## **PAPER** Uirapuru Radiotelescope: System Overview

:::{admonition} Abstract
:class: alert dropdown

| **Info** | **Choice** | **extra** |
|----------|------------|-----------|
| **journal** | [Experimental Astronomy](https://link.springer.com/journal/10686) | 
| **repository** |    |
| **overleaf** | |
| **author** | |
| **data** | |

**Context.** Radio telescope development requires the integration of electromagnetic, radio-frequency, digital acquisition, control, environmental monitoring, and scientific data-management subsystems. Small-scale experimental instruments provide an opportunity to investigate these interactions and validate operational architectures before deployment in larger astronomical facilities.

**Aims.** We present the system architecture, engineering implementation, and operational design of the Uirapuru radiotelescope, developed as an experimental platform supporting the BINGO project. The work describes the integration of its receiving system, digital backend, instrument-control software, monitoring infrastructure, and scientific acquisition pipelines.

**Methods.** We document the mechanical and electromagnetic configuration of the antenna, the analogue receiving chain, and the FPGA-based digital backend. We describe the software architecture responsible for device configuration, instrument state management, acquisition scheduling, and operational monitoring. Environmental and engineering sensors are integrated into a monitoring pipeline distinct from, but coordinated with, the astronomical data-acquisition system. We examine the interfaces between subsystems, data flows, configuration management, fault handling, and operational procedures. System-level tests assess communication reliability, acquisition continuity, monitoring behaviour, and recovery from representative operational failures.

**Results.** The integrated system supports [TBD: observing modes and operational capabilities], with [TBD: acquisition and monitoring performance]. Integration tests demonstrate [TBD: communication reliability and system availability], while operational measurements establish [TBD: configuration, recovery, and monitoring metrics]. The implemented architecture provides coordinated management of astronomical and engineering data and supports [TBD: demonstrated levels of automation and remote operation].

**Conclusions.** Uirapuru establishes an integrated experimental architecture for the development and operation of radio astronomical instrumentation. The separation of device control, scientific acquisition, and engineering monitoring provides a framework for maintainable operation, fault diagnosis, and system evolution. The engineering experience and operational procedures offer practical contributions to the commissioning and management of BINGO instrumentation.

:::

## **PAPER** RADIOHorn: A user-friendly and robust frameork for amateur radioastronomy

:::{admonition} Abstract
:class: alert dropdown

| **Info** | **Choice** | **extra** |
|----------|------------|-----------|
| **journal** | [Journal of Astronomical Instrumentation](https://www.worldscientific.com/worldscinet/jai) | 
| **journal** | [RAS Techniques and Instruments](https://academic.oup.com/rasti/issue/volume/5) | 
| **repository** |    |
| **overleaf** | |
| **author** | |
| **data** | |

**Context.** Software-defined radio devices have made radio astronomical observations increasingly accessible to educational institutions, amateur astronomers, and small research laboratories. Nevertheless, integrating receiver control, continuous acquisition, real-time visualisation, calibration, and persistent scientific data storage remains a significant technical barrier for users without specialised instrumentation expertise.

**Aims.** We present RADIOHorn, a Python-based software framework designed to simplify the operation of small radio telescopes using affordable software-defined radio hardware. The framework aims to provide a reproducible and extensible environment for receiver control, spectral acquisition, interactive visualisation, and elementary radio astronomical data analysis.

**Methods.** RADIOHorn integrates receiver interfaces for RTL-SDR and USRP-class devices through the RFStream acquisition and control layer. A web-based interface developed with Panel and HoloViews provides interactive visualisation of spectral and time-dependent measurements, together with instrument configuration and acquisition management. The framework separates acquisition, transport, processing, and presentation components, allowing local or network-distributed deployment. Scientific observations are persisted using the BINGO-SDHDF data format. We evaluate the system through synthetic-signal tests, acquisition benchmarks, and [TBD: representative astronomical observing experiment], examining data continuity, spectral fidelity, resource consumption, and operational usability.

**Results.** The framework supports [TBD: tested devices, sample rates, and acquisition modes] and achieves [TBD: sustainable throughput and data-loss metrics] under [TBD: hardware configurations]. Synthetic-signal experiments establish [TBD: spectral accuracy and processing performance], while observational tests demonstrate [TBD: astronomical signal detection or measurement]. The integrated interface enables [TBD: validated control, visualisation, and data-export capabilities] without requiring users to implement custom acquisition pipelines.

**Conclusions.** RADIOHorn provides an accessible and modular environment for practical radio astronomy with software-defined receivers. By combining instrument control, streaming acquisition, interactive scientific visualisation, and structured data persistence, the framework reduces the technical complexity of operating small radio telescopes and supports educational experiments, amateur observations, and instrumentation prototyping.

:::

## **PAPER** Evaluating Science Awareness and Strategic Goals for Steam Education Under the Light of BINGO Radiotelescope

:::{admonition} Abstract
:class: alert dropdown

| **Info** | **Choice** | **extra** |
|----------|------------|-----------|
| **journal** | [TBD](TBD) | 
| **repository** |    |
| **overleaf** | |
| **author** | |
| **data** | |

**Context.** Large scientific facilities can contribute to regional development beyond their primary research objectives by promoting scientific literacy, educational engagement, and public awareness of science and technology. The BINGO radiotelescope, located in Paraíba, Brazil, provides an opportunity to investigate how a major astronomical research project can support Science, Technology, Engineering, Arts, and Mathematics (STEAM) education and strengthen connections between scientific institutions, schools, and local communities.

**Aims.** We investigate public awareness of the BINGO radiotelescope, perceptions of its scientific and regional significance, and opportunities for aligning outreach activities with strategic STEAM education objectives. The study aims to identify knowledge gaps, educational expectations, and potential pathways for sustained engagement with the project.

**Methods.** We adopt an exploratory mixed-methods approach combining structured interviews, questionnaires, and qualitative analysis of participants' understanding of radio astronomy, the BINGO project, and its expected contributions to science and society. Data are collected during [TBD: outreach events and educational activities], involving [TBD: participant groups and sample sizes]. Responses are analysed using descriptive statistics and thematic categorisation, examining prior knowledge, perceptions of scientific research, regional identity, and interest in further educational engagement. The findings inform the formulation of educational priorities and outreach strategies associated with the BINGO project.

**Results.** The study characterises the initial level of awareness of radio astronomy and BINGO among [TBD: number and profile of participants], identifying [TBD: principal knowledge gaps and recurring perceptions]. Quantitative analysis reveals [TBD: proportions or associations], while qualitative responses highlight [TBD: principal themes concerning science, education, and regional development]. These findings provide an empirical basis for defining [TBD: educational priorities and strategic recommendations].

**Conclusions.** Assessing scientific awareness and community expectations provides a foundation for developing evidence-informed outreach and STEAM education strategies associated with major research infrastructures. The BINGO case offers an opportunity to connect frontier scientific research with educational participation and regional engagement, while establishing a framework for evaluating the broader educational contributions of astronomical facilities.

:::