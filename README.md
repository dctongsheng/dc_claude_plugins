# Claude Code Plugins Collection

个人 Claude Code 插件集合，用于扩展和定制 Claude Code 的功能。

## 项目结构

```
claude-plugins/
├── plugins/                    # 插件目录
│   ├── plugin-name/           # 单个插件
│   │   ├── plugin.json        # 插件清单
│   │   ├── skills/            # 技能（自动发现）
│   │   ├── commands/          # 命令（自动发现）
│   │   ├── hooks/             # 钩子
│   │   │   └── hooks.json     # 钩子配置
│   │   ├── .mcp.json          # MCP 服务器配置（可选）
│   │   └── README.md          # 插件说明
│   └── ...
├── marketplace.json           # 市场配置
└── README.md                  # 本文件
```

## 插件列表

### 可用插件

<!-- 在这里添加你的插件 -->

## 安装方法

### 从本地加载插件

```bash
# 加载整个插件集合
cc --plugin-dir /workspace/xm/claude-plugins

# 加载单个插件
cc --plugin-dir /workspace/xm/claude-plugins/plugins/plugin-name
```

### 安装单个插件

```bash
/plugin install plugin-name@claude-plugins
```

## 开发新插件

### 1. 创建插件目录

```bash
mkdir -p plugins/your-plugin-name/{skills,commands,hooks}
```

### 2. 创建 plugin.json

```json
{
  "name": "your-plugin-name",
  "version": "1.0.0",
  "description": "插件描述",
  "author": "Your Name",
  "license": "MIT"
}
```

### 3. 添加功能

- **Skills**: 在 `skills/` 目录下创建 `.md` 文件
- **Commands**: 在 `commands/` 目录下创建 `.md` 文件
- **Hooks**: 在 `hooks/hooks.json` 中配置钩子
- **MCP Servers**: 在 `.mcp.json` 中配置 MCP 服务器

### 4. 测试插件

```bash
cc --plugin-dir /workspace/xm/claude-plugins/plugins/your-plugin-name
```

## 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

## 许可证

MIT License

## 作者

Your Name - [GitHub](https://github.com/yourusername)
