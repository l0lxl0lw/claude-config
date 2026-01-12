#!/usr/bin/env python3
"""
MCP Server for fetching web content.

Provides two tools:
- fetch_url: Simple HTTP fetch with browser-like headers
- fetch_url_browser: Full browser rendering for JavaScript-heavy sites

Usage:
    python -m mcp_servers.web_fetch_server

Add to Claude Code settings (~/.claude/settings.json):
{
    "mcpServers": {
        "web-fetch": {
            "type": "stdio",
            "command": "python",
            "args": ["-m", "mcp_servers.web_fetch_server"],
            "cwd": "/Users/azulee/workspace/claude-config"
        }
    }
}
"""

import asyncio
import json
import sys
from typing import Any, Dict, List, Optional

import httpx

# Optional: playwright for JS-rendered pages
try:
    from playwright.async_api import async_playwright
    PLAYWRIGHT_AVAILABLE = True
except ImportError:
    PLAYWRIGHT_AVAILABLE = False


# MCP Protocol Implementation
class MCPServer:
    def __init__(self, name: str, version: str = "1.0.0"):
        self.name = name
        self.version = version
        self.tools = {}

    def tool(self, name: str, description: str, input_schema: dict, required: Optional[List[str]] = None):
        """Decorator to register a tool."""
        def decorator(func):
            self.tools[name] = {
                "name": name,
                "description": description,
                "inputSchema": {
                    "type": "object",
                    "properties": input_schema,
                    "required": required or []
                },
                "handler": func
            }
            return func
        return decorator

    async def handle_request(self, request: dict) -> dict:
        """Handle incoming MCP requests."""
        method = request.get("method", "")
        req_id = request.get("id")

        if method == "initialize":
            return {
                "jsonrpc": "2.0",
                "id": req_id,
                "result": {
                    "protocolVersion": "2024-11-05",
                    "capabilities": {"tools": {}},
                    "serverInfo": {"name": self.name, "version": self.version}
                }
            }

        elif method == "notifications/initialized":
            return None  # No response needed for notifications

        elif method == "tools/list":
            tools_list = [
                {
                    "name": t["name"],
                    "description": t["description"],
                    "inputSchema": t["inputSchema"]
                }
                for t in self.tools.values()
            ]
            return {
                "jsonrpc": "2.0",
                "id": req_id,
                "result": {"tools": tools_list}
            }

        elif method == "tools/call":
            tool_name = request.get("params", {}).get("name")
            arguments = request.get("params", {}).get("arguments", {})

            if tool_name not in self.tools:
                return {
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "error": {"code": -32601, "message": f"Tool not found: {tool_name}"}
                }

            try:
                handler = self.tools[tool_name]["handler"]
                result = await handler(arguments)
                return {
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "result": {"content": [{"type": "text", "text": result}]}
                }
            except Exception as e:
                return {
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "result": {"content": [{"type": "text", "text": f"Error: {str(e)}"}], "isError": True}
                }

        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "error": {"code": -32601, "message": f"Unknown method: {method}"}
        }

    async def run_stdio(self):
        """Run the server using stdio transport."""
        reader = asyncio.StreamReader()
        protocol = asyncio.StreamReaderProtocol(reader)
        await asyncio.get_event_loop().connect_read_pipe(lambda: protocol, sys.stdin)

        writer_transport, writer_protocol = await asyncio.get_event_loop().connect_write_pipe(
            asyncio.streams.FlowControlMixin, sys.stdout
        )
        writer = asyncio.StreamWriter(writer_transport, writer_protocol, None, asyncio.get_event_loop())

        while True:
            try:
                line = await reader.readline()
                if not line:
                    break

                request = json.loads(line.decode().strip())
                response = await self.handle_request(request)

                if response:
                    writer.write((json.dumps(response) + "\n").encode())
                    await writer.drain()

            except json.JSONDecodeError:
                continue
            except Exception as e:
                sys.stderr.write(f"Error: {e}\n")
                sys.stderr.flush()


# Create server instance
server = MCPServer("web-fetch", "1.0.0")


# Default headers to mimic a browser
DEFAULT_HEADERS = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.9",
    "Accept-Encoding": "gzip, deflate, br",
    "Connection": "keep-alive",
    "Upgrade-Insecure-Requests": "1",
}


@server.tool(
    "fetch_url",
    "Fetch content from a URL using HTTP. Good for most websites. Returns raw HTML.",
    {
        "url": {"type": "string", "description": "The URL to fetch"},
        "extract_text": {"type": "boolean", "description": "If true, extract visible text only (no HTML tags). Default: false"}
    },
    required=["url"]
)
async def fetch_url(args: Dict[str, Any]) -> str:
    """Fetch URL content with browser-like headers."""
    url = args["url"]
    extract_text = args.get("extract_text", False)

    async with httpx.AsyncClient(
        follow_redirects=True,
        timeout=30.0,
        headers=DEFAULT_HEADERS
    ) as client:
        response = await client.get(url)
        response.raise_for_status()
        content = response.text

    if extract_text:
        content = extract_visible_text(content)

    # Truncate if too long
    if len(content) > 100000:
        content = content[:100000] + "\n\n[Content truncated...]"

    return f"Status: {response.status_code}\nURL: {str(response.url)}\n\n{content}"


@server.tool(
    "fetch_url_browser",
    "Fetch content using a headless browser. Use for JavaScript-heavy sites (Social Blade, etc). Slower but renders JS.",
    {
        "url": {"type": "string", "description": "The URL to fetch"},
        "wait_for": {"type": "string", "description": "CSS selector to wait for before capturing content. Optional."},
        "extract_text": {"type": "boolean", "description": "If true, extract visible text only. Default: true"}
    },
    required=["url"]
)
async def fetch_url_browser(args: Dict[str, Any]) -> str:
    """Fetch URL using headless browser for JS rendering."""
    if not PLAYWRIGHT_AVAILABLE:
        return "Error: playwright is not installed. Run: pip install playwright && playwright install chromium"

    url = args["url"]
    wait_for = args.get("wait_for")
    extract_text = args.get("extract_text", True)

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            user_agent=DEFAULT_HEADERS["User-Agent"],
            viewport={"width": 1920, "height": 1080}
        )
        page = await context.new_page()

        try:
            await page.goto(url, wait_until="domcontentloaded", timeout=30000)

            # Wait for JS to render content
            await asyncio.sleep(3)

            if wait_for:
                await page.wait_for_selector(wait_for, timeout=10000)

            if extract_text:
                # Extract visible text content
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

            final_url = page.url

        finally:
            await browser.close()

    # Truncate if too long
    if len(content) > 100000:
        content = content[:100000] + "\n\n[Content truncated...]"

    return f"URL: {final_url}\n\n{content}"


def extract_visible_text(html: str) -> str:
    """Extract visible text from HTML (basic implementation)."""
    import re

    # Remove script and style elements
    text = re.sub(r'<script[^>]*>.*?</script>', '', html, flags=re.DOTALL | re.IGNORECASE)
    text = re.sub(r'<style[^>]*>.*?</style>', '', text, flags=re.DOTALL | re.IGNORECASE)

    # Remove HTML tags
    text = re.sub(r'<[^>]+>', ' ', text)

    # Decode HTML entities
    text = text.replace('&nbsp;', ' ').replace('&amp;', '&').replace('&lt;', '<').replace('&gt;', '>')
    text = text.replace('&quot;', '"').replace('&#39;', "'")

    # Clean up whitespace
    text = re.sub(r'\s+', ' ', text)
    text = '\n'.join(line.strip() for line in text.split('\n') if line.strip())

    return text.strip()


if __name__ == "__main__":
    asyncio.run(server.run_stdio())
