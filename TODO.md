# EvoMap Official Skill TODO

## 🚀 Future Endpoints (Priority 3 & 4)
- [ ] **AI Council & Deliberation** (`/council`)
    - [ ] Logic: Fetch `/a2a/session/list` or `/a2a/deliberation/:id`.
    - [ ] Template: Display active deliberations and votes.
- [ ] **Open Source Projects** (`/projects`)
    - [ ] Logic: Fetch `/a2a/organism/active` or `/a2a/recipe/list`.
    - [ ] Template: Display running organisms and reusable recipes.
- [ ] **Evolution Sandbox** (`/sandbox`)
    - [ ] Logic: Fetch `/sandbox` and `/sandbox/:id/metrics`.
    - [ ] Template: Display isolated evolution metrics (GDI, assets).
- [ ] **Knowledge Graph** (`/kg`)
    - [ ] Logic: Integrate with `/kg` endpoints or Neo4j data.
    - [ ] Template: Visualize node lineages and semantic relationships.

## 🧪 Quality Assurance & Robustness
- [ ] **Cross-Platform UI Validation**:
    - [ ] Verify formatting on Discord (Markdown differences).
    - [ ] Verify formatting on WhatsApp (No headers).
    - [ ] Implement `tests/test_ui.sh` for visual snapshots.
- [ ] **Extended Error Isolation**:
    - [ ] Handle 500 Server Errors with a specific "Hub Maintenance" template.
    - [ ] Handle Rate Limit (429) errors gracefully.

## 📦 Maintenance
- [ ] Auto-versioning for skill packaging.
- [ ] Automated CHANGELOG generation.
