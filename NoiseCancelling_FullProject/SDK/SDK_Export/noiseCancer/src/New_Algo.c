/*
 * New_Algo.c
 *
 *  Created on: Feb 27, 2014
 *      Author: truongbinh
 */
#include "mul_complex.h"
#include "math.h"
#include "stdio.h"
#include "xparameters.h"


void NoiseCance(float Y1in[2], float Y2in[2],float Py1in, float Py2in, float Py12in, float Pnin,int i, float Py1[1],float Py2[1], float Py12[1], float Pn[1], float Xest[2])
{
	float an = 0.95, ax = 0.75;
	float Dmin = 0.2, Dmax = 0.8;
	float Linit = 1;
	float YY2, YY1, YY12;
	float Dq, Dd;
	float Rx12, g;
	float H12;
	float G, Hexp;
	float A[2], B[2], C[2];
	A[0] = Y1in[0];
	A[1] = Y1in[1];
	B[0] = Y1in[0];
	B[1] = -Y1in[1];
	mul_c_float(A,B,C);
	YY1 = C[0];
	A[0] = Y2in[0];
	A[1] = Y2in[1];
	B[0] = Y2in[0];
	B[1] = -Y2in[1];
	mul_c_float(A,B,C);
	YY2 = C[0];
	A[0] = Y1in[0];
	A[1] = Y1in[1];
	B[0] = Y2in[0];
	B[1] = -Y2in[1];
	mul_c_float(A,B,C);
	YY12 = sqrtf(C[0]*C[0]+C[1]*C[1]);
	//update noisy
	Py1[0] = ax*Py1in + (1-ax)*YY1;
	Py2[0] = ax*Py2in + (1-ax)*YY2;
	Py12[0] = ax*Py12in+(1-ax)*YY12;

	if(i<Linit)
	{
		Xest[0] = 0;
		Xest[1] = 0;
		Pn[0] = Py2[0];
	}
	else
	{
		Rx12 = Py12[0]/sqrtf(Py1[0]*Py2[0]);
		Dq = (Py1[0]-Py2[0])/(Py1[0]+Py2[0]);
		Dd = (Py1[0]-Py2[0]);
		Dq = Dq>0?Dq:-Dq;
		Dd = Dd>0?Dd:0;
		if(Rx12<Dmin)
			g = 0.8944;
		else if(Rx12>Dmin)
			g = 0.4472;
		else
			g = sqrtf(1-Rx12);


		if(Dq<Dmin)
			Pn[0] = an*Pnin + (1-an)*YY1;
		else if(Dq>Dmax)
			Pn[0] = Pnin;
		else
			Pn[0] = an*Pnin + (1-an)*YY2;

		H12 = (Py12[0] - g*Pn[0])/(Py1[0]-Pn[0]);
		H12 = H12>0?H12:-H12;
		Hexp = 1-H12*H12;
		Hexp = Hexp>0?Hexp:-Hexp;
		G = Dd/(Dd + g*Pn[0]*Hexp);
		Xest[0] = G*Y1in[0];
		Xest[1] = G*Y1in[1];

	}



}

