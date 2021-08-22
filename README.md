# Noise cancelling algorithm for speech signals on System-on-chip design

In this project, the Power Level Difference (PLD)-based noise cancelling algorithm is implemented in a Xilinx FPGA SoC
using hardware/software co-design methodology. Thanks to the hardware/software co-design, the complex control part of
the algorithm can be fast deployed in software meanwhile the computational part is effectively implemented in hardware.
Therefore, the system can not only process the real-time input data but also consumes few hardware resource.
In order to evaluate hardware resources and measuare performance of system, proposed system is implemented in FPGA
development board (Xilinx XC6SLX45) and then placed in some noisy environments which are white Gaussian noise (WGN),
F-16 cockpit noise and babble noise to assess the algorithm quality through specific targets.
According to results of this project, I submited a paper in the international conference on Advanced Technologies for
Communication (ATC 2015).


# How to use the project
a. rtl code: 
	./rtl_code
	     or ./NoiseCancelling_FullProject/pcores/nc_test_v1_00_a/hdl/verilog
b. software code:
	./NoiseCancelling_FullProject/SDK/SDK_Export/noiseCancer/src

# Publication 
V. Phu Ha, D. M. Nguyen and Q. H. Dang, "Hardware/software co-design of power level difference based noise cancellation," 2015 International Conference on Advanced Technologies for Communications (ATC), 2015, pp. 616-621, doi: 10.1109/ATC.2015.7388404
