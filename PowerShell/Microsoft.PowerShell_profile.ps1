# .NETのngenで事前コンパイルし起動を速くする
#Set-Alias ngen @(  
#dir (join-path ${env:\windir} "Microsoft.NET\Framework") ngen.exe -recurse |  
#sort -descending lastwritetime  
#)[0].fullName  
#[appdomain]::currentdomain.getassemblies() | %{ngen $_.location}

function Get-Assembly {
   [Appdomain]::CurrentDomain.GetAssemblies() | %{$_.GetName().Name}
}

function Call-Gvim {
    cmd.exe /c gvim $args
}

function Call-ls {
    ls.exe -la
}

function Call-lsd-la {
    lsd.exe -la
}

function Call-lsd-tree {
    lsd.exe --tree
}

function Call-CommandPath {
    (Get-Command $args).source
}

function Start-OhMyPosh {
    #Import-Module posh-git
    #Import-Module oh-my-posh
    Set-PoshPrompt -Theme negligible
    # $GitPromptSettings.AnsiConsole = $true
    $Env:POSHGIT_CYGWIN_WARNING = 'off'
}

#Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
# zsh風Tabの補完
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
# PowerShell/cmd風のTab補完
#Set-PSReadLineKeyHandler -Key Tab -Function TabCompleteNext

# fish風のオートサジェスト機能を有効に
Set-PSReadLineOption -PredictionSource History


# nvimエイリアス
#Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias gvim Call-Gvim

#Set-Alias ll Call-ls
#Set-Alias ls ls.exe

Set-Alias type Call-CommandPath

# oh-my-posh (PsowerLine) 
#if ($env:WT_PROFILE_ID) {
#    Start-OhMyPosh
#}

# starship
if ($env:WT_PROFILE_ID) {
    Invoke-Expression (&starship init powershell)
}

#lsd,batコマンド
if ($env:WT_PROFILE_ID) {
    Set-Alias ls lsd
    Set-Alias ll Call-lsd-la
    Set-Alias tree Call-lsd-tree
}

#パイプ通過時、コンソール出力時の文字コード
$OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")

# Rust目的で導入したOpenSSL
#$env:OPENSSL_LIB_DIR="C:\Program Files\OpenSSL-Win64"
#$env:OPENSSL_INCLUDE_DIR="C:\Program Files\OpenSSL-Win64\include"
