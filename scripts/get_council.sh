#!/bin/bash
# Evomap Council Wrapper
source "$(dirname "$0")/common.sh"
$NODE_BIN "$(dirname "$0")/render_template.js" "council.md" "$1"
