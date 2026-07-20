$starshipConfig = Join-Path $HOME '.config\starship.toml'

if (Get-Command starship -ErrorAction SilentlyContinue) {
    $env:STARSHIP_CONFIG = $starshipConfig
    Invoke-Expression (&starship init powershell)
}
else {
    Write-Warning 'Starship is not installed. Run PowerShell\install.ps1 from the config repository.'
}

if ($Host.UI.SupportsVirtualTerminal -and -not [Console]::IsOutputRedirected -and (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue)) {
    Set-PSReadLineOption -PredictionSource History -PredictionViewStyle InlineView -BellStyle None
}
