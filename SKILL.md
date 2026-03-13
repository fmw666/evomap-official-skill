---
name: evomap-official-skill
description: EvoMap linkage and automation skill. Triggered by "evomap" keyword, slash commands (/dashboard, /node, /help, /global), or natural language intents. Provides real-time data from evomap.ai.
---

# EvoMap Official Skill

This skill handles all interactions with the EvoMap (GEP) network. It strictly separates logic from visual presentation and enforces concise, template-based communication.

## ⚠️ Strict Output Policy
1. **No Fluff**: When a command (/dashboard, /node, /help) is executed, the agent MUST output the template result DIRECTLY. 
2. **Concise Replies**: Avoid conversational filler (e.g., "Here is your dashboard", "I've fetched the data for you").
3. **Template Supremacy**: Use only the approved Markdown templates in `assets/templates/`.

## Trigger & Intent Logic

### 1. Dashboard View
- **Trigger**: `evomap /dashboard [lang]`, `evomap 面板`, "进化看板"
- **Action**: Runs `scripts/dashboard.sh`.

### 2. Node Status
- **Trigger**: `evomap /node [node_id] [lang]`, `evomap 节点 [ID]`
- **Action**: Runs `scripts/node_status.sh`.

### 3. Help & Commands
- **Trigger**: `evomap /help`, `evomap 帮助`
- **Action**: Runs `scripts/help.sh`.

### 4. Fallback (Intent Guessing)
- **Condition**: User mentions "evomap" but no slash command or specific intent is recognized.
- **Action**: The agent must guess the user's intent and suggest 2-3 relevant endpoints from `/help`.
- **Example**: "evomap 怎么玩" -> Suggest `/help` and `/dashboard`.

## Template Architecture
- **Logic**: Bash scripts in `scripts/` fetch API data and export to environment variables prefixed with `EVO_`.
- **Rendering**: `scripts/render_template.py` extracts language sections from Markdown files and replaces `{{VARIABLE}}` placeholders.
- **Assets**: Combined Markdown files in `assets/templates/`.

## Bundled Resources
- **Scripts**:
  - `dashboard.sh`: Evolution overview.
  - `node_status.sh`: Node identity and metrics.
  - `help.sh`: Command list.
  - `render_template.py`: Multi-language template engine.
- **Assets**:
  - `templates/dashboard.md`: MD template for dashboard.
  - `templates/node.md`: MD template for node status.
- **References**:
  - `api_reference.md`: A2A protocol documentation.
