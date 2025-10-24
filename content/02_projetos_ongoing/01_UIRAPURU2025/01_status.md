# Status Report

**Check the repository**: [UIRAPURU2025](https://github.com/BINGO-PB/UIRAPURU2025)

## Setup and Status

:::{admonition} **Goals**
:class: important

- Enough for blind tests
- We have a reasonable understanting of the sky seen by the instrument.
- We have a reasonable understanding of the data acquiring phase
- We have a reasonable understanting of the hardware
- We are able to devise a few reasonable (again) calibrating strategies
- **It is (long) past due time to do it.**
:::

:::{admonition} **Basic Concept**

- Keep track of important variables:
  - RFI monitoring
  - ADSB monitoring
  - Physical temperature at the receiver.
  - Voltage and current monitoring in the LNAs
  - GNSS data:
    - Using GNSS-SDR with USRP hardware
    - RINEX files from Campina Grande Station
  - Noise injection in receiver chain to get $T_{\mathrm{SYS}}$
  - Astronomical Calibration to obtain antenna effective area
:::

:::{admonition} **Data Sources**
:class: dropdown

- Physical Temperature, Voltage and current:
  - Analog Sensors
  - arduino
  - raspberry
- ADSB monitoring:
  - dipole antenna
  - RTL-SDR dongle
  - raspberry
  - dump1090 over TCP
  - pymodeS client
  - linux machine
- GNSS:
  - gnss antenna
  - 2xLNA
  - USRP ettus N200
  - gnss-sdr
  - docker container
  - linux machine
- RFI
  - omnidirectional antenna
  - 2xLNA
  - Skarab
  - linux machine
- Noise Injection
  - Callisto Callibration Unit
  - Callisto Spectrometer (bystander)
  - raspberry + TCPSerialBridge
  - linux machine (controller)
  - Select $T_\mathrm{hot}$, $T_\mathrm{warm}$, $T_\mathrm{cold}$ for 30 minutes, once a day.
  - Skarab
  - Linux machine
- Other polarization directly into receiver and skarab
:::

:::{admonition} **Dfficulties**
:class: error, dropdown

- 👷 Real life is a bitch!
  - Connections, cables, components, parts should be checked and matched accordingly.
- 👷 Skarap development in python 2.7 environment makes it very difficult to integrate code efficiently.
- 👷 We need a 12V 2A DC source and 3 5V 3A DC sources and a 4V 1A DC source, all the available power sources at our disposal were compromised in some sort.
- 👷 The main computer was relying on ethernet mounts to boot and function, while destructive maintenance in the server was happening, leaving the system innoperative.
- 👷 Every components should fit in a box....
:::

:::{admonition} **Status of the Assembly**
:class: caution, dropdown

- 📌 All antennas are in place.
- 📌 All hardware are in place.
- 📌 All the connections are done.
- 📌 All power sources are in place.
- 🚒 **We need to fix boot of the main controller**
  - ✅ 23/10
- 🧹 **Some network tweaks**
  - ✅ 23/10
- 🧹 **Finish installing software in raspberry**
:::

:::{admonition} **Safety and Security Actions Enacted**
:class: attention

- **uirapuru controller:
  - Linux User running devices do not log.
  - `\opt\share\uirapuru` is a shared mounting point for local users. This comprehend both **code** and **data**.
  -  Code in shared mounting point is meant to be run from the `main` branch.
  - Data folders should be immutable.
  - Never work on the shared mounting point directly. Use a local copy.
  - Never work on `main` branch.
  - Default branch to everyone is `dev`.
  - Github flow:
    - sync --> branch --> work --> pull request to DEV --> (editor) merge
  - After tests and discussions, someone is designated to merge dev --> main as a **deploy**.
  - No one is sudo and after first round of tests, apt cache should be frozen.
  - Try to use conda to install any OS related dependency.
  - Careful with environments and dependencies.
  - The shared folder is mounted via NFS to a jupyterhub.
  - There is a backup running daily in this machine, to the same partition.
- Feel free to use any jibberish commit msg, but be thoughtful naming:
  - branches: LB_skarab_controller_tcpclient
  - modules/files
  - folders
  - classes/functions
- please, feel yourself confident to ask, comment, answer, engage in the available spaces:
  - email / whatsapp / face-to-face
  - github issues
  - github projects
  - github discussions or wiki (in case of need)
:::

:::{admonition} **Plan**
:class: tip, dropdown

- 📅 Finish installation by 23/10/2025
- ⏯️ Run at least 24h with 2048 FFT channels
- ⏯️  Run at least 24h with 4096 FFT channels
- ⏯️  Run at least 24h with 8192 FFT channels
- 🔁 Preferable 48h for each of the above.
- ⁉️ Stop, analyze, plan further actions
- 🖋️ Commit knowledge to an article
:::

## Code

### Skarab

- ❓ **fpg bitstream**:
  - We would be using three ADC channels and it is not clear that current bitstream can handle it.
  - ⏳ For future thoughts: current bitstream is not adequate to serious signal processing.
- **Data Ingestion**:
  - 🏗️ Python code running is messy and saves npz files. At the very least the code should be upgraded to store a minimum metadata plus other important informations, like frequencies and timestamps.
  - [ ] **It is not difficult to implement a data streaming with this code, using zmq protocol and consume this stream with a more thoughtful logic at the other end.**

### Raspberry (Callisto)

- [x] Calibration Unit controller.
- [x] Callisto controller
- [x] TCP2SerialBridge
- [ ] Arduino Controller with pyfirmata2 : *not tested*
- [ ] Arduino Sensor data stream: *not tested*

### Raspberry (ADSB)

- [ ] dump1090-mutability + configurations: *not tested*

### Linux controller

- [ ] TCP client connecting to TCPSerialBridge: coded and tested in different setup, but not integrated in an operational code base with current setting.
- [ ] pymodeS TCP client for ADS-B **not tested**
- [x] docker gnss-sdr
- [ ] gnss-sdr configuration and test.
- [ ] Task scheduler: good starting point tested in different configuration but needs work.
- [ ] zmq client for skarab data stream.
- [ ] HDF5 format: CSIRO SDHDF is a good starting point, we already have code along this lines but we should decide the exact format to use the engine.
- [ ] Implementation of HDF5 engine

### Code for Analysis

- [x] pointing array
- [x] sattelite tracker
- [ ] radiosources event array: for speed we can track nvss sources and use specfind catalog to retrieve spectral indices. All funcionalities are already coded, but not integrated in a package.
- [ ] baseline extraction
- [ ] RFI flagging
- [ ] Compare continuum measures with convolved map:
  - ❓pysm3
  - ❓HIPASS?
  - ❓ASKAP?
  - ❓VLASS?
- [x] RINEX downloader and Analyser
- [x] Solar flux calculator: download data from learmonth observatory and interpolate to desired frequency.

## Ideas for Analysis

:::{admonition} Analysis

- With Callisto measurements determine:

$$
\begin{aligned}
{V_0}_\nu &\mapsto \textrm{Voltage Offset per frequency}\\
b_\nu &\mapsto \textrm{Detector Slope per frequency}\\
{T_{RX}}_\nu &\mapsto \textrm{Receiver Temperature per frequency}\\
\end{aligned}
$$

- First order calibrated measure is:

$$
S_\nu  = \frac{2k_B \nu^2}{c^2} \frac{4\pi}{G_\nu}\left[10^{\frac{V_\nu - {V_0}_\nu}{b_\nu}}\; \mathrm{K} - {T_{RX}}_\nu\right]
$$

- Antenna Directivity is obtained from measured beam pattern with interpolation. Gain is obtained by multiplying by $\eta$ factor, which encodes the effective area of the beam and if determined with sky calibration.

$$
D = \frac{B(\theta, \phi)_\mathrm{max}}{\frac{1}{4\pi}\iint B(\theta, \phi)d\Omega}\\
G = \eta D
$$

- Astronomical Callibration
  - Sun is a point source for uirapuru beam

$$
T_A = \frac{\Omega_\odot}{\Omega_A}T_{\odot}
$$

- Galactic Plane emission.

- Radiosources

- GNSS satellites and RINEX data

- Continuum Sky Map
:::

:::{admonition} 3-point calibration
:class: error

$T_\mathrm{hot} \gg T_\mathrm{cold} \sim T_\mathrm{RX}$

$$
T_\mathrm{cold} = 290 K\\
T_\mathrm{warm} = 94868 K\\
T_\mathrm{cold} = 948683 K\\
$$

$$
\begin{aligned}
V_\mathrm{cold} &= V_0 + b \log (T_\mathrm{RX} + T_\mathrm{cold})\\
V_\mathrm{warm} &= V_0 + b \log (T_\mathrm{warm})\\
V_\mathrm{hot} &= V_0 + b \log (T_\mathrm{hot})
\end{aligned}
$$

$$
\begin{aligned}
b &= \frac{V_\mathrm{hot} - V_\mathrm{warm}}{\log \frac{T_\mathrm{hot}}{T_\mathrm{warm}}}\\
V_0 &= \frac{V_\mathrm{warm} \log T_\mathrm{hot} - V_\mathrm{hot} \log T_\mathrm{warm}}{\log \frac{T_\mathrm{hot}}{T_\mathrm{warm}}}\\
T_\mathrm{RX} &= 10^\frac{V_\mathrm{cold} - V_0}{b} - T_\mathrm{cold}
\end{aligned}
$$
:::

## Questions

- Receiver physical parameters and $T_\mathrm{sys}$
- Correlation with RFI and horn signal
- Robustness of calibration procedure
- Timescale for receiver stability
- local RFI characterization
- GNSS carrier x GNSS observed spectrum
  - Time variabilityy
  - Frequency shift/drift
  - time of detection
- Time of detection and ephemeris for radiosources
- Pointing correction
- Sensitivity
- $G/T_\mathrm{sys}$
- SEFD
- Polarization?
- Keeping or removing filters?
