#!/bin/sh

SGE_TASK_ID=$1
cd /nfs/bigeye/hieule/GOP/GOP/code/outsource/VSS/
matlab -nodisplay -r "segment_video(${SGE_TASK_ID}); exit;" -logfile "seg_${SGE_TASK_ID}.txt"

exit 0;

