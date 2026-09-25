#!/bin/bash

#SBATCH --job-name GPUCheck
#SBATCH --partition=gpu1
#SBATCH --time=00:10:00
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --gres=gpu:1
#SBATCH --output=%x.%J.out
#SBATCH --error=%x.%J.err

echo "Starting at $(date)"
echo "Running on $SLURM_NODELIST"

nvidia-smi --query-gpu=name,memory.total --format=csv

/shared/workshops/basics/venv/bin/python - <<'PY'
import time
import torch

x = torch.randn(8192, 8192, device="cuda")
torch.cuda.synchronize()
start = time.time()
for _ in range(20):
    y = x @ x
torch.cuda.synchronize()
elapsed = time.time() - start
print(f"{torch.cuda.get_device_name()}: 20 matmuls of 8192x8192 in {elapsed:.2f} s")
print(f"about {20 * 2 * 8192**3 / elapsed / 1e12:.1f} TFLOPS")
PY

echo "Finished at $(date)"
