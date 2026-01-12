#!/bin/bash
#
# ============================================================================
# fetch-youtube-stats.sh
# ============================================================================
#
# DESCRIPTION:
#   Fetch comprehensive statistics and metadata for a YouTube video.
#   Returns structured JSON with video info, channel info, stats, and thumbnails.
#
# USAGE:
#   ./fetch-youtube-stats.sh --video_url <URL> [--output_path <PATH>]
#
# ARGUMENTS:
#   --video_url <URL>      (required) YouTube video URL - MUST be quoted
#                          Supports: youtube.com/watch?v=, youtu.be/, shorts/
#
#   --output_path <PATH>   (optional) File path to save JSON output
#                          - If provided: saves to file AND prints to stdout
#                          - If omitted: prints to stdout only
#
#   -h, --help             Show help message
#
# OUTPUT FORMAT:
#   {
#     "video": {
#       "id": "VIDEO_ID",
#       "title": "Video Title",
#       "description": "First 500 chars...",
#       "duration_seconds": 123,
#       "duration_display": "2:03",
#       "upload_date": "20240101",
#       "availability": "public",
#       "is_live": false,
#       "was_live": false
#     },
#     "channel": {
#       "name": "Channel Name",
#       "id": "CHANNEL_ID",
#       "url": "https://...",
#       "subscriber_count": 100000
#     },
#     "stats": {
#       "view_count": 1000000,
#       "like_count": 50000,
#       "comment_count": 1000
#     },
#     "metadata": {
#       "categories": ["Education"],
#       "tags": ["tag1", "tag2", ...],
#       "language": "en",
#       "age_limit": 0
#     },
#     "media": {
#       "thumbnail_url": "https://i.ytimg.com/...",
#       "thumbnails": ["https://...", "https://..."]
#     }
#   }
#
# EXAMPLES:
#   # Print stats to console
#   ./fetch-youtube-stats.sh --video_url 'https://www.youtube.com/watch?v=abc123'
#
#   # Save stats to file
#   ./fetch-youtube-stats.sh --video_url 'https://www.youtube.com/watch?v=abc123' --output_path ~/stats.json
#
#   # Extract specific field with jq
#   ./fetch-youtube-stats.sh --video_url 'https://youtu.be/abc123' | jq '.stats.view_count'
#
# DEPENDENCIES:
#   - yt-dlp (brew install yt-dlp or pip install yt-dlp)
#   - jq (brew install jq)
#
# ============================================================================

set -e

# Default values
VIDEO_URL=""
OUTPUT_PATH=""

# jq filter for structured output
JQ_FILTER='{
  video: {
    id: .id,
    title: .title,
    description: (.description // "" | .[0:500]),
    duration_seconds: .duration,
    duration_display: .duration_string,
    upload_date: .upload_date,
    availability: .availability,
    is_live: .is_live,
    was_live: .was_live
  },
  channel: {
    name: .channel,
    id: .channel_id,
    url: .channel_url,
    subscriber_count: .channel_follower_count
  },
  stats: {
    view_count: .view_count,
    like_count: .like_count,
    comment_count: .comment_count
  },
  metadata: {
    categories: .categories,
    tags: (.tags // [] | .[0:15]),
    language: .language,
    age_limit: .age_limit
  },
  media: {
    thumbnail_url: .thumbnail,
    thumbnails: [.thumbnails[-1].url, .thumbnails[-2].url] | map(select(. != null))
  }
}'

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
        -h|--help)
            echo "Usage: $0 --video_url <URL> [--output_path <PATH>]"
            echo ""
            echo "Options:"
            echo "  --video_url    YouTube video URL (required) - MUST be quoted"
            echo "  --output_path  File path to save JSON output (optional)"
            echo ""
            echo "Examples:"
            echo "  $0 --video_url 'https://www.youtube.com/watch?v=abc123'"
            echo "  $0 --video_url 'https://youtu.be/abc123' --output_path ~/stats.json"
            echo "  $0 --video_url 'https://youtu.be/abc123' | jq '.stats'"
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

# Check dependencies
if ! command -v yt-dlp &> /dev/null; then
    echo "Error: yt-dlp is not installed"
    echo "Install with: brew install yt-dlp or pip install yt-dlp"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed"
    echo "Install with: brew install jq"
    exit 1
fi

# Fetch and format stats
if [[ -n "$OUTPUT_PATH" ]]; then
    # Expand tilde
    OUTPUT_PATH="${OUTPUT_PATH/#\~/$HOME}"

    # Create parent directory if needed
    mkdir -p "$(dirname "$OUTPUT_PATH")"

    # Fetch, format, save, and print
    yt-dlp --dump-json "$VIDEO_URL" | jq "$JQ_FILTER" | tee "$OUTPUT_PATH"

    echo ""
    echo "Saved to: $OUTPUT_PATH" >&2
else
    # Fetch and print to stdout only
    yt-dlp --dump-json "$VIDEO_URL" | jq "$JQ_FILTER"
fi
