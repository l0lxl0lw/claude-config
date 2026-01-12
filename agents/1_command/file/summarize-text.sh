#!/bin/bash
#
# ============================================================================
# summarize-text.sh
# ============================================================================
#
# DESCRIPTION:
#   Summarize a text file into a structured table-of-contents format.
#   Uses Claude CLI to generate an intelligent summary with key topics,
#   details, and takeaways.
#
# USAGE:
#   ./summarize-text.sh --input_path <PATH> [--output_path <PATH>]
#
# ARGUMENTS:
#   --input_path <PATH>    (required) Path to the text file to summarize
#
#   --output_path <PATH>   (optional) Path to save the summary
#                          - If provided: saves to file
#                          - If omitted: prints to stdout
#
#   -h, --help             Show help message
#
# OUTPUT FORMAT:
#   # Summary
#
#   ## Overview
#   Brief 2-3 sentence overview of the content.
#
#   ## Key Topics
#   1. **Topic 1**: Description
#   2. **Topic 2**: Description
#   ...
#
#   ## Main Takeaways
#   - Takeaway 1
#   - Takeaway 2
#   ...
#
# EXAMPLES:
#   # Print summary to console
#   ./summarize-text.sh --input_path ~/transcript.txt
#
#   # Save summary to file
#   ./summarize-text.sh --input_path ~/transcript.txt --output_path ~/summary.txt
#
# DEPENDENCIES:
#   - claude CLI (Anthropic's Claude Code)
#
# ============================================================================

set -e

# Default values
INPUT_PATH=""
OUTPUT_PATH=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --input_path)
            INPUT_PATH="$2"
            shift 2
            ;;
        --output_path)
            OUTPUT_PATH="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 --input_path <PATH> [--output_path <PATH>]"
            echo ""
            echo "Options:"
            echo "  --input_path   Path to text file to summarize (required)"
            echo "  --output_path  Path to save summary (optional, prints to stdout if omitted)"
            echo ""
            echo "Examples:"
            echo "  $0 --input_path ~/transcript.txt"
            echo "  $0 --input_path ~/transcript.txt --output_path ~/summary.txt"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate required arguments
if [[ -z "$INPUT_PATH" ]]; then
    echo "Error: --input_path is required"
    echo "Usage: $0 --input_path <PATH> [--output_path <PATH>]"
    exit 1
fi

# Expand tilde
INPUT_PATH="${INPUT_PATH/#\~/$HOME}"

# Check input file exists
if [[ ! -f "$INPUT_PATH" ]]; then
    echo "Error: Input file not found: $INPUT_PATH"
    exit 1
fi

# Read content
CONTENT=$(cat "$INPUT_PATH")

# Generate summary using Claude CLI
SUMMARY=$(claude --print -p "Summarize this text into a structured markdown format:

## Overview
(2-3 sentence summary)

## Key Topics
(numbered list with brief descriptions)

## Main Takeaways
(bullet points of key insights)

Keep it concise. Here's the text:

$CONTENT")

if [[ -n "$OUTPUT_PATH" ]]; then
    # Expand tilde for output
    OUTPUT_PATH="${OUTPUT_PATH/#\~/$HOME}"

    # Create parent directory if needed
    mkdir -p "$(dirname "$OUTPUT_PATH")"

    # Save to file
    echo "$SUMMARY" > "$OUTPUT_PATH"

    echo "Summary saved to: $OUTPUT_PATH"
    echo "File size: $(stat -f%z "$OUTPUT_PATH" 2>/dev/null || stat -c%s "$OUTPUT_PATH" 2>/dev/null) bytes"
else
    # Print to stdout
    echo "$SUMMARY"
fi
