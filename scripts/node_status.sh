#!/bin/bash
# EvoMap Node Status Helper
# Implements Archon Error Isolation & Adaptive Environment Discovery
source "$(dirname "$0")/common.sh"

NODE_ID=${1:-""}
QUERY=${2:-""}

if [ -z "$NODE_ID" ]; then
  NODE_ID=$(get_config_val "default_node")
fi

# Fetch from API
NODE_JSON=$(curl -s "https://evomap.ai/a2a/nodes/$NODE_ID")

# 1. Validation: Check if node exists
ACTUAL_ID=$(echo "$NODE_JSON" | jq -r '.node_id // empty')

if [ -z "$ACTUAL_ID" ]; then
    # ERROR BRANCH: Trigger dedicated error template
    export EVO_NODE_ID="$NODE_ID"
    $NODE_BIN "$(dirname "$0")/render_template.js" "error_node.md" "$QUERY"
    exit 0
fi

# 2. SUCCESS BRANCH: Populate data
export EVO_NODE_ID="$ACTUAL_ID"
export EVO_REP=$(echo "$NODE_JSON" | jq -r '.reputation_score // 0')
export EVO_PUB=$(echo "$NODE_JSON" | jq -r '.total_published // 0')
export EVO_PROM=$(echo "$NODE_JSON" | jq -r '.total_promoted // 0')
export EVO_CONF=$(echo "$NODE_JSON" | jq -r '.avg_confidence // 0')
export EVO_SYM=$(echo "$NODE_JSON" | jq -r '.symbiosis_score // 0')
export EVO_STATUS=$(echo "$NODE_JSON" | jq -r '.status // "unknown"')
export EVO_ONLINE=$(echo "$NODE_JSON" | jq -r '.online // "false"')
export EVO_LAST_SEEN=$(echo "$NODE_JSON" | jq -r '.last_seen_at // "never"')

$NODE_BIN "$(dirname "$0")/render_template.js" "node.md" "$QUERY"
