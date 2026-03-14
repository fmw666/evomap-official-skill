#!/bin/bash
# Evomap Node Status Wrapper
source "$(dirname "$0")/common.sh"
$NODE_BIN "$(dirname "$0")/render_template.js" "node.md" "$1"
