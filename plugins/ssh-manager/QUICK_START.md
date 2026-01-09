# SSH Manager - 快速使用指南

SSH 管理器插件现已完全可用！以下是所有命令的快速参考。

## ✅ 已安装

如果你看到这个文档，说明插件已成功安装。

## 📋 可用命令

### 1. 列出所有连接

```bash
/ssh-list
```

**示例输出**：
```
SSH Connections:

ID    Name                 Host                           User            Port
------------------------------------------------------------------------------------------------
1     localhost            127.0.0.1                      root            2222
2     production           prod.example.com               admin           22
3     staging-db           staging.db.example.com         dbuser          22
4     github               github.com                     git             22
```

### 2. 添加新连接

```bash
/ssh-add <name> <host> <user> [port] [identity_file] [description]
```

**示例**：
```bash
# 基本连接
/ssh-add myserver 192.168.1.100 root

# 带端口
/ssh-add myserver 192.168.1.100 root 2222

# 带私钥
/ssh-add github github.com git 22 ~/.ssh/id_rsa

# 完整配置
/ssh-add production prod.example.com admin 22 ~/.ssh/prod_key "Production server"
```

**参数说明**：
- `name` - 连接名称（必需，唯一）
- `host` - 主机地址或 IP（必需）
- `user` - SSH 用户名（必需）
- `port` - SSH 端口（可选，默认 22）
- `identity_file` - 私钥路径（可选）
- `description` - 描述（可选）

### 3. 编辑连接

```bash
/ssh-edit <index> <field>=<value> [<field>=<value> ...]
```

**示例**：
```bash
# 修改主机
/ssh-edit 1 host=new.example.com

# 修改多个字段
/ssh-edit 1 host=new.example.com port=2222

# 添加描述
/ssh-edit 1 description="Updated server"

# 移除私钥
/ssh-edit 1 identity_file=null
```

**可用字段**：
- `name` - 连接名称
- `host` - 主机地址
- `user` - 用户名
- `port` - 端口号
- `identity_file` - 私钥路径
- `description` - 描述

### 4. 删除连接

```bash
/ssh-delete <index>
```

**示例**：
```bash
/ssh-delete 1
```

## 💡 使用技巧

### 查找索引

使用 `/ssh-list` 查看所有连接，记住要操作的连接索引号。

### 批量操作

可以连续使用多个命令：

```bash
/ssh-list        # 查看所有连接
/ssh-add ...     # 添加新连接
/ssh-list        # 确认添加
/ssh-edit 2 ...  # 修改连接 2
/ssh-delete 1    # 删除连接 1
```

### 数据备份

连接数据存储在：
```
/workspace/xm/claude-plugins/plugins/ssh-manager/data/connections.jsonl
```

**备份数据**：
```bash
cp /workspace/xm/claude-plugins/plugins/ssh-manager/data/connections.jsonl \
   /workspace/xm/claude-plugins/plugins/ssh-manager/data/connections.jsonl.backup
```

**查看原始数据**：
```bash
cat /workspace/xm/claude-plugins/plugins/ssh-manager/data/connections.jsonl | jq '.'
```

## 🔧 故障排除

### 命令不生效

确保插件已正确安装：
```bash
/plugin
# 应该能看到 ssh-manager
```

### 数据文件为空

如果没有任何连接，添加一个测试连接：
```bash
/ssh-add localhost 127.0.0.1 root 2222
```

### jq 错误

确保系统已安装 jq：
```bash
# Alpine
apk add jq

# Ubuntu/Debian
apt-get install jq
```

## 📊 数据格式

每条连接以 JSON 格式存储：

```json
{
  "id": "1234567890",
  "name": "localhost",
  "host": "127.0.0.1",
  "user": "root",
  "port": 2222,
  "identity_file": null,
  "description": "Local development server",
  "created_at": "2026-01-09T12:00:00Z",
  "updated_at": "2026-01-09T12:00:00Z"
}
```

## 🎯 快速示例

完整的操作流程：

```bash
# 1. 查看当前连接
/ssh-list

# 2. 添加开发服务器
/ssh-add dev dev.example.com developer 22 ~/.ssh/id_dev

# 3. 添加生产服务器
/ssh-add prod prod.example.com admin 22 ~/.ssh/id_prod "Production - use with caution"

# 4. 修改开发服务器端口
/ssh-edit 1 port=2222

# 5. 删除测试连接
/ssh-delete 3

# 6. 确认最终状态
/ssh-list
```

## 📚 更多信息

- 完整文档：[README.md](./README.md)
- 使用示例：[USAGE_EXAMPLES.md](./USAGE_EXAMPLES.md)
- 插件开发指南：[../../docs/从零开始构建Claude-Code插件生态系统-实战指南.md](../../docs/从零开始构建Claude-Code插件生态系统-实战指南.md)

---

**插件版本**: 1.0.0
**最后更新**: 2026-01-09
**状态**: ✅ 完全可用
