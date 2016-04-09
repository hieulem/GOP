/*
 *Mex function for the computation of similarity between masks based on the Dice coefficient
 
 *Use: similarity=Measuresimilaritymex(newmask,predictedMask,[printonscreen]);
 *newmask and [printonscreen] must be booleans

 * mex Measuresimilaritymex.cpp
*/



/* INCLUDES: */
#include "mex.h"
#include "matrix.h"

 #include "limits.h"
 #include "math.h"

#include "float.h"
#include "stdlib.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{


    /* DECLARATIONS: */
    double *predictedMask; /* input arguments  */
    bool *newmask, *printonscreen; /* input arguments  */
    double *similarity; /* output arguments  */
    
    
    int k; /* counters for processing the video */
    
    int nomatrixelements; /* no elements in the input matrices */
    
    double relevantpredicted=0;
    double relevantnewmask=0;
    double sumpredicted=0;
    double sumnewmask=0;
    
    
    
	nomatrixelements=(int)mxGetNumberOfElements(prhs[0]);
    if (nomatrixelements != (int)mxGetNumberOfElements(prhs[1]))
        mexErrMsgTxt("Size of input matrices must be the same\n");
    
    /* mexPrintf("nlhs %d, nrhs %d\n",nlhs,nrhs); */

    
    
	/* GET MEX INPUT: */
    newmask = (bool *)mxGetPr(prhs[0]);
    predictedMask = mxGetPr(prhs[1]);
    
    
    /* Initialise output arrays: */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    if (plhs[0] == NULL)
        mexErrMsgTxt("Could not create mxArray.\n");
    /* mxDestroyArray(plhs[0]); _unnecessary as the array is output*/
	similarity = mxGetPr(plhs[0]);


    //count=0;
    for (k=0;k<nomatrixelements;k++)
    {
        if (newmask[k])
        {
            relevantpredicted+=predictedMask[k];
            sumnewmask++;
        }
        if (predictedMask[k]>0)
        {
            relevantnewmask+=  (double)(newmask[k]);
            sumpredicted+=predictedMask[k];
        }
    }
    
    *similarity= (relevantpredicted+relevantnewmask) / (sumpredicted+sumnewmask);
    
    /*mexPrintf("Number of inputs %d\n",nrhs);*/
    if (nrhs>2)
    {
        printonscreen = (bool *)mxGetPr(prhs[2]);
        if (*printonscreen)
            mexPrintf("Similarity is %f\n",*similarity);
    }

    /* MEX OUTPUT: */
    
    /* FREE MEMORY */

    
} /* mexFunction */





    




