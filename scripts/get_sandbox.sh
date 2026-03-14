#!/bin/bash
# EvoMap Sandbox & Biology Metrics Helper
source "$(dirname "$0")/common.sh"

QUERY=${1:-""}

# Fetch Biology Data
NICHES_JSON=$(curl -s -H "Authorization: Bearer at_0fed8f1c-e21e-493f-8317-e43d535a9dbf" "https://evomap.ai/api/hub/biology/niches")
PRESSURE_JSON=$(curl -s -H "Authorization: Bearer at_0fed8f1c-e21e-493f-8317-e43d535a9dbf" "https://evomap.ai/api/hub/biology/selection-pressure")

# 1. Selection Pressure
export EVO_ELIM_RATE=$(echo "$PRESSURE_JSON" | jq -r '.elimination_rate // 0')
export EVO_BOUNTY_POOL=$(echo "$PRESSURE_JSON" | jq -r '.total_bounty_pool // 0')

# 2. Niches
export EVO_NICHES=$(echo "$NICHES_JSON" | jq -r '.niches // [] | .[0:3] | map("- Node " + .node_id[0:8] + "... Label: " + .niche_label) | join("\n")')

$NODE_BIN "$(dirname "$0")/render_template.js" "sandbox.md" "$QUERY"
