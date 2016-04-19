#!/bin/sh
JOB_NUM=14
JOB_PARALLEL=14
JOB_MEM=5G

qsub -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} ./eseg.sh
${JOB_NUM}

exit 0;

