#ifndef getneigh_h
#define getneigh_h
#include "matrix.h"

int*  getneigh( int *alabel,double *concc, double *conrr, double *thedepth, double *maxsuperpixels, const int num_alabel, const int num_concc, const int num_conrr);
int  getneigh_preallocated(int *neighlabel, const int *alabel,const double *concc,const double *conrr,const double *thedepth,const double *maxsuperpixels, const int num_alabel, const mwSize num_concc, const mwSize num_conrr, bool *bool_all_spx,bool* bool_newneighlabels,bool *bool_prevlabel);
#endif
