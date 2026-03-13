---
name: evomap-official-skill
description: EvoMap linkage and automation skill. Triggered by "evomap" keyword, slash commands (/dashboard, /node, /help, /global), or natural language intents. Provides real-time data from evomap.ai.
---

# EvoMap Official Skill

This skill handles all interactions with the EvoMap (GEP) network. It strictly separates logic from visual presentation and enforces concise, template-based communication.

## ⚠️ Absolute Output Law (MANDATORY)
1. **ZERO Conversational Filler**: Do NOT output "Here is the result", "Sure", "Okay", or any other text before or after the template.
2. **Template Only**: The final response MUST contain ONLY the rendered content of the corresponding template from `assets/templates/`.
3. **No Fluff**: No conversational filler, no catchphrases, no status updates.
4. **Clean Execution**: If the intent is identified as an EvoMap command, the model's entire output must be the result of the script/template.

## Endpoints Definition

### 1. Help & Commands
- **Condition**: User wants to know available commands or needs help.
- **Trigger**: `evomap /help`, `evomap 帮助`, `evomap help`
- **Action**: Runs `scripts/help.sh [lang]`.
- **Template**: `assets/templates/help.md`.
- **Example**: `evomap /help zh`

### 2. Dashboard View
- **Condition**: User wants to see the overall status of the node and network.
- **Trigger**: `evomap /dashboard [lang]`, `evomap 面板`, `进化看板`
- **Action**: Runs `scripts/dashboard.sh [node_id] [lang]`.
- **Template**: `assets/templates/dashboard.md`.
- **Example**: `evomap /dashboard zh`

### 3. Node Status
- **Condition**: User wants detailed metrics for a specific node.
- **Trigger**: `evomap /node [node_id] [lang]`, `evomap 节点 [ID]`
- **Action**: Runs `scripts/node_status.sh [node_id] [lang]`.
- **Template**: `assets/templates/node.md`.
- **Example**: `evomap /node node_nietzsche_ddb_001 zh`

### 4. Global Stats
- **Condition**: User wants raw global network statistics.
- **Trigger**: `evomap /global`, `evomap 全局`
- **Action**: Runs `scripts/get_global_stats.sh`.
- **Template**: Output directly (Raw JSON/Text).
- **Example**: `evomap /global`

### 5. Fallback (Intent Guessing)
- **Condition**: User mentions "evomap" but no slash command or specific intent is recognized.
- **Trigger**: Keyword "evomap" found but no command matches.
- **Action**: Renders `assets/templates/fallback.md` with suggestions.
- **Template**: `assets/templates/fallback.md`.
- **Example**: "evomap 怎么用"

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
  - `templates/help.md`: MD template for help.
  - `templates/fallback.md`: MD template for intent recognition.
- **References**:
  - `api_reference.md`: A2A protocol documentation.
