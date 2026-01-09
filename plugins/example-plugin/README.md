# Example Plugin

示例插件，展示 Claude Code 插件的基本功能。

## 功能

### Skills

- `/greet` - 问候用户

### Commands

- `/hello` - 输出 Hello World

### Hooks

- `SessionStart` - 会话开始时的欢迎消息

## 安装

```bash
cc --plugin-dir /workspace/xm/claude-plugins/plugins/example-plugin
```

## 使用

### 使用 Skill

直接在对话中输入：
```
请用 greet 功能
```

### 使用 Command

```bash
/hello
```

## 开发

这是学习和开发插件的参考示例。
