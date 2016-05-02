#include "math.h"
#include "mex.h"
#include <stdio.h>
#include <vector>
#include "matrix.h"
#include <algorithm>

using namespace std;

#define inputLabels(i,j) inputLabels[(i-1)+(j-1)*dimsIL[0]]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

	//2 input, 1 output
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
	for (int i = 1; i <= dimsIL[0]; i ++ ){
		for (int j = 1; j <= dimsIL[1]; j ++){
		
			currLabel = inputLabels(i,j);
			
			//left neighbor
			if (j>1){
				if(inputLabels(i,j-1)!=currLabel){
					neighbors[(mwSize)(currLabel-1)].push_back(inputLabels(i,j-1));
				}
			}
			
			//top neighbor
			if (i>1){
				if(inputLabels(i-1,j)!=currLabel){
					neighbors[(mwSize)(currLabel-1)].push_back(inputLabels(i-1,j));
				}
			}
			
			//right neighbor
			if (j < dimsIL[1]){
				if(inputLabels(i,j+1)!=currLabel){
					neighbors[(mwSize)(currLabel-1)].push_back(inputLabels(i,j+1));
				}
			}
			
			//bottom neighbor
			if (i < dimsIL[0]){
				if(inputLabels(i+1,j)!=currLabel){
					neighbors[(mwSize)(currLabel-1)].push_back(inputLabels(i+1,j));
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





















