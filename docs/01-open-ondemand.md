# 1. Open OnDemand

Open OnDemand is a web portal for AI.Panther. From a browser you can open a shell, browse and
edit files, submit and watch jobs, and start interactive apps such as Jupyter on a GPU. It is how
you will do everything in this tutorial.

## 1.1 Logging in

Go to <https://ood.fit.edu> and sign in with your Florida Tech TRACKS username and password, then
approve the DUO prompt.

> **Note:** Off campus, connect to the VPN first. Without it `ood.fit.edu` does not resolve and
> the page never loads.

## 1.2 Finding your way around

The navigation bar along the top has four menus you will use:

| Menu | What it gives you |
|---|---|
| **Files** | A file browser for your home directory and other storage. Upload, download, edit, rename, delete |
| **Jobs** | **Active Jobs** lists what is running or queued; **Job Composer** writes and submits job scripts |
| **Clusters** | **AI.Panther Shell Access** opens a terminal on the login node in a new tab |
| **Interactive Apps** | Jupyter, Code Server (VS Code in the browser), a virtual desktop, MATLAB and others |

**My Interactive Sessions**, also in the top bar, lists the interactive apps you have running and
is where you connect to them or shut them down.

## 1.3 Try it: open a shell

Open **Clusters > AI.Panther Shell Access**. A terminal opens in a new browser tab, already
logged in to the login node. Confirm where you are:

```bash
hostname      # The login node's name
whoami        # Your username
```

This is the same shell you would get from `ssh username@ai-panther.fit.edu`, so every command in
the rest of the tutorial works here.

Now get a copy of this tutorial into your home directory. You will need it for the job scripts
and notebooks later on:

```bash
git clone https://github.com/Florida-Tech-Research/AI.Panther-Basics-Tutorial.git
```

To leave the shell, type `exit` or close the tab.

## 1.4 Try it: the file browser

Open **Files > Home Directory**. You should see the `AI.Panther-Basics-Tutorial` folder you just
cloned. Click into it, then into `scripts`, and click `test_job.sh` to view it. The **Edit**
button opens the file in an editor in the browser, which is often easier than editing in a
terminal.

The buttons along the top of the file browser cover most day-to-day file handling: **Upload**,
**Download**, **New File**, **New Directory**, **Copy/Move** and **Delete**. [Section 3](03-linux-cli.md)
shows the command-line equivalents.

## 1.5 Interactive apps

Every app under **Interactive Apps** opens a form asking what hardware you want and for how long.
When you press **Launch**, Open OnDemand submits a Slurm job for you. The session appears under
**My Interactive Sessions** as *Queued*, then *Running*, at which point a **Connect** button
appears.

Interactive apps run on the vgpu nodes (the `vdi-*` partitions), so a session with one GPU gets a
12 GB slice of an L40S.

> **Important:** A session keeps its GPU for the full time you asked for, even if you close the
> browser tab. When you are finished, press **Delete** on the session card so someone else can
> use the GPU.

## 1.6 Try it: launch your Jupyter session now

You will use one Jupyter session for the second half of the workshop, for both the object
detection in [Section 6](06-jupyterlab-detection.md) and the chat in
[Section 7](07-containers.md). Start it now so it is ready when you get there.

Open **Interactive Apps > Jupyter** and fill in the form:

| Field | Value for this workshop |
|---|---|
| Partition | `vdi-med` |
| Hours / Minutes | 2 / 30 |
| CPUs | 8 |
| Memory (GB) | 16 |
| GPUs | 1 |
| Modules to load | leave blank |
| Working Directory | leave blank |

Click **Launch**. There is no need to connect yet; leave it running and carry on.

`vdi-med` allows up to 8 hours. `vdi-short` is capped at one hour, which is not long enough to
last the workshop. Outside of a workshop, ask only for the time you need.

## Troubleshooting

| Problem | Fix |
|---|---|
| **`ood.fit.edu` does not load** | Connect to the VPN if you are off campus. |
| **Login fails** | Check your TRACKS username and password, and that DUO is set up. |
| **Session stuck on *Queued*** | All GPU slices are in use. Wait, or ask for fewer hours so the scheduler can fit you in sooner. |
| **Shell tab is blank** | Reload the page. Shell tabs time out when idle. |

## Reference

- KB Article: [Getting Started with Open OnDemand (OOD)](https://help.fit.edu/TDClient/39/Portal/KB/Article/21616/Getting-Started-with-Open-OnDemand-OOD)

---

[↑ Back to README](../README.md) | **Next →** [Section 2: Cluster Architecture & Storage](02-architecture-storage.md)
