#!/bin/bash
# Claude Code 插件创建脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PLUGINS_DIR="$REPO_ROOT/plugins"

if [ -z "$1" ]; then
    echo "用法: $0 <plugin-name>"
    echo ""
    echo "示例:"
    echo "  $0 my-awesome-plugin"
    exit 1
fi

PLUGIN_NAME="$1"
PLUGIN_DIR="$PLUGINS_DIR/$PLUGIN_NAME"

# 检查插件是否已存在
if [ -d "$PLUGIN_DIR" ]; then
    echo "错误: 插件 '$PLUGIN_NAME' 已存在于 $PLUGIN_DIR"
    exit 1
fi

# 创建插件目录结构
echo "创建插件: $PLUGIN_NAME"
mkdir -p "$PLUGIN_DIR"/{skills,commands,hooks}

# 复制模板文件
cp "$PLUGINS_DIR/templates/plugin.json" "$PLUGIN_DIR/plugin.json"
cp "$PLUGINS_DIR/templates/README.md" "$PLUGIN_DIR/README.md"

# 替换模板变量
sed -i "s/{{plugin-name}}/$PLUGIN_NAME/g" "$PLUGIN_DIR/plugin.json"
sed -i "s/{{Plugin Name}}/$PLUGIN_NAME/g" "$PLUGIN_DIR/README.md"
sed -i "s/{{plugin-name}}/$PLUGIN_NAME/g" "$PLUGIN_DIR/README.md"
sed -i "s/{{Plugin description}}/Plugin description/g" "$PLUGIN_DIR/plugin.json"
sed -i "s/{{Plugin description}}/Plugin description/g" "$PLUGIN_DIR/README.md"

# 创建空的 hooks.json
cat > "$PLUGIN_DIR/hooks/hooks.json" << 'EOF'
{
  "description": "Hooks for PLUGIN_NAME",
  "hooks": {}
}
EOF
sed -i "s/PLUGIN_NAME/$PLUGIN_NAME/g" "$PLUGIN_DIR/hooks/hooks.json"

# 创建示例 skill
cat > "$PLUGIN_DIR/skills/example.md" << 'EOF'
# Example Skill

This is an example skill. Replace this with your actual skill implementation.

Describe what this skill does and how it should behave.
EOF

# 创建示例 command
cat > "$PLUGIN_DIR/commands/example.md" << 'EOF'
# Example Command

Description of the example command.

## Usage

```bash
/example
```

## Description

This is an example command. Replace this with your actual command.
EOF

echo "✓ 插件 '$PLUGIN_NAME' 创建成功！"
echo ""
echo "下一步:"
echo "  1. 编辑插件配置: $PLUGIN_DIR/plugin.json"
echo "  2. 添加 skills: $PLUGIN_DIR/skills/"
echo "  3. 添加 commands: $PLUGIN_DIR/commands/"
echo "  4. 配置 hooks: $PLUGIN_DIR/hooks/hooks.json"
echo "  5. 测试插件: cc --plugin-dir $PLUGIN_DIR"
