#include "math.h"
#include "mex.h"
#include <stdio.h>
#include <vector>
#include "matrix.h"
#include <algorithm>

using namespace std;

#define tConnections(i,j) tConnections[(i-1)+(j-1)*dimsIL[0]]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

	//input 1: tConnections
	//input 2: top k to keep
	
	double *tConnections, *k; //*tvPr, 
	const mwSize *dimsIL;
	mxArray *tempVector;
	
	/*retrieve the input data */
	tConnections = mxGetPr(prhs[0]);
	k = mxGetPr(prhs[1]);
	
	/*find the dimensions of the input data*/
	dimsIL = mxGetDimensions(prhs[0]);

	/*set up output data: Cell array*/
	plhs[0] = mxCreateDoubleMatrix(dimsIL[0], 3, mxREAL);
	
	int count = (int)k[0];
	printf("k = %d\n", count);
	for (int i = 1; i < dimsIL[0]; i++){
	
		if (i > 1 && tConnections(i,1) != tConnections(i-1,1)){

			//reset the counter
			count = (int)k[0];
		}
	
		if (count == 0){
			tConnections(i,3) = 0;
		}
		else{
			count --;
		}
	}
	
	//memcpy(mxGetPr(plhs[0]), tConnections, dimsIL[0]*3*sizeof(double));

	
}





















