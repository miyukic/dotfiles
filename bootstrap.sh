#!/usr/bin/env bash

cd $(dirname $0)
#echo "debug => $1"
echo $(pwd )

type curl >/dev/null 2>&1 || {
    echo >&2 "■ curl is installing..."; sudo apt apdate >/dev/null 2>&1;\
    sudo apt install curl -y ; echo >&2 "■ curl is installing...";
}

bash ./bash/set-bashrc.sh && \
bash ./Git/gitinit.sh
echo -e "Y\n" | bash ./Vim/vim/vimrc-setup.sh && \
