@echo off
set target=%USERPROFILE%\AppData\Local\nvim\
set vimrc_name=init.vim
echo %target%�ɃV���{���b�N�����N���쐬���܂��B
if not exist %target%%vimrc_name% (
    if not exist %target% (
        echo %target%���쐬���܂��B
        mkdir %target%
        echo %target%���쐬���܂����B
    )
    if exist ./.vimrc (
        echo mklink �����s���܂��B
        mklink %target%%vimrc_name% ./.vimrc
        echo mklink �����s���܂����B
    ) else (
        echo ".vimrc" ��������܂���ł����B
    )
) else (
    echo ���ł� %vimrc_name% �����݂���̂ŁA
    echo ������ɃV���{���b�N�����N���쐬����K�v�͂���܂���B
)
@pause

