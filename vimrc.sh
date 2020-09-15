#!/bin/sh

target=$HOME/
vimrc=.vimrc

create_link() {
    current_dir=$(cd $(dirname $0); pwd)
    echo $current_dir
    ln -s $current_dir/.vimrc ${target}${vimrc}
    echo "${target}${vimrc}にシンボリックリンクを作成しました！"
}

echo "${target}に名前 ${vimrc} でシンボリックリンクを作成します。"
while true
do
    if [ -e $target$vimrc ]; then
        echo ".vimrcは存在しています。削除して置き換えますか？(Y/N)"
        read resp
        if [ $resp = "Y" ]; then
            echo "Yが入力されました。"
            rm $target$vimrc
            echo "${target}${vimrc}が削除されました。"
	    create_link && break
        elif [ $resp = "N" ]; then
            echo "Nが入力されました。" && break
        else
            echo "Y/Nを入力してください"
        fi
    else
        create_link
        break
    fi
done

# vim-plugのインストール
VIMPLUG=~/.vim/autoload/plug.vim
if [ ! -e $VIMPLUG ]; then
curl -fLo $VIMPLUG --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
