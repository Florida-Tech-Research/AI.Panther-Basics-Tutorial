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

Start the server in the background:

```bash
module load apptainer
OLLAMA=/shared/workshops/basics/ollama
PORT=$(( 11000 + UID % 1000 ))

apptainer exec --nv \
    --bind $OLLAMA/models:/models:ro \
    --env OLLAMA_MODELS=/models,OLLAMA_HOST=127.0.0.1:$PORT,OLLAMA_NOPRUNE=1 \
    $OLLAMA/ollama.sif ollama serve > ~/ollama.log 2>&1 &
```

Chat with it:

```bash
apptainer exec --env OLLAMA_HOST=127.0.0.1:$PORT $OLLAMA/ollama.sif ollama run llama3.2:3b
```

The first reply can take up to 30 seconds while the model loads. `/bye` leaves the chat; the server
keeps running.

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

In a second terminal, `nvidia-smi` shows the model in GPU memory.

## 7.5 Try it: chat from a notebook

Open [`notebooks/chat.ipynb`](../notebooks/chat.ipynb) with the **Detection (workshop)** kernel and
run the cells. It streams replies, keeps a conversation, and compares the two models.

## 7.6 Clean up

```bash
pkill -u $USER -f "ollama serve"
```

Then **Delete** the Jupyter session in **My Interactive Sessions**.

## Containers in batch jobs

The same `apptainer exec` commands work in an `sbatch` script after `module load apptainer`.

## References

- [Apptainer documentation](https://apptainer.org/docs/user/latest/)
- [NVIDIA NGC container catalog](https://catalog.ngc.nvidia.com/containers)
- [Ollama model library](https://ollama.com/library)

---

**← Previous** [Section 6: JupyterLab & Live Object Detection](06-jupyterlab-detection.md) | **Next →** [Section 8: Additional Resources](08-resources.md)
