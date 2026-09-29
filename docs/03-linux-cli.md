# 3. Linux CLI: Navigating, File Sizes and Transfers

Everything in this section runs in the **Shell** (**Clusters > AI.Panther Shell Access**), on the
login node, except the `scp` and `rsync` commands in 3.7. The prompt shows your username, the host
and your current directory (`~` is your home directory):

```text
username@ai-panther:~$
```

## 3.1 Navigation commands

```bash
pwd             # Show your current directory
ls              # List files in the current directory
ls -lh          # List files with human-readable sizes
cd dirname      # Change into a directory
cd ..           # Go up one level
cd ~            # Go to your home directory
```

## 3.2 File size & disk usage

```bash
du -sh *        # Show size of each file/directory
df -h           # Show available disk space
```

## 3.3 Running a Python script

```bash
module load python
python script_name.py
```

> **Note:** Run only small, quick scripts on the login node. Anything heavy goes in a Slurm job
> ([Section 4](04-slurm.md)).

## 3.4 Try it: explore the file system

**Shell:**

```bash
pwd
ls -lh
mkdir test_folder
cd test_folder
pwd
cd ..
du -sh ~
df -h /home1
```

Create a file and read it from Python. **Shell:**

```bash
echo "Hello AI Panther" > hello.txt
cat hello.txt
ls -lh hello.txt

module load python
cat > read_hello.py << 'EOF'
with open("hello.txt") as f:
    text = f.read().strip()
print(f"hello.txt says: {text}")
print(f"Character count: {len(text)}")
EOF
python read_hello.py
```

```text
hello.txt says: Hello AI Panther
Character count: 16
```

Clean up. **Shell:**

```bash
rm -r hello.txt read_hello.py test_folder
```

## 3.5 Try it: the workshop directory

`/shared/workshops/basics` holds the environment, models and data for Sections 6 and 7. It is
read-only. **Shell:**

```bash
cd /shared/workshops/basics
ls -lh
du -sh *
ls data/frames | wc -l
ls -lh models/
```

`ollama` (the chat container and models) and `venv` (the Python environment) are the largest.

This fails with `Permission denied`. **Shell:**

```bash
touch /shared/workshops/basics/test.txt
```

Your own files go in your home directory or `/shared/scratch`.

## 3.6 Try it: transfer files in the browser

Use this for files up to a few hundred MB. Open **Files > Home Directory**, click **Upload** and
choose any small file from your computer. Then select it and click **Download**. You can also drag
files onto the list.

## 3.7 Transferring from the command line

For large files or directories, run `scp` or `rsync` **on your own computer**, not in the Shell.
Off campus, this needs the VPN.

Local to cluster. **Your computer:**

```powershell
# Windows (PowerShell/CMD):
scp -r .\local_folder\ username@ai-panther.fit.edu:/home1/username/
```

```bash
# macOS / Linux:
scp -r ./local_folder/ username@ai-panther.fit.edu:/home1/username/
rsync -avh local_folder/ username@ai-panther.fit.edu:/home1/username/
```

Cluster to local. **Your computer:**

```powershell
# Windows (PowerShell/CMD):
scp -r username@ai-panther.fit.edu:/home1/username/data/ .\data\
```

```bash
# macOS / Linux:
scp -r username@ai-panther.fit.edu:/home1/username/data/ ./data/
rsync -avh username@ai-panther.fit.edu:/home1/username/data/ ./data/
```

`rsync` skips files that have not changed. It is not built into Windows; use `scp`, the browser,
or [cwRsync](https://itefix.net/cwrsync). [FileZilla](https://filezilla-project.org/) and WinSCP
are GUI options.

---

**← Previous** [Section 2: Cluster Architecture & Storage](02-architecture-storage.md) | **Next →** [Section 4: Slurm](04-slurm.md)
