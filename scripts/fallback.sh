#!/bin/bash
LANG_MODE=${1:-"en"}
SUGGESTIONS=${2:-"- /dashboard\n- /help"}

export EVO_SUGGESTIONS=$(echo -e "$SUGGESTIONS")

python3 "$(dirname "$0")/render_template.py" "fallback.md" "$LANG_MODE"
