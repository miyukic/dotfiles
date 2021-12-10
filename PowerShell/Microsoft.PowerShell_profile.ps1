
function Get-Assembly {
   [Appdomain]::CurrentDomain.GetAssemblies() | %{$_.GetName().Name}
}

function Call-Gvim {
    cmd.exe /c gvim $args
}

function Start-OhMyPosh {
    #Import-Module posh-git
    #Import-Module oh-my-posh
    Set-PoshPrompt -Theme powerlevel10k_rainbow
    # $GitPromptSettings.AnsiConsole = $true
    $Env:POSHGIT_CYGWIN_WARNING = 'off'
}

#Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar

# fish風のオートサジェスト機能を有効に
Set-PSReadLineOption -PredictionSource History


#nvimエイリアス
#Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias gvim Call-Gvim

#oh-my-posh (PsowerLine) 
if ($env:WT_PROFILE_ID) {
    Start-OhMyPosh
}
