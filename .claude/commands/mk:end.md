# /mk:end - End Session

> Saves context at session end and prepares for next session.

## Usage

```
User: "end session" or "/mk:end"
```

---

## Automatic Procedure

### Step 1: Summarize This Session

```python
mcp__serena__write_memory("session-last", content)
```

Content:
- List of completed tasks
- Modified files
- Resolved issues / discovered issues
- Date

Format:
```markdown
# Session Summary

> **Date**: YYYY-MM-DD

## Completed Tasks
- Task 1
- Task 2

## Modified Files
- path/to/file1
- path/to/file2

## Resolved Issues
- Issue 1

## Discovered Issues
- Issue 1 (unresolved)
```

### Step 2: Organize Next Tasks

```python
mcp__serena__write_memory("session-next", content)
```

Content:
- Next tasks by priority
- Incomplete items
- Notes

Format:
```markdown
# Next Tasks

> **Updated**: YYYY-MM-DD

## High Priority
- [ ] Task 1
- [ ] Task 2

## Normal Priority
- [ ] Task 3

## Notes
- Important points
```

### Step 3: Update Context

```python
mcp__serena__write_memory("session-context", content)
```

Content:
- Current project status
- In-progress features
- Latest date

Format:
```markdown
# Project Context

> **Last Updated**: YYYY-MM-DD

## Current Status
Project status summary

## In Progress
- Feature/task 1
- Feature/task 2

## Recently Completed
- Completed task 1
- Completed task 2
```

### Step 4: Update Index

```python
# Update index to include session-* memories
# Update existing session-* entries
```

### Step 5: Display Exit Message

```
✅ Session end prepared

Saved memories:
- session-last: This session summary
- session-next: Next tasks
- session-context: Project status

_index updated

→ Use /exit or Ctrl+C to end session.
→ Next session will read session-context to restore context.
```

---

## Next Session Start

Claude will automatically:
1. Read `_index` to understand all memories
2. Read `session-context` to restore current status
3. Read `session-next` to check next tasks

---

## Options

```
/mk:end              # Full procedure
/mk:end --quick      # Save session-last only (quick exit)
/mk:end --dry-run    # Preview without saving
```

---

## Notes

- Actual exit is done by user with `/exit` or `Ctrl+C`
- session-* memories should not be archived (always keep active)
