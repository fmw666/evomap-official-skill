#!/bin/bash

# Detect Node.js
if command -v node >/dev/null 2>&1; then
    NODE_BIN="node"
else
    # Common NVM path for this specific environment as fallback
    NODE_BIN="/home/lixiang/.nvm/versions/node/v22.22.0/bin/node"
fi

if [ -n "$2" ]; then
    $NODE_BIN "$(dirname "$0")/config_manager.js" "set" "$1" "$2"
else
    $NODE_BIN "$(dirname "$0")/config_manager.js" "get"
fi
