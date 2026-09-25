# AI.Panther Basics Tutorial

A hands-on tutorial for getting started on **AI.Panther**, Florida Tech's high-performance computing (HPC) cluster. Follow the sections in order, since each one builds on the last.

## What you'll learn

By the end of this tutorial you will be able to:

- Log in to AI.Panther from a browser with Open OnDemand and start interactive apps
- Choose the right storage for code, job output, shared data and archives, and find the staged datasets
- Navigate the cluster's file system from the Linux command line and move files on and off it
- Submit, monitor and cancel jobs through Slurm, from the shell and from the Job Composer
- Work out why a job failed, and read the files Slurm leaves behind
- Set up Python virtual environments (venv / Conda) and use them as Jupyter kernels
- Run a real model on a GPU against a live camera feed
- Run software in Apptainer containers, including a language model you can chat with

## Tutorial sections

| # | Section | Topics |
|---|---------|--------|
| 1 | [Open OnDemand](docs/01-open-ondemand.md) | Logging in, shell access, file browser, launching your Jupyter session |
| 2 | [Cluster Architecture & Storage](docs/02-architecture-storage.md) | Nodes, home, scratch, project storage, archive, datasets |
| 3 | [Linux CLI](docs/03-linux-cli.md) | Navigation, file sizes, shared storage, file transfers |
| 4 | [Slurm](docs/04-slurm.md) | Monitoring, partitions, job scripts, viewing and cancelling, interactive jobs, debugging, Job Composer and templates |
| 5 | [Virtual Environments](docs/05-virtual-environments.md) | Python `venv`, Conda module, Miniforge3 |
| 6 | [JupyterLab & Live Object Detection](docs/06-jupyterlab-detection.md) | Kernels, JupyterLab, a model on a live camera feed |
| 7 | [Using Containers](docs/07-containers.md) | Apptainer, NGC images, chatting with a language model |
| 8 | [Additional Resources](docs/08-resources.md) | KB articles, external links, workshop survey |

## Repository layout

```
AI.Panther-Basics-Tutorial/
├── README.md              # this file
├── docs/                  # numbered tutorial sections
├── notebooks/
│   ├── detection.ipynb    # live object detection (Section 6)
│   └── chat.ipynb         # chat with a language model (Section 7)
├── scripts/               # ready-to-use example scripts
│   ├── test_job.sh        # minimal Slurm job script (Section 4)
│   └── broken_job.sh      # a job that fails on purpose (Section 4)
├── job-templates/
│   └── gpu-check/         # a Job Composer template (Section 4)
└── images/                # diagrams
```

## Before you start

You will need:

- A **Florida Tech TRACKS account** (username + password) with access to AI.Panther
- **DUO authentication** set up
- **FortiClient VPN** if you are connecting from off-campus
- A web browser. Everything else runs on the cluster

Ready? Start with **[Section 1 → Open OnDemand](docs/01-open-ondemand.md)**.
