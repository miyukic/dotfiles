ALIASES_FILE=".bash_aliases"
MYBASHRC_FILE=".mybashrc"
if [ -e "~/${ALIASES_FILE}" ]; then
    ln -s "`pwd`/${ALIASES_FILE}" ~/.bash_aliases
else
    echo "${ALIASES_FILE}はすでに存在しています"
        echo "${ALIASES_FILE}は存在しています。削除して置き換えますか？(Y/N)"
        read resp
        if [ $resp = "Y" ]; then
            echo "Yが入力されました。"
            rm "~/${ALIASES_FILE}"
            echo "~/${ALIASES_FILE}が削除されました。"
            ln -s "`pwd`/${ALIASES_FILE}" ~/.bash_aliases
        elif [ $resp = "N" ]; then
            echo "Nが入力されました。";
            echo "${ALIASES_FILE}は置き換えません" #&& break
        else
            echo "Y/Nを入力してください"
        fi
fi
if [ -e "~/${MYBASHRC_FILE}" ]; then
    ln -s "`pwd`/${MYBASHRC_FILE}" ~/${MYBASHRC_FILE} 
else 
    echo "${MYBASHRC_FILE}はすでに存在しています"
fi

cat ~/.bashrc | grep -E "^source ~/${MYBASHRC_FILE}$"
if [ $? = 1 ]; then
    cat "source ~/${MYBASHRC_FILE}" >> ~/.bashrc
else
    echo "source ~/${MYBASHRC_FILE}はすでに記述されています"
fi

