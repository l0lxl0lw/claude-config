#!/bin/bash
#
# ============================================================================
# download-image.sh
# ============================================================================
#
# DESCRIPTION:
#   Download an image from a URL using curl.
#   Supports any HTTP/HTTPS image URL with automatic redirect following.
#
# USAGE:
#   ./download-image.sh --image_url <URL> --output_path <PATH>
#
# ARGUMENTS:
#   --image_url <URL>      (required) Direct URL to the image
#                          Supports any HTTP/HTTPS URL
#
#   --output_path <PATH>   (required) Output destination
#                          - If directory (exists or ends with /): uses filename from URL
#                          - If file path: saves to exact path specified
#
#   -h, --help             Show help message
#
# EXAMPLES:
#   # Download to specific file
#   ./download-image.sh --image_url 'https://i.ytimg.com/vi/abc123/maxresdefault.jpg' --output_path ~/images/thumb.jpg
#
#   # Download to directory (uses filename from URL)
#   ./download-image.sh --image_url 'https://example.com/photo.png' --output_path ~/images/
#
#   # Download YouTube thumbnail
#   ./download-image.sh --image_url 'https://i.ytimg.com/vi/Xtxscxi83XA/sddefault.jpg' --output_path ~/Downloads/thumbnail.jpg
#
# OUTPUT:
#   - Downloaded image file at specified location
#   - Prints file path, size, and type on success
#
# DEPENDENCIES:
#   - curl
#
# ============================================================================

set -e

# Default values
IMAGE_URL=""
OUTPUT_PATH=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --image_url)
            IMAGE_URL="$2"
            shift 2
            ;;
        --output_path)
            OUTPUT_PATH="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 --image_url <URL> --output_path <PATH>"
            echo ""
            echo "Options:"
            echo "  --image_url    Direct URL to the image (required)"
            echo "  --output_path  Output path - can be directory or full file path (required)"
            echo ""
            echo "Examples:"
            echo "  $0 --image_url 'https://example.com/image.jpg' --output_path ~/images/photo.jpg"
            echo "  $0 --image_url 'https://example.com/image.jpg' --output_path ~/images/"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate required arguments
if [[ -z "$IMAGE_URL" ]]; then
    echo "Error: --image_url is required"
    echo "Usage: $0 --image_url '<URL>' --output_path <PATH>"
    exit 1
fi

if [[ -z "$OUTPUT_PATH" ]]; then
    echo "Error: --output_path is required"
    echo "Usage: $0 --image_url '<URL>' --output_path <PATH>"
    exit 1
fi

# Expand tilde
OUTPUT_PATH="${OUTPUT_PATH/#\~/$HOME}"

# Check if output_path is a directory or ends with /
if [[ -d "$OUTPUT_PATH" ]] || [[ "$OUTPUT_PATH" == */ ]]; then
    # It's a directory - extract filename from URL
    FILENAME=$(basename "$IMAGE_URL" | cut -d'?' -f1)
    if [[ -z "$FILENAME" ]] || [[ "$FILENAME" == "/" ]]; then
        FILENAME="image.jpg"
    fi
    mkdir -p "$OUTPUT_PATH"
    OUTPUT_PATH="${OUTPUT_PATH%/}/$FILENAME"
else
    # It's a file path - create parent directory
    mkdir -p "$(dirname "$OUTPUT_PATH")"
fi

# Download the image
echo "Downloading: $IMAGE_URL"
curl -sL -o "$OUTPUT_PATH" "$IMAGE_URL"

# Verify download
if [[ -f "$OUTPUT_PATH" ]]; then
    # Get file size (macOS and Linux compatible)
    FILE_SIZE=$(stat -f%z "$OUTPUT_PATH" 2>/dev/null || stat -c%s "$OUTPUT_PATH" 2>/dev/null)
    FILE_TYPE=$(file "$OUTPUT_PATH")

    if [[ "$FILE_SIZE" -lt 1000 ]]; then
        echo "Warning: Downloaded file is very small ($FILE_SIZE bytes) - may be invalid"
    fi

    echo "Downloaded: $OUTPUT_PATH"
    echo "File size: $FILE_SIZE bytes"
    echo "File type: $FILE_TYPE"
else
    echo "Error: Failed to download image"
    exit 1
fi
