---
site:
  hide_outline: true
---

# Referencias


:::{table} Consolidated Radio Telescope Pipeline Survey
:widths: auto
:name: tab:pipelines

| # | Categoria | Autores | Ano | Título | Stage | Latency | Scalability | Hardware | Features | Citações |
| -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- |
||**DSP Frameworks** |||||||||||
1 | DSP | Hickish et al. | 2016 | [A Decade of Developing Radio-Astronomy Instrumentation using CASPER](https://arxiv.org/abs/1611.01826) | F-engine | Real-time | 10–100 nodes | FPGA | Modular DSP | — | 
2 | DSP | van Straten et al. | 2011 | [DSPSR: Digital Signal Processing Software for Pulsar Astronomy](https://arxiv.org/abs/1008.3973) | Search | Real-time | Single-node/GPU | CPU/GPU | Coherent dedispersion | 402 | 
3 | DSP | Ransom | 2011 | [PRESTO: Tools for Pulsar Searching and Timing](https://github.com/scottransom/presto) | Search | Offline | Cluster | CPU | Pulsar search | — |
||**Correlators / X-engines** |||||||||||
4 | Correlator | Meyers et al. | 2015 | [An Efficient Real-Time Data Pipeline for the CHIME Pathfinder X-engine](https://arxiv.org/abs/1503.06189) | X-engine | Real-time | Tbps-scale (~819 Gb/s) | GPU cluster | Massive correlator | — | 
5 | Correlator | Kocz et al. | 2015 | [Digital Signal Processing using Stream High Performance Computing: A 512-input Broadband Correlator for Radio Astronomy](https://arxiv.org/abs/1505.1411.3751) | X-engine | Real-time | 100s nodes | FPGA+GPU | Streaming correlator | — | 
6 | Correlator | Edgar et al. | 2010 | [Enabling a High Throughput Real Time Data Pipeline](https://arxiv.org/abs/1003.5575) | X-engine | Real-time | Large-N array | GPU | High throughput | 1 | 
7 | Correlator | Veenboer et al. | 2019 | [GPU-Accelerated Radio-Astronomy Signal Processing with OpenCL and CUDA](https://link.springer.com/chapter/10.1007/978-3-030-29400-7_36) | X-engine | Real-time | LOFAR-scale | FPGA/GPU | Tradeoff study | 13 |
||**FRB / Transient Pipelines** |||||||||||
8 | FRB | Sclocco et al. | 2020 | [Real-Time RFI Mitigation for the Apertif Radio Transient System](https://arxiv.org/abs/2001.03389) | Search | Real-time | 70+ Gb/s | GPU | RFI mitigation | — | 
9 | FRB | Adamek et al. | 2019 | [Single Pulse Detection Algorithms for Real-time Fast Radio Burst Searches using GPUs](https://arxiv.org/abs/1910.08324) | Search | Real-time | Multi-GPU | GPU | Dedispersion | — | 
10 | FRB | Surnis et al. | 2019 | [GREENBURST: A Fast, Open-Source Hardware-Accelerated FRB Detection System](https://arxiv.org/abs/1903.05573) | Search | Real-time | Telescope-scale | GPU | FRB detection | — | 
11 | FRB | Magro et al. | 2014 | [A Real-Time GPU-Based Backend for Radio Telescopes](https://arxiv.org/abs/1401.8258) | Search | Real-time | Single cluster | GPU | Non-imaging backend | 2 | 
12 | FRB | Yu et al. | 2022 | [A Fast Transient Backend to Detect FRBs with the Tianlai Dish Pathfinder Array](https://arxiv.org/abs/2210.03272) | F+X+Search | Real-time | Multi-node | FPGA+GPU | Full pipeline | 1 | 
13 | FRB | Yu et al. | 2024 | [The FRB-searching pipeline of the Tianlai Cylinder Pathfinder Array](https://arxiv.org/abs/2406.15740) | F+X+Search | Real-time | Cluster | GPU | Beamforming | 3 | 
14 | FRB | Lin et al. | 2025 | [Back-End System of BURSTT](https://arxiv.org/abs/2512.07300) | F+X+Search | Real-time | Scalable array | FPGA+GPU | Beamforming | — | 
15 | FRB | McCauley et al. | 2026 | [Long-Integration Magnetar Burst Observatory (LIMBO): Instrument Summary and Early FRB Rate Constraints](https://arxiv.org/abs/2603.05603) | Search | Real-time | Small array | GPU | Magnetar/FRB | — | 
16 | FRB | Jiang et al. | 2026 | [An Improved Machine Learning Approach for RFI Mitigation in FAST-SETI Survey Archival Data](https://arxiv.org/abs/2512.15809) | Search | Real-time | FAST-scale | GPU | RFI mitigation | — | 
17 | FRB | Buch et al. | 2025 | [A Comprehensive Review of RFI Mitigation Techniques in Radio Astronomy](https://arxiv.org/abs/2512.01954) | — | — | — | — | Taxonomy | — | 
18 | FRB | Ma et al. | 2025 | [A deployed real-time end-to-end deep learning algorithm for fast radio burst detection](https://www.aanda.org/articles/aa/pdf/2025/10/aa55217-25.pdf) | Search | Real-time | Production deployment | GPU | Deep-learning detection | — |
19 | FRB | Lin et al. | 2025 | [ASTROFLOW: A Real-Time End-to-End Pipeline for Radio Single-Pulse Searches](https://arxiv.org/abs/2511.02328) | Search | Real-time | Cluster | GPU | End-to-end single-pulse pipeline | — | 
20 | FRB | Hombal et al. | 2026 | [Evaluating the effectiveness of radio frequency interference removal algorithms for single pulse searches](https://arxiv.org/abs/2601.08351) | Search | Offline | Comparative study | — | RFI algorithm evaluation | — | 
21 | FRB | Zhao et al. | 2026 | [An Improved Machine Learning Approach for Radio Frequency Interference Mitigation in FAST-SETI Survey Archival Data](https://arxiv.org/abs/2512.15809) | Search | Real-time | FAST-scale | GPU | ML-based RFI mitigation | — | 
22 | FRB | Serylak et al. | 2024 | [FRB Real-time Pipeline Design for Northern Cross](https://ceur-ws.org/Vol-4130/paper111.pdf) | F+X+Search | Real-time | Ethernet cluster | GPU | Beamforming | — |
||**Cosmology / IM pipelines** |||||||||||
23 | Cosmology | Castorina et al. | 2020 | [PUMA: Precision Ultra-sensitive Milliarcsecond-scale Array for CMB Observations](https://arxiv.org/abs/2002.05072) | F+X | Real-time | Future Tbps | Hybrid | Next-gen design | 37 | 
||**System / Backend Architectures** |||||||||||
24 | System | Bourke et al. | 2024 | [A 400Gbit Ethernet core enabling High Data Rate Streaming from FPGAs to Servers and GPUs in Radio Astronomy](https://arxiv.org/abs/2411.15630) | Transport | Real-time | 400 GbE+ | FPGA+GPU | RDMA | — | 
25 | System | Hickish et al. | 2019 | [Commensal, Multi-user Observations with an Ethernet-based Jansky Very Large Array](https://arxiv.org/abs/1907.05263) | F+X+Search | Real-time | Multi-user | Hybrid | Commensal ops | — | 
26 | System | Comoretto et al. | 2024 | [The SKARAB Board in the Framework of Single-Dish Radio Astronomy](https://www.worldscientific.com/doi/10.1142/S2251171724500089) | F-engine | Real-time | FPGA boards | FPGA | PFB | 2 |
27 | System | Jing et al. | 2024 | [HiFAST: An Hi data calibration and imaging pipeline for FAST](http://dx.doi.org/10.1007/s11433-023-2333-8) | Calibration/Imaging | Offline | FAST-scale | CPU | H I calibration pipeline | — |

:::