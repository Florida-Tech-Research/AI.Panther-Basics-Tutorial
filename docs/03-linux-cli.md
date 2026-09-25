# 3. Linux CLI: Navigating, File Sizes and Transfers

In the Open OnDemand shell (**Clusters > AI.Panther Shell Access**), you interact with AI.Panther through the Linux command line interface (CLI). Commands you type run on the login node.

Your prompt looks like this:

```text
username@ai-panther:~$
```

This tells you your username, the system you are on, and your current directory (`~` means your home directory).

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

To run a Python script from the command line, use:

```bash
python script_name.py
```

You'll try this in the hands-on exercises below by writing a small script that reads the `hello.txt` file you create.

> **Note:** Python is not loaded by default on AI.Panther. Run `module load python` first (see [Section 5](05-virtual-environments.md) for details on virtual environments). And remember, only run small, quick scripts on the login node. Anything heavy (training, long simulations) belongs in a Slurm job (see [Section 4](04-slurm.md)).

## 3.4 Try it: explore the file system

Run each of these commands after logging in and observe the output.

### See where you are

```bash
pwd
```

Expected output:

```text
/home1/username
```

### List what's in your home directory

```bash
ls -lh
```

Expected output (yours will vary):

```text
total 4.0K
drwxr-xr-x 2 username username 4.0K Feb  4 10:00 Documents
```

### Navigate into a directory and back

```bash
mkdir test_folder          # Create a new directory
cd test_folder             # Move into it
pwd                        # Confirm your location
cd ..                      # Go back up one level
pwd                        # Confirm you're back
```

Expected output:

```text
/home1/username/test_folder
/home1/username
```

### Check how much space you're using

```bash
du -sh ~
```

Expected output:

```text
12K     /home1/username
```

### Check available disk space on the system

```bash
df -h /home1
```

Expected output (values will vary):

```text
Filesystem      Size  Used Avail Use% Mounted on
server:/home1   5.0T  1.2T  3.8T  24% /home1
```

### Create a file and verify it exists

```bash
echo "Hello AI Panther" > hello.txt
cat hello.txt              # Print the file contents
ls -lh hello.txt           # Check its size
```

Expected output:

```text
Hello AI Panther
-rw-r--r-- 1 username username 17 Feb  4 10:05 hello.txt
```

### Read the file from a Python script

Now write a tiny Python script that reads `hello.txt` and run it.

> **Note:** As a rule, don't run real workloads on the login node. Submit them as Slurm jobs (see [Section 4](04-slurm.md)). A tiny sanity check like this one is fine because it finishes in milliseconds and uses almost no resources.

```bash
module load python                                # Load Python (skip if already loaded)

cat > read_hello.py << 'EOF'
with open("hello.txt") as f:
    text = f.read().strip()
print(f"hello.txt says: {text}")
print(f"Character count: {len(text)}")
EOF

python read_hello.py
```

Expected output:

```text
hello.txt says: Hello AI Panther
Character count: 16
```

Clean up both files:

```bash
rm hello.txt read_hello.py
```

## 3.5 Explore the workshop directory

Everything above used files you made yourself. Real work on AI.Panther usually means reading
data somebody else put on shared storage, so it is worth practising on a directory you did not
create.

`/shared/workshops/basics` holds the model weights and camera data used in
[Section 6](06-jupyterlab-detection.md). It is readable by everyone and writable by nobody, which is
what shared reference data normally looks like.

```bash
cd /shared/workshops/basics
ls -lh
```

Now answer these using the commands from this section. Each one is a single line.

**How big is each thing in here, and which is largest?**

```bash
du -sh *
```

Two things dwarf the rest. `ollama` holds the container and language models used in
[Section 7](07-containers.md), and language models are big. `venv` is the Python environment for
[Section 6](06-jupyterlab-detection.md), and it is about two hundred times the size of the detection
models it exists to run, which is the usual story: code and weights are small, the Python
environment around them is not. Both live in `/shared` rather than in each of your home
directories, where 19 copies would be 19 times the size.

**How many sample frames are there?**

```bash
ls data/frames | wc -l
```

`wc -l` counts lines, so piping `ls` into it counts files.

**What models are available, and how big are they?**

```bash
ls -lh models/
```

**Where does your home directory stand against your quota?**

```bash
du -sh ~
```

Your home directory is capped at 100 GB. Compare that to the size of the environment you just
measured, and it becomes clear why shared data is staged centrally rather than copied per user.

**One thing you cannot do:**

```bash
touch /shared/workshops/basics/test.txt
```

This fails with `Permission denied`. You have read access to shared reference data, not write
access. Your own work belongs in your home directory or in `/shared/scratch`.

## 3.6 File transfers

You will often need to move files between your own computer and AI.Panther.

### In the browser

For anything up to a few hundred megabytes, the Open OnDemand file browser is the easiest route.
Open **Files > Home Directory**, go to the folder you want, and use **Upload** to send files to the
cluster or select a file and press **Download** to bring it back. You can also drag files from your
desktop onto the file list.

### From the command line

For large files, whole directories, or anything you repeat, use `scp` or `rsync` from a terminal
**on your own computer**, not in the Open OnDemand shell. These do use SSH underneath, so off
campus you still need the VPN.

Local to cluster:

```powershell
# Windows (PowerShell/CMD), use backslashes for local paths:
scp -r .\local_folder\ username@ai-panther.fit.edu:/home1/username/
```

```bash
# macOS / Linux:
scp -r ./local_folder/ username@ai-panther.fit.edu:/home1/username/
rsync -avh local_folder/ username@ai-panther.fit.edu:/home1/username/
```

Cluster to local:

```powershell
# Windows (PowerShell/CMD):
scp -r username@ai-panther.fit.edu:/home1/username/data/ .\data\
```

```bash
# macOS / Linux:
scp -r username@ai-panther.fit.edu:/home1/username/data/ ./data/
rsync -avh username@ai-panther.fit.edu:/home1/username/data/ ./data/
```

`rsync` only copies what has changed, so re-running it after an interruption picks up where it
left off. It is not available natively on Windows; use `scp`, the browser, or
[cwRsync](https://itefix.net/cwrsync).

> **Tip:** [FileZilla](https://filezilla-project.org/) and WinSCP give you a drag-and-drop window
> over the same SSH connection, if you prefer a GUI for large transfers.

### Try it later

[Section 6](06-jupyterlab-detection.md) ends by writing an image to your home directory. That is a good
excuse to come back here and download a real file, either from the file browser or with:

```bash
scp username@ai-panther.fit.edu:/home1/username/detection.png .
```

---

**← Previous** [Section 2: Cluster Architecture & Storage](02-architecture-storage.md) | **Next →** [Section 4: Slurm](04-slurm.md)
