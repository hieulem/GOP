/*
 * Integrated program in mex for "computeappearencesimilarity.m"
 * 
 * Command to compile
 *    mex -largeArrayDims  comp_app_sim_inerloops.cpp -I. getneigh_preallocated.cpp find_double_preallocated.cpp initarrytozero.cpp initbooltozero.cpp initintarrytozero.cpp
 * Command to execute
 *    comp_app_sim_inerloops(labelsatframe,constcc,constrr,framebelong,noallsuperpixels,noFrames,temporaldepth,concc,conrr,thedepth,allmedianl,allmediana,allmedianb,maxnumberofsuperpixelsperframe,usecomplement,mapped,sxf,svf,syf,sxo,svo,syo)
 *    
*/

/* INCLUDES: */
#include "mex.h"
#include "matrix.h"
#include "getneigh.h"  // This header has the implementation of GETNEIGHBORLABELS.M
#include "auxfun.h"

 #include "limits.h"
 #include "math.h"

#include "float.h"
#include "stdlib.h"
        
 int linearindex_k( int rowindex, int colindex, int no_rows) // THIS FUNCTION IS USED BY FIRSTMEX
 {
    int linearind;
    linearind =0;
    linearind = ((colindex-1)* no_rows) + (rowindex-1);  
    return linearind;
 }        
 
 int linearindex_3d( int rowindex, int colindex, int frame_index, int no_rows, int no_cols)
 {
    int linearind;
    linearind =0;
    linearind = ((frame_index - 1)*(no_rows *no_cols))+((colindex-1)* no_rows) + (rowindex-1);  
    return linearind;
 }
 void indToSub(const int no_rows, int indices, int &row_index, int &col_index)
 {
//      int *rowtemp,*coltemp;
     if(indices > (no_rows-1))
         {
            row_index = (indices % no_rows);
            col_index = (indices / no_rows)+1;
            if ((indices % no_rows) ==0 )
            {
                row_index = no_rows;
                col_index = (indices / no_rows);
            }        
         }
         else 
         {
            row_index = indices;
            col_index = 1;
         }    
 }

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
   /* DECLARATIONS: */
    double  *labelsatframe, *constcc, *constrr, *framebelong, *maxsuperpixels, *noframes, *temporaldepth;
    double  *concc, *conrr, *thedepth,*maxsuperpixelsperframe ;   /* input arguments  */
   
    double * allmedianl,*allmediana, *allmedianb;
    double *usecomplement,*mapped, *sxf, *svf, *syf,*sxo, *svo, *syo;
    
    double *test;  //output variable

    labelsatframe                 = mxGetPr(prhs[0]);
    constcc                       = mxGetPr(prhs[1]);
    constrr                       = mxGetPr(prhs[2]);
    framebelong                   = mxGetPr(prhs[3]);
    maxsuperpixels                = mxGetPr(prhs[4]);
    noframes                      = mxGetPr(prhs[5]);
    temporaldepth                 = mxGetPr(prhs[6]);
    concc                         = mxGetPr(prhs[7]);
    conrr                         = mxGetPr(prhs[8]);
    thedepth                      = mxGetPr(prhs[9]);
    allmedianl                    = mxGetPr(prhs[10]);
    allmediana                    = mxGetPr(prhs[11]);
    allmedianb                    = mxGetPr(prhs[12]);
    maxsuperpixelsperframe        = mxGetPr(prhs[13]);
    usecomplement                 = mxGetPr(prhs[14]);
    mapped                        = mxGetPr(prhs[15]);
    sxf                           = mxGetPr(prhs[16]);
    svf                           = mxGetPr(prhs[17]);
    syf                           = mxGetPr(prhs[18]);
    sxo                           = mxGetPr(prhs[19]);
    svo                           = mxGetPr(prhs[20]);
    syo                           = mxGetPr(prhs[21]);
            
    
    
    int i,j,k,n,p,t,num_spatf,num_tempneighall,numberofsuperpixels; //, num_tempneighframes;
    int localsp, num_tempneighframes,num_tempneighlabels,asp,num_constrr,num_framebelong,temp;
    bool * bool_tempneighlabels, *bool_tempneighframes;
    int  *tempneighall, *tempneighlabels, *tempneighframes; // intermediate parametres
    int num_alabel, num_concc, num_conrr;
    int *alabel, num_neighlabels;
    int *neighlabels, *spatf;
    int l,m,tmp,neighlocallabel1; /* counters for processing the video*/
    int maskid1, maskid2, maskid3, maskid4; /* mask ID's for accesing similarity arrays*/
    int dimrow, dimcol,dimrow_median, dimcol_median;
    int f,noinsertedintra,noinsertedinter;
    
    double  *similarityatothers, *similarityatf;
    bool *similaritydonef, *similaritydoneothers;
    int min,cf,framenumber,num_touchedlabels,nl;
    int *spatf_temp, *touchedlabels;
    bool *bool_all_spx,*bool_prevlabel,*bool_newneighlabels;

    numberofsuperpixels = (int) *maxsuperpixels;
    num_constrr         = mxGetNumberOfElements(prhs[2]);
    num_framebelong     = mxGetNumberOfElements(prhs[3]);
    num_concc           = mxGetNumberOfElements(prhs[7]);   
    num_conrr           = mxGetNumberOfElements(prhs[8]);    
    dimrow              = (int) *maxsuperpixelsperframe;
    dimcol              = (int) *maxsuperpixelsperframe;
    dimrow_median       = mxGetM(prhs[10]);
    dimcol_median       = mxGetM(prhs[10]);
   
//    using logical matrics to generate tempneighlabels, tempneighframes and temp neighall//
   bool_tempneighlabels             = new bool[numberofsuperpixels];
   bool_tempneighframes             = new bool[(int) *noframes];
   similaritydonef                  = new bool[dimrow*dimcol];
   similarityatf                    = new double[dimrow*dimcol];
   similaritydoneothers             = new bool[dimrow*dimcol*((int) *temporaldepth)];
   similarityatothers               = new double[dimrow*dimcol*((int) *temporaldepth)]; 
   spatf                            = new int[(int)*maxsuperpixelsperframe];
   spatf_temp                       = new int[(int)*maxsuperpixelsperframe];
   tempneighframes                  = new int[(int)*maxsuperpixelsperframe];
   tempneighall                     = new int[(int)*maxsuperpixelsperframe];
   tempneighlabels                  = new int[(int)*maxsuperpixelsperframe];
   touchedlabels                    = new int[(int)*maxsuperpixelsperframe];
   alabel                           = new int[(int)*maxsuperpixelsperframe];
   neighlabels                      = new int[(int)*maxsuperpixelsperframe];
   bool_all_spx                     = new bool[(int)*maxsuperpixels];
   bool_newneighlabels              = new bool[(int)*maxsuperpixels];
   bool_prevlabel                   = new bool[(int)*maxsuperpixels];
 
   noinsertedintra=0; 
   noinsertedinter=0;

   for(f =1; f <= (int) *noframes; f++)
   {
       initbooltozero   ( similaritydonef,(dimrow*dimcol));
       initbooltozero   ( similaritydoneothers,(dimrow*dimcol*((int) *temporaldepth)));
       initarrytozero   ( similarityatf ,(dimrow*dimcol));
       initarrytozero   ( similarityatothers ,(dimrow*dimcol*((int) *temporaldepth))); 
       initintarrytozero( spatf, (int)*maxsuperpixelsperframe);
       num_spatf=find_double_preallocated(spatf,f, framebelong, num_framebelong,(int)*maxsuperpixelsperframe);
       for(i=0; i< num_spatf; i++)
       {
           initbooltozero( bool_tempneighlabels, numberofsuperpixels);
           initbooltozero( bool_tempneighframes, (int) *noframes);
           asp = spatf[i]; 
           localsp = (int) labelsatframe[asp-1];         
           for(j=0; j< num_constrr; j++)
            {
                if(constrr[j] == asp)
                {
                   bool_tempneighlabels[(int) constcc[j]-1] = true;         
                }

                if(constcc[j] == asp)
                {
                   bool_tempneighlabels[(int) constrr[j]-1] = true;

                }
            }
           for(j=0; j< numberofsuperpixels ; j++)
           {

                if(bool_tempneighlabels[j])
                {
                    bool_tempneighframes[(int)framebelong[j]-1] = true;             
                }
           }


           bool_tempneighframes[f-1] = true;

    //-----------------------------------------------------
    //-------exclude frames out of bounds [f:f+temporaldepth]    
           for( j=0; j< (int) *noframes; j++)
           {
               temp = (f-1) + (int) *temporaldepth ;
               if( j > temp)
               {
                   bool_tempneighframes[j] = false;
               }
               else if( j < (f-1))    //changed from f to f-1  since f is matlab and bool is c for f = 20
               {
                   bool_tempneighframes[j] = false;  
               }
           }
//     -------------------------------------------------------    

// //__________GENERATE TEMPNEIGHFRAMES___________________________  
//        Counting the number of tempneighframes
//------------------------------------------------------- 

           num_tempneighframes =0;
           for( j=0; j< numberofsuperpixels; j++)
           {
               if(bool_tempneighlabels[j])
               {
                   num_tempneighframes++;
               }
           }
        
//       ----------------------------------------------------------------------
//        generating the array first
//            tempneighframes= new int[num_tempneighframes];
           initintarrytozero(tempneighframes,(int) *maxsuperpixelsperframe);
           
           k =0;
           for(j=0; j< numberofsuperpixels; j++)      
            {
                if(bool_tempneighlabels[j])// generating with bool tempneighlabels to remain consistent with fabio code
                    {              
                         tempneighframes[k] = (int) framebelong[j];
                        k++;
                    }
             }
// //__________GENERATING TEMPNEIGHFRAMES COMPLETE___________________________        

    // //_____________GENERATE TEMPNEIGHALL__________________
    //        -----------------------------------------------
     //        count the number of tempneighall
           num_tempneighall =0;
           for( j=0; j< (int) *noframes; j++)
           {
               if(bool_tempneighframes[j])
               {
                   num_tempneighall++;
               }
           }  
    
//            tempneighall= new int[num_tempneighall]; 
           initintarrytozero(tempneighall,(int) *maxsuperpixelsperframe);
           
    //        tempneighall[0] =num_tempneighframes;
           k =0;
           for(j=0; j< (int) *noframes; j++)      
            {
                if(bool_tempneighframes[j])
                    {              
                        tempneighall[k] = j+1;          
                        k++;
                    }
             }
           
// //_______________TEMPEIGHALL GENERATED_________________________

// //__________GENERATE TEMPNEIGHLABELS___________________________  
    //        Counting the tempneighlabels
           num_tempneighlabels =0;
           for(j=0; j< numberofsuperpixels; j++) 
           {
               if(bool_tempneighlabels[j])
               {
                   num_tempneighlabels++;
               }
           }
    //       ----------------------------------------------------------------------
    //        generating the array first
//            tempneighlabels= new int[num_tempneighlabels];
            initintarrytozero(tempneighlabels,(int) *maxsuperpixelsperframe);
            p =0;
            for(j=0; j< numberofsuperpixels; j++)    
            {
                if(bool_tempneighlabels[j])
                    {              
                        tempneighlabels[p] = j+1;
                        p++;
                    }
             }
// //__________GENERATING TEMPNEIGHLABELS COMPLETE___________________________     
 
// //__________THe next level outer_testfilefor.cpp_________________

            for(n=0; n< num_tempneighall; n++)
            {
               initintarrytozero(alabel,(int) *maxsuperpixelsperframe); 
               if(tempneighall[n] == f)
               {
//                    alabel= new int[1];
                   alabel[0] = asp;
                   num_alabel =1;
               }
               else
               {
                   k=0;        
                   for(j=0; j< num_tempneighframes; j++)
                   {
                       if( (int) tempneighframes[j] == tempneighall[n])
                       {
                           k++;  
                       }
                   }
//                    alabel = new int[k];
                   num_alabel = k;
        //            generating the alabels
                   k=0;
                    for(j=0; j< num_tempneighframes; j++)
                   {
    //                    if((int) tempneighframes[j] == (n+1))
                       if((int) tempneighframes[j] == tempneighall[n])   /// this is better
                       {
                           alabel[k] = tempneighlabels[j];
                           k++;
                       }
                   }
                  num_alabel =k;   
               }  // end of else 
               initintarrytozero( neighlabels, (int)*maxsuperpixelsperframe);               
               initbooltozero   (bool_all_spx,(int)*maxsuperpixels);
               initbooltozero   (bool_newneighlabels,(int)*maxsuperpixels);
               initbooltozero   (bool_prevlabel,(int)*maxsuperpixels);
               num_neighlabels = getneigh_preallocated(neighlabels,alabel, concc, conrr, thedepth, maxsuperpixels, num_alabel, num_concc, num_conrr,bool_all_spx,bool_newneighlabels,bool_prevlabel);

    // //___________________   outer_testfilefor.cpp COMPLETE___________________________________         

    // // //__________THe next level FIRSTMEX.cpp____________________________________________    

               for ( j =0; j < num_neighlabels ; j++)
               {
                   tmp = (int) neighlabels[j];
                   neighlocallabel1 =  (int)labelsatframe[tmp-1];

                   /*similaritydonef[(int *)localsp][neighlocallabel1] = MASK ID 1*/
                   maskid1 = linearindex_k( localsp, (neighlocallabel1), dimrow);

                   /*allmedianl[*f][localsp] = MASKID 2*/
                    maskid2 = linearindex_k(f, localsp, dimrow_median);

                   /*allmedianl[*f][neighlocallabel1]= MASKID 3 */
                   maskid3 = linearindex_k(f,(neighlocallabel1), dimrow_median);

                   /*similarityatf[(int) neighlocallabel1][(int) *localsp] =MSAKID4*/
                   maskid4 = linearindex_k((neighlocallabel1),localsp , dimrow);
                   if (f == tempneighall[n]) /* this would be the symettric case*/  
                   {    
                       if (similaritydonef[maskid1])
                       {
                                    continue;
                       }
                       /* ----------------OLD CODE---------------------------------------------
                       similarityatf[(int) *localsp][neighlocallabel] = pow((allmedianl[*f][localsp]-allmedianl[*f][neighlocallabel]),2) +
                                                                     pow((allmediana[*f][localsp]-allmediana[*f][neighlocallabel]),2) +
                                                                     pow((allmedianb[*f][localsp]-allmedianb[*f][neighlocallabel]),2);          
                       similarityatf(neighlocallabel,localsp)= similarityatf(localsp,neighlocallabel);
                       similaritydonef[localsp][neighlocallabel] =true;
                       similaritydonef[neighlocallabel][localsp] =true;
                       ----------------------OLD CODE ENDS------------------------------------*/

                       similarityatf[maskid1] = pow((allmedianl[maskid2]-allmedianl[maskid3]),2) +
                                                pow((allmediana[maskid2]-allmediana[maskid3]),2) +
                                                pow((allmedianb[maskid2]-allmedianb[maskid3]),2);
                        similarityatf[maskid4] = similarityatf[maskid1];
                        
                        similaritydonef[maskid1] =true;
                        similaritydonef[maskid4] =true;
                   }

                  else          /*between sp at f and all others at other fram*/
                      /*----------------OLD CODE----------------------------------------
                      {
                      similarityatothers[localsp][neighlocallabel][neighframe[i]- *f]=
                                    pow((allmedianl[*f][localsp]-allmedianl[neighframe[i]][neighlocallabel]),2) +
                                    pow((allmediana[*f][localsp]-allmediana[neighframe[i]][neighlocallabel]),2)+
                                    pow((allmedianb[*f][localsp]-allmedianb[neighframe[i]][neighlocallabel]),2);
                    }
                   similaritydoneothers[localsp][neighlocallabel][neighframe[i]- *f]=true;  
                    -----------------OLD CODE ENDS-------------------------------------*/

                  {
                       /*REUSING THE MASKID3 FOR
                       allmedianl[neighframe[i]][neighlocallabel]) = MASKID3
                        * Have to use the 3d linearindex here
                        *int temp_var = tempneighall[n];
                        * maskid1 = linearindex_3d( localsp, (neighlocallabel1), (temp_var -f),dimrow,dimcol);
                       maskid3 = ((neighlocallabel1-1) * 20) + ((int) *neighframe ) -1;*/
                      int temp_var = tempneighall[n];
                      maskid1 = linearindex_3d( localsp, (neighlocallabel1), (temp_var -f),dimrow,dimcol);
                      maskid3 = linearindex_k(tempneighall[n] ,(neighlocallabel1), dimrow_median); 
                      
                      similarityatothers[maskid1]= pow((allmedianl[maskid2]-allmedianl[maskid3]),2) +
                                    pow((allmediana[maskid2]-allmediana[maskid3]),2)+
                                    pow((allmedianb[maskid2]-allmedianb[maskid3]),2);
                    similaritydoneothers[maskid1]=true;
                     }
               }
           }// END OF  for(i=0; i< num_tempneighall; i++) OR  for neighframe=tempneighall'
        }// end of :::: "for asp=spatf"   
// // // //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^6
// // // //    ---------usecompliment part of the code--------------------------------------
   if(usecomplement)
   {

       min = (int) *noframes - f;
       if((int) *temporaldepth < min)
       {
           min = (int) *temporaldepth;
       }
       for(cf=1; cf <= min; cf++)
       {
           framenumber = cf+ f;
           initintarrytozero( spatf_temp, (int)*maxsuperpixelsperframe);
           num_spatf=find_double_preallocated(spatf_temp,framenumber, framebelong, num_framebelong,(int)*maxsuperpixelsperframe);             
           for(k=0; k< num_spatf;k++)
           {
               initbooltozero( bool_tempneighlabels, numberofsuperpixels);
               initbooltozero( bool_tempneighframes, (int) *noframes); 
               
               asp = (int) spatf_temp[k];
               localsp = (int) labelsatframe[asp-1];
               for(j=0; j< num_constrr; j++)
               {
                    if(constrr[j] == asp)
                    {
                       bool_tempneighlabels[(int) constcc[j]-1] = true;              //MADE A CHANGE FROM []] TO [J] -1      
                    }

                    if(constcc[j] == asp)
                    {
                       bool_tempneighlabels[(int) constrr[j]-1] = true;             //MADE A CHANGE FROM []] TO [J] -1     
                    }
               }
               for(j=0; j< numberofsuperpixels ; j++)
                {
                    if(bool_tempneighlabels[j])
                    {
                        bool_tempneighframes[(int)framebelong[j]-1] = true;    
                    }
                }
// // //                 bool_tempneighframes[(int) *f] = true;                   
// //__________GENERATE TEMPNEIGHFRAMES___________________________  
//        Counting the number of tempneighframes         
               
                  num_tempneighframes =0;
                  for( j=0; j< numberofsuperpixels; j++)
                   {
                       if(bool_tempneighlabels[j])
                       {
                           num_tempneighframes++;
                       }
                   }
// //        generating the array first
//                    tempneighframes= new int[num_tempneighframes];
                   initintarrytozero(tempneighframes,(int) *maxsuperpixelsperframe);
                   
                   t=0;
                   for(j=0; j< numberofsuperpixels; j++)      
                    {
                        if(bool_tempneighlabels[j])// generating with bool tempneighlabels to remain consistent with fabio code
                        {              
                            tempneighframes[t] = (int) framebelong[j];//POTENTIAL BUG FAILS AT BOUNDARIES-- SOLVED BY A PATCH ABOVE AND BELOW IN TEMP NEIGHLABLES
                            t++;
                        }
                     }
// 
// // //__________GENERATING TEMPNEIGHFRAMES COMPLETE___________________________                   
// // //__________GENERATE TEMPNEIGHLABELS___________________________  
//        Counting the tempneighlabels
                   
                   num_tempneighlabels =0;
                   for(j=0; j< numberofsuperpixels; j++) 
                   {
                       if(bool_tempneighlabels[j])
                       {
                           num_tempneighlabels++;
                       }
                   }              
            //        generating the array first
//                    tempneighlabels= new int[num_tempneighlabels];
                   initintarrytozero(tempneighlabels,(int) *maxsuperpixelsperframe);

                    p =0;
                    for(j=0; j< numberofsuperpixels; j++)    
                    {
                        if(bool_tempneighlabels[j])
                            {              
                                tempneighlabels[p] = j+1;    // MADE A CHANGE FROM J TO J+1
                                p++;
                            }
                     }
// // //__________GENERATING TEMPNEIGHLABELS COMPLETE___________________________                       
// // //________________Generating Touched labels__________________________________
// //                     
                  p=0;
                   for(j=0; j< num_tempneighframes; j++)
                   {
                       if(tempneighframes[j] == f)
                       {
                         p++;  
                       }
                   } 
//                   touchedlabels = new int[p];
                  num_touchedlabels = p;
                  initintarrytozero(touchedlabels,(int) *maxsuperpixelsperframe);
//            generating the alabels
                   t=0;
                   for(j=0; j< num_tempneighframes; j++)
                   {
                       if((int) tempneighframes[j] == f)  
                       {
                           touchedlabels[t] = tempneighlabels[j];
                           t++;
                       }
                   }
                  num_touchedlabels = t;
//                   
// //________________Generating Touched labels COMPLETE__________________________________   
                  initintarrytozero( neighlabels, (int)*maxsuperpixelsperframe);               
                  initbooltozero   (bool_all_spx,(int)*maxsuperpixels);
                  initbooltozero   (bool_newneighlabels,(int)*maxsuperpixels);
                  initbooltozero   (bool_prevlabel,(int)*maxsuperpixels);
                  num_neighlabels = getneigh_preallocated(neighlabels,touchedlabels, concc, conrr, thedepth, maxsuperpixels, num_touchedlabels, num_concc, num_conrr,bool_all_spx,bool_newneighlabels,bool_prevlabel);                
                   
                   for ( nl =0; nl < num_neighlabels ; nl++)
                   {
                       tmp = (int) neighlabels[nl];
                       neighlocallabel1 =  (int) labelsatframe[tmp-1];
                       
// // //                     maskid1 for  similarityatothers(neighlocallabel,localsp,cf)
//                        maskid1 = linearindex_k((neighlocallabel1),localsp , dimrow);  /MUST6 USE 3D INDICE
                       maskid1 = linearindex_3d(neighlocallabel1, localsp, cf,dimrow,dimcol);
                       
// //                     mask id 2 for   allmedianl(cf+f,localsp)
                       maskid2 = linearindex_k((f +cf) , localsp, dimrow_median);
                       
// //                     maskid3 for allmedianl(f,neighlocallabel)
                       maskid3 = linearindex_k(f,(neighlocallabel1), dimrow_median);
                     
                       if(similaritydoneothers[maskid1])
                       {
                           continue;
                       }
                       similarityatothers[maskid1] =  pow((allmedianl[maskid2]-allmedianl[maskid3]),2)+
                               pow((allmediana[maskid2]-allmediana[maskid3]),2)+
                               pow((allmedianb[maskid2]-allmedianb[maskid3]),2);
                       similaritydoneothers[maskid1]=true;
                   }               
                }// end of   for(k=0; k< num_spatf;k++)       
             } //end of cf
         }// end of if(usecomplement)
// // //    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// // //    -----------usecompliment ends-------------------------------------------
       
        int  num_indi,lind,lind2;
//         int *indices, dimrow_sim, num_indi;
        int linear_ind,ff,toinsertthere;
//         int *row_index, *col_index;
        int row_index=0, col_index=0;
        double num_simdonef,num_simdoneothers;
        
       num_simdonef = dimrow*dimrow;  // dimrow = maxnosuperpixelsperframe
       num_simdoneothers=dimrow*dimrow*((int) *temporaldepth);
       int indices; 
       for (lind=0;lind< num_simdonef;lind++) 
       {
           if(similaritydonef[lind]) 
           {
               indices = (lind+1); // matlab notations
               indToSub(dimrow,indices,row_index,col_index);              
               linear_ind =linearindex_k(f,row_index,(int) *noframes);
               sxf[noinsertedintra] = mapped[linear_ind];
               linear_ind =linearindex_k(f,col_index,(int) *noframes);
               syf[noinsertedintra] = mapped[linear_ind];
               linear_ind =linearindex_k(row_index,col_index,dimrow);
               svf[noinsertedintra] = similarityatf[linear_ind]; 
               noinsertedintra++;
           }
       }
             
       for(ff = 1;ff <= (int) *temporaldepth; ff++)
       {          
           // copying the contents of the appropriate froam into temp arrays
           int tk, start_index;
           start_index = linearindex_3d(1,1, ff,dimrow,dimcol);
           for(tk=0; tk< (dimrow*dimcol); tk++)
           {
               if(similaritydoneothers[(start_index+tk)])
               {
                   
                   indices = (start_index+tk+1);
                   indToSub(dimrow,indices,row_index,col_index); 
                   linear_ind =linearindex_k(f,row_index,(int) *noframes);
                   sxo[noinsertedinter] = mapped[linear_ind];
                   linear_ind =linearindex_k((f+ff),col_index,(int) *noframes);
                   syo[noinsertedinter] = mapped[linear_ind];
                   linear_ind =linearindex_3d(row_index,col_index,ff,dimrow,dimcol);
                   svo[noinsertedinter] = similarityatothers[linear_ind];  
                   noinsertedinter++;
                }             
            }
       }
   }  //end for f = 1:20
   delete []bool_tempneighlabels;
   delete []bool_tempneighframes;
   delete []similaritydonef;      
   delete []similarityatf;     
   delete []similaritydoneothers; 
   delete []similarityatothers;
   delete []spatf;
   delete []spatf_temp;
   delete []tempneighframes; 
   delete []tempneighall;
   delete []tempneighlabels;
   delete []touchedlabels;
   delete []alabel;
   delete []neighlabels; 
   delete []bool_all_spx;          
   delete []bool_newneighlabels;   
   delete []bool_prevlabel;
    plhs[0]= mxCreateDoubleMatrix( 2, 1,mxREAL);         
   test = mxGetPr(plhs[0]);
   test[0]  = noinsertedinter;
   test[1]  = noinsertedintra;
 }

