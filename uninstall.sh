#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CLAUDE_DIR="$HOME/.claude"

echo -e "${BLUE}"
echo "╔══════════════════════════════════════╗"
echo "║       memex-kit uninstaller          ║"
echo "╚══════════════════════════════════════╝"
echo -e "${NC}"

# Check if memex-kit is installed
if ! grep -q "memex-kit" "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null; then
    echo -e "${YELLOW}memex-kit is not installed.${NC}"
    exit 0
fi

echo -e "${YELLOW}This will remove:${NC}"
echo "  - /init-memory command"
echo "  - /save-context command"
echo "  - /update-index command"
echo "  - /list-memories command"
echo "  - memex-kit section from CLAUDE.md"
echo "  - templates/project-init/"
echo ""
echo -e "${YELLOW}Note: Project-level memories (Serena) will NOT be deleted.${NC}"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Uninstall cancelled.${NC}"
    exit 0
fi

echo ""

# Remove commands
echo -e "${BLUE}Removing commands...${NC}"
COMMANDS=("init-memory.md" "save-context.md" "update-index.md" "list-memories.md")
for cmd in "${COMMANDS[@]}"; do
    if [ -f "$CLAUDE_DIR/commands/$cmd" ]; then
        rm "$CLAUDE_DIR/commands/$cmd"
        echo -e "  ${RED}Removed${NC}: $cmd"
    fi
done

# Remove templates
echo -e "${BLUE}Removing templates...${NC}"
if [ -d "$CLAUDE_DIR/templates/project-init" ]; then
    rm -rf "$CLAUDE_DIR/templates/project-init"
    echo -e "  ${RED}Removed${NC}: templates/project-init/"
fi

# Remove memex-kit section from CLAUDE.md
echo -e "${BLUE}Cleaning CLAUDE.md...${NC}"
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    # Check for backup
    LATEST_BACKUP=$(ls -t "$CLAUDE_DIR"/CLAUDE.md.backup.* 2>/dev/null | head -1)

    if [ -n "$LATEST_BACKUP" ]; then
        echo -e "  ${YELLOW}Backup found:${NC} $(basename "$LATEST_BACKUP")"
        read -p "  Restore from backup? (y/N) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp "$LATEST_BACKUP" "$CLAUDE_DIR/CLAUDE.md"
            echo -e "  ${GREEN}Restored from backup${NC}"
        else
            # Just remove memex-kit section
            sed -i '' '/# --- memex-kit configuration ---/,$d' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null || \
            sed -i '/# --- memex-kit configuration ---/,$d' "$CLAUDE_DIR/CLAUDE.md"
            echo -e "  ${GREEN}Removed memex-kit section${NC}"
        fi
    else
        # No backup, just remove the section
        sed -i '' '/# --- memex-kit configuration ---/,$d' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null || \
        sed -i '/# --- memex-kit configuration ---/,$d' "$CLAUDE_DIR/CLAUDE.md"
        echo -e "  ${GREEN}Removed memex-kit section${NC}"
    fi
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      Uninstall complete!             ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Note:${NC} Serena project memories were preserved."
echo "  To delete them: mcp__serena__delete_memory(\"memory_name\")"
echo ""
