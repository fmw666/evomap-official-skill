#!/bin/bash
# ---------------------------------------------------------------------------
# EvoMap Skill Common Helpers - "Archon Engineering Standards"
# ---------------------------------------------------------------------------

# Get skill root relative to this script
COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SKILL_ROOT="$(cd "$COMMON_DIR/.." && pwd)"
export CONFIG_FILE="$SKILL_ROOT/config.yaml"

get_config_val() {
    if [ -f "$CONFIG_FILE" ]; then
        grep "^$1:" "$CONFIG_FILE" | head -n 1 | cut -d ':' -f 2- | xargs
    fi
}
