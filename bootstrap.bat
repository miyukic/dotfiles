@echo off
chcp 65001

rem starship
if NOT "%1" == "auto" (
    .\starship\starship_install.bat
) ELSE (
    echo Y | .\starship\starship_install.bat
)
echo ✅ starhipのインストールが終わりました。

rem git config
if NOT "%1" == "auto" (
    .\Git\gitinit.bat
) ELSE (
    echo Y | .\Git\gitinit.bat
)
echo ✅ gitconfigの設定が終わりました。

if NOT "%1" == "auto" (
    echo ✅ すべてのセットアップが完了しました。
    @pause
) ELSE (
    echo;
    echo;
    echo ✅ すべてのセットアップが完了しました。
)
