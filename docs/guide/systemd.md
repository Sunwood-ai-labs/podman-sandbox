# systemd Integration

Podman provides native integration with systemd for managing containers as system services.

## Overview

Podman can generate systemd service files for containers and pods, allowing them to:
- Start automatically on boot
- Be managed with standard systemctl commands
- Integrate with system logging (journalctl)

## Basic Usage

### Generate Service File

```bash
# For a container
podman generate systemd --name my-container

# With --new flag to recreate on start
podman generate systemd --new --name my-container

# For a pod
podman generate systemd --pod --name my-pod
```

### Service Location

```bash
# User services (rootless)
~/.config/systemd/user/

# System services (root)
/etc/systemd/system/
```

## Complete Example

### 1. Create Container

```bash
podman run -d --name webapp -p 8080:80 nginx:alpine
```

### 2. Generate Service File

```bash
mkdir -p ~/.config/systemd/user
podman generate systemd --new --name webapp > ~/.config/systemd/user/container-webapp.service
```

### 3. Enable and Start

```bash
systemctl --user daemon-reload
systemctl --user enable --now container-webapp
```

### 4. Verify

```bash
systemctl --user status container-webapp
```

## Service Management Commands

```bash
# Start service
systemctl --user start container-webapp

# Stop service
systemctl --user stop container-webapp

# Restart service
systemctl --user restart container-webapp

# View logs
journalctl --user -u container-webapp

# Enable on boot
systemctl --user enable container-webapp

# Disable on boot
systemctl --user disable container-webapp
```

## Advantages

| Feature | Docker | Podman |
|---------|--------|--------|
| Auto-start on boot | --restart flag | Native systemd |
| Service generation | Manual | Automatic |
| Log integration | Separate | journalctl |
| Dependency management | Limited | Full systemd support |

## Best Practices

1. **Use `--new` flag**: Ensures clean container state on each start
2. **User services for rootless**: Run containers as non-root user
3. **Pod services**: Group related containers together
4. **Enable linger**: Use `--stop-timeout` for clean shutdown
5. **Monitor logs**: Use journalctl for centralized logging
