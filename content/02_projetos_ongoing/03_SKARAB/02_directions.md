# Comparint Digital BACKENDS


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

