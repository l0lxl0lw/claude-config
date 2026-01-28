#!/bin/bash
# Track a job application in applications.md
# Usage: track-application.sh <company-name> <role-title> [status] [notes]

set -e

RESUME_BASE="/Users/azulee/workspace/private/resume"
APPLICATIONS_FILE="$RESUME_BASE/applications.md"

if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 <company-name> <role-title> [status] [notes]"
    echo "Example: $0 'Acme Corp' 'Senior Engineer' 'Applied' 'Referral from John'"
    exit 1
fi

COMPANY="$1"
ROLE="$2"
STATUS="${3:-Applied}"
NOTES="${4:--}"
DATE=$(date +%Y-%m-%d)

# Create applications.md with header if it doesn't exist
if [[ ! -f "$APPLICATIONS_FILE" ]]; then
    echo "Creating applications.md..."
    cat > "$APPLICATIONS_FILE" << 'EOF'
# Job Applications

| Company | Role | Date | Status | Notes |
|---------|------|------|--------|-------|
EOF
fi

# Append new entry
echo "| $COMPANY | $ROLE | $DATE | $STATUS | $NOTES |" >> "$APPLICATIONS_FILE"

echo "=== Application Tracked ==="
echo "Company: $COMPANY"
echo "Role: $ROLE"
echo "Date: $DATE"
echo "Status: $STATUS"
echo "Notes: $NOTES"
echo ""
echo "Updated: $APPLICATIONS_FILE"

# Show last 5 entries
echo ""
echo "=== Recent Applications ==="
tail -6 "$APPLICATIONS_FILE"
