#!/bin/sh
JOB_NUM=14
JOB_PARALLEL=14
JOB_MEM=30G

qsub -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./sout.txt -e ./serr.txt ./segjob_aff.sh
${JOB_NUM}

exit 0;

