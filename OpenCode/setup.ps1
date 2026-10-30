[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$ConfigDirectory = (Join-Path $env:USERPROFILE '.config\opencode')
)

$ErrorActionPreference = 'Stop'
$sourcePath = Join-Path $PSScriptRoot 'plugins\strata-server-info.js'
if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
    throw "Plugin source not found: $sourcePath"
}

$configRoot = [System.IO.Path]::GetFullPath($ConfigDirectory)
$pluginDirectory = Join-Path $configRoot 'plugins'
$loaderPath = Join-Path $pluginDirectory 'strata-server-info.js'
$sourceUri = ([System.Uri]::new($sourcePath)).AbsoluteUri
$loader = 'export { default } from "' + $sourceUri + '";' + "`r`n"

if ((Test-Path -LiteralPath $loaderPath -PathType Leaf) -and
    [System.IO.File]::ReadAllText($loaderPath) -eq $loader) {
    Write-Output "OpenCode repository loader already current: $loaderPath"
    return
}
if (-not $PSCmdlet.ShouldProcess($loaderPath, 'Install OpenCode repository loader')) {
    return
}

[void][System.IO.Directory]::CreateDirectory($pluginDirectory)
if (Test-Path -LiteralPath $loaderPath -PathType Leaf) {
    $backupDirectory = Join-Path $configRoot 'plugin-backups'
    [void][System.IO.Directory]::CreateDirectory($backupDirectory)
    $backupName = 'strata-server-info.' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.' +
        [guid]::NewGuid().ToString('N').Substring(0, 8) + '.js.bak'
    $backupPath = Join-Path $backupDirectory $backupName
    [System.IO.File]::Copy($loaderPath, $backupPath, $false)
    Write-Output "Previous plugin backed up: $backupPath"
}
[System.IO.File]::WriteAllText($loaderPath, $loader, [System.Text.UTF8Encoding]::new($true))
Write-Output "OpenCode repository loader installed: $loaderPath"
Write-Output "Plugin source: $sourcePath"
