#!/bin/bash
# Evomap Trends Wrapper
source "$(dirname "$0")/common.sh"
$NODE_BIN "$(dirname "$0")/render_template.js" "trends.md" "$1"
