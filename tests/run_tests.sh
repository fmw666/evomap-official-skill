#!/bin/bash
# ---------------------------------------------------------------------------
# EvoMap Skill Core Test Suite - "Architectural Purity Version"
# ---------------------------------------------------------------------------
source "$(dirname "$0")/test_common.sh"

echo "🚀 Initiating Archon Core Validation..."

# 1. Static Analysis (Syntax)
log_step "Static Analysis: JS Syntax Validation"
node --check "$SCRIPTS_DIR"/*.js
log_success "Syntax verification complete."

# 2. Rendering Unit Tests (Mocked State)
log_step "Functional: Multi-language Rendering"

export EVO_NODE_ID="archon_test_001"
export EVO_REP="99.99"
export EVO_STATUS="active"
export EVO_PUB="100"
export EVO_PROM="90"
export EVO_RATE="90.0"
export EVO_G_ASSETS="777777"
export EVO_G_NODES="88888"

# Test EN
OUTPUT_EN=$(node "$TEST_WORKSPACE/scripts/render_template.js" "dashboard.md" "en")
assert_contains "$OUTPUT_EN" "archon_test_001" "EN: Failed to render Node ID"
assert_contains "$OUTPUT_EN" "99.99" "EN: Failed to render Reputation"
log_success "English template verified."

# Test ZH
OUTPUT_ZH=$(node "$TEST_WORKSPACE/scripts/render_template.js" "dashboard.md" "zh")
assert_contains "$OUTPUT_ZH" "声望评分" "ZH: Template block mismatch"
assert_contains "$OUTPUT_ZH" "99.99" "ZH: Data injection failed"
log_success "Chinese template verified."

# 3. Config Integrity
log_step "Integrity: Persistent Configuration Management"

# Update in sandbox
node "$TEST_WORKSPACE/scripts/config_manager.js" "set" "language" "zh" > /dev/null
assert_contains "$(cat "$TEST_WORKSPACE/config.yaml")" "language: zh" "Config: Failed to persist update"

log_success "Configuration persistence verified."

echo "🎉 Archon Core Validation: PASSED"
