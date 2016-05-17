/* Mex impelmentation of STT
 * Usage :
 *
 * mex -largeArrayDims STT_innerloops_mex.cpp  -I. initarrytozero.cpp initbooltozero.cpp initintarrytozero.cpp Evolveregionsfastwithfilteredflows_cpp.cpp  Measuresimilarity_cpp.cpp
 *
 * Command to execute:
 * noofinserted= STT_innerloops_mex(graphdepth,noFrames,labelledlevelvideo,multcount,maxnumberofsuperpixelsperframe,flows,mapped,sxo,syo,svo);
 *
 */

/* INCLUDES: */
#include "mex.h"
#include "matrix.h"
#include "auxfun.h"
#include "limits.h"
#include "math.h"
#include "Evolveregionsfastwithfilteredflows_cpp.h"
#include "Measuresimilarity_cpp.h"

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
 
 
 
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
   /* DECLARATIONS: */
    double  *graphdepth ,*noframes, *labelledlevelvideo,*multcount, *maxsuperpixels, *flows, *mapped,*sxo,*syo,*svo;
    double *test;  //output variable

    graphdepth                     = mxGetPr(prhs[0]);
    noframes                       = mxGetPr(prhs[1]);
    labelledlevelvideo             = mxGetPr(prhs[2]);
    multcount                      = mxGetPr(prhs[3]);
    maxsuperpixels                 = mxGetPr(prhs[4]);
    flows                          = mxGetPr(prhs[5]);
    mapped                         = mxGetPr(prhs[6]);
    sxo                            = mxGetPr(prhs[7]);
    syo                            = mxGetPr(prhs[8]);
    svo                            = mxGetPr(prhs[9]);
    
//          local variables
    int firstframe, frame,frameup,nolabelsone, noofinserted,maxsuperpixelsperframe;
    int dimframe_labvideo,dimrow_labvideo,dimcol_labvideo, i, start_index;;
    bool  *bool_masksonframe, *similaritydoneone, *themask;
    int *labelsonone, *labelsontwo;  
    double  *similarityatone,importanceforprobability,*predicted_mask,similarity;
    int label, atdepth,min,num_elements,num_fields,aux1;
    int ff,tk,num_indi,toinsertthere,lin_ind,num_simdone; // variables for graphdepth >1
    int *interestedlabels;
    int *indices,*col_index,*row_index,dimrow,dimcol;


// pointers to extract a flow from the structure
   mxArray *tmp_flows_flows,*tmp_flows_flows_no,*tmp_flows_flows_no_Up,*tmp_flows_flows_no_Vp,*tmp_flows_flows_no_Um,*tmp_flows_flows_no_Vm;
   int no_frames;      
   double  *tmp_flows_flows_no_Up_matrix,*tmp_flows_flows_no_Vp_matrix,*tmp_flows_flows_no_Um_matrix,*tmp_flows_flows_no_Vm_matrix;
   
    maxsuperpixelsperframe = (int) *maxsuperpixels;
    dimrow_labvideo        = mxGetM(prhs[2]);
    dimframe_labvideo      = (int) *noframes;
    dimcol_labvideo        = mxGetN(prhs[2])/dimframe_labvideo;
    num_elements           = mxGetNumberOfElements(prhs[5]);
    num_fields             = mxGetNumberOfFields(prhs[5]);
    dimrow                 = (int) *maxsuperpixels;
    dimcol                 = (int) *maxsuperpixels;

   
     bool *bool_interestedlabels,*bool_maskontwo; 
     int num_lab=0,ii,il,intlab,label_max,max_var;  // max_var keeps track of the max label for every iteration so that there is no need to run through the entire bool array
     label_max = (int) maxsuperpixelsperframe;    
   // memory allocations for the temp arrays
      bool_interestedlabels = new bool[label_max];          //label_max is the upperbound of the labels ASK FABIO             
      bool_maskontwo = new bool[(dimrow_labvideo*dimcol_labvideo)];
      labelsonone                 = new int[dimrow_labvideo*dimcol_labvideo]; // chang this too to double?
      labelsontwo                 = new int[dimrow_labvideo*dimcol_labvideo];     
      similarityatone             = new double[maxsuperpixelsperframe*maxsuperpixelsperframe*((int)*graphdepth)];
      similaritydoneone           = new bool[maxsuperpixelsperframe*maxsuperpixelsperframe*((int) *graphdepth)];
      themask                     = new bool[dimrow_labvideo*dimcol_labvideo]; 
      bool_masksonframe           = new bool[dimrow_labvideo*dimcol_labvideo*maxsuperpixelsperframe];
      interestedlabels            = new int[dimrow_labvideo*dimcol_labvideo];
      predicted_mask              = new double[dimrow_labvideo*dimcol_labvideo];

        
      
//       initbooltozero(themask               ,(dimrow_labvideo*dimcol_labvideo));
//       initbooltozero(bool_maskontwo        ,(dimrow_labvideo*dimcol_labvideo));
//       initbooltozero(bool_interestedlabels ,label_max);
      
      noofinserted =0;
      for(frame =1; frame < (int) *noframes; frame++)
//       for(frame =1; frame < 2; frame++)
       {
           initbooltozero(similaritydoneone,(maxsuperpixelsperframe*maxsuperpixelsperframe*((int)*graphdepth)));
           initarrytozero(similarityatone,(maxsuperpixelsperframe*maxsuperpixelsperframe*((int)*graphdepth)));
        //-----------GENERATING LABELSATONE------------
           start_index = linearindex_3d(1,1, frame,dimrow_labvideo,dimcol_labvideo);
           nolabelsone =0;
           for( i =0; i< (dimcol_labvideo*dimrow_labvideo); i++)
           {
               labelsonone[i] = (int) labelledlevelvideo[start_index];
               start_index++;
               if(nolabelsone <labelsonone[i])
               {
                   nolabelsone = labelsonone[i];
               }
           }
        //--------gen labelsatone complete-----------------
//            bool_masksonframe = new bool[dimrow_labvideo*dimcol_labvideo*nolabelsone];
//            initbooltozero(bool_masksonframe,(dimrow_labvideo*dimcol_labvideo*maxsuperpixelsperframe));
           for(label=0;label < nolabelsone; label++)
           {
               start_index = linearindex_3d(1,1, (label+1),dimrow_labvideo,dimcol_labvideo);
               for(i=0; i <  (dimcol_labvideo*dimrow_labvideo); i++)
               {
                   if(labelsonone[i] == (label+1))  //labelsonone contain matlab index elements
                   {
                        bool_masksonframe[start_index+i]= true;
                   }
                   else
                   {
                       bool_masksonframe[start_index+i]= false;
                   }
               }
           }
           min = frame+ (int) *graphdepth;

           if(min > (int) *noframes)
           {
               min = (int)*noframes;
           }  
        /*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            *________CODE TO EXTRACT FLOWS FROM STRUCT "FLOWS"____________________*/
           /* Pointer to the first location of the mxArray */
              tmp_flows_flows = mxGetField(prhs[5], 0, "flows"); //extraction from struct
              no_frames = mxGetNumberOfElements(tmp_flows_flows);
             tmp_flows_flows_no = mxGetCell(tmp_flows_flows,(frame-1) ); //extraction from cell array
           // extraction from struct
             tmp_flows_flows_no_Up=mxGetField(tmp_flows_flows_no,0,"Up"); 
             tmp_flows_flows_no_Vp=mxGetField(tmp_flows_flows_no,0,"Vp"); 
             tmp_flows_flows_no_Um=mxGetField(tmp_flows_flows_no,0,"Um"); 
             tmp_flows_flows_no_Vm=mxGetField(tmp_flows_flows_no,0,"Vm"); 
           // typecasting for use     
             tmp_flows_flows_no_Up_matrix = mxGetPr(tmp_flows_flows_no_Up);
             tmp_flows_flows_no_Vp_matrix = mxGetPr(tmp_flows_flows_no_Vp);
             tmp_flows_flows_no_Um_matrix = mxGetPr(tmp_flows_flows_no_Um);
             tmp_flows_flows_no_Vm_matrix = mxGetPr(tmp_flows_flows_no_Vm);
             /*^^^^^^^^^^^^^^^FLOWS ARE EXTRACTED^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
           importanceforprobability=1.0; //value is decreased by multcount in successive graphdepths
           firstframe=true;
          
           for(frameup =(frame+1); frameup <= min; frameup++)
           {
               atdepth = frameup - frame;
        //        generate labelsontwo
//                initintarrytozero(labelsontwo,(dimcol_labvideo*dimrow_labvideo)); 
                start_index = linearindex_3d(1,1, frameup,dimrow_labvideo,dimcol_labvideo);  
                for( i =0; i< (dimcol_labvideo*dimrow_labvideo); i++)
                {
                    labelsontwo[i] = labelledlevelvideo[start_index];
                    start_index++;
                }

        //         -----labelsattwo generated-----------   
                if(firstframe)
                {
                    firstframe =false;
                }
                else
                {
                    importanceforprobability=importanceforprobability/ (*multcount);
                }
                for(label =0;label< nolabelsone;label++)
                {
//                     initbooltozero(themask,(dimrow_labvideo*dimcol_labvideo));
                    aux1 = label+1;
                    start_index = linearindex_3d(1,1,aux1,dimrow_labvideo,dimcol_labvideo);//label+1 because maskonframe has matlab indices
                    for( i =0; i< (dimcol_labvideo*dimrow_labvideo); i++)
                    {
                        themask[i] = bool_masksonframe[start_index];
                        start_index++;
                    }
                    initarrytozero(predicted_mask,(dimcol_labvideo*dimrow_labvideo));
                    
                     Evolveregionsfastwithfilteredflows_cpp(predicted_mask,themask,tmp_flows_flows_no_Up_matrix,tmp_flows_flows_no_Vp_matrix,
                    tmp_flows_flows_no_Um_matrix,tmp_flows_flows_no_Vm_matrix,dimrow_labvideo,dimcol_labvideo);  
                    if((int) *graphdepth >1)
                    {
                          start_index = linearindex_3d(1,1, aux1,dimrow_labvideo,dimcol_labvideo);
                          for(i=0;i<(dimcol_labvideo*dimrow_labvideo);i++)
                          {
                              if(predicted_mask[i] > 0.5)  
                              {
                                   bool_masksonframe[start_index+i]= true; //update masksonframe for next graph depth    
                              }
                              else
                              {
                                  bool_masksonframe[start_index+i] =false;
                              }
                          }
                     }
                     initbooltozero(bool_interestedlabels,label_max); 
                     
                    max_var=0;
                     for(i=0; i<(dimcol_labvideo*dimrow_labvideo); i++)
                     {
                         if(predicted_mask[i] > 0)
                         {
                             bool_interestedlabels[labelsontwo[i] -1] =true; // labelsontwo in matlab indices, bool_interes... in "c" indices
                             if(max_var < labelsontwo[i])
                             {
                                max_var = labelsontwo[i]; //max_var will limit the range of the iteration below
                             }
                         }
                     }
                    num_lab=0;
    //              counting the number of interestde labels
                     for(i=0; i< max_var; i++)
                     {
                         if( bool_interestedlabels[i] == true)
                         {
                            num_lab++;
                         }
                     }
//                     initintarrytozero(interestedlabels,(dimcol_labvideo*dimrow_labvideo)); 
//                     interestedlabels = new double[num_lab];
                    ii=0;
                    for(i=0;i < max_var;i++)  // max_var is helping to limit the range of the iteration
                    {
                         if(bool_interestedlabels[i])
                         {
                             interestedlabels[ii] = (i+1); // since labels must be in matlab indices
                             bool_interestedlabels[i] = false;  // this helps in that the bool array need not be init to zero for every iteration
                             ii++;
                         }
                     }
                    for(il=0;il < num_lab; il++)
                     {
                         similarity =0;
                         intlab = interestedlabels[il];
//                          initbooltozero(bool_maskontwo,(dimrow_labvideo*dimcol_labvideo));  // since this is reused within the loop
                         for( i =0; i< (dimcol_labvideo*dimrow_labvideo); i++)
                         {
                             if(labelsontwo[i] == intlab)
                             {
                                 bool_maskontwo[i] =true;
                             }
                             else
                             {
                                 bool_maskontwo[i] =false;
                             }
                         }
                         similarity  = Measuresimilarity_cpp(bool_maskontwo,predicted_mask,dimrow_labvideo,dimcol_labvideo);   
                         start_index = linearindex_3d((label+1),intlab,atdepth,maxsuperpixelsperframe,maxsuperpixelsperframe);
                         similarityatone[start_index] = similarity*importanceforprobability;
                         similaritydoneone[start_index]=true;
                      }
                }//for(label =0;label< nolabelsone;label++)
           }// end of ***for(frameup =(frame+1); frameup <= min; frameup++) 
           
           
//            int row_index=0, col_index=0,row_index_2d=0,col_index_2d=0;
//            int indices;
           int r,c,tmp,nframes,startofframe;
           nframes=(int) *noframes;
           num_simdone = maxsuperpixelsperframe*maxsuperpixelsperframe;
           for(ff=1; ff <= (int) *graphdepth; ff++)
//            for(ff=1; ff <= 2; ff++)  
           {
               startofframe=(ff-1)*maxsuperpixelsperframe*maxsuperpixelsperframe;
               for(r=1; r<= maxsuperpixelsperframe; r++)
               {
                   for (c=1; c<= maxsuperpixelsperframe; c++)
                   {                                             
                        lin_ind =startofframe + (c-1)*maxsuperpixelsperframe + (r-1);
                        if (similaritydoneone[lin_ind])
                        {
                           svo[noofinserted] = similarityatone[lin_ind]; 
                           tmp=linearindex_k(frame,r, nframes);
                           sxo[noofinserted] = mapped[tmp]; //lin_ind < [frame, r];
                           tmp=linearindex_k(frame+ff,c, nframes);
                           syo[noofinserted] = mapped[tmp]; //lin_ind < [frame+ff, c];
                           noofinserted++;                        
                        }
                   }
               }
           } //end of for(ff=1; ff <= (int) *graphdepth; ff++)
      } // end of "for(frame =1; frame < (int) *noframes; frame++)"
  
    
       delete [] labelsonone;
       delete [] labelsontwo;
       delete [] similarityatone;             
       delete [] similaritydoneone;
       delete [] themask;
       delete [] bool_maskontwo;
       delete [] bool_interestedlabels;
       delete [] interestedlabels;
       delete [] predicted_mask;
       delete [] bool_masksonframe;
 

    //    generating the output array 
       plhs[0]= mxCreateDoubleMatrix(1, 1,mxREAL);         
       test = mxGetPr(plhs[0]);
       test[0] = noofinserted;
}// end of main
