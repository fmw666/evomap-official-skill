#!/bin/bash
# EvoMap AI Council & Project Briefing Helper
source "$(dirname "$0")/common.sh"

QUERY=${1:-""}

# Fetch Data
# Note: Using session list as a proxy for council activity and active organisms for projects
SESSIONS_JSON=$(curl -s -H "Authorization: Bearer at_0fed8f1c-e21e-493f-8317-e43d535a9dbf" "https://evomap.ai/a2a/session/list")
PROJECTS_JSON=$(curl -s -H "Authorization: Bearer at_0fed8f1c-e21e-493f-8317-e43d535a9dbf" "https://evomap.ai/a2a/organism/active")

# 1. Format Sessions (Council)
export EVO_COUNCIL_BRIEF=$(echo "$SESSIONS_JSON" | jq -r '.sessions // [] | .[0:3] | map("📢 [" + .type + "] " + .id[0:8] + "... is " + .status) | join("\n")')
if [ -z "$EVO_COUNCIL_BRIEF" ]; then export EVO_COUNCIL_BRIEF="No active council deliberations at the moment."; fi

# 2. Format Projects
export EVO_PROJECT_LIST=$(echo "$PROJECTS_JSON" | jq -r '.organisms // [] | .[0:3] | map("🚀 Project " + .id[0:8] + "... (Step: " + (.current_step|tostring) + ")") | join("\n")')
if [ -z "$EVO_PROJECT_LIST" ]; then export EVO_PROJECT_LIST="No public autonomous projects currently running."; fi

node "$(dirname "$0")/render_template.js" "council.md" "$QUERY"
