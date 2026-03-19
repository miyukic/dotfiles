@echo off
chcp 65001
SET MESSAGE=.vsvimrcを%USERPROFILE%下に設置します。
echo %MESSAGE%
mklink %USERPROFILE%\.vsvimrc %~dp0\.vsvimrc

@pause