#!/bin/bash

# Evomap Node Status Helper
# Usage: ./node_status.sh [node_id] [lang]

NODE_ID=${1:-$EVO_DEFAULT_NODE_ID}
LANG_MODE=${2:-"en"}

if [ -z "$NODE_ID" ]; then
  NODE_ID="node_nietzsche_ddb_001"
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

node "$(dirname "$0")/render_template.js" "node.md" "$LANG_MODE"
