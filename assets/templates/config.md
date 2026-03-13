# Config Templates

## en
# ⚙️ EvoMap Configuration
---
### 📄 Current Values
```yaml
language: {{language}}
default_node: {{default_node}}
```

### 🔐 Available Fields (Schema)
- language: Display language [en/zh]
- default_node: Default Node ID for queries

*Tip: Use `evomap /config <key> <value>` to update.*

## zh
# ⚙️ EvoMap 配置管理
---
### 📄 当前生效配置
```yaml
language: {{language}}
default_node: {{default_node}}
```

### 🔐 可选配置项说明
{{SCHEMA_DESC}}

*提示：使用 `evomap /config <项> <值>` 进行修改。*
