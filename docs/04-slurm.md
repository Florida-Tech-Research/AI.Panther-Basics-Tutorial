# 4. Slurm

**Slurm** schedules jobs onto AI.Panther's compute nodes: you submit from the login node, the job
waits in a queue, and Slurm runs it when CPUs, GPUs and memory are free. Open OnDemand
interactive apps are Slurm jobs too.

## 4.1 Monitoring the cluster

Run these in the Open OnDemand shell:

```bash
squeue                   # Running and queued jobs
sinfo                    # Partitions and node states (idle, mix, alloc, drain)
sinfo -N -l              # Per-node CPUs, memory and state
sinfo -o "%P %G %D"      # GPU types per partition
```

`mix` means part of the node is in use.

In Open OnDemand, **Jobs > Active Jobs** lists jobs (filter *Your Jobs* / *All Jobs*), and
**Clusters** has system status pages.

## 4.2 Partitions

| Partition | Max Compute Time | Nodes | Hardware |
|---|---|---|---|
| `short` | 45 minutes | 16 | CPU only |
| `med` | 4 hours | 16 | CPU only |
| `long` | 7 days | 16 | CPU only |
| `gpu1` | 7 days | 4 | A100 40GB, 4 per node |
| `gpu2` | 7 days | 4 | A100 40GB, 4 per node |
| `h200` | 7 days | 2 | H200, 8 per node |
| `h200_mig` | 7 days | 2 | H200 split into 35GB slices |
| `vdi-short` | 1 hour | 3 | L40S split into 12GB slices, 8 per node |
| `vdi-med` | 8 hours | 3 | Same nodes as `vdi-short` |
| `vdi-long` | 7 days | 3 | Same nodes as `vdi-short` |

`short`, `med` and `long` are the same 16 CPU nodes with different time limits. The `vdi-*`
partitions are the VDI nodes used by Open OnDemand apps.

A job asking for more time than its partition allows stays pending with reason
`PartitionTimeLimit`. Check current limits with:

```bash
sinfo -o "%P %l %D %G"
```

## 4.3 Before you submit

- **Batch job:** a script Slurm runs unattended. Most work.
- **Interactive job:** a shell on a compute node. Testing and debugging.

Decide CPU or GPU, how long, and which partition. Profiling helps:
[Python Profiler](https://docs.python.org/3/library/profile.html),
[NVIDIA Nsight Systems](https://developer.nvidia.com/nsight-systems).

- No GPU library, no GPU: use `short`, `med` or `long`.
- Ask for a bit more time than you expect. Jobs are killed at the limit.
- Asking for much more than you need means a longer wait.

## 4.4 Job scripts & directives

A job script is a shell script with `#SBATCH` directives at the top.

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

> **Important:** Unless your code uses MPI or DDP, set `--ntasks` to `1`.

`%J` is the job ID and `%x` the job name.

## 4.5 Try it: your first batch job

[`scripts/test_job.sh`](../scripts/test_job.sh):

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

```bash
cd ~/AI.Panther-Basics-Tutorial
sbatch scripts/test_job.sh
```

Output files are written to the directory you submitted from.

## 4.6 Viewing and cancelling jobs

```bash
squeue --me                  # Your queued and running jobs
scancel <jobid>              # Cancel one job
scancel --me                 # Cancel all of your jobs
sacct -j <jobid>             # State and exit code, including finished jobs
```

In `squeue`, `ST` is the state: `PD` pending, `R` running, `CG` completing. Pending jobs show a
reason such as `Resources` or `Priority`. Finished jobs leave `squeue`; use `sacct`.

```bash
squeue --me
cat testjob.<jobid>.out
```

**Jobs > Active Jobs** in Open OnDemand shows the same list, with a delete button to cancel.

## 4.7 Accessing compute nodes interactively

```bash
srun -p short --ntasks=1 --cpus-per-task=2 --mem=4G --time=00:30:00 --pty bash -i
hostname
nproc
exit
```

The prompt changes to the compute node's name. `exit` or closing the tab ends the job. Long work
belongs in a batch job.

With a GPU:

```bash
srun -p gpu1 --ntasks=1 --gres=gpu:1 --mem=16G --time=00:30:00 --pty bash -i
nvidia-smi
exit
```

## 4.8 When a job goes wrong

[`scripts/broken_job.sh`](../scripts/broken_job.sh) tries to import PyTorch:

```bash
sbatch scripts/broken_job.sh
sacct -j <jobid> --format=JobID,JobName,State,ExitCode,Elapsed
```

```text
73919         BrokenJob  COMPLETED      0:0   00:00:01
```

The `.out` file looks fine too. The error is in the `.err` file:

```bash
cat brokenjob.<jobid>.err
```

```text
Traceback (most recent call last):
  File "<string>", line 1, in <module>
ModuleNotFoundError: No module named 'torch'
```

- `sacct` reports the exit code of the script, not of each command. Add `set -e` to stop at the
  first error.
- Check the `.err` file.
- A batch job starts with no modules loaded. In an interactive job
  ([Section 4.7](#47-accessing-compute-nodes-interactively)), compare:

```bash
which python3
module load python
which python3
```

Bare `python3` is the copy bundled with STAR-CCM+ (Python 3.6, no torch). Load a module or
activate your environment in the job script.

## 4.9 Job Composer and templates

**Jobs > Job Composer** creates, edits and submits batch jobs in the browser. Each job gets its own
directory with a `main_job.sh`.

### Try it

1. **New Job > From Default Template**.
2. Under **Submit Script**, **Open Editor**. Change the partition to `#SBATCH --partition=short`
   and save.
3. Select the job and click **Submit**.
4. Open the `.out` file under **Folder Contents**.

**Stop** cancels a job; **Delete** removes it and its directory.

### Templates

A template is a job script plus a `manifest.yml`. **New Job > From Template** makes a fresh copy.
Your own templates live in `~/ondemand/data/sys/myjobs/templates`. Install the GPU check template
from this repo:

```bash
mkdir -p ~/ondemand/data/sys/myjobs/templates
cp -r ~/AI.Panther-Basics-Tutorial/job-templates/gpu-check ~/ondemand/data/sys/myjobs/templates/
```

Reload the page, then **New Job > From Template > GPU check > Create New Job**, and submit. It
runs a PyTorch matrix multiply on an A100.

To save any existing job as a template, select it and click **Create Template**.

## 4.10 Your Jupyter session is a Slurm job

```bash
squeue --me
```

The job on `vdi-med` is the Jupyter session from
[Section 1.6](01-open-ondemand.md#16-try-it-launch-your-jupyter-session). Open OnDemand turned the
form into `#SBATCH` directives and submitted it. `scancel` on its ID ends the session, the same as
**Delete**.

## Reference

- KB Article: [How to submit and run jobs on AI.Panther](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=2107)

---

**← Previous** [Section 3: Linux CLI](03-linux-cli.md) | **Next →** [Section 5: Virtual Environments](05-virtual-environments.md)
