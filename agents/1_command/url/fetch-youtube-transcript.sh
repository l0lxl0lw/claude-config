#!/bin/bash
#
# ============================================================================
# fetch-youtube-transcript.sh
# ============================================================================
#
# DESCRIPTION:
#   Fetch transcript/captions from a YouTube video using youtube-transcript-api.
#   Returns timestamped transcript in [MM:SS.ss] format.
#
# USAGE:
#   ./fetch-youtube-transcript.sh --video_url <URL> [--output_path <PATH>] [--language <CODE>]
#
# ARGUMENTS:
#   --video_url <URL>      (required) YouTube video URL - MUST be quoted
#                          Supports: youtube.com/watch?v=, youtu.be/, shorts/
#
#   --output_path <PATH>   (optional) File path to save transcript
#                          - If provided: saves to file AND prints summary
#                          - If omitted: prints to stdout
#
#   --language <CODE>      (optional) Language code for transcript (default: en)
#                          Examples: en, es, fr, de, ja, ko, zh
#
#   -h, --help             Show help message
#
# OUTPUT FORMAT:
#   [00:00.00] First line of transcript
#   [00:05.23] Second line of transcript
#   [00:10.45] Third line of transcript
#   ...
#
# EXAMPLES:
#   # Print transcript to console
#   ./fetch-youtube-transcript.sh --video_url 'https://www.youtube.com/watch?v=abc123'
#
#   # Save transcript to file
#   ./fetch-youtube-transcript.sh --video_url 'https://www.youtube.com/watch?v=abc123' --output_path ~/transcript.txt
#
#   # Fetch Spanish transcript
#   ./fetch-youtube-transcript.sh --video_url 'https://youtu.be/abc123' --language es
#
#   # Save to directory (uses video ID as filename)
#   ./fetch-youtube-transcript.sh --video_url 'https://youtu.be/abc123' --output_path ~/transcripts/
#
# DEPENDENCIES:
#   - python3
#   - youtube-transcript-api (pip install youtube-transcript-api)
#
# ============================================================================

set -e

# Default values
VIDEO_URL=""
OUTPUT_PATH=""
LANGUAGE="en"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --video_url)
            VIDEO_URL="$2"
            shift 2
            ;;
        --output_path)
            OUTPUT_PATH="$2"
            shift 2
            ;;
        --language)
            LANGUAGE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 --video_url <URL> [--output_path <PATH>] [--language <CODE>]"
            echo ""
            echo "Options:"
            echo "  --video_url    YouTube video URL (required) - MUST be quoted"
            echo "  --output_path  File path to save transcript (optional)"
            echo "  --language     Language code: en, es, fr, de, ja, ko, zh (default: en)"
            echo ""
            echo "Examples:"
            echo "  $0 --video_url 'https://www.youtube.com/watch?v=abc123'"
            echo "  $0 --video_url 'https://youtu.be/abc123' --output_path ~/transcript.txt"
            echo "  $0 --video_url 'https://youtu.be/abc123' --language es"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate required arguments
if [[ -z "$VIDEO_URL" ]]; then
    echo "Error: --video_url is required"
    echo "Usage: $0 --video_url '<URL>' [--output_path <PATH>]"
    exit 1
fi

# Extract video ID from URL
if [[ "$VIDEO_URL" =~ v=([^&]+) ]]; then
    VIDEO_ID="${BASH_REMATCH[1]}"
elif [[ "$VIDEO_URL" =~ youtu\.be/([^?]+) ]]; then
    VIDEO_ID="${BASH_REMATCH[1]}"
elif [[ "$VIDEO_URL" =~ shorts/([^?]+) ]]; then
    VIDEO_ID="${BASH_REMATCH[1]}"
else
    echo "Error: Could not extract video ID from URL"
    exit 1
fi

# Expand tilde in output path
if [[ -n "$OUTPUT_PATH" ]]; then
    OUTPUT_PATH="${OUTPUT_PATH/#\~/$HOME}"

    # Check if output_path is a directory or ends with /
    if [[ -d "$OUTPUT_PATH" ]] || [[ "$OUTPUT_PATH" == */ ]]; then
        mkdir -p "$OUTPUT_PATH"
        OUTPUT_PATH="${OUTPUT_PATH%/}/${VIDEO_ID}_transcript.txt"
    else
        mkdir -p "$(dirname "$OUTPUT_PATH")"
    fi
fi

# Python script for fetching transcript
PYTHON_SCRIPT=$(cat << 'PYEOF'
import sys
sys.path.insert(0, '/Users/azulee/Library/Python/3.9/lib/python/site-packages')

import os
from youtube_transcript_api import YouTubeTranscriptApi

video_id = sys.argv[1]
output_path = sys.argv[2] if len(sys.argv) > 2 and sys.argv[2] else None
language = sys.argv[3] if len(sys.argv) > 3 else 'en'

try:
    api = YouTubeTranscriptApi()
    transcript = api.fetch(video_id, languages=[language, 'en'])
    segments = list(transcript)

    lines = []
    for t in segments:
        mins = int(t.start // 60)
        secs = t.start % 60
        clean_text = t.text.replace('\n', ' ').replace('\xa0', ' ')
        clean_text = ' '.join(clean_text.split())
        lines.append(f'[{mins:02d}:{secs:05.2f}] {clean_text}')

    if output_path:
        with open(output_path, 'w') as f:
            f.write('\n'.join(lines))

        file_size = os.path.getsize(output_path)
        last_segment = segments[-1]
        duration_mins = int(last_segment.start // 60)
        duration_secs = last_segment.start % 60

        print(f'Saved to: {output_path}')
        print(f'Segments: {len(segments)}')
        print(f'Duration: ~{duration_mins}:{duration_secs:05.2f}')
        print(f'File size: {file_size} bytes')
    else:
        print('\n'.join(lines))
        print(f'\nSegments: {len(segments)}', file=sys.stderr)

except Exception as e:
    print(f'Error: {e}', file=sys.stderr)
    sys.exit(1)
PYEOF
)

# Run the Python script
python3 -c "$PYTHON_SCRIPT" "$VIDEO_ID" "$OUTPUT_PATH" "$LANGUAGE"
