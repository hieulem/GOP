#ifndef getneigh_cpp_c
#define getneigh_cpp_c

#include <stdio.h>
#include <string.h>
#include <iostream>

#include "auxfun.h"
#include "getneigh_cpp.h"


// this functzion is specific for the cpp friendly impelmentation. the first argument is now just a const int

int*  getneigh_cpp( int alabel,double *concc, double *conrr, double *thedepth, double *maxsuperpixels, const int num_concc, const int num_conrr)
//  int*  getneigh( int *alabel ,double conrr, const int num_alabel)
{
  // I. INITIATE
    int i,j,d,k,num_neighlabels, thelabel;
    int numberofsuperpixels, num_prevneighbors,num_newlabels;
    bool * bool_all_spx, * bool_newneighlabels;
    int  *temp_labels,*temp_prevlabels;
  
    
    int *neighlabel;  // this is the output array
 
    
    numberofsuperpixels = (int) *maxsuperpixels;
    bool_all_spx          = new bool[numberofsuperpixels];
    bool_newneighlabels   = new bool[numberofsuperpixels];
    num_neighlabels   = 0;
    num_newlabels     = 0;
    num_prevneighbors = 0; 
    
//     for(i=0; i< numberofsuperpixels; i++)
//    {
//        bool_all_spx[i] = false;         Delete in the final stage
//        bool_newneighlabels[i] = false;
//    }
   initbooltozero( bool_all_spx,numberofsuperpixels);
   initbooltozero( bool_newneighlabels,numberofsuperpixels);
   
  
   
    thelabel = alabel;
    bool_all_spx[thelabel-1] = true;          // possibility to do thelabel-1 to be consistent with c or allocate maxsuperpixel +1

    for(j=0; j< num_conrr; j++)
    {
        if(conrr[j] == thelabel)
        {
             bool_all_spx[(int)concc[j]-1] = true; 

        }
        if(concc[j] == thelabel)
        {
             bool_all_spx[(int)conrr[j]-1] = true; 
        }
    }
    bool_all_spx[thelabel-1] =false;               
   
//    
// //    The  bool_all_spx logical array is used to generate neighlabel
// //    Counting the number of neighlabel 
   for(j=0; j< numberofsuperpixels; j++)
   {
        if(bool_all_spx[j] == true)
        {
           num_neighlabels++;
        }
   }
   //    numneighlabels has the number of neighboring labels
    temp_labels = new int[num_neighlabels];    //mxCreateDoubleMatrix(num_neighlabels, 1,mxREAL); 1
    temp_prevlabels = new int[num_neighlabels];
//     initialising temp_labels to 0
    for(i=0; i< num_neighlabels; i++)
   {
       temp_labels[i] = 0;
       temp_prevlabels[i] =0;
   } 
 // generating the neighlabel and storing it in the temp_labels array   
    i=0;
    for(j=0; j< numberofsuperpixels; j++)      
       {
            if(bool_all_spx[j] == 1)
                {
                   temp_labels[i] =j+1;        //changed form j to j+1
                   temp_prevlabels[i] =j+1;
                   bool_newneighlabels[j] = true;
                   i++;
                }
       } 
//  +++++++++++ num_neighlabels has the number of neighlabel    ++++++++++++
    num_prevneighbors =num_neighlabels;
// // DEpth > 2***************************************** 
   for (d = 2; d <= *thedepth; d++)   
       {
            for(j=0; j< num_prevneighbors; j++)
            {
                for(i=0; i< num_concc; i++)
                {
                    if(conrr[i] ==temp_prevlabels[j])   
                    {
                        bool_newneighlabels[(int)concc[i]-1] = true;   ///change i to i-1
                    }
                     if(concc[i] ==temp_prevlabels[j])
                    {
                        bool_newneighlabels[(int)conrr[i]-1] = true;    //change i to i-1
                    }
                }
            }
            if ( (* thedepth>2) && (d< * thedepth) )
            {
                k=0;
                for(i=0; i< numberofsuperpixels; i++)
                {
                    if( bool_newneighlabels[i] != bool_all_spx[i])
                    {
                        temp_prevlabels[k] = i+1;
                        k++;
                    }
                }     
                if (d==2)
                { 
                   
                        bool_newneighlabels[alabel -1] = false;
                }
            }
   }
    
//     _________________________________________________________________________________________________
//     bool_newneighlabels[1] = false;   // THIS HAS TO BE IMPLIMENTED FOR THE MORE GENERAL CASE
// At this stage, temp_neighlabels ahve the neighlabel and bool_newneighlabels have the newneighlabels
//   both of these have to be concatenated in neighlables and returned   
//    Counting the number of newneighlabels 
   for(j=0; j< numberofsuperpixels; j++)
   {
        if(bool_newneighlabels[j]== true)
        {
           num_newlabels++;
        }
   } 
     
    neighlabel = new int[num_newlabels +1];
     i=1;
    for(j=0; j< numberofsuperpixels; j++)      
    {
        if(bool_newneighlabels[j] == 1)
            {
//                neighlabel[num_neighlabels + i] =j;
                  neighlabel[i] =j+1;
               i++;
            }
     }

    neighlabel[0] = i-1;
    delete []bool_all_spx;
    delete []bool_newneighlabels;
    delete []temp_labels;
    delete []temp_prevlabels; 
    
    return neighlabel;

    
    
}


#endif

