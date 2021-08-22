##############################################################################
## Filename:          /home/phuhv/Workspace/NoiseCancelling/1403110617_final_R2L/project/drivers/nc_test_v1_00_a/data/nc_test_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Sun Jul 12 21:06:28 2015 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "nc_test" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
