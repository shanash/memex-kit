# /mk:save - Save Current Context

Saves current discussion/decision/work content to Serena memory.

## Usage

```
/mk:save [type] [title]
```

### Types (optional)
- `decision` : Design decisions
- `feature` : Implemented features
- `bugfix` : Bug fixes
- `discussion` : Key discussions
- `learning` : Discoveries/learnings

If type is not specified, it will be auto-determined by analyzing the conversation.

---

## Execution Steps

### Step 1: Determine Type

If no arguments provided, analyze recent conversation and suggest appropriate type:

```
AskUserQuestion:
"Select the type of content to save"
- decision (Design decision)
- feature (Feature implementation)
- bugfix (Bug fix)
- discussion (Discussion)
- learning (Learning)
```

### Step 2: Determine Title

```
AskUserQuestion:
"Enter memory title (e.g., auth-jwt-decision)"
```

### Step 3: Summarize Content

Extract and summarize key content from recent conversation:

```markdown
# {{title}}

## Date
{{today's date}}

## Context
{{background extracted from conversation}}

## Content
{{key decision/implementation/fix details}}

## Impact
{{impact of this content}}

## Related Files
{{mentioned files}}
```

### Step 4: Save

```python
mcp__serena__write_memory(
  f"{type}-{title}",
  summarized_content
)
```

### Step 5: Update Index (Required!)

```python
# 1. Read existing index
index = mcp__serena__read_memory("_index")

# 2. Create new index if none exists
if not index:
    # Execute /mk:index logic to create full index
    pass

# 3. Add new entry to appropriate category table
#    e.g., Add row to decision- category table
#    | decision-auth-jwt | 2025-12-31 | Chose JWT auth |

# 4. Update total count
#    > **Total Memories**: N → N+1

# 5. Update recent additions list (newest first, max 5)
#    1. [2025-12-31] decision-auth-jwt - Chose JWT auth
#    2. [previous items...]

# 6. Save index
mcp__serena__write_memory("_index", updated_index)
```

### Step 6: Confirm

```
Saved: {type}-{title}
Index updated!

View content: mcp__serena__read_memory("{type}-{title}")
View index: mcp__serena__read_memory("_index")
```

---

## Example

```
User: /mk:save decision api-pagination

Claude:
Found API pagination decision in recent conversation.

Content to save:
- Chose cursor-based pagination
- Reason: Efficiency for large datasets
- Impact: /api/items endpoint

Save? [Yes/No]

User: Yes

Claude:
Saved: decision-api-pagination
```

---

## Quick Save

```
/mk:save          # Interactive
/mk:save decision # Type only
/mk:save decision auth-method  # Type+title
```
