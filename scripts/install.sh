#!/usr/bin/env bash
set -e

echo "Installing MCP configuration..."

# Detect OS and set VS Code config path
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    VSCODE_CONFIG="$HOME/Library/Application Support/Code/User/mcp.json"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    VSCODE_CONFIG="$HOME/.config/Code/User/mcp.json"
else
    echo "Unsupported OS: $OSTYPE"
    echo "Please use install.ps1 for Windows"
    exit 1
fi

# Check if VS Code is installed
if [ ! -d "$(dirname "$VSCODE_CONFIG")" ]; then
    echo "VS Code user directory not found at: $(dirname "$VSCODE_CONFIG")"
    echo "Make sure VS Code is installed and has been run at least once"
    exit 1
fi

# Create directory if needed
mkdir -p "$(dirname "$VSCODE_CONFIG")"

# Backup existing config if present
if [ -f "$VSCODE_CONFIG" ]; then
    BACKUP="$VSCODE_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$VSCODE_CONFIG" "$BACKUP"
    echo "Backed up existing config to: $BACKUP"
fi

# Clone semantic-scholar server (requires local clone due to multi-file package structure)
SEMS_DIR="$HOME/.bio-mcp-servers/semantic-scholar"
if [ -d "$SEMS_DIR" ]; then
    echo "Updating semantic-scholar server..."
    git -C "$SEMS_DIR" pull
else
    echo "Cloning semantic-scholar server..."
    mkdir -p "$HOME/.bio-mcp-servers"
    git clone https://github.com/zongmin-yu/semantic-scholar-fastmcp-mcp-server.git "$SEMS_DIR"
fi

# Clone/build medical-mcp locally to avoid broken npx bin shim on Unix
MEDICAL_DIR="$HOME/.bio-mcp-servers/medical-mcp"
if [ -d "$MEDICAL_DIR" ]; then
    echo "Updating medical-mcp server..."
    git -C "$MEDICAL_DIR" pull
else
    echo "Cloning medical-mcp server..."
    mkdir -p "$HOME/.bio-mcp-servers"
    git clone https://github.com/jamesanz/medical-mcp.git "$MEDICAL_DIR"
fi

echo "Installing/building medical-mcp..."
(
    cd "$MEDICAL_DIR"
    npm install --no-audit --no-fund
    npm run build
)

# Copy config
cp mcp.vscode.json "$VSCODE_CONFIG"

echo "Config installed to: $VSCODE_CONFIG"
echo ""
echo "Next steps:"
echo "1. Restart VS Code (or run 'Developer: Reload Window')"
echo "2. Open Command Palette (Cmd+Shift+P / Ctrl+Shift+P)"
echo "3. Run: 'MCP: Open User Configuration' and confirm it opens: $VSCODE_CONFIG"
echo "4. Run: 'MCP: List Servers'"
echo "5. You should see server names such as 'biothings-mcp' and 'biomcp'"
echo ""
echo "Note: 'bio-mcp-config' is a config repo, not an MCP server name."
echo "On first use, VS Code will prompt for API keys."
echo "You can leave them blank for lower rate limits."
