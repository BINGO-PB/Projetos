# Skarab Roadmap

![design](../../00_images/dbk.drawio.png)

```mermaid
flowchart TB

    subgraph Level Zero - Set Up
        SETUP["Server Preparation"]
        DESIGN["Matlab+Vivado Server"]
        CONTROL["Skarab Controller"]
    end

    subgraph Level 1 - 
        CONN["Connection"]
        UP["Upload"]
        TUT1["Casper Tutorial 1"]
        TUT4["Casper Tutorial 4"]
    end

    SKARAB["Working Skarab"]
    SINT["Sinthetic Signal"]


    subgraph Level 2
        FFT["FFT"]
        PSD["Power Spectral computation"]
        INT["Integration block"]
        SIM2["Simulink"]
        TEST2["Testing with hardware"]
    end

    FFT --> PSD
    PSD --> INT
    INT --> SIM2
    SIM2 --> TEST2

    subgraph Level 3
        FIR["FIR Design"]
        SIM3["Simulink"]
        TEST3["Testing with hardware"]
    end

    FIR --> SIM3 
    SIM3 --> TEST3

    subgraph Level 4
        PFB["PFB Design"]
        SIM4["Simulink"]
        TEST4["Testing with hardware"]
    end

    PFB --> SIM4
    SIM4 --> TEST4

    subgraph Level 5
        PSEUDO["Pseudo Correlation"]
        SIM5["Simulink"]
        TEST5["Testing with hardware"]
    end

    PSEUDO --> SIM5
    SIM5 --> TEST5

    subgraph Level 6
        RFI["RFI Design"]
        SIM6["Simulink"]
        TEST6["Testing with hardware"]
    end

    RFI --> SIM6
    SIM6 --> TEST6

    subgraph Level 7
        PACK["Packetize - UDP/SPEAD"]
        SIM7["Simulink"]
        TEST7["Testing with hardware"]
    end

    PACK --> SIM7
    SIM7 --> TEST7

    subgraph Level 8
        INTEG["Integration Design"]
        SIM8["Simulink"]
        TEST8["Testing with hardware"]
    end

    INTEG --> SIM8 
    SIM8 --> TEST8


    SETUP --> DESIGN
    SETUP --> CONTROL
    CONTROL --> CONN
    CONN --> UP
    UP --> TUT1
    TUT1 --> TUT4
    UP --> SKARAB 

    SKARAB --> FFT
    SKARAB --> FIR
    SKARAB --> PFB
    SKARAB --> PSEUDO
    SKARAB --> RFI
    SKARAB --> PACK
    SINT --> FFT
    SINT --> FIR
    SINT --> PFB
    SINT --> PSEUDO
    SINT --> RFI
    SINT --> PACK


    TEST2 --> INTEG
    TEST3 --> INTEG
    TEST4 --> INTEG
    TEST5 --> INTEG
    TEST6 --> INTEG
    TEST7 --> INTEG
``` 




## Pipeline Server

```mermaid 
flowchart TB

    subgraph Frontend
        FPGA["28 × SKARAB"]
    end

    CORE["100 GbE Core Switch"]

    subgraph Backend
        S1["GPU Server 1"]
        S2["GPU Server 2"]
        S3["GPU Server 3"]
        S4["Optional Spare"]
    end

    subgraph Storage
        NVME["NVMe Buffer Layer"]
        CEPH["Persistent Storage"]
    end

    FPGA --> CORE

    CORE --> S1
    CORE --> S2
    CORE --> S3
    CORE --> S4

    S1 --> NVME
    S2 --> NVME
    S3 --> NVME

    NVME --> CEPH
``` 


## 1. Science & Signal Processing Parameters

| Item                 | Value                  | Notes                         |
| -------------------- | ---------------------- | ----------------------------- |
| Telescope frontend   | Pseudo-correlator      | Sky − Reference differencing  |
| Number of horns      | 28                     | One SKARAB per horn           |
| Inputs per horn      | 4                      | Radiometer outputs            |
| Total digital inputs | 112                    | 28 × 4                        |
| ADC sampling rate    | 3 GSps                 | ADC32RF45-class               |
| ADC resolution       | 14–16 bits             | 16 bits preferred             |
| RF bandwidth         | 375 MHz                | After analog filtering        |
| Spectral channels    | 1024 - **4096**        | PFB + FFT                     |
| Integration time     | 1–10 ms                | 10 ms baseline survey         |
| FPGA RFI filtering   | Yes                    | Spectral thresholding/masking |
| Packet protocol      | UDP + sequence numbers | Jumbo frames                  |
| Data Rate            | 262 Mb/s               | 1 ms/per Horn                 |
| Output data type     | Power spectra          | 16-bit recommended            |

---


# 4. Backend Cluster Architecture

| Component          | Recommendation       | Specifications |
| ------------------ | -------------------- | --------------- |
| Backend servers    | 3 + 1 spare optional | AMD EPYC 9354P 32 cores 512 GB DDR5  |
| NIC     | 100 Gbs               |ConnectX-6 Dx 100GbE|
| GPU class          | 2 x RTX 4090      |
| Local storage      | NVMe RAID10 | 4× 3.84 TB U.2 E         |
| Persistent storage | Ceph                 | 100 - 200 Tb |
| Network fabric     | 100Gbps |  Mellanox SN2700 32 x 100 GbE|\x

