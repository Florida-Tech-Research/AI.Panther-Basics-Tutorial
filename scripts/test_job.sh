#!/bin/bash

#SBATCH --job-name TestJob
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --mem=50MB
#SBATCH --time=00:15:00
#SBATCH --partition=short
#SBATCH --error=testjob.%J.err
#SBATCH --output=testjob.%J.out

module load mpich

echo "Starting at $(date)"
echo "Running on hosts: $SLURM_NODELIST"
echo "Running on $SLURM_NNODES nodes."
echo "Running on $SLURM_NPROCS processors."
echo "Current working directory is $(pwd)"

sleep 60
