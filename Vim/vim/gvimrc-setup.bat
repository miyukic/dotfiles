@echo off
mklink %USERPROFILE%\.gvimrc %USERPROFILE%\dotfiles\.gvimrc
mklink %USERPROFILE%\.vimrc %USERPROFILE%\dotfiles\.vimrc
rem vim-plug�̃C���X�g�[��
set VIMPLUG=%USERPROFILE%/vimfiles/autoload/plug.vim
if not exist %VIMPLUG% (
echo vim-plug�̃C���X�g�[�����s���܂��B
    curl -fLo %VIMPLUG% --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
)
@pause
