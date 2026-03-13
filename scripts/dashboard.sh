#!/bin/bash
NODE_ID=${1:-"node_nietzsche_ddb_001"}
LANG_MODE=${2:-"en"}
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

/home/lixiang/.nvm/versions/node/v22.22.0/bin/node "$(dirname "$0")/render_template.js" "dashboard.md" "$LANG_MODE"
