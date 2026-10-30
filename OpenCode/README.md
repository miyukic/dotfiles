# OpenCode

Strataで現在ロードされているモデル名とコンテキスト上限を、OpenCodeの起動時に取り込むプラグイン。
OpenCode 1.17.14で確認済み。

## 配置

Windowsのリポジトリ直下で実行する。`bootstrap.bat` からも呼ばれる。

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\OpenCode\setup.ps1
```

本体は `OpenCode/plugins/strata-server-info.js`。配置先の
`~/.config/opencode/plugins/strata-server-info.js` は、本体を読み込む短いファイルになる。
シンボリックリンクや管理者権限は不要。Gitで本体を更新すると、次のOpenCodeバックエンド起動から使われる。
リポジトリを移動した場合は `setup.ps1` を再実行する。

既存の配置ファイルは、変更が必要な場合だけ `~/.config/opencode/plugin-backups/` に退避する。
他のプラグイン、`opencode.json`、認証情報は変更しない。再実行して内容が同じなら何もしない。

## 動作

- 既存の `provider.strata.options.baseURL` と同じサーバーの `/health` を、起動時に一度取得する。
- 実モデルID、表示名、コンテキスト上限をメモリ上の設定へ反映する。保存済みの会話で使う別名キーは維持する。
- 出力上限などの既存設定は維持し、明示的な入力上限は収まる範囲に制限する。自動圧縮には更新後の上限が使われる。
- 5秒以内に取得できない、モデルがロード中、出力上限が収まらない場合は、その起動中のStrataだけを無効にして理由をログへ残す。
- 推論、設定JSONへの書き戻し、常駐監視は行わない。画像・ツール対応などの能力は変更しない。

Strataのモデルや上限を変更した場合はOpenCodeバックエンドを起動し直す。
稼働中のバックエンドへ画面を接続し直すだけでは再取得されない。

## 確認

追加パッケージは不要。Node.js 20以降でローカル検証できる。

```powershell
node .\OpenCode\tests\verify-startup.mjs
opencode models strata --verbose
```

2番目は実際のサーバー情報を取り込んだモデル一覧を表示し、推論は行わない。

## 戻す場合

配置先の `strata-server-info.js` を `plugins` の外へ退避し、必要ならバックアップを戻してOpenCodeを起動し直す。

## 参照

- https://opencode.ai/docs/plugins/#from-local-files
- https://github.com/anomalyco/opencode/blob/v1.17.14/packages/opencode/src/provider/provider.ts
- https://github.com/Niko1221/Strata/blob/main/docs/DETAILS.md
