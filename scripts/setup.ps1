<# 
.SYNOPSIS
    LA VAGUE Bot — One-Command Setup for Windows
.DESCRIPTION
    Installs Hermes, configures LA VAGUE bot, installs custom skill, sets up Obsidian vault.
.EXAMPLE
    .\scripts\setup.ps1
#>

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Colors
$Green = [ConsoleColor]::Green
$Yellow = [ConsoleColor]::Yellow
$Red = [ConsoleColor]::Red
$Gray = [ConsoleColor]::DarkGray

function Write-Color($Message, $Color) {
    Write-Host $Message -ForegroundColor $Color
}

Write-Color "🌊 LA VAGUE Bot Setup" $Yellow
Write-Color "=====================" $Yellow

# Check Hermes installation
Write-Color "`n[1/6] Checking Hermes installation..." $Yellow
if (-not (Get-Command hermes -ErrorAction SilentlyContinue)) {
    Write-Color "Hermes not found. Installing..." $Red
    irm https://hermes-agent.nousresearch.com/install.ps1 | iex
} else {
    $version = hermes --version
    Write-Color "✓ Hermes found: $version" $Green
}

# Health check
Write-Color "`n[2/6] Running Hermes health check..." $Yellow
hermes doctor

# Setup config directory
Write-Color "`n[3/6] Setting up config..." $Yellow
$HermesHome = $env:HERMES_HOME ?? "$env:APPDATA\hermes"
if (-not (Test-Path $HermesHome)) {
    New-Item -ItemType Directory -Force -Path $HermesHome | Out-Null
}

# Copy config.yaml
if (Test-Path "config\config.yaml") {
    Copy-Item "config\config.yaml" "$HermesHome\config.yaml" -Force
    Write-Color "✓ Config copied to $HermesHome\config.yaml" $Green
} else {
    Write-Color "config\config.yaml not found" $Red
}

# Setup .env
$EnvPath = "$HermesHome\.env"
if (-not (Test-Path $EnvPath)) {
    Copy-Item "config\.env.example" $EnvPath -Force
    Write-Color "Created .env template at $EnvPath" $Yellow
    Write-Color "⚠ Edit $EnvPath with your tokens!" $Red
} else {
    Write-Color "✓ .env already exists" $Green
}

# Install custom skill
Write-Color "`n[4/6] Installing la-vague-radar-curator skill..." $Yellow
$SkillsDir = "$HermesHome\skills"
New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null
if (Test-Path "skills\la-vague-radar-curator") {
    Copy-Item "skills\la-vague-radar-curator" "$SkillsDir\" -Recurse -Force
    Write-Color "✓ Skill installed to $SkillsDir\la-vague-radar-curator" $Green
} else {
    Write-Color "Skill directory not found" $Red
}

# Create Obsidian vault
Write-Color "`n[5/6] Setting up Obsidian vault..." $Yellow
$VaultPath = $env:OBSIDIAN_VAULT_PATH ?? "$env:USERPROFILE\Documents\Obsidian Vault\LA_VAGUE"
New-Item -ItemType Directory -Force -Path $VaultPath | Out-Null
Write-Color "✓ Vault directory: $VaultPath" $Green

# Create initial vault files
$VaultFiles = @{
    "LA VAGUE Radar.md" = @"
---
tags: [radar, editorial, cinema, fashion, music]
created: $(Get-Date -Format 'yyyy-MM-dd')
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
"@
    "Editorial Calendar.md" = @"
---
tags: [calendar, editorial, planning]
created: $(Get-Date -Format 'yyyy-MM-dd')
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
|      |       |              |        |       |
"@
    "Visual References.md" = @"
---
tags: [visual, references, moodboard]
created: $(Get-Date -Format 'yyyy-MM-dd')
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
"@
}

foreach ($file in $VaultFiles.Keys) {
    $path = Join-Path $VaultPath $file
    $content = $VaultFiles[$file]
    $content | Set-Content -Path $path -Encoding UTF8
}

Write-Color "✓ Initial vault files created" $Green

# Final instructions
Write-Color "`n========================================" $Green
Write-Color "✅ Setup Complete!" $Green
Write-Color "========================================$NC" $Green

Write-Color "`nNext Steps:" $Yellow
Write-Color "1. Edit $HermesHome\.env with your Discord token" $Yellow
Write-Color "2. Run: hermes gateway run" $Yellow
Write-Color "3. Test in Discord: @La Vague ping" $Yellow

Write-Color "`nKey Files:" $Yellow
Write-Color "  Config: $HermesHome\config.yaml"
Write-Color "  Env:    $HermesHome\.env"
Write-Color "  Skill:  $HermesHome\skills\la-vague-radar-curator\"
Write-Color "  Vault:  $VaultPath"

Write-Color "`nStart Gateway:" $Yellow
Write-Color "  hermes gateway run          # Foreground (testing)"
Write-Color "  hermes gateway install      # Background (Windows Scheduled Task)"
Write-Color "  hermes gateway start        # Start background service"

Write-Color "`nCron Jobs:" $Yellow
Write-Color "  hermes cronjob create --from-file cron/jobs.yaml"
Write-Color "  hermes cronjob list"

Write-Color "`nHappy editing! 🌊" $Green