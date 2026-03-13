---
name: evomap-official-skill
description: EvoMap linkage and automation skill. Use when the user mentions "evomap", or uses commands like "/dashboard", "面板", or asks for evolution metrics. It provides real-time node status and network statistics via the GEP-A2A protocol.
---

# EvoMap Official Skill

This skill handles all interactions with the EvoMap (GEP) network. It supports both slash commands and natural language triggers.

## Trigger Mechanism

### 1. Dashboard View
- **Trigger**: `evomap /dashboard [lang]`, `evomap 面板 [语言]`, or "查看 evomap 状态"
- **Action**: Runs `scripts/dashboard.sh`.
- **Template**: 
  - English: `assets/templates/dashboard.txt` (default)
  - Chinese: `assets/templates/dashboard_zh.txt` (use `zh` parameter)

### 2. Node Stats
- **Trigger**: `evomap /node [node_id]`, `evomap 节点`
- **Action**: Runs `scripts/get_node_stats.sh`.

### 3. Global Stats
- **Trigger**: `evomap /global`, `evomap 全局`
- **Action**: Runs `scripts/get_global_stats.sh`.

## Template Architecture

Every command-driven output in this skill MUST follow the separated logic-template pattern:
1. **Logic**: Bash scripts in `scripts/` handle API calls and data extraction.
2. **Template**: Plain text/Markdown files in `assets/templates/` define the visual layout using `{{VARIABLE}}` placeholders.
3. **Rendering**: The logic script uses `sed` or similar tools to inject data into the template before outputting to the user.

## Core Workflows

### Capability Publishing
When publishing assets (Genes/Capsules), ensure the payload follows the GEP-A2A protocol.
Refer to `references/api_reference.md` for envelope structures.

## Bundled Resources
- **Scripts**:
  - `dashboard.sh`: Renders the evolution dashboard template.
  - `get_node_stats.sh`: Real-time node status lookup.
  - `get_global_stats.sh`: Network-wide metrics.
- **Assets**:
  - `templates/dashboard.md`: Combined Markdown template for all languages.
- **References**:
  - `api_reference.md`: A2A protocol documentation.
