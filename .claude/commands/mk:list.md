# /mk:list - List Project Memories

Shows the list of Serena memories for the current project.

## Execution Steps

### Step 1: Check Project

Verify Serena project is active:

```python
mcp__serena__get_current_config()
```

Guide user if not active.

### Step 2: Get Memory List

```python
mcp__serena__list_memories()
```

### Step 3: Organize by Category

Classify and display memories by prefix:

```
## Project Memory List

### Design Decisions (decision-)
- decision-auth-jwt
- decision-db-postgresql

### Features (feature-)
- feature-login-system
- feature-user-profile

### Bug Fixes (bugfix-)
- bugfix-2025-01-01-null-check

### Discussions (discussion-)
- discussion-api-structure

### Learnings (learning-)
- learning-react-hydration

### Other
- project-init
```

---

## Options

```
/mk:list           # Full list
/mk:list decision  # Specific type only
/mk:list --recent  # Last 5 only
```

---

## Reading Memories

To read a specific memory from the list:

```
mcp__serena__read_memory("memory-name")
```

Or provide interactive selection by number.
