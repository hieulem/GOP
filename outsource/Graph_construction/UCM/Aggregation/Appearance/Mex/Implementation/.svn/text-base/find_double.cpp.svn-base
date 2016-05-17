#ifndef find_double_c
#define find_double_c

#include <stdio.h>
#include <string.h>
#include <iostream>
#include "matrix.h"
#include "float.h"
#include "stdlib.h"
#include "limits.h"
#include "math.h"
#include "auxfun.h"

int*  find_double( const int framenumber, double *inarray, const int num_inarray)
{
    int *indices;
// local variable intialisations 
    int i,k,num_indices;
    
    i =0;
    for (k=0;k< num_inarray  ;k++) 
    {
        if(inarray[k] == framenumber) 
        {
            i++;
        }
        
    }
    num_indices = i;
    indices = new int[num_indices +1]; // additional memory to store the number
    
    i=1;
    for (k=0;k<= num_inarray  ;k++) 
    {
        if(inarray[k] == framenumber) 
        {
            indices[i] = k+1;
            i++;
        }   
    }
    indices[0] = num_indices;
    return indices;
}

#endif


