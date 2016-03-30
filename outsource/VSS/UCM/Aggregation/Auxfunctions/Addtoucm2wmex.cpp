/*
 *Mex function for the computation of minimum distance and neighbouring points
 
 *Use: considerednewucm2=Addtoucm2withmex(frameofinterest,labelledvideo,considerednewucm2,dimIi, dimIj, nointerestframes);

 * frameofinterest = (double)
 * dimIi = (double)
 * dimIj = (double)
 * considerednewucm2 = cell array with elements of size (uint8 2*dimJ x 2*dimI)
 * labelledvideo = (double dimJ x dimI x no_frames)
 
 * mex Addtoucm2withmex.c
*/



/* INCLUDES: */
#include "mex.h"
#include "matrix.h"

 #include "limits.h"
 #include "math.h"

#include "float.h"
#include "stdlib.h"

#if !defined(max)
#define max(a, b) ((a) > (b) ? (a) : (b))
#define min(a, b) ((a) < (b) ? (a) : (b))
#endif

int indexwiththree(int i,int j,int f,int dimI,int dimJ)
{
    return ( f*dimJ + j)*dimI + i;
}
int indexwithtwo(int i,int j,int dimI)
{
    return j*dimI + i;
}
        
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{


    /* DECLARATIONS: */
    double *frameofinterest, *labelledvideo, *ddimIi, *ddimIj, *dnointerestframes; /* input arguments  */
    int dimIi, dimIj, nointerestframes; //int copy of input parameters
    
    mxArray *oneucm, *oneucmconst; /* input and output argument  */
    unsigned char *voneucm, *voneucmconst;
    
    int f, i, j, k; // counters for processing the video
    int ff;
    int ui, uj;
    
	/* mexPrintf("nlhs %d, nrhs %d\n",nlhs,nrhs); */
    
	/* GET MEX INPUT: */
    frameofinterest = mxGetPr(prhs[0]);
    labelledvideo = mxGetPr(prhs[1]);
    //considerednewucm2 = mxGetPr(prhs[2]); _an explicit definition is not needed
    ddimIi = mxGetPr(prhs[3]);
    ddimIj = mxGetPr(prhs[4]);
    dnointerestframes = mxGetPr(prhs[5]);
    
    /* INT INPUT */
    dimIi = (int)(*ddimIi);
    dimIj = (int)(*ddimIj);
    nointerestframes = (int)(*dnointerestframes);
    
    //mexPrintf("dimIi %d, dimIj %d, noFrames %d, colourdim %d, k %d, kf %d\n",dimIi,dimIj,noFrames,colourdim,k,kf);
    //no_pixels_integral_and_squared_video = (int)mxGetNumberOfElements(prhs[0]);
	//mexPrintf("no_pixels_integral_and_squared_video %d\n",no_pixels_integral_and_squared_video);
    
    plhs[0] = mxDuplicateArray (prhs[2]); //considerednewucm2, this should be plhs[0] = prhs[2] but matlab requires copy
    
    //mexPrintf("index %d, labelledvideo(5,2,3) %f\n",indexwiththree(5,2,3,dimIi,dimIj),labelledvideo[indexwiththree(5,2,3,dimIi,dimIj)]);
    for (f=0;f<nointerestframes;f++)
    {
        ff=(int)(frameofinterest[f]-1);
        //mexPrintf("oneinterestframe %d\n",ff);
        oneucm = mxGetCell (plhs[0], ff);
        oneucmconst = mxGetCell (prhs[2], ff);
        voneucm=(unsigned char *)(mxGetPr(oneucm));
        voneucmconst=(unsigned char *)(mxGetPr(oneucmconst));

        for (i=0;i<dimIi;i++)
        {
            ui=min(dimIi-1,i+1);
            for (j=0;j<dimIj;j++)
            {
                uj=min(dimIj-1,j+1);
                //if (i==0)
                    //mexPrintf("Value test (%d,%d,%d) %d %d\n", i, j, ff, int(labelledvideo[indexwiththree(i,j,ff,dimIi,dimIj)]), int(labelledvideo[indexwiththree(ui,j,ff,dimIi,dimIj)]));
                //labelindex=indexwiththree(i,j,f,dimIi,dimIj);
                //ucmindex=indexwithtwo(i,j,2*dimIi+1);
                if ( int(labelledvideo[indexwiththree(i,j,ff,dimIi,dimIj)]) != int(labelledvideo[indexwiththree(ui,j,ff,dimIi,dimIj)]) )
                    for (k=-1;k<=1;k++)
                        voneucm[indexwithtwo(2*(i+1),2*(j+1)-1+k,2*dimIi+1)]=voneucmconst[indexwithtwo(2*(i+1),2*(j+1)-1+k,2*dimIi+1)] + int(1);
                if ( int(labelledvideo[indexwiththree(i,j,ff,dimIi,dimIj)]) != int(labelledvideo[indexwiththree(i,uj,ff,dimIi,dimIj)]) )
                    for (k=-1;k<=1;k++)
                        voneucm[indexwithtwo(2*(i+1)-1+k,2*(j+1),2*dimIi+1)]=voneucmconst[indexwithtwo(2*(i+1)-1+k,2*(j+1),2*dimIi+1)] + int(1);
/*      for f=frameofinterest
            newucm2frame=considerednewucm2{f};
            for i=1:dimIi
                ui=min(dimIi,i+1);
                for j=1:dimIj
                    uj=min(dimIj,j+1);

                    if (labelledvideo(i,j,f)~=labelledvideo(ui,j,f))
                        newucm2frame(2*i+1,2*j-1:2*j+1)=considerednewucm2{f}(2*i+1,2*j-1:2*j+1)+1;
                    end
                    if (labelledvideo(i,j,f)~=labelledvideo(i,uj,f))
                        newucm2frame(2*i-1:2*i+1,2*j+1)=considerednewucm2{f}(2*i-1:2*i+1,2*j+1)+1;
                    end
                end
            end
            considerednewucm2{f}=newucm2frame;
        end*/
            }
        }
        mxSetCell(plhs[0], ff, oneucm);
    }

    /* MEX OUTPUT: */
    
    /* FREE MEMORY */
    
} /* mexFunction */



    




    /*
    
    idxuv = mxMalloc(no_element_m*sizeof(int));
    
    count=0;
    themin=DBL_MAX;
    mexPrintf("INT_MAX by limits.h %d\n",INT_MAX); 
    for (k=0;k<no_element_m;k++)
    {
        maskrow=(int)Mrow[k]-radius-1+neighir;
        maskcol=(int)Mcol[k]-radius-1+neighjr;
        
        mexPrintf("Out loop, Mrow[k] %d, Mcol[k] %d, radius %d, neighir %d, neighjr %d\n",(int)Mrow[k],(int)Mcol[k], radius, neighir, neighjr);
        
        if ( (maskrow>=1)&(maskrow<=dimIi)&(maskcol>=1)&(maskcol<=dimIj) )
        {
            maskidx= ( (maskcol-1) * (dimIi) ) + maskrow - 1 ;
            
            mexPrintf("In loop, maskrow %d, maskcol %d, dimIi %d, maskidx %d\n",maskrow,maskcol,dimIi, maskidx);
            mexPrintf("In loop, mask[maskidx] %d, %d\n",mask[maskidx], mask[203839-1]);
            if (mask[maskidx])
            {
                mexPrintf("In inner loop, maskidx (true) %d, maskrow %d, maskcol %d\n",maskidx, maskrow, maskcol);
                idxuv[count]=maskidx;
                count++;
            }
        }
    }
    mexPrintf("count %d\n",count);
    
    mxFree(idxuv);
    
    */



