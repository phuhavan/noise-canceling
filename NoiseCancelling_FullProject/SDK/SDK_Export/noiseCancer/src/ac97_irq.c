/*
 * ac97_irq.c
 *
 *  Created on: Feb 19, 2014
 *      Author: admin
 */

#include "ac97_irq.h"
#include "ac97_irq_d.h"

XAC97_Config *AC97_LookupConfig(u16 DeviceId)
{
	XAC97_Config *CfgPtr = NULL;

	int Index;

	for (Index = 0; Index < 3; Index++) {//XPAR_XGPIO_NUM_INSTANCES
		if (XAC97_ConfigTable[Index].DeviceId == DeviceId) {
			CfgPtr = &XAC97_ConfigTable[Index];
			break;
		}
	}

	return CfgPtr;
}


int AC97_Initialize(XAC97 * InstancePtr, u16 DeviceId)
{
	XAC97_Config *ConfigPtr;

	/*
	 * Assert arguments
	 */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/*
	 * Lookup configuration data in the device configuration table.
	 * Use this configuration info down below when initializing this
	 * driver.
	 */
	ConfigPtr = AC97_LookupConfig(DeviceId);
	if (ConfigPtr == (XAC97_Config *) NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return AC97_CfgInitialize(InstancePtr, ConfigPtr,
				   ConfigPtr->BaseAddress);
}

int AC97_CfgInitialize(XAC97 * InstancePtr, XAC97_Config * Config,
			u32 EffectiveAddr)
{
	/*
	 * Assert arguments
	 */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/*
	 * Set some default values.
	 */
//#if (XPAR_XGPIO_USE_DCR_BRIDGE != 0)
//	InstancePtr->BaseAddress = ((EffectiveAddr >> 2)) & 0xFFF;
//#else
	InstancePtr->BaseAddress = EffectiveAddr;
//#endif

	InstancePtr->InterruptPresent = Config->InterruptPresent;
//	InstancePtr->IsDual = Config->IsDual;

	/*
	 * Indicate the instance is now ready to use, initialized without error
	 */
	InstancePtr->IsReady = XIL_COMPONENT_IS_READY;
	return (XST_SUCCESS);
}
