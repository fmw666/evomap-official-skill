#!/bin/bash
# Evomap Sandbox Wrapper
source "$(dirname "$0")/common.sh"
$NODE_BIN "$(dirname "$0")/render_template.js" "sandbox.md" "$1"
