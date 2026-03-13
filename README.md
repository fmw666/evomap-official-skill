# EvoMap Official Skill

Official automation and linkage skill for the EvoMap (GEP) network. Designed for high performance, portability, and strictly clean output.

## 🚀 Features
- **Logic-Presentation Separation**: Bash logic scripts and a Node.js-based rendering engine (`render_template.js`) handle data, while Markdown templates (`assets/templates/`) define the visual layout.
- **Persistent Configuration**: A local `config.yaml` manages user preferences (language, default node) with built-in **Schema Validation** to prevent invalid settings.
- **Absolute Output Law**: Zero conversational filler. The skill responds ONLY with rendered templates, ensuring a machine-ready and distraction-free experience.
- **Smart Language Perception**: Automatically detects user language (English/Chinese) from the input query to select the appropriate template block.
- **Dependency-Free QA**: A native test suite (`tests/run_tests.sh`) providing syntax linting and rendering validation without heavy external frameworks.
- **CI/CD Ready**: Integrated GitHub Actions for automated testing on every push.

## 📋 Commands
- `evomap /dashboard`: Visual evolution overview of the node and global network.
- `evomap /node`: Detailed metrics for the current/specific node.
- `evomap /config [key] [value]`: View current settings or update configuration with Schema enforcement.
- `evomap /help`: List all available commands and usage instructions.
- `evomap /global`: Raw global network statistics.

## 🛠️ Internal Architecture
```bash
evomap-official-skill/
├── assets/templates/   # Markdown templates with {{VARIABLE}} placeholders
├── scripts/            # Node.js renderer and Bash logic controllers
├── tests/              # Native test suite and API mocks
├── .github/workflows/  # CI/CD configuration
└── config.yaml         # Persistent user settings
```

## 🧪 Quality Assurance
Run the native test suite locally:
```bash
./tests/run_tests.sh
```

## 🛠️ TODO / Roadmap
- [ ] **Cross-Platform Compatibility**:
    - [x] Feishu (Lark) Markdown validation.
    - [ ] Discord/WhatsApp formatting refinements.
- [ ] **Enhanced Metrics**:
    - [ ] Real-time graph rendering for reputation history.
    - [ ] Credit balance tracking (`/credits`).

## 📄 License
MIT
