#!/bin/bash
# ---------------------------------------------------------------------------
# EvoMap Skill Robustness Suite - "Chaotic Environment Resilience"
# ---------------------------------------------------------------------------
source "$(dirname "$0")/test_common.sh"

echo "🧪 Initiating Resilience Stress Tests..."

# 1. Configuration Corruption (Self-Healing)
log_step "Resilience: Configuration Corruption Recovery"
echo "damaged: : : : : data" > "$TEST_WORKSPACE/config.yaml"

# Should use internal defaults and not crash
OUTPUT=$($NODE_BIN "$TEST_WORKSPACE/scripts/render_template.js" "help.md" "en")
assert_contains "$OUTPUT" "Help Commands" "Self-healing: System crashed on invalid YAML"
log_success "Internal recovery verified."

# 2. Template Boundary Errors
log_step "Resilience: Template Boundary Violation"
OUTPUT=$($NODE_BIN "$TEST_WORKSPACE/scripts/render_template.js" "ghost_template.md" "en")
assert_contains "$OUTPUT" "Template ghost_template.md not found" "Error: Unfriendly stack trace exposed"
log_success "Missing template handled gracefully."

# 3. Input Sanitization (Case Normalization)
log_step "Resilience: Input Normalization (Schema Enforcement)"
$NODE_BIN "$TEST_WORKSPACE/scripts/config_manager.js" "set" "language" "ZH" > /dev/null
assert_contains "$(cat "$TEST_WORKSPACE/config.yaml")" "language: zh" "Sanitization: Case conversion failed"
log_success "Schema enforcement verified."

# 4. API Signal Instability (Failing Downstream)
log_step "Resilience: API Downstream Instability (Empty/Null Response)"
# Mocking a catastrophic API failure by passing a non-existent node ID 
# which causes the Logic layer to get empty data.
# We point to the real scripts but execute in a context that mimics logic failure
OUTPUT=$($SKILL_ROOT/scripts/dashboard.sh "node_corrupted_id_000" "en")
assert_contains "$OUTPUT" "0" "Instability: Dashboard crashed on empty API response"
log_success "API data instability handled."

echo "🎉 Resilience Stress Tests: PASSED"
