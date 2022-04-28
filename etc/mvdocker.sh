#sudoで実行
#未検証
#PATHに設置したいディレクトリパスを入力（中にdockerフォルダが作られる)

$PAHT="/media/rn1/hdd1/Users/tikyu_000/docker"
cp -ar /var/lib/docker $PATH
rm -r /var/lib/docker
ln -s "{$PATH}/docker/" /var/lib/docker

