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
@pause

