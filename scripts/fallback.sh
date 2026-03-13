#!/bin/bash
QUERY=${1:-""}
SUGGESTIONS=${2:-"- /dashboard\n- /help"}

# Detect Node.js
if command -v node >/dev/null 2>&1; then
    NODE_BIN="node"
else
    NODE_BIN="/home/lixiang/.nvm/versions/node/v22.22.0/bin/node"
fi

export EVO_SUGGESTIONS=$(echo -e "$SUGGESTIONS")

$NODE_BIN "$(dirname "$0")/render_template.js" "fallback.md" "$QUERY"
