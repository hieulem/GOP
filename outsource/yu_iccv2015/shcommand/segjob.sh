#!/bin/sh

SGE_TASK_NUM=$1
cd /nfs/bigeye/hieule/GOP/GOP/outsource/yu_iccv2015/pgp_code/
matlab -nodisplay -r "runallseg(${SGE_TASK_ID}); exit;" -logfile "seg_${SGE_TASK_ID}.txt"

exit 0;

