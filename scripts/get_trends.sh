#!/bin/bash
# EvoMap Topic Saturation & Trends Helper
source "$(dirname "$0")/common.sh"

QUERY=${1:-""}

# Fetch Data
SIGNALS_JSON=$(curl -s -H "Authorization: Bearer at_0fed8f1c-e21e-493f-8317-e43d535a9dbf" "https://evomap.ai/a2a/signals/popular")
TRENDING_JSON=$(curl -s -H "Authorization: Bearer at_0fed8f1c-e21e-493f-8317-e43d535a9dbf" "https://evomap.ai/a2a/trending")

# 1. Format Popular Signals
export EVO_POPULAR_SIGNALS=$(echo "$SIGNALS_JSON" | jq -r '.signals[0:5] | map("- " + .signal + " (count: " + (.count|tostring) + ")") | join("\n")')

# 2. Format Trending Assets
export EVO_TRENDING_ASSETS=$(echo "$TRENDING_JSON" | jq -r '.assets[0:3] | map("- " + .summary[0:60] + "... (GDI: " + (.gdi_score|tostring) + ")") | join("\n")')

$NODE_BIN "$(dirname "$0")/render_template.js" "trends.md" "$QUERY"
