#include "math.h"
#include "mex.h"
#include <stdio.h>
#include <vector>
#include "matrix.h"
#include <algorithm>

using namespace std;

#define inputLabels(i,j,k) inputLabels[((i-1)+(j-1)*dimsIL[0])+(k-1)*dimsIL[0]*dimsIL[1]]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

	//input 1: labels
	//input 2: maxLabels
	//input 3: get temporal neighbors or not (0 is no, 1 is yes)
	//input 4: the temporal neighbors search window
	double *inputLabels, *maxLabels, currLabel; //*tvPr, 
	const mwSize *dimsIL;
	mwSize colSize;
	mxArray *tempVector;
	
	/*retrieve the input data */
	inputLabels = mxGetPr(prhs[0]);
	maxLabels = mxGetPr(prhs[1]);
	
	/*find the dimensions of the input data*/
	dimsIL = mxGetDimensions(prhs[0]);

	/*set up output data: Cell array*/
	plhs[0] = mxCreateCellMatrix((mwSize)maxLabels[0], 1);
	
	//declare the neighbor list 2d vector
	vector<vector<double>> neighbors((mwSize)maxLabels[0],vector<double>(0));

	//iterate through the data label map and populate the 2d neighbor-list vector
	//by default it is looking for 4-neighbors
	for (int k = 1; k <= dimsIL[2]; k ++){
	
		for (int i = 1; i <= dimsIL[0]; i ++ ){
			for (int j = 1; j <= dimsIL[1]; j ++){
		
				currLabel = inputLabels(i,j,k);
			
				//left neighbor
				if (j>1){
					if(inputLabels(i,j-1,k)!=currLabel){
						neighbors[(mwSize)(currLabel-1)].push_back(inputLabels(i,j-1,k));
					}
				}
			
				//top neighbor
				if (i>1){
					if(inputLabels(i-1,j,k)!=currLabel){
						neighbors[(mwSize)(currLabel-1)].push_back(inputLabels(i-1,j,k));
					}
				}
			
				//right neighbor
				if (j < dimsIL[1]){
					if(inputLabels(i,j+1,k)!=currLabel){
						neighbors[(mwSize)(currLabel-1)].push_back(inputLabels(i,j+1,k));
					}
				}
			
				//bottom neighbor
				if (i < dimsIL[0]){
					if(inputLabels(i+1,j,k)!=currLabel){
						neighbors[(mwSize)(currLabel-1)].push_back(inputLabels(i+1,j,k));
					}
				}
				
				if (mxGetPr(prhs[2])[0] == 1){
				/*
					//previous frame temporal neighbor
					if (k > 1){
						neighbors[(mwSize)(currLabel-1)].push_back(inputLabels(i,j,k-1));
					}
				*/
					//next frame temporal neighbor
					if (k < dimsIL[2]){
						neighbors[(mwSize)(currLabel-1)].push_back(inputLabels(i,j,k+1));
					}
				}
			}
		}
		
	}
	
	//place the vector to the output cell
	for (mwSize i = 0; i < neighbors.size(); i ++){
	
		//sort and remove duplicates
		sort( neighbors[i].begin(), neighbors[i].end());
		neighbors[i].erase(unique(neighbors[i].begin(), neighbors[i].end()), neighbors[i].end());
	
	
		//populate the mxArray to be passed to the cell array
		colSize = neighbors[i].size();

		tempVector = mxCreateDoubleMatrix(colSize, 1, mxREAL);

		for (mwSize j = 0; j < colSize; j ++){
			
			((double*)mxGetPr(tempVector))[j] = neighbors[i].at(j);
		}
		
		//make a deep copy
		mxSetCell(plhs[0], i, mxDuplicateArray(tempVector));
	
		mxDestroyArray(tempVector);
		
	}
	
}





















