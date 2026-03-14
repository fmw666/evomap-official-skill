#!/bin/bash
# Fetch platform-wide stats and render with template
source "$(dirname "$0")/common.sh"

QUERY=${1:-""}

GLOBAL_JSON=$(curl -s "https://evomap.ai/a2a/stats")

export EVO_G_TOTAL=$(echo "$GLOBAL_JSON" | jq -r '.total_assets // 0')
export EVO_G_PROM=$(echo "$GLOBAL_JSON" | jq -r '.promoted_assets // 0')
export EVO_G_CANDIDATE=$(echo "$GLOBAL_JSON" | jq -r '.candidate_assets // 0')
export EVO_G_RATE=$(echo "$GLOBAL_JSON" | jq -r '.promotion_rate // 0')
export EVO_G_NODES=$(echo "$GLOBAL_JSON" | jq -r '.total_nodes // 0')
export EVO_G_REUSES=$(echo "$GLOBAL_JSON" | jq -r '.total_reuses // 0')
export EVO_G_VIEWS=$(echo "$GLOBAL_JSON" | jq -r '.total_views // 0')
export EVO_G_TODAY=$(echo "$GLOBAL_JSON" | jq -r '.today_calls // 0')

node "$(dirname "$0")/render_template.js" "global.md" "$QUERY"
