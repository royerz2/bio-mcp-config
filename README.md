# My MCP Configuration

Centralized config for all my bioinformatics MCP servers.

## Setup on a new machine

### Prerequisites
- [uv](https://docs.astral.sh/uv/getting-started/installation/) (Python MCP servers)
- Node.js 18+ (for medical-mcp)
- VS Code with GitHub Copilot

### Installation

**macOS/Linux:**
```bash
git clone <this-repo-url> ~/my-mcp-config
cd ~/my-mcp-config
chmod +x scripts/install.sh
./scripts/install.sh
```

**Windows (PowerShell):**
```powershell
git clone <this-repo-url> $env:USERPROFILE\my-mcp-config
cd $env:USERPROFILE\my-mcp-config
.\scripts\install.ps1
```

This will:
1. Copy `mcp.vscode.json` → VS Code user config location
2. Restart VS Code to pick up the new servers

### First run
VS Code will prompt for API keys when each server first starts. Leave blank if you don't have keys (most work without them, just with lower rate limits).

## Updating

```bash
git pull
./scripts/install.sh  # re-copy config
```

To upgrade server versions, edit the version pins in `mcp.vscode.json` and commit.

## Servers included

| Server | Purpose | Docs |
|--------|---------|------|
| biothings-mcp | BioThings APIs (genes, drugs) | [GitHub](https://github.com/longevity-genie/biothings-mcp) |
| biomcp | cBioPortal, NCI, AlphaGenome | [biomcp.org](https://biomcp.org) |
| alex-mcp | OpenAlex academic search | [GitHub](https://github.com/drAbreu/alex-mcp) |
| semantic-scholar-fastmcp | Semantic Scholar papers | [GitHub](https://github.com/zongmin-yu/semantic-scholar-fastmcp-mcp-server) |
| academic-search-mcp | Multi-source academic search | [GitHub](https://github.com/afrise/academic-search-mcp-server) |
| medical-mcp | PubMed, FDA, WHO, RxNorm | [GitHub](https://github.com/JamesANZ/medical-mcp) |

## Troubleshooting

### "No servers found"
Run `MCP: List Servers` in VS Code command palette. If empty, check that:
- The config file was copied to the correct location (check install script output)
- VS Code was restarted after installation
- GitHub Copilot extension is installed and enabled

### "Server failed to start"
Check VS Code Output panel → select the server from dropdown. Common issues:
- Missing `uv` or `node` in PATH
- Network issues downloading packages (first run only)
- Invalid API keys (most servers work without keys, just slower)

### "Module not found" errors
The first time each server starts, `uvx`/`npx` will download it. This can take 10-30 seconds. Check the Output panel for progress.

## Project structure

```
my-mcp-config/
├── README.md                    # This file
├── mcp.vscode.json             # VS Code MCP config (single source of truth)
├── .env.example                # Template for secrets
└── scripts/
    ├── install.sh              # macOS/Linux setup
    └── install.ps1             # Windows setup
```

## Why this approach

| Old way | This meta-repo way |
|---------|-------------------|
| Clone 6 repos individually | Clone 1 config repo |
| Hard-code 6 absolute paths in JSON | Zero paths, `uvx`/`npx` resolve everything |
| `npm install && npm run build` × 6 | No builds, registry packages auto-installed |
| Manual `git pull` in each repo to update | `git pull` meta-repo + restart VS Code |
| Per-machine JSON edits | Single versioned `mcp.vscode.json` |
| Secrets scattered | VS Code `${input:...}` prompts once per machine |
