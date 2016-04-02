/* Copyright (C) 2010 Joao Carreira

 This code is part of the extended implementation of the paper:
 
 J. Carreira, C. Sminchisescu, Constrained Parametric Min-Cuts for Automatic Object Segmentation, IEEE CVPR 2010
 */

/*---
function [i] = segm_intersection_mex(segms)
Input:
    segms - binary matrix, with segms in columns  

Output:
    i = symmetric overlap matrix

Joao Carreira, February 2010
--*/

#include "omp.h"
#include "mex.h"
#include "math.h"
#include "time.h"

void intersection(unsigned int *intersections, mxLogical *segms, int nc, int nr) {
    int i, j, index_ij, index_ik, index_jk, k;

    {
#pragma omp parallel for private(index_ik, index_jk, index_ij, i, j, k)
        for(i=0; i<nc; i++) { /* for each segment */
            for(j=i+1; j<nc; j++) { /* go through the others with j>i */
                index_ij = i*nc + j;
                intersections[index_ij] = 0;

                for( k=0; k<nr; k++) { /* compute intersections */
                    index_ik = i*nr + k;
                    index_jk = j*nr + k;
                    intersections[index_ij] = intersections[index_ij] + (segms[index_ik] * segms[index_jk]);     
                }
            }
        }
    }
    return;
}

void mexFunction(
    int nargout,
    mxArray *out[],
    int nargin,
    const mxArray *in[]) {

    /* declare variables */
    int nr, nc;
	register unsigned int i, j;
    mxLogical *segms;
    unsigned int *intersections;
    
    /* check argument */
    if (nargin<1) {
        mexErrMsgTxt("One input argument required ( the segments in column form and the minimum intersection before stopping)");
    }
    if (nargout>1) {
        mexErrMsgTxt("Too many output arguments");
    }

    nr = mxGetM(in[0]);
    nc = mxGetN(in[0]);

    if (!mxIsLogical(in[0]) || mxGetNumberOfDimensions(in[0]) != 2) {
        mexErrMsgTxt("Usage: segms must be a logical matrix");
    }

    segms = (bool *) mxGetData(in[0]);
     
    /*intersections = (unsigned int *)malloc(nc* nc*sizeof(unsigned int));*/    
    
    out[0] = mxCreateNumericMatrix(nc,nc,mxUINT32_CLASS, (mxComplexity) 0);
    if (out[0]==NULL) {
	    mexErrMsgTxt("Not enough memory for the output matrix");
    }
    intersections = (unsigned int *) mxGetPr(out[0]);    
	 
    intersection(intersections, segms, nc, nr);

    /* copy lower triangle to upper triangle; matrix is symmetric */
    for (i=0; i<nc; i++) {      
        /*mexPrintf("i: %d\n",i);*/
        for(j=i+1; j<nc; j++) {   
            /*mexPrintf("j: %d\n",j);
            mexPrintf("index: %d\n", j*nc+i);*/
            intersections[j*nc+i] = intersections[i*nc+j];
        }
    }
    
    /* fill diagonal with ones */
    for (i=0; i<nc; i++) {
       intersections[i*nc+i] = 1;
    }
        
}
