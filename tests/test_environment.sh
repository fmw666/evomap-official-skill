#!/bin/bash
# ---------------------------------------------------------------------------
# EvoMap Skill Environment Discovery Test Suite
# ---------------------------------------------------------------------------
source "$(dirname "$0")/test_common.sh"

echo "🧪 Initiating Environment Discovery Tests..."

# 1. Test Level 1: Configuration Override
log_step "Discovery: Configuration Override (node_path)"
# Create a fake node binary that prints a specific string
FAKE_NODE="$TEST_WORKSPACE/fake_node"
echo '#!/bin/bash
echo "FAKE_NODE_OUTPUT"' > "$FAKE_NODE"
chmod +x "$FAKE_NODE"

# Set it in config
$NODE_BIN "$TEST_WORKSPACE/scripts/config_manager.js" "set" "node_path" "$FAKE_NODE" > /dev/null

# Source common.sh in a subshell to check NODE_BIN
# Note: we must point SKILL_ROOT to TEST_WORKSPACE for this to work correctly
ACTUAL_NODE=$(SKILL_ROOT="$TEST_WORKSPACE" bash -c "source $TEST_WORKSPACE/scripts/common.sh && echo \$NODE_BIN")

if [ "$ACTUAL_NODE" == "$FAKE_NODE" ]; then
    log_success "Configuration override (node_path) prioritized."
else
    echo "❌ Discovery: node_path override failed. Found: $ACTUAL_NODE"
    exit 1
fi

# 2. Test Level 2: PATH Priority (when node_path is empty)
log_step "Discovery: PATH Priority"
# Remove node_path from config
sed -i '/node_path:/d' "$TEST_WORKSPACE/config.yaml"

# Mock PATH by creating a 'node' in a temp dir and adding it to PATH
MOCK_PATH_DIR="$TEST_WORKSPACE/mock_path"
mkdir -p "$MOCK_PATH_DIR"
MOCK_NODE="$MOCK_PATH_DIR/node"
cp "$FAKE_NODE" "$MOCK_NODE"

ACTUAL_NODE=$(PATH="$MOCK_PATH_DIR:$PATH" SKILL_ROOT="$TEST_WORKSPACE" bash -c "source $TEST_WORKSPACE/scripts/common.sh && which \$NODE_BIN")

if [[ "$ACTUAL_NODE" == *"$MOCK_PATH_DIR/node"* ]]; then
    log_success "PATH priority verified."
else
    echo "❌ Discovery: PATH priority failed. Found: $ACTUAL_NODE"
    exit 1
fi

echo "🎉 Environment Discovery Tests: PASSED"
