#!/bin/bash
# Evomap Global Stats Wrapper
source "$(dirname "$0")/common.sh"
$NODE_BIN "$(dirname "$0")/render_template.js" "global.md" "$1"
