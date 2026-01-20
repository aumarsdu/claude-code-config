# Claude Code 配置管理仓库

> 个人开发环境配置文件的集中管理仓库

[![GitHub](https://img.shields.io/badge/GitHub-aumarsdu-blue)](https://github.com/aumarsdu/claude-code-config)

## 📁 仓库结构

```
.
├── .claude/
│   └── settings.json          # Claude Code 项目配置
├── .cursorrules               # Cursor IDE 编码规范
├── .iderules                  # Qoder/Trae IDE 编码规范
├── .mcp.json                  # MCP 服务器配置
├── .gitignore                 # Git 忽略文件
├── CLAUDE.md                  # Claude Code 项目说明
└── README.md                  # 本文件
```

## 🚀 快速开始

### 在新设备上使用这些配置

```bash
# 1. 克隆仓库到主目录
cd ~
git clone git@github.com:aumarsdu/claude-code-config.git temp-config

# 2. 复制配置文件（不覆盖现有文件）
cp -rn temp-config/. .

# 3. 清理临时目录
rm -rf temp-config

# 4. 验证配置
ls -la .claude/ .cursorrules .iderules .mcp.json
```

## 📝 日常管理工作流

### 1️⃣ 查看变更

```bash
cd ~
git status
```

### 2️⃣ 添加新配置文件

```bash
# 添加单个文件
git add .claude/settings.json

# 或添加所有变更
git add .cursorrules .iderules .mcp.json CLAUDE.md
```

### 3️⃣ 提交变更

```bash
# 使用 Conventional Commits 格式
git commit -m "🔧 chore: update Claude settings"

# 或使用 /commit 命令（如果安装了 Claude Code）
# 这会自动生成符合规范的提交信息
```

### 4️⃣ 推送到 GitHub

```bash
git push
```

### 5️⃣ 从其他设备同步

```bash
cd ~
git pull
```

## 🔒 安全最佳实践

### ⚠️ 敏感信息检查清单

在提交前，检查以下文件是否包含敏感信息：

- [ ] API 密钥
- [ ] 访问令牌
- [ ] 密码
- [ ] 私有服务器地址
- [ ] 个人身份信息

### 🛡️ 处理敏感配置

如果配置文件包含敏感信息：

```bash
# 方案 1: 添加到 .gitignore
echo ".claude.json" >> .gitignore

# 方案 2: 创建模板文件
cp .claude.json .claude.json.template
# 编辑 .claude.json.template，移除敏感信息
# 提交模板文件，忽略实际配置
```

## 🔄 常用命令速查

### Git 基础操作

```bash
# 查看状态
git status

# 查看变更
git diff

# 查看提交历史
git log --oneline -10

# 撤销未提交的变更
git checkout -- <file>

# 撤销已暂存的文件
git restore --staged <file>
```

### 分支管理

```bash
# 创建新分支（用于测试新配置）
git checkout -b test-config

# 切换回主分支
git checkout main

# 合并分支
git merge test-config

# 删除分支
git branch -d test-config
```

## 📋 配置文件说明

### `.claude/settings.json`
Claude Code 的核心配置，包含：
- 模型选择（sonnet/opus/haiku）
- Hooks 配置
- 插件启用状态
- 语言偏好

### `.mcp.json`
Model Context Protocol 服务器配置，用于：
- 集成外部工具
- 配置 API 连接
- 自定义服务

### `.cursorrules`
Cursor IDE 编码规范，定义：
- 代码风格
- 命名规范
- 最佳实践

### `.iderules`
Qoder/Trae IDE 编码规范，包含：
- TypeScript 规范
- React 开发指南
- 测试规范

## 🎯 进阶管理

### 1. 使用别名简化命令

添加到 `~/.zshrc` 或 `~/.bashrc`：

```bash
# 配置管理别名
alias config-status='cd ~ && git status'
alias config-diff='cd ~ && git diff'
alias config-push='cd ~ && git add -A && git commit && git push'
alias config-pull='cd ~ && git pull'
```

### 2. 自动备份钩子

创建 Git post-commit hook：

```bash
# .git/hooks/post-commit
#!/bin/bash
echo "✅ 配置已提交到本地仓库"
echo "💡 别忘了运行 'git push' 推送到 GitHub"
```

### 3. 定期检查

设置提醒，每周检查：
- 是否有未提交的配置变更
- 是否需要同步其他设备
- 是否有过时的配置需要清理

## 🔧 故障排除

### 问题：推送失败

```bash
# 检查远程仓库
git remote -v

# 重新设置远程仓库
git remote set-url origin git@github.com:aumarsdu/claude-code-config.git

# 强制推送（谨慎使用）
git push -f origin main
```

### 问题：合并冲突

```bash
# 查看冲突文件
git status

# 手动编辑冲突文件，然后
git add <conflicted-file>
git commit -m "🔀 merge: resolve conflicts"
```

### 问题：误提交敏感信息

```bash
# 从历史中删除敏感文件
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch <sensitive-file>' \
  --prune-empty --tag-name-filter cat -- --all

# 强制推送
git push origin --force --all
```

## 📚 相关资源

- [Git 官方文档](https://git-scm.com/doc)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Claude Code 文档](https://docs.anthropic.com/claude/docs)
- [GitHub SSH 设置](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

## 🤝 贡献

这是个人配置仓库，但欢迎参考和借鉴。

## 📄 许可

MIT License

---

**最后更新**：2026-01-20
**维护者**：[@aumarsdu](https://github.com/aumarsdu)
