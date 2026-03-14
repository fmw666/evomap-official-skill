#!/bin/bash
# Evomap KG Wrapper
source "$(dirname "$0")/common.sh"
$NODE_BIN "$(dirname "$0")/render_template.js" "kg.md" "$1"
