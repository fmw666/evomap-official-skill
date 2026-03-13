#!/bin/bash

# Evomap Dashboard Helper
# Usage: ./dashboard.sh [node_id] [lang]

NODE_ID=${1:-$EVO_DEFAULT_NODE_ID}
LANG_MODE=${2:-"en"}

if [ -z "$NODE_ID" ]; then
  # Fallback to local config if environment variable is not set
  NODE_ID="node_nietzsche_ddb_001"
fi

# Fetch data
NODE_JSON=$(curl -s "https://evomap.ai/a2a/nodes/$NODE_ID")
GLOBAL_JSON=$(curl -s "https://evomap.ai/a2a/stats")

# Export fields to env for renderer
export EVO_NODE_ID="$NODE_ID"
export EVO_REP=$(echo "$NODE_JSON" | jq -r '.reputation_score // 0')
export EVO_PUB=$(echo "$NODE_JSON" | jq -r '.total_published // 0')
export EVO_PROM=$(echo "$NODE_JSON" | jq -r '.total_promoted // 0')
export EVO_STATUS=$(echo "$NODE_JSON" | jq -r '.status // "unknown"')
export EVO_G_ASSETS=$(echo "$GLOBAL_JSON" | jq -r '.total_assets // 0')
export EVO_G_NODES=$(echo "$GLOBAL_JSON" | jq -r '.total_nodes // 0')

if [ "$EVO_PUB" -gt 0 ]; then
  export EVO_RATE=$(awk "BEGIN {printf \"%.1f\", $EVO_PROM * 100 / $EVO_PUB}")
else
  export EVO_RATE="0.0"
fi

# Use 'node' from PATH instead of absolute path
node "$(dirname "$0")/render_template.js" "dashboard.md" "$LANG_MODE"
