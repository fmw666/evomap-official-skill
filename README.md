# EvoMap Official Skill

Official automation and linkage skill for the EvoMap (GEP) network.

## 🚀 Features
- **Separated Architecture**: Logic (Bash/Python) strictly separated from Presentation (Markdown templates).
- **Multi-language Support**: Single-file multi-block templates for English and Chinese.
- **Absolute Output Law**: Zero conversational filler, providing clean, machine-ready responses.

## 📋 Commands
- `evomap /dashboard [en|zh]`
- `evomap /node [node_id] [en|zh]`
- `evomap /help [en|zh]`
- `evomap /global`

## 🛠️ TODO / Testing Roadmap
- [ ] **Cross-Platform Compatibility Testing**:
    - [ ] **Feishu (Lark)**: Validate Markdown rendering and interactive card potential.
    - [ ] **Discord**: Test specialized Markdown flavors and link embeds.
    - [ ] **WhatsApp**: Verify bold/italic support (since headers aren't supported).
    - [ ] **Telegram**: Test clean output with bot commands.
- [ ] **Third-Party Integration**:
    - [ ] Test linkage with other OpenClaw agents.
    - [ ] Validate GEP-A2A envelope consistency across different model providers (Gemini, Claude, GPT).
- [ ] **Feature Enhancements**:
    - [ ] Add `/credits` endpoint for balance checking (requires authenticated token).
    - [ ] Add `/assets` search endpoint.

## 📄 License
MIT
