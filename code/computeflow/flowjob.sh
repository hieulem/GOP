#!/bin/sh

SGE_TASK_ID=$1
cd /nfs/bigeye/hieule/GOP/GOP/code/computeflow
/usr/local/MATLAB/R2015b/bin/matlab -nodisplay -r "computeflow_vbs(${SGE_TASK_ID}); exit;" -logfile "vbs_${SGE_TASK_ID}.txt"

exit 0;

