#! /bin/sh

# Bash script for sumbitting matlab jobs to an SGE cluster queue.
# This is the script you run from the command line to submit the jobs.
# By David Black-Schaffer, June 2007.
# Permission to use and modify this script is granted.
# I am not responsible for any errors in this script, so be forewarned!

# Modify this to set the number of jobs you want to run
qsub -t 1-2 job.sh
