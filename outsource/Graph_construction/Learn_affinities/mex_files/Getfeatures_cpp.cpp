/* Mex impelmentation of Getcorrsupertracksmatrixmx
 * Usage :
 * mex -largeArrayDims Getfeatures_cpp2.cpp
 */

/* INCLUDES: */
#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "float.h"
#include "stdlib.h"
#include "limits.h"                                
#include <iostream> //cout
#include "map" //map
#include <utility> //pair

using namespace std;
 
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
   /* DECLARATIONS: */
    double   *framebelong,*v_stt, *v_stm,*v_sta,*v_abm,*v_aba,*v_ctr,*v_ltt, *noallsuperpixels, *i2_stt,*i1_stt, *i2_sta,*i1_sta, *i2_aba,*i1_aba,*i2_ltt,*i1_ltt;
    mwSize  j,jj,noallsuperpixelsnew, count_stt, count_sta,count_aba, count_ltt, c1, c2, c3, c4, c5, newsize,n1,n2,n3,n4,n5;
    signed long  i;

    /*Read input*/
    noallsuperpixels        = mxGetPr(prhs[0]);
    v_stt                   = mxGetPr(prhs[1]);
    i1_stt                  = mxGetPr(prhs[2]);
    i2_stt                  = mxGetPr(prhs[3]);
    v_stm                   = mxGetPr(prhs[4]);
    v_sta                   = mxGetPr(prhs[5]);
    i1_sta                  = mxGetPr(prhs[6]);
    i2_sta                  = mxGetPr(prhs[7]);
    v_abm                   = mxGetPr(prhs[8]);
    v_aba                   = mxGetPr(prhs[9]);
    i1_aba                  = mxGetPr(prhs[10]);
    i2_aba                  = mxGetPr(prhs[11]);
    v_ctr                   = mxGetPr(prhs[12]);
    v_ltt                   = mxGetPr(prhs[13]);
    i1_ltt                  = mxGetPr(prhs[14]);
    i2_ltt                  = mxGetPr(prhs[15]);
    framebelong             = mxGetPr(prhs[16]);
    
    
    noallsuperpixelsnew = (mwSize)(*noallsuperpixels); 
    newsize = noallsuperpixelsnew*(noallsuperpixelsnew-1)/2; 
     n1 = 0; n3 = 0;
     n2 = 0; n4 = 0; n5=0;
     count_stt = 0;
     count_sta = 0;
     count_aba = 0;
     count_ltt = 0;
       /* get size of arrays */
 
       
         for( i=0 ; i<noallsuperpixelsnew ; i++ )             
            for( j=0 ; j<noallsuperpixelsnew ; j++ )    
            {  
                 if ((j<i)&&(((i1_stt[count_stt]==(i+1))&&(i2_stt[count_stt]==(j+1)))||((i1_sta[count_sta]==(i+1))&&(i2_sta[count_sta]==(j+1)))||((i1_aba[count_aba]==(i+1))&&(i2_aba[count_aba]==(j+1)))||((i1_ltt[count_ltt]==(i+1))&&(i2_ltt[count_ltt]==(j+1)))))
                  n5++;
                
             /* STT */
             if ((i1_stt[count_stt]==(i+1))&&(i2_stt[count_stt]==(j+1)))
               {  
                   if (j<i)
                   { 
                    n1++;
                   }
                   
               count_stt++;
               }
               
               /* STA, STM */
             if ((i1_sta[count_sta]==(i+1))&&(i2_sta[count_sta]==(j+1)))
               {  
                   if (j<i)
                   { 
                     n2++;
                   }
                   
               count_sta++;
               }
            
                  /* ABA, ABM */
             if ((i1_aba[count_aba]==(i+1))&&(i2_aba[count_aba]==(j+1)))
               {  
                    if (j<i)
                   { 
                     n3++;

                    }
               count_aba++;
               }
           
                /* CTR, LTT */
             if ((i1_ltt[count_ltt]==(i+1))&&(i2_ltt[count_ltt]==(j+1)))
               {  
                     if (j<i)
                   { 
                     n4++;
                     } 
               count_ltt++;
               }
             
             }   
   
    
   
    mxArray *Xtd = mxCreateDoubleMatrix(n5,1,mxREAL); 
    double *td = mxGetPr(Xtd);
    
    mxArray *I5 = mxCreateDoubleMatrix(n5,1,mxREAL);  
    double *ind5 = mxGetPr(I5);
    
    mxArray *Xstt = mxCreateDoubleMatrix(n1,1,mxREAL); 
    double *stt = mxGetPr(Xstt);
    
    mxArray *I1 = mxCreateDoubleMatrix(n1,1,mxREAL);  
    double *ind1 = mxGetPr(I1);
         
    mxArray *Xstm = mxCreateDoubleMatrix(n2,1,mxREAL); 
    double*stm = mxGetPr(Xstm);
     
    mxArray *Xsta = mxCreateDoubleMatrix(n2,1,mxREAL); 
    double *sta = mxGetPr(Xsta);
    
    mxArray *I2 = mxCreateDoubleMatrix(n2,1,mxREAL); 
    double *ind2 = mxGetPr(I2);
    
    mxArray *Xabm = mxCreateDoubleMatrix(n3,1,mxREAL); 
    double *abm = mxGetPr(Xabm);
     
    mxArray *Xaba = mxCreateDoubleMatrix(n3,1,mxREAL); 
    double *aba = mxGetPr(Xaba);
     
    mxArray *I3 = mxCreateDoubleMatrix(n3,1,mxREAL); 
    double *ind3 = mxGetPr(I3);
   
    
    mxArray *Xltt = mxCreateDoubleMatrix(n4,1,mxREAL); 
    double *ltt = mxGetPr(Xltt);    
     
    mxArray *Xctr = mxCreateDoubleMatrix(n4,1,mxREAL); 
    double *ctr = mxGetPr(Xctr);
    
    mxArray *I4 = mxCreateDoubleMatrix(n4,1,mxREAL); 
    double *ind4 = mxGetPr(I4);
 
     count_stt = 0;
     count_sta = 0;
     count_aba = 0;
     count_ltt = 0;
      
    c1=0; c2=0; c3=0; c4=0; c5=0;
      
   
       for( i=0 ; i<noallsuperpixelsnew ; i++ )        
      for( j=0 ; j<noallsuperpixelsnew ; j++ )
              
            {  
             
             /* TD */
               if ((j<i)&&(((i1_stt[count_stt]==(i+1))&&(i2_stt[count_stt]==(j+1)))||((i1_sta[count_sta]==(i+1))&&(i2_sta[count_sta]==(j+1)))||((i1_aba[count_aba]==(i+1))&&(i2_aba[count_aba]==(j+1)))||((i1_ltt[count_ltt]==(i+1))&&(i2_ltt[count_ltt]==(j+1)))))
                   
               { 
//                    td[mwSize(round((i+1)*(i-2)/2+j+1))] =abs(framebelong[i]-framebelong[j]);
                   td[c5] = abs(framebelong[i]-framebelong[j]);
                   ind5[c5]=mwSize(round((i+1)*(i-2)/2+j+1));
                   c5++;
               }
              
             
             /* STT */
             if ((i1_stt[count_stt]==(i+1))&&(i2_stt[count_stt]==(j+1)))
               {  
                   if (j<i)
                   { 
                    stt[c1] = v_stt[count_stt];
                    ind1[c1] = mwSize(round((i+1)*(i-2)/2+j+1));
                    c1++;
                   }
                   
               count_stt++;
               }
               
               /* STA, STM */
             if ((i1_sta[count_sta]==(i+1))&&(i2_sta[count_sta]==(j+1)))
               {  
                   if (j<i)
                   { 
                     sta[c2] =v_sta[count_sta];
                     stm[c2] =v_stm[count_sta];
                     ind2[c2] = mwSize(round((i+1)*(i-2)/2+j+1));
                     
                     c2++;
                   }
                   
               count_sta++;
               }
            
                  /* ABA, ABM */
             if ((i1_aba[count_aba]==(i+1))&&(i2_aba[count_aba]==(j+1)))
               {  
                    if (j<i)
                   { 
                     aba[c3] = v_aba[count_aba];
                     abm[c3] = v_abm[count_aba];
                     ind3[c3] = mwSize(round((i+1)*(i-2)/2+j+1));
                     c3++;
                    }

               count_aba++;
               }
           
                /* CTR, LTT */
             if ((i1_ltt[count_ltt]==(i+1))&&(i2_ltt[count_ltt]==(j+1)))
               {  
                     if (j<i)
                   {
                     ctr[c4] =v_ctr[count_ltt];
                     ltt[c4] =v_ltt[count_ltt];
                     ind4[c4] = mwSize(round((i+1)*(i-2)/2+j+1));
                     c4++;
                     } 
               count_ltt++;
               }
             
             }   

   /* get size of arrays */
     n1 = 0; n3 = 0;
     n2 = 0; n4 = 0;
    count_stt = 0;
    count_sta = 0;
    count_aba = 0;
    count_ltt = 0;
    c5 = 0;

    for(j=0; j<newsize; j++)
    {
        /* within */
      
        if ((td[c5]==0)&&((ind2[count_sta]==j)||(ind3[count_aba]==j)))
             
               n1++;
     
        /* across_1 */
             
         if ((td[c5]==1)&&((ind2[count_sta]==j)||(ind1[count_stt]==j)))
      
               n2++;
       
        /* across_2 */
             
          if ((td[c5]==2)&&((ind4[count_ltt]==j)||(ind1[count_stt]==j)))
          
              n3++;
        
         /* across_2 */
             
          if ((td[c5]>2)&&(ind4[count_ltt]==j))
  
              n4++;
         
           if (ind4[count_ltt]==j) count_ltt++;
           if (ind1[count_stt]==j) count_stt++;
           if (ind2[count_sta]==j) count_sta++;
           if (ind3[count_aba]==j) count_aba++; 
           if (ind5[c5]==j) c5++;
        
    } 

    plhs[0] = mxCreateDoubleMatrix(n1,4,mxREAL);    
    double* X1 = mxGetPr(plhs[0]);  
    plhs[1] = mxCreateDoubleMatrix(n2,3,mxREAL);    
    double* X2 = mxGetPr(plhs[1]);   
    plhs[2] = mxCreateDoubleMatrix(n3,3,mxREAL);    
    double* X3 = mxGetPr(plhs[2]);  
    plhs[3] = mxCreateDoubleMatrix(n4,3,mxREAL);    
    double* X4 = mxGetPr(plhs[3]);  
     
    plhs[4] = mxCreateDoubleMatrix(n1,1,mxREAL);    
    double* index1 = mxGetPr(plhs[4]);  
    plhs[5] = mxCreateDoubleMatrix(n2,1,mxREAL);    
    double* index2 = mxGetPr(plhs[5]);   
    plhs[6] = mxCreateDoubleMatrix(n3,1,mxREAL);    
    double* index3 = mxGetPr(plhs[6]);  
    plhs[7] = mxCreateDoubleMatrix(n4,1,mxREAL);    
    double* index4 = mxGetPr(plhs[7]);  
    
    
    c1=0; c2=0; c3=0; c4=0;
    count_stt = 0;
    count_sta = 0;
    count_aba = 0;
    count_ltt = 0;
    c5=0;  
    mwSize count = 1; 
   

    for(j=0; j<newsize; j++)
    {
        /* within */
         if ((td[c5]==0)&&((ind2[count_sta]==j)||(ind3[count_aba]==j)))
           {  if (ind2[count_sta]==j)
              {
              X1[c1] = sta[count_sta]; X1[n1+c1] = stm[count_sta]; 
              }
              if (ind3[count_aba]==j)
              {
              X1[2*n1+c1] = aba[count_aba]; X1[3*n1+c1] = abm[count_aba];
              }
              index1[c1] = count;
              c1++;
            }
        
        /* across_1 */
             
        if ((td[c5]==1)&&((ind2[count_sta]==j)||(ind1[count_stt]==j)))
            { if (ind2[count_sta]==j)
              {            
              X2[c2] = stm[count_sta]; X2[n2+c2] = sta[count_sta]; 
              }
              if (ind1[count_stt]==j)
              {
              X2[2*n2+c2] = stt[count_stt]; 
              }              
              index2[c2] = count;
              c2++;
            }
        
        /* across_2 */
             
        if ((td[c5]==2)&&((ind4[count_ltt]==j)||(ind1[count_stt]==j)))
                      
            { if (ind1[count_stt]==j)
              {
              X3[c3] = stt[count_stt]; 
              }
              if (ind4[count_ltt]==j)
              {
              X3[n3+c3] = ltt[count_ltt]; X3[2*n3+c3] = ctr[count_ltt]; 
              }
              index3[c3] = count;
              c3++;
            }
        
         /* across_2 */
             
        if ((td[c5]>2)&&(ind4[count_ltt]==j))
            { 
                
              X4[c4] = ltt[count_ltt]; X4[n4+c4] = ctr[count_ltt]; X4[2*n4+c4] = td[c5]; 
              index4[c4] = count;
              c4++;
           }
         
           if (ind4[count_ltt]==j) count_ltt++;
           if (ind1[count_stt]==j) count_stt++;
           if (ind2[count_sta]==j) count_sta++;
           if (ind3[count_aba]==j) count_aba++;  
           if (ind5[c5]==j) c5++;
//            if ((ind4[count_ltt]==j)||(ind1[count_stt]==j)||(ind2[count_sta]==j)||(ind3[count_aba]==j))    c5++;
         
     count++;    
    }
    

    
mxDestroyArray(Xtd);    
mxDestroyArray(Xstt);
mxDestroyArray(Xstm);
mxDestroyArray(Xsta);
mxDestroyArray(Xaba);
mxDestroyArray(Xabm);
mxDestroyArray(Xltt);
mxDestroyArray(Xctr);
mxDestroyArray(I1);
mxDestroyArray(I2);
mxDestroyArray(I3);
mxDestroyArray(I4);  
mxDestroyArray(I5); 
}

