#!/bin/bash

# Claude Code Status Line
# Shows: Model | context bar % | ~/path | repo | ⎇ branch* | 5h/7d rate limits
#
# Requires: jq (brew install jq)

input=$(cat)

# Parse JSON
model_name="Claude"
pct_int=0
pct="0.0"

if command -v jq &>/dev/null && [ -n "$input" ]; then
  display_name=$(printf '%s' "$input" | jq -r '.model.display_name // empty' 2>/dev/null)
  [ -n "$display_name" ] && model_name="$display_name"

  used=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)
  if [ -n "$used" ] && [ "$used" != "null" ]; then
    pct_int=$(printf '%.0f' "$used")
    pct=$(printf '%.0f' "$used")
  fi

  five_hr=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
  seven_day=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)
fi

# Colors
cyan="\033[36m"
blue="\033[34m"
magenta="\033[35m"
dim="\033[2m"
reset="\033[0m"

# Context bar color (dynamic)
if [ "$pct_int" -ge 80 ]; then
  bar_color="\033[31m"
elif [ "$pct_int" -ge 50 ]; then
  bar_color="\033[33m"
else
  bar_color="\033[32m"
fi

# Progress bar helper (args: percentage_int, width)
make_bar() {
  local pct_val=$1 width=${2:-10}
  local filled_count=$((pct_val * width / 100))
  [ "$filled_count" -gt "$width" ] && filled_count=$width
  local empty_count=$((width - filled_count))
  printf '%s%s' "$(printf '%*s' "$filled_count" '' | tr ' ' '█')" "$(printf '%*s' "$empty_count" '' | tr ' ' '░')"
}

# Color by percentage
pct_color() {
  local val=$1
  if [ "$val" -ge 80 ]; then
    printf '\033[31m'
  elif [ "$val" -ge 50 ]; then
    printf '\033[33m'
  else
    printf '\033[32m'
  fi
}

# Context bar
bar_color=$(pct_color "$pct_int")
bar=$(make_bar "$pct_int" 10)

# Directory relative to home
dir_path=$(echo "$PWD" | sed "s|^$HOME|~|")

# Git branch + clickable repo link
git_info=""
repo_link=""
if git rev-parse --git-dir &>/dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
      git_info="${magenta}⎇ $branch${reset}*"
    else
      git_info="${magenta}⎇ $branch${reset}"
    fi
  fi

  # Clickable repo link (OSC 8)
  remote_url=$(git remote get-url origin 2>/dev/null)
  if [ -n "$remote_url" ]; then
    remote_url=$(echo "$remote_url" | sed 's|git@github.com:|https://github.com/|' | sed 's|\.git$||')
    repo_name=$(basename "$remote_url")
    repo_link="\033]8;;${remote_url}\a${repo_name}\033]8;;\a"
  fi
fi

# Rate limit bars
rate_info=""
if [ -n "$five_hr" ] && [ "$five_hr" != "null" ]; then
  five_hr_int=$(printf '%.0f' "$five_hr")
  five_hr_color=$(pct_color "$five_hr_int")
  five_hr_bar=$(make_bar "$five_hr_int" 10)
  rate_info="${dim}5h${reset} ${five_hr_color}${five_hr_bar}${reset} ${five_hr_int}%"
fi
if [ -n "$seven_day" ] && [ "$seven_day" != "null" ]; then
  seven_day_int=$(printf '%.0f' "$seven_day")
  seven_day_color=$(pct_color "$seven_day_int")
  seven_day_bar=$(make_bar "$seven_day_int" 10)
  [ -n "$rate_info" ] && rate_info="$rate_info ${dim}|${reset} "
  rate_info="${rate_info}${dim}7d${reset} ${seven_day_color}${seven_day_bar}${reset} ${seven_day_int}%"
fi

# Build output
output="${cyan}${model_name}${reset} ${dim}|${reset} ${blue}${dir_path}${reset}"
[ -n "$repo_link" ] && output="$output ${dim}|${reset} ${cyan}$repo_link${reset}"
[ -n "$git_info" ] && output="$output ${dim}|${reset} $git_info"
output="$output ${dim}||${reset} ${dim}ctx${reset} ${bar_color}${bar}${reset} ${pct}%"
[ -n "$rate_info" ] && output="$output ${dim}|${reset} $rate_info"

printf '%b\n' "$output"
