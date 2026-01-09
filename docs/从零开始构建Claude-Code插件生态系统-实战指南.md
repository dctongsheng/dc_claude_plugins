# 从零开始构建 Claude Code 插件生态系统：实战指南

> 在本文中，我将分享从零开始创建 Claude Code 插件市场的完整旅程，包括踩过的坑、解决的问题以及从官方文档中学到的最佳实践。

![Claude Code](https://img.shields.io/badge/Claude_Code-Plugin_Dev-success)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)
![Time](https://img.shields.io/badge/Reading_Time-15_min-blue)

---

## 📖 目录

- [前言：为什么要构建插件系统](#前言为什么要构建插件系统)
- [第一部分：准备工作](#第一部分准备工作)
- [第二部分：搭建插件市场](#第二部分搭建插件市场)
- [第三部分：开发第一个插件](#第三部分开发第一个插件)
- [第四部分：踩坑与排雷](#第四部分踩坑与排雷)
- [第五部分：最佳实践总结](#第五部分最佳实践总结)
- [总结与展望](#总结与展望)

---

## 🎯 前言：为什么要构建插件系统

作为一名开发者，我经常需要管理大量的 SSH 连接、记住各种服务器地址、维护多个开发环境。当我发现 Claude Code 支持插件系统时，我意识到这是一个绝佳的机会来提升我的工作效率。

**本文的目标**：

- ✅ 创建一个个人插件市场，方便管理和分发插件
- ✅ 开发一个实用的 SSH 连接管理器
- ✅ 记录踩过的坑，帮助后来者避开
- ✅ 整理官方文档精华，形成最佳实践指南

**你将学到**：

- Claude Code 插件系统的完整架构
- 如何创建符合规范的插件市场
- Commands、Skills、Hooks 的使用方法
- JSONL 数据存储的实践应用
- 插件开发的常见问题和解决方案

---

## 🚀 第一部分：准备工作

### 环境配置

我使用的是 Docker-in-Docker 容器环境：

```bash
# 容器信息
容器名: bws-dind-dev-26
项目目录: /workspace/xm/claude-plugins
```

### 必备工具

**1. jq - JSON 处理神器**

```bash
# Ubuntu/Debian
apt-get update && apt-get install -y jq

# Alpine Linux
apk add jq

# macOS
brew install jq
```

为什么需要 jq？因为我们需要处理 JSONL 格式的数据存储。

**2. 初始化 Git 仓库**

```bash
cd /workspace/xm/claude-plugins
git init

# 配置用户信息
git config user.name "Claude Plugins Developer"
git config user.email "developer@claude-plugins.local"
```

---

## 🏗️ 第二部分：搭建插件市场

### 理解 Claude Code 插件架构

在开始之前，我花时间研究了官方文档，发现 Claude Code 的插件系统非常模块化：

```
插件市场 (Marketplace)
├── 插件 A (Plugin)
│   ├── Commands (命令)
│   ├── Skills (技能)
│   ├── Hooks (钩子)
│   └── MCP Servers (可选)
├── 插件 B
└── 插件 C
```

### 关键文件结构

根据官方规范，这是正确的目录结构：

```
claude-plugins/
├── .claude-plugin/          # ⚠️ 重要：市场配置目录
│   └── marketplace.json     # 市场清单文件
├── plugins/                 # 插件存放目录
│   ├── ssh-manager/
│   └── example-plugin/
├── scripts/                 # 工具脚本
├── docs/                    # 文档
└── README.md
```

### 创建市场配置文件

**文件位置**：`.claude-plugin/marketplace.json`

```json
{
  "$schema": "https://anthropic.com/claude-code/marketplace.schema.json",
  "name": "personal-plugins",
  "version": "1.0.0",
  "description": "Personal collection of development and utility plugins",
  "owner": {
    "name": "Your Name",
    "email": "your.email@example.com"
  },
  "plugins": [
    {
      "name": "ssh-manager",
      "description": "Manage SSH connections with CRUD operations",
      "source": "./plugins/ssh-manager",
      "category": "utilities"
    }
  ]
}
```

**💡 关键点**：
- 配置文件必须在 `.claude-plugin/` 目录下
- `source` 路径使用相对路径 `./`
- 市场名称不能包含保留词（后面会详细说明）

---

## 💻 第三部分：开发第一个插件

### 需求分析

我需要一个 SSH 连接管理器，功能包括：

- 📋 查看所有 SSH 连接
- ➕ 添加新连接
- ✏️ 编辑现有连接
- 🗑️ 删除连接

**技术选型**：
- 使用 **Commands** 实现具体功能
- 使用 **JSONL** 格式存储数据
- 使用 **Bash + jq** 处理数据

### 插件结构设计

```
ssh-manager/
├── plugin.json              # 插件清单
├── README.md                # 使用文档
├── USAGE_EXAMPLES.md        # 详细示例
├── commands/                # 命令定义
│   ├── ssh-list.md         # 列出连接
│   ├── ssh-add.md          # 添加连接
│   ├── ssh-edit.md         # 编辑连接
│   └── ssh-delete.md       # 删除连接
├── scripts/
│   └── ssh-manager-lib.sh  # 核心逻辑
└── data/
    └── connections.jsonl   # 数据存储
```

### 编写 plugin.json

根据官方文档，这是正确格式：

```json
{
  "name": "ssh-manager",
  "version": "1.0.0",
  "description": "Manage SSH connection information with CRUD operations",
  "author": {
    "name": "Claude Plugins Developer",
    "email": "developer@claude-plugins.local"
  },
  "license": "MIT"
}
```

**⚠️ 注意**：只使用官方支持的字段，不要添加自定义字段！

### 实现 Commands

Commands 是 Claude Code 插件的核心功能，通过 Markdown 文件定义。

#### 示例：ssh-add.md

```markdown
# SSH Add Command

Add a new SSH connection.

## Usage

```bash
/ssh-add <name> <host> <user> [port] [identity_file] [description]
```

## Examples

```bash
# Basic connection
/ssh-add production prod.example.com admin

# With custom port
/ssh-add production prod.example.com admin 2222

# Full configuration
/ssh-add production prod.example.com admin 22 ~/.ssh/id_rsa "Production server"
```
```

### 数据存储实现

我选择 JSONL 格式，每行一个 JSON 对象：

```json
{"id":"1736419200000000000","name":"localhost","host":"127.0.0.1","user":"root","port":2222,"identity_file":null,"description":null,"created_at":"2026-01-09T12:00:00Z","updated_at":"2026-01-09T12:00:00Z"}
{"id":"1736419200000000001","name":"production","host":"prod.example.com","user":"admin","port":22,"identity_file":"/home/user/.ssh/id_rsa","description":"Production server","created_at":"2026-01-09T12:05:00Z","updated_at":"2026-01-09T12:05:00Z"}
```

**为什么选择 JSONL？**

- ✅ 易于追加新记录
- ✅ 简单的删除操作
- ✅ 适合大量数据
- ✅ 可以用文本编辑器查看

### 核心逻辑实现

创建 `scripts/ssh-manager-lib.sh`：

```bash
#!/bin/bash
set -e

DATA_FILE="$SCRIPT_DIR/../data/connections.jsonl"

# 列出所有连接
list_connections() {
    echo "SSH Connections:"
    printf "%-5s %-20s %-30s %-15s %-10s\n" "ID" "Name" "Host" "User" "Port"
    echo "------------------------------------------------------------------------------------------------"

    local index=1
    while IFS= read -r line; do
        local name=$(echo "$line" | jq -r '.name')
        local host=$(echo "$line" | jq -r '.host')
        local user=$(echo "$line" | jq -r '.user')
        local port=$(echo "$line" | jq -r '.port // 22')

        printf "%-5s %-20s %-30s %-15s %-10s\n" "$index" "$name" "$host" "$user" "$port"
        ((index++))
    done < "$DATA_FILE"
}

# 添加连接
add_connection() {
    local name="$1"
    local host="$2"
    local user="$3"
    local port="${4:-22}"

    local id=$(date +%s%N)
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    echo "{\"id\":\"$id\",\"name\":\"$name\",\"host\":\"$host\",\"user\":\"$user\",\"port\":$port,\"created_at\":\"$timestamp\",\"updated_at\":\"$timestamp\"}" >> "$DATA_FILE"
}

export -f list_connections
export -f add_connection
```

---

## 💣 第四部分：踩坑与排雷

这一章是本文的精华！我记录了开发过程中遇到的所有问题和解决方案。

### 问题 1：市场配置文件找不到 ❌

**错误信息**：
```
Marketplace file not found at
/workspace/xm/claude-plugins/.claude-plugin/marketplace.json
```

**原因分析**：
我将 `marketplace.json` 放在了根目录，而不是 `.claude-plugin/` 子目录下。

**解决方案**：
```bash
# 创建正确的目录
mkdir -p .claude-plugin

# 移动配置文件
mv marketplace.json .claude-plugin/marketplace.json
```

**教训**：
> Claude Code 对目录结构有严格要求，市场配置必须在 `<marketplace-path>/.claude-plugin/marketplace.json`

---

### 问题 2：市场名称包含保留词 ❌

**错误信息**：
```
Invalid schema: name: Marketplace name cannot impersonate official
Anthropic/Claude marketplaces. Names containing "official", "anthropic",
or "claude" in official-sounding combinations are reserved.
```

**原因分析**：
我使用了 "claude-plugins" 作为市场名称，包含了保留词 "claude"。

**解决方案**：
```json
{
  "name": "personal-plugins",  // ✅ 正确
  "description": "Personal collection of development and utility plugins"
}
```

**命名规则总结**：

| 名称 | 状态 | 原因 |
|------|------|------|
| `personal-plugins` | ✅ 有效 | 不包含保留词 |
| `my-dev-tools` | ✅ 有效 | 描述性强 |
| `claude-plugins` | ❌ 无效 | 包含 "claude" |
| `anthropic-tools` | ❌ 无效 | 包含 "anthropic" |
| `official-plugins` | ❌ 无效 | 包含 "official" |

---

### 问题 3：plugin.json 包含无效字段 ❌

**错误信息**：
```
Error: Failed to install: Plugin has an invalid manifest file.
Validation errors: : Unrecognized key(s) in object: 'claude'
```

**原因分析**：
我在 `plugin.json` 中添加了自定义字段：

```json
{
  "claude": {
    "minVersion": "1.0.0"  // ❌ 这个字段不被支持
  }
}
```

**解决方案**：
删除无效字段，只保留官方支持的字段：

```json
{
  "name": "ssh-manager",
  "version": "1.0.0",
  "description": "Manage SSH connections",
  "author": {
    "name": "Developer",
    "email": "developer@example.com"
  },
  "license": "MIT"
}
```

**官方支持的字段**：

```json
{
  // === 必需字段 ===
  "name": "plugin-name",           // 插件名称（kebab-case）

  // === 可选字段 ===
  "version": "1.0.0",              // 语义化版本号
  "description": "Plugin desc",    // 插件描述
  "author": {                      // 作者信息
    "name": "Author",
    "email": "author@example.com",
    "url": "https://example.com"
  },
  "license": "MIT",                // 许可证
  "homepage": "https://docs...",   // 主页
  "repository": {                  // 仓库信息
    "type": "git",
    "url": "https://github.com/..."
  },
  "keywords": ["tool", "util"],    // 关键词
  "commands": ["./commands"],      // 命令目录
  "agents": "./agents",            // 代理目录
  "hooks": "./hooks.json",         // 钩子配置
  "mcpServers": "./.mcp.json"      // MCP 服务器配置
}
```

---

### 问题 4：插件名称格式错误 ❌

**验证规则**：
插件名称必须符合 kebab-case 格式：

**正则表达式**：
```javascript
/^[a-z][a-z0-9]*(-[a-z0-9]+)*$/
```

**有效示例**：
- ✅ `my-plugin`
- ✅ `ssh-manager`
- ✅ `code-quality-checker`
- ✅ `dev-tools`

**无效示例**：
- ❌ `My Plugin` - 包含空格和大写
- ❌ `my_plugin` - 使用下划线
- ❌ `my-plugin-` - 结尾有连字符
- ❌ `-my-plugin` - 开头有连字符
- ❌ `my--plugin` - 连续连字符

**命名建议**：
```bash
# 使用连字符连接单词
ssh-manager        # ✅ 清晰
code-review-tool   # ✅ 描述性强

# 避免缩写（除非很常见）
ssh-mgr            # ⚠️ 不推荐
ssh-manager        # ✅ 推荐
```

---

## 📚 第五部分：最佳实践总结

基于官方文档和实战经验，我总结出以下最佳实践。

### 1. 命名规范 📝

**插件命名**：
```bash
# 好的命名
ssh-manager
code-quality-tool
database-migrator

# 不好的命名
SSHManager         # 不要驼峰
ssh_manager        # 不要下划线
ssh-mgr            # 不要过度缩写
```

**Commands 命名**：
```bash
# 使用前缀避免冲突
/ssh-add
/ssh-list
/ssh-delete

# 动词开头
/list-connections
/add-server
/delete-config
```

### 2. 文档优先 📖

每个插件应该包含：

```
plugin-name/
├── README.md              # 快速开始
├── USAGE_EXAMPLES.md      # 详细示例
└── commands/
    └── command.md         # 命令文档
```

**README.md 模板**：
```markdown
# Plugin Name

Brief description.

## Features

- Feature 1
- Feature 2

## Installation

```bash
/plugin install plugin-name@marketplace
```

## Usage

\`\`\`bash
/command-name
\`\`\`

## Examples

Detailed usage examples...
```

### 3. 数据管理 💾

**推荐格式**：

| 格式 | 优点 | 缺点 | 适用场景 |
|------|------|------|----------|
| **JSONL** | 易追加、删除 | 不支持嵌套 | 日志、记录 |
| **JSON** | 结构化 | 需要读写整个文件 | 配置文件 |
| **SQLite** | 支持查询 | 需要额外依赖 | 复杂数据 |

**数据位置**：
```
plugin-name/
└── data/
    └── data.jsonl
```

**.gitignore 配置**：
```bash
# 忽略用户数据
data/*.jsonl

# 但保留示例数据
!data/example.jsonl
```

### 4. 错误处理 🛡️

```bash
#!/bin/bash
set -e  # 遇到错误立即退出

# 输入验证
if [ -z "$1" ]; then
    echo "Error: Missing required argument" >&2
    return 1
fi

# 数据验证
ensure_data_file() {
    if [ ! -f "$DATA_FILE" ]; then
        touch "$DATA_FILE"
    fi
}

# 错误处理
safe_operation() {
    if ! operation_that_might_fail; then
        echo "Error: Operation failed" >&2
        return 1
    fi
}
```

### 5. 版本控制 🔄

**提交信息规范**：
```bash
feat: Add new feature
fix: Fix bug in command
docs: Update README
refactor: Refactor core logic
test: Add test cases
chore: Update dependencies
```

**.gitignore 建议**：
```bash
# macOS
.DS_Store

# IDEs
.idea/
.vscode/
*.swp

# Logs
*.log

# Data
data/*.jsonl

# Temporary files
*.tmp
*.temp
```

### 6. 测试流程 🧪

```bash
# 1. 本地测试
cc --plugin-dir /path/to/plugin

# 2. 测试 commands
/ssh-list
/ssh-add test 127.0.0.1 root

# 3. 验证数据
cat data/connections.jsonl | jq '.'

# 4. 调试模式
cc --debug --plugin-dir /path/to/plugin

# 5. 清理测试数据
rm data/connections.jsonl
```

---

## 🎯 总结与展望

### 项目成果

经过这次实践，我成功创建了：

✅ **完整的插件市场** - 符合 Claude Code 官方规范
✅ **SSH 管理器** - 功能完整的 CRUD 插件
✅ **开发工具** - 插件创建脚本和模板
✅ **详细文档** - 使用说明和开发指南

### Git 提交历史

```bash
bdfff1c docs: Add comprehensive plugin development guide
2108e97 Fix: Remove invalid 'claude' field from plugin.json
ec44131 Fix: Rename marketplace to avoid reserved keywords
2abad78 Fix: Move marketplace.json to correct location
091a637 Add ssh-manager plugin
1b5fc92 Initial commit: Claude Code plugins repository
```

### 关键收获

1. **遵循规范是关键**
   - 严格遵守官方文档规范
   - 避免使用保留词和无效字段
   - 目录结构必须符合要求

2. **踩坑是学习的一部分**
   - 每个错误都是学习机会
   - 官方文档是最好的参考
   - 调试模式很有帮助

3. **文档很重要**
   - 良好的文档让插件更易用
   - 示例代码胜过千言万语
   - 记录问题帮助他人

### 未来计划

- [ ] 添加更多实用插件（数据库管理、Docker 管理等）
- [ ] 实现插件间的协作功能
- [ ] 集成 MCP 服务器
- [ ] 推送到 GitHub 公开分享
- [ ] 收集用户反馈持续优化

### 资源链接

- 📖 [Claude Code 官方文档](https://github.com/anthropics/claude-code)
- 📚 [插件开发指南](https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev)
- 🔌 [MCP 协议规范](https://modelcontextprotocol.io/)
- 💻 [我的插件仓库](https://github.com/yourusername/claude-plugins)（待上传）

---

## 💬 结语

创建 Claude Code 插件市场是一次非常有价值的实践。虽然过程中遇到了不少问题，但每一次解决都让我对插件系统有了更深入的理解。

希望这篇实战指南能够帮助你：
- 🚀 快速上手插件开发
- ⚠️ 避开我踩过的坑
- 📚 掌握最佳实践
- 💡 激发更多创意

**如果你有任何问题或建议，欢迎交流！**

---

**文章信息**
- 📅 发布日期：2026-01-09
- ⏱️ 阅读时间：15 分钟
- 🏷️ 标签：#ClaudeCode #Plugin #Dev #Tutorial

**下一篇文章预告**
《深入 Claude Code Hooks：自动化你的开发流程》

---

<div align="center">

**如果这篇文章对你有帮助，请给个 ⭐️**

Made with ❤️ by Claude Plugins Developer

</div>
