#!/usr/bin/env bash

ALIASES_FILE=".bash_aliases"
MYBASHRC_FILE=".mybashrc"
REAL_ALIASES_FILE="bash_aliases"
REAL_MYBASHRC_FILE="mybashrc"

printLine() {
    lines=$(tput cols)
    for ((i=0; i<$lines*1; i++)); do
        echo -n ─ 
    done
    echo
}

printLine
echo " "

if [ -e $HOME/$ALIASES_FILE ]; then
    echo ${ALIASES_FILE}"はすでに存在しています"
    echo "${ALIASES_FILE}は存在しています。削除して置き換えますか？(Y/N)"
    read resp
    if [ $resp = "Y" ]; then
        echo "Yが入力されました。"
        rm "~/"${ALIASES_FILE}
        #echo "~/"${ALIASES_FILE}"が削除されました。"
        sudo ln -s `pwd`"/"${REAL_ALIASES_FILE} $HOME"/.bash_aliases"
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

if [ -e $HOME/$MYBASHRC_FILE ]; then
    echo ${MYBASHRC_FILE}"はすでに存在しています"
    echo "${MYBASHRC_FILE}は存在しています。削除して置き換えますか？(Y/N)"
    read resp
    if [ $resp = "Y" ]; then
        echo "Yが入力されました。"
        rm ~/$MYBASHRC_FILE
        #echo "~/ ${MYBASHRC_FILE} が削除されました。"
        sudo ln -s "`pwd`/${REAL_MYBASHRC_FILE}}" ~/.bash_aliases
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
