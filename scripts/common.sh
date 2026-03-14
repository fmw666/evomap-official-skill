#!/bin/bash
# ---------------------------------------------------------------------------
# EvoMap Skill Common Helpers - "Archon Engineering Standards"
# ---------------------------------------------------------------------------

# 1. Path Discovery
COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SKILL_ROOT="$(cd "$COMMON_DIR/.." && pwd)"
export CONFIG_FILE="$SKILL_ROOT/config.yaml"

# 2. Node.js Binary Identification (Adaptive & Resilient)
# We strictly trust system PATH as per standards, but implement a transparent 
# self-healing PATH injection for common Agent environments (like NVM).
get_node_bin() {
    # If node is missing, try to restore standard paths
    if ! command -v node >/dev/null 2>&1; then
        # Standard NVM path auto-injection (Universal Pattern)
        local nvm_bin_dir
        nvm_bin_dir=$(find "$HOME/.nvm/versions/node" -mindepth 2 -maxdepth 2 -name bin -type d 2>/dev/null | sort -V | tail -1)
        if [ -n "$nvm_bin_dir" ]; then
            export PATH="$PATH:$nvm_bin_dir"
        fi
        # Standard System path check
        export PATH="$PATH:/usr/local/bin:/usr/bin:/bin"
    fi

    # Final check: return full path if 'node' still not found, otherwise just 'node'
    if command -v node >/dev/null 2>&1; then
        command -v node
    else
        echo "node" # Still return 'node' to trigger standard error if missing
    fi
}

export NODE_BIN=$(get_node_bin)

get_config_val() {
    if [ -f "$CONFIG_FILE" ]; then
        grep "^$1:" "$CONFIG_FILE" | head -n 1 | cut -d ':' -f 2- | xargs
    fi
}
