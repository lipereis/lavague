#!/bin/bash
# LA VAGUE Bot — One-Command Setup
# Run: ./scripts/setup.sh

set -e

echo "🌊 LA VAGUE Bot Setup"
echo "====================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check Hermes installation
echo -e "\n${YELLOW}Checking Hermes installation...${NC}"
if ! command -v hermes &> /dev/null; then
    echo -e "${RED}Hermes not found. Installing...${NC}"
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        irm https://hermes-agent.nousresearch.com/install.ps1 | iex
    else
        # Linux/macOS
        curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
    fi
else
    echo -e "${GREEN}✓ Hermes found: $(hermes --version)${NC}"
fi

# Check Hermes health
echo -e "\n${YELLOW}Running Hermes health check...${NC}"
hermes doctor || true

# Setup config directory
echo -e "\n${YELLOW}Setting up config...${NC}"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
mkdir -p "$HERMES_HOME"

# Copy config.yaml
if [ -f "config/config.yaml" ]; then
    cp config/config.yaml "$HERMES_HOME/config.yaml"
    echo -e "${GREEN}✓ Config copied to $HERMES_HOME/config.yaml${NC}"
else
    echo -e "${RED}config/config.yaml not found${NC}"
fi

# Setup .env
if [ ! -f "$HERMES_HOME/.env" ]; then
    cp config/.env.example "$HERMES_HOME/.env"
    echo -e "${YELLOW}Created .env template at $HERMES_HOME/.env${NC}"
    echo -e "${RED}⚠ Edit $HERMES_HOME/.env with your tokens!${NC}"
else
    echo -e "${GREEN}✓ .env already exists${NC}"
fi

# Install custom skill
echo -e "\n${YELLOW}Installing la-vague-radar-curator skill...${NC}"
SKILLS_DIR="$HERMES_HOME/skills"
mkdir -p "$SKILLS_DIR"
if [ -d "skills/la-vague-radar-curator" ]; then
    cp -r skills/la-vague-radar-curator "$SKILLS_DIR/"
    echo -e "${GREEN}✓ Skill installed to $SKILLS_DIR/la-vague-radar-curator${NC}"
else
    echo -e "${RED}Skill directory not found${NC}"
fi

# Create Obsidian vault directory
echo -e "\n${YELLOW}Setting up Obsidian vault...${NC}"
VAULT_PATH="${OBSIDIAN_VAULT_PATH:-$HOME/Documents/Obsidian Vault/LA_VAGUE}"
mkdir -p "$VAULT_PATH"
echo -e "${GREEN}✓ Vault directory: $VAULT_PATH${NC}"

# Create initial vault files
cat > "$VAULT_PATH/LA VAGUE Radar.md" << 'EOF'
---
tags: [radar, editorial, cinema, fashion, music]
created: {{date}}
status: active
---

# LA VAGUE Radar

Central hub for cultural radar sweeps.

## Latest Sweeps
- [[LA VAGUE Radar - 2026-08-27]]

## Sources Tracked
- Criterion Daily
- MUBI Notebook
- SSENSE Editorial
- Dazed Digital
- Highsnobiety
- Crack Magazine

## Tags
#radar #editorial #cinema #fashion #music
EOF

cat > "$VAULT_PATH/Editorial Calendar.md" << 'EOF'
---
tags: [calendar, editorial, planning]
created: {{date}}
status: active
---

# Editorial Calendar

## This Week
- [ ] Daily radar sweeps (Mon-Fri 09:00)
- [ ] Weekly review (Fri 10:00)
- [ ] Auto-post approved (Fri 14:00)

## Status Legend
- 🟢 `draft` — Radar output, needs review
- 🟡 `selected` — Chosen for development
- 🔵 `approved` — Ready to publish
- 🟣 `published` — Live
- ⚪ `archived` — Not pursuing

## Current Items
| Date | Title | Intersection | Status | Links |
|------|-------|--------------|--------|-------|
| | | | | |
EOF

cat > "$VAULT_PATH/Visual References.md" << 'EOF'
---
tags: [visual, references, moodboard]
created: {{date}}
status: active
---

# Visual References

Central moodboard for LA VAGUE editorial visuals.

## By Intersection
### Cinema → Fashion
- [[Wong Kar-wai color palette]]
- [[Royal Tenenbaums uniform]]

### Cinema → Music
- [[Drive neon noir]]
- [[Phantom Thread score]]

### Fashion → Music
- [[Runway show scores]]
- [[Music video directors]]

## By Publication
- Criterion: Frame grabs
- SSENSE: Editorial spreads
- Dazed: Fashion film stills
EOF

echo -e "${GREEN}✓ Initial vault files created${NC}"

# Final instructions
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Edit $HERMES_HOME/.env with your Discord token"
echo "2. Run: hermes gateway run"
echo "3. Test in Discord: @La Vague ping"
echo -e "\n${YELLOW}Key Files:${NC}"
echo "  Config: $HERMES_HOME/config.yaml"
echo "  Env:    $HERMES_HOME/.env"
echo "  Skill:  $HERMES_HOME/skills/la-vague-radar-curator/"
echo "  Vault:  $VAULT_PATH"
echo -e "\n${YELLOW}Start Gateway:${NC}"
echo "  hermes gateway run          # Foreground (testing)"
echo "  hermes gateway install      # Background (Windows Scheduled Task)"
echo "  hermes gateway start        # Start background service"
echo -e "\n${YELLOW}Cron Jobs:${NC}"
echo "  hermes cronjob create --from-file cron/jobs.yaml"
echo "  hermes cronjob list"
echo -e "\n${GREEN}Happy editing! 🌊${NC}"