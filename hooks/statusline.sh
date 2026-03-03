#!/bin/bash

# Claude Code Status Line
# Shows: Model | context bar % | ~/path | ⎇ branch*
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
    pct=$(printf '%.1f' "$used")
  fi
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

# Progress bar (10 chars)
filled=$((pct_int / 10))
[ "$filled" -gt 10 ] && filled=10
empty=$((10 - filled))
bar=$(printf '%*s' "$filled" '' | tr ' ' '█')$(printf '%*s' "$empty" '' | tr ' ' '░')

# Directory relative to home
dir_path=$(echo "$PWD" | sed "s|^$HOME|~|")

# Git branch
git_info=""
if git rev-parse --git-dir &>/dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
      git_info="${magenta}⎇ $branch${reset}*"
    else
      git_info="${magenta}⎇ $branch${reset}"
    fi
  fi
fi

# Build output
output="${cyan}${model_name}${reset} ${dim}|${reset} ${bar_color}${bar}${reset} ${pct}% ${dim}|${reset} ${blue}${dir_path}${reset}"
[ -n "$git_info" ] && output="$output ${dim}|${reset} $git_info"

printf '%b\n' "$output"
