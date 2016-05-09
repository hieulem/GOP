#!/bin/sh
JOB_NUM=64
JOB_PARALLEL=20
JOB_MEM=30G
rm co.txt
rm ce.txt
qsub -l h=!detection -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./co.txt -e ./ce.txt ./chen.sh ${JOB_NUM}

exit 0;

