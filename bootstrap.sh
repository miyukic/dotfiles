#!/usr/bin/env bash

cd $(dirname $0)
echo "debug => $1"

echo $(pwd )

echo -e "Y\n" | bash ./Vim/vim/vimrc-setup.sh && \
bash ./bash/set-bashrc.sh && \
bash ./Git/gitinit.sh
