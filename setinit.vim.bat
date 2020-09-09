@echo off
set target=%USERPROFILE%\AppData\Local\nvim\
set vimrc_name=init.vim
echo %target%にシンボリックリンクを作成します。
if not exist %target%%vimrc_name% (
    if not exist %target% (
        echo %target%を作成します。
        mkdir %target%
        echo %target%を作成しました。
    )
    if exist ./.vimrc (
        echo mklink を実行します。
        mklink %target%%vimrc_name% ./.vimrc
        echo mklink を実行しました。
    ) else (
        echo ".vimrc" が見つかりませんでした。
    )
) else (
    echo すでに %vimrc_name% が存在するので、
    echo あたらにシンボリックリンクを作成する必要はありません。
)
@pause

