#!/bin/bash

# ========================================
# Claude Code 配置管理脚本
# ========================================
# 作用: 简化配置文件的 Git 管理操作
# 使用: ./config-manager.sh [command]
# ========================================

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置文件列表
CONFIG_FILES=(
    ".claude/settings.json"
    ".mcp.json"
    "CLAUDE.md"
    ".cursorrules"
    ".iderules"
    ".gitignore"
    "README.md"
)

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 显示帮助信息
show_help() {
    cat << EOF
${GREEN}Claude Code 配置管理脚本${NC}

${YELLOW}用法:${NC}
    ./config-manager.sh [命令]

${YELLOW}可用命令:${NC}
    ${BLUE}status${NC}      - 查看配置文件的 Git 状态
    ${BLUE}diff${NC}        - 查看配置文件的变更
    ${BLUE}sync${NC}        - 从 GitHub 同步最新配置
    ${BLUE}backup${NC}      - 提交并推送配置到 GitHub
    ${BLUE}list${NC}        - 列出所有跟踪的配置文件
    ${BLUE}check${NC}       - 检查配置文件是否存在
    ${BLUE}install${NC}     - 在新设备上安装配置文件
    ${BLUE}clean${NC}       - 清理未跟踪的文件（谨慎使用）
    ${BLUE}help${NC}        - 显示此帮助信息

${YELLOW}示例:${NC}
    ./config-manager.sh status
    ./config-manager.sh backup
    ./config-manager.sh sync

${YELLOW}注意:${NC}
    - 此脚本应该在主目录 (~) 下运行
    - 使用前确保已配置 Git 和 GitHub

EOF
}

# 检查是否在主目录
check_home_dir() {
    if [ "$PWD" != "$HOME" ]; then
        print_warning "当前不在主目录，正在切换..."
        cd ~
        print_success "已切换到主目录: $HOME"
    fi
}

# 检查 Git 仓库
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "当前目录不是 Git 仓库"
        print_info "请先运行: git init"
        exit 1
    fi
}

# 查看状态
show_status() {
    print_info "配置文件 Git 状态:"
    echo ""
    git status --short "${CONFIG_FILES[@]}" 2>/dev/null || git status --short
    echo ""

    # 显示最近的提交
    print_info "最近的提交:"
    git log --oneline -5
}

# 查看差异
show_diff() {
    print_info "配置文件变更详情:"
    echo ""
    git diff "${CONFIG_FILES[@]}"
}

# 同步配置
sync_config() {
    print_info "正在从 GitHub 同步配置..."

    # 检查是否有未提交的变更
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        print_warning "检测到未提交的变更"
        read -p "是否先提交本地变更? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            backup_config
        fi
    fi

    git pull origin main
    print_success "配置同步完成"
}

# 备份配置
backup_config() {
    print_info "正在备份配置到 GitHub..."

    # 显示变更
    echo ""
    git status --short
    echo ""

    # 确认
    read -p "确认提交以上变更? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "操作已取消"
        exit 0
    fi

    # 添加文件
    for file in "${CONFIG_FILES[@]}"; do
        if [ -f "$HOME/$file" ]; then
            git add "$file"
        fi
    done

    # 提交
    read -p "输入提交信息 (留空使用默认): " commit_msg
    if [ -z "$commit_msg" ]; then
        commit_msg="🔧 chore: update configuration files"
    fi

    git commit -m "$commit_msg" || print_warning "没有变更需要提交"

    # 推送
    git push origin main
    print_success "配置已备份到 GitHub"
}

# 列出配置文件
list_files() {
    print_info "跟踪的配置文件:"
    echo ""
    for file in "${CONFIG_FILES[@]}"; do
        if [ -f "$HOME/$file" ]; then
            echo -e "${GREEN}✓${NC} $file"
        else
            echo -e "${RED}✗${NC} $file (不存在)"
        fi
    done
}

# 检查配置文件
check_files() {
    print_info "检查配置文件完整性..."
    echo ""

    missing_files=0
    for file in "${CONFIG_FILES[@]}"; do
        if [ ! -f "$HOME/$file" ]; then
            print_error "$file 不存在"
            ((missing_files++))
        fi
    done

    if [ $missing_files -eq 0 ]; then
        print_success "所有配置文件都存在"
    else
        print_warning "缺少 $missing_files 个配置文件"
    fi
}

# 在新设备上安装
install_config() {
    print_info "在新设备上安装配置文件..."

    # 克隆仓库
    temp_dir="/tmp/claude-config-temp-$$"
    git clone git@github.com:aumarsdu/claude-code-config.git "$temp_dir"

    # 复制文件（不覆盖现有文件）
    for file in "${CONFIG_FILES[@]}"; do
        src="$temp_dir/$file"
        dst="$HOME/$file"

        if [ -f "$src" ]; then
            if [ ! -f "$dst" ]; then
                mkdir -p "$(dirname "$dst")"
                cp "$src" "$dst"
                print_success "已安装: $file"
            else
                print_warning "已存在，跳过: $file"
            fi
        fi
    done

    # 清理
    rm -rf "$temp_dir"
    print_success "配置安装完成"
}

# 清理未跟踪的文件
clean_untracked() {
    print_warning "此操作将删除所有未跟踪的文件"
    read -p "确认继续? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git clean -fd
        print_success "清理完成"
    else
        print_info "操作已取消"
    fi
}

# 主函数
main() {
    check_home_dir

    case "${1:-help}" in
        status)
            check_git_repo
            show_status
            ;;
        diff)
            check_git_repo
            show_diff
            ;;
        sync)
            check_git_repo
            sync_config
            ;;
        backup)
            check_git_repo
            backup_config
            ;;
        list)
            list_files
            ;;
        check)
            check_files
            ;;
        install)
            install_config
            ;;
        clean)
            check_git_repo
            clean_untracked
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "未知命令: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# 运行主函数
main "$@"
