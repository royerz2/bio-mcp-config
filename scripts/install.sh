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
