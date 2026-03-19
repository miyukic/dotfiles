#Set-StrictMode -Version Latest

Param([string]$flag = "true")

$CPATH = $PSScriptRoot

function create() {
    # Write-Outputの日本語コメントはpowershell 5.1でCP932誤認識されるため削除
    New-Item -Path ~\.config\ -Name starship.toml -Value "$CPATH\starship.toml" -ItemType SymbolicLink
#sudo cmd -c mklink.exe ~\.config\starship.toml .\starship.toml ; exit
}

if ($flag -eq "true") {
    if (Test-Path "$env:USERPROFILE\.config\starship.toml") {
        Remove-Item "$env:USERPROFILE\.config\starship.toml"
    }
    create
} else {
    if (Test-Path "$env:USERPROFILE\.config\starship.toml") {
    } else {
        create
    }
}

#Set-StrictMode -Off
