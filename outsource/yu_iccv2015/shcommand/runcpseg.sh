#!/bin/sh
JOB_NUM=224
JOB_PARALLEL=20
JOB_MEM=30G
echo "BASELINE"
rm re.o
rm re.e
qsub -l h=!detection -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./re.o -e ./re.e ./segjob.sh ${JOB_NUM}

exit 0;

