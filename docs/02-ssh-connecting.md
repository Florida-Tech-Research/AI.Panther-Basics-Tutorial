# 2. SSH & Connecting

SSH (Secure Shell) is the standard way to log into a remote system over a network. All communication is encrypted. You will use SSH to connect to the AI.Panther login node.

## 2.1 What you need

To connect, you need three things:

- **Hostname:** `ai-panther.fit.edu`
- **Username:** your Florida Tech username (e.g. `aissitt2019`)
- **Password:** your Florida Tech password (or an SSH key later)

## 2.2 Connecting

Open a terminal (Command Prompt, PowerShell, or macOS/Linux Terminal) and run:

```bash
ssh username@ai-panther.fit.edu
```

> **Note:** On your first connection, you will see a message asking whether to trust the host. This is normal — type `yes` to continue.

## 2.3 Verifying your connection

Once connected, try these commands to confirm you are on the cluster:

```bash
hostname      # Should display the login node name
whoami        # Should display your username
```

## 2.4 Disconnecting

To end your SSH session:

```bash
exit
# or press Ctrl + D
```

## Reference

- KB Article: [SSH Passwordless Authentication Setup for ai-panther.fit.edu](https://help.fit.edu/TDClient/39/Portal/KB/ArticleDet?ID=21093) — set up SSH keys so you don't have to type your password every time

---

**← Previous** [Section 1: Cluster Architecture](01-cluster-architecture.md) | **Next →** [Section 3: Linux CLI](03-linux-cli.md)
