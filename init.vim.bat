@rem Windows��nvim�����̏����ݒ������bat�X�N���v�g

@echo off
set target=%USERPROFILE%\AppData\Local\nvim\
set vimrc_name=init.vim
set gvimrc_name=ginit.vim

echo "���݂̃f�B���N�g��==> %~dp0"
echo %target%�ɃV���{���b�N�����N���쐬���܂��B
@rem vimrc�̐ݒu
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
rem gvimrc�̐ݒu
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

@rem vim-plug�̃C���X�g�[��
rem where /Q pwsh
rem set VIMPLUG=%USERPROFILE%\appdata\local\nvim\autoload\plug.vim
rem set url=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
rem if not exist %VIMPLUG% (
rem echo vim-plug�̃C���X�g�[�����s���܂��B
rem     if %ERRORLEVEL% == 0 (
rem         pwsh -c md ~\appdata\local\nvim\autoload
rem         rem pwsh -c $url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
rem         pwsh -c (new-object net.webclient).downloadfile(%url%, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
rem     ) else (
rem         powershell -c md ~\appdata\local\nvim\autoload
rem         rem powershell -c $url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
rem         powershell -c (new-object net.webclient).downloadfile(%url%, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
rem     )
rem )

@rem nvim����python�̃C���X�g�[��
set PATH=%PATH%;%USERPROFILE%\Anaconda3\Library\bin;%USERPROFILE%\Anaconda3\Scripts;%USERPROFILE%\Anaconda3\condabin
where /Q python
if %ERRORLEVEL% == 0 (
    pip install pynvim
)


echo ���ׂĂ̏������I���܂����B
@pause

