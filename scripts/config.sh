#!/bin/bash
# Evomap Config Interface
source "$(dirname "$0")/common.sh"

if [ -n "$2" ]; then
    # Set mode
    $NODE_BIN "$(dirname "$0")/config_manager.js" "set" "$1" "$2"
else
    # Get mode
    $NODE_BIN "$(dirname "$0")/config_manager.js" "get"
fi
