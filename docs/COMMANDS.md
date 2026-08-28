# LA VAGUE Bot — Command Reference

## Discord Commands

### Mentions (in any channel)
| Command | Description | Example |
|---------|-------------|---------|
| `@La Vague ping` | Health check | `@La Vague ping` |
| `@La Vague help` | Show all commands | `@La Vague help` |
| `@La Vague status` | Gateway/platform status | `@La Vague status` |
| `@La Vague radar` | Run cultural radar sweep | `@La Vague radar` |
| `@La Vague scan culture` | Alias for radar | `@La Vague scan culture` |

### Editorial Commands
| Command | Description | Example |
|---------|-------------|---------|
| `@La Vague draft carousel [topic]` | Generate Instagram carousel | `@La Vague draft carousel "Wong Kar-wai color palette"` |
| `@La Vague draft essay [topic]` | Generate Substack essay prompt | `@La Vague draft essay "Drive neon noir → Y2K revival"` |
| `@La Vague draft carousel "Royal Tenenbaums fashion"` | Specific carousel | `@La Vague draft carousel "Royal Tenenbaums fashion"` |

### Obsidian Integration
| Command | Description | Example |
|---------|-------------|---------|
| `@La Vague save to [[Note Name]]` | Save content to Obsidian | `@La Vague save this to [[Content Calendar]]` |
| `@La Vague save to [[Note]] with tag #tag` | Save with tag | `@La Vague save to [[Visual References]] with tag #moodboard` |
| `@La Vague search [query]` | Search vault | `@La Vague search "Wong Kar-wai"` |
| `@La Vague search web [query]` | Web search | `@La Vague search web "Criterion Wong Kar-wai"` |

### Content Management
| Command | Description | Example |
|---------|-------------|---------|
| `@La Vague review [[Note]]` | Review/edit note | `@La Vague review [[Content Calendar]]` |
| `@La Vague finalize carousel [title]` | Polish carousel draft | `@La Vague finalize carousel "Wong Kar-wai"` |
| `@La Vague schedule post friday 10am` | Create cron job | `@La Vague schedule post friday 10am` |

### Publishing
| Command | Description | Example |
|---------|-------------|---------|
| `@La Vague publish to substack "Title" "Content"` | Publish to Substack | `@La Vague publish to substack "Title" "Content"` |
| `@La Vague post to instagram --images "url1,url2" --caption "text"` | Post to Instagram | `@La Vague post carousel to instagram --images "..." --caption "..."` |
| `@La Vague post "Message" to #channel` | Post to Discord | `@La Vague post "Hello" to #general` |
| `@La Vague dm me "Message"` | Send DM | `@La Vague dm me "Test"` |

### Debug & Config
| Command | Description | Example |
|---------|-------------|---------|
| `@La Vague debug channel-dir` | Show channel directory | `@La Vague debug channel-dir` |
| `@La Vague debug allowlist` | Show allowlist | `@La Vague debug allowlist` |
| `@La Vague reload config` | Hot-reload config | `@La Vague reload config` |

---

## Slash Commands (type `/`)

| Command | Description |
|---------|-------------|
| `/skill` | Browse 77 skills (autocomplete) |
| `/help` | Show help |
| `/status` | Gateway status |
| `/radar` | Quick radar sweep |
| `/draft` | Quick draft (carousel/essay) |

---

## Natural Language Patterns

The bot understands conversational commands:

```
"run a radar sweep"
"scan for new cultural intersections"
"create a carousel about Drive's influence on fashion"
"write an essay prompt about film composers scoring runway shows"
"save this to my content calendar"
"what's in my editorial calendar?"
"post this to discord general channel"
"schedule a daily radar at 9am"
"publish this essay to substack"
```

---

## Cron Job Commands (via bot)

```
@La Vague schedule daily radar at 9am
@La Vague schedule weekly review friday 10am
@La Vague schedule auto-post friday 2pm
@La Vague list cron jobs
@La Vague run cron job la-vague-daily-radar
@La Vague pause cron job la-vague-weekly-review
@La Vague resume cron job la-vague-weekly-review
```

---

## Obsidian Vault Structure

```
LA_VAGUE/
├── LA VAGUE Radar.md           # Radar hub
├── LA VAGUE Radar - YYYY-MM-DD.md  # Individual sweeps
├── Editorial Calendar.md       # Content pipeline
├── Visual References.md        # Moodboard hub
├── Content/
│   ├── Carousels/              # Carousel drafts
│   ├── Essays/                 # Essay drafts
│   └── Published/              # Published items
├── Archive/
│   └── YYYY-MM/                # Monthly archives
└── Sources/
    ├── Cinema/
    ├── Fashion/
    └── Music/
```

---

## Content Calendar Status Flow

```
draft → selected → approved → published
  ↓         ↓          ↓          ↓
radar    review     finalize    post
output   meeting    assets      live
```

### Status Tags
- `#draft` — Radar output, needs review
- `#selected` — Chosen for development
- `#approved` — Ready to publish
- `#published` — Live with URL
- `#archived` — Not pursuing

---

## Visual References Tags

| Category | Tags |
|----------|------|
| Cinema → Fashion | `#cinema-fashion` `#wardrobe` `#costume-design` |
| Cinema → Music | `#cinema-music` `#score` `#soundtrack` `#needle-drop` |
| Fashion → Music | `#fashion-music` `#runway-score` `#music-video` |
| Cross-discipline | `#intersection` `#cultural-pulse` `#zeitgeist` |

---

## Quick Reference Card

| Shortcut | Full Command |
|----------|--------------|
| `radar` | `@La Vague radar` |
| `carousel "topic"` | `@La Vague draft carousel "topic"` |
| `essay "topic"` | `@La Vague draft essay "topic"` |
| `save "note"` | `@La Vague save to [[note]]` |
| `post #channel "msg"` | `@La Vague post "msg" to #channel` |
| `dm "msg"` | `@La Vague dm me "msg"` |
| `status` | `@La Vague status` |
| `help` | `@La Vague help` |

---

## Pro Tips

1. **Thread replies** — Bot auto-threads in channels (configurable)
2. **DM for private work** — Use DMs for draft iterations
3. **Wiki-links** — Use `[[Note Name]]` for Obsidian links
3. **Tags** — Add `#tag` in messages for auto-tagging in Obsidian
4. **Iterate** — `@La Vague make slide 2 more analytical`
5. **Batch** — `@La Vague create 3 carousels from this week's radar`