#!/bin/bash
#
# ============================================================================
# download-youtube-video.sh
# ============================================================================
#
# DESCRIPTION:
#   Download YouTube videos using yt-dlp with configurable quality settings.
#   Supports both directory and file path outputs.
#
# USAGE:
#   ./download-youtube-video.sh --video_url <URL> --output_path <PATH> [--quality <QUALITY>]
#
# ARGUMENTS:
#   --video_url <URL>      (required) YouTube video URL - MUST be quoted
#                          Supports: youtube.com/watch?v=, youtu.be/, shorts/
#
#   --output_path <PATH>   (required) Output destination
#                          - If directory (exists or ends with /): saves as <title>.mp4
#                          - If file path: saves to exact path specified
#
#   --quality <QUALITY>    (optional) Video quality, default: 240
#                          Options: 144, 240, 360, 480, 720, 1080, best
#                          Falls back to next higher quality if unavailable
#
#   -h, --help             Show help message
#
# EXAMPLES:
#   # Download to directory (uses video title as filename)
#   ./download-youtube-video.sh --video_url 'https://www.youtube.com/watch?v=abc123' --output_path ~/Downloads/
#
#   # Download to specific file
#   ./download-youtube-video.sh --video_url 'https://www.youtube.com/watch?v=abc123' --output_path ~/Videos/video.mp4
#
#   # Download at 720p quality
#   ./download-youtube-video.sh --video_url 'https://youtu.be/abc123' --output_path ~/Downloads/ --quality 720
#
#   # Download best quality
#   ./download-youtube-video.sh --video_url 'https://youtu.be/abc123' --output_path ~/Downloads/ --quality best
#
# OUTPUT:
#   - Video file in mp4 format at specified location
#   - Audio: m4a (lowest quality to minimize file size)
#   - Video: h264 codec in mp4 container
#
# DEPENDENCIES:
#   - yt-dlp (brew install yt-dlp or pip install yt-dlp)
#   - ffmpeg (for merging video/audio streams)
#
# ============================================================================

set -e

# Default values
VIDEO_URL=""
OUTPUT_PATH=""
QUALITY="240"

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
        --quality)
            QUALITY="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 --video_url <URL> --output_path <PATH> [--quality <QUALITY>]"
            echo ""
            echo "Options:"
            echo "  --video_url    YouTube video URL (required) - MUST be quoted"
            echo "  --output_path  Output path - can be directory or full file path (required)"
            echo "  --quality      Video quality: 144, 240, 360, 480, 720, 1080, best (default: 240)"
            echo ""
            echo "Examples:"
            echo "  $0 --video_url 'https://www.youtube.com/watch?v=abc123' --output_path ~/Videos/"
            echo "  $0 --video_url 'https://www.youtube.com/watch?v=abc123' --output_path ~/Videos/video.mp4"
            echo "  $0 --video_url 'https://youtu.be/abc123' --output_path ~/Downloads/ --quality 720"
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
    echo "Usage: $0 --video_url '<URL>' --output_path <PATH> [--quality <QUALITY>]"
    exit 1
fi

if [[ -z "$OUTPUT_PATH" ]]; then
    echo "Error: --output_path is required"
    echo "Usage: $0 --video_url '<URL>' --output_path <PATH> [--quality <QUALITY>]"
    exit 1
fi

# Expand tilde
OUTPUT_PATH="${OUTPUT_PATH/#\~/$HOME}"

# Check if output_path is a directory or ends with /
if [[ -d "$OUTPUT_PATH" ]] || [[ "$OUTPUT_PATH" == */ ]]; then
    # It's a directory - append template for video title
    mkdir -p "$OUTPUT_PATH"
    OUTPUT_PATH="${OUTPUT_PATH%/}/%(title)s.%(ext)s"
else
    # It's a file path - create parent directory
    mkdir -p "$(dirname "$OUTPUT_PATH")"
fi

# Build format selector based on quality
case $QUALITY in
    144)
        FORMAT="bestvideo[height<=144][ext=mp4]+worstaudio[ext=m4a]/bestvideo[height<=240][ext=mp4]+worstaudio[ext=m4a]/bestvideo[ext=mp4]+worstaudio[ext=m4a]"
        ;;
    240)
        FORMAT="bestvideo[height<=240][ext=mp4]+worstaudio[ext=m4a]/bestvideo[height<=360][ext=mp4]+worstaudio[ext=m4a]/bestvideo[height<=480][ext=mp4]+worstaudio[ext=m4a]/bestvideo[ext=mp4]+worstaudio[ext=m4a]"
        ;;
    360)
        FORMAT="bestvideo[height<=360][ext=mp4]+worstaudio[ext=m4a]/bestvideo[height<=480][ext=mp4]+worstaudio[ext=m4a]/bestvideo[ext=mp4]+worstaudio[ext=m4a]"
        ;;
    480)
        FORMAT="bestvideo[height<=480][ext=mp4]+worstaudio[ext=m4a]/bestvideo[height<=720][ext=mp4]+worstaudio[ext=m4a]/bestvideo[ext=mp4]+worstaudio[ext=m4a]"
        ;;
    720)
        FORMAT="bestvideo[height<=720][ext=mp4]+worstaudio[ext=m4a]/bestvideo[height<=1080][ext=mp4]+worstaudio[ext=m4a]/bestvideo[ext=mp4]+worstaudio[ext=m4a]"
        ;;
    1080)
        FORMAT="bestvideo[height<=1080][ext=mp4]+worstaudio[ext=m4a]/bestvideo[ext=mp4]+worstaudio[ext=m4a]"
        ;;
    best)
        FORMAT="bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio"
        ;;
    *)
        echo "Error: Invalid quality '$QUALITY'. Use: 144, 240, 360, 480, 720, 1080, or best"
        exit 1
        ;;
esac

echo "Downloading at ${QUALITY}p quality..."

# Download to specified path
yt-dlp -f "$FORMAT" --merge-output-format mp4 -o "$OUTPUT_PATH" "$VIDEO_URL"

echo "Done!"
