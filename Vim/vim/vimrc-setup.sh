#!/usr/bin/env bash

from=`pwd`
cd `dirname $0`

TARGET_DIR=$HOME/
vimrc=.vimrc
real_vimrc=vimrc

create_link() {
    current_dir=$(cd $(dirname $0); pwd)
    cd ../
	rm ${TARGET_DIR}${vimrc}
    ln -s $(pwd)/$real_vimrc ${TARGET_DIR}${vimrc}
    echo "${TARGET_DIR}${vimrc}にシンボリックリンクを作成しました！"
}

echo "${TARGET_DIR}に名前 ${vimrc} でシンボリックリンクを作成します。"
while true
do

	echo ""
    if [ -e $TARGET_DIR$vimrc ]; then
        echo ".vimrcは存在しています。削除して置き換えますか？(Y/N)"
        read resp
        if [ $resp = "Y" ]; then
            echo "Yが入力されました。"
            echo "${TARGET_DIR}${vimrc}が削除されました。"
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
    mkdir -p ~/.vim/autoload
    curl -fLo $VIMPLUG --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    # vim-plug PlugInstallの実行
    if vim -c :PlugInstall -c :q! -c :q!; then
        echo "vim-plugのプラグインのインストールが完了しました。"
    else
        echo "vim-plugのプラグインインストールに失敗しました。"
    fi
fi

cd $from
