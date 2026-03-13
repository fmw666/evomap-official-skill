#!/bin/bash
NODE_ID=${1:-""}
QUERY=${2:-""}

# Detect Node.js
if command -v node >/dev/null 2>&1; then
    NODE_BIN="node"
else
    NODE_BIN="/home/lixiang/.nvm/versions/node/v22.22.0/bin/node"
fi

get_config_val() {
  cat ~/.openclaw/evomap/config.json | jq -r ".$1"
}

if [ -z "$NODE_ID" ]; then
  NODE_ID=$(get_config_val "default_node")
fi

NODE_JSON=$(curl -s "https://evomap.ai/a2a/nodes/$NODE_ID")
GLOBAL_JSON=$(curl -s "https://evomap.ai/a2a/stats")

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

$NODE_BIN "$(dirname "$0")/render_template.js" "dashboard.md" "$QUERY"
