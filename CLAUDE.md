# Claude Code 项目配置

## 项目说明

本项目使用 Claude Code 作为主要的 AI 辅助开发工具。

## 配置文件说明

### `.claude/settings.json`
项目级系统配置文件，包含：
- 模型选择配置
- Hooks 配置
- 启用的插件列表
- 语言偏好设置

### `.mcp.json`
MCP (Model Context Protocol) 服务器配置文件，用于配置外部工具和服务集成。

### `.claude/skills/`
团队共享的 Skills 目录，包含自定义的 AI 技能和工作流。

## 编码规范

### Cursor IDE
详见 `.cursorrules` 文件

### Qoder/Trae IDE
详见 `.iderules` 文件

## 使用说明

1. 确保已安装 Claude Code CLI
2. 配置文件会自动被 Claude Code 读取
3. Skills 可通过 `/skill-name` 命令调用

## 插件

当前启用的插件：
- document-skills@anthropic-agent-skills
- superpowers@superpowers-marketplace
- docx-format-replicator@happy-claude-skills
- business-startup-skills@claude-skills-collection
- marketing-growth-skills@claude-skills-collection
