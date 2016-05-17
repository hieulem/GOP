/* Mex impelmentation of Reweightequivalentlyheinloopmex
 * Usage :
 *
 * mex -largeArrayDims Reweightequivalentlyheinloopmex.cpp
 * 
 *Command to execute:
 *
 * [rrd,ccd,rcvd]=Reweightequivalentlyheinloopmex(rr,rcv,normpertrack,maxnotracks,Z,sizew);
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
    double  *rrd, *ccd, *rcvd, *rr, *rcv, *normpertrack, *maxnotracks, *Z, *sizew ;
    mwSize i, j, numelrr, maxnotracksmwsize;
    double psum, id;
    mxArray *allrcvsumsmxar;
    double *allrcvsums;
    
    /*Read input and output*/
    rr            = mxGetPr(prhs[0]);
    rcv           = mxGetPr(prhs[1]);
    normpertrack  = mxGetPr(prhs[2]);
    maxnotracks   = mxGetPr(prhs[3]);
    Z             = mxGetPr(prhs[4]);
    sizew         = mxGetPr(prhs[5]);

    numelrr=mxGetNumberOfElements(prhs[0]);
    maxnotracksmwsize=(mwSize)(*maxnotracks);
    
    
    
    /* Initialize output */
    plhs[0] = mxCreateDoubleMatrix(maxnotracksmwsize, 1, mxREAL);
    if (plhs[0] == NULL)
        mexErrMsgTxt("Could not create matrix.\n");
    plhs[1] = mxCreateDoubleMatrix(maxnotracksmwsize, 1, mxREAL);
    if (plhs[1] == NULL)
        mexErrMsgTxt("Could not create matrix.\n");
    plhs[2] = mxCreateDoubleMatrix(maxnotracksmwsize, 1, mxREAL);
    if (plhs[2] == NULL)
        mexErrMsgTxt("Could not create matrix.\n");
    
    rrd        = mxGetPr(plhs[0]);
    ccd        = mxGetPr(plhs[1]);
    rcvd       = mxGetPr(plhs[2]);
    
    // mxDestroyArray(plhs[0]); _unnecessary as the array is output
    // numelrrd = mxGetNumberOfElements(plhs[0]);
    
    
    
    // Allocate, initialize and compute allrcvsums
    //mexPrintf("sizew (%d)\n",(mwSize)(*sizew));
    allrcvsumsmxar = mxCreateDoubleMatrix( (mwSize)(*sizew) , 1, mxREAL);
    if (allrcvsumsmxar == NULL)
        mexErrMsgTxt("Could not create matrix.\n");
    
    allrcvsums = mxGetPr(allrcvsumsmxar);
    
    for ( i=0 ; i<numelrr ; i++ )
    {
        allrcvsums[ (mwSize)(rr[i]) - 1 ] += rcv[i];
    }

    
    
    for( i=0 ; i<maxnotracksmwsize ; i++ )
    {
        id=(double)(i);
        rrd[i]= (id+1);
        ccd[i]= (id+1);
        
        psum = allrcvsums[i];
        /*
        psum=0;
        for ( j=0 ; j<numelrr ; j++ )
        {
            if ( (mwSize)(rr[j]) == (i+1) )
            {
                psum+=rcv[j];
            }
        }
        */
        
        rcvd[i]=
        normpertrack[i] *    /*g_i*/
        (normpertrack[i]-1) *   /*g_i-1*/
        (*Z) * psum; /*sum( Zw(e_{ij}) )*/
        
        
        /*mexPrintf("i (%d)\n",i);*/
        
    }
    
    //Destroy allocated memory
    mxDestroyArray(allrcvsumsmxar);
}


