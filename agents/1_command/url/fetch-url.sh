#!/bin/bash
# fetch-url.sh - Fetch URL content using headless browser
# Usage: ./fetch-url.sh <url> [--raw]
#   --raw: Return HTML instead of extracted text

URL="$1"
RAW_MODE="$2"

if [ -z "$URL" ]; then
    echo "Usage: fetch-url.sh <url> [--raw]"
    echo "  --raw: Return HTML instead of extracted text"
    exit 1
fi

if [ "$RAW_MODE" == "--raw" ]; then
    EXTRACT_TEXT="False"
else
    EXTRACT_TEXT="True"
fi

/usr/bin/python3 - "$URL" "$EXTRACT_TEXT" << 'PYEOF'
import asyncio
import sys
from playwright.async_api import async_playwright

async def fetch(url, extract_text):
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            viewport={"width": 1920, "height": 1080}
        )
        page = await context.new_page()

        try:
            await page.goto(url, wait_until="domcontentloaded", timeout=30000)
            await asyncio.sleep(3)

            if extract_text:
                content = await page.evaluate("""
                    () => {
                        const walker = document.createTreeWalker(
                            document.body,
                            NodeFilter.SHOW_TEXT,
                            null,
                            false
                        );
                        let text = '';
                        let node;
                        while (node = walker.nextNode()) {
                            const parent = node.parentElement;
                            if (parent && !['SCRIPT', 'STYLE', 'NOSCRIPT'].includes(parent.tagName)) {
                                const trimmed = node.textContent.trim();
                                if (trimmed) text += trimmed + '\\n';
                            }
                        }
                        return text;
                    }
                """)
            else:
                content = await page.content()

            print(content)
        finally:
            await browser.close()

if __name__ == "__main__":
    url = sys.argv[1]
    extract_text = sys.argv[2] == "True"
    asyncio.run(fetch(url, extract_text))
PYEOF
