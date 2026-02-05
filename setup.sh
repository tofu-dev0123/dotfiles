#!/bin/sh

# =============================================================================
# Dotfiles Setup Script
# シンボリックリンクを作成してdotfilesをセットアップします
# =============================================================================

set -e

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# dotfilesディレクトリのパスを取得（スクリプト自身の場所から）
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# タイムスタンプ（バックアップ用）
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# =============================================================================
# ユーティリティ関数
# =============================================================================

print_info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

print_success() {
    printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"
}

print_warning() {
    printf "${YELLOW}[WARNING]${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1"
}

# シンボリックリンクを作成する関数
# 引数: $1 = ソースパス, $2 = リンク先パス
create_symlink() {
    src="$1"
    dest="$2"

    # ソースが存在するか確認
    if [ ! -e "$src" ]; then
        print_error "ソースが存在しません: $src"
        return 1
    fi

    # リンク先の親ディレクトリを作成
    dest_dir=$(dirname "$dest")
    if [ ! -d "$dest_dir" ]; then
        print_info "ディレクトリを作成: $dest_dir"
        mkdir -p "$dest_dir"
    fi

    # 既存のファイル/ディレクトリをバックアップ
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        backup="${dest}.backup.${TIMESTAMP}"
        print_warning "既存ファイルをバックアップ: $dest -> $backup"
        mv "$dest" "$backup"
    fi

    # シンボリックリンクを作成
    ln -s "$src" "$dest"
    print_success "リンク作成: $dest -> $src"
}

# =============================================================================
# メイン処理
# =============================================================================

main() {
    echo ""
    echo "========================================"
    echo "  Dotfiles Setup Script"
    echo "========================================"
    echo ""
    print_info "Dotfiles ディレクトリ: $DOTFILES_DIR"
    echo ""

    # ~/.config ディレクトリを作成（なければ）
    if [ ! -d "$HOME/.config" ]; then
        print_info "~/.config ディレクトリを作成"
        mkdir -p "$HOME/.config"
    fi

    # シンボリックリンクを作成
    print_info "シンボリックリンクを作成中..."
    echo ""

    # Neovim
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    # WezTerm
    create_symlink "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"

    # Zsh
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

    echo ""
    echo "========================================"
    print_success "セットアップ完了!"
    echo "========================================"
    echo ""
}

# スクリプトを実行
main
