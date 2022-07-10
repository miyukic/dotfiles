#!/usr/bin/env bash

FROM=`pwd`
cd `dirname $0`

TARGET_DIR="${HOME}/.config/nvim/"
vimrc=init.vim
real_vimrc=vimrc

create_link() {
    current_dir=$(cd $(dirname $0); pwd)
    cd ../
    if [[ -e "${TARGET_DIR}${vimrc}" ]]; then
        rm ${TARGET_DIR}${vimrc}
    fi
    if [[ ! -d "${TARGET_DIR}" ]]; then
        mkdir "${TARGET_DIR}"
    fi
    sudo ln -s "$(pwd)/$real_vimrc" "${TARGET_DIR}${vimrc}"
    echo "${TARGET_DIR}${vimrc}にシンボリックリンクを作成しました！"
}

echo "${TARGET_DIR}に名前 ${vimrc} でシンボリックリンクを作成します。"
while true
do
	echo ""
    if [[ -e "${TARGET_DIR}${vimrc}" ]]; then
        echo "${vimrc}は存在しています。削除して置き換えますか？(Y/N)"
        read resp
        if [ "$resp" = "Y" ]; then
            echo "Yが入力されました。"
            echo "${TARGET_DIR}${vimrc}が削除されました。"
	    create_link && break
        elif [ "$resp" = "N" ]; then
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
VIMPLUG=${HOME}/.local/share/nvim/site/autoload/plug.vim
if [ ! -e "$VIMPLUG" ]; then
    mkdir -p ~/.vim/autoload
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    # vim-plug PlugInstallの実行
    if nvim -c :PlugInstall -c :q! -c :q!; then
        echo "vim-plugのプラグインのインストールが完了しました。"
    else
        echo "vim-plugのプラグインインストールに失敗しました。"
    fi
else
    echo "vim-plugはインストール済みです。"
fi

cd $FROM
