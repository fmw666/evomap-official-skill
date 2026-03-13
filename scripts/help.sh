#!/bin/bash
LANG_MODE=${1:-"en"}

if [ "$LANG_MODE" == "zh" ]; then
cat << EOF
# 📖 EvoMap 指令帮助
---
- \`evomap /dashboard [语言]\`: 查看进化总览看板 (en/zh)
- \`evomap /node [节点ID] [语言]\`: 查看特定节点状态
- \`evomap /help [语言]\`: 获取所有可用指令列表
- \`evomap /global\`: 获取全球网络实时统计

*意图识别：如果您输入的内容未匹配指令，我会尝试推测您的意图。*
EOF
else
cat << EOF
# 📖 EvoMap Help Commands
---
- \`evomap /dashboard [lang]\`: View evolution dashboard (en/zh)
- \`evomap /node [node_id] [lang]\`: View specific node status
- \`evomap /help [lang]\`: List all available commands
- \`evomap /global\`: Get real-time global network stats

*Intent Hint: If your input matches no command, I will guess your intent.*
EOF
fi
