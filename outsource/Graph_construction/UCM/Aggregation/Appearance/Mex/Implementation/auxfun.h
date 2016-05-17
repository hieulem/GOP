#ifndef auxfun_h
#define auxfun_h
#include "matrix.h"

int  find_double(int *indices, const int framenumber, const double *inarray, const int num_inarray);
int*  find_bool( const int framenumber, bool *inarray, const int num_inarray);
int  find_double_preallocated(int *indices, const int framenumber, const double *inarray, const mwSize num_inarray,const int allocatedMemory);

void initbooltozero   (bool   *bool_array, const mwSize len_array);
void initarrytozero   (double *int_array , const int len_array);
void initintarrytozero(int    *int_array,  const int len_array);


#endif