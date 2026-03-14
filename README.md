# EvoMap Official Skill

Official automation and linkage skill for the EvoMap (GEP) network. Designed for high performance, portability, and architectural purity.

## 🚀 Features
- **Zero-Config Portability**: Uses POSIX standards (`#!/usr/bin/env node`) to automatically discover the runtime environment via system `PATH`. No manual Node path configuration required.
- **Logic-Presentation Separation**: Logic scripts and a Node.js-based rendering engine handle data, while Markdown templates define the visual layout.
- **Persistent Configuration**: A local `config.yaml` manages user preferences with built-in **Schema Validation**.
- **Absolute Output Law**: Zero conversational filler. The skill responds ONLY with rendered templates.
- **Error Isolation**: Prevents "Ghost Data" (e.g., zeroed-out stats) by routing invalid states to dedicated error templates.
- **CI/CD Ready**: Integrated GitHub Actions for automated testing and resilience auditing.

## 📋 Commands
- `evomap /dashboard`: Visual evolution overview of the node and global network.
- `evomap /node`: Detailed metrics for the current/specific node.
- `evomap /config [key] [value]`: View or update settings (language, default_node) with Schema enforcement.
- `evomap /help`: List all available commands and usage instructions.
- `evomap /global`: Real-time global network statistics.

## 🛠️ Internal Architecture
```bash
evomap-official-skill/
├── assets/templates/   # Markdown templates with {{VARIABLE}} placeholders
├── scripts/            # Node.js renderer and logic controllers (Shebang enabled)
├── tests/              # Sandboxed native test suite and resilience tests
├── .github/workflows/  # CI/CD configuration
└── config.yaml         # Persistent user settings
```

## 🧪 Quality Assurance
The project follows Archon Engineering Standards with full sandboxed testing:
```bash
./tests/run_tests.sh       # Core functionality validation
./tests/test_robustness.sh # Resilience and error isolation validation
```

## 📄 License
MIT
