/* Mex impelmentation of Getcorrsupertracksmatrixmx
 * Usage :
 *
 * mex -largeArrayDims Getmedianforstd.cpp
 * 

/* INCLUDES: */
#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "float.h"
#include "stdlib.h"
#include <vector>
#include <algorithm>
#include <iostream> 

double median(std::vector<double> vec)
{
        typedef std::vector<double>::size_type vec_sz;
        vec_sz size = vec.size();  

        if (size == 0) return 0;
        if (size ==1) return vec[0];

        std::sort(vec.begin(), vec.end());

        vec_sz mid = size/2;

        return size % 2 == 0 ? (vec[mid] + vec[mid-1]) / 2 : vec[mid];
}
 
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
   /* DECLARATIONS: */
    double   *noallsuperpixels,*numberofsuperpixelsperframe,*labelledlevelvideo,*noFrames; /*, numelboolmatrix*/
    mwSize j,i,k,l,num, N,spx, frames;
    const mwSize *dim_array;
    std::vector<double> v_x,v_y;
 
    /*Read input*/
   
    noallsuperpixels                 = mxGetPr(prhs[0]);
    numberofsuperpixelsperframe      = mxGetPr(prhs[1]);
    labelledlevelvideo               = mxGetPr(prhs[2]);
    noFrames                         = mxGetPr(prhs[3]);
 
    

    num = (mwSize)*noallsuperpixels;
    frames = (mwSize)*noFrames;
    /* Initialize output */
    plhs[0] = mxCreateDoubleMatrix(num,1, mxREAL);   
    double* medianx = mxGetPr(plhs[0]);
    plhs[1] = mxCreateDoubleMatrix(num,1, mxREAL);   
    double* mediany = mxGetPr(plhs[1]);
    plhs[2] = mxCreateDoubleMatrix(num,1, mxREAL);   
    double* medianf = mxGetPr(plhs[2]);
    
    dim_array = mxGetDimensions(prhs[2]);
    N=0; 
       
      for( j=0 ; j<frames ; j++ )  
      {
          for (i=0; i<mwSize(numberofsuperpixelsperframe[j]);i++)
          {
              for(k=0;k<dim_array[0];k++)
                   for(l=0;l<dim_array[1];l++)    
                    
                   if (mwSize(labelledlevelvideo[k+dim_array[0]*l+dim_array[1]*dim_array[0]*j])==(i+1))
       
                  {  v_x.push_back(k+1);
                     v_y.push_back(l+1);
               
                   }  
              medianx[mwSize(N+i)] = median(v_x);
              mediany[mwSize(N+i)] = median(v_y);
              medianf[mwSize(N+i)] = j+1;
              v_x.clear();
              v_y.clear();
              
       }

      N = N+numberofsuperpixelsperframe[j];
      }

}
