<p align="center">
  <img src="docs/images/podman-sandbox-icon.svg" alt="Podman Sandbox Logo" width="128" height="128">
</p>

<h1 align="center">Podman Sandbox</h1>

<p align="center">
  <strong>A repository for comparing and learning Podman vs Docker</strong>
</p>

<p align="center">
  <strong>English</strong> | <a href="README.ja.md">日本語</a>
</p>

<p align="center">
  <a href="https://github.com/Sunwood-ai-labs/podman-sandbox/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/Sunwood-ai-labs/podman-sandbox?style=flat-square&color=blue" alt="License">
  </a>
  <a href="https://github.com/Sunwood-ai-labs/podman-sandbox">
    <img src="https://img.shields.io/badge/GitHub-podman--sandbox-892ca0?style=flat-square&logo=github" alt="GitHub">
  </a>
  <a href="https://sunwood-ai-labs.github.io/podman-sandbox/">
    <img src="https://img.shields.io/badge/Docs-VitePress-892ca0?style=flat-square&logo=googledocs" alt="Docs">
  </a>
</p>

---

## 📋 Table of Contents

- [🎯 Overview](#-overview)
- [✨ Key Features](#-key-features)
- [🏗️ Architecture Differences](#️-architecture-differences)
- [💾 Memory Efficiency Comparison](#-memory-efficiency-comparison)
- [⚙️ systemd Integration](#️-systemd-integration)
- [📁 Examples](#-examples)
- [🚀 Basic Usage](#-basic-usage)
- [📊 Summary](#-summary)
- [📚 References](#-references)

---

## 🎯 Overview

**Podman** is a container runtime developed by Red Hat that serves as a drop-in replacement for Docker.

### ✨ Key Features

| Feature | Description |
|---------|-------------|
| 🐳 **Daemonless** | No background daemon required |
| 🔓 **Rootless** | Run without root privileges |
| 🔄 **Docker Compatible** | Drop-in replacement for Docker commands |
| 📦 **Pod Support** | Kubernetes-style container grouping |
| ⚙️ **systemd Integration** | Native systemd service management |

---

## 🏗️ Architecture Differences

| Aspect | Docker | Podman |
|--------|--------|--------|
| Architecture | Client-server model (daemon required) | Daemonless (fork-exec model) |
| Resident Process | `dockerd` runs constantly | None |
| Execution Privileges | Root by default (rootless mode available) | Rootless by default |
| Security | Daemon can be an attack vector | Smaller attack surface |

---

## 💾 Memory Efficiency Comparison

### Conclusion

**Podman tends to be more memory-efficient**

### Reasons

#### 1. Daemonless Design

| | Docker | Podman |
|--|--------|--------|
| Idle | `dockerd` continuously consumes memory | No memory consumption |
| Execution Flow | CLI → Daemon → Container | CLI → Container directly |
| Base Overhead | High (daemon + container) | Low (no daemon) |

Docker's `dockerd` runs in the background and consumes memory even when no containers are running.
Podman has no daemon, so it only uses resources when containers are executing.

#### 2. Rootless Execution Optimization

- **Podman**: Designed for rootless from the start, efficient unprivileged execution
- **Docker**: Rootless mode was added later, higher overhead

#### 3. Process Model

- **Podman**: Each container runs as a direct child of the `podman` process (fork-exec)
- **Docker**: Managed through daemon, adding an extra layer

### Scenario-based Comparison

| Scenario | Winner |
|----------|--------|
| Few containers | Podman (no daemon overhead) |
| Many concurrent containers | Docker (daemon sharing improves efficiency) |
| Rootless execution | Podman (native support) |
| Development ease | Both equivalent |

### Checking Memory Usage

```bash
# Podman
podman stats

# Docker
docker stats
```

---

## ⚙️ systemd Integration

Podman has powerful systemd integration, allowing containers to be managed as systemd services.

### Converting Containers to systemd Services

```bash
# Generate systemd service file from container
podman generate systemd --name my-container

# Use --new to create fresh container on restart
podman generate systemd --new --name my-container
```

### Pod Service Conversion

```bash
# Convert entire Pod to systemd service
podman generate systemd --pod --name my-pod
```

### Service Management

```bash
# Enable as service
systemctl enable container-myapp

# Start/Stop/Restart
systemctl start container-myapp
systemctl stop container-myapp
systemctl restart container-myapp

# Check status
systemctl status container-myapp
```

### Comparison with Docker

| Feature | Docker | Podman |
|---------|--------|--------|
| systemd Integration | `--restart` policy only | Native integration, service file generation |
| Service Management | Via docker daemon | Direct systemctl management |
| Startup Order Control | Limited | Full systemd dependency support |
| Log Management | Proprietary | journalctl integration possible |

### Practical Example: Running Containers as System Services

```bash
# 1. Create container
podman run -d --name webapp -p 8080:80 nginx

# 2. Generate systemd service
podman generate systemd --name webapp --new > /etc/systemd/system/container-webapp.service

# 3. Enable with systemd
systemctl daemon-reload
systemctl enable --now container-webapp
```

Now the **container automatically starts on server reboot** and is fully manageable via `systemctl`.

---

## 📁 Examples

| Example | Description |
|---------|-------------|
| [01-basic-container](example/01-basic-container/) | Basic container execution (nginx) |
| [02-pod-example](example/02-pod-example/) | Pod: Group multiple containers |
| [03-systemd-service](example/03-systemd-service/) | systemd integration: Service-ize containers |
| [04-dockerfile-example](example/04-dockerfile-example/) | Build from Dockerfile |
| [05-claudecode-example](example/05-claudecode-example/) | Claude Code CLI embedded container |
| [06-envfile-example](example/06-envfile-example/) | Environment variable management with .env |
| [07-compose-example](example/07-compose-example/) | docker-compose.yml compatible |
| [08-compose-claudecode](example/08-compose-claudecode/) | Claude Code + Alibaba Qwen compose |
| [09-freeze-screenshot](example/09-freeze-screenshot/) | Terminal screenshots with freeze |
| [10-cron-office-work](example/10-cron-office-work/) | Claude Meeting Bot (cron + AI) |

---

## 🚀 Basic Usage

```bash
# Pull image
podman pull ubuntu

# Run container
podman run -it ubuntu /bin/bash

# List containers
podman ps -a

# List images
podman images

# Remove container
podman rm <container_id>

# Remove image
podman rmi <image_id>
```

### Docker Command Compatibility

Most `docker` commands work by simply replacing with `podman`:

```bash
# Docker
docker run -d -p 80:80 nginx

# Podman (works the same)
podman run -d -p 80:80 nginx
```

---

## 📊 Summary

| Requirement | Recommendation |
|-------------|----------------|
| Efficiently run a few containers | Podman |
| Run containers securely rootless | Podman |
| Integrate with systemd for service management | Podman |
| Run many containers concurrently | Consider Docker |
| Leverage existing Docker ecosystem | Docker |

**Podman's key strengths: "Containers as native systemd services", "Better memory efficiency", "Enhanced security"**

---

## 📚 References

- [Podman Official Documentation](https://podman.io/)
- [Red Hat - Podman Getting Started](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/building_running_and_managing_containers)
- [Podman GitHub](https://github.com/containers/podman)
