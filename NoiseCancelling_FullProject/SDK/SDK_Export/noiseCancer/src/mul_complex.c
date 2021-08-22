/*
 * mul_complex.c
 *
 *  Created on: Feb 13, 2014
 *      Author: truongbinh
 */
#include "math.h"

void mul_c_float(float A[2], float B[2], float C[2])
{
	C[0] = (A[0]*B[0] - A[1]*B[1]);
	C[1] = (A[0]*B[1] + A[1]*B[0]);

}
