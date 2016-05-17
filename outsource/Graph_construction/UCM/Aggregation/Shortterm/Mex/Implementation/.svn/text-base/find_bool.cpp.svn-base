#ifndef find_bool_c
#define find_bool_c

#include <stdio.h>
#include <string.h>
#include <iostream>
#include "matrix.h"
#include "float.h"
#include "stdlib.h"
#include "limits.h"
#include "math.h"
#include "auxfun.h"

int*  find_bool( const int framenumber, bool *inarray, const int num_inarray)
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
    if (num_indices >0) // DONOT ITERATE IF NUM_INDI IS 0.. THIS IS NOT INCLUDED IN THE SODE FOR "STM"
    {    
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
    }
    else
    {
        indices[0] = 0;
    }
    return indices;
}
#endif
