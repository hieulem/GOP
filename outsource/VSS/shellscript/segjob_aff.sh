#!/bin/sh

SGE_TASK_NUM=$1
cd /nfs/bigeye/hieule/GOP/GOP/outsource/VSS/
matlab -nodisplay -r "segment_video_segtrack_withnewaff(${SGE_TASK_ID}); exit;" -logfile "saf${SGE_TASK_ID}.txt"

exit 0;

