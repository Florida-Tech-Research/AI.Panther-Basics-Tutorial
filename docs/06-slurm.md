# 6. Slurm — Job Scripts, Submitting & Monitoring Jobs

**Slurm** is the job scheduler that manages access to AI.Panther's compute nodes. It controls who gets access to CPUs, GPUs, and memory, and in what order.

The workflow is:

1. **Prepare** your job on the Login Node
2. **Submit** it to Slurm
3. Slurm **places it in a queue** and runs it on a compute node when resources become available

> **Login Node:** Edit files, monitor jobs, submit jobs.
> **Compute Nodes:** Run your actual workloads (ML training, simulations, etc.).

## 6.1 Monitoring the cluster

Before submitting jobs, check what hardware is available and whether nodes are busy.

**View running jobs:**

```bash
squeue
```

**View available partitions and node states:**

```bash
sinfo
```

This shows partition names, node availability, and node states (`idle`, `mix`, `drain`).

**View detailed node info:**

```bash
sinfo -N -l
```

This displays individual node names, CPU counts, memory, and state.

**View GPU availability:**

```bash
sinfo -o "%P %G %D"
```

Use this to determine which partitions have GPUs, what GPU types exist, and how many nodes are available.

## 6.2 Partitions

AI.Panther offers several partitions, each with different time limits and node counts. Choose the partition that fits your workload:

| Partition Name | Max Compute Time | Max Nodes |
|---|---|---|
| `short` | 45 minutes | 16 |
| `med` | 4 hours | 16 |
| `long` | 7 days | 16 |
| `eternity` | Infinite | 16 |
| `gpu1` | Infinite | 4 |
| `gpu2` | Infinite | 4 |
| `h200` | Infinite | 4 |

> **Reference:** KB Article: AI.Panther Partitions

## 6.3 Job scripts & directives

A job script is a regular shell script (`.sh`) with Slurm directives at the top. These directives, prefixed with `#SBATCH`, tell Slurm what resources to allocate and what command to run.

### Common directives

| Directive | Purpose |
|---|---|
| `--job-name` | Name for the job |
| `--partition` | Which partition to submit to |
| `--nodes` | Number of nodes |
| `--ntasks` | Number of tasks (use `1` unless using MPI/DDP) |
| `--cpus-per-task` | CPUs per task |
| `--mem` | Memory allocation (e.g. `50GB`) |
| `--time` | Max wall time (`HH:MM:SS`) |
| `--gres` | Generic resources (e.g. `gpu:1`) |
| `--output` | Path for stdout (e.g. `job.%J.out`) |
| `--error` | Path for stderr (e.g. `job.%J.err`) |

> **Important:** If you did not explicitly design your code to run multiple processes (MPI / DDP), set `--ntasks` to `1`.

## 6.4 Submitting & managing jobs

```bash
sbatch job.sh              # Submit a job
squeue --me            # View your running jobs
scancel <jobid>            # Cancel a job
```

## 6.5 Before you submit

Before submitting, decide what hardware your job needs (CPU vs. GPU), how long it will run, and which partition to use. If possible, profile your application to estimate resource requirements:

- [Python Profiler](https://docs.python.org/3/library/profile.html)
- [NVIDIA Nsight Systems](https://developer.nvidia.com/nsight-systems)

## 6.6 Try it — your first job

A ready-to-use copy of this script lives at [`scripts/test_job.sh`](../scripts/test_job.sh). You can copy it to the cluster, or recreate it from scratch with the steps below.

Create a test job script:

```bash
nano test_job.sh
```

Type the following into the file:

```bash
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
```

Save and exit (`Ctrl+S`, then `Ctrl+X` in nano). Then submit:

```bash
sbatch test_job.sh
```

Monitor your job:

```bash
squeue --me                  # View your job in the queue
cat testjob.<jobid>.out      # View the output after completion
```

## Reference

- KB Article: Slurm Job Submission Examples

---

**← Previous** [Section 5: VS Code SSH Setup](05-vscode-ssh.md) | **Next →** [Section 7: Virtual Environments](07-virtual-environments.md)
