#Set-StrictMode -Version Latest

Param([string]$flag = "true")

$CPATH=pwd

function create() {
    Write-Output ".\starship.toml -> ~\.config\starship.tomlにシンボリックリンクを作成します"
    New-Item -Path ~\.config\ -Name starship.toml -Value $CPATH\starship.toml -ItemType SymbolicLink
    #sudo cmd -c mklink.exe ~\.config\starship.toml .\starship.toml ; exit
}

if ($flag -eq "true") {
    if (Test-Path "~\.config\starship.toml") {
        Remove-Item ~\.config\starship.toml
        create
    }
} else {
    if (Test-Path "~\.config\starship.toml") {
    } else {
        create
    }
}

#Set-StrictMode -Off
