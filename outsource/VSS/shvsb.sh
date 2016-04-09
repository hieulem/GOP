#!/bin/sh
JOB_NUM=60
JOB_PARALLEL=30
JOB_MEM=30G

qsub -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./vbsout.txt -e ./vbserr.txt ./vbsjob.sh
${JOB_NUM}

exit 0;

