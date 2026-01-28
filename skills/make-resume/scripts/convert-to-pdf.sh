#!/bin/bash
# Convert resume and cover letter markdown files to PDF using pandoc + weasyprint
# Usage: convert-to-pdf.sh <company-folder-path>

set -e

RESUME_BASE="/Users/azulee/workspace/private/resume"
CSS_FILE="$RESUME_BASE/resume.css"

if [[ -z "$1" ]]; then
    echo "Usage: $0 <company-folder-path>"
    echo "Example: $0 /Users/azulee/workspace/private/resume/tailored/acme-corp"
    exit 1
fi

COMPANY_DIR="$1"

if [[ ! -d "$COMPANY_DIR" ]]; then
    echo "ERROR: Directory not found: $COMPANY_DIR"
    exit 1
fi

if [[ ! -f "$CSS_FILE" ]]; then
    echo "WARNING: CSS file not found: $CSS_FILE"
    echo "PDFs will be generated without custom styling"
    CSS_FLAG=""
else
    CSS_FLAG="--css=$CSS_FILE"
fi

cd "$COMPANY_DIR"

# Convert resume if exists
if [[ -f "resume.md" ]]; then
    echo "Converting resume.md to PDF..."
    pandoc resume.md -o resume.pdf --pdf-engine=weasyprint $CSS_FLAG
    echo "  Created: $COMPANY_DIR/resume.pdf"
else
    echo "SKIP: resume.md not found"
fi

# Convert cover letter if exists
if [[ -f "cover-letter.md" ]]; then
    echo "Converting cover-letter.md to PDF..."
    pandoc cover-letter.md -o cover-letter.pdf --pdf-engine=weasyprint $CSS_FLAG
    echo "  Created: $COMPANY_DIR/cover-letter.pdf"
else
    echo "SKIP: cover-letter.md not found"
fi

echo ""
echo "=== PDF Conversion Complete ==="
ls -la "$COMPANY_DIR"/*.pdf 2>/dev/null || echo "No PDF files generated"
