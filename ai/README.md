# AI

Self-hosted AI services for local inference and agent workflows. Services run in isolated Docker Compose projects and are started individually on demand.

## Services

| Service | Port | Purpose |
| ------- | ---- | ------- |
| [OpenHuman](https://github.com/tinyhumansai/openhuman) | [7788](http://localhost:7788) | Personal AI assistant core — headless JSON-RPC server for AI workflows, memory, and 118+ integrations |

---

## Attribution

**OpenHuman** is open-source software developed and maintained by [tinyhumansai](https://github.com/tinyhumansai) and contributors, made freely available under the [GNU GPL v3 License](https://github.com/tinyhumansai/openhuman/blob/main/LICENSE).

---

## System Requirements

Unlike GPU-dependent LLM inference services, OpenHuman runs entirely on CPU with moderate RAM.

| Resource | Notes |
| -------- | ----- |
| RAM | 4 GB available (configurable via `OPENHUMAN_CORE_MEM_LIMIT` in `.env`) |
| Disk | ~2 GB for the Docker image (Rust multi-stage build); workspace volume grows with memory trees and cached integrations |
| CPU | 2 cores recommended (configurable via `OPENHUMAN_CORE_CPUS` in `.env`) |

See [openhuman/README.md](openhuman/README.md) for setup instructions and API usage.
