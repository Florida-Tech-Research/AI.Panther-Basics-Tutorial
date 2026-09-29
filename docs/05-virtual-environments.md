# 5. Virtual Environments: Python `venv` and Conda

Python and Conda are provided through the **module system**. Install your packages into a virtual
environment. Every command in this section runs in the **Shell**.

## 5.1 Try it: Python `venv`

**Shell:**

```bash
module load python                            # Load Python
python -m venv myenv                          # Create environment
source ~/myenv/bin/activate                   # Activate it
pip install jupyterlab                        # Install packages
jupyter lab --version                         # Verify installation
```

You will use `myenv` as a Jupyter kernel in [Section 6](06-jupyterlab-detection.md).

In a Slurm job script, add these lines to activate it:

```bash
module load python
source ~/myenv/bin/activate
```

> **Reference:** KB Article: [Using Python and Pip with Environment Modules](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=3282)

## 5.2 Option B: Conda (module)

```bash
module load anaconda3                                          # Load Conda
source $(conda info --base)/etc/profile.d/conda.sh             # Initialize conda for shell
conda create -n myenv python=3.13 -y                           # Create environment
conda activate myenv                                           # Activate it
conda install -c conda-forge jupyterlab -y                     # Install packages
jupyter lab --version                                          # Verify installation
```

In a Slurm job script, add:

```bash
module load anaconda3
source $(conda info --base)/etc/profile.d/conda.sh
conda activate myenv
```

> **Reference:** KB Article: [Conda on AI.Panther](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=20934)

## 5.3 Option C: Miniforge3 (user-installed Conda)

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

## 5.4 Environments in job scripts

A job starts with no modules loaded and no environment activated
([Section 4.8](04-slurm.md#48-try-it-a-job-that-goes-wrong)), so set up the environment in the job
script:

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

**← Previous** [Section 4: Slurm](04-slurm.md) | **Next →** [Section 6: JupyterLab & Live Object Detection](06-jupyterlab-detection.md)
