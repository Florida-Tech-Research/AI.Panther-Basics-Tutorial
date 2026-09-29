# 2. Cluster Architecture & Storage

AI.Panther is a set of nodes managed by the Slurm scheduler, sharing several kinds of storage.

![AI.Panther architecture overview](../images/Simple%20Access%20Diagram.png)

## 2.1 How access works

- Off campus: VPN first, then <https://ood.fit.edu>. On campus: open it directly.
- The Open OnDemand shell runs on the **Login Node**. Slurm sends jobs to the compute nodes.
- SSH to `ai-panther.fit.edu` reaches the same login node, but is not needed here.

> **Important:** The login node is for light tasks: editing files, submitting jobs. **Running
> heavy processes on the login node is prohibited.**

## 2.2 Compute nodes

| Node Group | Nodes | Hardware | Used for |
|---|---|---|---|
| CPU Nodes 01-16 | 16 | 96 cores, 385 GB RAM | CPU batch jobs |
| GPU Nodes 01-08 | 8 | 4x A100 40GB each | GPU batch jobs |
| GPU Nodes 09-10 | 2 | 8x H200 each | Large GPU batch jobs |
| GPU Nodes 11-12 | 2 | H200 split into 35 GB slices | Smaller GPU batch jobs |
| VDI Nodes 01-03 | 3 | L40S split into 12 GB slices, 8 per node | Open OnDemand interactive apps |

Your Jupyter session from [Section 1.6](01-open-ondemand.md#16-try-it-launch-your-jupyter-session)
runs on a VDI node.

## 2.3 Try it: look around

In the Open OnDemand shell:

```bash
sinfo -s
ls /shared
ls $AIP_DATASETS
du -sh ~
```

In `sinfo -s`, `NODES(A/I/O/T)` is allocated / idle / other / total. The `vdi-*` rows are the VDI
nodes.

## 2.4 Storage types

| Storage | Path | Mount Type | Accessible From |
|---|---|---|---|
| User Home | `/home1` | NFS Mount | Login Node, all compute nodes |
| Project Storage | `/shared/projects` | LFS Mount (DDN Servers) | Login Node, all compute nodes |
| Shared Scratch | `/shared/scratch` | LFS Mount (DDN Servers) | Login Node, all compute nodes |
| Datasets | `/shared/datasets` | LFS Mount (DDN Servers) | Login Node, all compute nodes |
| Local Scratch | `/localscratch` | Local Mount | GPU Nodes 09-12 (H200) only |
| Archive | `/archive` | NFS Mount | Login Node only |

## 2.5 Home directory: `/home1/username`

Code, job scripts, config files, small environments. Persistent, **100 GB** per user. Not for
datasets, checkpoints or large outputs.

## 2.6 Scratch

Both kinds are temporary and **auto-purged**. Copy anything you need to keep.

- **Shared scratch, `/shared/scratch/username`:** visible from every node. Job outputs,
  intermediate files, large caches.
- **Local scratch, `/localscratch`:** a disk inside each H200 node (gpu09-12), visible only to jobs
  on that node, and the fastest storage. Copy data in at the start of a job and results out
  before it ends.

## 2.7 Project storage: `/shared/projects`

Shared storage for a research group. Requires a request and approval; time-limited.

## 2.8 Archive: `/archive`

Long-term storage for finished data you need to keep. Mounted **only on the login node**, so jobs
cannot read it.

Check whether you have a directory:

```bash
ls -d /archive/$USER
```

If not, request one through a ticket.

## 2.9 Datasets: `/shared/datasets`

Read-only shared copies of common datasets. `$AIP_DATASETS` points at the root in every shell.
Each dataset has a `README` and a module that sets path variables:

```bash
module avail datasets
module load datasets/cifar-10
echo $CIFAR10_DATA
```

Use the variables rather than hard-coded `/shared/datasets/...` paths.

| Dataset | Access |
|---|---|
| `cifar-10`, `cifar-100` | Open |
| `culane`, `curvelanes` | Open; non-commercial use only, no copying off the cluster (see `TERMS.txt`) |
| `imagenet-1k` | Gated; agree to the terms in a ticket (see its `README`) |

Request missing datasets through a ticket.

## 2.10 Which one should I use?

| You have... | Put it in |
|---|---|
| Code, scripts, notebooks | Home |
| A Python environment | Home, or project storage if large or shared |
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
