# AI.Panther Basics Tutorial

A hands-on tutorial for getting started on **AI.Panther**, Florida Tech's high-performance computing (HPC) cluster. Follow the sections in order, since each one builds on the last.

## What you'll learn

By the end of this tutorial you will be able to:

- Connect to AI.Panther over SSH (from on- or off-campus)
- Navigate the cluster's file system from the Linux command line
- Move files between your local machine and the cluster
- Edit code on the cluster directly in VS Code
- Submit and monitor jobs through Slurm
- Set up Python virtual environments (venv / Conda)
- Run JupyterLab on a compute node and connect from your browser
- Work out why a job failed, and read the files Slurm leaves behind
- Run a real model on a GPU against a live camera feed

## Tutorial sections

| # | Section | Topics |
|---|---------|--------|
| 1 | [Cluster Architecture & Storage](docs/01-cluster-architecture.md) | Login node, compute nodes, storage paths |
| 2 | [SSH & Connecting](docs/02-ssh-connecting.md) | Logging in, verifying, disconnecting |
| 3 | [Linux CLI](docs/03-linux-cli.md) | Navigation, file sizes, exploring shared storage |
| 4 | [File Transfers](docs/04-file-transfers.md) | `scp`, `rsync`, VS Code drag-and-drop |
| 5 | [VS Code SSH Setup](docs/05-vscode-ssh.md) | Remote-SSH extension, opening your home directory |
| 6 | [Slurm](docs/06-slurm.md) | Partitions, job scripts, submitting, monitoring, debugging |
| 7 | [Virtual Environments](docs/07-virtual-environments.md) | Python `venv`, Conda module, Miniforge3 |
| 8 | [JupyterLab & Port Forwarding](docs/08-jupyterlab.md) | Running notebooks on a compute node |
| 9 | [Live Object Detection](docs/09-detection-demo.md) | Running a model on a live camera feed, on a GPU |
| 10 | [Additional Resources](docs/10-resources.md) | KB articles, external links, workshop survey |

## Repository layout

```
AI.Panther-Basics-Tutorial/
├── README.md            # this file
├── docs/                # numbered tutorial sections
├── notebooks/           # notebooks used in the tutorial
│   └── detection.ipynb  # live object detection (Section 9)
├── scripts/             # ready-to-use example scripts
│   ├── test_job.sh      # minimal Slurm job script (Section 6)
│   └── broken_job.sh    # a job that fails on purpose (Section 6.7)
└── images/              # diagrams and screenshots
```

## Before you start

You will need:

- A **Florida Tech TRACKS account** (username + password)
- **DUO authentication** set up
- **FortiClient VPN** if you are connecting from off-campus
- A terminal application (Command Prompt / PowerShell on Windows, or the macOS/Linux Terminal)

Ready? Start with **[Section 1 → Cluster Architecture & Storage](docs/01-cluster-architecture.md)**.
