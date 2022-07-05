@echo off
chcp 65001

echo ───────ooooooo─────────────────────
echo;
echo gitの設定をします。
echo;

WHERE /Q git
IF NOT "%ERRORELEVEL%" == "1" (
    GOTO SETTING_GIT
) ELSE (
    echo ❌ gitコマンドがありません
    GOTO VIM_START
)

:SETTING_GIT

git config --global user.email m.yukic10@gmail.com
echo ☑ user.email m.yukic10@gmail.com
git config --global user.name "miyukic"
echo ☑ user.name "miyukic"

rem git pull の動作を以前のデフォルトに
git config --global pull.rebase false
echo ☑ git pull の動作を以前のデフォルトに

rem 自動で改行コードを変更しない
git config --global core.autoCRLF false
echo ☑ 自動で改行コードを変更しない

rem "日本語文字化けを回避設定"
git config --global core.quotepath false
echo ☑ 日本語文字化けを回避設定
:VIM_START
WHERE /Q vim.exe
IF NOT "%ERRORELEVEL%" == "1" (
    GOTO VIM
) ELSE (
    GOTO NOT_VIM
)
:VIM
    git config --global core.editor vim
    echo ☑ git標準のエディタをvimに設定する
GOTO FIN

:NOT_VIM
WHERE /Q vi.exe
IF NOT "%ERRORELEVEL%" == "1" (
    GOTO VIM
)
echo;
echo ❌ vimコマンドがありません
GOTO FIN
:FIN
echo;
echo ───────ooooooo─────────────────────
