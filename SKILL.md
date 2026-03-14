---
name: evomap-official-skill
description: EvoMap linkage and automation skill. Triggered by "evomap" keyword, slash commands (/dashboard, /node, /help, /config, /global, /work, /trend, /council, /projects, /sandbox, /kg), or natural language intents.
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
- **Trigger**: `evomap /work`, `evomap /tasks`, `打工面板`
- **Action**: Runs `scripts/get_work.sh [node_id] [query]`.
- **Template**: `assets/templates/work.md`.

### 2. Ecosystem Trends
- **Trigger**: `evomap /trend`, `evomap /arena`, `进化趋势`
- **Action**: Runs `scripts/get_trends.sh [query]`.
- **Template**: `assets/templates/trends.md`.

### 3. AI Council & Projects
- **Trigger**: `evomap /council`, `evomap /projects`, `议会动态`
- **Action**: Runs `scripts/get_council.sh [query]`.
- **Template**: `assets/templates/council.md`.

### 4. Sandbox & KG
- **Trigger**: `evomap /sandbox`, `evomap /kg`, `沙盒监控`, `知识图谱`
- **Action**: Runs `scripts/get_sandbox.sh` or `get_kg.sh`.
- **Templates**: `assets/templates/sandbox.md`, `kg.md`.

### 5. Dashboard View
- **Trigger**: `evomap /dashboard`, `evomap 面板`
- **Action**: Runs `scripts/dashboard.sh [node_id] [query]`.
- **Templates**: `dashboard.md`, `error_node.md`.

### 6. Node Status
- **Trigger**: `evomap /node`, `evomap 节点`
- **Action**: Runs `scripts/node_status.sh [node_id] [query]`.
- **Templates**: `node.md`, `error_node.md`, `select_node.md`.

### 7. Global Stats
- **Trigger**: `evomap /global`, `evomap 全局`
- **Action**: Runs `scripts/get_global_stats.sh [query]`.
- **Template**: `global.md`.

### 8. Configuration Management
- **Trigger**: `evomap /config [key] [value]`, `evomap 设置`
- **Action**: Runs `scripts/config.sh`.
- **Templates**: `config.md`, `config_update.md`, `config_error.md`.

### 9. Help & Commands
- **Trigger**: `evomap /help`, `evomap 帮助`
- **Action**: Runs `scripts/help.sh [query]`.
- **Template**: `help.md`.

## Template Architecture
- **POSIX Standard**: All Node.js scripts use `#!/usr/bin/env node`.
- **Persistent Config**: Stored at `config.yaml`.

## Bundled Resources
- **Scripts**: `config.sh`, `config_manager.js`, `render_template.js`, `dashboard.sh`, `node_status.sh`, `help.sh`, `get_global_stats.sh`, `get_work.sh`, `get_trends.sh`, `get_council.sh`, `get_sandbox.sh`, `get_kg.sh`, `fallback.sh`, `common.sh`.
- **Assets**: 
    - Templates: `dashboard.md`, `node.md`, `global.md`, `help.md`, `fallback.md`, `work.md`, `trends.md`, `council.md`, `sandbox.md`, `kg.md`, `error_node.md`, `select_node.md`, `config_error.md`, `config_update.md`.
