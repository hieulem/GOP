#include "math.h"
#include "mex.h"
#include <stdio.h>
#include <vector>
#include "matrix.h"
#include <algorithm>
#include <numeric>

using namespace std;

//#define inputLabels(i,j) inputLabels[(i-1)+(j-1)*dimsIL[0]]
//#define inputImg(i,j,k) inputImg[((i-1)+(j-1)*dimsIL[0])+(k-1)*dimsIL[0]*dimsIL[1]]
//#define affinMatrixI(i,j) affinMatrixI[(i-1)+(j-1)*(mwSize)maxLabels[0]]
#define PI 3.14159265358979323846 
static inline double round(double x) { return (floor(x + 0.5)); } 

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	
	//9 input, 5 output
	double *inputImg, *spNeighbor, *labelsList, *affinMatrixI, *maxLabels, *hueImg, *satImg, *angles, *mag, *tvPr, *tvPr1, *tvPr2, *lbCentroids, *lastFrame;
	double aDiff, bDiff, nzElements, nzMax, prcnt_sparse, iMax, cMax, oMax, temp, tempH, tempS, temp2, tempA, tempM, runningM1, runningM2;
	const mwSize *dimsIL;
	mwSize colSize, rowSize;
	double row, col;
	mxArray *cElement, *neighbors, *plhsI[1], *prhsI[2], *plhsC[1], *prhsC[4], *plhsO[1], *prhsO[2];
	mxArray *inputImgG1, *inputImgG2, *uvU1, *uvU2, *uvV1, *uvV2, *spList1, *spList2, *mag1, *mag2, *angles1, *angles2, *tempVector1, *tempVector2, *tempVector3;
	int currFrameID, compFrameID;
	double histI1[256], cumsumI1[256], histC1x[50], histC1y[50], cumsumC1x[50], cumsumC1y[50];
	double histI2[256], cumsumI2[256], histC2x[50], histC2y[50], cumsumC2x[50], cumsumC2y[50];
	int spList1L = 0;
	int spList2L = 0;
	int nonZeros1 = 0;
	int nonZeros2 = 0;
	int num1801 = 0;
	int num1802 = 0;
	int hist1OInvalid = 0;
	int hist2OInvalid = 0;
	int currLength = 0;
	int ignore = 0;
	
	double cR = 0;
	double cC = 0;
	
	/*retrieve the input data*/
	labelsList = mxGetPr(prhs[0]);
	maxLabels = mxGetPr(prhs[1]);
	lastFrame = mxGetPr(prhs[6]);
	//prhs[2] is spNeighbors
	//prhs[3] is spList


	/*set up the output data....later because we don't know how large*/
	//double from[400000] = {0};
	//double to[400000] = {0};
	//double wm[400000] = {0};
	mxArray* wm = mxCreateDoubleMatrix(2500000,1,mxREAL);

	/*
	prhsC[0] = mxCreateDoubleMatrix(1,1,mxREAL);
	prhsC[1] = mxCreateDoubleMatrix(1,1,mxREAL);
	prhsC[2] = mxCreateDoubleMatrix(1,1,mxREAL);
	prhsC[3] = mxCreateDoubleMatrix(1,1,mxREAL);
	mxGetPr(prhsC[0])[0] = 0.0;
	mxGetPr(prhsC[1])[0] = 180.0;
	mxGetPr(prhsC[2])[0] = 1.0;
	mxGetPr(prhsC[3])[0] = 1.0;
	plhsC[0] = mxCreateDoubleMatrix(1,1,mxREAL);
	mexCallMATLAB(1,plhsC,4,prhsC,"colorEMD");
	cMax = mxGetScalar(plhsC[0]);
	mxDestroyArray(prhsC[0]);
	mxDestroyArray(prhsC[1]);
	mxDestroyArray(prhsC[2]);
	mxDestroyArray(prhsC[3]);
	mxDestroyArray(plhsC[0]);

	oMax = 90.0;	
	*/
	
	row = mxGetM(mxGetCell(prhs[4], 0));
	col = mxGetN(mxGetCell(prhs[4], 0));
	double normSize = sqrt(row*row + col*col);
	//printf("normSize: %.4f\n", normSize);
	
	int count = 0;
	int isTemporal = 0;
	//for each superpixel, find its intensity, color, and gradient orientation EMD distances
	currFrameID = 1;
	for (mwSize i = 1; i <= (mwIndex)maxLabels[0]; i ++){
		
		if (i > labelsList[currFrameID-1]){
			currFrameID = currFrameID + 1;
		}
		
		uvU1 = mxGetCell(prhs[4], currFrameID-1);
		uvV1 = mxGetCell(prhs[5], currFrameID-1);
	
		
		compFrameID = currFrameID;
		uvU2 = mxGetCell(prhs[4], compFrameID-1);
		uvV2 = mxGetCell(prhs[5], compFrameID-1);
			
		//for all of its larger-ID neighbors only
		neighbors = mxGetCell(prhs[2], i-1);
		tvPr = mxGetPr(neighbors);
		rowSize = mxGetM(neighbors);
		spList1 = mxGetCell(prhs[3], i-1);
		spList1L = (int)mxGetM(spList1);
		
		ignore = 0;
		
		if (currFrameID > (int)lastFrame[0]){
			ignore = 1;
		}
		
		for (int j = 0; j < rowSize; j ++){
			
			if (tvPr[j] > i){

				//printf("%d, %d, %d \n", i, (mwIndex)tvPr[j], count);
			
				//if it is a temporal neighbor (overlapping)
				if (tvPr[j] > labelsList[currFrameID-1]){
					uvU2 = mxGetCell(prhs[4], compFrameID);
					uvV2 = mxGetCell(prhs[5], compFrameID);
					
					//if (currFrameID == (int)lastFrame[0]){
						ignore = 1;
					//}
				}
				
				//update the from and to list
				//from[count] = (double)i;
				//to[count] = tvPr[j];
				
				if (ignore == 1){
				//if (from[count] == 29395 && to[count] == 29396){
				//	printf("here01\n");
				//}
					mxGetPr(wm)[count] = 10.0;
				}
				
				else {

				spList2 = mxGetCell(prhs[3], (mwIndex)(tvPr[j]-1));
				spList2L = (int)mxGetM(spList2);
				
				//********************compute the color EMD********************************
				//build color 2d histograms (hue + saturation)
				memset(histC1x, 0, sizeof(histC1x));
				memset(histC1y, 0, sizeof(histC1y));
				memset(histC2x, 0, sizeof(histC2x));
				memset(histC2y, 0, sizeof(histC2y));
				memset(cumsumC1x, 0, sizeof(cumsumC1x));
				memset(cumsumC1y, 0, sizeof(cumsumC1y));
				memset(cumsumC2x, 0, sizeof(cumsumC2x));
				memset(cumsumC1y, 0, sizeof(cumsumC1y));
				/*
				if (from[count] == 29395 && to[count] == 29396){
					printf("here01\n");
				}*/
				
				for (int k = 0; k < spList1L; k ++){
				/*
				if (i == 1 && j == 0){
				printf("from: %.0f, to: %.0f, LAB value: %d\n", from[count], to[count], (mwIndex)round(mxGetPr(uvU1)[(mwIndex)(mxGetPr(spList1)[k])-1])+100);
				}*/
					histC1x[(int)(round(mxGetPr(uvU1)[(mwIndex)(mxGetPr(spList1)[k])-1])-1)] ++;
					histC1y[(int)(round(mxGetPr(uvV1)[(mwIndex)(mxGetPr(spList1)[k])-1])-1)] ++;
					
					
				}
				/*
				if (from[count] == 29395 && to[count] == 29396){
					printf("here02\n");
				}*/

				for (int k = 0; k < spList2L; k ++){
					histC2x[(int)(round(mxGetPr(uvU2)[(mwIndex)(mxGetPr(spList2)[k])-1]))-1] ++;
					histC2y[(int)(round(mxGetPr(uvV2)[(mwIndex)(mxGetPr(spList2)[k])-1])-1)] ++;

				}
				/*
				if (from[count] == 29395 && to[count] == 29396){
					printf("here03\n");
				}*/
				
				//normalize both histograms such that they sum to 1
				for (int k = 0; k < 50; k ++){
					histC1x[k] /= (double)spList1L;
					histC1y[k] /= (double)spList1L;
					histC2x[k] /= (double)spList2L;
					histC2y[k] /= (double)spList2L;
				}
				/*
				if (from[count] == 29395 && to[count] == 29396){
					printf("here04\n");
				}*/
				
				partial_sum (histC1x, histC1x+50, cumsumC1x);
				partial_sum (histC1y, histC1y+50, cumsumC1y);
				partial_sum (histC2x, histC2x+50, cumsumC2x);
				partial_sum (histC2y, histC2y+50, cumsumC2y);
				/*
				if (from[count] == 29395 && to[count] == 29396){
					printf("here05\n");
				}*/
				
				temp = 0;
				temp2 = 0;
				for (int k = 0; k < 50; k ++){
					temp += abs(cumsumC1x[k]-cumsumC2x[k]);
					temp2 += abs(cumsumC1y[k]-cumsumC2y[k]);
				}
				/*
				if (from[count] == 29395 && to[count] == 29396){
					printf("here06\n");
				}*/
				
				mxGetPr(wm)[count] = (temp/50.0) + (temp2/50.0);
				
				}
				
				count ++;

			}
		}
		
	}
	//if (from[count] == 29395 && to[count] == 29396){
	//				printf("here02, count = %d\n", count);
	//			}
	//set up the outputs
	plhs[0] = mxCreateDoubleMatrix(count, 1, mxREAL );
	//plhs[0] = mxCreateNumericMatrix(count, 1, mxDOUBLE_CLASS, mxREAL);
	//printf("here02.0, count = %d\n", count);
	//plhs[1] = mxCreateDoubleMatrix(count, 1, mxREAL );
	//printf("here02.1, count = %d\n", count);
	//plhs[2] = mxCreateDoubleMatrix(count, 1, mxREAL );
//if (from[count] == 29395 && to[count] == 29396){
				//	printf("here03\n");
			//	}
	//memcpy(mxGetPr(plhs[0]), from, count*sizeof(double));
	//memcpy(mxGetPr(plhs[1]), to, count*sizeof(double));
	memcpy(mxGetPr(plhs[0]), mxGetPr(wm), count*sizeof(double));


}







