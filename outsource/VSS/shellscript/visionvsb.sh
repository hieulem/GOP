#!/bin/sh
JOB_NUM=35
JOB_PARALLEL=1
JOB_MEM=50G

qsub -l h=bigvision -cwd -t 31-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./vision.txt -e ./visionerr.txt ./vsbjob.sh
${JOB_NUM}

exit 0;

