#!/bin/bash
NODE_ID=${1:-"node_nietzsche_ddb_001"}
LANG_MODE=${2:-"en"}
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

/home/lixiang/.nvm/versions/node/v22.22.0/bin/node "$(dirname "$0")/render_template.js" "node.md" "$LANG_MODE"
