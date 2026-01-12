#!/bin/bash
#
# ============================================================================
# calculate-video-kpis.sh
# ============================================================================
#
# DESCRIPTION:
#   Calculate YouTube video KPIs from a stats.json file.
#   Includes viral metrics, engagement rates, content efficiency,
#   watch time estimates, and benchmark comparisons.
#
# USAGE:
#   ./calculate-video-kpis.sh --input_path <PATH> --output_path <PATH>
#
# ARGUMENTS:
#   --input_path <PATH>    (required) Path to stats.json file
#   --output_path <PATH>   (required) Path to save KPI report
#   -h, --help             Show help message
#
# KPIs CALCULATED:
#   - Views/Subscriber Ratio (viral potential)
#   - Views per Day/Hour (velocity)
#   - Like Rate, Comment Rate, Engagement Rate
#   - Like/Comment Ratio
#   - Views per Minute, Engagement per Minute
#   - Estimated Watch Hours
#
# EXAMPLES:
#   ./calculate-video-kpis.sh --input_path ~/video/stats.json --output_path ~/video/kpis.txt
#
# DEPENDENCIES:
#   - jq (brew install jq)
#   - bc (usually pre-installed)
#
# ============================================================================

set -e

INPUT_PATH=""
OUTPUT_PATH=""

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
            echo "Usage: $0 --input_path <PATH> --output_path <PATH>"
            echo ""
            echo "Options:"
            echo "  --input_path   Path to stats.json file (required)"
            echo "  --output_path  Path to save KPI report (required)"
            echo ""
            echo "Example:"
            echo "  $0 --input_path ~/video/stats.json --output_path ~/video/kpis.txt"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$INPUT_PATH" ]]; then
    echo "Error: --input_path is required"
    exit 1
fi

if [[ -z "$OUTPUT_PATH" ]]; then
    echo "Error: --output_path is required"
    exit 1
fi

INPUT_PATH="${INPUT_PATH/#\~/$HOME}"
OUTPUT_PATH="${OUTPUT_PATH/#\~/$HOME}"

if [[ ! -f "$INPUT_PATH" ]]; then
    echo "Error: File not found: $INPUT_PATH"
    exit 1
fi

# Extract data from JSON
TITLE=$(jq -r '.video.title' "$INPUT_PATH")
VIDEO_ID=$(jq -r '.video.id' "$INPUT_PATH")
DURATION_SEC=$(jq -r '.video.duration_seconds' "$INPUT_PATH")
DURATION_DISPLAY=$(jq -r '.video.duration_display' "$INPUT_PATH")
UPLOAD_DATE=$(jq -r '.video.upload_date' "$INPUT_PATH")
CHANNEL=$(jq -r '.channel.name' "$INPUT_PATH")
SUBSCRIBERS=$(jq -r '.channel.subscriber_count' "$INPUT_PATH")
VIEWS=$(jq -r '.stats.view_count' "$INPUT_PATH")
LIKES=$(jq -r '.stats.like_count' "$INPUT_PATH")
COMMENTS=$(jq -r '.stats.comment_count' "$INPUT_PATH")

# Calculate days since upload
UPLOAD_YEAR=${UPLOAD_DATE:0:4}
UPLOAD_MONTH=${UPLOAD_DATE:4:2}
UPLOAD_DAY=${UPLOAD_DATE:6:2}
UPLOAD_EPOCH=$(date -j -f "%Y-%m-%d" "${UPLOAD_YEAR}-${UPLOAD_MONTH}-${UPLOAD_DAY}" "+%s" 2>/dev/null || date -d "${UPLOAD_YEAR}-${UPLOAD_MONTH}-${UPLOAD_DAY}" "+%s")
NOW_EPOCH=$(date "+%s")
DAYS_SINCE=$(( (NOW_EPOCH - UPLOAD_EPOCH) / 86400 ))
HOURS_SINCE=$(( (NOW_EPOCH - UPLOAD_EPOCH) / 3600 ))

# Calculate KPIs
DURATION_MIN=$(echo "scale=2; $DURATION_SEC / 60" | bc)

# Viral metrics
VIEWS_PER_SUB=$(echo "scale=2; $VIEWS / $SUBSCRIBERS" | bc)
VIEWS_PER_DAY=$(echo "scale=0; $VIEWS / $DAYS_SINCE" | bc)
VIEWS_PER_HOUR=$(echo "scale=0; $VIEWS / $HOURS_SINCE" | bc)

# Engagement metrics
LIKE_RATE=$(printf "%.2f" $(echo "scale=4; ($LIKES / $VIEWS) * 100" | bc))
COMMENT_RATE=$(printf "%.3f" $(echo "scale=5; ($COMMENTS / $VIEWS) * 100" | bc))
ENGAGEMENT_RATE=$(printf "%.2f" $(echo "scale=4; (($LIKES + $COMMENTS) / $VIEWS) * 100" | bc))
LIKE_COMMENT_RATIO=$(echo "scale=1; $LIKES / $COMMENTS" | bc)

# Content efficiency
VIEWS_PER_MIN=$(echo "scale=0; $VIEWS / $DURATION_MIN" | bc)
ENGAGEMENT_PER_MIN=$(echo "scale=0; ($LIKES + $COMMENTS) / $DURATION_MIN" | bc)

# Watch time estimates (50% retention assumption)
EST_WATCH_HOURS=$(echo "scale=0; ($VIEWS * $DURATION_SEC * 0.5) / 3600" | bc)
EST_HOURS_PER_DAY=$(echo "scale=0; $EST_WATCH_HOURS / $DAYS_SINCE" | bc)

# Rating functions
rate_viral() {
    local ratio=$1
    if (( $(echo "$ratio >= 10" | bc -l) )); then
        echo "VIRAL"
    elif (( $(echo "$ratio >= 5" | bc -l) )); then
        echo "GREAT"
    elif (( $(echo "$ratio >= 1" | bc -l) )); then
        echo "GOOD"
    else
        echo "GROWING"
    fi
}

rate_like() {
    local rate=$1
    if (( $(echo "$rate >= 5" | bc -l) )); then
        echo "EXCELLENT"
    elif (( $(echo "$rate >= 3" | bc -l) )); then
        echo "GOOD"
    elif (( $(echo "$rate >= 2" | bc -l) )); then
        echo "AVERAGE"
    else
        echo "LOW"
    fi
}

rate_comment() {
    local rate=$1
    if (( $(echo "$rate >= 0.1" | bc -l) )); then
        echo "HIGH"
    elif (( $(echo "$rate >= 0.03" | bc -l) )); then
        echo "AVERAGE"
    else
        echo "LOW"
    fi
}

# Format numbers with commas
format_num() {
    printf "%'d" $1
}

VIRAL_RATING=$(rate_viral $VIEWS_PER_SUB)
LIKE_RATING=$(rate_like $LIKE_RATE)
COMMENT_RATING=$(rate_comment $COMMENT_RATE)

# Create output directory
mkdir -p "$(dirname "$OUTPUT_PATH")"

# Generate report
REPORT=$(cat << EOF
================================================================================
KPI REPORT: $TITLE
================================================================================

VIDEO INFO
  ID:             $VIDEO_ID
  Duration:       $DURATION_DISPLAY ($DURATION_SEC sec)
  Uploaded:       ${UPLOAD_YEAR}-${UPLOAD_MONTH}-${UPLOAD_DAY} ($DAYS_SINCE days ago)
  Channel:        $CHANNEL ($(format_num $SUBSCRIBERS) subs)

RAW STATS
  Views:          $(format_num $VIEWS)
  Likes:          $(format_num $LIKES)
  Comments:       $(format_num $COMMENTS)

--------------------------------------------------------------------------------
VIRAL METRICS
--------------------------------------------------------------------------------
  Views/Subscriber:     ${VIEWS_PER_SUB}x           [$VIRAL_RATING]
  Views/Day:            $(format_num $VIEWS_PER_DAY)
  Views/Hour:           $(format_num $VIEWS_PER_HOUR)

--------------------------------------------------------------------------------
ENGAGEMENT METRICS
--------------------------------------------------------------------------------
  Like Rate:            ${LIKE_RATE}%           [$LIKE_RATING] (avg: 4%)
  Comment Rate:         ${COMMENT_RATE}%         [$COMMENT_RATING] (avg: 0.05%)
  Engagement Rate:      ${ENGAGEMENT_RATE}%
  Like/Comment Ratio:   ${LIKE_COMMENT_RATIO}:1         (avg: 50:1)

--------------------------------------------------------------------------------
CONTENT EFFICIENCY
--------------------------------------------------------------------------------
  Views/Minute:         $(format_num $VIEWS_PER_MIN)
  Engagement/Minute:    $(format_num $ENGAGEMENT_PER_MIN)

--------------------------------------------------------------------------------
WATCH TIME (ESTIMATED @ 50% RETENTION)
--------------------------------------------------------------------------------
  Est. Total Hours:     $(format_num $EST_WATCH_HOURS) hrs
  Est. Hours/Day:       $(format_num $EST_HOURS_PER_DAY) hrs

================================================================================
EOF
)

# Save and print
echo "$REPORT" > "$OUTPUT_PATH"
echo "$REPORT"
echo ""
echo "Saved to: $OUTPUT_PATH"
