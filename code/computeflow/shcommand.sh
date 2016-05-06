#!/bin/sh
JOB_NUM=3
JOB_PARALLEL=3
JOB_MEM=20G

qsub -cwd -t 3-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./flowcompute.out -e ./flowcompute.err ./flowjob.sh
${JOB_NUM}

exit 0;

