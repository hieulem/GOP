#ifndef initbooltozero_c
#define initbooltozero_c

#include <stdio.h>
#include <string.h>
#include <iostream> 

void initarrytozero( double *int_array, const int len_array)
{
    int t;
    for(t=0; t< len_array; t++)
    {
         int_array[t] = 0;
    }
}
#endif