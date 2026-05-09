#!/usr/bin/env bash
# 開発ツールのキャッシュ（npm / gradle / docker / cargo）を一括クリーンアップする。
# インストール済みのツールのみ処理する。
# Usage: cleanup-caches.sh [--dry-run]

set -euo pipefail

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=1 ;;
    --help|-h)
      cat <<EOF
Usage: $(basename "$0") [--dry-run]

開発ツールのキャッシュ（npm / gradle / docker / cargo）をクリーンアップする。
インストール済みのツールのみ処理する。

Options:
  --dry-run, -n  実際の削除を行わず、対象と現在のサイズのみ表示
  --help, -h     このヘルプを表示
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

# 色付け（TTY のときのみ）
if [ -t 1 ]; then
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_BLUE=$'\033[34m'
  C_BOLD=$'\033[1m'
  C_RESET=$'\033[0m'
else
  C_GREEN=''
  C_YELLOW=''
  C_BLUE=''
  C_BOLD=''
  C_RESET=''
fi

section() {
  printf '\n%s==> %s%s\n' "${C_BOLD}${C_BLUE}" "$1" "${C_RESET}"
}
warn() {
  printf '%s%s%s\n' "${C_YELLOW}" "$1" "${C_RESET}" >&2
}
ok() {
  printf '%s✓ %s%s\n' "${C_GREEN}" "$1" "${C_RESET}"
}

# ディレクトリサイズ（du -sh の値、存在しなければ "0"）
dir_size() {
  if [ -d "$1" ]; then
    du -sh "$1" 2>/dev/null | awk '{print $1}'
  else
    echo "0"
  fi
}

cleanup_npm() {
  if ! command -v npm >/dev/null 2>&1; then
    warn "npm が見つかりません。スキップします。"
    return
  fi
  local cache_dir before after
  cache_dir=$(npm config get cache 2>/dev/null || echo "$HOME/.npm")
  before=$(dir_size "$cache_dir")
  echo "対象: $cache_dir (現在 $before)"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  [dry-run] npm cache verify は実行しません"
    return
  fi
  npm cache verify
  after=$(dir_size "$cache_dir")
  ok "npm: $before → $after"
}

cleanup_gradle() {
  if ! command -v gradle >/dev/null 2>&1 && [ ! -d "$HOME/.gradle" ]; then
    warn "gradle が見つかりません。スキップします。"
    return
  fi
  local cache_dir="$HOME/.gradle"
  local before after
  before=$(dir_size "$cache_dir")
  echo "対象: $cache_dir (現在 $before)"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  [dry-run] gradle --stop は実行しません"
    return
  fi
  if command -v gradle >/dev/null 2>&1; then
    gradle --stop || true
  fi
  echo "  ※ gradle 4.10+ の自動 TTL で古いキャッシュは順次削除されます"
  after=$(dir_size "$cache_dir")
  ok "gradle: $before → $after"
}

cleanup_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    warn "docker が見つかりません。スキップします。"
    return
  fi
  if ! docker info >/dev/null 2>&1; then
    warn "docker デーモンが起動していません。スキップします。"
    return
  fi
  echo "対象: docker system"
  docker system df || true
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  [dry-run] docker system prune は実行しません"
    return
  fi
  docker system prune -f
  ok "docker: prune 完了"
}

cleanup_cargo() {
  if [ ! -d "$HOME/.cargo" ]; then
    warn "cargo が見つかりません。スキップします。"
    return
  fi
  local cache_dir="$HOME/.cargo"
  local before after
  before=$(dir_size "$cache_dir")
  echo "対象: $cache_dir (現在 $before)"
  if ! command -v cargo-cache >/dev/null 2>&1; then
    warn "  cargo-cache 未導入。\`cargo install cargo-cache\` で利用可能"
    return
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  [dry-run] cargo cache --autoclean は実行しません"
    return
  fi
  cargo cache --autoclean
  after=$(dir_size "$cache_dir")
  ok "cargo: $before → $after"
}

# ── 実行 ──────────────────────────────────────────
if [ "$DRY_RUN" -eq 1 ]; then
  printf '%sキャッシュクリーンアップ (dry-run モード)%s\n' "${C_BOLD}" "${C_RESET}"
else
  printf '%sキャッシュクリーンアップ%s\n' "${C_BOLD}" "${C_RESET}"
fi
echo "開始: $(date '+%Y-%m-%d %H:%M:%S')"

section "npm"
cleanup_npm
section "gradle"
cleanup_gradle
section "docker"
cleanup_docker
section "cargo"
cleanup_cargo

echo ""
printf '%s完了%s: %s\n' "${C_BOLD}" "${C_RESET}" "$(date '+%Y-%m-%d %H:%M:%S')"
