/* Mex impelmentation of Reducenewwithheinmex
 * Usage :
 *
 * mex -largeArrayDims Reducenewwithheinmex.cpp
 * 
 *Command to execute:
 *
 * [internallabelvolume,semilabelvolume]=Reducenewwithheinmex(ii,jj,vv,newsize);
 *
 */

/* INCLUDES: */
#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "float.h"
#include "stdlib.h"


 
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
   /* DECLARATIONS: */
    double  *internallabelvolume, *semilabelvolume, *ii, *jj, *vv, *newsize ;
    mwSize k, numelii, newsizemwsize ;
    
    /*Read input and output*/
    ii                  = mxGetPr(prhs[0]);
    jj                  = mxGetPr(prhs[1]);
    vv                  = mxGetPr(prhs[2]);
    newsize             = mxGetPr(prhs[3]);

    newsizemwsize=(mwSize)(*newsize);
    
    
    
    /* Initialize output */
    plhs[0] = mxCreateDoubleMatrix(newsizemwsize, 1, mxREAL);
    if (plhs[0] == NULL)
        mexErrMsgTxt("Could not create matrix.\n");
    plhs[1] = mxCreateDoubleMatrix(newsizemwsize, 1, mxREAL);
    if (plhs[1] == NULL)
        mexErrMsgTxt("Could not create matrix.\n");
    
    internallabelvolume        = mxGetPr(plhs[0]);
    semilabelvolume            = mxGetPr(plhs[1]);
    
    // mxDestroyArray(plhs[0]); _unnecessary as the array is output
    // numelinternallabelvolume = mxGetNumberOfElements(plhs[0]);

    
    
    numelii=mxGetNumberOfElements(prhs[0]);
    
    for( k=0 ; k<numelii ; k++ )
    {
        
        if ( (mwSize)(ii[k]) == (mwSize)(jj[k]) )
        {
            internallabelvolume[(mwSize)ii[k]-1] = internallabelvolume[(mwSize)ii[k]-1] + vv[k];
        }
        else
        {
            semilabelvolume[(mwSize)ii[k]-1] = semilabelvolume[(mwSize)ii[k]-1] + vv[k];
        }
        
        /*mexPrintf("k (%d)\n",k);*/
        
    }
    
}


