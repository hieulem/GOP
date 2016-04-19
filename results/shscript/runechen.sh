#!/bin/sh
JOB_NUM=8
JOB_PARALLEL=8
JOB_MEM=5G

qsub -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} ./echenjob.sh
${JOB_NUM}

exit 0;

