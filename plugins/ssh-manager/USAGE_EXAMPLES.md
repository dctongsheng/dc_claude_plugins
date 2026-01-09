# SSH Manager - 使用示例

## 快速开始

### 1. 添加 SSH 连接

```bash
# 添加本地开发服务器
/ssh-add localhost 127.0.0.1 root 2222

# 添加生产服务器
/ssh-add production prod.example.com admin 22 ~/.ssh/id_rsa "Production web server"

# 添加数据库服务器
/ssh-add staging-db db.example.com dbuser
```

### 2. 查看所有连接

```bash
/ssh-list
```

输出：
```
SSH Connections:

ID    Name                 Host                           User            Port
------------------------------------------------------------------------------------------------
1     localhost            127.0.0.1                       root            2222
2     production           prod.example.com               admin           22
3     staging-db           db.example.com                  dbuser          22
```

### 3. 编辑连接

```bash
# 修改主机地址
/ssh-edit 2 host=prod2.example.com

# 修改用户和端口
/ssh-edit 2 user=admin2 port=2222

# 添加描述
/ssh-edit 3 description="Staging database server"

# 更新私钥路径
/ssh-edit 2 identity_file=~/.ssh/prod_key
```

### 4. 删除连接

```bash
# 删除第 3 个连接
/ssh-delete 3
```

## 实际使用场景

### 场景 1：管理多环境服务器

```bash
# 开发环境
/ssh-add dev dev.example.com dev 22

# 测试环境
/ssh-add test test.example.com test 22

# 预发布环境
/ssh-add staging staging.example.com admin 22

# 生产环境
/ssh-add prod prod.example.com admin 22 ~/.ssh/prod_key "Production - use with caution"
```

### 场景 2：管理不同端口的容器

```bash
# Docker 容器 1
/ssh-add docker1 localhost root 2222

# Docker 容器 2
/ssh-add docker2 localhost root 2223

# Docker 容器 3
/ssh-add docker3 localhost root 2224
```

### 场景 3：团队协作服务器

```bash
# 共享开发服务器
/ssh-add team-dev team.example.com team 22

# 项目服务器
/ssh-add project-x project-x.example.com developer 22 ~/.ssh/project_x_key

# 客户户服务器
/ssh-add client-a client.example.com admin 22 ~/.ssh/client_a "Client A - billing server"
```

## 数据文件示例

`data/connections.jsonl` 内容示例：

```json
{"id": "1736419200000000000", "name": "localhost", "host": "127.0.0.1", "user": "root", "port": 2222, "identity_file": null, "description": null, "created_at": "2026-01-09T12:00:00Z", "updated_at": "2026-01-09T12:00:00Z"}
{"id": "1736419200000000001", "name": "production", "host": "prod.example.com", "user": "admin", "port": 22, "identity_file": "/home/user/.ssh/id_rsa", "description": "Production server", "created_at": "2026-01-09T12:05:00Z", "updated_at": "2026-01-09T12:05:00Z"}
{"id": "1736419200000000002", "name": "staging-db", "host": "db.example.com", "user": "dbuser", "port": 22, "identity_file": null, "description": null, "created_at": "2026-01-09T12:10:00Z", "updated_at": "2026-01-09T12:10:00Z"}
```

## 备份和管理

### 创建备份

```bash
# 备份连接数据
cp /workspace/xm/claude-plugins/plugins/ssh-manager/data/connections.jsonl \
   /workspace/xm/claude-plugins/plugins/ssh-manager/data/connections.jsonl.backup.$(date +%Y%m%d)
```

### 导出为可读格式

```bash
# 导出为格式化的 JSON 数组
# 需要先安装 jq
while IFS= read -r line; do
    echo "$line"
done < /workspace/xm/claude-plugins/plugins/ssh-manager/data/connections.jsonl | \
jq -s '.' > /tmp/ssh-connections-export.json
```

### 从备份恢复

```bash
# 恢复最近的备份
cp /workspace/xm/claude-plugins/plugins/ssh-manager/data/connections.jsonl.backup.* \
   /workspace/xm/claude-plugins/plugins/ssh-manager/data/connections.jsonl
```

## 故障排除

### 问题：命令无法执行

确保插件已正确加载：
```bash
cc --plugin-dir /workspace/xm/claude-plugins/plugins/ssh-manager
```

### 问题：jq 未安装

```bash
# Ubuntu/Debian
apt-get update && apt-get install -y jq

# Alpine
apk add jq

# macOS
brew install jq
```

### 问题：权限错误

确保数据文件可写：
```bash
chmod 644 /workspace/xm/claude-plugins/plugins/ssh-manager/data/connections.jsonl
```
