# LA VAGUE Bot

> **Cinema × Fashion × Music** — Autonomous editorial radar & publishing bot

LA VAGUE is an AI-powered editorial assistant that scans cultural publications (Criterion, MUBI, SSENSE, Dazed, Highsnobiety, Crack Magazine, etc.), identifies intersections between cinema, fashion, and music, and produces publication-ready editorial drafts for Instagram carousels, Substack essays, and Discord distribution.

## Features

- 🎯 **Cultural Radar** — Scans 12+ publications for cinema/fashion/music intersections
- 📝 **Editorial Drafts** — Produces Instagram carousels + Substack essays with visual direction
- 💾 **Obsidian Integration** — Saves all output to vault with wiki-links, tags, frontmatter
- 🤖 **Discord Bot** — Slash commands, mentions, auto-posting, DM delivery
- ⏰ **Cron Jobs** — Automated radar sweeps, digests, publishing pipelines
- 🔒 **Local-First** — Runs on your machine, no cloud dependencies

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Cultural   │────▶│  LA VAGUE   │────▶│  Output     │
│  Sources    │     │  Bot        │     │  Channels   │
└─────────────┘     └─────────────┘     └─────────────┘
                           │
                    ┌──────┴──────┐
                    │  Obsidian   │
                    │   Vault     │
                    └─────────────┘
```

## Quick Start

```bash
# 1. Clone & setup
git clone https://github.com/yourusername/la-vague-bot.git
cd la-vague-bot
./scripts/setup.sh

# 2. Configure secrets
cp config/.env.example config/.env
# Edit config/.env with your tokens

# 3. Start gateway
hermes gateway run
```

## Bot Commands

| Command | Description |
|---------|-------------|
| `@La Vague radar` | Run cultural radar sweep |
| `@La Vague draft carousel [topic]` | Generate Instagram carousel |
| `@La Vague draft essay [topic]` | Generate Substack essay prompt |
| `@La Vague save to [[Note]]` | Save to Obsidian vault |
| `@La Vague status` | Gateway health check |
| `/skill` | Browse 77 skills |

## Automation

| Job | Schedule | Description |
|-----|----------|-------------|
| Daily Radar | 09:00 | Scan publications, produce 4 drafts |
| Weekly Digest | Fri 10:00 | Curate best drafts for review |
| Auto-Post | Fri 14:00 | Post approved content to Discord |

## Documentation

- [Setup Guide](docs/SETUP.md)
- [Command Reference](docs/COMMANDS.md)
- [Architecture](docs/ARCHITECTURE.md)

## License

MIT — Use freely for your own editorial projects.