# OpenSSH Server Setup Script
# Run as Administrator (gsudo)

$ErrorActionPreference = "Stop"

# -- 1. Install OpenSSH Server ------------------------------------------------
Write-Output "[1/5] Checking OpenSSH Server..."
$sshd = Get-WindowsCapability -Online | Where-Object Name -like "OpenSSH.Server*"
if ($sshd.State -eq "Installed") {
    Write-Output "  OpenSSH Server is already installed."
} else {
    Write-Output "  Installing OpenSSH Server..."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Write-Output "  Done."
}

# -- 2. Enable and start sshd service -----------------------------------------
Write-Output "[2/5] Configuring sshd service..."
Set-Service -Name sshd -StartupType Automatic
Start-Service sshd
Write-Output "  sshd service started and set to auto-start."

# -- 3. Firewall rule ----------------------------------------------------------
Write-Output "[3/5] Configuring firewall..."
$PORT = 50041
$ruleName = "OpenSSH-Server-In-TCP-$PORT"
$existing = Get-NetFirewallRule -Name $ruleName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Output "  Firewall rule already exists."
} else {
    Remove-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue
    New-NetFirewallRule -Name $ruleName -DisplayName "OpenSSH Server (Port $PORT)" `
        -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort $PORT
    Write-Output "  Firewall rule created for port $PORT."
}

# -- 4. Edit sshd_config ------------------------------------------------------
Write-Output "[4/5] Configuring sshd_config..."
$configPath = "C:\ProgramData\ssh\sshd_config"

function Set-SshdOption {
    param([string]$Key, [string]$Value)
    $content = Get-Content $configPath -Raw
    if ($content -match "(?m)^#?\s*$Key\s+") {
        $content = $content -replace "(?m)^#?\s*$Key\s+.*", "$Key $Value"
    } else {
        $content += "`n$Key $Value"
    }
    Set-Content $configPath $content -Encoding UTF8
}

Set-SshdOption "Port"                   "50041"
Set-SshdOption "PasswordAuthentication" "no"
Set-SshdOption "PubkeyAuthentication"   "yes"

# Restore Administrators_authorized_keys override (default Windows OpenSSH behavior)
# This prevents SSH sessions from getting elevated tokens
$content = Get-Content $configPath -Raw
if ($content -match "(?m)^#Match Group administrators") {
    $content = $content -replace "(?m)^#(Match Group administrators)", "`$1"
    $content = $content -replace "(?m)^#(\s*AuthorizedKeysFile __PROGRAMDATA__)", "`$1"
    Set-Content $configPath $content -Encoding UTF8
    Write-Output "  Restored Administrators_authorized_keys override."
} elseif ($content -notmatch "(?m)^Match Group administrators") {
    $content += "`nMatch Group administrators`n       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys"
    Set-Content $configPath $content -Encoding UTF8
    Write-Output "  Added Administrators_authorized_keys override."
} else {
    Write-Output "  Administrators_authorized_keys override already set."
}

Write-Output "  sshd_config updated."

# -- 5. Set pwsh as default shell ---------------------------------------------
Write-Output "[5/5] Setting pwsh as default SSH shell..."
$pwshPath = (Get-Command pwsh.exe -ErrorAction SilentlyContinue).Source
if ($pwshPath) {
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell `
        -Value $pwshPath -PropertyType String -Force | Out-Null
    Write-Output "  DefaultShell set to: $pwshPath"
} else {
    Write-Output "  WARNING: pwsh.exe not found. Install pwsh first, then re-run this script."
}

Restart-Service sshd
Write-Output "  sshd restarted."

# -- Manual steps -------------------------------------------------------------
Write-Output ""
Write-Output "======================================================"
Write-Output "  MANUAL STEPS REQUIRED"
Write-Output "======================================================"
Write-Output ""
Write-Output "  SSH keys must be set up manually."
Write-Output "  Choose one of the following:"
Write-Output ""
Write-Output "  [A] Generate new key pair (on client machine):"
Write-Output "      ssh-keygen -t ed25519 -C 'your_comment'"
Write-Output ""
Write-Output "  [B] Restore from backup:"
Write-Output "      Copy your existing private/public key files."
Write-Output ""
Write-Output "  Then place the public key on THIS machine:"
Write-Output "      Path: C:\Users\<USERNAME>\.ssh\authorized_keys"
Write-Output ""
Write-Output "  Permissions fix (run on this machine if auth fails):"
Write-Output "      icacls `$env:USERPROFILE\.ssh\authorized_keys /inheritance:r /grant `"$env:USERNAME`:F`""
Write-Output ""
Write-Output "  Connection test from client:"
Write-Output "      ssh -p 50041 <USERNAME>@<IP>"
Write-Output ""
Write-Output "======================================================"
Write-Output "  Setup complete."
Write-Output "======================================================"
