#!/bin/bash
# ---------------------------------------------------------------------------
# EvoMap Skill Test Helper - "Archon Engineering Standards"
# ---------------------------------------------------------------------------
set -euo pipefail

# 1. Path Discovery
export SKILL_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export SCRIPTS_DIR="$SKILL_ROOT/scripts"
export TEMPLATES_DIR="$SKILL_ROOT/assets/templates"
export TEST_DIR="$SKILL_ROOT/tests"

# 2. Node.js Binary Identification
if command -v node >/dev/null 2>&1; then
    export NODE_BIN="node"
else
    # Fallback to known stable path
    export NODE_BIN="/home/lixiang/.nvm/versions/node/v22.22.0/bin/node"
fi

# 3. Sandboxing Logic
# Create a dedicated temp workspace for this test run to prevent polluting local state
export TEST_WORKSPACE=$(mktemp -d)
trap 'rm -rf "$TEST_WORKSPACE"' EXIT

# Copy current config as baseline if it exists
if [ -f "$SKILL_ROOT/config.yaml" ]; then
    cp "$SKILL_ROOT/config.yaml" "$TEST_WORKSPACE/config.yaml"
else
    echo "language: en" > "$TEST_WORKSPACE/config.yaml"
fi

# Point the skill to the sandbox config via environment or local symlink simulation
# In our current script logic, it looks for ../config.yaml relative to scripts/
# We will simulate this by creating a mock scripts dir in the workspace
mkdir -p "$TEST_WORKSPACE/scripts"
mkdir -p "$TEST_WORKSPACE/assets/templates"
cp "$SCRIPTS_DIR"/*.js "$TEST_WORKSPACE/scripts/"
cp "$TEMPLATES_DIR"/*.md "$TEST_WORKSPACE/assets/templates/"

# 4. Assertion Helpers
assert_contains() {
    local input="$1"
    local expected="$2"
    local msg="${3:-Assertion failed: '$expected' not found in output}"
    
    if ! echo "$input" | grep -q "$expected"; then
        echo "❌ $msg"
        echo "--- ACTUAL OUTPUT ---"
        echo "$input"
        echo "---------------------"
        exit 1
    fi
}

log_step() {
    echo "🔷 [TEST] $1"
}

log_success() {
    echo "  ✅ $1"
}
