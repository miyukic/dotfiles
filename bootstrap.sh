#!/usr/bin/env bash

cd $(dirname $0)
echo "debug => $1"

echo $(pwd )

echo -e "Y\n" | . ./vim_vimrc_unix.sh && \
. ./bash/set-bashrc.sh && \
. ./Git/gitinit.sh
