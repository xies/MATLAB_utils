#!/bin/sh

# SGE job script for sumbitting matlab jobs to an SGE cluster queue.
# This is submitted to the queue by the job.sh script. It simply runs
#  matlab with the correct arguments.
# By David Black-Schaffer, June 2007.
# Permission to use and modify this script is granted.
# I am not responsible for any errors in this script, so be forewarned!


#$ -j n
# Modify these to put the stdout and stderr files in the right place for your system.
#$ -o ~/job-nobackup.$JOB_ID.$TASK_ID.out
#$ -e ~/job-nobackup.$JOB_ID.$TASK_ID.err
#$ -cwd

echo "Starting job: $SGE_TASK_ID"

# Modify this to use the path to matlab for your system
/cad/mathworks/matlab6.5/bin/matlab -nojvm -nodisplay -r matlab_job 

echo "Done with job: $SGE_TASK_ID"