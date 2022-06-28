#!/usr/bin/env bash

from=$(pwd)
cd `dirname $0`

ALIASES_FILE=".bash_aliases"
MYBASHRC_FILE=".mybashrc"
REAL_ALIASES_FILE="bash_aliases"
REAL_MYBASHRC_FILE="mybashrc"

printLine() {
    echo -ne "\e[1;33m"
    lines=$(tput cols)
    for ((i=0; i<$lines*1; i++)); do
        echo -n ─ 
    done
    echo
    echo -ne "\e[1;0m"
}

printLine
echo " "

# .bash_aliasesの配置
# なぜか二段構えじゃないとファイルの存在判定ができない...
test -e $HOME/$ALIASES_FILE 
if [ $? = "0" ]; then
    echo ${ALIASES_FILE}"はすでに存在しています"
    echo 
    echo "削除して置き換えますか？(Y/N)"
    read resp
    if [ $resp = "Y" ]; then
        echo "Yが入力されました。"
        rm -f "$HOME/$ALIASES_FILE"
        #echo "~/"${ALIASES_FILE}"が削除されました。"
        sudo ln -s `pwd`"/"${REAL_ALIASES_FILE} $HOME"/.bash_aliases" && echo "`pwd`/${REAL_ALIASES_FILE} ==> ~/$ALIASES_FILE シンボリックリンクをを作成しました"

    elif [ $resp = "N" ]; then
        echo "Nが入力されました。";
        echo "${ALIASES_FILE}は置き換えません" #&& break
    else
        echo "Y/Nを入力してください"
    fi
else
    echo "${ALIASES_FILE}のシンボリックリンクを作成します"
    sudo ln -s `pwd`/${REAL_ALIASES_FILE} ~/$ALIASES_FILE && echo "`pwd`/${REAL_ALIASES_FILE} ==> ~/$ALIASES_FILE シンボリックリンクをを作成しました"
fi

echo " "
printLine
echo " "

# .mybashrcの配置
# なぜか二段構えじゃないとファイルの存在判定ができない...
test -e $HOME/$MYBASHRC_FILE
if test $? = "0"; then
    echo ${MYBASHRC_FILE}"はすでに存在しています"
    echo 
    echo "削除して置き換えますか？(Y/N)"
    read resp2
    if [ $resp2 = "Y" ]; then
        echo "Yが入力されました。"
        echo "$HOME/$MYBASHRC_FILE"
        rm -f "$HOME/$MYBASHRC_FILE"
        #echo "~/ ${MYBASHRC_FILE} が削除されました。"
        sudo ln -s "`pwd`/${REAL_MYBASHRC_FILE}" ~/${MYBASHRC_FILE} && echo "`pwd`/${REAL_MYBASHRC_FILE} ==> ~/${MYBASHRC_FILE} シンボリックリンクを作成しました"

    elif [ $resp = "N" ]; then
        echo "Nが入力されました。";
        echo "${MYBASHRC_FILE}は置き換えません" #&& break
    else
        echo "Y/Nを入力してください"
    fi
else 
    echo "${MYBASHRC_FILE}のシンボリックリンクを作成します"
    sudo ln -s "`pwd`/${REAL_MYBASHRC_FILE}" ~/${MYBASHRC_FILE} && echo "`pwd`/${REAL_MYBASHRC_FILE} ==> ~/${MYBASHRC_FILE} シンボリックリンクを作成しました"
fi

echo " "
printLine
echo " "

# .bashrc内に.mybashrcの読み込みスクリプトの追記
cat ~/.bashrc | grep -E "^source ~/${MYBASHRC_FILE}$"
if [ $? = 1 ]; then
    echo "source ~/${MYBASHRC_FILE}" >> ~/.bashrc
else
    echo ~/.bashrc 内に
    echo "source ~/${MYBASHRC_FILE}はすでに記述されています"
fi

echo " "
printLine
echo " "

cd $from
