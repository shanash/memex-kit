# memex-kit Configuration

> Serena MCP-based memory indexing system
> https://github.com/shanash/memex-kit

## What is memex-kit?

**memex-kit is NOT a pip package - it's a Claude Code configuration kit.**

A Serena MCP-based memory indexing system installed in the `~/.claude/` folder.

### How to Check Installation

```bash
# Correct way
ls ~/.claude/commands/ | grep -E "(save-context|update-index|archive)"

# Wrong way (not a pip package!)
# pip show memex-kit  ← Don't do this
```

### Installation Location

```
~/.claude/
├── CLAUDE.md                    ← This file
└── commands/
    ├── mk:init.md
    ├── mk:save.md
    ├── mk:index.md
    ├── mk:list.md
    ├── mk:archive.md
    └── mk:end.md
```

---

## Serena MCP Memory System

### Auto-Save Triggers

**Always** suggest saving to the user in these situations:

| Situation | Suggested Message | Memory Prefix |
|-----------|------------------|---------------|
| Design/architecture decision completed | "Should I save this decision?" | `decision-` |
| Feature implementation completed | "Should I record this implementation?" | `feature-` |
| Bug fix completed | "Should I record this fix?" | `bugfix-` |
| Important discussion ended | "Should I save this discussion?" | `discussion-` |
| New discovery/learning | "Should I record this?" | `learning-` |

### Save Format

Use this format when saving memories:

```markdown
# {{title}}

## Date
YYYY-MM-DD

## Context
Why this decision/work was done

## Content
Specific details

## Impact
Impact of this decision/work

## Related Files
- file paths
```

### On Session Start

When Serena project is activated:
1. Check existing memories with `list_memories()`
2. If `_index` memory exists, read it first to understand overall structure
3. Automatically reference related memories if relevant to current work

---

## Commands

| Command | Purpose |
|---------|---------|
| `/mk:init` | Initialize new project memory structure |
| `/mk:save` | Save current discussion/decision + update index |
| `/mk:list` | List project memories |
| `/mk:index` | Regenerate full memory index |
| `/mk:archive` | Archive old memories |
| `/mk:end` | End session |

---

## Auto Index Update System

### `_index` Memory

Every project should have an `_index` memory.
This memory is an index organizing all memories by category.

### Auto Update Rules

**Always** update `_index` after saving a memory:

```
1. Save new memory (write_memory)
2. Read existing _index (read_memory("_index"))
3. Add new entry to appropriate category table
4. Update total count
5. Update recent additions list (keep last 5)
6. Save _index (write_memory("_index", updated_content))
```

### Index Format

```markdown
# Project Memory Index

> **Last Updated**: YYYY-MM-DD
> **Total Memories**: N

## Quick Navigation

### Design Decisions (decision-) [N]
| Memory Name | Date | Summary |
|-------------|------|---------|
| decision-xxx | 2025-01-01 | One-line summary |

### Feature Implementations (feature-) [N]
...

## Recently Added (Last 5)
1. [date] memory-name - summary
```

### When Index Doesn't Exist

If `_index` memory doesn't exist, run `/mk:index` to create it.

---

## Archive System

### When Archive is Needed

Suggest archiving when memories exceed 200:
- "You have a lot of memories. Should I archive old ones?"

### Archive Criteria (Recommended)

| Type | Archive Criteria |
|------|-----------------|
| `bugfix-` | Older than 3 months |
| `discussion-` | Completed discussions |
| `learning-` | Older than 6 months |
| `decision-` | **Never archive** (always keep) |
| `feature-` | 6 months after release |

### Archive Location

```
.serena/memories/archive/{YYYY}/ or
.serena/memories/archive/{YYYY-Q#}/
```

**Note**: Archived memories are excluded from `list_memories()` and `_index`.

---

## Work Rules

### When to Suggest Saving

- **Immediately**: When explicit decision is made
- **After completion**: Feature implementation, bug fix completion
- **On request**: When user says "record", "save", etc.

### When NOT to Save

- Simple Q&A
- Exploratory conversation (no decision yet)
- When user declines to save

---

## Project-Specific Settings Priority

```
1. project/CLAUDE.md (highest priority)
2. ~/.claude/CLAUDE.md (this file, fallback)
```

If project has its own CLAUDE.md, those rules take priority.
