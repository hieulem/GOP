#!/bin/sh

SGE_TASK_NUM=$1
cd /nfs/bigeye/hieule/GOP/GOP/results/
matlab -nodisplay -r "fchen(${SGE_TASK_ID},50,9,5,5,255,1); exit;"

exit 0;

