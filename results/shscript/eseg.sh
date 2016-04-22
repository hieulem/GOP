#!/bin/sh

SGE_TASK_NUM=$1
cd /nfs/bigeye/hieule/GOP/GOP/results/
matlab -nodisplay -r "fseg(${SGE_TASK_ID},50,9,13,5,255,0); exit;" -logfile "eseg_${SGE_TASK_ID}.txt"

exit 0;

