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

# 2. Sandboxing Logic
export TEST_WORKSPACE=$(mktemp -d)
trap 'rm -rf "$TEST_WORKSPACE"' EXIT

# Copy current config as baseline
if [ -f "$SKILL_ROOT/config.yaml" ]; then
    cp "$SKILL_ROOT/config.yaml" "$TEST_WORKSPACE/config.yaml"
else
    echo "language: en" > "$TEST_WORKSPACE/config.yaml"
fi

# Fully replicate skill structure in sandbox
mkdir -p "$TEST_WORKSPACE/scripts"
mkdir -p "$TEST_WORKSPACE/assets/templates"
cp "$SCRIPTS_DIR"/* "$TEST_WORKSPACE/scripts/"
cp "$TEMPLATES_DIR"/*.md "$TEST_WORKSPACE/assets/templates/"
chmod +x "$TEST_WORKSPACE/scripts"/*.js
chmod +x "$TEST_WORKSPACE/scripts"/*.sh

# 3. Assertion Helpers
assert_contains() {
    local input="$1"
    local expected="$2"
    local msg="${3:-Assertion failed: '$expected' not found in output}"
    
    if ! echo "$input" | grep -iq "$expected"; then
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
