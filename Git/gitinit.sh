#!/usr/bin/bash

from=`pwd`
cd `dirname $0`

if type git > /dev/null 2>&1; then
    git config --global user.email m.yukic10@gmail.com
    git config --global user.name "miyukic"

    # git pull の動作を以前のデフォルトに
    git config --global pull.rebase false
    # 自動で改行コードを変更しない
    git config --global core.autoCRLF false

    if type vim > /dev/null 2>&1; then
        git config --global core.editor 'vim -c "set fenc=utf-8"'
    fi
fi

cd $from
