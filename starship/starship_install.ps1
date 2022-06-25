echo "hogehoge"

$CPATH=pwd

if (Test-Path "~\.config\starship.toml") {
} else {
    Write-Output ".\starship.toml -> ~\.config\starship.tomlにシンボリックリンクを作成します"
    New-Item -Path ~\.config\ -Name starship.toml -Value $CPATH\starship.toml -ItemType SymbolicLink
    #sudo cmd -c mklink.exe ~\.config\starship.toml .\starship.toml ; exit
}

