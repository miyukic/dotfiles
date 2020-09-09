#!/bin/sh
target=$HOME/
vimrc=.vimrc
echo "${target}に名前 ${vimrc} でシンボリックリンクを作成します。"
if [ -e $target$vimrc ]; then
    echo ".vimrcは存在しています。削除して置き換えますか？(Y/N)"
    read resp
    if [ $resp = "Y" ]; then
        echo "Yが入力されました。"
    elif [ $resp = "N" ]; then
        echo "Nが入力されました。"
    else
        echo "Y/Nを入力してください"
    fi
fi


