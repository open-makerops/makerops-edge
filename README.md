# MakerOps Edge

MakerOps Edge is the per-developer bundle of the MakerOps spoke-and-hub system. Install it on each team member's computer to bring AI assistant services and local integrations close to where work happens.

The companion **MakerOps Core** collection is installed in a central location — a shared server or team machine — and provides services that Edge devices and the whole team can access together. Edge can connect to Core for a fully self-hosted setup, or use cloud AI providers standalone.

Each service runs as an independent, fully isolated Docker Compose project. Supported install environments include Linux, macOS, and WSL2 on Windows.

Services are organized by category:

- [ai/](ai/README.md) — AI assistants and local inference services

## Services

| Service | Port | Purpose | Idle RAM | Base Storage |
| ------- | ---- | ------- | -------- | ------------ |
| [OpenHuman](https://github.com/tinyhumansai/openhuman) | [7788](http://localhost:7788) | Personal AI assistant core — JSON-RPC server for AI workflows, memory, and integrations | ~200 MB | ~2 GB (image) |

## System Requirements

| Resource | Minimum | Notes |
| -------- | ------- | ----- |
| RAM | 4 GB available | Default container limit; configurable via `OPENHUMAN_CORE_MEM_LIMIT` |
| Disk | 10 GB | ~2 GB for the Docker image (Rust build); workspace volume grows with use |
| CPU | 2 cores | Configurable via `OPENHUMAN_CORE_CPUS` |

## Service Environment Files

Each service reads configuration from a `.env` file in its directory. On first start, `start.sh` auto-creates `.env` from `.env.example` and generates any required secrets. `.env` files are git-ignored and never committed.

| Service | Config file | Key variables |
| ------- | ----------- | ------------- |
| OpenHuman | `ai/openhuman/.env` | `OPENHUMAN_CORE_TOKEN`, `OPENHUMAN_REPO_PATH` |

---

## Prerequisites

- [Docker Engine 24+](https://docs.docker.com/engine/install/)
- [Docker Compose v2.24+](https://docs.docker.com/compose/install/)
- `openssl` — for automatic secret generation on first start
- `git` — to clone service source repositories before building

## Individual Service Control

```bash
cd ai/openhuman && ./start.sh
```

## First Run Notes

### OpenHuman

- The openhuman repo must be cloned before first start — see [ai/openhuman/README.md](ai/openhuman/README.md) for setup instructions
- `OPENHUMAN_CORE_TOKEN` is auto-generated and saved to `ai/openhuman/.env` on first start
- **Keep `ai/openhuman/.env` backed up** — losing `OPENHUMAN_CORE_TOKEN` requires reconfiguring all RPC clients

## Data Persistence

All service data is stored in Docker named volumes scoped to each project. Stopping a service preserves all data.

To remove a service's data volumes (destructive — cannot be undone):

```bash
cd <category>/<service> && ./stop.sh --volumes
```

## Architecture Notes

Each service is a separate Docker Compose project with its own network, volumes, and container namespace. Services share only the host network interface via distinct ports.

| Service | Docker project | Storage |
| ------- | -------------- | ------- |
| OpenHuman | `openhuman` | `openhuman-workspace` volume (SQLite + memory trees) |
