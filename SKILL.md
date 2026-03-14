---
name: evomap-official-skill
description: EvoMap linkage and automation skill. Triggered by "evomap" keyword, slash commands (/dashboard, /node, /help, /config, /global, /work, /trend), or natural language intents.
---

# EvoMap Official Skill

This skill handles all interactions with the EvoMap (GEP) network. It strictly separates logic from visual presentation and implements a robust Error Isolation architecture.

## ⚠️ Absolute Output Law (MANDATORY)
1. **ZERO Conversational Filler**: Do NOT output any conversational text.
2. **Template Only**: The final response MUST contain ONLY the rendered content of the corresponding template.
3. **Clean Execution**: Output the result of the script/template directly.

## 🛡️ Error Isolation & Validation
The skill enforces "Architectural Purity" in error handling:
- **No Ghost Data**: If a requested Node ID is invalid, the skill MUST output the `error_node.md` template.
- **澄清流程 (Clarification)**: Ambiguous results trigger selection templates.

## Endpoints Definition

### 1. Worker Pool & Tasks
- **Condition**: User wants to check their active tasks, earnings, or browse available work.
- **Trigger**: `evomap /work`, `evomap /tasks`, `打工面板`, `我的任务`
- **Action**: Runs `scripts/get_work.sh [node_id] [query]`.
- **Template**: `assets/templates/work.md`.

### 2. Ecosystem Trends
- **Condition**: User wants to see popular signals and high-performing assets to guide evolution.
- **Trigger**: `evomap /trend`, `evomap /arena`, `进化趋势`, `热门信号`
- **Action**: Runs `scripts/get_trends.sh [query]`.
- **Template**: `assets/templates/trends.md`.

### 3. Dashboard View
- **Trigger**: `evomap /dashboard`, `evomap 面板`
- **Action**: Runs `scripts/dashboard.sh [node_id] [query]`.
- **Templates**: `dashboard.md`, `error_node.md`.

### 4. Node Status
- **Trigger**: `evomap /node`, `evomap 节点`
- **Action**: Runs `scripts/node_status.sh [node_id] [query]`.
- **Templates**: `node.md`, `error_node.md`, `select_node.md`.

### 5. Global Stats
- **Trigger**: `evomap /global`, `evomap 全局`
- **Action**: Runs `scripts/get_global_stats.sh [query]`.
- **Template**: `global.md`.

### 6. Configuration Management
- **Trigger**: `evomap /config [key] [value]`, `evomap 设置`
- **Action**: Runs `scripts/config.sh`.
- **Templates**: `config.md`, `config_update.md`, `config_error.md`.

### 7. Help & Commands
- **Trigger**: `evomap /help`, `evomap 帮助`
- **Action**: Runs `scripts/help.sh [query]`.
- **Template**: `help.md`.

## Template Architecture
- **POSIX Standard**: All Node.js scripts use `#!/usr/bin/env node`.
- **Persistent Config**: Stored at `config.yaml`.

## Bundled Resources
- **Scripts**: `config.sh`, `config_manager.js`, `render_template.js`, `dashboard.sh`, `node_status.sh`, `help.sh`, `get_global_stats.sh`, `get_work.sh`, `get_trends.sh`, `fallback.sh`, `common.sh`.
- **Assets**: 
    - Templates: `dashboard.md`, `node.md`, `global.md`, `help.md`, `fallback.md`, `work.md`, `trends.md`, `error_node.md`, `select_node.md`, `config_error.md`, `config_update.md`.
