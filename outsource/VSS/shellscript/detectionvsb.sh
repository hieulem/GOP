#!/bin/sh
JOB_NUM=40
JOB_PARALLEL=1
JOB_MEM=50G

qsub -l h=detection -cwd -t 36-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./detection.txt -e ./detectionerr.txt ./vsbjob.sh
${JOB_NUM}

exit 0;

