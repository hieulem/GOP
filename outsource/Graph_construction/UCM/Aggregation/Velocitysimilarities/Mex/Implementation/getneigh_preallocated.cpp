#ifndef getneigh_c
#define getneigh_c

#include <stdio.h>
#include <string.h>
#include <iostream>
#include "auxfun.h"
#include "matrix.h"
#include "getneigh.h"


int  getneigh_preallocated(int *neighlabel,const int *alabel,const double *concc,const double *conrr,const double *thedepth,const double *maxsuperpixels, const int num_alabel, const mwSize num_concc, const mwSize num_conrr,bool *bool_all_spx,bool* bool_newneighlabels,bool *bool_prevlabel)
//  int*  getneigh( int *alabel ,double conrr, const int num_alabel)
{
  // I. INITIATE
    int d,k,num_neighlabels, thelabel,bpl,ip,ipl;
    int numberofsuperpixels, num_prevneighbors,num_newlabels;
    int  num_neighlabel;
    mwSize i,j;
    numberofsuperpixels = (int) *maxsuperpixels; // total superpizels across noFrames
    num_neighlabels   = 0;
    num_newlabels     = 0;
    num_prevneighbors = 0; 
   if(num_alabel > 1)
   {
       for( i =0 ; i< num_alabel; i++)
       {
            thelabel = (int)alabel[i];
            bool_all_spx  [thelabel-1] = true;       
            bool_prevlabel[thelabel-1] = true;
            for(j=0; j< num_conrr; j++)
            {
                if(conrr[j] == thelabel)
                {
                   bool_all_spx   [(int) concc[j]-1] = true; 
                   bool_prevlabel[(int) concc[j]-1] = true;  // making a copy of the neighlabels
                }
                if(concc[j] == thelabel)
                {
                  bool_all_spx  [(int) conrr[j]-1] = true;  
                  bool_prevlabel[(int) conrr[j]-1] = true;// making a copy of the neighlabels
                }
            }
            bool_all_spx  [thelabel-1] =false;      //remove the original labels (alabel) from the neighlabel 
            bool_prevlabel[thelabel-1] =false;// making a copy of the neighlabels
       } 
   }   
   else if( num_alabel ==1)
   {
        thelabel = (int) alabel[0];
        bool_all_spx  [thelabel-1] = true;          
        bool_prevlabel[thelabel-1] = true;// making a copy of the neighlabels
        for(j=0; j< num_conrr; j++)
        {
            if(conrr[j] == thelabel)
            {
                 bool_all_spx  [(int)concc[j]-1] = true; 
                 bool_prevlabel[(int)concc[j]-1] = true;// making a copy of the neighlabels

            }
            if(concc[j] == thelabel)
            {
                 bool_all_spx  [(int)conrr[j]-1] = true; 
                 bool_prevlabel[(int)conrr[j]-1] = true;// making a copy of the neighlabels
            }
        }
//         bool_all_spx  [thelabel-1] =false;               // not needed
//         bool_prevlabel[thelabel-1] =false; // making a copy of the neighlabels
  }
//    
// //    The  bool_all_spx logical array has all the neighboring labels
   
   for (d = 2; d <= *thedepth; d++)   
   {
//         for(bpl=0; bpl<numberofsuperpixels ; bpl++)
//         {
//             if(bool_prevlabel[bpl])
//             {
//                 for(i=0; i< num_concc; i++)
//                 {
//                     if(conrr[i] ==(bpl+1))   // since the conrr and concc arrays are in matlab notations
//                     {
//                         bool_newneighlabels[(int)concc[i]-1] = true;   ///change i to i-1
//                     }
//                     if(concc[i] ==(bpl+1))
//                     {
//                         bool_newneighlabels[(int)conrr[i]-1] = true;    //change i to i-1
//                     }
//                 }
//             }
//         }
       for(i=0; i< num_concc; i++)
       {
           if(bool_prevlabel[(int)(conrr[i]-1)])
           {
               bool_newneighlabels[(int)concc[i]-1] = true;
           }
           if(bool_prevlabel[(int)(concc[i]-1)])
           {
               bool_newneighlabels[(int)conrr[i]-1] = true;
           }
       }
           
        if ( (* thedepth>2) && (d< * thedepth) )
        {
            for(ip=0; ip< numberofsuperpixels; ip++)   // code for  :: "prevneighbours=setdiff(newneighlabels,neighlabels)"
            {
                if( bool_newneighlabels[ip] != bool_all_spx[ip])
                {
                     bool_prevlabel[ip]=true;  //setting true to the differences
//                     temp_prevlabels[k] = i+1;
//                     k++;
                }
                if(bool_all_spx[ip])
                {                                 
                     bool_prevlabel[ip]=false;    // deleting the original labels
                }
            }
            if (d==2)
            { 
                if(num_alabel > 1)
                {
                     for( i =0 ; i< num_alabel; i++)
                     {
                        thelabel = (int)alabel[i];
//                         bool_newneighlabels[thelabel-1] = false;   //alabels arrays is in matlab notations
                        bool_prevlabel[thelabel-1] = false;
                    }
                }
                else if(num_alabel == 1)
                {
//                     bool_newneighlabels[((int) alabel[0]) -1] = false;
                       bool_prevlabel[((int) alabel[0]) -1] = false;

                }
            }
        }
   }
    
//     _________________________________________________________________________________________________
//     bool_newneighlabels[1] = false;   // THIS HAS TO BE IMPLIMENTED FOR THE MORE GENERAL CASE  
//    Counting the number of newneighlabels
    
       for(ipl=0; ipl< numberofsuperpixels; ipl++)   // code for  :: "prevneighbours=setdiff(newneighlabels,neighlabels)"
       {
           if(bool_all_spx[ipl])
           {
                bool_newneighlabels[ipl]=true;
           }
       }

    
   for(j=0; j< numberofsuperpixels; j++)
   {
        if(bool_newneighlabels[j]== true)
        {
           num_newlabels++;
        }
   } 
   i=0;
   for(j=0; j< numberofsuperpixels; j++)      
   {
       if(bool_newneighlabels[j])
       {
          neighlabel[i] =j+1;
          i++;
       }
   }

   num_neighlabel = i;
   return num_neighlabel;  
}


#endif

