#ifndef initbooltozero_c
#define initbooltozero_c

#include <stdio.h>
#include <string.h>
#include <iostream> 
#include "matrix.h"

void initbooltozero( bool *bool_array, const mwSize len_array)
{
    mwSize t;
    for(t=0; t< len_array; t++)
    {
         bool_array[t] = false;
    }
}
#endif