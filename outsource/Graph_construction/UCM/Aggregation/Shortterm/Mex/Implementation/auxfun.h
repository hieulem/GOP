#ifndef auxfun_h
#define auxfun_h

int*  find_double( const int framenumber, double *inarray, const int num_inarray);
int*  find_bool( const int framenumber, bool *inarray, const int num_inarray);

void initbooltozero   ( bool *bool_array,   const int len_array);
void initarrytozero   (double  *int_array , const int len_array);
void initintarrytozero(int *int_array,      const int len_array);

void firstfor(double *spatf,double *labelsatframe,double *constcc, double *constrr, double *framebelong, double *maxsuperpixels,
        const int numberofsuperpixels, double *noframes, double *temporaldepth,double *concc, double *conrr,double *thedepth,
        double *allmedianl,double *allmediana,double *allmedianb, bool *bool_tempneighlabels, bool *bool_tempneighframes, 
        const int num_constrr,const int num_concc,const int num_conrr,const int f,const int num_spatf,float *similariyatf, 
        const int dimrow,const int dimrow_median,float *similarityatothers, bool *similaritydonef, bool* similaritydoneothers);

void secondfor(double *labelsatframe,double *constcc, double *constrr,double *framebelong, double *maxsuperpixels,
        const int numberofsuperpixels,double *noframes, double *temporaldepth,double *concc,double *conrr,double *thedepth,
        double *allmedianl,double *allmediana,double *allmedianb,bool *bool_tempneighlabels,bool *bool_tempneighframes, 
        const int num_constrr,const int num_concc,const int num_conrr,const int f,const int num_framebelong,
        float *similarityatothers,const int dimrow,const int dimrow_median,bool* similaritydoneothers);  

#endif