#!/bin/sh
# Claude Code statusLine command
# Catppuccin Frappe palette (matches starship.toml)

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_h_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_h_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Abbreviate home directory
home="$HOME"
display_dir="${cwd#"$home"}"
if [ "$display_dir" != "$cwd" ]; then
  display_dir="~$display_dir"
fi

# Git branch (skip optional locks to avoid hangs)
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# Catppuccin Frappe colors
green="\033[38;2;166;209;137m"
sky="\033[38;2;153;209;219m"
sapphire="\033[38;2;133;193;220m"
overlay0="\033[38;2;115;121;148m"
overlay1="\033[38;2;148;156;187m"
surface1="\033[38;2;81;87;109m"
red="\033[38;2;231;130;132m"
peach="\033[38;2;239;159;118m"
reset="\033[0m"

# Separator
SEP=" ${surface1}│${reset} "

# Helper: format remaining seconds as "Xh Ym" or "Ym"
format_remaining() {
  secs=$1
  now=$(date +%s)
  remaining=$((secs - now))
  if [ "$remaining" -le 0 ]; then
    echo "now"
  else
    h=$((remaining / 3600))
    m=$(((remaining % 3600) / 60))
    if [ "$h" -gt 0 ]; then
      echo "${h}h${m}m"
    else
      echo "${m}m"
    fi
  fi
}

# Helper: pick color by percentage
pct_color() {
  pct=$1
  if [ "$pct" -ge 80 ]; then printf "%s" "$red"
  elif [ "$pct" -ge 50 ]; then printf "%s" "$peach"
  else printf "%s" "$overlay0"
  fi
}

# Helper: build a colored progress bar  e.g. "████░░░░"
make_bar() {
  pct=$1
  color=$2
  width=8
  filled=$(( pct * width / 100 ))
  empty=$(( width - filled ))
  bar="${color}"
  i=0; while [ $i -lt $filled ]; do bar="${bar}█"; i=$((i+1)); done
  bar="${bar}${surface1}"
  i=0; while [ $i -lt $empty ];  do bar="${bar}░"; i=$((i+1)); done
  bar="${bar}${reset}"
  printf "%s" "$bar"
}

# ── Segment: dir ──────────────────────────────────────────────
seg_dir="${green}${display_dir}${reset}"

# ── Segment: branch ───────────────────────────────────────────
seg_branch=""
if [ -n "$git_branch" ]; then
  seg_branch="${sky} ${git_branch}${reset}"
fi

# ── Segment: model ────────────────────────────────────────────
seg_model=""
if [ -n "$model" ]; then
  seg_model="${overlay1}model:${reset}${sapphire}${model}${reset}"
fi

# ── Segment: 5h rate limit ────────────────────────────────────
seg_5h=""
if [ -n "$five_h_pct" ]; then
  five_h_int=$(printf "%.0f" "$five_h_pct")
  color=$(pct_color "$five_h_int")
  bar=$(make_bar "$five_h_int" "$color")
  seg_5h="${overlay1}5h:${reset}${bar}${color}${five_h_int}%${reset}"
  if [ -n "$five_h_reset" ]; then
    seg_5h="${seg_5h}${overlay0}($(format_remaining "$five_h_reset"))${reset}"
  fi
fi

# ── Segment: weekly rate limit ────────────────────────────────
seg_7d=""
if [ -n "$week_pct" ]; then
  week_int=$(printf "%.0f" "$week_pct")
  color=$(pct_color "$week_int")
  bar=$(make_bar "$week_int" "$color")
  seg_7d="${overlay1}7d:${reset}${bar}${color}${week_int}%${reset}"
  if [ -n "$week_reset" ]; then
    seg_7d="${seg_7d}${overlay0}($(format_remaining "$week_reset"))${reset}"
  fi
fi

# ── Segment: context window ───────────────────────────────────
seg_ctx=""
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  color=$(pct_color "$used_int")
  bar=$(make_bar "$used_int" "$color")
  seg_ctx="${overlay1}ctx:${reset}${bar}${color}${used_int}%${reset}"
fi

# ── Compose groups ────────────────────────────────────────────
# Group 1: location  (dir + branch)
group1="${seg_dir}"
[ -n "$seg_branch" ] && group1="${group1} ${seg_branch}"

# Group 2: model + usage stats
group2=""
for seg in "$seg_model" "$seg_5h" "$seg_7d" "$seg_ctx"; do
  [ -z "$seg" ] && continue
  if [ -z "$group2" ]; then
    group2="${seg}"
  else
    group2="${group2}${SEP}${seg}"
  fi
done

# ── Wrapping ──────────────────────────────────────────────────
# Compute visible (ANSI-stripped) length
visible_len() {
  printf "%b" "$1" | sed 's/\x1b\[[0-9;]*m//g' | wc -m | tr -d ' '
}

term_width=$(tput cols 2>/dev/null || echo 120)
sep_len=3  # " │ "

if [ -n "$group2" ]; then
  len1=$(visible_len "$group1")
  len2=$(visible_len "$group2")
  total=$((len1 + sep_len + len2))
  if [ "$total" -le "$term_width" ]; then
    printf "%b" "${group1}${SEP}${group2}"
  else
    printf "%b" "${group1}\n${group2}"
  fi
else
  printf "%b" "$group1"
fi
