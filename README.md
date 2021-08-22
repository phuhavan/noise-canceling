# Noise cancelling algorithm for speech signals on System-on-chip design

In this project, the Power Level Difference (PLD)-based noise cancelling algorithm is implemented in a Xilinx FPGA SoC
using hardware/software co-design methodology. Thanks to the hardware/software co-design, the complex control part of
the algorithm can be fast deployed in software meanwhile the computational part is effectively implemented in hardware.
Therefore, the system can not only process the real-time input data but also consumes few hardware resource.
In order to evaluate hardware resources and measuare performance of system, proposed system is implemented in FPGA
development board (Xilinx XC6SLX45) and then placed in some noisy environments which are white Gaussian noise (WGN),
F-16 cockpit noise and babble noise to assess the algorithm quality through specific targets.
According to results of this project, I was accepted a paper in international conference on Advanced Technologies for
Communication (ATC 2015).
