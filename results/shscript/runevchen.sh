#!/bin/sh
JOB_NUM=256
JOB_PARALLEL=20
JOB_MEM=5G
rm evchen.o
rm evchen.e
qsub -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -o ./evchen.o -e ./evchen.e ./evchenjob.sh
${JOB_NUM}

exit 0;

