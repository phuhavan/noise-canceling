/************************************************************************/
/*																		*/
/*	ac97_demo.c	--	AC'97 Demo Main Program								*/
/*																		*/
/************************************************************************/
/*	Author: Sam Bobrowicz												*/
/*	Copyright 2011, Digilent Inc.										*/
/************************************************************************/
/*  Module Description: 												*/
/*																		*/
/*	This program demonstrates the audio processing capabilities of the  */
/*  Atlys Development Board. The onboard push buttons provide the 		*/
/*  following functionality to the user:								*/
/*																		*/
/*  BTNR  Record a short period of audio and store it in memory. SW0	*/
/*		   selects either LINE IN (up) or MIC (down) as the input 		*/
/*		   source. LD0 will be illuminated while recording.				*/
/*	BTNL  Play back the recorded audio data on both LINE OUT and		*/
/*		   HP OUT. LD1 will be illuminated while playing data back.		*/
/*	BTND  Output a brief tone on both LINE OUT and HP OUT				*/
/*																		*/
/************************************************************************/
/*  Revision History:													*/
/* 																		*/
/*		11/4/2011(SamB): Created										*/
/*																		*/
/************************************************************************/


/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */
#include <stdio.h>
#include "platform.h"  //Contains Cache initializing function
#include "xparameters.h"  //The hardware configuration describing constants
#include "xgpio.h"	//GPIO API functions
#include "xintc.h"	//Interrupt Controller API functions
#include "xil_io.h"	//Contains the Xil_Out32 and Xil_In32 functions
#include "mb_interface.h" //Contains the functions for registering the
//interrupt controller with the microblaze MP
#include "ac97_demo.h"
#include "ac97.h"

#include "ac97_irq.h"//

// alg include
#include "New_Algo.h"
#include "mul_complex.h"
#include "nc_test.h"

/* ------------------------------------------------------------ */
/*				XPAR Constants									*/
/* ------------------------------------------------------------ */
/* All constants used from xparameters.h are located here so 	*/
/* that they may be easily accessed.							*/
/**/

#define AC97_BASEADDR 	XPAR_DIGILENT_AC97_CNTLR_BASEADDR
#define AC97_1_BASEADDR XPAR_DIGILENT_AC97_CNTLR_1_BASEADDR
#define CIP_BASEADDR 0x7A800000
#define BTNS_BASEADDR XPAR_PUSH_BUTTONS_5BITS_BASEADDR
#define SW_BASEADDR XPAR_DIP_SWITCHES_8BITS_BASEADDR
#define LED_BASEADDR XPAR_LEDS_8BITS_BASEADDR
#define BTNS_DEVICE_ID XPAR_PUSH_BUTTONS_5BITS_DEVICE_ID
#define INTC_DEVICE_ID XPAR_INTC_0_DEVICE_ID
#define AC97_DEVICE_ID XPAR_AC97_DEVICE_ID//
#define BTNS_IRPT_ID XPAR_INTC_SINGLE_DEVICE_ID
#define AC97_IRPT_ID 1
#define DDR2_BASEADDR XPAR_MCB_DDR2_S0_AXI_BASEADDR

/*
 * The pAudioMem constant points to the physical address of the
 * start of the audio data in the DDR2 memory. It is offset from
 * the beginning of DDR to allow room for program memory
 */
#define pAudioData (DDR2_BASEADDR + 0x01000000)

/* ------------------------------------------------------------ */
/*				Global Variables								*/
/* ------------------------------------------------------------ */

volatile u32 lBtnStateOld;
volatile u8 fsRunAction; //flags are set by interrupts to trigger
//different actions

Xboolean SW0state = XFALSE;
Xboolean SW1state = XFALSE;

/*-----------------Event variable---------------------------*/
Xboolean R2 =XFALSE;
Xboolean R5 =XFALSE;

Xboolean RUN =XFALSE;

Xboolean chan_le=XFALSE;

/*-----------------count variable---------------------------*/
Xuint32 frame=0; // count frame
Xuint32 start_frame=0;

Xuint32 Count_error=0;
Xuint32 Count_64=0;
Xuint32 chot=0; // for save cycle of ALG

int PDATA[64];// store processed data & swait ...



/* ------------------------------------------------------------ */
/*				Procedure Definitions							*/
/* ------------------------------------------------------------ */

int main()
{
	init_platform();

	static XGpio pshBtns;
	static XIntc intCtrl;
	static XAC97 ac97drv;

	//user var
	int v1[128],v2[128],v3[128],v4[128],v5[64];
	float v5hn_chan[128],v5hn_le[128];

	float Pno[1], Py1o[1], Py2o[1], Py12o[1];	// in
	float Xesto[2];								// out
	float Y1in[2], Y2in[2], Pnin, Py1in, Py2in, Py12in; // point
	float Py1[128], Py2[128], Py12[128], Pn[128];  // variable for next turn
	int ALG_OUT_RE[128], ALG_OUT_IM[128];

	int k=0; // var for ALG

	lBtnStateOld = 0x00000000;
	fsRunAction = 0;
	//////////////////////////////////////////

	/*Initialize the driver structs for the Push button and interrupt cores.
	 *This allows the API functions to be used with these cores.*/
	XGpio_Initialize(&pshBtns, BTNS_DEVICE_ID);
	XIntc_Initialize(&intCtrl, INTC_DEVICE_ID);
	AC97_Initialize(&ac97drv, AC97_DEVICE_ID);

	/* Connect the function PushBtnHandler to the interrupt controller so that
	 * it is called whenever the Push button GPIO core signals an interrupt.*/
	XIntc_Connect(&intCtrl, BTNS_IRPT_ID, PushBtnHandler, &pshBtns);
	XIntc_Connect(&intCtrl, AC97_IRPT_ID, AC97Handler, &ac97drv);

	/* Enable interrupts at the interrupt controller*/
	XIntc_Enable(&intCtrl, BTNS_IRPT_ID);

	/* Register the interrupt controller with the microblaze
	 * processor and then start the Interrupt controller so that it begins
	 * listening to the interrupt core for triggers.*/
	microblaze_register_handler(XIntc_DeviceInterruptHandler, INTC_DEVICE_ID);
	microblaze_enable_interrupts();
	XIntc_Start(&intCtrl, XIN_REAL_MODE);

	/* Enable the push button GPIO core to begin sending interrupts to the
	 * interrupt controller in response to changes in the button states*/
	XGpio_InterruptEnable(&pshBtns, lBtnChannel);
	XGpio_InterruptGlobalEnable(&pshBtns);

	if ((Xil_In32(SW_BASEADDR) & bitSw0) == 0x01){ SW0state = XTRUE; }
	else{ SW0state =  XFALSE;	}
	if ((Xil_In32(SW_BASEADDR) & bitSw1) == 0x02){ SW1state = XTRUE; }
	else{ SW1state =  XFALSE;	}
	/************************************************************************/
	/*	 * Wait for AC97 to become ready	 */
	while (!(AC97_Link_Is_Ready (AC97_BASEADDR)));
	/*	 * Set TAG to configure codec	 */
	AC97_Set_Tag_And_Id (AC97_BASEADDR, 0xF800);
	/*	 * Enable audio output and set volume	 */
	AC97_Unmute (AC97_BASEADDR, AC97_MASTER_VOLUME_OFFSET);
	AC97_Unmute (AC97_BASEADDR, AC97_HEADPHONE_VOLUME_OFFSET);
	AC97_Unmute (AC97_BASEADDR, AC97_PCM_OUT_VOLUME_OFFSET);

	AC97_Set_Volume (AC97_BASEADDR, AC97_MASTER_VOLUME_OFFSET,
			BOTH_CHANNELS, VOLUME_MAX);
	AC97_Set_Volume (AC97_BASEADDR, AC97_HEADPHONE_VOLUME_OFFSET,
			BOTH_CHANNELS, VOLUME_MID);
	AC97_Set_Volume (AC97_BASEADDR, AC97_PCM_OUT_VOLUME_OFFSET,
			BOTH_CHANNELS, VOLUME_MID);
	/*	 * Select input source, enable it, and then set the volume	 */
	if (SW0state == XTRUE)	{
		AC97_Select_Input (AC97_BASEADDR, BOTH_CHANNELS,
				AC97_MIC_SELECT);
		/*AC97_Unmute (AC97_BASEADDR, AC97_LINE_IN_VOLUME_OFFSET);
			AC97_Set_Volume (AC97_BASEADDR, AC97_LINE_IN_VOLUME_OFFSET,
					BOTH_CHANNELS, VOLUME_MAX);*/
	}else{
		AC97_Select_Input (AC97_BASEADDR, BOTH_CHANNELS,
				AC97_LINE_IN_SELECT);
		/*AC97_Unmute (AC97_BASEADDR, AC97_MIC_VOLUME_OFFSET);
			AC97_Set_Volume (AC97_BASEADDR, AC97_MIC_VOLUME_OFFSET,
					BOTH_CHANNELS, VOLUME_MID);*/
	}
	//set record gain
	AC97_Set_Volume (AC97_BASEADDR, AC97_RECORD_GAIN_OFFSET,
			BOTH_CHANNELS, 0x00);
	AC97_Set_Tag_And_Id (AC97_BASEADDR, 0x9800); //Set to Send/Receive data

	Xil_Out32(LED_BASEADDR, 0xAA);

	/************************************************************************/

	if (SW0state == XTRUE)
	{
		/*	 * Wait for AC97 to become ready	 */
		while (!(AC97_Link_Is_Ready (AC97_1_BASEADDR)));
		/*	 * Set TAG to configure codec	 */
		AC97_Set_Tag_And_Id (AC97_1_BASEADDR, 0xF800);
		/*	 * Enable audio output and set volume	 */
		AC97_Unmute (AC97_1_BASEADDR, AC97_MASTER_VOLUME_OFFSET);
		AC97_Unmute (AC97_1_BASEADDR, AC97_HEADPHONE_VOLUME_OFFSET);
		AC97_Unmute (AC97_1_BASEADDR, AC97_PCM_OUT_VOLUME_OFFSET);

		AC97_Set_Volume (AC97_1_BASEADDR, AC97_MASTER_VOLUME_OFFSET,
				BOTH_CHANNELS, VOLUME_MAX);
		AC97_Set_Volume (AC97_1_BASEADDR, AC97_HEADPHONE_VOLUME_OFFSET,
				BOTH_CHANNELS, VOLUME_MID);
		AC97_Set_Volume (AC97_1_BASEADDR, AC97_PCM_OUT_VOLUME_OFFSET,
				BOTH_CHANNELS, VOLUME_MID);
		/*	 * Select input source, enable it, and then set the volume	 */
		AC97_Select_Input (AC97_1_BASEADDR, BOTH_CHANNELS,
				AC97_MIC_SELECT);
		//set record gain
		AC97_Set_Volume (AC97_1_BASEADDR, AC97_RECORD_GAIN_OFFSET,
				BOTH_CHANNELS, 0x00);
		AC97_Set_Tag_And_Id (AC97_1_BASEADDR, 0x9800); //Set to Send/Receive data
	}
	/************************************************************************/

	Xil_Out32(LED_BASEADDR, 0xFF);

	XIntc_Enable(&intCtrl, AC97_IRPT_ID);

	while (1)
	{

		if (R2==XTRUE){
			RUN=XTRUE;
			R2=XFALSE;
			for(k=0;k<128;k++){
				v1[k]=XIo_In32(CIP_BASEADDR+0x10);
				v2[k]=XIo_In32(CIP_BASEADDR+0x14);
				v3[k]=XIo_In32(CIP_BASEADDR+0x18);
				v4[k]=XIo_In32(CIP_BASEADDR+0x1C);
			}
			/*------------------------ALG go here---------------------------*/
			for(k = 0; k <128;k++){
				Y1in[0] = ((float)v1[k])/(float)4194304;
				Y1in[1] = ((float)v2[k])/(float)4194304;
				Y2in[0] = ((float)v3[k])/(float)4194304;
				Y2in[1] = ((float)v4[k])/(float)4194304;
				if(frame==0){//initial data
					Py1in = 0;
					Py2in = 0;
					Py12in = 0;
					Pnin = 0;
				}
				else{//use data previous
					Py1in = Py1[k];
					Py2in = Py2[k];
					Py12in = Py12[k];
					Pnin = Pn[k];
				}
				NoiseCance(Y1in,Y2in,Py1in,Py2in,Py12in,Pnin,frame,Py1o,Py2o,Py12o,Pno,Xesto);
				// loop data using calculate next state
				Py1[k] = Py1o[0];
				Py2[k] = Py2o[0];
				Py12[k]= Py12o[0];
				Pn[k]  = Pno[0];
				//output sent to IFFT
				ALG_OUT_RE[k] = (int)(Xesto[0]*(float)32768);// mul 100
				ALG_OUT_IM[k] = (int)(Xesto[1]*(float)32768);
			}
			chot=Count_64+(Xuint32)64*(frame-start_frame);// sample for calc
			if (chot < 0xFF)
				XIo_Out32(LED_BASEADDR,(chot<<2)+Count_error);	// display it
			else XIo_Out32(LED_BASEADDR,0xFF);
			/*------------------------W3-----------------------------*/
			for(k=0;k<128;k++)
			{
				XIo_Out32(CIP_BASEADDR+0x08,ALG_OUT_IM[k]);
				XIo_Out32(CIP_BASEADDR+0x0C,ALG_OUT_RE[k]);
				//XIo_Out32(CIP_BASEADDR+0x08,v2[k]);
				//XIo_Out32(CIP_BASEADDR+0x0C,v1[k]);
			}
			RUN=XFALSE;
		}
		else if (R5 ==XTRUE){
			R5 =XFALSE;
			for(k=0;k<64;k++)
			{
				v5[k]=XIo_In32(CIP_BASEADDR+0x20); // test
				PDATA[k]=v5[k]/64;
			}
//			if(chan_le==XCHAN){
//				for(k=0;k<128;k++)
//				{
//					v5[k]=XIo_In32(CIP_BASEADDR+0x24);
//					v5hn_chan[k]=(float)v5[k]*(float)HN[k]/(float)1048576;
//				}
//				for(k=0;k<64;k++)
//				{
//					PDATA[k]=(int)v5hn_chan[k]+(int)v5hn_le[k+64];
//				}
//			}
//			else{
//				for(k=0;k<128;k++)
//				{
//					v5[k]=XIo_In32(CIP_BASEADDR+0x24);
//					v5hn_le[k]=(float)v5[k]*(float)HN[k]/(float)1048576;
//				}
//				for(k=0;k<64;k++)
//				{
//					PDATA[k]=(int)v5hn_le[k]+(int)v5hn_chan[k+64];
//				}
//			}
		}
	}

	cleanup_platform();

	return 0;
}

/***	PushBtnHandler
 **	Parameters:
 **		CallBackRef - Pointer to the push button struct (pshBtns) initialized
 **		in main.
 **	Return Value:None
 **	Errors:None
 **	Description:
 **		Respond to various button pushes by triggering actions to occur outside
 **		the ISR. Actions are triggered by setting flags within the fsRunAction
 **		flag set variable.
 */
void PushBtnHandler(void *CallBackRef)
{
	XGpio *pPushBtn = (XGpio *)CallBackRef;
	u32 lBtnStateNew = XGpio_DiscreteRead(pPushBtn, lBtnChannel);
	u32 lBtnChanges = lBtnStateNew ^ lBtnStateOld;
	if (fsRunAction == 0)
	{
		if ((lBtnChanges & bitBtnD) && (lBtnStateNew & bitBtnD))
		{			fsRunAction = fsRunAction | bitGenWave;		}
		if ((lBtnChanges & bitBtnL) && (lBtnStateNew & bitBtnL))
		{			fsRunAction = fsRunAction | bitPlay;		}
		if ((lBtnChanges & bitBtnR) && (lBtnStateNew & bitBtnR))
		{			fsRunAction = fsRunAction | bitRec;		}
	}
	lBtnStateOld = lBtnStateNew;
	XGpio_InterruptClear(pPushBtn, lBtnChannel);
}


void AC97Handler(void *CallBackRef)
{
	static Xuint32 Count_6=0;
	int Sample_L;
	int Sample_R;
	XAC97 *aac97 = (XAC97 *)CallBackRef;
	int p;

	static int LDATA[64];
	static int RDATA[64];

	Count_6++;
	if (Count_6 >= 7 ) Count_6 = 1;
	else if (Count_6 == 6)
	{
		Count_64++;
		if(Count_64>=65) Count_64 = 1;

		/*----------------- freq 8khz---------------------------*/
		//Read audio data from codec
		Sample_L = XIo_In32(AC97_BASEADDR + AC97_PCM_IN_L_OFFSET);
		if (SW0state == XFALSE)	Sample_R = XIo_In32(AC97_BASEADDR + AC97_PCM_IN_R_OFFSET);
		else Sample_R = XIo_In32(AC97_1_BASEADDR + AC97_PCM_IN_R_OFFSET);

		LDATA[Count_64-1]= Sample_L*64;
		RDATA[Count_64-1]= Sample_R*64;
		/*----------------- send data to codec---------------------------*/
		if(SW1state==XFALSE) XIo_Out32 ((AC97_BASEADDR + AC97_PCM_OUT_L_OFFSET), Sample_L); //origin data
		else XIo_Out32 ((AC97_BASEADDR + AC97_PCM_OUT_L_OFFSET), Sample_R);
		XIo_Out32 ((AC97_BASEADDR + AC97_PCM_OUT_R_OFFSET), PDATA[Count_64]);//processed data
		/*----------------- create event---------------------------*/
		if		(Count_64==1){
			if (RUN==XTRUE)
				Count_error++;
			else {
				R2=XTRUE;
				start_frame=frame;// save start point.
			}
		}
		else if (Count_64==63){
			if (RUN==XTRUE)
				Count_error++;
			else R5=XTRUE;
		}
		else if (Count_64==64){
			/*-----------------send to CIP FFT-----------------*/
			for (p=0;p<64;p++){
				XIo_Out32(CIP_BASEADDR  ,LDATA[p]);
				XIo_Out32(CIP_BASEADDR+4,RDATA[p]);
			}
			frame++;
			chan_le=!chan_le;
		}
	}
	// clear interrupt
	Xil_Out32(XPAR_MICROBLAZE_0_INTC_BASEADDR+XIN_IAR_OFFSET,0x2);
}
