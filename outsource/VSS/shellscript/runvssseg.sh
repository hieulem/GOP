#!/bin/sh
JOB_NUM=14
JOB_PARALLEL=14
JOB_MEM=30G

qsub -l h=!detection -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./run6.txt -e ./serr.txt ./segtrackvss.sh
${JOB_NUM}

exit 0;

