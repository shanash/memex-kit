# memex-kit

> Memory indexing system for Claude Code
> Session-to-session context persistence with Serena MCP

**Memex** (1945, Vannevar Bush) - A modern implementation of the "Memory Extender"

[🇰🇷 한국어](README.ko.md)

⚠️ **Important: memex-kit is NOT a pip package!** It's a Claude Code configuration kit.

```bash
# Check installation (correct way)
ls ~/.claude/commands/ | grep -E "(save-context|update-index|archive)"

# pip show memex-kit ← Don't do this!
```

---

## Features

- **Auto-indexing**: Automatically organize memories by category
- **Save triggers**: Prompts to save after important decisions/work
- **Session continuity**: Maintain context across sessions
- **Simple commands**: `/mk:init`, `/mk:save`, `/mk:index`, `/mk:end`

---

## Why memex-kit?

Compared to using Serena MCP alone:

| Aspect | Plain Serena | memex-kit |
|--------|-------------|-----------|
| **Saving** | Manual (`write_memory`) | `/mk:save` + auto-prompt |
| **Structure** | Flat list | Categorized + indexed |
| **Discovery** | Must remember names | Browse `_index` with summaries |
| **Session start** | Don't know what exists | Index shows everything |
| **Project init** | Manual setup | One `/mk:init` command |

### Key Benefits

1. **Discoverability**
   - Serena: "What did I name that memory?"
   - memex-kit: `_index` shows all memories with summaries and dates

2. **Save Habits**
   - Serena: Must explicitly request to save
   - memex-kit: Claude prompts "Should I save this?" after important work

3. **Context Continuity**
   - Serena: Unsure what to load each session
   - memex-kit: Index → quickly load relevant memories

### Why Prefixes Instead of Folders?

Serena supports folder structures, but `list_memories()` API **only scans root level**:

```
.serena/memories/
├── decision-auth.md      ← Visible to list_memories() ✓
├── feature-login.md      ← Visible to list_memories() ✓
├── decisions/
│   └── auth.md           ← Not visible ✗
└── features/
    └── login.md          ← Not visible ✗
```

Folder-based organization breaks automatic `_index` generation.
memex-kit uses prefix naming to keep all memories at root level for **complete auto-indexing**.

> **In short:** Serena is storage, memex-kit is an **organized knowledge management system**

---

## Requirements

- [Claude Code](https://claude.ai/code) CLI
- [Serena MCP](https://github.com/oraios/serena) (for memory storage)

### Installing Serena MCP

```bash
# Using uv (recommended)
claude mcp add serena -- uvx serena

# Or using pip
pip install serena
claude mcp add serena -- serena
```

---

## Installation

### Method 1: Auto Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/shanash/memex-kit/main/install.sh | bash
```

### Method 2: Manual Install

```bash
git clone https://github.com/shanash/memex-kit.git
cd memex-kit
./install.sh
```

### Method 3: Direct Copy

```bash
git clone https://github.com/shanash/memex-kit.git
cp -r memex-kit/.claude/* ~/.claude/
```

---

## Usage

### 1. Initialize Project

In a new project:

```
/mk:init
```

→ Interactive project info input
→ Creates CLAUDE.md
→ Registers with Serena
→ Creates initial `_index` memory

### 2. Save Context

After important decisions/implementations/discussions:

```
/mk:save                     # Interactive
/mk:save decision auth-jwt   # Specify type+title directly
```

### 3. Update Index

Regenerate full memory index:

```
/mk:index
```

### 4. List Memories

```
/mk:list
```

### 5. Archive Old Memories

When memories accumulate, archive old ones:

```
/mk:archive                    # Interactive
/mk:archive --before 2025-06   # Before specific date
/mk:archive --type bugfix      # All of specific type
```

### 6. End Session

When ending a work session:

```
/mk:end
```

→ Saves session summary (`session-last`)
→ Records next actions (`session-next`)
→ Updates project context (`session-context`)
→ Updates `_index`

---

## Memory Naming Convention

| Prefix | Purpose | Example |
|--------|---------|---------|
| `decision-` | Design/architecture decisions | `decision-auth-jwt` |
| `feature-` | Feature implementation records | `feature-login-system` |
| `bugfix-` | Bug fix history | `bugfix-2025-01-01-null` |
| `discussion-` | Important discussions | `discussion-api-design` |
| `learning-` | Discoveries/learnings | `learning-react-hydration` |
| `session-` | Session state (auto) | `session-last`, `session-next` |

---

## Index Structure

The `_index` memory is structured as follows:

```markdown
# Project Memory Index

> **Last Updated**: 2025-01-01
> **Total Memories**: 15

## Quick Navigation

### Design Decisions (decision-) [3]
| Memory Name | Date | Summary |
|-------------|------|---------|
| decision-auth-jwt | 2025-01-01 | Chose JWT authentication |
...

## Recently Added (Last 5)
1. [2025-01-01] feature-dashboard - Dashboard implementation
...
```

---

## Auto-Save Triggers

After installing memex-kit, Claude will prompt to save in these situations:

- Design/architecture decision completed
- Feature implementation completed
- Bug fix completed
- Important discussion ended
- New discovery/learning

---

## File Structure

```
~/.claude/
├── CLAUDE.md                    # Global settings (memex-kit rules)
└── commands/
    ├── mk:init.md           # Project initialization
    ├── mk:save.md          # Context saving
    ├── mk:index.md          # Index regeneration
    ├── mk:list.md         # Memory listing
    ├── mk:archive.md      # Memory archiving
    └── mk:end.md          # Session end
```

---

## Large Project Management

### Why Archive?

memex-kit stores all memories at root level (`list_memories()` API limitation).
With hundreds of memories:
- List queries slow down
- `_index` becomes too long
- Hard to find relevant memories

**Solution**: Move old memories to `archive/` folder
- Excluded from `list_memories()` → manage only active memories
- Can manually access archive when needed

### Recommended Strategy

| Memory Count | Strategy |
|-------------|----------|
| ~50 | Prefixes are enough |
| ~200 | Rely on `_index`, occasional archive |
| 500+ | Regular archiving required |

**Archive Structure:**

```
.serena/memories/
├── _index.md              ← Only active memories indexed
├── decision-*.md          ← Active (always keep)
├── feature-*.md           ← Active
├── bugfix-*.md            ← Archive when old
└── archive/               ← Excluded from list_memories()
    ├── 2024/
    │   └── bugfix-old.md
    └── 2025-Q1/
```

**Recommended for Archive:**
- `bugfix-*` older than 3 months
- Completed `discussion-*`
- Old `learning-*`

**Keep Active:**
- `decision-*` (project lifetime)
- Recent `feature-*`

---

## Compatibility

- If `~/.claude/CLAUDE.md` exists, backs up then appends
- Existing commands preserved, only adds new ones
- On conflict, existing files take priority (no overwrite)

---

## Uninstall

```bash
# Method 1: Remote execution
curl -fsSL https://raw.githubusercontent.com/shanash/memex-kit/main/uninstall.sh | bash

# Method 2: Local execution
git clone https://github.com/shanash/memex-kit.git
cd memex-kit
./uninstall.sh
```

On uninstall:
- Removes memex-kit commands (`/mk:init`, `/mk:save`, etc.)
- Removes memex-kit config from CLAUDE.md
- Offers backup restoration if available
- **Serena memories are preserved** (project data kept)

---

## License

MIT License

---

## Credits

- **Memex concept**: Vannevar Bush, "As We May Think" (1945)
- **Serena MCP**: [oraios/serena](https://github.com/oraios/serena)
- **Inspiration**: [centminmod/my-claude-code-setup](https://github.com/centminmod/my-claude-code-setup)
