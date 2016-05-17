/*
 *CPP function for the computation of similarity between masks based on the Dice coefficient
 
 *Use: similarity = Measuresimilaritymex(newmask,predictedMask,[printonscreen]);
 *newmask and [printonscreen] must be booleans

 * mex Measuresimilaritymex.cpp
*/

#ifndef Measuresimilarity_cpp_c
#define Measuresimilarity_cpp_c
/* INCLUDES: */
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <math.h>
#include "auxfun.h" 

#include "Measuresimilarity_cpp.h"

double Measuresimilarity_cpp( bool *newmask, double *predictedmask, int dimrow_labvideo, int dimcol_labvideo)
{  
    double sim;             /* output arguments  */
    int k; /* counters for processing the video */    
    int nomatrixelements; /* no elements in the input matrices */    
    double relevantpredicted=0;
    double relevantnewmask=0;
    double sumpredicted=0;
    double sumnewmask=0;
    nomatrixelements = dimrow_labvideo*dimcol_labvideo;
    for (k=0;k<nomatrixelements;k++)
    {
        if (newmask[k])
        {
            relevantpredicted+=predictedmask[k];
            sumnewmask++;
        }
        if (predictedmask[k]>0)
        {
            relevantnewmask+=  (double)(newmask[k]);
            sumpredicted+=predictedmask[k];
        }
    }
    sim= (relevantpredicted+relevantnewmask) / (sumpredicted+sumnewmask);
    return(sim);  
}
#endif