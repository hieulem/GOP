#!/bin/sh

SGE_TASK_NUM=$1
cd /nfs/bigeye/hieule/GOP/GOP/code/computeflow
/usr/local/MATLAB/R2015b/bin/matlab -nodisplay -r "computeflow_vbs(${SGE_TASK_ID}); exit;" -logfile "computeflow_vbs_${SGE_TASK_ID}.txt"

exit 0;

