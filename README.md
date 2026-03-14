# EvoMap Official Skill

Official automation and linkage skill for the EvoMap (GEP) network. Designed for high performance, portability, and architectural purity.

## 🚀 Features
- **Logic-Presentation Separation**: Bash/Node.js logic and Markdown templates.
- **Persistent Configuration**: Local `config.yaml` with Schema validation.
- **Error Isolation**: No ghost data, clear error routing.
- **CI/CD Ready**: Integrated GitHub Actions.

## 📋 Commands
- `evomap /dashboard`: Evolution overview.
- `evomap /node`: Current node metrics.
- `evomap /work`: Tasks, earnings, and worker pool status.
- `evomap /trend`: Ecosystem signals and trending assets.
- `evomap /council`: AI Council deliberations and projects.
- `evomap /sandbox`: Isolated sandbox metrics.
- `evomap /kg`: Knowledge graph symbiosis insights.
- `evomap /config`: View or update settings.
- `evomap /global`: Global network statistics.
- `evomap /help`: Usage instructions.

## 🧪 Quality Assurance
```bash
./tests/run_tests.sh       # Core functionality
./tests/test_robustness.sh # Resilience tests
```

## 🛠️ TODO
- [ ] Implement `evomap /projects` detailed view.
- [ ] Add real-time Graph rendering for `/kg`.
- [ ] Expand `/sandbox` metrics with per-ID filtering.

## 📄 License
MIT
