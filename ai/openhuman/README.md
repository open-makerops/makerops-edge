# openhuman — Personal AI Assistant Core

OpenHuman is a headless Rust JSON-RPC server that powers a personal AI super intelligence. It manages memory trees, 118+ service integrations, web search, voice, and model routing behind a single authenticated RPC endpoint.

- **Home page / docs:** <https://github.com/tinyhumansai/openhuman>
- **GitHub:** <https://github.com/tinyhumansai/openhuman>
- **Discord:** <https://discord.gg/tinyhumans>

---

## Attribution

**OpenHuman** is open-source software developed and maintained by [tinyhumansai](https://github.com/tinyhumansai) and contributors, made freely available under the [GNU GPL v3 License](https://github.com/tinyhumansai/openhuman/blob/main/LICENSE).

---

## Obsidian Integration

OpenHuman pairs with [Obsidian](https://obsidian.md) — a local-first markdown knowledge base — to provide an improved human-AI interaction and cooperative thinking experience. Obsidian serves as the human-facing interface for notes, prompts, and memory review that feed into OpenHuman's memory trees and workflows.

> **Tip:** OpenHuman's workspace volume stores memory trees in Markdown format, making them directly readable and editable in Obsidian.

### Installing Obsidian

Download the installer from **[obsidian.md/download](https://obsidian.md/download)**, or install via package manager:

| Platform | Command |
| -------- | ------- |
| Windows (winget) | `winget install Obsidian.Obsidian` |
| macOS (Homebrew) | `brew install --cask obsidian` |
| Linux (Flatpak) | `flatpak install flathub md.obsidian.Obsidian` |
| Linux (Snap) | `snap install obsidian --classic` |
| Linux (apt / .deb) | Download the `.deb` from [obsidian.md/download](https://obsidian.md/download), then `sudo apt install ./obsidian-*.deb` |
| Arch Linux (AUR) | `yay -S obsidian` |

---

## AI Chat Service Requirement

OpenHuman requires a connected AI chat service (LLM backend) to function. You may use any commonly available service:

- **Cloud services:** OpenAI, Anthropic, Google Gemini, and others
- **Self-hosted:** MakerOps Core includes an **Ollama** service that can satisfy this requirement, enabling a fully local, offline-capable setup with no external API dependency

Configure the AI service endpoint and credentials in your `.env` file (see `.env.example` for available variables).

---

## Prerequisites

The openhuman Docker image is built from source. Clone the repo once before starting:

```bash
git clone https://github.com/tinyhumansai/openhuman.git ~/repos/openhuman
```

The clone path is configurable via `OPENHUMAN_REPO_PATH` in `.env` (default: `~/repos/openhuman`).

---

## Local Access

| | |
| --- | --- |
| **Health endpoint** | <http://localhost:7788/health> |
| **RPC endpoint** | <http://localhost:7788/rpc> |

---

## Setup

### Before first start

Clone the openhuman repo (see Prerequisites above). No other configuration is required — `start.sh` handles `.env` creation and token generation automatically.

### Start

```bash
./start.sh
```

On first run this will:
1. Create `.env` from `.env.example`
2. Generate `OPENHUMAN_CORE_TOKEN` and save it to `.env`
3. Build the `openhuman-core:local` Docker image from your local clone (~10–20 minutes the first time)
4. Start the container

Subsequent starts skip the build if the image already exists (Docker layer cache).

### Rebuild after pulling new source

```bash
cd ~/repos/openhuman && git pull
./start.sh  # --build flag is always passed; Docker rebuilds only changed layers
```

---

## Scripts

### `./start.sh`

Generates secrets on first run, builds the image if needed, and starts the container.

```bash
./start.sh
```

### `./stop.sh`

Stops the container. The `openhuman-workspace` volume (all memory trees and data) is preserved.

```bash
./stop.sh
```

### `./teardown.sh`

Interactive full teardown: shows what will be removed, prompts for confirmation, then deletes the container, volume, image, and network. **All memory trees, integrations, and cached data will be deleted.**

```bash
./teardown.sh
```

---

## Files

| File | Purpose |
| ---- | ------- |
| `docker-compose.yml` | Container definition — build, ports, security, volumes, health check |
| `.env.example` | Template for local configuration |
| `start.sh` | Generate secrets, build image, and start |
| `stop.sh` | Stop (workspace volume preserved) |
| `teardown.sh` | Full wipe with confirmation |

---

## Architecture

```text
RPC clients / desktop app / integrations
  └─► localhost:7788/rpc  (Bearer token required)
          └─► openhuman-core  (openhuman-core:local)
                ├─► localhost:7788/health  (health check, no auth)
                └─► openhuman-workspace volume  (/home/openhuman/.openhuman)
                      ├─► SQLite databases
                      └─► Memory trees (Markdown / Obsidian-compatible)
```

---

## Cheat Sheet

### Logs

```bash
docker compose -p openhuman logs -f
docker logs openhuman-core -f
```

### Shell access

```bash
docker exec -it openhuman-core bash
```

### Health check

```bash
curl http://localhost:7788/health
```

### RPC call (requires token)

```bash
TOKEN=$(grep OPENHUMAN_CORE_TOKEN .env | cut -d= -f2)
curl -H "Authorization: Bearer $TOKEN" http://localhost:7788/rpc
```

### View the core token

```bash
grep OPENHUMAN_CORE_TOKEN .env
```

### Upgrade

1. `cd ~/repos/openhuman && git pull`
2. `./stop.sh`
3. `./start.sh` — Docker rebuilds only changed layers; workspace volume is preserved
