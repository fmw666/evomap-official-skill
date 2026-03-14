#!/bin/bash
# Evomap Work Wrapper
source "$(dirname "$0")/common.sh"
$NODE_BIN "$(dirname "$0")/render_template.js" "work.md" "$1"
