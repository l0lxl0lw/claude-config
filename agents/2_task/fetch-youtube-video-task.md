---
name: fetch-youtube-video-task
description: "Process a YouTube video: download, get stats, transcript, thumbnail, frames, summary, and KPIs."
input: youtube_url
model: sonnet
dangerouslyDisableSandbox: true
allowedTools:
  - Bash
---

You process YouTube videos by generating and executing a self-contained bash script.

## Instructions

1. Extract the VIDEO_ID from the YouTube URL (the `v=` parameter or youtu.be/ path)
2. Generate the complete bash script below with VIDEO_URL and VIDEO_ID substituted
3. Execute the entire script in a SINGLE Bash tool call

## Script Template

Generate this script with `VIDEO_URL` and `VIDEO_ID` replaced with actual values, then execute it:

```bash
#!/bin/bash

# =============================================================================
# YouTube Video Processing Script
# =============================================================================

VIDEO_URL="__VIDEO_URL__"
VIDEO_ID="__VIDEO_ID__"
SCRIPTS_DIR="/Users/azulee/workspace/claude-config/agents/1_command"

# -----------------------------------------------------------------------------
# Phase 1: Setup
# -----------------------------------------------------------------------------
echo "=== Phase 1: Setup ==="
VIDEO_TITLE=$(yt-dlp --get-title "$VIDEO_URL" 2>/dev/null | tr -d '/:*?"<>|\\' | cut -c1-50)
OUTPUT_DIR="$(pwd)/$(date +%Y-%m-%d)_${VIDEO_ID}_${VIDEO_TITLE}"
mkdir -p "$OUTPUT_DIR"
STEP1_STATUS=$?

if [ $STEP1_STATUS -ne 0 ]; then
  echo "ERROR: Setup failed"
  exit 1
fi

echo "Output directory: $OUTPUT_DIR"

# -----------------------------------------------------------------------------
# Phase 2: Download Video, Stats, Transcript (Parallel)
# -----------------------------------------------------------------------------
echo "=== Phase 2: Parallel Downloads ==="

# Step 2: Download Video
"$SCRIPTS_DIR/url/download-youtube-video.sh" \
  --video_url "$VIDEO_URL" \
  --output_path "$OUTPUT_DIR/${VIDEO_ID}.mp4" \
  --quality 240 &
PID_VIDEO=$!

# Step 3: Fetch Stats
"$SCRIPTS_DIR/url/fetch-youtube-stats.sh" \
  --video_url "$VIDEO_URL" \
  --output_path "$OUTPUT_DIR/stats.json" &
PID_STATS=$!

# Step 4: Fetch Transcript
"$SCRIPTS_DIR/url/fetch-youtube-transcript.sh" \
  --video_url "$VIDEO_URL" \
  --output_path "$OUTPUT_DIR/transcript.txt" &
PID_TRANSCRIPT=$!

# -----------------------------------------------------------------------------
# Phase 3: Wait and Process Dependencies
# -----------------------------------------------------------------------------
echo "=== Phase 3: Processing Dependencies ==="

# Wait for Video download, then extract frames
wait $PID_VIDEO
STEP2_STATUS=$?
echo "Step 2 (Video): $([ $STEP2_STATUS -eq 0 ] && echo 'OK' || echo 'FAILED')"

if [ $STEP2_STATUS -eq 0 ]; then
  "$SCRIPTS_DIR/file/extract-video-frames.sh" \
    --video_path "$OUTPUT_DIR/${VIDEO_ID}.mp4" \
    --output_dir "$OUTPUT_DIR/frames" &
  PID_FRAMES=$!
else
  PID_FRAMES=""
  STEP6_STATUS=1
fi

# Wait for Stats, then download thumbnail and calculate KPIs
wait $PID_STATS
STEP3_STATUS=$?
echo "Step 3 (Stats): $([ $STEP3_STATUS -eq 0 ] && echo 'OK' || echo 'FAILED')"

if [ $STEP3_STATUS -eq 0 ]; then
  THUMBNAIL_URL=$(jq -r '.media.thumbnail_url' "$OUTPUT_DIR/stats.json")

  "$SCRIPTS_DIR/url/download-image.sh" \
    --image_url "$THUMBNAIL_URL" \
    --output_path "$OUTPUT_DIR/thumbnail.jpg" &
  PID_THUMB=$!

  "$SCRIPTS_DIR/file/calculate-video-kpis.sh" \
    --input_path "$OUTPUT_DIR/stats.json" \
    --output_path "$OUTPUT_DIR/kpis.txt" &
  PID_KPIS=$!
else
  # Fallback thumbnail
  THUMBNAIL_URL="https://i.ytimg.com/vi/${VIDEO_ID}/sddefault.jpg"
  "$SCRIPTS_DIR/url/download-image.sh" \
    --image_url "$THUMBNAIL_URL" \
    --output_path "$OUTPUT_DIR/thumbnail.jpg" &
  PID_THUMB=$!
  PID_KPIS=""
  STEP8_STATUS=1
fi

# Wait for Transcript, then generate summary
wait $PID_TRANSCRIPT
STEP4_STATUS=$?
echo "Step 4 (Transcript): $([ $STEP4_STATUS -eq 0 ] && echo 'OK' || echo 'FAILED')"

if [ $STEP4_STATUS -eq 0 ]; then
  "$SCRIPTS_DIR/file/summarize-text.sh" \
    --input_path "$OUTPUT_DIR/transcript.txt" \
    --output_path "$OUTPUT_DIR/summary.txt" &
  PID_SUMMARY=$!
else
  PID_SUMMARY=""
  STEP7_STATUS=1
fi

# -----------------------------------------------------------------------------
# Phase 4: Wait for Remaining Tasks
# -----------------------------------------------------------------------------
echo "=== Phase 4: Waiting for Remaining Tasks ==="

if [ -n "$PID_FRAMES" ]; then
  wait $PID_FRAMES
  STEP6_STATUS=$?
fi

if [ -n "$PID_THUMB" ]; then
  wait $PID_THUMB
  STEP5_STATUS=$?
fi

if [ -n "$PID_KPIS" ]; then
  wait $PID_KPIS
  STEP8_STATUS=$?
fi

if [ -n "$PID_SUMMARY" ]; then
  wait $PID_SUMMARY
  STEP7_STATUS=$?
fi

# -----------------------------------------------------------------------------
# Phase 5: Final Report
# -----------------------------------------------------------------------------
echo ""
echo "=== Status Report ==="
echo ""
echo "| Step | Task | Status |"
echo "|------|------|--------|"
echo "| 1 | Setup | OK |"
echo "| 2 | Download Video | $([ $STEP2_STATUS -eq 0 ] && echo 'OK' || echo 'FAILED') |"
echo "| 3 | Fetch Stats | $([ $STEP3_STATUS -eq 0 ] && echo 'OK' || echo 'FAILED') |"
echo "| 4 | Fetch Transcript | $([ $STEP4_STATUS -eq 0 ] && echo 'OK' || echo 'FAILED') |"
echo "| 5 | Download Thumbnail | $([ ${STEP5_STATUS:-1} -eq 0 ] && echo 'OK' || echo 'FAILED') |"
echo "| 6 | Extract Frames | $([ ${STEP6_STATUS:-1} -eq 0 ] && echo 'OK' || echo 'SKIPPED/FAILED') |"
echo "| 7 | Generate Summary | $([ ${STEP7_STATUS:-1} -eq 0 ] && echo 'OK' || echo 'SKIPPED/FAILED') |"
echo "| 8 | Calculate KPIs | $([ ${STEP8_STATUS:-1} -eq 0 ] && echo 'OK' || echo 'SKIPPED/FAILED') |"
echo ""
echo "Output: $OUTPUT_DIR"
echo ""
ls -la "$OUTPUT_DIR"
```

## Example

For URL `https://www.youtube.com/watch?v=Xtxscxi83XA`:
- VIDEO_URL = `https://www.youtube.com/watch?v=Xtxscxi83XA`
- VIDEO_ID = `Xtxscxi83XA`

Then execute the script with those values substituted.

## Rules

1. Execute the ENTIRE script in ONE Bash tool call
2. Replace `__VIDEO_URL__` with the actual YouTube URL
3. Replace `__VIDEO_ID__` with the extracted video ID
4. Do NOT split into multiple Bash calls - this causes variable loss
5. Execute immediately without confirmation prompts
