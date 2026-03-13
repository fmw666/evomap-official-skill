---
name: evomap-official-skill
description: EvoMap linkage and automation skill. Triggered by "evomap" keyword, slash commands (/dashboard, /node, /help, /config), or natural language intents.
---

# EvoMap Official Skill

This skill handles all interactions with the EvoMap (GEP) network. It strictly separates logic from visual presentation and uses a persistent configuration system.

## ⚠️ Absolute Output Law (MANDATORY)
1. **ZERO Conversational Filler**: Do NOT output any conversational text.
2. **Template Only**: The final response MUST contain ONLY the rendered content of the corresponding template.
3. **Clean Execution**: Output the result of the script/template directly.

## Endpoints Definition

### 1. Configuration Management
- **Condition**: User wants to view or change settings (e.g., language).
- **Trigger**: `evomap /config [key] [value]`, `evomap 设置`
- **Action**: Runs `scripts/config.sh [key] [value]`.
- **Template**: `assets/templates/config.md` or `config_update.md`.
- **Example**: `evomap /config language zh`

### 2. Dashboard View
- **Condition**: User wants to see the overall status of the node and network.
- **Trigger**: `evomap /dashboard`, `evomap 面板`
- **Action**: Runs `scripts/dashboard.sh [node_id] [query]`.
- **Template**: `assets/templates/dashboard.md`.

### 3. Node Status
- **Condition**: User wants detailed metrics for the current node.
- **Trigger**: `evomap /node`, `evomap 节点`
- **Action**: Runs `scripts/node_status.sh [node_id] [query]`.
- **Template**: `assets/templates/node.md`.

### 4. Help & Commands
- **Condition**: User needs instructions.
- **Trigger**: `evomap /help`, `evomap 帮助`
- **Action**: Runs `scripts/help.sh [query]`.
- **Template**: `assets/templates/help.md`.

## Template Architecture
- **Persistent Config**: Stored at `config.json` in the skill root directory.
- **Rendering Engine**: `scripts/render_template.js` (Node.js) automatically merges persisted config with environment variables and injects them into templates.

## Bundled Resources
- **Config**:
  - `config.json`: Default settings for language and node ID.
- **Scripts**:
  - `config.sh`: Entry point for settings.
  - `config_manager.js`: Logic for reading/writing config.
  - `render_template.js`: Core rendering engine.
  - `dashboard.sh`, `node_status.sh`, `help.sh`: Functional commands.
- **Assets**:
  - `templates/config.md`, `templates/config_update.md`: YAML-style config templates.
  - `templates/dashboard.md`, `templates/node.md`, `templates/help.md`: Command templates.
