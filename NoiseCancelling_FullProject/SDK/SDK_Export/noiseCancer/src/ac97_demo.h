/************************************************************************/
/*																		*/
/*	ac97_demo.h	--	Interface Declarations for ac97_demo.c				*/
/*																		*/
/************************************************************************/
/*	Author:	Sam Bobrowicz												*/
/*	Copyright 2011, Digilent Inc.										*/
/************************************************************************/
/*  File Description: 													*/
/*																		*/
/*	This Header file contains the interface and constant definitions	*/
/*	used by ac97_demo.c. 												*/
/*																		*/
/************************************************************************/
/*  Revision History:													*/
/* 																		*/
/*		11/4/2011(SamB): Created										*/
/*																		*/
/************************************************************************/

#ifndef AC97_DEMO_H
#define AC97_DEMO_H

/* ------------------------------------------------------------ */
/*					Constant Definitions						*/
/* ------------------------------------------------------------ */

#define lBtnChannel	1//GPIO channel of the push buttons

/*
 * Push Button bit definitions
 */
#define bitBtnC 0x00000001
#define bitBtnR 0x00000002
#define bitBtnD 0x00000004
#define bitBtnL 0x00000008
#define bitBtnU 0x00000010

/*
 * DIP Switch bit definitions
 */
#define bitSw0 0x00000001
#define bitSw1 0x00000002

/*
 * LED bit definitions
 */
#define bitRecLED 0x00000001
#define bitPlayLED 0x00000002

/*
 * Run action flag set bit definitions
 */
#define bitPlay 0x01
#define bitRec 0x02
#define bitGenWave 0x04

/*
 * Recorded data properties
 */
#define lSampleRate 8000
#define lRecLength 5
#define lNumSamples (lSampleRate * lRecLength)

#define XCHAN XFALSE
#define XLE XTRUE

/* ------------------------------------------------------------ */
/*					Procedure Declarations						*/
/* ------------------------------------------------------------ */

void PushBtnHandler(void *CallBackRef);

void AC97Handler(void *CallBackRef);


/* ------------------------------------------------------------ */
#endif
