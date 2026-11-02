[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$ConfigDirectory = (Join-Path $env:USERPROFILE '.config\opencode')
)

$ErrorActionPreference = 'Stop'
$sources = @(Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'plugins') -Filter '*.js' -File)
if (-not $sources) {
    throw "No plugin sources found in: $(Join-Path $PSScriptRoot 'plugins')"
}

$configRoot = [System.IO.Path]::GetFullPath($ConfigDirectory)
$pluginDirectory = Join-Path $configRoot 'plugins'

foreach ($source in $sources) {
    $loaderPath = Join-Path $pluginDirectory $source.Name
    $sourceUri = ([System.Uri]::new($source.FullName)).AbsoluteUri
    $loader = 'export { default } from "' + $sourceUri + '";' + "`r`n"

    if ((Test-Path -LiteralPath $loaderPath -PathType Leaf) -and
        [System.IO.File]::ReadAllText($loaderPath) -eq $loader) {
        Write-Output "OpenCode repository loader already current: $loaderPath"
        continue
    }
    if (-not $PSCmdlet.ShouldProcess($loaderPath, 'Install OpenCode repository loader')) {
        continue
    }

    [void][System.IO.Directory]::CreateDirectory($pluginDirectory)
    if (Test-Path -LiteralPath $loaderPath -PathType Leaf) {
        $backupDirectory = Join-Path $configRoot 'plugin-backups'
        [void][System.IO.Directory]::CreateDirectory($backupDirectory)
        $backupName = $source.BaseName + '.' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.' +
            [guid]::NewGuid().ToString('N').Substring(0, 8) + '.js.bak'
        $backupPath = Join-Path $backupDirectory $backupName
        [System.IO.File]::Copy($loaderPath, $backupPath, $false)
        Write-Output "Previous plugin backed up: $backupPath"
    }
    [System.IO.File]::WriteAllText($loaderPath, $loader, [System.Text.UTF8Encoding]::new($true))
    Write-Output "OpenCode repository loader installed: $loaderPath"
    Write-Output "Plugin source: $($source.FullName)"
}
