/*
 *Mex function which extracts the U and V values of the mask by using M (Mrow and Mcol)
 
 *Use: [nearvelocity_uv_many]=Getneighbournearvelocitymex(mask,Mrow,Mcol,U,V,neighxyr,radius,dimIi,dimIj);
 *nearvelocity_uv_many=[Uvalues;
 *                      Vvalues]
 *
 *Inputs:
 *  mask: logical mask
 *  other inputs are doubles
 *
 *The function is preceded by an operation to find the coordinates of M:
 * [Mrow,Mcol]=find(M);
 *
 *The median of the extracted values gives the value of the velocity in the closest part to the other region
 * then nearvelocity_uv_r=median ( nearvelocity_uv_many(1,:) );
 * then nearvelocity_uv_r=median ( nearvelocity_uv_many(2,:) );
 *
 *
 *
 *The following code may be used to verify the function
 *
***Computation of nearvelocity_uv_many with this function***
mask=dist_track_mask{1,1};
[dimIi,dimIj]=size(mask);
radius=10;
[XM,YM]=meshgrid(-radius:radius,-radius:radius);
M=( (XM.^2+YM.^2) <= (radius^2) );
[Mrow,Mcol]=find(M);
[rm,cm]=find(mask);
whichtopick=10;
neighxyr=[cm(whichtopick),rm(whichtopick)];
[nearvelocity_uv_many]=Getneighbournearvelocitymex(mask,Mrow,Mcol,flows.flows{1}.Up,flows.flows{1}.Vp,neighxyr,radius,dimIi,dimIj);
******
 *
***Computation of nearvelocity_uv_many0 with built-in matlab functions***
nearMask=false(dimIi,dimIj);
firstMi=max(neighxyr(2)-radius,1);
firstGi=firstMi-neighxyr(2)+radius+1;
endMi=min(neighxyr(2)+radius,dimIi);
endGi=radius+1+endMi-neighxyr(2);
firstMj=max(neighxyr(1)-radius,1);
firstGj=firstMj-neighxyr(1)+radius+1;
endMj=min(neighxyr(1)+radius,dimIj);
endGj=radius+1+endMj-neighxyr(1);
nearMask(firstMi:endMi,firstMj:endMj)=( M(firstGi:endGi,firstGj:endGj) & mask(firstMi:endMi,firstMj:endMj) );
notrue=numel(find(nearMask));
nearvelocity_uv_manyo=zeros(2,notrue);
nearvelocity_uv_manyo(1,:)=flows.flows{1}.Up(nearMask);
nearvelocity_uv_manyo(2,:)=flows.flows{1}.Vp(nearMask);
******
 *
 *
 */



/* INCLUDES: */
#include "mex.h"
#include "matrix.h"

#include "limits.h"/**/
#include "math.h"/**/

#include "float.h"/**/


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{


    /* DECLARATIONS: */
    double *Mrow, *Mcol, *U, *V, *neighxyrd, *radiusd, *dimIid, *dimIjd; /* input arguments  */
    bool *mask;
    double *nearvelocity_uv_many; /* output arguments  */
    
    int no_element_m; /*int no_element_mask, no_element_u;*/
    int dimIi, dimIj, radius, neighir, neighjr;
    
    int k, maskrow, maskcol, maskidx, count; /* counters for processing through the two contours */
    int *idxuv;

    
	/* mexPrintf("nlhs %d, nrhs %d\n",nlhs,nrhs); */

    
	/* GET MEX INPUT: */
    mask = mxGetPr(prhs[0]);
    Mrow = mxGetPr(prhs[1]);
    Mcol = mxGetPr(prhs[2]);
    U = mxGetPr(prhs[3]);
    V = mxGetPr(prhs[4]);
    neighxyrd = mxGetPr(prhs[5]);
    radiusd = mxGetPr(prhs[6]);
    dimIid = mxGetPr(prhs[7]);
    dimIjd = mxGetPr(prhs[8]);
        
    dimIi=(int)(*dimIid);
    dimIj=(int)(*dimIjd);
    radius=(int)(*radiusd);
    neighir=(int)(neighxyrd[1]);
    neighjr=(int)(neighxyrd[0]);
    
    no_element_m = mxGetNumberOfElements(prhs[1]);
    /* no_element_mask = mxGetNumberOfElements(prhs[0]); no_element_u = mxGetNumberOfElements(prhs[3]);
    mexPrintf("no_element_mask %d, no_element_m %d, no_element_u %d, \n",no_element_mask,no_element_m,no_element_u); */
    
    idxuv = mxMalloc(no_element_m*sizeof(int));
    
    /* for (k=0;k<no_element_mask;k++)
        mexPrintf("mask[k] %d\n",mask[k]); */
    
    count=0;
    for (k=0;k<no_element_m;k++)
    {
        maskrow=(int)Mrow[k]-radius-1+neighir;
        maskcol=(int)Mcol[k]-radius-1+neighjr;
        
        /*mexPrintf("Out loop, Mrow[k] %d, Mcol[k] %d, radius %d, neighir %d, neighjr %d\n",(int)Mrow[k],(int)Mcol[k], radius, neighir, neighjr);*/
        
        if ( (maskrow>=1)&(maskrow<=dimIi)&(maskcol>=1)&(maskcol<=dimIj) )
        {
            maskidx= ( (maskcol-1) * (dimIi) ) + maskrow - 1 ;
            
            /*mexPrintf("In loop, maskrow %d, maskcol %d, dimIi %d, maskidx %d\n",maskrow,maskcol,dimIi, maskidx);
            mexPrintf("In loop, mask[maskidx] %d, %d\n",mask[maskidx], mask[203839-1]);*/
            if (mask[maskidx])
            {
                /*mexPrintf("In inner loop, maskidx (true) %d, maskrow %d, maskcol %d\n",maskidx, maskrow, maskcol);*/
                idxuv[count]=maskidx;
                count++;
            }
        }
    }
    /*mexPrintf("count %d\n",count);*/
    
	plhs[0] = mxCreateDoubleMatrix(2, count, mxREAL);
	nearvelocity_uv_many = mxGetPr(plhs[0]);
    
    
    /* for (k=0;k<count;k++)
        mexPrintf("idxuv[k] %d\n",idxuv[k]); */
    
    for (k=0;k<count;k++)
    {
        nearvelocity_uv_many[k*2]=U[idxuv[k]];
        nearvelocity_uv_many[k*2+1]=V[idxuv[k]];
    }

    mxFree(idxuv);
        
    
} /* mexFunction */




