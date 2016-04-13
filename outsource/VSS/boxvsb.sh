#!/bin/sh
JOB_NUM=15
JOB_PARALLEL=1
JOB_MEM=50G

qsub -l h=bigbox -cwd -t 11-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./box.txt -e ./boxerr.txt ./vsbjob.sh
${JOB_NUM}

exit 0;

