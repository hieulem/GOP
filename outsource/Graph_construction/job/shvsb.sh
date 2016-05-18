#!/bin/sh
JOB_NUM=60
JOB_PARALLEL=30
JOB_MEM=30G
rm vsbout2.txt vsberr2.txt
qsub -cwd -t 20-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -m ea -o ./vsbout2.txt -e ./vsberr2.txt ./vsbjob.sh ${JOB_NUM}

exit 0;

