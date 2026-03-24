# Examples

Browse through our collection of practical Podman examples.

## Basic Examples

| Example | Description | Difficulty |
|--------|-------------|-----------|
| [01-basic-container](/examples/01-basic-container) | Simple nginx container | 🟢 Beginner |
| [02-pod-example](/examples/02-pod-example) | Multi-container pod | 🟡 Intermediate |
| [03-systemd-service](/examples/03-systemd-service) | systemd integration | 🟡 Intermediate |
| [04-dockerfile-example](/examples/04-dockerfile-example) | Custom Dockerfile | 🟡 Intermediate |

## Advanced Examples

| Example | Description | Difficulty |
|--------|-------------|-----------|
| [05-claudecode-example](/examples/05-claudecode-example) | Claude Code in container | 🔴 Advanced |
| [06-envfile-example](/examples/06-envfile-example) | Environment variables | 🟡 Intermediate |
| [07-compose-example](/examples/07-compose-example) | Docker Compose compatible | 🟡 Intermediate |
| [08-compose-claudecode](/examples/08-compose-claudecode) | Multi-service compose | 🔴 Advanced |
| [09-freeze-screenshot](/examples/09-freeze-screenshot) | Terminal screenshots | 🟡 Intermediate |
| [10-cron-office-work](/examples/10-cron-office-work) | Cron + AI automation | 🔴 Advanced |

## Quick Start

Each example includes:
- `run.sh` - Start the example
- `cleanup.sh` - Clean up resources
- `README.md` - Detailed instructions

## Running Examples

```bash
cd example/01-basic-container
./run.sh
```

## Cleanup

```bash
cd example/01-basic-container
./cleanup.sh
```

## Clean All

```bash
podman rm -af && podman rmi -af && podman pod rm -af
```
