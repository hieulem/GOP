#ifndef initintarrytozero_c
#define initintarrytozero_c

#include <stdio.h>
#include <string.h>
#include <iostream> 

void initintarrytozero( int *int_array, const int len_array)
{
    int t;
    for(t=0; t< len_array; t++)
    {
         int_array[t] = 0;
    }
}
#endif