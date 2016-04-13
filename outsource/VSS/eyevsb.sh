#!/bin/sh
JOB_NUM=30
JOB_PARALLEL=1
JOB_MEM=50G

qsub -l h=bigeye -cwd -t 21-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./eye.txt -e ./eyeerr.txt ./vsbjob.sh
${JOB_NUM}

exit 0;

