#!/bin/sh

SGE_TASK_NUM=$1
cd /nfs/bigeye/hieule/GOP/GOP/code/computeflow
matlab -nodisplay -r "computeflow_chen(${SGE_TASK_ID}); exit;" -logfile "chen_${SGE_TASK_ID}.txt"

exit 0;

