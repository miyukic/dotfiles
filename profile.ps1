function Get-Assembly {
   [Appdomain]::CurrentDomain.GetAssemblies() | %{$_.GetName().Name}
}

function Call-Gvim {
    cmd.exe /c gvim $args
}

Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar

#nvimエイリアス
Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias gvim Call-Gvim

#oh-my-posh (PsowerLine) 
if ($env:WT_PROFILE_ID) {
    Import-Module posh-git
    Import-Module oh-my-posh
    Set-PoshPrompt -Theme agnosterplus
    $GitPromptSettings.AnsiConsole = $false
}
