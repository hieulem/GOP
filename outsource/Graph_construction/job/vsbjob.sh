#!/bin/sh

SGE_TASK_NUM=$1
cd /nfs/bigeye/hieule/GOP/GOP/outsource/Graph_construction/
matlab -nodisplay -r "segment_video_vsb100(${SGE_TASK_ID}); exit;" -logfile "./log/${SGE_TASK_ID}.txt"

exit 0;

