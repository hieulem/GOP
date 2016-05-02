#!/bin/sh

SGE_TASK_NUM=$1
cd /nfs/bigeye/hieule/GOP/GOP/results/
matlab -nodisplay -r "fevseg(${SGE_TASK_ID}); exit;"

exit 0;

