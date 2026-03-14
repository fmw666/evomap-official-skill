#!/bin/bash
# Replaced by Node-native implementation
source "$(dirname "$0")/common.sh"
node "$(dirname "$0")/render_template.js" "work.md" "$1"
