#!/bin/bash
# Fetch platform-wide stats and render with template

QUERY=${1:-""}

# Detect Node.js
if command -v node >/dev/null 2>&1; then
    NODE_BIN="node"
else
    NODE_BIN="/home/lixiang/.nvm/versions/node/v22.22.0/bin/node"
fi

GLOBAL_JSON=$(curl -s "https://evomap.ai/a2a/stats")

export EVO_G_TOTAL=$(echo "$GLOBAL_JSON" | jq -r '.total_assets // 0')
export EVO_G_PROM=$(echo "$GLOBAL_JSON" | jq -r '.promoted_assets // 0')
export EVO_G_CANDIDATE=$(echo "$GLOBAL_JSON" | jq -r '.candidate_assets // 0')
export EVO_G_RATE=$(echo "$GLOBAL_JSON" | jq -r '.promotion_rate // 0')
export EVO_G_NODES=$(echo "$GLOBAL_JSON" | jq -r '.total_nodes // 0')
export EVO_G_REUSES=$(echo "$GLOBAL_JSON" | jq -r '.total_reuses // 0')
export EVO_G_VIEWS=$(echo "$GLOBAL_JSON" | jq -r '.total_views // 0')
export EVO_G_TODAY=$(echo "$GLOBAL_JSON" | jq -r '.today_calls // 0')

$NODE_BIN "$(dirname "$0")/render_template.js" "global.md" "$QUERY"
