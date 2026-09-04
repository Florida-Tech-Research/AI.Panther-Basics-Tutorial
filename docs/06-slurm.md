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

| Partition | Max Compute Time | Nodes | Hardware |
|---|---|---|---|
| `short` | 45 minutes | 16 | CPU only |
| `med` | 4 hours | 16 | CPU only |
| `long` | 7 days | 16 | CPU only |
| `gpu1` | 7 days | 4 | A100 40GB, 4 per node |
| `gpu2` | 7 days | 4 | A100 40GB, 4 per node |
| `h200` | 7 days | 2 | H200, 8 per node |
| `h200_mig` | 7 days | 2 | H200 split into 35GB slices |

The `short`, `med` and `long` partitions share the same sixteen CPU nodes; the only difference
between them is how long a job is allowed to run. Asking for more time than a partition allows
does not fail at submission. The job sits in the queue forever with reason `PartitionTimeLimit`,
which is a confusing way to find out you picked the wrong one.

You can always check the real limits rather than trusting a table:

```bash
sinfo -o "%P %l %D %G"
```

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

## 6.7 When a job goes wrong

Most of the time you spend with Slurm will be working out why a job did not do what you expected.
It is worth seeing that happen once on purpose, in a case where the answer is known.

A ready-made example lives at [`scripts/broken_job.sh`](../scripts/broken_job.sh). It is the same
shape as the job above, but it tries to import PyTorch:

```bash
sbatch scripts/broken_job.sh
```

Once it finishes, check whether Slurm thought it worked:

```bash
sacct -j <jobid> --format=JobID,JobName,State,ExitCode,Elapsed
```

```text
73919         BrokenJob  COMPLETED      0:0   00:00:01
```

Slurm says `COMPLETED` with exit code `0:0`. Now read the output file:

```bash
cat brokenjob.<jobid>.out
```

```text
Starting at Fri Sep  4 16:52:35 EDT 2026
Running on node01
Finished at Fri Sep  4 16:52:35 EDT 2026
```

That also looks fine. The job started, ran, and finished. The actual problem is in the error file,
which is the one people forget to open:

```bash
cat brokenjob.<jobid>.err
```

```text
Traceback (most recent call last):
  File "<string>", line 1, in <module>
ModuleNotFoundError: No module named 'torch'
```

Three things are worth taking from this.

The first is that a job can report success and still have done nothing useful. `sacct` reports the
exit code of the *script*, and a failing command partway through a script does not stop the rest of
it from running. If you want a job to stop at the first error, put `set -e` near the top.

The second is that `--output` and `--error` are different files, and the interesting one is usually
`--error`. If both go to the same place you will see everything interleaved, which is sometimes
easier.

The third is the actual cause. Run this on a compute node:

```bash
which python3
python3 --version
```

```text
/usr/local/siemens/16.02.008-R8/STAR-CCM+16.02.008-R8/star/bin/python3
Python 3.6.1
```

Bare `python3` on AI.Panther is the copy bundled inside STAR-CCM+, a 2017-era Python 3.6 with
almost nothing installed in it. That is what your job used. Loading a module, or activating a
virtual environment, puts a real Python ahead of it on your `PATH`:

```bash
module load python
which python3
```

This is the single most common reason a job that works when you type it by hand fails when you
submit it. Your interactive shell has modules loaded; a fresh batch job does not.

## Reference

- KB Article: [How to submit and run jobs on AI.Panther](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=2107) — covers partitions, directives, and submission examples

---

**← Previous** [Section 5: VS Code SSH Setup](05-vscode-ssh.md) | **Next →** [Section 7: Virtual Environments](07-virtual-environments.md)
