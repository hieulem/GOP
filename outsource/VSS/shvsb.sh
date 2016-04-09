#!/bin/sh
JOB_NUM=60
JOB_PARALLEL=30
JOB_MEM=10G

qsub -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./vsbout.txt -e ./vsberr.txt ./vsbjob.sh
${JOB_NUM}

exit 0;

