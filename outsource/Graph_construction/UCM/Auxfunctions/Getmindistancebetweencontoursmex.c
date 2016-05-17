/*
 *Mex function for the computation of minimum distance and neighbouring points
 
 *Use: [mmin,neighr1,neighr2]=Getmindistancebetweencontoursmex(row1,col1,row2,col2)
 * mmin = (double) minimum distance between contours
 * neighr1 and neighr2 = (double 2x1) [x;y] coordinates of neighbouring point
*/



/* INCLUDES: */
#include "mex.h"
#include "matrix.h"

 #include "limits.h"
 #include "math.h"

#include "float.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{


    /* DECLARATIONS: */
    double *row1, *col1, *row2, *col2; /* input arguments  */
    double *mmin, *neighr1, *neighr2; /* output arguments  */
    
    int contour_tot_1, contour_tot_2;
    
    int k1, k2; /* counters for processing through the two contours */
    int best_in_c1, best_in_c2; /* these variables keep track of the position of the encountered maximum */
    double dist;
    double themin;
    double diff1, diff2;

    
	/* mexPrintf("nlhs %d, nrhs %d\n",nlhs,nrhs); */

    
	/* GET MEX INPUT: */
    row1 = mxGetPr(prhs[0]);
    col1 = mxGetPr(prhs[1]);
    row2 = mxGetPr(prhs[2]);
    col2 = mxGetPr(prhs[3]);
    
    contour_tot_1 = mxGetNumberOfElements(prhs[0]);
    contour_tot_2 = mxGetNumberOfElements(prhs[2]);
    
    
    /* Initialise output arrays: */
	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	plhs[1] = mxCreateDoubleMatrix(2, 1, mxREAL);
	plhs[2] = mxCreateDoubleMatrix(2, 1, mxREAL);
    
	mmin = mxGetPr(plhs[0]);	
	neighr1 = mxGetPr(plhs[1]);	
	neighr2 = mxGetPr(plhs[2]);	

    
    /* mexPrintf("INT_MAX by limits.h %d\n",INT_MAX); */

    themin=DBL_MAX;
    best_in_c1=0;
    best_in_c2=0;
    for(k2=0;k2<contour_tot_2;k2++)
    {
        for(k1=0;k1<contour_tot_1;k1++)
        {
            diff1=(row1[k1]-row2[k2]);
            diff2=(col1[k1]-col2[k2]);
            dist= diff1*diff1 + diff2*diff2;
            if (dist<themin)
            {
                themin=dist;
                best_in_c1=k1;
                best_in_c2=k2;
            }
        }
    }
    
    
    /* MEX OUTPUT: */
    *mmin=sqrt( themin );
    neighr1[0]=col1[best_in_c1];
    neighr1[1]=row1[best_in_c1];
    neighr2[0]=col2[best_in_c2];
    neighr2[1]=row2[best_in_c2];
    
    
} /* mexFunction */


/*
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{


    // DECLARATIONS:
    double *row1, *col1, *row2, *col2; //input arguments
    double *mmin, *neighr1, *neighr2; //output arguments
    
    int contour_tot_1, contour_tot_2;
    
    int k1, k2; //counters for processing through the two contours
    int best_in_c1, best_in_c2; //these variables keep track of the position of the encountered maximum
    int dist;
    int themin;
    int diff1, diff2;

    
	//mexPrintf("nlhs %d, nrhs %d\n",nlhs,nrhs);

    
	// GET MEX INPUT:
    row1 = mxGetPr(prhs[0]);
    col1 = mxGetPr(prhs[1]);
    row2 = mxGetPr(prhs[2]);
    col2 = mxGetPr(prhs[3]);
    
    contour_tot_1 = mxGetNumberOfElements(prhs[0]);
    contour_tot_2 = mxGetNumberOfElements(prhs[2]);
    
    
    // Initialise output arrays:
	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	plhs[1] = mxCreateDoubleMatrix(2, 1, mxREAL);
	plhs[2] = mxCreateDoubleMatrix(2, 1, mxREAL);
    
	mmin = mxGetPr(plhs[0]);	
	neighr1 = mxGetPr(plhs[1]);	
	neighr2 = mxGetPr(plhs[2]);	

    
    //mexPrintf("INT_MAX by limits.h %d\n",INT_MAX);

    themin=INT_MAX;
    best_in_c1=0;
    best_in_c2=0;
    for(k1=0;k1<contour_tot_1;k1++)
    {
        for(k2=0;k2<contour_tot_2;k2++)
        {
            diff1=(row1[k1]-row2[k2]);
            diff2=(col1[k1]-col2[k2]);
            dist= diff1*diff1 + diff2*diff2;
            if (dist<themin)
            {
                themin=dist;
                best_in_c1=k1;
                best_in_c2=k2;
            }
        }
    }
    
    
    // MEX OUTPUT:
    *mmin=sqrt( themin );
    neighr1[0]=col1[best_in_c1];
    neighr1[1]=row1[best_in_c1];
    neighr2[0]=col2[best_in_c2];
    neighr2[1]=row2[best_in_c2];
    
    
} // mexFunction

*/





