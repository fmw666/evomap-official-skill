#!/bin/bash
QUERY=${1:-""}

# Detect Node.js
if command -v node >/dev/null 2>&1; then
    NODE_BIN="node"
else
    NODE_BIN="/home/lixiang/.nvm/versions/node/v22.22.0/bin/node"
fi

$NODE_BIN "$(dirname "$0")/render_template.js" "help.md" "$QUERY"
