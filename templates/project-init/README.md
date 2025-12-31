# Project Memory Initialization Templates

Templates for Serena MCP-based project memory structure.

## Usage

### Method 1: /mk:init Command (Recommended)
```
/mk:init
```
Interactively prompts for project information and auto-configures.

### Method 2: Manual Copy
1. Copy `CLAUDE.md.template` to project root
2. Replace `{{PLACEHOLDER}}` with actual values
3. Register project with Serena

## Included Files

| File | Purpose |
|------|---------|
| `CLAUDE.md.template` | Project entry point + save trigger logic |
| `README.md` | This guide |

## Serena Project Registration

After applying template, register the project with Serena:

```
mcp__serena__activate_project("/path/to/project")
```

## Memory Structure

This template uses the following memory naming convention:

- `decision-*` : Design decisions
- `feature-*` : Implemented features
- `bugfix-*` : Bug fixes
- `discussion-*` : Key discussions
- `learning-*` : Discoveries/learnings

## Save Triggers

Instructions in CLAUDE.md direct Claude to automatically:
1. Suggest saving when important decisions/work is completed
2. Save memories in consistent format
3. Reference related memories at session start
