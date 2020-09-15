@echo off
set target=%USERPROFILE%\AppData\Local\nvim\
set vimrc_name=init.vim
set gvimrc_name=ginit.vim

echo "���݂̃f�B���N�g��==> %~dp0"
echo %target%�ɃV���{���b�N�����N���쐬���܂��B
rem vimrc
if not exist %target%%vimrc_name% (
    if not exist %target% (
        echo %target%���쐬���܂��B
        mkdir %target%
        echo %target%���쐬���܂����B
    )
    if exist %~dp0.vimrc (
        echo mklink �����s���܂��B
        mklink %target%%vimrc_name% %~dp0\.vimrc
        echo %target%%vimrc_name% ==> %~dp0\.vimrc
    ) else (
        echo ".vimrc" ��������܂���ł����B
    )
) else (
    echo ���ł� %vimrc_name% �����݂���̂ŁA
    echo �V���ɃV���{���b�N�����N���쐬����K�v�͂���܂���B
)
echo ==============================================================
rem gvimrc
if not exist %target%%gvimrc_name% (
    if not exist %target% (
        echo %target%���쐬���܂��B
        mkdir %target%
        echo %target%���쐬���܂����B
    )
    if exist %~dp0.gvimrc (
        echo mklink �����s���A%gvimrc_name%���쐬���܂��B
        mklink %target%%gvimrc_name% %~dp0\.gvimrc
        echo %target%%gvimrc_name% ==> %~dp0\.gvimrc
    ) else (
        echo ".gvimrc" ��������܂���ł����B
    )
) else (
    echo ���ł� %gvimrc_name% �����݂���̂ŁA
    echo �V���ɃV���{���b�N�����N���쐬����K�v�͂���܂���B
)

rem vim-plug�̃C���X�g�[��
where /Q pwsh
set VIMPLUG=~\appdata\local\nvim\autoload\plug.vim
if not exist %VIMPLUG% (
echo vim-plug�̃C���X�g�[�����s���܂��B
    if %ERRORLEVEL% == 0 (
        pwsh -c md ~\appdata\local\nvim\autoload
        pwsh -c $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        pwsh -c (new-object net.webclient).downloadfile($uri, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
    ) else (
        powershell -c md ~\appdata\local\nvim\autoload
        powershell -c $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        powershell -c (new-object net.webclient).downloadfile($uri, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
    )
)
echo ���ׂĂ̏������I���܂����B
@pause

