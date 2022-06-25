
sudo New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value $((Get-Command pwsh.exe).source) -PropertyType String -Force
