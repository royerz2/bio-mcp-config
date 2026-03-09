Write-Host "🔧 Installing MCP configuration..." -ForegroundColor Cyan

# VS Code user config location
$vscodePath = "$env:APPDATA\Code\User\globalStorage\github.copilot-chat"
$configFile = Join-Path $vscodePath "mcp.json"

# Check if VS Code is installed
if (-not (Test-Path "$env:APPDATA\Code")) {
    Write-Host "❌ VS Code user directory not found at: $env:APPDATA\Code" -ForegroundColor Red
    Write-Host "Make sure VS Code is installed and has been run at least once" -ForegroundColor Yellow
    exit 1
}

# Create directory
New-Item -ItemType Directory -Force -Path $vscodePath | Out-Null

# Backup existing config if present
if (Test-Path $configFile) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backup = "$configFile.backup.$timestamp"
    Copy-Item $configFile $backup -Force
    Write-Host "📦 Backed up existing config to: $backup" -ForegroundColor Yellow
}

# Copy config
Copy-Item "mcp.vscode.json" $configFile -Force

Write-Host "✅ Config installed to: $configFile" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart VS Code"
Write-Host "2. Open Command Palette (Ctrl+Shift+P)"
Write-Host "3. Run: 'MCP: List Servers'"
Write-Host "4. You should see all 6 servers listed"
Write-Host ""
Write-Host "On first use, VS Code will prompt for API keys." -ForegroundColor Yellow
Write-Host "You can leave them blank for lower rate limits." -ForegroundColor Yellow