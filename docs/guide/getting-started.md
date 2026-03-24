# Getting Started

This guide will help you set up Podman and run your first container.

## Prerequisites

- Linux, macOS, or Windows
- Podman installed

## Installation

### Linux (Fedora, RHEL, CentOS)

```bash
sudo dnf install podman
```

### macOS

```bash
brew install podman
```

### Windows

Download from [Podman GitHub releases](https://github.com/containers/podman/releases)

## Verify Installation

```bash
podman --version
```

## Run Your First Container

```bash
podman run -d --name hello-world -p 8080:80 docker.io/library/nginx:alpine
```

## Verify

```bash
podman ps
```

You should see your container running:

## Access the Container

Open your browser and navigate to `http://localhost:8080`

## Clean Up

```bash
podman rm -f hello-world
```

## Next Steps

- [Architecture Comparison](/guide/architecture) - Understand how Podman differs from Docker
- [Examples](/examples/) - Explore practical examples
- [systemd Integration](/guide/systemd) - Learn about systemd service management
