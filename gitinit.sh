#!/usr/bin/bash

if type git > /dev/null 2>&1; then
    git config --global user.email m.yukic10@gmail.com
    git config --global user.name "miyukic"


    if type vim > /dev/null 2>&1; then
        git config --global core.editor 'vim -c "set fenc=utf-8"'
    fi
fi
