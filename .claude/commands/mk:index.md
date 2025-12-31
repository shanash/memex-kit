# /mk:index - Update Memory Index

Scans all Serena memories in the project and creates/updates the `_index` memory.

---

## Execution Steps

### Step 1: Check Project

```python
# Verify Serena project is active
mcp__serena__get_current_config()
```

Guide user if not active.

### Step 2: Scan All Memories

```python
memories = mcp__serena__list_memories()
```

### Step 3: Categorize

Classify each memory by prefix:

```python
categories = {
    "decision": [],    # decision-*
    "feature": [],     # feature-*
    "bugfix": [],      # bugfix-*
    "discussion": [],  # discussion-*
    "learning": [],    # learning-*
    "other": []        # Others (excluding _index)
}

for memory in memories:
    if memory == "_index":
        continue  # Exclude index itself
    elif memory.startswith("decision-"):
        categories["decision"].append(memory)
    elif memory.startswith("feature-"):
        categories["feature"].append(memory)
    # ... etc
```

### Step 4: Extract Summary for Each Memory

Read each memory and extract first line or summary:

```python
for memory_name in all_memories:
    content = mcp__serena__read_memory(memory_name)
    # Use first # header or first line as summary
    summary = extract_first_header_or_line(content)
    # Try to extract date from memory name (bugfix-2025-01-01-xxx → 2025-01-01)
    date = extract_date(memory_name) or "N/A"
```

### Step 5: Generate Index

```markdown
# Project Memory Index

> **Last Updated**: 2025-12-31
> **Total Memories**: 25

---

## Quick Navigation

### Design Decisions (decision-) [7]
| Memory Name | Date | Summary |
|-------------|------|---------|
| decision-auth-jwt | 2025-01-01 | Chose JWT authentication |
| ... | ... | ... |

### Feature Implementations (feature-) [5]
...

### Recently Added (Last 5)
1. [2025-12-31] bugfix-xxx - Summary
2. [2025-12-30] feature-yyy - Summary
...
```

### Step 6: Save Index

```python
mcp__serena__write_memory("_index", index_content)
```

### Step 7: Report Results

```
Index updated!

Total memories: 25
- Design decisions: 7
- Features: 5
- Bug fixes: 8
- Discussions: 3
- Learnings: 2

View index: mcp__serena__read_memory("_index")
```

---

## Auto vs Manual Update

| Situation | Method |
|-----------|--------|
| After `/mk:save` | Auto (add single entry) |
| After memory deletion | Manual (`/mk:index`) |
| Full rebuild needed | Manual (`/mk:index`) |
| Session start | Auto check (update if changed) |

---

## Options

```
/mk:index           # Full scan and update
/mk:index --force   # Ignore cache, complete rebuild
/mk:index --dry-run # Preview only
```
