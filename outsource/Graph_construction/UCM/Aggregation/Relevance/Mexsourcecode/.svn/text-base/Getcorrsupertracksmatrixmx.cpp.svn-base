/* Mex impelmentation of Getcorrsupertracksmatrixmx
 * Usage :
 *
 * mex -largeArrayDims Getcorrsupertracksmatrixmx.cpp
 * 
 * Command to execute:
 *
 * corrsupertracks=Getcorrsupertracksmatrixmx(labelledlevelunique,labelledlowerunique,maxnotracks,noallsuperpixels);
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
    double  *labelledlevelunique,*labelledlowerunique, *maxnotracks, *noallsuperpixels ; /*, numelboolmatrix*/
    mxLogical *corrsupertracks ; /*bool*/
    mwSize i,j,numeloflabelledlevelunique,numeloflabelledlowerunique,numelmin,pi,pj,maxnotracksmwsize,nosuperpixelsmwsize;
    unsigned long lp;

    /*Read input*/
    labelledlevelunique   = mxGetPr(prhs[0]);
    labelledlowerunique   = mxGetPr(prhs[1]);
    maxnotracks           = mxGetPr(prhs[2]);
    noallsuperpixels      = mxGetPr(prhs[3]);

    maxnotracksmwsize=(mwSize)(*maxnotracks);
    nosuperpixelsmwsize=(mwSize)(*noallsuperpixels);
    

    numeloflabelledlevelunique = mxGetNumberOfElements(prhs[0]);
    numeloflabelledlowerunique = mxGetNumberOfElements(prhs[1]);
    
    /* Initialize output */
    plhs[0] = mxCreateLogicalMatrix((mwSize) maxnotracksmwsize, (mwSize) nosuperpixelsmwsize);
    if (plhs[0] == NULL)
        mexErrMsgTxt("Could not create logical matrix.\n");
    corrsupertracks       = mxGetLogicals(plhs[0]);
    // mxDestroyArray(plhs[0]); _unnecessary as the array is output
    //numelboolmatrix = (double)mxGetNumberOfElements(plhs[0]);
    //mexPrintf("Numelboolmatrix %f (%d, %d, %d), requested %f\n",numelboolmatrix, mxGetM(plhs[0]), mxGetN(plhs[0]), mxGetM(plhs[0])* mxGetN(plhs[0]), (double)(maxnotracksmwsize)*(double)(nosuperpixelsmwsize));
    //mexPrintf("Sizes (%d, %d), number of elements %f\n",maxnotracksmwsize,nosuperpixelsmwsize, (double)mxGetNumberOfElements(plhs[0]) );
    //mexPrintf("numeloflabelledlevelunique (%d) and numeloflabelledlowerunique (%d)\n",numeloflabelledlevelunique,numeloflabelledlowerunique);
    
        
    
    numelmin=numeloflabelledlevelunique;
    if (numeloflabelledlowerunique!=numelmin)
    {
        mexPrintf("Difference between numeloflabelledlevelunique (%d) and numeloflabelledlowerunique (%d)",numeloflabelledlevelunique,numeloflabelledlowerunique);
        if (numeloflabelledlowerunique<numelmin)
        {
            numelmin=numeloflabelledlowerunique;
        }
        mexPrintf(" - using %d\n",numelmin);
    }
    //mexPrintf("Numelmin (%d), numel corrsupertracks %f (==%f)\n",numelmin, (double)mxGetNumberOfElements(plhs[0]),(double)(maxnotracksmwsize)*(double)(nosuperpixelsmwsize));

    
    
    for( i=0 ; i<numelmin ; i++ )
    {
        pi=((mwSize) labelledlevelunique[i])-1; // labelledlevelunique is in matlab notations
        pj=((mwSize) labelledlowerunique[i])-1; // labelledlowerunique is in matlab notations
        lp= (unsigned long)(pj)*maxnotracksmwsize + pi;
        
        corrsupertracks[lp] = (mxLogical)1;
    }
    
    
    
}



// * corrsupertracks2=Getcorrsupertracksmatrixmx(twinlabelledlevelunique,twinlabelledlowerunique,maxnotracks,noallsuperpixels);

//         if (i==13604590)
//         {
//             mexPrintf("i (%d), pi (%d) labelledlevelunique[i] (%d), pj (%d) labelledlowerunique[i] (%d), linear index (%ul)\n",
//                    i, pi,(int)labelledlevelunique[i],pj,(int)labelledlowerunique[i],lp);
//             
//             break;
//         }
    
//     for( i=0 ; i<numelmin ; i++ )
//     {
//         pi=((int) labelledlevelunique[i])-1; // labelledlevelunique is in matlab notations
//         pj=((int) labelledlowerunique[i])-1; // labelledlowerunique is in matlab notations
//         
//         // Move to the position to modify without incurring into problems from int overflow
//         linidxlog=corrsupertracks;
//         for (j=0; j<pj; j++)
//         {
//             linidxlog+=maxnotracksmwsize;
//         }
//         linidxlog+=pi;
//         //lp= pj*maxnotracksmwsize + pi; //overflowing alternative
//             
//         //*linidxlog = (mxLogical)1;
//         //corrsupertracks[lp] = (mxLogical)1;
//     }

//         if ( (lp>numelboolmatrix) || (lp<0) )
//         {
//             mexPrintf("Warning overflow at %d\n",i);
//             break;
//         }
//         else
//         {
//             corrsupertracks[lp] = (mxLogical)1;
//         }
        
    
//     for( i=0 ; i<numelmin ; i++ )
//     {
//         pi=((int) labelledlevelunique[i])-1; // labelledlevelunique is in matlab notations
//         pj=((int) labelledlowerunique[i])-1; // labelledlowerunique is in matlab notations
//         lp= pj*maxnotracksmwsize + pi;
//         
//         
//         if (lp>numelboolmatrix)
//         {
//             mexPrintf("Warning overflow at %d\n",i);
//         }
//         else
//         {
//             corrsupertracks[lp] = (mxLogical)1;
//         }
//         
//         //mexPrintf("i (%d), pi (%d) labelledlevelunique[i] (%d), pj (%d) labelledlowerunique[i] (%d), linear index (%d) corrsupertracks (%d)\n",
//         //        i, pi,(int)labelledlevelunique[i],pj,(int)labelledlowerunique[i],lp,corrsupertracks[lp]);
//     }
