#!/bin/bash
# ---------------------------------------------------------------------------
# EvoMap Skill Native Test Runner (Dependency-Free)
# ---------------------------------------------------------------------------

SKILL_DIR="$(dirname "$0")/.."
SCRIPTS_DIR="$SKILL_DIR/scripts"

# Detect Node.js
if command -v node >/dev/null 2>&1; then
    NODE_BIN="node"
else
    NODE_BIN="/home/lixiang/.nvm/versions/node/v22.22.0/bin/node"
fi

echo "🚀 Starting Native Tests..."

# 1. Syntax Check (Lint)
echo "[1/3] Checking JS Syntax..."
$NODE_BIN --check "$SCRIPTS_DIR"/*.js || exit 1

# 2. Rendering Unit Tests (Mock Environment)
echo "[2/3] Testing Template Rendering (English)..."
export EVO_NODE_ID="test_node_001"
export EVO_REP="99.99"
export EVO_STATUS="active"
export EVO_PUB="100"
export EVO_PROM="90"
export EVO_RATE="90.0"
export EVO_G_ASSETS="500000"
export EVO_G_NODES="50000"

OUTPUT_EN=$($NODE_BIN "$SCRIPTS_DIR/render_template.js" "dashboard.md" "en")
if echo "$OUTPUT_EN" | grep -q "99.99" && echo "$OUTPUT_EN" | grep -q "test_node_001"; then
    echo "  ✅ English Rendering passed."
else
    echo "  ❌ English Rendering failed."
    echo "$OUTPUT_EN"
    exit 1
fi

echo "[2/3] Testing Template Rendering (Chinese)..."
OUTPUT_ZH=$($NODE_BIN "$SCRIPTS_DIR/render_template.js" "dashboard.md" "zh")
if echo "$OUTPUT_ZH" | grep -q "声望评分" && echo "$OUTPUT_ZH" | grep -q "99.99"; then
    echo "  ✅ Chinese Rendering passed."
else
    echo "  ❌ Chinese Rendering failed."
    echo "$OUTPUT_ZH"
    exit 1
fi

# 3. Config Manager Tests
echo "[3/3] Testing Config Management..."
# Backup existing config
[ -f "$SKILL_DIR/config.yaml" ] && cp "$SKILL_DIR/config.yaml" "$SKILL_DIR/config.yaml.bak"

$NODE_BIN "$SCRIPTS_DIR/config_manager.js" "set" "language" "zh" > /dev/null
if grep -q "language: zh" "$SKILL_DIR/config.yaml"; then
    echo "  ✅ Config Update passed."
else
    echo "  ❌ Config Update failed."
    exit 1
fi

# Restore backup
[ -f "$SKILL_DIR/config.yaml.bak" ] && mv "$SKILL_DIR/config.yaml.bak" "$SKILL_DIR/config.yaml"

echo "🎉 All tests passed successfully!"
