# 1. Open OnDemand

Open OnDemand is AI.Panther's web portal. It gives you a shell, a file browser, job tools and
interactive apps such as Jupyter, all in the browser.

## 1.1 Try it: log in

Go to <https://ood.fit.edu> and sign in with your TRACKS username, password and DUO.

> **Note:** Off campus, connect to the VPN first.

## 1.2 Navigation

| Menu | What it does |
|---|---|
| **Files** | Browse, upload, download, edit, rename and delete files |
| **Jobs** | **Active Jobs** lists running and queued jobs; **Job Composer** writes and submits job scripts |
| **Clusters** | **AI.Panther Shell Access** opens a terminal on the login node |
| **Interactive Apps** | Jupyter, Code Server (VS Code), Desktop, MATLAB and others |
| **My Interactive Sessions** | Connect to or delete your running apps |

In this tutorial, **Shell** means **Clusters > AI.Panther Shell Access**.

## 1.3 Try it: open a shell

**Shell:**

```bash
hostname
whoami
git clone https://github.com/Florida-Tech-Research/AI.Panther-Basics-Tutorial.git
```

`hostname` prints `ai-panther.fit.edu`, the login node. `git clone` copies this tutorial into
your home directory.

## 1.4 Try it: the file browser

Open **Files > Home Directory**, go into `AI.Panther-Basics-Tutorial/scripts`, and open
`test_job.sh`. **Edit** opens it in a browser editor. The toolbar has **Upload**, **Download**,
**New File**, **New Directory**, **Copy/Move** and **Delete**.

## 1.5 Interactive apps

Each app has a form for hardware and time. **Launch** submits a Slurm job. The session shows as
*Queued*, then *Running* with a **Connect** button.

Interactive apps run on the VDI nodes (`vdi-*` partitions). One GPU is a 12 GB slice of an L40S.

> **Important:** A session holds its GPU until you **Delete** it or its time runs out. Closing
> the tab does not free it.

## 1.6 Try it: launch your Jupyter session

You will use this session in Sections 6 and 7. Open **Interactive Apps > Jupyter** and fill in:

| Field | Value |
|---|---|
| Partition | `vdi-med` |
| Hours / Minutes | 2 / 30 |
| CPUs | 8 |
| Memory (GB) | 16 |
| GPUs | 1 |
| Modules to load | leave blank |
| Working Directory | leave blank |

Click **Launch**. You do not need to connect yet.

`vdi-short` has a 1-hour limit, which is too short for the workshop.

## Troubleshooting

| Problem | Fix |
|---|---|
| `ood.fit.edu` does not load | Connect to the VPN |
| Login fails | Check your TRACKS credentials and DUO |
| Session stuck on *Queued* | All GPU slices are in use; wait, or ask for less time |
| Shell tab is blank | Reload the page |

## Reference

- KB Article: [Getting Started with Open OnDemand (OOD)](https://help.fit.edu/TDClient/39/Portal/KB/Article/21616/Getting-Started-with-Open-OnDemand-OOD)

---

[↑ Back to README](../README.md) | **Next →** [Section 2: Cluster Architecture & Storage](02-architecture-storage.md)
