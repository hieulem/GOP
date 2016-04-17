#!/bin/sh
JOB_NUM=20
JOB_PARALLEL=1
JOB_MEM=50G

qsub -l h=bigbrain -cwd -t 16-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./brain.txt -e ./brainerr.txt ./vsbjob.sh
${JOB_NUM}

exit 0;

