# Environment Variable Conventions

Common patterns and standards shared across all service `.env` files in this stack.

---

## Data Path Variables (`*_DATA_PATH`)

Every service exposes optional `*_DATA_PATH` variables that override where Docker stores persistent data on the host. When unset, data lands in subdirectories relative to the `docker-compose.yml` file (e.g. `./data`).

Override these when:
- You want to store data on a separate disk or mount point
- You need an absolute path for backup tooling
- You are migrating data from another location

Leave unset to use the service-local defaults shown in each `.env` file.

---

## Secret Generation

Services generate secrets automatically on first run via `start.sh`, but you can pre-generate them with:

```sh
# 64-character hex (32 bytes) — for bearer tokens and encryption keys
openssl rand -hex 32

# 32-character hex (16 bytes) — for shorter tokens
openssl rand -hex 16
```

### Never-change-after-first-run keys

The following keys authenticate or encrypt data. **Changing them after the first successful start will break existing clients or make stored data unreadable:**

| Service | Variable |
| ------- | -------- |
| OpenHuman | `OPENHUMAN_CORE_TOKEN` |

Back these up immediately after first start.

---

## Admin Credential Defaults

Stack-wide standard for initial admin accounts (first-run only; change after setup):

| Field | Default |
| ----- | ------- |
| Email | `admin@example.com` |
| Username | `admin` |
| Password | service-specific (see individual `.env`) |

---

## Environment File Backup

Local `.env` files contain secrets and are excluded from the git repository (see `.gitignore`). Back them up using an encrypted storage method of your choice before changing anything.
