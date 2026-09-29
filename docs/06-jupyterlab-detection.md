# 6. JupyterLab & Live Object Detection

JupyterLab runs notebooks, terminals and a file browser in the browser. Open OnDemand starts it on
a VDI node with a GPU.

This section uses three places to run things:

| Where | How to open it | Runs on |
|---|---|---|
| **Shell** | **Clusters > AI.Panther Shell Access** | Login node |
| **Jupyter terminal** | In JupyterLab, **File > New > Terminal** | Your VDI GPU node |
| **Notebook** | Open a `.ipynb` file in JupyterLab | Your VDI GPU node |

## 6.1 Try it: register your environment as a kernel

Jupyter runs code in a **kernel**, which is a Python environment. Register `myenv` from
[Section 5.1](05-virtual-environments.md#51-try-it-python-venv) once. **Shell:**

```bash
module load python
source ~/myenv/bin/activate
pip install ipykernel
python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```

For Conda, use `conda install -c conda-forge ipykernel` instead of `pip`.

**Python (myenv)** then appears in Jupyter, including in a running session after a page reload.

## 6.2 Try it: connect to your session

Open **My Interactive Sessions** and click **Connect to Jupyter** on the session from
[Section 1.6](01-open-ondemand.md#16-try-it-launch-your-jupyter-session). If it has ended, launch a
new one with the same settings.

## 6.3 JupyterLab basics

- The **file browser** on the left starts in your home directory.
- The **Launcher** creates notebooks (one button per kernel) and terminals.
- **File > New > Terminal** opens a **Jupyter terminal** on your GPU node, not the login node.
- The kernel name in the **top right** of a notebook shows the current kernel. Click it to switch.

## 6.4 Try it: terminal and notebook

1. **Jupyter terminal:** run `nvidia-smi`. You should see one `NVIDIA L40S-12Q` with 12 GB.
2. **Notebook:** in the Launcher, start a notebook with the **Python 3** kernel and run:

   ```python
   import sys, socket
   print(socket.gethostname(), sys.executable)
   ```

3. Switch the kernel to **Python (myenv)** and run the cell again. The Python path changes to the
   one inside `myenv`.

## 6.5 Try it: live object detection

**Notebook:** open `AI.Panther-Basics-Tutorial/notebooks/detection.ipynb` and run the cells in
order.

- If Jupyter asks you to select a kernel, choose **Python 3**.
- The first cell registers the **Detection (workshop)** kernel and tells you to switch to it with
  **Kernel > Change Kernel...**. Run it again after switching; it prints `Ready`.
- The rest of the notebook checks the GPU, grabs a camera frame, runs YOLO, and then loops on a
  live feed.

| Camera | Resolution | New frame every |
|---|---|---|
| New York City traffic cameras (default: Brooklyn Bridge) | 352x240 | ~2 s |
| Florida Tech: `feeds.find("Crimson")`, `feeds.CAMPUS` | 1920x1080 | ~80 s |
| Florida DOT near campus: `feeds.find("Melbourne")` | | slower |

For the slower cameras, raise the sleep in the live loop to about 30 seconds.

Leave the session running for [Section 7](07-containers.md).

## Other interactive apps

- **Code Server:** VS Code in the browser, on a compute node. The notebooks work there too.
- **Desktop:** a Linux desktop for graphical programs.

## Reference

- KB Article: [Using JupyterLab on AI.Panther](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=20935)

---

**← Previous** [Section 5: Virtual Environments](05-virtual-environments.md) | **Next →** [Section 7: Using Containers](07-containers.md)
