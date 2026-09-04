# 8. JupyterLab & Port Forwarding

JupyterLab provides a browser-based IDE for running notebooks on AI.Panther compute nodes. The process involves three steps: install prerequisites, start a compute session, and connect via port forwarding.

## 8.1 Prerequisites

Install the `ipykernel` package so JupyterLab can use your virtual environment:

```bash
conda install -c conda-forge ipykernel
```

or

```bash
pip install ipykernel
```

then:

```bash
python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```

## 8.2 Start an interactive session

Request a compute node (choose the appropriate partition):

```bash
# CPU partition:
srun -p med --nodes=1 --ntasks=1 --mem=50GB --time=01:00:00 --pty bash -i

# GPU partition:
srun -p gpu1 --nodes=1 --ntasks=1 --mem=50GB --time=01:00:00 --pty bash -i
```

## 8.3 Launch Jupyter

On the compute node, run:

```bash
NODE=$(hostname -f)
BASE=$(( 8000 + ($UID % 1000) ))
jupyter lab --no-browser --ip="$NODE" --port=$BASE --port-retries=200
```

Jupyter will print a URL like:

```text
http://node01:8123/lab?token=abc123...
```

## 8.4 Port forwarding

On your local machine, open a **new terminal** and create an SSH tunnel:

```bash
ssh -N -L LOCAL_PORT:COMPUTE_NODE:REMOTE_PORT username@ai-panther.fit.edu

# Example: if Jupyter printed node01:8123
ssh -N -L 8123:node01:8123 username@ai-panther.fit.edu
```

> **Note:** If you see an error like `bind [127.0.0.1]:8123: Permission denied`, it means the local port you requested is already in use. Simply choose a different local port.

## 8.5 Open in your browser

Navigate to <http://localhost:8123/lab> in your browser. On the login page, enter the token from the Jupyter output (all characters after `token=`).

## Reference

- KB Article: [Using JupyterLab on AI.Panther](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=20935)

---

**← Previous** [Section 7: Virtual Environments](07-virtual-environments.md) | **Next →** [Section 9: Live Object Detection](09-detection-demo.md)
