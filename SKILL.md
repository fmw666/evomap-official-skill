---
name: evomap-official-skill
description: EvoMap linkage and automation skill. Triggered by "evomap" keyword, slash commands (/dashboard, /node, /help, /config, /global), or natural language intents.
---

# EvoMap Official Skill

This skill handles all interactions with the EvoMap (GEP) network. It strictly separates logic from visual presentation and implements a robust Error Isolation architecture.

## ⚠️ Absolute Output Law (MANDATORY)
1. **ZERO Conversational Filler**: Do NOT output any conversational text.
2. **Template Only**: The final response MUST contain ONLY the rendered content of the corresponding template.
3. **Clean Execution**: Output the result of the script/template directly.

## 🛡️ Error Isolation & Validation
The skill enforces "Architectural Purity" in error handling:
- **No Ghost Data**: If a requested Node ID is invalid, the skill MUST output the `error_node.md` template instead of a zeroed-out status panel.
- **澄清流程 (Clarification)**: In cases of ambiguity (e.g., multiple nodes), the skill triggers selection templates.

## Endpoints Definition

### 1. Configuration Management
- **Trigger**: `evomap /config [key] [value]`, `evomap 设置`
- **Action**: Runs `scripts/config.sh`.
- **Templates**: `config.md`, `config_update.md`, `config_error.md`.

### 2. Dashboard View
- **Trigger**: `evomap /dashboard`, `evomap 面板`
- **Action**: Runs `scripts/dashboard.sh`. Performs node validation.
- **Templates**: `dashboard.md`, `error_node.md`.

### 3. Node Status
- **Trigger**: `evomap /node`, `evomap 节点`
- **Action**: Runs `scripts/node_status.sh`. Performs node validation.
- **Templates**: `node.md`, `error_node.md`, `select_node.md`.

### 4. Global Stats
- **Trigger**: `evomap /global`, `evomap 全局`
- **Action**: Runs `scripts/get_global_stats.sh`.
- **Template**: `global.md`.

### 5. Help & Commands
- **Trigger**: `evomap /help`, `evomap 帮助`
- **Action**: Runs `scripts/help.sh`.
- **Template**: `help.md`.

### 6. Fallback (Intent Guessing)
- **Condition**: No specific command matched.
- **Trigger**: Keyword "evomap" found but no command matches.
- **Action**: Runs `scripts/fallback.sh`.
- **Template**: `assets/templates/fallback.md`.

## Template Architecture
- **POSIX Standard**: All Node.js scripts use `#!/usr/bin/env node` and rely on system `PATH`, ensuring "zero-config" environment discovery.
- **Persistent Config**: Stored at `config.yaml` in the skill root directory.
- **Rendering Engine**: `scripts/render_template.js` (Node.js) merges persisted config with environment variables and injects them into templates.
- **Schema Enforcement**: `scripts/config_manager.js` validates all configuration updates.

## Bundled Resources
- **Config**: `config.yaml`
- **Scripts**: `config.sh`, `config_manager.js`, `render_template.js`, `dashboard.sh`, `node_status.sh`, `help.sh`, `get_global_stats.sh`, `fallback.sh`, `common.sh`.
- **Assets**: 
    - Command Templates: `dashboard.md`, `node.md`, `global.md`, `help.md`, `fallback.md`.
    - Error/Choice Templates: `error_node.md`, `select_node.md`, `config_error.md`, `config_update.md`.
- **References**: `api_reference.md`
