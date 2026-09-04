# 4. File Transfers — `rsync`, `scp`, VS Code

You will frequently need to move files between your local machine and AI.Panther. You can use the **VS Code GUI** (drag-and-drop), or command-line tools like **`scp`** and **`rsync`**.

## 4.1 Local → Cluster

### Using `scp` (Windows, macOS, Linux)

```powershell
# Windows (PowerShell/CMD) — use backslashes for local paths:
scp -r .\local_folder\ username@ai-panther.fit.edu:/home1/username/
```

```bash
# macOS / Linux — use forward slashes:
scp -r ./local_folder/ username@ai-panther.fit.edu:/home1/username/
```

### Using `rsync` (macOS, Linux only)

```bash
rsync -avh local_folder/ username@ai-panther.fit.edu:/home1/username/
```

> **Note:** `rsync` is not available natively on Windows. You can install [cwRsync](https://itefix.net/cwrsync) to use it, or use `scp` or VS Code drag-and-drop instead.

## 4.2 Cluster → Local

### Using `scp` (Windows, macOS, Linux)

```powershell
# Windows (PowerShell/CMD):
scp -r username@ai-panther.fit.edu:/home1/username/data/ .\data\
```

```bash
# macOS / Linux:
scp -r username@ai-panther.fit.edu:/home1/username/data/ ./data/
```

### Using `rsync` (macOS, Linux only)

```bash
rsync -avh username@ai-panther.fit.edu:/home1/username/data/ ./data/
```

## 4.3 VS Code drag-and-drop

If you have VS Code connected via Remote-SSH (see [Section 5](05-vscode-ssh.md)), you can simply drag and drop files between your local file explorer and the VS Code file panel. This is often the easiest option for Windows users.

> **Tip:** You can also use [FileZilla](https://filezilla-project.org/) (GUI) for file transfers on any platform.

## Try it later

[Section 9](09-detection-demo.md) ends by writing an image to your home directory. That is a good
excuse to come back here and pull a real file down:

```bash
scp username@ai-panther.fit.edu:/home1/username/detection.png .
```

---

**← Previous** [Section 3: Linux CLI](03-linux-cli.md) | **Next →** [Section 5: VS Code SSH Setup](05-vscode-ssh.md)
