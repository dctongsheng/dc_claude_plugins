# Claude Code 插件开发指南

本指南帮助你快速开发 Claude Code 插件。

## 快速开始

### 1. 创建新插件

```bash
# 使用脚本创建插件（如果有）
./scripts/create-plugin.sh my-new-plugin

# 或手动创建
mkdir -p plugins/my-new-plugin/{skills,commands,hooks}
cp plugins/templates/plugin.json plugins/my-new-plugin/
cp plugins/templates/README.md plugins/my-new-plugin/
```

### 2. 编辑 plugin.json

```json
{
  "name": "my-new-plugin",
  "version": "1.0.0",
  "description": "我的新插件",
  "author": "Your Name",
  "license": "MIT"
}
```

### 3. 添加功能

#### 创建 Skill

在 `skills/` 目录创建 `my-skill.md`：

```markdown
# My Skill

You are an expert in [topic]. When the user asks about [topic], provide detailed and helpful responses.
```

#### 创建 Command

在 `commands/` 目录创建 `my-command.md`：

```markdown
# My Command

Description of what this command does.

## Usage

```bash
/my-command [args]
```
```

#### 添加 Hooks

编辑 `hooks/hooks.json`：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Before writing files, check if they contain sensitive data."
          }
        ]
      }
    ]
  }
}
```

### 4. 测试插件

```bash
cc --plugin-dir /workspace/xm/claude-plugins/plugins/my-new-plugin
```

### 5. 更新 marketplace.json

```json
{
  "plugins": [
    {
      "name": "my-new-plugin",
      "description": "我的新插件",
      "source": "./plugins/my-new-plugin",
      "category": "development"
    }
  ]
}
```

## 插件结构

```
plugin-name/
├── plugin.json       # 必需：插件清单
├── README.md         # 推荐：插件文档
├── skills/           # 可选：技能目录
│   └── *.md         # 技能文件
├── commands/         # 可选：命令目录
│   └── *.md         # 命令文件
├── hooks/            # 可选：钩子目录
│   └── hooks.json   # 钩子配置
└── .mcp.json        # 可选：MCP 服务器配置
```

## 高级功能

### MCP 集成

创建 `.mcp.json`：

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/servers/my-server.js"],
      "env": {
        "API_KEY": "${API_KEY}"
      }
    }
  }
}
```

### Hook 类型

1. **Prompt Hooks** - 修改 AI 行为
2. **Command Hooks** - 执行 shell 命令

### 可用 Hook 事件

- `SessionStart` - 会话开始
- `SessionEnd` - 会话结束
- `PreToolUse` - 工具使用前
- `PostToolUse` - 工具使用后

## 最佳实践

1. **命名规范**
   - 插件名使用小写字母和连字符：`my-awesome-plugin`
   - Skills 和 Commands 使用清晰的名称

2. **文档**
   - 为每个插件编写详细的 README
   - 在 Skills 中提供使用示例
   - 在 Commands 中说明用法

3. **错误处理**
   - 在 Command hooks 中验证输入
   - 提供有用的错误消息

4. **测试**
   - 使用 `--plugin-dir` 本地测试
   - 测试所有 Skills 和 Commands
   - 验证 Hooks 正常工作

## 调试技巧

```bash
# 启用调试模式
cc --debug --plugin-dir /workspace/xm/claude-plugins/plugins/my-plugin

# 查看插件日志
# 调试输出会显示在终端
```

## 参考资源

- [Claude Code 官方文档](https://github.com/anthropics/claude-code)
- [Plugin Development Guide](https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev)
- [MCP 协议规范](https://modelcontextprotocol.io/)
