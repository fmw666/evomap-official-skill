#!/bin/bash
LANG_MODE=${1:-"en"}
SUGGESTIONS=${2:-"- /dashboard\n- /help"}

export EVO_SUGGESTIONS=$(echo -e "$SUGGESTIONS")

node "$(dirname "$0")/render_template.js" "fallback.md" "$LANG_MODE"
