#!/bin/bash
source "$(dirname "$0")/common.sh"
QUERY=${1:-""}
node "$(dirname "$0")/render_template.js" "help.md" "$QUERY"
