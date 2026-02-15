#!/bin/bash

# Claude Code Context Window Progress Bar
# https://gist.github.com/davidamo9/764415aff29959de21f044dbbfd00cd9
#
# Installation:
# 1. Save this file to ~/.claude/hooks/statusline.sh
# 2. Make it executable: chmod +x ~/.claude/hooks/statusline.sh
# 3. Add to ~/.claude/settings.json:
# {
#   "statusLine": {
#     "type": "command",
#     "command": "~/.claude/hooks/statusline.sh"
#   }
# }
# 4. Restart Claude Code
#
# Requires: jq (brew install jq / apt install jq)

# Read JSON input from stdin
input=$(cat)

# Parse data from JSON input
if command -v jq &>/dev/null && [ -n "$input" ]; then
  model=$(echo "$input" | jq -r '.model.api_model_id // empty' 2>/dev/null)
  cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty' 2>/dev/null)
  context_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty' 2>/dev/null)

  # Get all token types for accurate count
  input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0' 2>/dev/null)
  output_tokens=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0' 2>/dev/null)
  cache_create=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0' 2>/dev/null)
  cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0' 2>/dev/null)
fi

# Model short name
model_short=""
case "$model" in
  *opus*) model_short="op" ;;
  *sonnet*) model_short="so" ;;
  *haiku*) model_short="ha" ;;
  *) model_short="cl" ;;
esac

# Build usage display
usage_info=""

# Cost display
if [ -n "$cost" ] && [ "$cost" != "null" ]; then
  cost_display=$(printf '$%.2f' "$cost" 2>/dev/null || echo "\$$cost")
  usage_info="$cost_display"
fi

# Context window usage
if [ -n "$context_size" ] && [ "$context_size" != "0" ] && [ "$context_size" != "null" ]; then
  # Total tokens used (including cache)
  total_tokens=$((input_tokens + output_tokens + cache_create + cache_read))

  # Calculate percentage with 1 decimal place using awk
  pct=$(awk "BEGIN {printf \"%.1f\", ($total_tokens / $context_size) * 100}")
  pct_int=${pct%.*} # Integer part for color/bar

  # Format token count (K for thousands)
  if [ "$total_tokens" -ge 1000 ]; then
    tokens_display="$((total_tokens / 1000))K"
  else
    tokens_display="$total_tokens"
  fi

  # Context size in K
  ctx_size_k="$((context_size / 1000))K"

  # Color coding based on usage (ANSI colors)
  if [ "$pct_int" -ge 80 ]; then
    color="\033[31m" # Red - danger zone
  elif [ "$pct_int" -ge 50 ]; then
    color="\033[33m" # Yellow - getting full
  else
    color="\033[32m" # Green - plenty of room
  fi

  reset="\033[0m"

  # Progress bar (10 chars wide)
  filled=$((pct_int / 10))
  [ "$filled" -gt 10 ] && filled=10
  empty=$((10 - filled))

  bar=$(printf '%*s' "$filled" '' | tr ' ' '█')$(printf '%*s' "$empty" '' | tr ' ' '░')

  if [ -n "$usage_info" ]; then
    usage_info="$usage_info | ${color}${bar}${reset} ${pct}% (${tokens_display}/${ctx_size_k})"
  else
    usage_info="${color}${bar}${reset} ${pct}% (${tokens_display}/${ctx_size_k})"
  fi
fi

# Git branch info (optional)
git_info=""
if git rev-parse --git-dir &>/dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
      git_info="$branch*"
    else
      git_info="$branch"
    fi
  fi
fi

# Build output: [model] cost | context_bar | git
output=""
[ -n "$usage_info" ] && output="$usage_info"
[ -n "$git_info" ] && output="${output:+$output | }$git_info"

# Prefix with model indicator
if [ -n "$output" ]; then
  output="[$model_short] $output"
else
  output="[$model_short]"
fi

echo -e "$output"
