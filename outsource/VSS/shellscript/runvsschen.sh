#!/bin/sh
JOB_NUM=8
JOB_PARALLEL=8
JOB_MEM=30G

qsub -l h=!detection -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./co.txt -e ./ce.txt ./chen.sh ${JOB_NUM}

exit 0;

