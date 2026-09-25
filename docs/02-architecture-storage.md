# 2. Cluster Architecture & Storage

AI.Panther is a high-performance computing (HPC) cluster at Florida Tech. It is **not a single
computer**, but a collection of interconnected nodes managed by a job scheduler, sharing several
kinds of storage.

![AI.Panther architecture overview](../images/arch.png)

## 2.1 How access works

- **Off-campus users** connect to the VPN first, then open <https://ood.fit.edu>.
- **On-campus users** open the site directly.
- The Open OnDemand shell puts you on the **Login Node**. From there, **Slurm** dispatches your
  jobs to the compute nodes.

SSH to `ai-panther.fit.edu` still works and lands you on the same login node, if you already
use it. Nothing in this tutorial requires it.

> **Key takeaway:** The Login Node is for **light tasks** (editing files, submitting jobs).
> Compute nodes handle your actual workloads. **Running heavy processes on the Login Node is
> prohibited.**

## 2.2 Compute nodes

| Node Group | Nodes | Hardware | Used for |
|---|---|---|---|
| CPU Nodes 01-16 | 16 | 96 cores, 385 GB RAM | CPU batch jobs |
| GPU Nodes 01-08 | 8 | 4x A100 40GB each | GPU batch jobs |
| GPU Nodes 09-10 | 2 | 8x H200 each | Large GPU batch jobs |
| GPU Nodes 11-12 | 2 | H200 split into 35 GB slices | Smaller GPU batch jobs |
| VDI Nodes vgpu01-03 | 3 | L40S split into 12 GB slices, 8 per node | Open OnDemand interactive apps |

The Jupyter session you launched in [Section 1.6](01-open-ondemand.md#16-try-it-launch-your-jupyter-session-now) is running on one of the
vgpu nodes, on one of the 24 L40S slices shared by everyone.

## 2.3 Try it: see the cluster for yourself

In the Open OnDemand shell, list the partitions and how busy they are:

```bash
sinfo -s
```

Each row is a partition. `NODES(A/I/O/T)` counts nodes that are allocated, idle, other (down or
draining) and the total. The `vdi-*` rows are the vgpu nodes; the other rows map onto the table
above. [Section 4](04-slurm.md) comes back to this.

Now look at the storage described below:

```bash
ls /shared
echo $AIP_DATASETS
ls $AIP_DATASETS
du -sh ~
```

## 2.4 Storage types

AI.Panther has several places to put files, and they behave differently. Picking the wrong one
is the usual way people run out of space or lose data. Where each one is mounted:

| Storage | Path | Mount Type | Accessible From |
|---|---|---|---|
| User Home | `/home1` | NFS Mount | Login Node, all compute nodes |
| Project Storage | `/shared/projects` | LFS Mount (DDN Servers) | Login Node, all compute nodes |
| Shared Scratch | `/shared/scratch` | LFS Mount (DDN Servers) | Login Node, all compute nodes |
| Datasets | `/shared/datasets` | LFS Mount (DDN Servers) | Login Node, all compute nodes |
| Local Scratch | `/localscratch` | Local Mount | GPU Nodes 09-12 (H200) only |
| Archive | `/archive` | NFS Mount | Login Node, CPU nodes |

## 2.5 Home directory: `/home1/username`

Your home directory is where you land when you log in, and where Jupyter starts. Use it for code,
job scripts, config files and small environments.

- Persistent and backed by NFS
- Capped at **100 GB** per user
- Not the place for datasets, model checkpoints or large outputs

## 2.6 Scratch

There are two kinds of scratch space. Both are for temporary, high-churn data, and both are
**auto-purged**, so anything you need to keep has to be copied somewhere else.

**Shared scratch, `/shared/scratch/username`,** is visible from every node. It suits job
outputs, intermediate files, and caches that are too big for your home directory, such as the
container images in [Section 7](07-containers.md).

**Local scratch, `/localscratch`,** is a disk inside each H200 node (gpu09-12). It is only
visible to jobs running on that node and is the fastest storage on the cluster. Copy data there
at the start of a job, work on it, and copy the results back out before the job ends.

## 2.7 Project storage: `/shared/projects`

Shared storage for a research group. A project directory has to be requested and approved, is
shared among the members of that project, and is granted for a limited time.

## 2.8 Archive: `/archive`

Long-term storage for data you are finished working with but need to keep, such as the raw data
behind a published paper. It is on a separate NFS server, mounted on the login node and the CPU
nodes, and is not meant to be read from inside a GPU job.

Not every account has an archive directory:

```bash
ls -d /archive/$USER
```

If that reports `No such file or directory`, request one through a ticket.

## 2.9 Datasets: `/shared/datasets`

Common public datasets are staged once, read-only, so that nobody has to download their own
copy. Every shell has `$AIP_DATASETS` set to the dataset root:

```bash
echo $AIP_DATASETS
ls $AIP_DATASETS
```

Each dataset has a `README` explaining how to read it, and a module that sets path variables for
it:

```bash
module avail datasets
module load datasets/cifar-10
echo $CIFAR10_DATA
```

Use those variables in your code rather than typing `/shared/datasets/...` directly. If the tree
ever moves, the variables follow and hard-coded paths do not.

| Dataset | Access |
|---|---|
| `cifar-10`, `cifar-100` | Open to everyone |
| `culane`, `curvelanes` | Open to read; non-commercial use only, no copying off the cluster (see `TERMS.txt`) |
| `imagenet-1k` | Gated: agree to the terms in a ticket to be added to the access group (see its `README`) |

If a dataset you need is missing, request it through a ticket instead of downloading your own
copy into project storage.

## 2.10 Which one should I use?

| You have... | Put it in |
|---|---|
| Code, scripts, notebooks | Home |
| A Python environment | Home, or project storage if it is large or shared |
| Output from a running job | Shared scratch, then copy what matters to project storage |
| Data your whole group reads | Project storage |
| A standard public dataset | Already in `/shared/datasets` |
| Finished data you must keep | Archive |

## References

- KB Article: [What is the AI.Panther cluster?](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=2831)
- KB Article: [AI.Panther Storage Types](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=20725)
- [Submit a ticket](https://help.fit.edu/TDClient/39/Portal/Requests/Service/8085/Submit-a-Ticket)

---

**← Previous** [Section 1: Open OnDemand](01-open-ondemand.md) | **Next →** [Section 3: Linux CLI](03-linux-cli.md)
