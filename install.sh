#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}"
echo "╔══════════════════════════════════════╗"
echo "║         memex-kit installer          ║"
echo "║   Memory Indexing for Claude Code    ║"
echo "╚══════════════════════════════════════╝"
echo -e "${NC}"

# Check if running from cloned repo or curl
if [ -f "$SCRIPT_DIR/.claude/CLAUDE.md" ]; then
    SOURCE_DIR="$SCRIPT_DIR"
    echo -e "${GREEN}Installing from local directory...${NC}"
else
    # Download from GitHub
    echo -e "${YELLOW}Downloading memex-kit...${NC}"
    TMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/shanash/memex-kit.git "$TMP_DIR" 2>/dev/null || {
        echo -e "${RED}Error: Failed to clone repository${NC}"
        exit 1
    }
    SOURCE_DIR="$TMP_DIR"
fi

# Create ~/.claude if not exists
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/templates"

# Backup existing CLAUDE.md
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo -e "${YELLOW}Backing up existing CLAUDE.md...${NC}"
    cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Install commands (don't overwrite existing)
echo -e "${BLUE}Installing commands...${NC}"
for cmd in "$SOURCE_DIR/.claude/commands/"*.md; do
    if [ -f "$cmd" ]; then
        filename=$(basename "$cmd")
        if [ -f "$CLAUDE_DIR/commands/$filename" ]; then
            echo -e "  ${YELLOW}Skip${NC}: $filename (already exists)"
        else
            cp "$cmd" "$CLAUDE_DIR/commands/"
            echo -e "  ${GREEN}Added${NC}: $filename"
        fi
    fi
done

# Install templates
echo -e "${BLUE}Installing templates...${NC}"
if [ -d "$SOURCE_DIR/templates" ]; then
    cp -r "$SOURCE_DIR/templates/"* "$CLAUDE_DIR/templates/" 2>/dev/null || true
    echo -e "  ${GREEN}Templates installed${NC}"
fi

# Merge or create CLAUDE.md
echo -e "${BLUE}Configuring CLAUDE.md...${NC}"
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    # Check if memex-kit section already exists
    if grep -q "memex-kit" "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null; then
        echo -e "  ${YELLOW}memex-kit section already exists${NC}"
    else
        echo -e "\n\n# --- memex-kit configuration ---\n" >> "$CLAUDE_DIR/CLAUDE.md"
        cat "$SOURCE_DIR/.claude/CLAUDE.md" >> "$CLAUDE_DIR/CLAUDE.md"
        echo -e "  ${GREEN}Configuration appended${NC}"
    fi
else
    cp "$SOURCE_DIR/.claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    echo -e "  ${GREEN}CLAUDE.md created${NC}"
fi

# Cleanup temp directory if used
if [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║       Installation complete!         ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Available commands:${NC}"
echo "  /init-memory    - Initialize project memory structure"
echo "  /save-context   - Save current context to memory"
echo "  /update-index   - Regenerate memory index"
echo "  /list-memories  - List all memories"
echo ""
echo -e "${YELLOW}Note:${NC} Serena MCP is required for memory storage."
echo "  Install: claude mcp add serena -- uvx serena"
echo ""
echo -e "${BLUE}Get started:${NC}"
echo "  1. Start Claude Code in your project"
echo "  2. Run /init-memory to set up project memory"
echo ""
