# gpu_swap（WORK2）

WORK2は Strata（ローカルLLM）と ComfyUI（画像生成）が同じGPU（RTX 5060 Ti 16GB）を取り合うので、同時には動かせない。
Strataを止めて画像を作り、Strataを戻す。OpenCodeからは `OpenCode/plugins/gpu-swap-image.js` の `generate_image` ツールで呼ぶ。

## ファイルと配置先（WORK2）

| ファイル | 配置先 | 役割 |
|---|---|---|
| `swap_image.ps1` | `E:\local-image-generation\gpu_swap\` | 入れ替え本体。Strata停止 → ComfyUI起動 → 生成 → ComfyUI停止 → Strata再起動 |
| `generate_image.py` | `E:\local-image-generation\gpu_swap\` | ComfyUI APIで Flux3 klein の画像を1枚作る。`--ref` で参照画像（`ComfyUI\input` のファイル名、最大3枚）を使う |
| `test_run.ps1` | `E:\local-image-generation\gpu_swap\` | 試運転用。Strataを起動してから入れ替えを1回 |
| `open_strata_4bit.cmd` | `E:\local-image-generation\` | デスクトップ「Strata 4bit」。`runtime start` でバックグラウンド起動 |
| `stop_strata_4bit.cmd` | `E:\local-image-generation\` | デスクトップ「Strata 4bit STOP」 |

WORK1から配置する（WORK2でgitは使わず、ファイルを送るだけ）:

```powershell
scp -P 50041 .\LocalAI\gpu_swap\swap_image.ps1 .\LocalAI\gpu_swap\generate_image.py .\LocalAI\gpu_swap\test_run.ps1 tikyu@work2.local:E:/local-image-generation/gpu_swap/
scp -P 50041 .\LocalAI\gpu_swap\open_strata_4bit.cmd .\LocalAI\gpu_swap\stop_strata_4bit.cmd tikyu@work2.local:E:/local-image-generation/
```

`swap_image.ps1` が使う既存の `E:\local-image-generation\start_comfyui.ps1` / `stop_comfyui_dynamic.ps1` はここでは管理していない。

## 守っていること

- **Strataは WMI（`Win32_Process.Create`）で起動する。** SSHから普通に起動すると、Windows版OpenSSHがセッションごとに作るJob Objectに入り、
  切断と同時に owner host ごと殺される（2026-11-03 実測: `owner_host_lost`。SSH内のPowerShellは `IsProcessInJob = True`）。
  WMIで作ったプロセスは WmiPrvSE の子になり、呼び出し元のJobの外で生まれる。
- Strataは `strata runtime start` で動いている必要がある。`strata serve`（前面起動）は runtime の管理外で止められないので、
  その状態を見つけたら何もせずに止まる。
- 生成が失敗しても ComfyUI は必ず止め、Strataは止める前に動いていた時だけ戻す。同時に2本は走らない（`runs\swap.lock`）。
- `runtime start --wait` は最大600秒。それで返っても `ready` になるまで状態を見て待つ（合計20分）。

## 記録

- 各回の秒数とVRAM使用量: `E:\local-image-generation\gpu_swap\runs\*.json`
- OpenCodeからの依頼と結果: `E:\local-image-generation\gpu_swap\requests\`
- 画像: `ComfyUI_windows_portable\ComfyUI\output\gpu-swap_*.png`（`start_comfyui.ps1` が保存先を指定しないため）

2026-11-03 実測（RAM 80GB）: LLM停止 7〜8秒、ComfyUI起動 16秒、生成 29〜31秒、ComfyUI停止 5秒、**LLM再起動 164〜171秒**。合計約4分。
