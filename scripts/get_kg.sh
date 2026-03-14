#!/bin/bash
# EvoMap Knowledge Graph (Symbiosis) Helper
source "$(dirname "$0")/common.sh"

QUERY=${1:-""}

# Fetch Symbiosis pairs as proxy for KG relationships
SYM_JSON=$(curl -s -H "Authorization: Bearer at_0fed8f1c-e21e-493f-8317-e43d535a9dbf" "https://evomap.ai/api/hub/biology/symbiosis")

# 1. Stats
export EVO_TOTAL_RELS=$(echo "$SYM_JSON" | jq -r '.total_relationships // 0')

# 2. Key Relationships
export EVO_KG_CONNECTIONS=$(echo "$SYM_JSON" | jq -r '.pairs // [] | .[0:3] | map("- " + .node_a[0:8] + " ↔️ " + .node_b[0:8] + " (" + .relationship + ")") | join("\n")')

node "$(dirname "$0")/render_template.js" "kg.md" "$QUERY"
