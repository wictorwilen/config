[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw 'winget is required. Install App Installer from the Microsoft Store.'
}

$packages = @(
    'Microsoft.PowerShell'
    'Microsoft.WindowsTerminal'
    'Starship.Starship'
    'Microsoft.Coreutils'
)

foreach ($package in $packages) {
    winget install --exact --id $package --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        throw "winget failed to install $package with exit code $LASTEXITCODE."
    }
}

$profileDirectory = Split-Path -Parent $PROFILE.CurrentUserAllHosts
New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null

if (Test-Path $PROFILE.CurrentUserAllHosts) {
    $backupPath = "$($PROFILE.CurrentUserAllHosts).backup-$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item $PROFILE.CurrentUserAllHosts $backupPath
    Write-Host "Existing profile backed up to $backupPath"
}

Copy-Item (Join-Path $PSScriptRoot 'profile.ps1') $PROFILE.CurrentUserAllHosts -Force

$starshipDirectory = Join-Path $HOME '.config'
New-Item -ItemType Directory -Path $starshipDirectory -Force | Out-Null
Copy-Item (Join-Path $PSScriptRoot '..\starship\starship.toml') `
    (Join-Path $starshipDirectory 'starship.toml') -Force

Write-Host 'PowerShell configuration installed. Restart PowerShell to load it.'
Write-Host 'Install CaskaydiaCove Nerd Font and select it in Windows Terminal.'
