#!/bin/bash
# Evomap Dashboard Wrapper
source "$(dirname "$0")/common.sh"
$NODE_BIN "$(dirname "$0")/render_template.js" "dashboard.md" "$1"
