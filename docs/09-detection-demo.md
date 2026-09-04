# 9. Live Object Detection

This section puts the rest of the tutorial together. You will request a GPU, start JupyterLab
on it, and run a model that draws boxes around whatever a live camera is currently looking at.

Everything the notebook needs is already staged on shared storage at
`/shared/workshops/basics`, so there is nothing to install and nothing to download.

## 9.1 Get the notebook

If you have not already cloned this repository, do it now from the login node:

```bash
git clone https://github.com/Florida-Tech-Research/AI.Panther-Basics-Tutorial.git
```

## 9.2 Request a GPU

The login node has no GPU, so ask Slurm for one. This asks for a single GPU for an hour:

```bash
srun -p gpu1 --nodes=1 --ntasks=1 --gres=gpu:1 --mem=32G --time=01:00:00 --pty bash -i
```

Your prompt changes to the compute node's name once the job starts. If nothing happens for a
while, the partition is busy and you are queued behind other people.

## 9.3 Start JupyterLab

The staged environment already contains JupyterLab, PyTorch and the model code, so you can
launch it directly rather than building an environment first:

```bash
NODE=$(hostname -f)
BASE=$(( 8000 + ($UID % 1000) ))
/shared/workshops/basics/venv/bin/jupyter lab --no-browser --ip="$NODE" --port=$BASE --port-retries=200
```

Note the node name and port in the URL it prints.

### Using Open OnDemand instead

If you would rather not deal with SSH tunnels, this notebook also runs in the Jupyter app on
<https://ood.fit.edu>. That Jupyter does not know about the staged environment, so register it as a
kernel once, from the login node:

```bash
/shared/workshops/basics/venv/bin/python -m ipykernel install --user \
    --name basics-detection --display-name "Detection (workshop)"
```

Then start a Jupyter session with a GPU, open the notebook, and pick **Detection (workshop)** from
the kernel menu in the top right. You can skip 9.3 and 9.4 entirely if you go this route.

## 9.4 Forward the port

In a **new terminal on your own machine**, open a tunnel to that node and port, as in
[Section 8](08-jupyterlab.md):

```bash
ssh -N -L 8123:gpu01:8123 username@ai-panther.fit.edu
```

Then open <http://localhost:8123/lab> and paste in the token from the Jupyter output.

## 9.5 Run it

Open `notebooks/detection.ipynb` and work down from the top. The notebook checks that you
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

## 9.6 Clean up

When you are finished, stop Jupyter with `Ctrl+C`, then `exit` the `srun` session so the GPU
goes back into the pool. If you forget, the job ends on its own when the hour you asked for runs
out, but somebody is probably waiting for it.

---

**← Previous** [Section 8: JupyterLab & Port Forwarding](08-jupyterlab.md) | **Next →** [Section 10: Additional Resources](10-resources.md)
