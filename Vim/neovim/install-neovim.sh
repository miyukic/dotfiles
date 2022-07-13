#!/usr/bin/env bash

FROM=`pwd`
cd `dirname $0`

Distri=`cat /etc/os-release | grep -Ei "^NAME=" | sed -e "s;^NAME=;;g" \
    | sed -e "s;\";;g"`
Version=`cat /etc/os-release | grep -Ei "^VERSION_ID" | sed -e "s;^VERSION_ID=;;g" \
    | sed -e "s;\";;g"`
echo "Distribution = $Distri"
echo "Version = $Version"
if [[ "$Distri" = "Ubuntu" ]]; then
    echo "neovimをインストールします..."
    sudo apt install -y snapd
    snap install nvim --classic
    echo "✅neovimをインストールしますが終わりました。"
fi


cd $FROM
