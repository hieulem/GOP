#!/bin/sh
JOB_NUM=12
JOB_PARALLEL=1
JOB_MEM=30G

qsub -l h="bigbrain|bigbang" -cwd -t 12-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./segout.txt -e ./segerr.txt ./segjob.sh
${JOB_NUM}

exit 0;

