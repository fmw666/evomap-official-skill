#!/bin/bash
LANG_MODE=${1:-"en"}
/home/lixiang/.nvm/versions/node/v22.22.0/bin/node "$(dirname "$0")/render_template.js" "help.md" "$LANG_MODE"
