@echo off
chcp 932

rem ����batfile��neovim�ɕK�v�ȃR�}���h�ƃA�v���P�[�V�����������C���X�g�[�����܂��B

rem scoop�̃C���X�g�[��
where /Q scoop
if "%ERRORLEVEL%" == "1" (
    GOTO SCOOP
) ELSE (
    GOTO SCOOP_FIN
)
:SCOOP
echo ==================================================
echo scoop�̃C���X�g�[�����J�n���܂�....
powershell -c Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
rem scoop�̃C���X�g�[��
powershell -c iwr -useb get.scoop.sh | iex && echo scoop�̃C���X�g�[�����������܂����B
:SCOOP_FIN

rem git�R�}���h�̃C���X�g�[��
where /Q git
if "%ERRORLEVEL%" == "1" (
    GOTO GIT
) else (
    GOTO FIN_GIT
)
:GIT
echo ==================================================
echo ������git�փp�X��ʂ��܂����H<Y/N>
set /P UserResp="����: "
echo.
if /i %UserResp% == "Y" (
    echo git�R�}���h���K�v�ł��B
    echo WSL��git�𗬗p����[W], scoop��git���C���X�g�[������[G], �X�L�b�v����[C]
    :SELECT
    set /P UserResp="����: "
    if /i %UserResp% == "S" (
        powershell -c scoop update
        powershell -c scoop install git
    ) else if /i %SerResp% == "W" (
        curl -fLo %SystemRoot%\system32\git.exe https://www.dropbox.com/s/c2qpu3tk5gwy2r1/wslgit.exe?dl=0
    ) else if %SerResp% == "C" (
    ) else (
        echo ���ꂩ�̃L�[[W, G, C]��I�����Ă��������B
        goto SELECT
    )
    echo.
)
:FIN_GIT
echo ==================================================

rem Ruby�̐ݒ�
echo Ruby�̃C���X�g�[�����J�n���܂��B
powershell -c "scoop install ruby && gem install neovim"
for /F %%i in ('which neovim-ruby-host') do set INSTALL_PATH=%%i
echo ==================================================
echo %INSTALL_PATH% �ɂ���܂��B

rem npm�̃C���X�g�[��
echo ��������������������������������������������������������������������������������������������������������������������������������������������������
echo nvm���C���X�g�[�����܂��B
echo ��������������������������������������������������������������������������������������������������������������������������������������������������
powershell -c scoop install nvm
echo nvm list available �ōŐV��LTS�Ńo�[�W�������m�F����B
echo nvm install <version> �ŃC���X�g�[�� ex) nvm install 12.18.4
echo �Ō�ɗ��p�������o�[�W�������w�肷��i�����Ŋ��ϐ��Ƀp�X���ǉ������j
echo ex) nvm use 12.18.4
echo ��������������������������������������������������������������������������������������������������������������������������������������������������

rem Python�̐ݒ�
echo ==================================================
rem Todo �X�N���v�g���쐬


rem ��������Avimrc�̐ݒu��vimplug�̃C���X�g�[�����s���܂��B

set TARGET=%USERPROFILE%\AppData\Local\nvim\
set VIMRC_NAME=init.vim
set GVIMRC_NAME=ginit.vim

SET CD=%~dp0
SET VIM=%CD:~0,-7%
set REAL_VIMRC=vimrc
set REAL_GVIMRC=gvimrc

echo "���݂̃f�B���N�g��==> %~dp0"
echo %TARGET%�ɃV���{���b�N�����N���쐬���܂��B
rem .vimrc
if not exist %TARGET%%VIMRC_NAME% (
    GOTO NOT_EXIST_VIMRC
) else (
    GOTO EXIST_VIMRC
)

:NOT_EXIST_VIMRC
if not exist %TARGET% (
    GOTO MKDIR_VIMRC
)
:MKDIR_VIMRC
echo %TARGET%���쐬���܂��B
mkdir %TARGET%
echo %TARGET%���쐬���܂����B
if exist %VIM%%REAL_VIMRC% (
    mklink %TARGET%%VIMRC_NAME% %VIM%%REAL_VIMRC% 
    echo %TARGET%%VIMRC_NAME% ==> %VIM%%REAL_VIMRC%
) else (
    echo %VIM%%REAL_VIMRC% ��������܂���ł����B
)
GOTO FIN_VIMRC

:EXIST_VIMRC
echo;
echo ���ł� %VIMRC_NAME% �����݂���̂ŁA
echo �V���ɃV���{���b�N�����N���쐬����K�v�͂���܂���B
echo "���蒼���܂����H<Y/N>"
set /P UserResp="����: "
IF /i "%UserResp%" == "Y" (
    GOTO YES_VIMRC
) ELSE (
    GOTO NO_VIMRC
)
GOTO FIN_VIMRC

:YES_VIMRC
rem echo mklink �����s���܂��B
del %TARGET%%VIMRC_NAME%
mklink %TARGET%%VIMRC_NAME% %VIM%%REAL_VIMRC%
echo %TARGET%%VIMRC_NAME% ==> %VIM%%REAL_VIMRC%
GOTO FIN_VIMRC
:NO_VIMRC
echo ����܂���ł����B
:FIN_VIMRC
echo ==============================================================
rem .gvimrc
if not exist %TARGET%%GVIMRC_NAME% (
    GOTO NOT_EXIST_GVIMRC
) else (
    GOTO EXIST_GVIMRC
)
:NOT_EXIST_GVIMRC
if not exist %TARGET% (
    echo %TARGET%���쐬���܂��B
    mkdir %TARGET%
    echo %TARGET%���쐬���܂����B
)
if exist %VIM%%REAL_VIMRC% (
    echo mklink �����s���A%GVIMRC_NAME%���쐬���܂��B
    mklink %TARGET%%GVIMRC_NAME% %VIM%%REAL_VIMRC%
    echo %TARGET%%GVIMRC_NAME% ==> %VIM%%REAL_VIMRC%
) else (
    echo ".gvimrc" ��������܂���ł����B
)
GOTO FIN_GVIMRC
:EXIST_GVIMRC

echo ���ł� %GVIMRC_NAME% �����݂���̂ŁA
echo �V���ɃV���{���b�N�����N���쐬����K�v�͂���܂���B
set /P UserResp="���蒼���܂���<Y/N>�H"
IF /i "%UserResp%" == "Y" (
    GOTO YES_GVIMRC
) ELSE (
    GOTO NO_GVIMRC
)
:YES_GVIMRC
echo mklink �����s���܂��B
del %TARGET%%GVIMRC_NAME%
mklink %TARGET%%GVIMRC_NAME% %VIM%%REAL_GVIMRC%
echo %TARGET%%GVIMRC_NAME% ==> %VIM%%REAL_GVIMRC%
GOTO FIN_GVIMRC
:NO_GVIMRC
echo ����܂���ł����B
:FIN_GVIMRC

rem vim-plug�̃C���X�g�[��
set VIMPLUG=%USERPROFILE%\appdata\local\nvim\autoload\plug.vim
if not exist %VIMPLUG% (
    echo vim-plug�̃C���X�g�[�����s���܂��B
    curl -fLo %VIMPLUG% --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && echo �C���X�g�[�����������܂����B
)

rem PowerShell���g����vimplug����(�����Ȃ�)
rem  vim-plug�̃C���X�g�[��
rem where /Q pwsh
rem set VIMPLUG=~\appdata\local\nvim\autoload\plug.vim
rem if not exist %VIMPLUG% (
rem echo vim-plug�̃C���X�g�[�����s���܂��B
rem     if "%ERRORLEVEL%" == "0" (
rem         pwsh -c md ~\appdata\local\nvim\autoload
rem         pwsh -c $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
rem         pwsh -c (new-object net.webclient).downloadfile($uri, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
rem     ) else (
rem         powershell -c md ~\appdata\local\nvim\autoload
rem         powershell -c $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
rem         powershell -c (new-object net.webclient).downloadfile($uri, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
rem     )
rem )

echo ���ׂĂ̏������I���܂����B
chcp 65001
@pause
