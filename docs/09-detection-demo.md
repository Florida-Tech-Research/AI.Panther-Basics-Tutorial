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

It starts on the Crimson Crossing camera, which looks over Babcock Street and normally has traffic
in shot. Two other sources are available. `feeds.CAMPUS` is the Olin Quad, which is the better
picture but looks down on a mostly empty lawn from a long way up, so there is often nothing in it
to detect. Beyond campus there are about 900 New York City traffic cameras, much lower resolution
but refreshing every second or two, and busy enough that there is always something to find:

```python
camera = feeds.find("Crimson")
camera = feeds.CAMPUS
camera = feeds.find("Brooklyn Bridge - Ped")
```

The Brooklyn Bridge pedestrian walkway is worth a look, since it is full of people rather than
traffic.

## 9.6 Clean up

When you are finished, stop Jupyter with `Ctrl+C`, then `exit` the `srun` session so the GPU
goes back into the pool. If you forget, the job ends on its own when the hour you asked for runs
out, but somebody is probably waiting for it.

---

**← Previous** [Section 8: JupyterLab & Port Forwarding](08-jupyterlab.md) | **Next →** [Section 10: Additional Resources](10-resources.md)
