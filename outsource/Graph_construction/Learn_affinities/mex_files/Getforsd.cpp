/* Mex impelmentation of Getcorrsupertracksmatrixmx
 * Usage :
 *
 * mex -largeArrayDims Getforsd.cpp
 * 


/* INCLUDES: */
#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "float.h"
#include "stdlib.h"

 
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
   /* DECLARATIONS: */
    double   *concc,*conrr,*medianx,*mediany; /*, numelboolmatrix*/
    mwSize j,num;
    
    
    /*Read input*/
   
    concc                 = mxGetPr(prhs[0]);
    conrr                 = mxGetPr(prhs[1]);
    medianx               = mxGetPr(prhs[2]);
    mediany               = mxGetPr(prhs[3]);

    

    num = mxGetNumberOfElements(prhs[1]);
        
    /* Initialize output */
    plhs[0] = mxCreateDoubleMatrix(num,1, mxREAL);   
    double* v = mxGetPr(plhs[0]);

     
           
      for( j=0 ; j<num ; j++ )          
          
       
            {                 
               v[j] = sqrt(pow(medianx[mwSize(concc[j]-1)]-medianx[mwSize(conrr[j]-1)],2)+ pow(mediany[mwSize(concc[j]-1)]-mediany[mwSize(conrr[j]-1)],2));
               
             }   
}

