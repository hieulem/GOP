/* Mex impelmentation of Reweightequivalentlynewloopmex
 * Usage :
 *
 * mex -largeArrayDims Reweightequivalentlynewloopmex.cpp
 * 
 *Command to execute:
 *
 * [rrd,ccd,rcvd]=Reweightequivalentlynewloopmex(rr,cc,rcv,normpertrack,maxnotracks,Z,sizew);
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
    double  *rrd, *ccd, *rcvd, *rr, *cc, *rcv, *normpertrack, *maxnotracks, *Z, *sizew ;
    mwSize i, j, numelrr, maxnotracksmwsize ;
    double psum, nsum, id;
    mxArray *allrcvsumsmxar, *allrcvandnormsumsmxar;
    double *allrcvsums, *allrcvandnormsums;
    
    /*Read input and output*/
    rr            = mxGetPr(prhs[0]);
    cc            = mxGetPr(prhs[1]);
    rcv           = mxGetPr(prhs[2]);
    normpertrack  = mxGetPr(prhs[3]);
    maxnotracks   = mxGetPr(prhs[4]);
    Z             = mxGetPr(prhs[5]);
    sizew         = mxGetPr(prhs[6]);

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

    
    
    // Allocate, initialize and compute allrcvsums and allrcvandnormsums
    //mexPrintf("sizew (%d)\n",(mwSize)(*sizew));
    allrcvsumsmxar = mxCreateDoubleMatrix( (mwSize)(*sizew) , 1, mxREAL);
    if (allrcvsumsmxar == NULL)
        mexErrMsgTxt("Could not create matrix.\n");
    allrcvandnormsumsmxar = mxCreateDoubleMatrix( (mwSize)(*sizew) , 1, mxREAL);
    if (allrcvandnormsumsmxar == NULL)
        mexErrMsgTxt("Could not create matrix.\n");
    
    allrcvsums = mxGetPr(allrcvsumsmxar);
    allrcvandnormsums = mxGetPr(allrcvandnormsumsmxar);
    
    for ( i=0 ; i<numelrr ; i++ )
    {
        allrcvsums[ (mwSize)(rr[i]) - 1 ] += rcv[i] ;
        allrcvandnormsums[ (mwSize)(rr[i]) - 1 ] += ( rcv[i] * normpertrack[(mwSize)(cc[i])-1] );
    }
    
    
    
    for( i=0 ; i<maxnotracksmwsize ; i++ )
    {
        id=(double)(i);
        rrd[i]= (id+1);
        ccd[i]= (id+1);
        
        psum=allrcvsums[i];
        nsum=allrcvandnormsums[i];
        /*
        for ( j=0 ; j<numelrr ; j++ )
        {
            if ( (mwSize)(rr[j]) == (i+1) )
            {
                psum+=rcv[j];
                nsum+= ( rcv[j] * normpertrack[(mwSize)cc[j]-1] ) ;
            }
        }
        */
        
        rcvd[i]=
        (normpertrack[i]-1) *   /* g_i */
        (
        (*Z) * psum /* sum( Zw(e_{ij}) ) */
        -
        nsum /* sum( g_j  w(e_{ij}) ) */
        );
        
        /*mexPrintf("i (%d)\n",i);*/
        
    }
    
    //Destroy allocated memory
    mxDestroyArray(allrcvsumsmxar);
    mxDestroyArray(allrcvandnormsumsmxar);
}


