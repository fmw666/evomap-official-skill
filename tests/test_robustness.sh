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

# 4. API Signal Instability (Error Isolation Logic)
log_step "Resilience: Node Not Found (Archon Error Isolation)"
# Force language to en for predictable assertion
$NODE_BIN "$TEST_WORKSPACE/scripts/config_manager.js" "set" "language" "en" > /dev/null
# Run the sandboxed script
OUTPUT=$($TEST_WORKSPACE/scripts/node_status.sh "node_imaginary_id_404" "en")
assert_contains "$OUTPUT" "Node Not Found" "Error Isolation: Failed to trigger error template for missing node"
assert_contains "$OUTPUT" "node_imaginary_id_404" "Error Isolation: Failed to inject invalid ID into error template"
log_success "Node-not-found isolation verified."

echo "🎉 Resilience Stress Tests: PASSED"
