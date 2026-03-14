#!/bin/bash
source "$(dirname "$0")/common.sh"
QUERY=${1:-""}
SUGGESTIONS=${2:-"- /dashboard\n- /help"}

export EVO_SUGGESTIONS=$(echo -e "$SUGGESTIONS")

$NODE_BIN "$(dirname "$0")/render_template.js" "fallback.md" "$QUERY"
