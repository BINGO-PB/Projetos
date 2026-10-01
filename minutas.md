# Last Minute remarks

Acho que esta minuta esta precisando de revisão humana, algumas clarificações para que a história seja registrada de forma mais acurada e compreensível no futuro.

Stage 0/1 Meeting Minutes 8/25

Participants: Elcio Abdalla, Alex Wuensche, Luciano Barosi, Tales Augusto, Cesar Strauss, Jordany Vieira

> 1. Spectrometer Updates and Laboratory Tests
>
>        1.1. Current Configuration and Interferences
>        The spectrometer was powered on with decimation 8, resulting in a 375 MHz band.
>        The chain is assembled with: input signal, Magic Keys, and two output chains. There is no reference noise source (confetti) at the moment.

>        Interference peaks were identified at frequencies of 1060 MHz and 1037 MHz.

>        The origin of the 1060 MHz peak is likely the power grid.

>        The origin of the 1037 MHz peak is unknown, both to César and the rest of the team.

*[LB] - Vamos especificar que estes testes foram realizados com o grupo do INPE*

1.2. Immediate Next Steps

Install the isolation boxes for the primary LNAs, which are currently operating without encapsulation, using only absorbers around them (an ineffective solution).

Perform tests with the reference noise source to measure signal stability, a step that had not been tested directly by the person in charge.

Activities will be conducted with Jorge, regardless of César's availability.

*[LB] -- Esses são os próximos passos no time de trabalho do INPE*

1.3. Firmware and Transmission Protocol
The firmware used was developed in collaboration with the team in Italy, using PFB, FFT, and decimation 8.

The data transmission protocol was discussed:

Initially, Rafael was unable to implement it via UDP.

*[LB] SPEAD Protocol (fromk Casper), more reliable and production ready than BRAM*
The current firmware uses UDP with the SPEED protocol (from Caspian), which is more efficient than the Behan reading.

*[LB] Provavelmente eu falei isto, mas não é inteiramente verdade, Valmir esta trabalhando m um bloco de rede próprio, em um bloco FIR e esta usando o bloco de protocolo UDP da Vivado, que certamente é mais eficiente do que o da casper, mas não foi projetado para radioastromia*

Valmir is developing a pure UDP block (from Vivado), which has superior efficiency because it is implemented in hardware, although it was not originally designed for radio astronomy.

A communication block was created that simultaneously supports 40 Gbps and 1 Gbps, resolving intermittency issues in the connection with SKARAB.

*[LB] o bloco de sinal sintético tem o objetivo de testes em simulação (via Symulink) com Skarab e cadeia de processamento sintética, injeção dos produtos em gerador de sinais para recepção pela SKARAB via RF e, adicionalmente TX/RX das skarabs*
2. Synthetic Signal Development (Thales)

*[LB] Sugiro que o thales compartilhe um parágrafo de características do sinal e a documentação no overleaf* 
2.1. Synthetic Signal Chain Status
Thales is finalizing a synthetic signal chain to inject a signal with sky characteristics.

The transmission (TX) part is ready.

It is still necessary to add the reception chain, the reception chain filter, and the FFT.

*[LB] GRASP
2.2. Grasp Software License
Sales manager Adam confirmed the provision of a full trial license for the Grespi software.

The requested operating system was Linux.

3. Software Licenses

*[LB] Acho que ninguém disse nada parecido com isto. A licença pode ser pedida por número de seats.*
3.1. Vivado License
The Vivado license currently in use was obtained for a one-year period (2024).

It was suggested that the professor request a permanent academic license from AMD, which would avoid periodic renewals.

3.2. MATLAB License
The team uses the USP license, which is permanent.

The license purchased by the collaboration has not arrived at INPE.

Jordany will lose his USP email in September but will be able to request a license via an Alumni account.

4. Thales' Visit to INPE

4.1. Technical Exchange Proposal
It was proposed that Thales spend one or two weeks at INPE to learn about the advanced firmware and edit code with the local team.

Financial resources:

Alex does not have funds available to cover the trip (not provided for in the CNPq universal call).

Subsistence (accommodation and meals) is the main concern.

Alex committed to looking for alternatives to make the visit feasible.

5. Technical Clarification on the Horn


*[LB] -- Magit Tee*
5.1. Polarization and Data Output
It was clarified that the horn, without the Magic Key, provides data in linear polarization (horizontal and vertical).

The Magic Key performs the H + V and H - V operations, allowing the reconstruction of circular polarization components.

6. Team Participation in Meetings

6.1. Importance of Attendance
The importance of team members (especially those in engineering) attending meetings so that their work is recognized was highlighted.

It was suggested that, for very busy people, a 15-minute monthly participation to present their work would be sufficient.

Valmir and Gutenberg were mentioned as people who should be encouraged to participate.

