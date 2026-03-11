Write-Host "Installing MCP configuration..." -ForegroundColor Cyan

# VS Code user profile MCP config location
$vscodeUserPath = "$env:APPDATA\Code\User"
$configFile = Join-Path $vscodeUserPath "mcp.json"

# Check if VS Code is installed
if (-not (Test-Path "$env:APPDATA\Code")) {
    Write-Host "ERROR: VS Code user directory not found at: $env:APPDATA\Code" -ForegroundColor Red
    Write-Host "Make sure VS Code is installed and has been run at least once" -ForegroundColor Yellow
    exit 1
}

# Create directory
New-Item -ItemType Directory -Force -Path $vscodeUserPath | Out-Null

# Backup existing config if present
if (Test-Path $configFile) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backup = "$configFile.backup.$timestamp"
    Copy-Item $configFile $backup -Force
    Write-Host "Backed up existing config to: $backup" -ForegroundColor Yellow
}

# Copy config
Copy-Item "mcp.vscode.json" $configFile -Force

Write-Host "Config installed to: $configFile" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart VS Code (or run 'Developer: Reload Window')"
Write-Host "2. Open Command Palette (Ctrl+Shift+P)"
Write-Host "3. Run: 'MCP: Open User Configuration' and confirm it opens: $configFile"
Write-Host "4. Run: 'MCP: List Servers'"
Write-Host "5. You should see server names such as 'biothings-mcp' and 'biomcp'"
Write-Host ""
Write-Host "Note: 'bio-mcp-config' is a config repo, not an MCP server name." -ForegroundColor Yellow
Write-Host "On first use, VS Code will prompt for API keys." -ForegroundColor Yellow
Write-Host "You can leave them blank for lower rate limits." -ForegroundColor Yellow
