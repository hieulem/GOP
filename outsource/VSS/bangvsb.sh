#!/bin/sh
JOB_NUM=10
JOB_PARALLEL=2
JOB_MEM=50G

qsub -l h=bigbang -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./bang.txt -e ./bangerr.txt ./vsbjob.sh
${JOB_NUM}

exit 0;

