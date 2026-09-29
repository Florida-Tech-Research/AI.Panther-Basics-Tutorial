# 6. JupyterLab & Live Object Detection

JupyterLab runs notebooks, terminals and a file browser in the browser. Open OnDemand starts it on
a VDI node with a GPU.

## 6.1 Register your environment as a kernel

Jupyter runs code in a **kernel**, a Python environment. Register yours once, in the Open
OnDemand shell:

```bash
module load python
source ~/myenv/bin/activate
pip install ipykernel
python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```

For Conda, use `conda install -c conda-forge ipykernel` instead of `pip`.

**Python (myenv)** then appears in Jupyter, including in a running session after a page reload.

## 6.2 Connect to your session

**My Interactive Sessions > Connect to Jupyter** on the session from
[Section 1.6](01-open-ondemand.md#16-try-it-launch-your-jupyter-session). If it has ended, launch a
new one with the same settings.

## 6.3 JupyterLab basics

- The **file browser** on the left starts in your home directory.
- The **Launcher** creates notebooks (one button per kernel) and terminals.
- **File > New > Terminal** opens a shell on the compute node.
- The kernel name in the **top right** of a notebook switches kernels.

## 6.4 Try it

1. In a terminal, run `nvidia-smi`. You should see one `NVIDIA L40S-12Q` with 12 GB.
2. Start a notebook with the **Python 3** kernel and run:

   ```python
   import sys, socket
   print(socket.gethostname(), sys.executable)
   ```

3. Switch to **Python (myenv)** and run it again. The Python path changes.

## 6.5 Try it: live object detection

Open `AI.Panther-Basics-Tutorial/notebooks/detection.ipynb` and run the cells in order. If Jupyter
asks for a kernel, choose **Python 3**. The first cell registers the **Detection (workshop)**
kernel and tells you to switch to it. The rest checks the GPU, grabs a camera frame, runs YOLO,
and loops on a live feed.

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
