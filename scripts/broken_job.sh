#!/bin/bash

#SBATCH --job-name BrokenJob
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --mem=50MB
#SBATCH --time=00:05:00
#SBATCH --partition=short
#SBATCH --error=brokenjob.%J.err
#SBATCH --output=brokenjob.%J.out

echo "Starting at $(date)"
echo "Running on $SLURM_NODELIST"

python3 -c "import torch; print(torch.__version__)"

echo "Finished at $(date)"
