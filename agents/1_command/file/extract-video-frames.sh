#!/bin/bash
#
# ============================================================================
# extract-video-frames.sh
# ============================================================================
#
# DESCRIPTION:
#   Extract frames from a video file at 1 frame per second.
#   Saves frames as sequentially numbered JPG images.
#
# USAGE:
#   ./extract-video-frames.sh --video_path <PATH> --output_dir <PATH> [--fps <FPS>]
#
# ARGUMENTS:
#   --video_path <PATH>    (required) Path to the video file
#                          Supports: .mp4, .mov, .webm, .avi, .mkv
#
#   --output_dir <PATH>    (required) Directory to save extracted frames
#                          Will be created if it doesn't exist
#
#   --fps <FPS>            (optional) Frames per second to extract (default: 1)
#                          Use 0.5 for 1 frame every 2 seconds
#                          Use 2 for 2 frames per second
#
#   -h, --help             Show help message
#
# OUTPUT:
#   - frame_001.jpg, frame_002.jpg, frame_003.jpg, ...
#   - Prints total frames extracted and directory size
#
# EXAMPLES:
#   # Extract 1 frame per second
#   ./extract-video-frames.sh --video_path ~/video.mp4 --output_dir ~/frames/
#
#   # Extract 1 frame every 2 seconds
#   ./extract-video-frames.sh --video_path ~/video.mp4 --output_dir ~/frames/ --fps 0.5
#
#   # Extract 2 frames per second
#   ./extract-video-frames.sh --video_path ~/video.mp4 --output_dir ~/frames/ --fps 2
#
# DEPENDENCIES:
#   - ffmpeg (brew install ffmpeg)
#
# ============================================================================

set -e

# Default values
VIDEO_PATH=""
OUTPUT_DIR=""
FPS="1"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --video_path)
            VIDEO_PATH="$2"
            shift 2
            ;;
        --output_dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --fps)
            FPS="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 --video_path <PATH> --output_dir <PATH> [--fps <FPS>]"
            echo ""
            echo "Options:"
            echo "  --video_path  Path to video file (required)"
            echo "  --output_dir  Directory to save frames (required)"
            echo "  --fps         Frames per second to extract (default: 1)"
            echo ""
            echo "Examples:"
            echo "  $0 --video_path ~/video.mp4 --output_dir ~/frames/"
            echo "  $0 --video_path ~/video.mp4 --output_dir ~/frames/ --fps 0.5"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate required arguments
if [[ -z "$VIDEO_PATH" ]]; then
    echo "Error: --video_path is required"
    echo "Usage: $0 --video_path <PATH> --output_dir <PATH>"
    exit 1
fi

if [[ -z "$OUTPUT_DIR" ]]; then
    echo "Error: --output_dir is required"
    echo "Usage: $0 --video_path <PATH> --output_dir <PATH>"
    exit 1
fi

# Expand tilde
VIDEO_PATH="${VIDEO_PATH/#\~/$HOME}"
OUTPUT_DIR="${OUTPUT_DIR/#\~/$HOME}"

# Check video file exists
if [[ ! -f "$VIDEO_PATH" ]]; then
    echo "Error: Video file not found: $VIDEO_PATH"
    exit 1
fi

# Check ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed"
    echo "Install with: brew install ffmpeg"
    exit 1
fi

# Create output directory
echo "Creating output directory: $OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Extract frames
echo "Extracting frames at $FPS fps..."
echo "Video: $VIDEO_PATH"
echo "Output: $OUTPUT_DIR"
echo ""

ffmpeg -i "$VIDEO_PATH" -vf "fps=$FPS" "$OUTPUT_DIR/frame_%03d.jpg" -y -loglevel warning

# Count frames and get size
FRAME_COUNT=$(ls -1 "$OUTPUT_DIR"/frame_*.jpg 2>/dev/null | wc -l | tr -d ' ')
DIR_SIZE=$(du -sh "$OUTPUT_DIR" | cut -f1)

echo ""
echo "Extracted: $FRAME_COUNT frames"
echo "Saved to: $OUTPUT_DIR"
echo "Total size: $DIR_SIZE"
