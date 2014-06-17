% Matlab script for running matlab jobs on an SGE cluster queue.
% This .m file is run on each of the nodes by the job.sh script 
%  and is responsible for finding out the task ID and running the
%  correct calculations.
% By David Black-Schaffer, June 2007.
% Permission to use and modify this script is granted.
% I am not responsible for any errors in this script, so be forewarned!

% This script runs the jobs
disp('Running mmatlab_job.m script...')

% Get the Task ID of this job
job_id_string = getenv('SGE_TASK_ID')

% If it is not defined, then we are testing.
if job_id_string == ''
    job_id = -1;
else
    job_id = str2double(job_id_string);
end

% Insert the matlab code you want here. Usually this will figure out
% what to do based on the job_id then start that processing.

% If we have a job ID, then exit so matlab does not sit at the command
% prompt forever.
if job_id ~= -1
    exit
end