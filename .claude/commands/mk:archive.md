# /mk:archive - Archive Old Memories

Moves old memories to archive when active memories accumulate.

---

## Why Archive?

- `list_memories()` only scans root level
- Hundreds of memories become difficult to manage
- Move old memories to archive → only index active memories

---

## Execution Steps

### Step 1: Check Current Memories

```python
memories = mcp__serena__list_memories()
```

### Step 2: Select Archive Targets

Present criteria to user:

```
Select archive criteria:

1. By date (e.g., older than 3 months)
2. By type (e.g., all bugfix-*)
3. Manual selection (pick from list)
```

### Step 3: Create Archive Folder

```python
# Archive folder structure: archive/YYYY/ or archive/YYYY-QN/
archive_path = f"archive/{year}"
```

### Step 4: Move Memories

For each selected memory:

```python
# 1. Read memory content
content = mcp__serena__read_memory(memory_name)

# 2. Create file in archive location
mcp__serena__create_text_file(
    relative_path=f".serena/memories/archive/{year}/{memory_name}.md",
    content=content
)

# 3. Delete original memory
mcp__serena__delete_memory(memory_name)
```

### Step 5: Update Index

```python
# Run /mk:index to index only active memories
```

### Step 6: Report Results

```
Archive complete!

Moved memories: 45
- bugfix-*: 30
- discussion-*: 15

Current active memories: 52
Archive location: .serena/memories/archive/2025/

Index has been updated.
```

---

## Options

```
/mk:archive                    # Interactive (select criteria)
/mk:archive --before 2025-06   # Before specific date
/mk:archive --type bugfix      # All of specific type
/mk:archive --dry-run          # Preview only (no actual move)
```

---

## Accessing Archived Memories

Archived memories don't appear in `list_memories()`, but can be accessed directly:

```python
# List archive contents
mcp__serena__list_dir(".serena/memories/archive", recursive=True)

# Read specific archived memory
mcp__serena__read_file(".serena/memories/archive/2025/bugfix-old-issue.md")
```

---

## Restoring from Archive

To restore from archive to active:

```python
# 1. Read archive file
content = mcp__serena__read_file(".serena/memories/archive/2025/memory-name.md")

# 2. Save as active memory
mcp__serena__write_memory("memory-name", content)

# 3. Delete archive file (optional)
# 4. Run /mk:index
```

---

## Recommended Archive Schedule

| Project Size | Recommended Schedule | Keep Active |
|--------------|---------------------|-------------|
| Small | As needed | All |
| Medium | Quarterly | Last 3 months |
| Large | Monthly | Last 1 month |

---

## Notes

- Archived memories are excluded from `_index`
- Don't archive frequently referenced memories
- Keep `decision-*` type active for project lifetime
