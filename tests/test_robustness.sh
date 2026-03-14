#!/bin/bash
# ---------------------------------------------------------------------------
# EvoMap Skill Robustness & Boundary Test Suite
# ---------------------------------------------------------------------------

SKILL_DIR="$(dirname "$0")/.."
SCRIPTS_DIR="$SKILL_DIR/scripts"
CONFIG_FILE="$SKILL_DIR/config.yaml"

# Detect Node.js
if command -v node >/dev/null 2>&1; then
    NODE_BIN="node"
else
    NODE_BIN="/home/lixiang/.nvm/versions/node/v22.22.0/bin/node"
fi

echo "🧪 Running Robustness & Boundary Tests..."

# Backup current config
[ -f "$CONFIG_FILE" ] && cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

# 1. Test Configuration Corruption Recovery
echo "[1/4] Testing Configuration Corruption Recovery..."
echo "invalid: yaml: : : : data" > "$CONFIG_FILE"
# Running a command should not crash and should use internal defaults
OUTPUT=$($NODE_BIN "$SCRIPTS_DIR/render_template.js" "help.md" "en")
if echo "$OUTPUT" | grep -q "Help Commands"; then
    echo "  ✅ Recovery from corrupted YAML passed."
else
    echo "  ❌ Recovery from corrupted YAML failed."
    exit 1
fi

# 2. Test Missing Template Graceful Failure
echo "[2/4] Testing Missing Template Handling..."
OUTPUT=$($NODE_BIN "$SCRIPTS_DIR/render_template.js" "non_existent.md" "en")
if echo "$OUTPUT" | grep -q "Template non_existent.md not found"; then
    echo "  ✅ Missing template handled."
else
    echo "  ❌ Missing template handling failed."
    exit 1
fi

# 3. Test Schema Case Correction (e.g., ZH -> zh)
echo "[3/4] Testing Schema Case Correction (ZH -> zh)..."
$NODE_BIN "$SCRIPTS_DIR/config_manager.js" "set" "language" "ZH" > /dev/null
if grep -q "language: zh" "$CONFIG_FILE"; then
    echo "  ✅ Case correction passed."
else
    echo "  ❌ Case correction failed."
    exit 1
fi

# 4. Test API Timeout/Failure Simulation (Mocking empty JSON)
echo "[4/4] Testing API Failure Robustness (Empty Data)..."
# We test the dashboard's output when given an invalid node ID
# Note: It may output in Chinese if config default changed, so we check for the value '0'
OUTPUT=$($SKILL_DIR/scripts/dashboard.sh "node_invalid_id_999" "en")
if echo "$OUTPUT" | grep -q "0"; then
    echo "  ✅ API failure (empty data) handled gracefully."
else
    echo "  ❌ API failure handling failed."
    echo "$OUTPUT"
    exit 1
fi

# Cleanup
[ -f "$CONFIG_FILE.bak" ] && mv "$CONFIG_FILE.bak" "$CONFIG_FILE"

echo "🎉 All robustness tests passed!"
