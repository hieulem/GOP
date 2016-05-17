/* Mex impelmentation of Getcorrsupertracksmatrixmx
 * Usage :
 * mex -largeArrayDims Getfeatures_cpp_new2.cpp
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
    double   *framebelong,*v_ds, *v_text_max, *v_text_mean,*v_stt,*v_std, *v_stm,*v_sta,*v_stm3,*v_sta3,*v_abm,*v_aba,*v_ctr,*v_ltt, *noallsuperpixels, *i2_stt,*i1_stt, *i2_sta,*i1_sta,*i2_text,*i1_text,*i2_ds,*i1_ds, *i2_aba,*i1_aba,*i2_ltt,*i1_ltt,*i2_std,*i1_std;
    mwSize  j,jj,noallsuperpixelsnew, count_ds, count_text, count_stt, count_sta,count_aba, count_ltt, count_std, c7,c8,c6, c1, c2, c3, c4, c5,c1_n1,c1_n2,c2_n1,c2_n2, newsize,n1,n2,n3,n4,n5,n6,n7,n8,n1_n2,n1_n1,n2_n1,n2_n2;
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
    v_std                   = mxGetPr(prhs[16]);

    v_stm3                  = mxGetPr(prhs[17]);
    v_sta3                  = mxGetPr(prhs[18]);        
    framebelong             = mxGetPr(prhs[19]);
    
    v_text_max              = mxGetPr(prhs[20]);
    v_text_mean             = mxGetPr(prhs[21]);
    i1_text                 = mxGetPr(prhs[22]);
    i2_text                 = mxGetPr(prhs[23]);
    
    v_ds                    = mxGetPr(prhs[24]);
    i1_ds                   = mxGetPr(prhs[25]);
    i2_ds                   = mxGetPr(prhs[26]);
    i1_std                  = mxGetPr(prhs[27]);
    i2_std                  = mxGetPr(prhs[28]);
    
    noallsuperpixelsnew = (mwSize)(*noallsuperpixels); 
    newsize = noallsuperpixelsnew*(noallsuperpixelsnew-1)/2; 
     n1 = 0; n3 = 0;
     n2 = 0; n4 = 0; n5=0; n6=0; n7=0; n8=0;
     count_stt = 0;   
     count_sta = 0;
     count_aba = 0;
     count_ltt = 0;
     count_ds=0;
     count_text =0;
     count_std = 0;

       /* get size of arrays */
 
       
         for( i=0 ; i<noallsuperpixelsnew ; i++ )             
            for( j=0 ; j<noallsuperpixelsnew ; j++ )    
            {  
               if ((j<i)&&(((i1_text[count_text]==(i+1))&&(i2_text[count_text]==(j+1)))||((i1_std[count_std]==(i+1))&&(i2_std[count_std]==(j+1)))||((i1_ds[count_ds]==(i+1))&&(i2_ds[count_ds]==(j+1)))||((i1_stt[count_stt]==(i+1))&&(i2_stt[count_stt]==(j+1)))||((i1_sta[count_sta]==(i+1))&&(i2_sta[count_sta]==(j+1)))||((i1_aba[count_aba]==(i+1))&&(i2_aba[count_aba]==(j+1)))||((i1_ltt[count_ltt]==(i+1))&&(i2_ltt[count_ltt]==(j+1)))))
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
               
                 
             /* Dspx */
             if ((i1_ds[count_ds]==(i+1))&&(i2_ds[count_ds]==(j+1)))
               {  
                   if (j<i)
                   { 
                   
                    n6++;
                   }
                   
               count_ds++;
               } 
               
             /* Texture */
             if ((i1_text[count_text]==(i+1))&&(i2_text[count_text]==(j+1)))
               {  
                    if (j<i)
                   { 
                     n7++;

                    }
               count_text++;
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
           
               
              /* STD */
             if ((i1_std[count_std]==(i+1))&&(i2_std[count_std]==(j+1)))
               {  
                   if (j<i)
                   { 
                   
                    n8++;
                   }
                   
               count_std++;
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
   
//       printf("%d\n",n8);
   
    mxArray *Xtd = mxCreateDoubleMatrix(n5,1,mxREAL); 
    double *td = mxGetPr(Xtd);
    
    mxArray *I5 = mxCreateDoubleMatrix(n5,1,mxREAL);  
    double *ind5 = mxGetPr(I5);
    
    mxArray *Xstd = mxCreateDoubleMatrix(n8,1,mxREAL); 
    double *std = mxGetPr(Xstd);
    
    mxArray *I8 = mxCreateDoubleMatrix(n8,1,mxREAL);  
    double *ind8 = mxGetPr(I8);   

    
    mxArray *Xstt = mxCreateDoubleMatrix(n1,1,mxREAL); 
    double *stt = mxGetPr(Xstt);
    
    mxArray *I1 = mxCreateDoubleMatrix(n1,1,mxREAL);   
    double *ind1 = mxGetPr(I1);
         
    mxArray *Xstm = mxCreateDoubleMatrix(n2,1,mxREAL); 
    double*stm = mxGetPr(Xstm);
     
    mxArray *Xsta = mxCreateDoubleMatrix(n2,1,mxREAL); 
    double *sta = mxGetPr(Xsta);
    
    mxArray *Xstm3 = mxCreateDoubleMatrix(n2,1,mxREAL); 
    double*stm3 = mxGetPr(Xstm3);
     
    mxArray *Xsta3 = mxCreateDoubleMatrix(n2,1,mxREAL); 
    double *sta3 = mxGetPr(Xsta3);
    
    mxArray *I2 = mxCreateDoubleMatrix(n2,1,mxREAL); 
    double *ind2 = mxGetPr(I2);
    
    mxArray *Xabm = mxCreateDoubleMatrix(n3,1,mxREAL); 
    double *abm = mxGetPr(Xabm);
     
    mxArray *Xaba = mxCreateDoubleMatrix(n3,1,mxREAL); 
    double *aba = mxGetPr(Xaba);
     
    mxArray *I3 = mxCreateDoubleMatrix(n3,1,mxREAL); 
    double *ind3 = mxGetPr(I3);
    
    
    mxArray *Xtext_max = mxCreateDoubleMatrix(n7,1,mxREAL); 
    double *text_max = mxGetPr(Xtext_max);
     
    mxArray *Xtext_mean = mxCreateDoubleMatrix(n7,1,mxREAL); 
    double *text_mean = mxGetPr(Xtext_mean);
     
    mxArray *I7 = mxCreateDoubleMatrix(n7,1,mxREAL); 
    double *ind7 = mxGetPr(I7);
    
    mxArray *Xds = mxCreateDoubleMatrix(n6,1,mxREAL); 
    double *ds = mxGetPr(Xds);
    
    mxArray *I6 = mxCreateDoubleMatrix(n6,1,mxREAL);  
    double *ind6 = mxGetPr(I6);   
   
    
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
     count_std = 0;
     count_ds=0;
     count_text=0;
      
    c1=0; c2=0; c3=0; c4=0; c5=0; c6=0; c7=0;c8=0;
      
   
       for( i=0 ; i<noallsuperpixelsnew ; i++ )        
      for( j=0 ; j<noallsuperpixelsnew ; j++ )
              
            {  
             
             /* TD */
               if ((((i1_text[count_text]==(i+1))&&(i2_text[count_text]==(j+1)))||((i1_std[count_std]==(i+1))&&(i2_std[count_std]==(j+1)))||((i1_ds[count_ds]==(i+1))&&(i2_ds[count_ds]==(j+1)))||((i1_stt[count_stt]==(i+1))&&(i2_stt[count_stt]==(j+1)))||((i1_sta[count_sta]==(i+1))&&(i2_sta[count_sta]==(j+1)))||((i1_aba[count_aba]==(i+1))&&(i2_aba[count_aba]==(j+1)))||((i1_ltt[count_ltt]==(i+1))&&(i2_ltt[count_ltt]==(j+1)))))
               {
                   if (j<i)   
               { 
                   td[c5] = abs(framebelong[i]-framebelong[j]);
                   ind5[c5]=mwSize(round((i+1)*(i-2)/2+j+1));
                   c5++;
               }
                 
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
               
                 /* Dspx */
             if ((i1_ds[count_ds]==(i+1))&&(i2_ds[count_ds]==(j+1)))
               {  
                   if (j<i)
                   { 
                    ds[c6] = v_ds[count_ds];
                    ind6[c6] = mwSize(round((i+1)*(i-2)/2+j+1));
                    c6++;
                   }
                   
               count_ds++;
               }
               
               
                  /* Textures */
             if ((i1_text[count_text]==(i+1))&&(i2_text[count_text]==(j+1)))
               {  
                   if (j<i)
                   { 
                     text_max[c7] =v_text_max[count_text];
                     text_mean[c7] =v_text_mean[count_text];
                     ind7[c7] = mwSize(round((i+1)*(i-2)/2+j+1));
                     
                     c7++;
                   }
                   
               count_text++;
               }
               
               /* STA, STM */
             if ((i1_sta[count_sta]==(i+1))&&(i2_sta[count_sta]==(j+1)))
               {  
                   if (j<i)
                   { 
                     sta[c2] =v_sta[count_sta];
                     stm[c2] =v_stm[count_sta];
                     sta3[c2] =v_sta3[count_sta];
                     stm3[c2] =v_stm3[count_sta];
                     ind2[c2] = mwSize(round((i+1)*(i-2)/2+j+1));
                     
                     c2++;
                   }
                   
               count_sta++;
               }
            
               
            /* STD */
             if ((i1_std[count_std]==(i+1))&&(i2_std[count_std]==(j+1)))
               {   
                   if (j<i)
                   { 
                    std[c8] = v_std[count_std];
                    ind8[c8] = mwSize(round((i+1)*(i-2)/2+j+1));
                    c8++;
                   }
                   
               count_std++;
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
     n1_n1 = 0;   n1_n2 = 0; n3 = 0;
     n2_n1 = 0; n2_n2=0; n4 = 0;
    count_stt = 0;
    count_sta = 0;
    count_aba = 0;
    count_ltt = 0;
    count_text=0;
    count_ds=0;
    count_std=0;
    c5 = 0;

    for(j=0; j<newsize; j++)
    {
        /* within */
      
        if ((td[c5]==0)&&((ind2[count_sta]==j)||(ind3[count_aba]==j)||(ind6[count_ds]==j)||(ind7[count_text]==j)||(ind8[count_std]==j) ))
                
            
            if (ind3[count_aba]==j)
               n1_n1++;
            else   
               n1_n2++;
           
                
        /* across_1 */
             
         if ((td[c5]==1)&&((ind2[count_sta]==j)||(ind1[count_stt]==j)||(ind7[count_text]==j)||(ind8[count_std]==j)))
      
            if (ind1[count_stt]==j)
               n2_n1++;
            else   
               n2_n2++;
       
        /* across_2 */
             
          if ((td[c5]==2)&&((ind4[count_ltt]==j)||(ind1[count_stt]==j)||(ind6[count_ds]==j)||(ind8[count_std]==j)))
          
              n3++;
        
         /* across_2 */
             
          if ((td[c5]>2)&&((ind4[count_ltt]==j)||(ind6[count_ds]==j)||(ind8[count_std]==j)))
  
              n4++;
         
           if (ind4[count_ltt]==j)  count_ltt++;
           if (ind1[count_stt]==j)  count_stt++;
           if (ind2[count_sta]==j)  count_sta++;
           if (ind3[count_aba]==j)  count_aba++; 
           if (ind6[count_ds]==j)   count_ds++;
           if (ind8[count_std]==j)   count_std++;
           if (ind7[count_text]==j) count_text++; 
           if (ind5[c5]==j) c5++;
        
    } 
    plhs[0] = mxCreateDoubleMatrix(n1_n1,10,mxREAL);    
    double* X1_n1 = mxGetPr(plhs[0]);  
    plhs[1] = mxCreateDoubleMatrix(n1_n2,8,mxREAL);    
    double* X1_n2 = mxGetPr(plhs[1]);  
    plhs[2] = mxCreateDoubleMatrix(n2_n1,7,mxREAL);    
    double* X2_n1 = mxGetPr(plhs[2]); 
    plhs[3] = mxCreateDoubleMatrix(n2_n2,6,mxREAL);    
    double* X2_n2 = mxGetPr(plhs[3]);   
    plhs[4] = mxCreateDoubleMatrix(n3,5,mxREAL);    
    double* X3 = mxGetPr(plhs[4]);  
    plhs[5] = mxCreateDoubleMatrix(n4,5,mxREAL);    
    double* X4 = mxGetPr(plhs[5]);  
     
    plhs[6] = mxCreateDoubleMatrix(n1_n1,1,mxREAL);    
    double* index1_n1 = mxGetPr(plhs[6]); 
    plhs[7] = mxCreateDoubleMatrix(n1_n2,1,mxREAL);    
    double* index1_n2 = mxGetPr(plhs[7]); 
    plhs[8] = mxCreateDoubleMatrix(n2_n1,1,mxREAL);    
    double* index2_n1 = mxGetPr(plhs[8]);  
    plhs[9] = mxCreateDoubleMatrix(n2_n2,1,mxREAL);    
    double* index2_n2 = mxGetPr(plhs[9]);   
    plhs[10] = mxCreateDoubleMatrix(n3,1,mxREAL);    
    double* index3 = mxGetPr(plhs[10]);  
    plhs[11] = mxCreateDoubleMatrix(n4,1,mxREAL);    
    double* index4 = mxGetPr(plhs[11]);  
    
    
    c1_n1=0; c2_n1=0; c1_n2=0; c2_n2=0; c3=0; c4=0;
    count_stt = 0;
    count_sta = 0;
    count_aba = 0;
    count_ltt = 0;
    c5=0; count_std=0; 
    count_text=0;
    count_ds=0;
    mwSize count = 1; 
   

    for(j=0; j<newsize; j++)
    {
        /* within */
         if ((td[c5]==0)&&((ind2[count_sta]==j)||(ind3[count_aba]==j)||(ind6[count_ds]==j)||(ind7[count_text]==j)||(ind8[count_std]==j)))
           {  
               if (ind3[count_aba]==j)
               {
             
             if (ind2[count_sta]==j)
              {
              X1_n1[c1_n1] = sta[count_sta]; X1_n1[n1_n1+c1_n1] = stm[count_sta]; 
              X1_n1[5*n1_n1+c1_n1] = sta3[count_sta]; X1_n1[6*n1_n1+c1_n1] = stm3[count_sta]; 
              }
              if (ind3[count_aba]==j)
              {
              X1_n1[2*n1_n1+c1_n1] = aba[count_aba]; X1_n1[3*n1_n1+c1_n1] = abm[count_aba];
              }
               if (ind6[count_ds]==j)
              {
              X1_n1[9*n1_n1+c1_n1] = ds[count_ds]; 
              }
               if (ind7[count_text]==j)
              {
              X1_n1[7*n1_n1+c1_n1] = text_max[count_text]; X1_n1[8*n1_n1+c1_n1] = text_mean[count_text];
              }
               if (ind8[count_std]==j)
              {
              X1_n1[4*n1_n1+c1_n1] = std[count_std];
              }
              
              index1_n1[c1_n1] = count;
              c1_n1++;
               }
               
               else
              {
             
             if (ind2[count_sta]==j)
              {
              X1_n2[c1_n2] = sta[count_sta]; X1_n2[n1_n2+c1_n2] = stm[count_sta]; 
              X1_n2[3*n1_n2+c1_n2] = sta3[count_sta]; X1_n2[4*n1_n2+c1_n2] = stm3[count_sta]; 
              }
            
               if (ind6[count_ds]==j)
              {
              X1_n2[7*n1_n2+c1_n2] = ds[count_ds]; 
              }
               if (ind7[count_text]==j)
              {
              X1_n2[5*n1_n2+c1_n2] = text_max[count_text]; X1_n2[6*n1_n2+c1_n2] = text_mean[count_text];
              }
               if (ind8[count_std]==j)
              {
              X1_n2[2*n1_n2+c1_n2] = std[count_std];
              }
              
              index1_n2[c1_n2] = count;
              c1_n2++;
               }
               
            }
        
        /* across_1 */
             
        if ((td[c5]==1)&&((ind2[count_sta]==j)||(ind1[count_stt]==j)||(ind7[count_text]==j)||(ind8[count_std]==j)))
             
            if (ind1[count_stt]==j)
            
            { if (ind2[count_sta]==j)
              {            
              X2_n1[c2_n1] = stm[count_sta]; X2_n1[n2_n1+c2_n1] = sta[count_sta]; 
              X2_n1[4*n2_n1+c2_n1] = sta3[count_sta]; 
              }
              if (ind1[count_stt]==j)
              {
              X2_n1[2*n2_n1+c2_n1] = stt[count_stt]; 
              }
              
             if (ind7[count_text]==j)
              {
              X2_n1[5*n2_n1+c2_n1] = text_max[count_text]; X2_n1[6*n2_n1+c2_n1] = text_mean[count_text];
              }
              
              if (ind8[count_std]==j)
              {
              X2_n1[3*n2_n1+c2_n1] = std[count_std];
              }
              
              index2_n1[c2_n1] = count;
              c2_n1++;
            }
            else
              { if (ind2[count_sta]==j)
              {            
              X2_n2[c2_n2] = stm[count_sta]; X2_n2[n2_n2+c2_n2] = sta[count_sta]; 
              X2_n2[3*n2_n2+c2_n2] = sta3[count_sta]; 
              }
                            
             if (ind7[count_text]==j)
              {
              X2_n2[4*n2_n2+c2_n2] = text_max[count_text]; X2_n2[5*n2_n2+c2_n2] = text_mean[count_text];
              }
              
              if (ind8[count_std]==j)
              {
              X2_n2[2*n2_n2+c2_n2] = std[count_std];
              }
              
              index2_n2[c2_n2] = count;
              c2_n2++;
            }
        /* across_2 */
             
        if ((td[c5]==2)&&((ind4[count_ltt]==j)||(ind1[count_stt]==j)||(ind6[count_ds]==j)||(ind8[count_std]==j)))
                      
            { if (ind1[count_stt]==j)
              {
              X3[c3] = stt[count_stt]; 
              }
              if (ind4[count_ltt]==j)
              {
              X3[n3+c3] = ltt[count_ltt]; X3[2*n3+c3] = ctr[count_ltt]; 
              }
               if (ind8[count_std]==j)
              {
              X3[3*n3+c3] = std[count_std];
              }
              
              
              if (ind6[count_ds]==j)
              {
              X3[4*n3+c3] = ds[count_ds]; 
              }
              
              index3[c3] = count;
              c3++;
            }
        
         /* across_2 */
             
        if ((td[c5]>2)&&((ind4[count_ltt]==j)||(ind6[count_ds]==j)||(ind8[count_std]==j)))
            { 
                
              X4[c4] = ltt[count_ltt]; X4[n4+c4] = ctr[count_ltt]; X4[4*n4+c4] = td[c5]; 
              if (ind8[count_std]==j)
              {
              X4[2*n4+c4] = std[count_std];              
                }
              if (ind6[count_ds]==j)
              {
              X4[3*n4+c4] = ds[count_ds]; 
              }
              

              index4[c4] = count;
              c4++;
           }
         
           if (ind4[count_ltt]==j) count_ltt++;
           if (ind1[count_stt]==j) count_stt++;
           if (ind2[count_sta]==j) count_sta++;
           if (ind3[count_aba]==j) count_aba++;  
           if (ind6[count_ds]==j)   count_ds++;
           if (ind7[count_text]==j) count_text++; 
           if (ind5[c5]==j) c5++;
           if (ind8[count_std]==j) count_std++;
         
     count++;    
    }
    

mxDestroyArray(Xstd);        
mxDestroyArray(Xtd);  
mxDestroyArray(Xds);
mxDestroyArray(Xtext_max);
mxDestroyArray(Xtext_mean);
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
mxDestroyArray(I6); 
mxDestroyArray(I7); 
mxDestroyArray(I8); 
}

