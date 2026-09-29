# 7. Using Containers

A **container** packages a program with its libraries and tools, so it runs the same on every node.
AI.Panther uses **Apptainer**, which runs Docker images without admin rights. Docker itself is not
available.

Work in a terminal in your Jupyter session (**File > New > Terminal**), so commands run on the GPU
node.

## 7.1 Load Apptainer

```bash
module load apptainer
apptainer --version
```

## 7.2 Try it: run a command inside a container

A shared NVIDIA PyTorch image:

```bash
ls -lh /shared/containers/ngc/pytorch/
apptainer exec --nv /shared/containers/ngc/pytorch/pytorch_25.08-py3.sif \
    python -c "import torch; print(torch.__version__, torch.cuda.get_device_name())"
```

`--nv` gives the container the GPU. Without it, PyTorch sees no GPU.

The container has its own Python:

```bash
python3 --version
apptainer exec /shared/containers/ngc/pytorch/pytorch_25.08-py3.sif python --version
```

## 7.3 Getting images

`apptainer pull` converts a Docker image to a `.sif` file. Keep the cache on scratch:

```bash
export APPTAINER_CACHEDIR=/shared/scratch/$USER/apptainer_cache
apptainer pull ollama.sif docker://ollama/ollama:latest
```

**Skip this today.** The Ollama image (3.3 GB) is already at
`/shared/workshops/basics/ollama/ollama.sif`.

## 7.4 Try it: chat with a language model

[Ollama](https://ollama.com) runs open language models on the GPU. Two models are staged:

| Model | Size | Notes |
|---|---|---|
| `llama3.2:3b` | 2.0 GB | Fast |
| `qwen2.5:7b` | 4.7 GB | Slower, usually better answers |

Open [`notebooks/chat.ipynb`](../notebooks/chat.ipynb) and run the cells in order. It sets up the
kernel, starts the Ollama container, chats with it, compares the two models, and stops the server
at the end.

## 7.5 Optional: the same from a terminal

In a Jupyter terminal (**File > New > Terminal**):

```bash
module load apptainer
OLLAMA=/shared/workshops/basics/ollama
PORT=$(( 11000 + $(id -u) % 1000 ))

apptainer exec --nv \
    --bind $OLLAMA/models:/models:ro \
    --env OLLAMA_MODELS=/models,OLLAMA_HOST=127.0.0.1:$PORT,OLLAMA_NOPRUNE=1 \
    $OLLAMA/ollama.sif ollama serve > ~/ollama.log 2>&1 &

apptainer exec --env OLLAMA_HOST=127.0.0.1:$PORT $OLLAMA/ollama.sif ollama run llama3.2:3b
```

`/bye` leaves the chat; the server keeps running. The notebook and the terminal use the same port,
so either can reuse a server the other started.

| Part | Why |
|---|---|
| `--nv` | GPU access |
| `--bind $OLLAMA/models:/models:ro` | Makes the model directory visible, read-only. `/shared` is not mounted in containers by default |
| `OLLAMA_MODELS=/models` | Where the models are |
| `OLLAMA_HOST=127.0.0.1:$PORT` | A per-user port, so people on the same node do not collide |
| `OLLAMA_NOPRUNE=1` | Needed for a read-only model directory |
| `> ~/ollama.log 2>&1 &` | Background, with output to a log |

Use `--env` rather than `export`: the image sets its own `OLLAMA_HOST`, which overrides your
shell's.

Stop the server:

```bash
pkill -u $(id -un) -f "ollama serve"
```

## 7.6 Clean up

**Delete** the Jupyter session in **My Interactive Sessions**.

## Containers in batch jobs

The same `apptainer exec` commands work in an `sbatch` script after `module load apptainer`.

## References

- [Apptainer documentation](https://apptainer.org/docs/user/latest/)
- [NVIDIA NGC container catalog](https://catalog.ngc.nvidia.com/containers)
- [Ollama model library](https://ollama.com/library)

---

**← Previous** [Section 6: JupyterLab & Live Object Detection](06-jupyterlab-detection.md) | **Next →** [Section 8: Additional Resources](08-resources.md)
