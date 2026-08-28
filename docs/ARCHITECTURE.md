# LA VAGUE Bot — Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        LA VAGUE BOT                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │   Discord    │    │   Gateway    │    │   Hermes     │      │
│  │   Platform   │◀──▶│   Runner     │◀──▶│   Agent      │      │
│  └──────────────┘    └──────────────┘    └──────┬───────┘      │
│                                                  │              │
│                    ┌──────────────┐              │              │
│                    │   Skills     │◀─────────────┘              │
│                    └──────┬───────┘                             │
│                          │                                      │
│         ┌────────────────┼────────────────┐                     │
│         ▼                ▼                ▼                     │
│   ┌───────────┐    ┌───────────┐    ┌───────────┐              │
│   │  Obsidian │    │  Cron     │    │  External │              │
│   │   Vault   │    │  Scheduler│    │   APIs    │              │
│   └───────────┘    └───────────┘    └───────────┘              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Core Components

### 1. Hermes Agent (Core)
- **LLM Provider**: NVIDIA Nemotron 3 Ultra (configurable)
- **Memory**: Persistent SQLite + FTS5 search
- **Skills**: Modular, hot-reloadable capabilities
- **Tools**: File, terminal, web, browser, MCP

### 2. Gateway Runner (Messaging)
- **Platform**: Discord (extensible to Telegram, Slack, etc.)
- **Session Management**: Per-user/channel threading
- **Authorization**: Allowlist/pairing/open policies
- **Delivery**: Multi-channel, multi-format

### 3. LA VAGUE Radar Skill
- **Sources**: 12 cultural publications
- **Workflow**: Search → Curate → Draft → Output
- **Output**: Instagram carousel + Substack essay (PT-BR)
- **Storage**: Obsidian vault with wiki-links

### 4. Cron Scheduler
- **Jobs**: YAML-defined, skill-aware
- **Triggers**: Cron expressions
- **Delivery**: Multi-target (Discord, Substack, Instagram)
- **Persistence**: SQLite with recovery

### 5. Obsidian Vault (Knowledge Base)
- **Structure**: Atomic notes, wiki-links, tags
- **Sync**: Local-first, git-compatible
- **Content**: Radar drafts, calendar, visual refs

## Data Flow

### Radar Sweep
```
1. Scheduled cron (09:00) triggers skill
2. Skill searches 12 sources via web search
3. Filters & curates cross-disciplinary intersections
3. Generates 4 drafts (carousel + essay each)
4. Saves to Obsidian with wiki-links + tags
5. Sends Discord digest
```

### Editorial Pipeline
```
Radar Draft → Review (manual) → Selected → Approved → Published
     ↓              ↓              ↓           ↓          ↓
  #draft        #selected      #approved   #published  #archived
```

### Auto-Post
```
Cron (Fri 14:00) → Check Calendar for #approved
     ↓
  For each: Post to Discord + Substack + Instagram
     ↓
  Update Calendar → #published + URLs
```

## Configuration Layers

```
┌─────────────────────────────────────┐
│  config.yaml (Hermes core)          │
├─────────────────────────────────────┤
│  .env (secrets)                     │
├─────────────────────────────────────┤
│  config.yaml (gateway platforms)    │
├─────────────────────────────────────┤
│  cron/jobs.yaml (automation)        │
├─────────────────────────────────────┤
│  skills/la-vague-radar-curator/     │
└─────────────────────────────────────┘
```

## Security Model

| Layer | Protection |
|-------|------------|
| **Secrets** | `.env` only (gitignored), env vars at runtime |
| **Discord** | Token in `.env`, allowlist/pairing policies |
| **Substack** | API key in `.env`, publication-scoped |
| **Instagram** | Tokens in `.env`, short-lived access tokens |
| **Obsidian** | Local filesystem, no cloud sync required |

## Scaling Considerations

| Dimension | Current | Scaling Path |
|-----------|---------|--------------|
| **Platforms** | Discord | Add Telegram, Slack via platform adapters |
| **Sources** | 12 pubs | Add RSS/NewsAPI, custom scrapers |
| **Output** | Discord/Substack/IG | Add Twitter, LinkedIn, newsletter |
| **Frequency** | Daily | Hourly with rate limiting |
| **Team** | Solo | Multi-user with profile multiplexing |

## Failure Modes & Recovery

| Failure | Detection | Recovery |
|---------|-----------|----------|
| Gateway crash | Lifecycle ledger | Auto-restart via Scheduled Task |
| Discord disconnect | WebSocket liveness | Auto-reconnect with backoff |
| Cron job failure | Job logs + heartbeat | Retry with exponential backoff |
| Skill error | Structured logging | Fallback to cached drafts |
| Obsidian corruption | Git backup | `git restore` from vault |

## Monitoring & Observability

| Metric | Source | Alert |
|--------|--------|-------|
| Gateway uptime | Lifecycle ledger | Discord notification on crash |
| Cron success/failure | Job logs | Daily digest includes failures |
| Discord latency | WebSocket ping | Logged, threshold at 5s |
| Skill execution time | Agent turns | Logged per radar sweep |
| Vault size | File count | Monthly archive job |

## Deployment Options

### Local (Current)
- Runs on your machine
- Gateway as Windows Scheduled Task
- Zero cost, full control

### Cloud VM (Future)
- DigitalOcean/Hetzner/Fly.io ($5-20/mo)
- Docker Compose for Hermes + Gateway
- Persistent volume for vault + SQLite
- Cloudflare Tunnel for Discord webhook

### Managed (Nous Portal)
- Hosted Hermes + Gateway
- Better models (GPT-4o, Claude)
- Shared auth across devices
- Subscription-based

## Extensibility Points

| Extension Point | How |
|-----------------|-----|
| **New Platform** | Add adapter in `gateway/platforms/` |
| **New Source** | Add search pattern in skill |
| **New Output** | Add delivery target in cron job |
| **New Skill** | Drop in `~/.hermes/skills/` |
| **New Command** | Add to skill's command handler |

## File Locations (Windows)

| Component | Path |
|-----------|------|
| Hermes Config | `%APPDATA%\hermes\config.yaml` |
| Env Secrets | `%APPDATA%\hermes\.env` |
| Skills | `%APPDATA%\hermes\skills\` |
| Gateway Logs | `%APPDATA%\hermes\logs\gateway.log` |
| State DB | `%APPDATA%\hermes\state.db` |
| Cron DB | `%APPDATA%\hermes\cron\executions.db` |
| Obsidian Vault | `Documents\Obsidian Vault\LA_VAGUE\` |