#!/bin/sh

JOB_NUM=60
JOB_PARALLEL=5
JOB_MEM=30G

qsub -l nodes=bigeye+bigbrain -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./flowcompute.out -e ./flowcompute.err ./flowjop.sh
${JOB_NUM}

exit 0;

