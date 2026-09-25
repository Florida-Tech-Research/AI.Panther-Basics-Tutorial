# 6. JupyterLab & Live Object Detection

JupyterLab is a browser-based environment for notebooks, terminals and files. On AI.Panther you
start it from Open OnDemand, which puts it on a compute node with a GPU and connects your browser
to it. There are no SSH tunnels or tokens to deal with.

This section puts the rest of the tutorial together: the session you launched in
[Section 1.6](01-open-ondemand.md#16-try-it-launch-your-jupyter-session-now), a Python environment registered as a kernel, and a model that
draws boxes around whatever a live camera is currently looking at.

## 6.1 Make your environment available as a kernel

Jupyter runs your code in a **kernel**, which is a Python environment. The Jupyter in Open
OnDemand only knows about its own default kernel until you register yours. Do this once per
environment, from the Open OnDemand shell:

```bash
module load python
source ~/myenv/bin/activate
pip install ipykernel
python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```

For a Conda environment, install `ipykernel` with `conda install -c conda-forge ipykernel`
instead of `pip`, and run the same `python -m ipykernel install` line.

This writes a small kernel description into `~/.local/share/jupyter/kernels/myenv`. Jupyter
lists **Python (myenv)** as a kernel from then on, including in a session that is already running
(reload the JupyterLab page if it does not appear).

## 6.2 Register the workshop kernel

Everything the detection notebook needs is already staged on shared storage at
`/shared/workshops/basics`: a virtual environment with PyTorch, the YOLO model code and
JupyterLab, plus the model weights. Register that environment as a kernel exactly as above, by
running this once in the Open OnDemand shell:

```bash
/shared/workshops/basics/venv/bin/python -m ipykernel install --user \
    --name basics-detection --display-name "Detection (workshop)"
```

## 6.3 Connect to your session

Open **My Interactive Sessions**. The Jupyter session from [Section 1.6](01-open-ondemand.md#16-try-it-launch-your-jupyter-session-now)
should be *Running*; click **Connect to Jupyter**.

If it is not there (it was never launched, or it has ended), start one from
**Interactive Apps > Jupyter** with the settings in [Section 1.6](01-open-ondemand.md#16-try-it-launch-your-jupyter-session-now). Kernels
registered after a session started still show up in it (after a page reload), so there is no need to restart one that
is already running.

## 6.4 Find your way around JupyterLab

- The **file browser** on the left starts in your home directory.
- The **Launcher** tab creates new notebooks (one button per kernel), consoles, and terminals.
- **File > New > Terminal** opens a shell *on the compute node*, not the login node. Run
  `hostname` and `nvidia-smi` in it to see which node and GPU you were given.
- The kernel name in the **top right** of a notebook shows which environment it is running in.
  Click it to switch.

## 6.5 Try it

1. Open a terminal and run `nvidia-smi`. You should see one `NVIDIA L40S-12Q` with 12 GB.
2. In the Launcher, start a notebook with the default **Python 3** kernel, and run:

   ```python
   import sys, socket
   print(socket.gethostname(), sys.executable)
   ```

3. Switch the kernel (top right) to **Python (myenv)** if you created it, and run the cell again.
   The path to Python changes to the one inside your environment.

## 6.6 Try it: live object detection

In JupyterLab, open `AI.Panther-Basics-Tutorial/notebooks/detection.ipynb`, check that the kernel in
the top right says **Detection (workshop)**, and work down from the top. The notebook checks that you
actually got a GPU, grabs a frame from a camera, runs the model on it, and then loops so you can
watch detections update on a live feed.

It starts on the pedestrian walkway of the Brooklyn Bridge, one of about 900 New York City traffic
cameras. Those are only 352x240, but they give a new frame every couple of seconds, which is the
only source fast enough for the live loop to look like video.

The other two sources are worth a look but refresh slowly. The two Florida Tech cameras are
1920x1080 and much better pictures, yet they only produce a new frame about every eighty seconds,
and the twelve Florida DOT cameras near campus are slower still:

```python
camera = feeds.find("Brooklyn Bridge - Ped")
camera = feeds.find("Crimson")
camera = feeds.CAMPUS
camera = feeds.find("Melbourne")
```

`feeds.find("Crimson")` looks over Babcock Street and usually has traffic in it. `feeds.CAMPUS` is
the Olin Quad, which looks down on a mostly empty lawn from a long way up, so there is frequently
nothing in it to detect. If you switch to either, raise the sleep in the live loop to about thirty
seconds.

Leave the session running when you finish. [Section 7](07-containers.md) uses it too.

## Other interactive apps

The other entries under **Interactive Apps** work the same way: fill in the form, wait for
*Running*, connect.

- **Code Server** is VS Code running in your browser, on a compute node. Everything in this
  tutorial also works there, including notebooks.
- **Desktop** is a full Linux desktop, useful for programs with a graphical interface.

## Reference

- KB Article: [Using JupyterLab on AI.Panther](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=20935)

---

**← Previous** [Section 5: Virtual Environments](05-virtual-environments.md) | **Next →** [Section 7: Using Containers](07-containers.md)
