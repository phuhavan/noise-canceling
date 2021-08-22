/*
 * ac97_irq.h
 *
 *  Created on: Feb 20, 2014
 *      Author: admin
 */

#ifndef AC97_IRQ_H_
#define AC97_IRQ_H_

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files ********************************/

#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xparameters.h"


#define XPAR_AC97_DEVICE_ID 0
#define AC97_DEVICE_ID XPAR_AC97_DEVICE_ID
#define AC97_BASEADDR XPAR_DIGILENT_AC97_CNTLR_BASEADDR
#define AC97_INTERRUPT_PRESENT 1



typedef struct {
	u16 DeviceId;		/* Unique ID  of device */
	u32 BaseAddress;	/* Device base address */
	int InterruptPresent;	/* Are interrupts supported in h/w */
} XAC97_Config;

typedef struct {
	u32 BaseAddress;	/* Device base address */
	u32 IsReady;		/* Device is initialized and ready */
	int InterruptPresent;	/* Are interrupts supported in h/w */
} XAC97;



XAC97_Config *AC97_LookupConfig(u16 DeviceId);
int AC97_Initialize(XAC97 * InstancePtr, u16 DeviceId);
int AC97_CfgInitialize(XAC97 * InstancePtr, XAC97_Config * Config,
			u32 EffectiveAddr);




#ifdef __cplusplus
}
#endif


#endif /* AC97_IRQ_H_ */
