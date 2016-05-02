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
	double *inputImg, *spNeighbor, *labelsList, *affinMatrixI, *maxLabels, *hueImg, *satImg, *angles, *mag, *tvPr, *tvPr1, *tvPr2, *lbCentroids, *geoAffinity;
	double aDiff, bDiff, nzElements, nzMax, prcnt_sparse, iMax, cMax, oMax, temp, tempH, tempS, temp2, tempA, tempM, runningM1, runningM2;
	const mwSize *dimsIL;
	mwSize colSize, rowSize;
	double row, col, avgX, avgY, selfX, selfY, nX, nY;;
	mxArray *cElement, *neighbors, *plhsI[1], *prhsI[2], *plhsC[1], *prhsC[4], *plhsO[1], *prhsO[2], *uvU1, *uvV1;
	mxArray *inputImgG1, *inputImgG2, *hueImg1, *hueImg2, *satImg1, *satImg2, *spList1, *spList2, *mag1, *mag2, *angles1, *angles2, *tempVector1, *tempVector2, *tempVector3;
	int currFrameID, compFrameID;
	double histI1[256], cumsumI1[256], histC1x[77], histC1y[77], cumsumC1x[77], cumsumC1y[77], histO1[360], cumsumO1[360];
	double histI2[256], cumsumI2[256], histC2x[77], histC2y[77], cumsumC2x[77], cumsumC2y[77], histO2[360], cumsumO2[360];
	double d = 76.0;  //width and height of the 2d hue+saturation histogram
	int spList1L = 0;
	int spList2L = 0;
	int nonZeros1 = 0;
	int nonZeros2 = 0;
	int num1801 = 0;
	int num1802 = 0;
	int hist1OInvalid = 0;
	int hist2OInvalid = 0;
	int currLength = 0;
	vector<double> anglesV1;
	vector<double> anglesV2;
	double cR = 0;
	double cC = 0;
	
	/*retrieve the input data*/
	labelsList = mxGetPr(prhs[0]);
	maxLabels = mxGetPr(prhs[1]);
	lbCentroids = mxGetPr(prhs[9]);
	geoAffinity = mxGetPr(prhs[12]);
	//prhs[2] is spNeighbors
	//prhs[3] is spList


	/*set up the output data....later because we don't know how large*/
	mxArray* from = mxCreateDoubleMatrix(2500000,1,mxREAL);
	mxArray* to = mxCreateDoubleMatrix(2500000,1,mxREAL);
	mxArray* wi = mxCreateDoubleMatrix(2500000,1,mxREAL);
	mxArray* wc = mxCreateDoubleMatrix(2500000,1,mxREAL);
	mxArray* wo = mxCreateDoubleMatrix(2500000,1,mxREAL);
	mxArray* wg = mxCreateDoubleMatrix(2500000,1,mxREAL);
	mxArray* location = mxCreateDoubleMatrix(2500000,1,mxREAL);
	
	/*
	double  from[500000] = {0};
	double  to[500000] = {0};
	double  wi[500000] = {0};
	double  wc[500000] = {0};
	double  wo[500000] = {0};
	double  location[500000] = {0};
*/

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
	double normSize = sqrt(row*row + col*col)/2;
	//printf("normSize: %.4f\n", normSize);
	
	mwIndex count = 0;
	int isTemporal = 0;
	//for each superpixel, find its intensity, color, and gradient orientation EMD distances
	currFrameID = 1;
	for (mwSize i = 1; i <= (mwIndex)maxLabels[0]; i ++){
			
		
		if (i > labelsList[currFrameID-1]){
			currFrameID = currFrameID + 1;
		}
		
		inputImgG1 = mxGetCell(prhs[4], currFrameID-1);
		hueImg1 = mxGetCell(prhs[5], currFrameID-1);
		satImg1 = mxGetCell(prhs[6], currFrameID-1);
		mag1 = mxGetCell(prhs[7], currFrameID-1);
		angles1 = mxGetCell(prhs[8], currFrameID-1);
		uvU1 = mxGetCell(prhs[10], currFrameID-1);
		uvV1 = mxGetCell(prhs[11], currFrameID-1);

		//selfY = lbCentroids[(mwIndex)(i-1)];
		//selfX = lbCentroids[(mwIndex)(i-1+maxLabels[0])];
		
		compFrameID = currFrameID;
		inputImgG2 = mxGetCell(prhs[4], compFrameID-1);
		hueImg2 = mxGetCell(prhs[5], compFrameID-1);
		satImg2 = mxGetCell(prhs[6], compFrameID-1);
		mag2 = mxGetCell(prhs[7], compFrameID-1);
		angles2 = mxGetCell(prhs[8], compFrameID-1);
		
		//for all of its larger-ID neighbors only
		neighbors = mxGetCell(prhs[2], i-1);
		tvPr = mxGetPr(neighbors);
		rowSize = mxGetM(neighbors);
		spList1 = mxGetCell(prhs[3], i-1);
		spList1L = (int)mxGetM(spList1);
		
		//find the average motion of the source
		avgX = 0;
		avgY = 0;
		for (int k = 0; k < spList1L; k ++){
			avgX += mxGetPr(uvU1)[(mwIndex)(mxGetPr(spList1)[k])-1];
			avgY += mxGetPr(uvV1)[(mwIndex)(mxGetPr(spList1)[k])-1];
		}
		avgX /= (double)spList1L;
		avgY /= (double)spList1L;
		
		for (int j = 0; j < rowSize; j ++){
			
			if (tvPr[j] > i){
	
				isTemporal = 0;
				//if it is a temporal neighbor (overlapping)
				if (tvPr[j] > labelsList[currFrameID-1]){
					inputImgG2 = mxGetCell(prhs[4], compFrameID);
					hueImg2 = mxGetCell(prhs[5], compFrameID);
					satImg2 = mxGetCell(prhs[6], compFrameID);
					mag2 = mxGetCell(prhs[7], compFrameID);
					angles2 = mxGetCell(prhs[8], compFrameID);
					isTemporal = 1;
				}
				
				//update the from and to list
				mxGetPr(from)[count] = (double)i;
				mxGetPr(to)[count] = tvPr[j];
				//from[count] = (double)i;
				//to[count] = tvPr[j];
				
				//******************compute the location similarity********************************
				//use the Euclidean distance between the centroids
				/*
				if (i == 200 && (tvPr[j]-1) == 219){
					printf("201 centroids: %.4f, %.4f\n", mxGetPr(lbCentroids1)[i], mxGetPr(lbCentroids1)[i+labelsCount1]);
					printf("219 centroids: %.4f, %.4f\n", mxGetPr(lbCentroids2)[(mwIndex)(tvPr[j]-1)], mxGetPr(lbCentroids2)[(mwIndex)((tvPr[j]-1)+labelsCount2)]);
				}*/
				
				if (isTemporal == 1) {
					
					//nY = lbCentroids[(mwIndex)(tvPr[j]-1)];
					//nX = lbCentroids[(mwIndex)((tvPr[j]-1)+(mwIndex)maxLabels[0])];
					
					//cR = (nY-selfY)-uvV1; //y-direction offset from self
					//cC = (nX-selfX)-uvU1; //x-direction offset from self
					
					/*
					if (i == 481 && tvPr[j] == 774){
					printf("normSize: %.2f\n", normSize);
					printf("481 centroids: %.4f, %.4f, avgX: %.4f, avgY: %.4f\n", lbCentroids[(mwIndex)(i-1)], lbCentroids[(mwIndex)(i-1+maxLabels[0])], avgX, avgY);
					printf("774 centroids: %.4f, %.4f\n", lbCentroids[(mwIndex)(tvPr[j]-1)], lbCentroids[(mwIndex)((tvPr[j]-1)+(mwIndex)maxLabels[0])]);
					}*/
					

					cR = lbCentroids[(mwIndex)(tvPr[j]-1)]-lbCentroids[(mwIndex)(i-1)] - avgY;
					cC = lbCentroids[(mwIndex)((tvPr[j]-1)+(mwIndex)maxLabels[0])] - lbCentroids[(mwIndex)(i-1+maxLabels[0])]-avgX;
					
					mxGetPr(location)[count] = sqrt(cC*cC + cR*cR)/normSize;
					//location[count] = sqrt(cC*cC + cR*cR)/normSize;
				}else{
					mxGetPr(location)[count] = 1;
					//location[count] = 1;
				}
				
				//********************compute the intensity EMD********************************
				spList2 = mxGetCell(prhs[3], (mwIndex)(tvPr[j]-1));
				
				//build intensity histograms
				for (int k = 0; k < 256; k ++){
					histI1[k]  = 0.0;
					histI2[k] = 0.0;
				}
				
				//memset(histI1, 0, sizeof(histI1));
				//memset(histI2, 0, sizeof(histI2));
				//memset(cumsumI1, 0, sizeof(cumsumI1));
				//memset(cumsumI2, 0, sizeof(cumsumI2));
				for (int k = 0; k < spList1L; k ++){
					histI1[(mwIndex)round(mxGetPr(inputImgG1)[(mwIndex)(mxGetPr(spList1)[k])-1])] ++;

				}
				
				spList2L = (int)mxGetM(spList2);
				for (int k = 0; k < spList2L; k ++){
					histI2[(mwIndex)round(mxGetPr(inputImgG2)[(mwIndex)(mxGetPr(spList2)[k])-1])] ++;
				}
				
				//normalize both histograms such that they sum to 1
				for (int k = 0; k < 256; k ++){
					histI1[k] /= spList1L;
					histI2[k] /= spList2L;
				}
				
				//partial_sum (histI1, histI1+256, cumsumI1);
				//partial_sum (histI2, histI2+256, cumsumI2);
				for (int k = 1; k < 256; k ++){
					histI1[k] += histI1[k-1];
					histI2[k] += histI2[k-1];
				}
				
				temp = 0;
				for (int k = 0; k < 256; k ++){
					temp += abs(histI1[k]-histI2[k]);
				}
				
				mxGetPr(wi)[count] = (temp/256.0);
				//wi[count] = (temp/256.0);
				
				//********************compute the color EMD********************************
				//build color 2d histograms (hue + saturation)
				
				for (int k = 0; k < 77; k ++){
					histC1x[k] = 0.0;
					histC1y[k] = 0.0;
					histC2x[k] = 0.0;
					histC2y[k] = 0.0;
				}
				/*
				memset(histC1x, 0, sizeof(histC1x));
				memset(histC1y, 0, sizeof(histC1y));
				memset(histC2x, 0, sizeof(histC2x));
				memset(histC2y, 0, sizeof(histC2y));
				*/
				memset(cumsumC1x, 0, sizeof(cumsumC1x));
				memset(cumsumC1y, 0, sizeof(cumsumC1y));
				memset(cumsumC2x, 0, sizeof(cumsumC2x));
				memset(cumsumC1y, 0, sizeof(cumsumC1y));
				
				
				//build the index list of patch 1 
				for (int k = 0; k < spList1L; k ++){
					
					
					tempH = round(mxGetPr(hueImg1)[(mwIndex)(mxGetPr(spList1)[k])-1]);
					if (tempH == -1){
						tempH = 1;
					}
					/*
					tempS = mxGetPr(satImg1)[(mwIndex)(mxGetPr(spList1)[k])-1];
					
					//x-axis
					histC1x[(int)(round(cos(tempH*PI/180.0)*(d/2)*tempS) + (d/2))] ++;
					
					//y-axis
					histC1y[int(d+2-(round(sin(tempH*PI/180.0)*(d/2)*tempS) + (d/2)))] ++;
					
					*/
					//x-axis

					histC1x[(mwIndex)(round(cos(tempH*PI/180.0)*(d/2))+(d/2))] += 1.0;
					
					//y-axis
					histC1y[(mwIndex)(d+2-(round(sin(tempH*PI/180.0)*(d/2))+(d/2)))] += 1.0;
					
				
				}
				
				/*
				if (i == 14785 && j == 6){
					for (int k = 0; k < 77; k++){
						printf("%.1f\n", histC1x[k]);
					}
				}*/
				
				//build the index list of patch 1 
				for (int k = 0; k < spList2L; k ++){
					
					tempH = round(mxGetPr(hueImg2)[(mwIndex)(mxGetPr(spList2)[k])-1]);
					if (tempH == -1){
						tempH = 1;
					}
					
					/*
					tempS = mxGetPr(satImg2)[(mwIndex)(mxGetPr(spList2)[k])-1];
					
					//x-axis
					histC2x[(int)(round(cos(tempH*PI/180.0)*(d/2)*tempS) + (d/2))] ++;
					
					//y-axis
					histC2y[(int)(d+2-(round(sin(tempH*PI/180.0)*(d/2)*tempS) + (d/2)))] ++;
					*/
					//x-axis
					histC2x[(mwIndex)(round(cos(tempH*PI/180.0)*(d/2))+(d/2))] += 1.0;
					
					//y-axis
					histC2y[(mwIndex)(d+2-(round(sin(tempH*PI/180.0)*(d/2))+(d/2)))] += 1.0;
					
				}
				
				/*
				if (i == 14785 && j == 6){
					for (int k = 0; k < 77; k++){
						printf("%.1f\n", histC2y[k]);
					}
				}*/
				
				//normalize all histograms
				for (int k = 0; k < 77; k ++){
					histC1x[k] /= (double)spList1L;
					histC1y[k] /= (double)spList1L;
					histC2x[k] /= (double)spList2L;
					histC2y[k] /= (double)spList2L;
				}
				/*
				if (i == 14785 && j == 6){
					for (int k = 0; k < 77; k++){
						printf("%.3f\n", histC2y[k]);
					}
				}*/
				
				partial_sum (histC1x, histC1x+77, cumsumC1x);
				partial_sum (histC1y, histC1y+77, cumsumC1y);
				partial_sum (histC2x, histC2x+77, cumsumC2x);
				partial_sum (histC2y, histC2y+77, cumsumC2y);
				
				/*
				for (int k = 1; k < 77; k ++){
					histC1x[k] += histC1x[k-1];
				}
				for (int k = 1; k < 77; k ++){
					histC2x[k] += histC2x[k-1];
				}
				for (int k = 1; k < 77; k ++){
					histC1y[k] += histC1y[k-1];
				}
				for (int k = 1; k < 77; k ++){
					histC2y[k] += histC2y[k-1];
				}*/
				
				/*
				if (count == 140766){
					for (int k = 0; k < 77; k++){
						printf("abs(%.3f - %.3f) = %.3f \n", histC1x[k], histC2x[k], abs(histC1x[k]-histC2x[k]));
					}
				}*/
				
				temp = 0.0;
				temp2 = 0.0;
				/*
				if (count == 140766){
					printf("temp = %.3f\n", temp);
					printf("temp2 = %.3f\n", temp2);
				}*/
				
				for (int k = 0; k < 77; k ++){
					temp += abs(cumsumC1x[k]-cumsumC2x[k]);
					temp += abs(cumsumC1y[k]-cumsumC2y[k]);
					//temp += abs(histC1x[k]-histC2x[k]);
					//temp2 += abs(histC1y[k]-histC2y[k]);
				}
				/*
				if (count == 140766){
					printf("temp = %.3f\n", temp);
					printf("temp2 = %.3f\n", temp2);
					printf("(temp/77.0) + (temp2/77.0) = %.3f\n", (temp/77.0) + (temp2/77.0));
				}*/
				/*
				if (temp >= 77){
					temp = 38.5;
				}
				if (temp2 >= 77){
					temp2 = 38.5;
				}*/
				
				mxGetPr(wc)[count] = (temp/77.0) + (temp2/77.0);
				//wc[count] = (temp/77.0) + (temp2/77.0);
				
				/*
				if (count == 140766){
					printf("wc[%d] = %.3f\n", count, wc[count]);

				}*/
				
				//********************compute the *texture EMD********************************
				
				//using gradient orientation
				//build the index list of patch 1 
				anglesV1.clear();
				anglesV2.clear();
				nonZeros1 = 0;
				nonZeros2 = 0;
				runningM1 = 0;
				runningM2 = 0;
				num1801 = 0;
				num1802 = 0;
				hist1OInvalid = 0;
				hist2OInvalid = 0;
				currLength = 0;
				
				//memset(histO1, 0, sizeof(histO1));
				//memset(histO2, 0, sizeof(histO2));
				memset(cumsumO1, 0, sizeof(cumsumO1));
				memset(cumsumO2, 0, sizeof(cumsumO2));
				for (int k = 0; k < 360; k ++){
						histO1[k] = 0.0;
						histO2[k] = 0.0;
				}
				
				//patch 1
				for (int k = 0; k < spList1L; k ++){
					
					//first patch
					tempM = mxGetPr(mag1)[(mwIndex)(mxGetPr(spList1)[k])-1];
					tempA = mxGetPr(angles1)[(mwIndex)(mxGetPr(spList1)[k])-1];
					
					runningM1 += tempM;
					if (tempA != 0){
						nonZeros1++;
						anglesV1.push_back(tempA/PI*180);
					}
					
					if (tempA == 180.0){
						num1801 ++;
					}

				}
				
				//patch 2
				for (int k = 0; k < spList2L; k ++){
					
					//first patch
					tempM = mxGetPr(mag2)[(mwIndex)(mxGetPr(spList2)[k])-1];
					tempA = mxGetPr(angles2)[(mwIndex)(mxGetPr(spList2)[k])-1];
					
					runningM2 += tempM;
					if (tempA != 0){
						nonZeros2++;
						anglesV2.push_back(tempA/PI*180);
					}
					
					if (tempA == 180.0){
						num1802 ++;
					}

				}
				
				if (((double)nonZeros1 > 0.3*spList1L) && ((double)nonZeros2 > 0.3*spList2L) && ((double)runningM1/spList1L > 10) && ((double)runningM2/spList2L > 10)){
				
					//patch 1
					for (int k = 0; k < num1801; k ++){
						anglesV1.push_back(0.0);
					}
				
					for (int k = 0; k < anglesV1.size(); k ++){
						if (anglesV1.at(k) <= 0){
							anglesV1.at(k) += 360;
						}
						histO1[(mwIndex)round(anglesV1.at(k))-1] ++;
						if (anglesV1.at(k) < 181){
							histO1[(mwIndex)round(anglesV1.at(k))-1+180] ++;
						}
					}
				
					//finally, make the histogram
					for (int k = 0; k < 180; k ++){
						histO1[k] = histO1[k+180];
						
					}
					
					partial_sum (histO1, histO1+360, cumsumO1);
					for (int k = 0; k < 360; k ++){
						histO1[k] /= cumsumO1[359];
					}

					memset(cumsumO1, 0, sizeof(cumsumO1));
					partial_sum (histO1, histO1+360, cumsumO1);
					
					/*
					double val = 0;
					for (int k = 0; k < 360; k ++){
						val += histO1[k];
					}
					for (int k = 0; k < 360; k ++){
						histO1[k] /= val;	
					}
					
					for (int k = 1; k < 360; k ++){
						histO1[k] += histO1[k-1];
					}*/
					
					//patch 2
					for (int k = 0; k < num1802; k ++){
						anglesV2.push_back(0.0);
					}
				
					for (int k = 0; k < anglesV2.size(); k ++){
						if (anglesV2.at(k) <= 0){
							anglesV2.at(k) += 360;
						}
						histO1[(mwIndex)round(anglesV2.at(k))-1] ++;
						if (anglesV2.at(k) < 181){
							histO2[(mwIndex)round(anglesV2.at(k))-1+180] ++;
						}
					}
				
					//finally, make the histogram
					for (int k = 0; k < 180; k ++){
						histO2[k] = histO2[k+180];
					}
				
					
					partial_sum (histO2, histO2+360, cumsumO2);
					for (int k = 0; k < 360; k ++){
						histO2[k] /= cumsumO2[359];
						
					}
					memset(cumsumO2, 0, sizeof(cumsumO2));
					partial_sum (histO2, histO2+360, cumsumO2);
					
					/*
					val = 0;
					for (int k = 0; k < 360; k ++){
						val += histO2[k];
					}
					for (int k = 0; k < 360; k ++){
						histO2[k] /= val;	
					}
					for (int k = 1; k < 360; k ++){
						histO2[k] += histO2[k-1];
					}*/
					
					temp = 0;
					for (int k = 0; k < 360; k ++){
						temp += abs(cumsumO1[k]-cumsumO2[k]);					
						//temp += abs(histO1[k]-histO2[k]);
						//printf("%.4f\n", temp);
					}

					mxGetPr(wo)[count] = temp/90.0;
					
					//wo[count] = temp/90.0;
					//printf("%.4f\n", wo[count]);
				} 

				else{
					//wo[count] = 0.0000001;
					
					mxGetPr(wo)[count] = 0.0;
					//wo[count] = 0.0;
				}
				
				//get the geodesic distance value
				mxGetPr(wg)[count] = geoAffinity[i-1 + ((int)tvPr[j]-1)*(int)maxLabels[0]];
				
				count ++;

			}
		}
		
	}
	
	//set up the outputs
	plhs[0] = mxCreateDoubleMatrix(count, 1, mxREAL);
	plhs[1] = mxCreateDoubleMatrix(count, 1, mxREAL);
	plhs[2] = mxCreateDoubleMatrix(count, 1, mxREAL);
	plhs[3] = mxCreateDoubleMatrix(count, 1, mxREAL);
	plhs[4] = mxCreateDoubleMatrix(count, 1, mxREAL);
	plhs[5] = mxCreateDoubleMatrix(count, 1, mxREAL);
	plhs[6] = mxCreateDoubleMatrix(count, 1, mxREAL);
	
	/*
	for (int i = 0; i < count; i ++){
		mxGetPr(plhs[0])[i] = mxGetPr(from)[i];
		mxGetPr(plhs[1])[i] = mxGetPr(to)[i];
		mxGetPr(plhs[2])[i] = mxGetPr(wi)[i];
		mxGetPr(plhs[3])[i] = mxGetPr(wc)[i];
		mxGetPr(plhs[4])[i] = mxGetPr(wo)[i];
		mxGetPr(plhs[5])[i] = mxGetPr(location)[i];
	}*/
	
	memcpy(mxGetPr(plhs[0]), mxGetPr(from), count*sizeof(double));
	memcpy(mxGetPr(plhs[1]), mxGetPr(to), count*sizeof(double));
	memcpy(mxGetPr(plhs[2]), mxGetPr(wi), count*sizeof(double));
	memcpy(mxGetPr(plhs[3]), mxGetPr(wc), count*sizeof(double));
	memcpy(mxGetPr(plhs[4]), mxGetPr(wo), count*sizeof(double));
	memcpy(mxGetPr(plhs[5]), mxGetPr(location), count*sizeof(double));
	memcpy(mxGetPr(plhs[6]), mxGetPr(wg), count*sizeof(double));
	/*
	mxFree(from);
	mxFree(to);
	mxFree(wi);
	mxFree(wc);
	mxFree(wo);
	mxFree(location);
	*/
}







