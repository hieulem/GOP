#!/bin/sh

SGE_TASK_NUM=$1
cd /nfs/bigeye/hieule/GOP/GOP/results/
matlab -nodisplay -r "fevchen(${SGE_TASK_ID}); exit;" -logfile "$SGE_TASK_ID}.txt"

exit 0;

