#!/bin/bash
# EvoMap Worker Pool Helper
source "$(dirname "$0")/common.sh"

NODE_ID=${1:-""}
QUERY=${2:-""}

if [ -z "$NODE_ID" ]; then
  NODE_ID=$(get_config_val "default_node")
fi

# Fetch Data
MY_WORK_JSON=$(curl -s -H "Authorization: Bearer at_0fed8f1c-e21e-493f-8317-e43d535a9dbf" "https://evomap.ai/a2a/work/my?node_id=$NODE_ID")
AVAIL_WORK_JSON=$(curl -s -H "Authorization: Bearer at_0fed8f1c-e21e-493f-8317-e43d535a9dbf" "https://evomap.ai/a2a/work/available?node_id=$NODE_ID")
NODE_JSON=$(curl -s "https://evomap.ai/a2a/nodes/$NODE_ID")

# 1. Validation
ACTUAL_ID=$(echo "$NODE_JSON" | jq -r '.node_id // empty')
if [ -z "$ACTUAL_ID" ]; then
    export EVO_NODE_ID="$NODE_ID"
    node "$(dirname "$0")/render_template.js" "error_node.md" "$QUERY"
    exit 0
fi

# 2. Extract Fields
export EVO_NODE_ID="$ACTUAL_ID"
export EVO_EARNINGS=$(echo "$NODE_JSON" | jq -r '.earnings // 0')
export EVO_ACTIVE_COUNT=$(echo "$MY_WORK_JSON" | jq -r '.count // 0')
export EVO_AVAIL_COUNT=$(echo "$AVAIL_WORK_JSON" | jq -r '.count // 0')

# Format Task Lists
export EVO_MY_TASKS=$(echo "$MY_WORK_JSON" | jq -r '.records // [] | .[0:3] | map("- [" + .status + "] " + .task_title) | join("\n")')
if [ -z "$EVO_MY_TASKS" ]; then export EVO_MY_TASKS="No active assignments."; fi

export EVO_AVAIL_TASKS=$(echo "$AVAIL_WORK_JSON" | jq -r '.records // [] | .[0:3] | map("- " + .title + " (" + (.bounty|tostring) + " credits)") | join("\n")')
if [ -z "$EVO_AVAIL_TASKS" ]; then export EVO_AVAIL_TASKS="No tasks available in your domains."; fi

node "$(dirname "$0")/render_template.js" "work.md" "$QUERY"
