# 7. Virtual Environments — Python `venv` / Conda

On AI.Panther, Python and Conda are provided through the **module system**. You should always work inside a virtual environment to manage your packages.

## 7.1 Option A — Python `venv`

```bash
module load python                            # Load Python
python -m venv myenv                          # Create environment
source ~/myenv/bin/activate                   # Activate it
pip install jupyterlab                        # Install packages
jupyter lab --version                         # Verify installation
```

In your Slurm job scripts, add these lines to activate the environment:

```bash
module load python
source ~/myenv/bin/activate
```

> **Reference:** KB Article: [Using Python and Pip with Environment Modules](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=3282)

## 7.2 Option B — Conda (module)

```bash
module load anaconda3                                          # Load Conda
source $(conda info --base)/etc/profile.d/conda.sh             # Initialize conda for shell
conda create -n myenv python=3.13 -y                           # Create environment
conda activate myenv                                           # Activate it
conda install -c conda-forge jupyterlab -y                     # Install packages
jupyter lab --version                                          # Verify installation
```

In your Slurm job scripts, add:

```bash
module load anaconda3
source $(conda info --base)/etc/profile.d/conda.sh
conda activate myenv
```

> **Reference:** KB Article: [Conda on AI.Panther](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=20934)

## 7.3 Option C — Miniforge3 (user-installed Conda)

If you prefer a user-managed Conda installation:

```bash
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
source ~/.bashrc

conda create -n myenv python=3.13.0           # Create environment
conda activate myenv                          # Activate it
conda install -c conda-forge jupyterlab       # Install packages
```

- [Miniforge3 on GitHub](https://github.com/conda-forge/miniforge)
- [Conda Documentation](https://docs.conda.io/)

## 7.4 Environments in job scripts

The commands above set up an environment in the shell you are sitting in. A Slurm job does not
inherit that. It starts in a fresh shell with no modules loaded and nothing activated, which is why
[Section 6.7](06-slurm.md) is worth reading before you submit anything real: a job that works fine
when you type it by hand will fail on the first `import` if the job script does not set the
environment up again.

So whichever option you picked above, repeat it inside the job script:

```bash
#!/bin/bash
#SBATCH --partition=short
#SBATCH --time=00:10:00
#SBATCH --output=myjob.%J.out
#SBATCH --error=myjob.%J.err

module load python
source ~/myenv/bin/activate

python my_script.py
```

---

**← Previous** [Section 6: Slurm](06-slurm.md) | **Next →** [Section 8: JupyterLab & Port Forwarding](08-jupyterlab.md)
