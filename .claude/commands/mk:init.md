# /mk:init - Initialize Project Memory Structure

Sets up Serena MCP-based memory structure for a new project.

## Execution Steps

### Step 1: Gather Project Information

Ask the user for the following:

```
AskUserQuestion:
- Project name
- Project goal (one line)
- Tech stack
- Current status (starting/in-progress/maintenance)
```

### Step 2: Create CLAUDE.md

Based on `~/.claude/templates/project-memory-init/CLAUDE.md.template`:

1. Create `CLAUDE.md` in current project root
2. Replace `{{PLACEHOLDER}}` with collected information
3. Set up basic structure

### Step 3: Register Serena Project

```
mcp__serena__activate_project("current_project_path")
```

Skip if project is already registered.

### Step 4: Create Initial Memory

Create `project-init` memory to record project start:

```
mcp__serena__write_memory(
  "project-init",
  "# Project Initialization\n\n## Date\n{{today}}\n\n## Configuration\n- Name: {{name}}\n- Goal: {{goal}}\n- Stack: {{stack}}"
)
```

### Step 5: Completion Checklist

```
- [x] CLAUDE.md created
- [x] Serena project registered
- [x] Initial memory created
```

---

## Generated Structure

```
project/
├── CLAUDE.md              # Auto-loaded entry point
└── (Serena memories)      # Saved in .serena/memories/
    └── project-init.md    # Initialization record
```

---

## Memory Naming Convention

| Prefix | Purpose |
|--------|---------|
| `decision-` | Design decisions |
| `feature-` | Implemented features |
| `bugfix-` | Bug fixes |
| `discussion-` | Key discussions |
| `learning-` | Discoveries/learnings |

---

## Example Execution

```
User: /mk:init

Claude: Initializing project memory.

[AskUserQuestion]
- Project name?
- Goal?
- Tech stack?

User: (answers)

Claude:
1. CLAUDE.md created
2. Serena project registered
3. project-init memory created

From now on, I'll suggest saving when important
decisions or implementations are completed.
```
