function Get-Assembly {
   [Appdomain]::CurrentDomain.GetAssemblies() | %{$_.GetName().Name}
}

Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

#Set-Alias vim nvim
#Set-Alias vi nvim
#Set-Alias gvim nvim-qt

