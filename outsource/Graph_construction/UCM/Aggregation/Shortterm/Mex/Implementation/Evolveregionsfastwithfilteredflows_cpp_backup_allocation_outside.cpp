// Subfunction Evolveregionsfastwithfilteredflows_cpp_backup_allocation_outside
#ifndef Evolveregionsfastwithfilteredflows_cpp_backup_allocation_outside_cpp_c
#define Evolveregionsfastwithfilteredflows_cpp_backup_allocation_outside_cpp_c

#include <stdio.h>
#include <string.h>
#include <iostream>
#include <math.h>
#include "auxfun.h"

#include "Evolveregionsfastwithfilteredflows_cpp_backup_allocation_outside.h"

int linear_index( int rowindex, int colindex, int no_rows) 
 {
    int linearind;
    linearind =0;
    linearind = ((colindex-1)* no_rows) + (rowindex-1);  
    return linearind;
 }


double* Adjustthematrix_c(double *matrix, double *vminus, double *vplus,int minlimit, int maxlimit, int count_avg)
{
    
    bool *whichbiggermin, *whichsmallermax, *whichboth, *whichonlysmaller,*whichonlybigger, *whichareequal, *equalandsmaller;
    int i,k,j,count_whichareequal,count_equalandsmaller;
    count_whichareequal =0;
      
    whichbiggermin  = new bool[count_avg];
    whichsmallermax = new bool[count_avg];
    whichboth       = new bool[count_avg];
    whichonlysmaller= new bool[count_avg];
    whichonlybigger = new bool[count_avg];
    whichareequal   = new bool[count_avg];
    initarrytozero(vminus,count_avg);
    initarrytozero(vplus,count_avg);
    initbooltozero(whichbiggermin,count_avg);
    initbooltozero(whichsmallermax,count_avg);
    initbooltozero(whichboth,count_avg);
    initbooltozero(whichonlysmaller,count_avg);
    initbooltozero(whichonlybigger ,count_avg);
    initbooltozero(whichareequal,count_avg);
   
    for(i=0;i<count_avg;i++)
    {
        if(matrix[i] >=minlimit)
        {
            whichbiggermin[i] = true;                   
        }
        if(matrix[i] <=maxlimit)
        {
            whichsmallermax[i] = true;
        }
        whichboth[i] = whichbiggermin[i] * whichsmallermax[i]; // AND operation
        if(whichboth[i])
        {
            vminus[i] = floor(matrix[i]);
            vplus[i]  = ceil (matrix[i]);
        }
        whichonlysmaller[i] = (~ whichboth[i]) & whichsmallermax[i];
        whichonlybigger [i] = (~ whichboth[i]) & whichbiggermin[i] ;
        if(whichonlysmaller[i])
        {
            matrix[i] =minlimit;
            vminus[i] = minlimit;
            vplus [i] = vminus[i] +1;
        }
        if(whichonlybigger[i])
        {
            matrix[i] = maxlimit;
            vplus[i]  = maxlimit;
            vminus[i] = vplus[i] -1;
        }   
        if(vplus[i] == vminus[i]);
        {
        whichareequal[i] = true;
        count_whichareequal++;
        }
    }    
    double *indareequal;
    indareequal = new double[count_whichareequal];
    initarrytozero(indareequal, count_whichareequal);
    k=0;
    for(j=0;j<count_avg;j++)
    {
        if(whichareequal[j])
        {
            indareequal[k] =j;
            k++;
        }
    }
    equalandsmaller = new bool[count_whichareequal];
    initbooltozero(equalandsmaller, count_whichareequal);
    k=0;
    count_equalandsmaller=0;
    for(j=0;j<count_whichareequal;j++)
    {
        if(vplus[(int) indareequal[j]] <maxlimit)
        {
            equalandsmaller[k]=true;
            k++;
            count_equalandsmaller++;
        }
    }
    for(j=0;j<count_equalandsmaller;j++)
    { 
        if(equalandsmaller[j])
        {
            vplus[(int) indareequal[j]] = vminus[(int) indareequal[j]]+1;
        }
        else 
        {
            vminus[(int) indareequal[j]] = vplus[(int) indareequal[j]]-1;
        }
    }
    delete [] whichbiggermin;
    delete [] whichsmallermax;
    delete [] whichboth;
    delete [] whichonlysmaller;
    delete [] whichonlybigger;
    delete [] whichareequal;
    delete [] equalandsmaller;
    delete [] indareequal;
    return (matrix);   
}

void Evolveregionsfastwithfilteredflows_cpp_backup_allocation_outside( double *predicted_mask, bool *mask, double *flow_up, double *flow_vp, double *flow_um, double *flow_vm, 
        const int dimIi, const int dimIj,double *avgxs,double *avgys,double *xplus, double *xminus, double *yplus, double*yminus)
{
//     double *predictedmask,*avgxs,*avgys,*xplus,*xminus,*yplus,*yminus;
    int i,k,count_avg,j_flow;

    j_flow =0;
    for(i=0;i<(dimIi*dimIj);i++)
    {
        if(mask[i] == 1)
        {   
            avgxs[j_flow] = flow_up[i];
            avgys[j_flow] = flow_vp[i];
            j_flow++;
        }
    }
    count_avg = j_flow;
        
    avgxs = Adjustthematrix_c(avgxs,xminus,xplus,1,dimIj,count_avg);
    avgys = Adjustthematrix_c(avgys,yminus,yplus,1,dimIi,count_avg);
    
    int linind;
    for(k=0 ; k<count_avg ;k++)
    {
        linind = linear_index(yplus[k],xplus[k],dimIi);
        predicted_mask[linind] = predicted_mask[linind]+(avgxs[k]-xminus[k])*(avgys[k]-yminus[k]);
        linind = linear_index(yminus[k],xminus[k],dimIi);
        predicted_mask[linind]= predicted_mask[linind]+(xplus[k]-avgxs[k])*(yplus[k]-avgys[k]);
        linind = linear_index(yplus[k],xminus[k],dimIi);
        predicted_mask[linind]= predicted_mask[linind]+(xplus[k]-avgxs[k])*(avgys[k]-yminus[k]);
        linind = linear_index(yminus[k],xplus[k],dimIi);
        predicted_mask[linind]= predicted_mask[linind]+(avgxs[k]-xminus[k])*(yplus[k]-avgys[k]);
    }    
}
#endif
    