#!/bin/sh
JOB_NUM=14
JOB_PARALLEL=14
JOB_MEM=5G
rm ev.out
rm ev.err
qsub -cwd -t 1-${JOB_NUM} -tc ${JOB_PARALLEL} -l mem_free=${JOB_MEM} -o ./ev.out -e ./ev.err ./evsegjob.sh 
${JOB_NUM} 

exit 0;

