#!/bin/sh

# =============================================================================
# Dotfiles Setup Script (mirror-style)
# パッケージディレクトリ内の構造を $HOME 配下にミラーする symlink を作成する
# =============================================================================
#
# 構造例:
#   nvim/.config/nvim/           → $HOME/.config/nvim/
#   zsh/.zshenv                  → $HOME/.zshenv
#   claude/.claude/settings.json → $HOME/.claude/settings.json
#
# 使い方:
#   ./setup.sh                 - symlink を作成する
#   ./setup.sh --dry-run       - 実行せずに何をするか表示する
#   ./setup.sh --clean-backups - 既存の .backup.* を列挙して削除する
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# symlink 対象のリスト（リポジトリからの相対パス）
# 形式: <package>/<HOME相対パス>
# 例: nvim/.config/nvim → $DOTFILES_DIR/nvim/.config/nvim を $HOME/.config/nvim に symlink
#
# claude/ 配下は ~/.claude/ に Claude Code 自身がステートを書き込むため、
# .claude/ 全体ではなく管理対象ファイル/ディレクトリ単位で symlink する。
LINKS="
nvim/.config/nvim
wezterm/.config/wezterm
starship/.config/starship.toml
zsh/.zshenv
zsh/.config/zsh
git/.config/git
claude/.claude/settings.json
claude/.claude/CLAUDE.md
claude/.claude/skills
claude/.claude/statusline-command.sh
"

# 事前作成するディレクトリ（ツールが書き込むパス）
PRE_MKDIRS="
.local/state/zsh
"

# =============================================================================
# ユーティリティ
# =============================================================================

print_info()    { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
print_success() { printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"; }
print_warning() { printf "${YELLOW}[WARNING]${NC} %s\n" "$1"; }
print_error()   { printf "${RED}[ERROR]${NC} %s\n" "$1" >&2; }

# =============================================================================
# モード判定
# =============================================================================

DRY_RUN=0
CLEAN_BACKUPS=0
case "${1:-}" in
    --dry-run)       DRY_RUN=1 ;;
    --clean-backups) CLEAN_BACKUPS=1 ;;
    "") ;;
    *)
        print_error "Unknown option: $1"
        echo "Usage: $0 [--dry-run | --clean-backups]"
        exit 1
        ;;
esac

# =============================================================================
# .backup.* の清掃モード
# =============================================================================

clean_backups() {
    print_info ".backup.* ファイルを検索中..."
    found=$(find "$HOME" -maxdepth 4 -name "*.backup.*" 2>/dev/null || true)
    if [ -z "$found" ]; then
        print_success ".backup.* ファイルは見つかりませんでした"
        return 0
    fi
    echo "$found"
    echo ""
    printf "上記を削除しますか？ [y/N]: "
    read -r answer
    case "$answer" in
        y|Y|yes|YES)
            echo "$found" | while IFS= read -r f; do
                [ -z "$f" ] && continue
                rm -rf "$f"
                print_success "削除: $f"
            done
            ;;
        *) print_info "キャンセルしました" ;;
    esac
}

# =============================================================================
# symlink 作成
# =============================================================================

create_link() {
    src="$1"
    dest="$2"

    if [ ! -e "$src" ]; then
        print_error "ソースが存在しません: $src"
        return 1
    fi

    dest_parent=$(dirname "$dest")
    if [ ! -d "$dest_parent" ]; then
        if [ "$DRY_RUN" -eq 1 ]; then
            print_info "[DRY-RUN] mkdir -p $dest_parent"
        else
            mkdir -p "$dest_parent"
        fi
    fi

    if [ -L "$dest" ]; then
        # 既存 symlink: 削除して上書き
        if [ "$DRY_RUN" -eq 1 ]; then
            current=$(readlink "$dest")
            if [ "$current" = "$src" ]; then
                print_info "[DRY-RUN] 既に正しい symlink: $dest"
                return 0
            fi
            print_info "[DRY-RUN] symlink を更新: $dest (現: $current → 新: $src)"
            return 0
        fi
        rm "$dest"
    elif [ -e "$dest" ]; then
        # 実体ファイル/ディレクトリ: 安全のため停止
        print_error "実体ファイル/ディレクトリが存在します: $dest"
        print_error "  手動で確認・退避してから再実行してください"
        return 1
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        print_info "[DRY-RUN] ln -s $src $dest"
    else
        ln -s "$src" "$dest"
        print_success "$dest -> $src"
    fi
}

# =============================================================================
# メイン処理
# =============================================================================

main() {
    echo ""
    echo "========================================"
    echo "  Dotfiles Setup Script (mirror-style)"
    echo "========================================"
    echo ""
    if [ "$DRY_RUN" -eq 1 ]; then
        print_warning "[DRY-RUN モード] 実際の変更は行われません"
    fi
    print_info "Dotfiles ディレクトリ: $DOTFILES_DIR"
    echo ""

    # 事前作成ディレクトリ
    for d in $PRE_MKDIRS; do
        path="$HOME/$d"
        if [ ! -d "$path" ]; then
            if [ "$DRY_RUN" -eq 1 ]; then
                print_info "[DRY-RUN] mkdir -p $path"
            else
                mkdir -p "$path"
                print_info "ディレクトリ作成: $path"
            fi
        fi
    done

    print_info "シンボリックリンクを作成中..."
    echo ""
    error_count=0
    for link in $LINKS; do
        src="$DOTFILES_DIR/$link"
        rel="${link#*/}"  # 最初の '/' より後ろ
        dest="$HOME/$rel"
        if ! create_link "$src" "$dest"; then
            error_count=$((error_count + 1))
        fi
    done

    echo ""
    echo "========================================"
    if [ "$error_count" -gt 0 ]; then
        print_error "完了 (エラー: $error_count 件)"
        exit 1
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
        print_success "[DRY-RUN] チェック完了"
    else
        print_success "セットアップ完了!"
    fi
    echo "========================================"
    echo ""
    print_info ".backup.* を整理する場合: ./setup.sh --clean-backups"
}

if [ "$CLEAN_BACKUPS" -eq 1 ]; then
    clean_backups
else
    main
fi
