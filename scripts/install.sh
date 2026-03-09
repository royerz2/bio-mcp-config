#!/usr/bin/env bash
set -e

echo "🔧 Installing MCP configuration..."

# Detect OS and set VS Code config path
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    VSCODE_CONFIG="$HOME/Library/Application Support/Code/User/globalStorage/github.copilot-chat/mcp.json"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    VSCODE_CONFIG="$HOME/.config/Code/User/globalStorage/github.copilot-chat/mcp.json"
else
    echo "❌ Unsupported OS: $OSTYPE"
    echo "Please use install.ps1 for Windows"
    exit 1
fi

# Check if VS Code is installed
if [ ! -d "$(dirname "$(dirname "$(dirname "$VSCODE_CONFIG")")")" ]; then
    echo "⚠️  VS Code user directory not found at: $(dirname "$(dirname "$(dirname "$VSCODE_CONFIG")")")"
    echo "Make sure VS Code is installed and has been run at least once"
    exit 1
fi

# Create directory if needed
mkdir -p "$(dirname "$VSCODE_CONFIG")"

# Backup existing config if present
if [ -f "$VSCODE_CONFIG" ]; then
    BACKUP="$VSCODE_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$VSCODE_CONFIG" "$BACKUP"
    echo "📦 Backed up existing config to: $BACKUP"
fi

# Copy config
cp mcp.vscode.json "$VSCODE_CONFIG"

echo "✅ Config installed to: $VSCODE_CONFIG"
echo ""
echo "Next steps:"
echo "1. Restart VS Code"
echo "2. Open Command Palette (Cmd+Shift+P / Ctrl+Shift+P)"
echo "3. Run: 'MCP: List Servers'"
echo "4. You should see all 6 servers listed"
echo ""
echo "On first use, VS Code will prompt for API keys."
echo "You can leave them blank for lower rate limits."