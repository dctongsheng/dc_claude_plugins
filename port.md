# Claude Code Plugins - 端口配置

本项目是 Claude Code 插件代码仓库，不需要分配运行时端口。

## 项目信息

- **项目名**: claude-plugins
- **路径**: `/workspace/xm/claude-plugins`
- **类型**: 代码仓库 / 插件集合
- **端口**: 无（代码仓库项目）
- **创建日期**: 2026-01-09

## 说明

这是一个纯代码仓库项目，用于存储和管理 Claude Code 插件代码。插件通过 `--plugin-dir` 参数加载到 Claude Code 中，不需要独立的运行时服务或端口。

## 使用方法

```bash
# 加载整个插件集合
cc --plugin-dir /workspace/xm/claude-plugins

# 加载单个插件
cc --plugin-dir /workspace/xm/claude-plugins/plugins/example-plugin
```
