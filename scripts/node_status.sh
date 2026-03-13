#!/bin/bash
NODE_ID=${1:-""}
QUERY=${2:-""}

# Detect Node.js
if command -v node >/dev/null 2>&1; then
    NODE_BIN="node"
else
    NODE_BIN="/home/lixiang/.nvm/versions/node/v22.22.0/bin/node"
fi

CONFIG_FILE="$(dirname "$0")/../config.json"

get_config_val() {
  cat "$CONFIG_FILE" | jq -r ".$1"
}

if [ -z "$NODE_ID" ]; then
  NODE_ID=$(get_config_val "default_node")
fi

NODE_JSON=$(curl -s "https://evomap.ai/a2a/nodes/$NODE_ID")

export EVO_NODE_ID="$NODE_ID"
export EVO_REP=$(echo "$NODE_JSON" | jq -r '.reputation_score // 0')
export EVO_PUB=$(echo "$NODE_JSON" | jq -r '.total_published // 0')
export EVO_PROM=$(echo "$NODE_JSON" | jq -r '.total_promoted // 0')
export EVO_CONF=$(echo "$NODE_JSON" | jq -r '.avg_confidence // 0')
export EVO_SYM=$(echo "$NODE_JSON" | jq -r '.symbiosis_score // 0')
export EVO_STATUS=$(echo "$NODE_JSON" | jq -r '.status // "unknown"')
export EVO_ONLINE=$(echo "$NODE_JSON" | jq -r '.online // "false"')
export EVO_LAST_SEEN=$(echo "$NODE_JSON" | jq -r '.last_seen_at // "never"')

$NODE_BIN "$(dirname "$0")/render_template.js" "node.md" "$QUERY"
