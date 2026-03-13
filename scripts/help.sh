#!/bin/bash
LANG_MODE=${1:-"en"}
python3 "$(dirname "$0")/render_template.py" "help.md" "$LANG_MODE"
