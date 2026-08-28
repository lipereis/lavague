# LA VAGUE Bot — Setup Guide

## Prerequisites

- **Windows 10/11** (or Linux/macOS)
- **Hermes Agent** installed
- **Discord Bot** created (see below)
- **Obsidian** vault (optional but recommended)

## 1. Install Hermes Agent

```bash
# Windows (PowerShell)
irm https://hermes-agent.nousresearch.com/install.ps1 | iex

# Or Linux/macOS
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

Verify:
```bash
hermes --version
hermes doctor
```

## 2. Discord Bot Setup

### Create Bot
1. Go to https://discord.com/developers/applications
2. **New Application** → Name: "LA VAGUE"
3. **Bot** tab → **Add Bot**
4. **Privileged Gateway Intents** → Enable:
   - ✅ Message Content Intent
   - ✅ Server Members Intent
5. **Copy Token** (save securely!)

### Invite to Server
1. **OAuth2** → **URL Generator**
2. Scopes: `bot`, `applications.commands`
3. Permissions: Send Messages, Read Messages, Use Slash Commands, Embed Links, Attach Files, Read Message History
4. Copy URL → Open in browser → Add to your server

## 3. Configure Hermes

### Copy Config
```bash
cp config/.env.example config/.env
```

### Edit `.env` with Your Tokens
```env
# Discord (required)
DISCORD_BOT_TOKEN=your_bot_token_here
DISCORD_ALLOW_ALL_USERS=true

# Substack (optional)
SUBSTACK_API_KEY=sk_xxxxx
SUBSTACK_PUBLICATION_ID=lavaguemag

# Instagram (optional - requires Meta app review)
INSTAGRAM_APP_ID=
INSTAGRAM_APP_SECRET=
INSTAGRAM_ACCESS_TOKEN=
INSTAGRAM_BUSINESS_ID=
```

### Copy Hermes Config
```bash
# Hermes config goes to ~/.hermes/config.yaml (or %APPDATA%\hermes\config.yaml on Windows)
# Use the config.yaml from this repo as reference
```

## 4. Obsidian Vault (Optional)

```bash
# Create vault
mkdir -p ~/Obsidian/LA_VAGUE

# Or use existing vault
# Settings → Vault → Open folder as vault
```

## 4. Install Custom Skill

```bash
# The la-vague-radar-curator skill is in skills/
# Hermes auto-discovers skills in ~/.hermes/skills/
mkdir -p ~/.hermes/skills
cp -r skills/la-vague-radar-curator ~/.hermes/skills/
```

## 5. Start Gateway

```bash
# Foreground (for testing)
hermes gateway run

# Background (production)
hermes gateway install  # Installs as Windows Scheduled Task
hermes gateway start
```

## 6. Verify

```bash
# Check status
hermes gateway status

# Test bot in Discord
@La Vague ping

# Should respond with pong
```

## 5. Add Cron Jobs

```bash
# Daily radar sweep
hermes cronjob create \
  --name "la-vague-daily" \
  --schedule "0 9 * * *" \
  --prompt "Run LA VAGUE radar sweep, save 4 drafts to Obsidian, send digest to Discord" \
  --skills "la-vague-radar-curator,obsidian" \
  --deliver "discord:#general"

# List jobs
hermes cronjob list
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Bot offline | Check `hermes gateway status`, restart with `hermes gateway restart` |
| No reply | Check `DISCORD_ALLOW_ALL_USERS=true` in .env |
| Skill not found | Restart gateway after adding skill |
| Config not loading | Check `hermes config path` for correct config file |

## File Locations

| File | Location |
|------|----------|
| Hermes config | `~/.hermes/config.yaml` (Linux/macOS) / `%APPDATA%\hermes\config.yaml` (Windows) |
| Env file | `~/.hermes/.env` / `%APPDATA%\hermes\.env` |
| Skills | `~/.hermes/skills/` / `%APPDATA%\hermes\skills\` |
| Logs | `~/.hermes/logs/gateway.log` / `%APPDATA%\hermes\logs\gateway.log` |
| Obsidian vault | Your chosen path |

## Windows Specific

- Config: `%APPDATA%\hermes\config.yaml`
- Env: `%APPDATA%\hermes\.env`
- Skills: `%APPDATA%\hermes\skills\`
- Run `hermes gateway install` as Administrator for Scheduled Task