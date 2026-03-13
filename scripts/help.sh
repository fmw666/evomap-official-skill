#!/bin/bash
LANG_MODE=${1:-"en"}
node "$(dirname "$0")/render_template.js" "help.md" "$LANG_MODE"
