/* Mex impelmentation of STT using map
 * Usage :
 * mex -largeArrayDims Gettouchingmatrixonlabelledvideo_mex.cpp  
 *
 * Command to execute while testing the program as a independant unit:
 * count1 = Gettouchingmatrixonlabelledvideo_mex(labelledlevelvideo ,btrajectories, noallsuperpixels,mapped,btrack,spx,noBtrajectories,dimvideo)
 *
 */

/* INCLUDES: */
#include "mex.h"
#include "matrix.h"
// #include "auxfun.h"
#include "limits.h"
#include "math.h"

#include "float.h"
#include "stdlib.h"
#include <iostream> //cout
#include "map" //map
#include <utility> //pair
using namespace std;

int linearindex_k( int rowindex, int colindex, int no_rows) // THIS FUNCTION IS USED BY FIRSTMEX
{
    int linearind;
    linearind =0;
    linearind = ((colindex-1)* no_rows) + (rowindex-1);  
    return linearind;
}

int linearindex_3d( int rowindex, int colindex, int frame_index, int no_rows, int no_cols)
{
    int linearind;
    linearind =0;
    linearind = ((frame_index - 1)*(no_rows *no_cols))+((colindex-1)* no_rows) + (rowindex-1);  
    return linearind;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
    /* DECLARATIONS: */
    double  *labelledlevelvideo ,*btrajectories, *noallsuperpixels,*mapped,*btrack,*spx, *noBtrajectories,*dimvideo;
    double *test;  //output variable

    labelledlevelvideo              = mxGetPr(prhs[0]);
    btrajectories                   = mxGetPr(prhs[1]);
    noallsuperpixels                = mxGetPr(prhs[2]);
    mapped                          = mxGetPr(prhs[3]);
    btrack                          = mxGetPr(prhs[4]);
    spx                             = mxGetPr(prhs[5]);
    noBtrajectories                 = mxGetPr(prhs[6]);
    dimvideo                        = mxGetPr(prhs[7]);

    
    int bk,bpos,f,min1,min2,min3,max1,max2, thex,they, lin_ind_3d, lin_ind, count, touchedlabel;
    mxArray *tmp_cell, *tmp_cell_start_frame, *tmp_cell_end_frame,*tmp_cell_xs,*tmp_cell_ys;
    double  *cell_start_frame , *cell_end_frame,*cell_xs,*cell_ys;
    count =0;       
    for(bk=0;bk< (int) *noBtrajectories;bk++)
//     for(bk=0;bk< 2;bk++)

    {
        bpos=0;
        tmp_cell = mxGetCell(prhs[1],bk ); //extraction from cell array
        //extraction from struct
        tmp_cell_start_frame =mxGetField(tmp_cell,0,"startFrame"); 
        tmp_cell_end_frame   =mxGetField(tmp_cell,0,"endFrame"); 
        tmp_cell_xs          =mxGetField(tmp_cell,0,"Xs"); 
        tmp_cell_ys          =mxGetField(tmp_cell,0,"Ys");
        // typecasting for use     
        cell_start_frame = mxGetPr(tmp_cell_start_frame);
        cell_end_frame   = mxGetPr(tmp_cell_end_frame);
        cell_xs          = mxGetPr(tmp_cell_xs);
        cell_ys          = mxGetPr(tmp_cell_ys);
        
        min1 = min((int) *cell_end_frame,(int) dimvideo[2]);

        for (f= (int) *cell_start_frame;f<= min1;f++){
//          calculating thex and they
            thex = min(max(round(cell_xs[bpos]),1.0),dimvideo[1]);
            they = min(max(round(cell_ys[bpos]),1.0),dimvideo[0]);
            lin_ind_3d=linearindex_3d(they,thex,f,dimvideo[0],dimvideo[1]);
            touchedlabel = labelledlevelvideo[lin_ind_3d];
            btrack[count] = bk+1; // matlab indices
            lin_ind = linearindex_k( f, touchedlabel,dimvideo[2]) ;
            spx[count] = mapped[lin_ind];  
            bpos = bpos+1;
            count=count+1; 
        }

    }

 
    
   plhs[0] = mxCreateDoubleMatrix( 1, 1,mxREAL);        
   test = mxGetPr(plhs[0]);  
   test[0]  = count;
 }// end of main   
    
    
    
    
    
    
    
    
    