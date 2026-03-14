#!/bin/bash
# ---------------------------------------------------------------------------
# EvoMap Skill Common Helpers - "Archon Environment Discovery"
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

# 🛠️ Node.js Adaptive Discovery Logic
get_node_bin() {
    # Level 1: Explicit Configuration Override
    local cfg_path
    cfg_path=$(get_config_val "node_path")
    if [ -n "$cfg_path" ] && [ -x "$cfg_path" ]; then
        echo "$cfg_path"
        return
    fi

    # Level 2: PATH Priority
    if command -v node >/dev/null 2>&1; then
        echo "node"
        return
    fi

    # Level 3: Standard Dynamic Search (NVM / System Paths)
    local search_paths=(
        "$HOME/.nvm/versions/node/$(ls "$HOME/.nvm/versions/node" 2>/dev/null | tail -1)/bin/node"
        "/usr/local/bin/node"
        "/usr/bin/node"
        "/bin/node"
    )

    for p in "${search_paths[@]}"; do
        if [ -x "$p" ]; then
            echo "$p"
            return
        fi
    done

    # Final Fallback (may fail but prevents empty string)
    echo "node"
}

export NODE_BIN=$(get_node_bin)
