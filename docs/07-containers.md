# 7. Using Containers

A **container** packages a program together with everything it needs to run: the libraries, the
Python version, the system tools. You run the container instead of installing the software
yourself, and it behaves the same on every node.

On AI.Panther, containers run with **Apptainer** (formerly Singularity). It can run images built
for Docker, but it does not need administrator rights, runs as you, and sees your home directory,
so it is safe to use on a shared cluster. Docker itself is not available.

This section is done inside the same Jupyter session as [Section 6](06-jupyterlab-detection.md). Open a
terminal in it with **File > New > Terminal**, so that everything runs on the GPU node rather than
the login node.

## 7.1 Load Apptainer

```bash
module load apptainer
apptainer --version
```

## 7.2 Try it: run a command inside a container

A PyTorch image from NVIDIA is kept on shared storage for everyone to use. It is a single file,
ending in `.sif`:

```bash
ls -lh /shared/containers/ngc/pytorch/
```

`apptainer exec` runs one command inside a container:

```bash
apptainer exec --nv /shared/containers/ngc/pytorch/pytorch_25.08-py3.sif \
    python -c "import torch; print(torch.__version__, torch.cuda.get_device_name())"
```

`--nv` makes the node's GPU and NVIDIA driver visible inside the container. Leave it out and
PyTorch reports that there is no GPU.

Compare with the Python outside the container:

```bash
python3 --version
apptainer exec /shared/containers/ngc/pytorch/pytorch_25.08-py3.sif python --version
```

The container brings its own Python, with PyTorch, CUDA libraries and a few hundred other packages
already installed, and none of it touches your home directory.

## 7.3 Getting images

`apptainer pull` downloads an image from a registry such as Docker Hub and converts it to a
`.sif` file:

```bash
export APPTAINER_CACHEDIR=/shared/scratch/$USER/apptainer_cache
apptainer pull ollama.sif docker://ollama/ollama:latest
```

Images are large (the Ollama one is 3.3 GB), and Apptainer keeps a cache of everything it
downloads, so point `APPTAINER_CACHEDIR` at scratch rather than letting it fill your home
directory. **You do not need to run this today**; the image is already staged at
`/shared/workshops/basics/ollama/ollama.sif`.

## 7.4 Try it: chat with a language model

[Ollama](https://ollama.com) is a server that runs open language models on a GPU. The staged copy
comes with two models:

| Model | Download size | Notes |
|---|---|---|
| `llama3.2:3b` | 2.0 GB | Small and fast |
| `qwen2.5:7b` | 4.7 GB | Slower, usually better answers |

Start the server in the background, in your Jupyter terminal:

```bash
module load apptainer
OLLAMA=/shared/workshops/basics/ollama
PORT=$(( 11000 + UID % 1000 ))

apptainer exec --nv \
    --bind $OLLAMA/models:/models:ro \
    --env OLLAMA_MODELS=/models,OLLAMA_HOST=127.0.0.1:$PORT,OLLAMA_NOPRUNE=1 \
    $OLLAMA/ollama.sif ollama serve > ~/ollama.log 2>&1 &
```

Then chat with it:

```bash
apptainer exec --env OLLAMA_HOST=127.0.0.1:$PORT $OLLAMA/ollama.sif ollama run llama3.2:3b
```

The first answer can take up to half a minute while the model loads onto the GPU. After that, replies
stream in faster than you can read them. Type `/bye` to leave the chat; the server keeps running.

What each part of the server command does:

| Part | Why |
|---|---|
| `--nv` | Gives the container the GPU. Without it Ollama falls back to the CPU and is far slower |
| `--bind $OLLAMA/models:/models:ro` | Makes the shared model directory visible inside the container, read-only, at `/models`. Apptainer only mounts your home directory and a few system paths by default; `/shared` is not one of them |
| `--env OLLAMA_MODELS=/models` | Tells Ollama where the models are |
| `--env OLLAMA_HOST=127.0.0.1:$PORT` | Up to eight people share each vgpu node. A port worked out from your user ID keeps your server from colliding with theirs, and `127.0.0.1` keeps it private to the node |
| `--env OLLAMA_NOPRUNE=1` | Stops Ollama trying to tidy up the read-only model directory |
| `> ~/ollama.log 2>&1 &` | Runs the server in the background and sends its messages to a log file |

The `--env` flags are needed, rather than a plain `export`, because the Ollama image sets
`OLLAMA_HOST` itself, and a variable set by the image wins over the same variable from your shell.

While the chat is running, open a second terminal and watch the GPU:

```bash
nvidia-smi
```

The Ollama process and the memory the model occupies appear there.

## 7.5 Try it: chat from a notebook

The server speaks HTTP, so any program can talk to it, not just the `ollama` command. Open
[`notebooks/chat.ipynb`](../notebooks/chat.ipynb) with the **Detection (workshop)** kernel and run
it from the top. It streams replies into the notebook, keeps a conversation going, and compares the
two models on the same question.

## 7.6 Clean up

Stop your server:

```bash
pkill -u $USER -f "ollama serve"
```

Then delete the Jupyter session from **My Interactive Sessions**. Deleting the session also stops
anything still running inside it, including the server.

## Containers in batch jobs

Nothing here is specific to Jupyter. The same `apptainer exec` line works in an `sbatch` script,
after a `module load apptainer`, and is often the easiest way to run software with complicated
dependencies in a batch job.

## References

- [Apptainer documentation](https://apptainer.org/docs/user/latest/)
- [NVIDIA NGC container catalog](https://catalog.ngc.nvidia.com/containers)
- [Ollama model library](https://ollama.com/library)

---

**← Previous** [Section 6: JupyterLab & Live Object Detection](06-jupyterlab-detection.md) | **Next →** [Section 8: Additional Resources](08-resources.md)
