# 4. Slurm

**Slurm** is the job scheduler that manages access to AI.Panther's compute nodes. It controls who gets access to CPUs, GPUs, and memory, and in what order.

The workflow is:

1. **Prepare** your job on the Login Node
2. **Submit** it to Slurm
3. Slurm **places it in a queue** and runs it on a compute node when resources become available

> **Login Node:** Edit files, monitor jobs, submit jobs.
> **Compute Nodes:** Run your actual workloads (ML training, simulations, etc.).

Everything that uses a compute node goes through Slurm, including the interactive apps in Open
OnDemand. When you launch a Jupyter session, Open OnDemand writes a job script and submits it
for you.

## 4.1 Monitoring the cluster

Before submitting jobs, check what hardware is available and whether nodes are busy. Run these in
the Open OnDemand shell (**Clusters > AI.Panther Shell Access**).

**View running jobs:**

```bash
squeue
```

**View available partitions and node states:**

```bash
sinfo
```

This shows partition names, node availability, and node states (`idle`, `mix`, `alloc`, `drain`).
`mix` means some of the node's cores or GPUs are in use and the rest are free.

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

### In Open OnDemand

The same information is available without a shell:

- **Jobs > Active Jobs** lists queued and running jobs. Switch the filter between *Your Jobs* and
  *All Jobs*, and expand a row to see which node it is on and how long it has been running.
- **Clusters** has system status pages showing how busy each partition is.

## 4.2 Partitions

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
| `vdi-short` | 1 hour | 3 | L40S split into 12GB slices, 8 per node |
| `vdi-med` | 8 hours | 3 | Same nodes as `vdi-short` |
| `vdi-long` | 7 days | 3 | Same nodes as `vdi-short` |

The `short`, `med` and `long` partitions share the same sixteen CPU nodes; the only difference
between them is how long a job is allowed to run. The three `vdi-*` partitions work the same way
over the three vgpu nodes, and those are the partitions Open OnDemand's interactive apps use.

Asking for more time than a partition allows does not fail at submission. The job sits in the
queue forever with reason `PartitionTimeLimit`, which is a confusing way to find out you picked
the wrong one.

You can always check the real limits rather than trusting a table:

```bash
sinfo -o "%P %l %D %G"
```

## 4.3 Before you submit

There are two ways to get work onto a compute node. A **batch job** is a script you hand to Slurm,
which runs it when resources free up, with nobody watching. An **interactive job** gives you a
shell on a compute node so you can type commands there yourself. Most real work is batch; the
interactive route is for testing and debugging.

All the commands in the rest of this section run in the Open OnDemand shell (**Clusters > AI.Panther Shell
Access**), on the login node.

Before submitting, decide what hardware your job needs (CPU vs. GPU), how long it will run, and which partition to use. If possible, profile your application to estimate resource requirements:

- [Python Profiler](https://docs.python.org/3/library/profile.html)
- [NVIDIA Nsight Systems](https://developer.nvidia.com/nsight-systems)

A few rules of thumb:

- If your code never imports a GPU library, it does not need a GPU. Use `short`, `med` or `long`.
- Ask for somewhat more time than you expect. A job that hits its time limit is killed, and
  whatever it had not saved is lost.
- Asking for far more than you need makes you wait longer in the queue, because Slurm has to find
  a bigger hole to fit you into.

## 4.4 Job scripts & directives

A job script is a regular shell script (`.sh`) with Slurm directives at the top. These directives, prefixed with `#SBATCH`, tell Slurm what resources to allocate and what command to run.

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

In `--output` and `--error`, `%J` is replaced by the job ID and `%x` by the job name, so every run
writes to its own files.

## 4.5 Try it: your first batch job

A ready-to-use copy of this script is in the repository you cloned in [Section 1](01-open-ondemand.md),
at [`scripts/test_job.sh`](../scripts/test_job.sh). Open it in the file browser to read it, or
print it in the shell:

```bash
cd ~/AI.Panther-Basics-Tutorial
cat scripts/test_job.sh
```

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

Submit it:

```bash
sbatch scripts/test_job.sh
```

Slurm replies with the job ID, for example `Submitted batch job 79109`. The output files are
written to the directory you submitted from, so `testjob.79109.out` appears in
`~/AI.Panther-Basics-Tutorial` once the job starts.

## 4.6 Viewing and cancelling jobs

```bash
squeue --me                  # Your queued and running jobs
scancel <jobid>              # Cancel one job
scancel --me                 # Cancel all of your jobs
sacct -j <jobid>             # State and exit code of a job, including finished ones
```

`squeue` only shows jobs that have not finished yet. Once a job ends it drops out of `squeue`,
and `sacct` is how you find out whether it worked.

The `ST` column in `squeue` is the job state: `PD` is pending (waiting in the queue), `R` is
running, `CG` is completing. For a pending job, the last column gives the reason it is waiting,
such as `Resources` (nothing free yet) or `Priority` (someone else is ahead of you).

Watch your test job, then read its output once it has finished:

```bash
squeue --me
cat testjob.<jobid>.out
```

In Open OnDemand, **Jobs > Active Jobs** shows the same list. Expand a row to see the details, and
use the delete (trash can) button on your own jobs to cancel them.

## 4.7 Accessing compute nodes interactively

`srun --pty bash` asks Slurm for resources exactly as `sbatch` does, but instead of running a
script it opens a shell on the compute node it is given:

```bash
srun -p short --ntasks=1 --cpus-per-task=2 --mem=4G --time=00:30:00 --pty bash -i
```

Your prompt changes from the login node's name to a compute node's name, such as `node07`. Check
what you were given, then leave:

```bash
hostname
nproc
exit
```

Leaving the shell ends the job and gives the resources back. So does closing the browser tab, which
means an interactive job is not the place for anything that has to run for hours: use a batch job
for that.

For a GPU, add `--gres` and pick a GPU partition:

```bash
srun -p gpu1 --ntasks=1 --gres=gpu:1 --mem=16G --time=00:30:00 --pty bash -i
nvidia-smi
exit
```

## 4.8 When a job goes wrong

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

The third is the actual cause. Run this on a compute node, in an interactive job from
[Section 4.7](#47-accessing-compute-nodes-interactively):

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

## 4.9 Job Composer and templates

**Jobs > Job Composer** in Open OnDemand is a web front end for batch jobs. Every job you create
there gets its own directory with a `main_job.sh`, which you edit in the browser and submit with
a button.

### Try it: submit a job from the composer

1. Open **Jobs > Job Composer**. If it offers a tour, you can skip it.
2. Click **New Job > From Default Template**. A new job appears at the top of
   the list, with the default job script copied into its own directory.
3. In the panel on the right, under **Submit Script**, click **Open Editor**. The default script
   runs on a `vdi` partition, which is meant for interactive apps. Change the
   partition line to `#SBATCH --partition=short`, and save.
4. Back in the Job Composer tab, select the job and click **Submit**. Its status changes to
   *Queued*, then *Running*, then *Completed*.
5. Under **Folder Contents**, click the `.out` file to read the output.

**Stop** cancels a running job, and **Delete** removes the job and its directory.

### Templates

A template is a directory containing a job script and a short `manifest.yml` describing it. The
composer offers every template it finds under **New Job > From Template**, and creates a fresh
copy of the directory each time you use one.

This repository includes one, [`job-templates/gpu-check`](../job-templates/gpu-check), which asks
for an A100, prints which GPU it got, and times a matrix multiply with PyTorch. The composer looks
for your own templates in `~/ondemand/data/sys/myjobs/templates`, so copy it there:

```bash
mkdir -p ~/ondemand/data/sys/myjobs/templates
cp -r ~/AI.Panther-Basics-Tutorial/job-templates/gpu-check ~/ondemand/data/sys/myjobs/templates/
```

Reload the Job Composer page, choose **New Job > From Template**, pick **GPU check**, and click
**Create New Job**. Submit it as before, and read the `.out` file when it completes.

You can also turn any job you have already written into a template: select it in the composer
and choose **Create Template**. That is the easiest way to keep a job script you reuse, with the
directives already filled in.

## 4.10 Your Jupyter session is a Slurm job

Run this one more time:

```bash
squeue --me
```

Besides anything you submitted, there is a job running on a `vdi-med` partition on one of the
vgpu nodes. That is the Jupyter session you launched in [Section 1.6](01-open-ondemand.md#16-try-it-launch-your-jupyter-session-now). Open
OnDemand wrote a job script from the form you filled in and submitted it with `sbatch`, exactly as
you did by hand above. Its time limit, memory and GPU are the `#SBATCH` directives it was given,
and `scancel` on that job ID would end the session, the same as pressing **Delete** in the portal.

You will connect to it in [Section 6](06-jupyterlab-detection.md), after setting up a Python
environment for it to use.

## Reference

- KB Article: [How to submit and run jobs on AI.Panther](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=2107), which covers partitions, directives, and submission examples

---

**← Previous** [Section 3: Linux CLI](03-linux-cli.md) | **Next →** [Section 5: Virtual Environments](05-virtual-environments.md)
