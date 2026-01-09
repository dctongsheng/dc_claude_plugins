# SSH Manager Plugin

管理 SSH 连接信息的 Claude Code 插件。提供增删改查功能，数据以 JSONL 格式存储。

## 功能特性

- **列出所有连接** - 查看所有保存的 SSH 连接
- **添加连接** - 添加新的 SSH 连接信息
- **编辑连接** - 修改现有连接的配置
- **删除连接** - 删除不再需要的连接

## 数据存储

连接信息以 JSONL (JSON Lines) 格式存储在 `data/connections.jsonl` 文件中：

```json
{"id": "1234567890", "name": "production", "host": "prod.example.com", "user": "admin", "port": 22, "identity_file": null, "description": "Production server", "created_at": "2026-01-09T12:00:00Z", "updated_at": "2026-01-09T12:00:00Z"}
```

## 安装

```bash
cc --plugin-dir /workspace/xm/claude-plugins/plugins/ssh-manager
```

## 使用方法

### 列出所有连接

```bash
/ssh-list
```

输出示例：
```
SSH Connections:

ID    Name                 Host                           User            Port
------------------------------------------------------------------------------------------------
1     production-server    prod.example.com               admin           22
2     staging-db           staging.db.example.com          dbuser          22
```

### 添加新连接

```bash
# 基本连接
/ssh-add production prod.example.com admin

# 带端口和描述
/ssh-add production prod.example.com admin 2222 ~/.ssh/id_rsa "Production server"
```

参数说明：
- `name` - 连接名称（必须唯一）
- `host` - 主机地址或 IP
- `user` - SSH 用户名
- `port` - SSH 端口（可选，默认 22）
- `identity_file` - SSH 私钥路径（可选）
- `description` - 连接描述（可选）

### 编辑连接

```bash
# 更新单个字段
/ssh-edit 1 host=new.example.com

# 更新多个字段
/ssh-edit 1 host=new.example.com port=2222 description="Updated server"
```

可用字段：
- `name` - 连接名称
- `host` - 主机地址
- `user` - 用户名
- `port` - 端口号
- `identity_file` - 私钥路径
- `description` - 描述

### 删除连接

```bash
/ssh-delete 1
```

## 数据结构

每条连接记录包含以下字段：

```json
{
  "id": "唯一ID",
  "name": "连接名称",
  "host": "主机地址",
  "user": "用户名",
  "port": 端口号,
  "identity_file": "私钥路径或null",
  "description": "描述或null",
  "created_at": "创建时间(ISO 8601)",
  "updated_at": "更新时间(ISO 8601)"
}
```

## 备份和恢复

### 备份

```bash
cp data/connections.jsonl data/connections.jsonl.backup
```

### 恢复

```bash
cp data/connections.jsonl.backup data/connections.jsonl
```

## 开发

插件使用 Bash 脚本处理数据：

- `scripts/ssh-manager-lib.sh` - 核心函数库
- `data/connections.jsonl` - 数据存储文件

## 依赖

- `jq` - JSON 处理工具

安装 jq：
```bash
# Ubuntu/Debian
apt-get install jq

# macOS
brew install jq
```

## 许可证

MIT
