# Strata を止めて GPU を空け、ComfyUI で画像を1枚作り、Strata を元に戻す。各工程の秒数を runs\ に JSON で残す。
# 生成が失敗しても finally で ComfyUI を止め、Strata は止める前に動いていた時だけ必ず戻す。
# 手動: -Prompt で渡す。OpenCode から: -RequestFile (JSON: prompt/width/height/steps/references) と -ResultFile で渡す。
# references は WORK2 上の画像パス (最大3枚)。ComfyUI\input に写して参照画像ワークフローで生成する。
param(
    [string]$Prompt,
    [string]$RequestFile,
    [string]$ResultFile,
    [string]$Profile = 'orca-iq4_xs-256k',
    [int]$Width = 1024,
    [int]$Height = 1024,
    [int]$Steps = 16
)
$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = 'E:\local-image-generation'
$strata = 'D:\local-llm\Strata\terminal\current\bin\strata.cmd'
$python = Join-Path $root 'ComfyUI_windows_portable\python_embeded\python.exe'
$runs = Join-Path $here 'runs'
New-Item -ItemType Directory -Path $runs -Force | Out-Null

if ($RequestFile) {
    $req = [IO.File]::ReadAllText($RequestFile, [Text.Encoding]::UTF8) | ConvertFrom-Json
    $Prompt = $req.prompt
    if ($req.width) { $Width = [int]$req.width }
    if ($req.height) { $Height = [int]$req.height }
    if ($req.steps) { $Steps = [int]$req.steps }
    $References = @($req.references | Where-Object { $_ } | Select-Object -First 3)
}

$result = [ordered]@{ started = (Get-Date).ToString('s'); profile = $Profile; prompt = $Prompt; seconds = [ordered]@{}; vram_used_mib = [ordered]@{} }

function Measure-Step([string]$name, [scriptblock]$body) {
    $sw = [Diagnostics.Stopwatch]::StartNew()
    try { & $body } finally { $result.seconds[$name] = [math]::Round($sw.Elapsed.TotalSeconds, 1) }
}
function Get-VramUsed { [int](nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | Select-Object -First 1) }
function Invoke-Strata([string[]]$arguments) {
    $out = & $strata @arguments 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0) { throw "strata $($arguments -join ' ') failed ($LASTEXITCODE): $out" }
    $out
}

# Strata は WMI (Win32_Process.Create) で起動する。SSH から呼ばれた時、普通に起動すると SSH セッションの
# Job Object に入り、切断と同時に owner host ごと殺される (2026-11-03 実測: owner_host_lost)。
# WMI で作ったプロセスは WmiPrvSE の子になり、呼び出し元の Job の外で生まれる。
# 起動は待たずに返し、ready になるまで状態を見て待つ (合計 20 分まで)。
function Start-Llm([string]$name) {
    $startLog = Join-Path $runs 'llm-start.log'
    $cmdline = "cmd.exe /c `"`"$strata`" runtime start --profile $name --wait 600 > `"$startLog`" 2>&1`""
    $created = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = $cmdline }
    if ($created.ReturnValue -ne 0) { throw "Win32_Process.Create failed with code $($created.ReturnValue)" }
    $started = Get-Date
    while (((Get-Date) - $started).TotalMinutes -lt 20) {
        Start-Sleep -Seconds 2
        $s = try { (& $strata runtime status --profile $name --json 2>$null | Out-String | ConvertFrom-Json).state } catch { 'unknown' }
        if ($s -eq 'ready') { return }
        # 起動直後はまだ stopped と出るので、1分経っても上がらない時だけ失敗とみなす
        if ($s -in @('failed', 'stale') -or ($s -eq 'stopped' -and ((Get-Date) - $started).TotalSeconds -gt 60)) {
            throw "Strata did not come up (state=$s). See $startLog"
        }
    }
    throw 'Strata did not become ready within 20 minutes'
}

$wasRunning = $false
$comfyStarted = $false
$lock = $null
try {
    if (-not $Prompt) { throw 'prompt is empty' }
    # 同時に2本走ると GPU とStrataの止め戻しが壊れるので、1本ずつに限る。ロックはプロセス終了で OS が外す。
    try { $lock = [IO.File]::Open((Join-Path $runs 'swap.lock'), 'OpenOrCreate', 'ReadWrite', 'None') }
    catch { throw 'another swap is already running' }
    # 参照画像は Strata を止める前に確かめる。無ければ何も止めずに失敗を返す。
    $refNames = @()
    foreach ($refSrc in @($References | Where-Object { $_ })) {
        if (-not (Test-Path -LiteralPath $refSrc)) { throw "reference image not found: $refSrc" }
        $refName = 'gpu-swap-ref-' + [IO.Path]::GetFileName($refSrc)
        Copy-Item -LiteralPath $refSrc -Destination (Join-Path $root "ComfyUI_windows_portable\ComfyUI\input\$refName") -Force
        $refNames += $refName
    }
    $result.references = $refNames
    $status =(& $strata runtime status --profile $Profile --json 2>$null | Out-String)
    $state = try { ($status | ConvertFrom-Json).state } catch { 'unknown' }
    $result.strata_state_before = $state
    $wasRunning = $state -notin @('stopped', 'stale', 'failed', 'cleaned', 'unknown')
    # デスクトップの「Strata 4bit」(strata serve の前面起動) は runtime の管理外なので止められない。GPU を取り合う前に止まる。
    if (-not $wasRunning -and (Get-NetTCPConnection -State Listen -LocalPort 8090 -ErrorAction SilentlyContinue)) {
        throw 'Strata is serving on :8090 outside runtime (desktop shortcut?). Close it or start it with runtime start.'
    }
    $result.vram_used_mib.before = Get-VramUsed

    if ($wasRunning) {
        Measure-Step 'llm_stop' { Invoke-Strata @('runtime', 'stop', '--profile', $Profile, '--wait', '300', '--quiet') | Out-Null }
    }
    $result.vram_used_mib.after_llm_stop = Get-VramUsed

    Measure-Step 'image_load' {
        & (Join-Path $root 'start_comfyui.ps1') | Out-Null
        $script:comfyStarted = $true
        $deadline = (Get-Date).AddSeconds(300)
        while ($true) {
            try { Invoke-RestMethod 'http://127.0.0.1:8188/system_stats' -TimeoutSec 3 | Out-Null; break } catch { }
            if ((Get-Date) -gt $deadline) { throw 'ComfyUI did not become ready within 300s' }
            Start-Sleep -Milliseconds 500
        }
    }

    Measure-Step 'image_generate' {
        # PowerShell 5.1 は外部コマンドの引数内の " を正しく渡せないので、プロンプトはファイルで渡す
        $promptFile = Join-Path $runs ('prompt-' + [guid]::NewGuid().ToString('N') + '.txt')
        [IO.File]::WriteAllText($promptFile, $Prompt, (New-Object Text.UTF8Encoding $false))
        $genArgs = @((Join-Path $here 'generate_image.py'), '--prompt-file', $promptFile, '--width', $Width, '--height', $Height, '--steps', $Steps, '--prefix', 'gpu-swap')
        foreach ($n in $refNames) { $genArgs += @('--ref', $n) }
        try { $json = & $python @genArgs | Out-String } finally { Remove-Item -LiteralPath $promptFile -ErrorAction SilentlyContinue }
        $gen = $json | ConvertFrom-Json
        if (-not $gen.ok) { throw "generation failed: $json" }
        # start_comfyui.ps1 は保存先を指定しないので ComfyUI\output に出る。デスクトップ起動 (--output-directory) なら output。実在する方を返す。
        $outDirs = @("$root\ComfyUI_windows_portable\ComfyUI\output", "$root\output")
        $result.images = @($gen.images | ForEach-Object {
            $img = $_
            $outDirs | ForEach-Object { Join-Path (Join-Path $_ $img.subfolder) $img.filename } | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
        })
        if ($result.images.Count -ne @($gen.images).Count) { throw "generated image not found in: $($outDirs -join ', ')" }
    }
    $result.vram_used_mib.peak_image = Get-VramUsed
    $result.ok = $true
}
catch {
    $result.ok = $false
    $result.error = $_.Exception.Message
}
finally {
    if ($comfyStarted) {
        Measure-Step 'image_unload' { & (Join-Path $root 'stop_comfyui_dynamic.ps1') | Out-Null }
    }
    $result.vram_used_mib.after_image_unload = Get-VramUsed
    if ($wasRunning) {
        try {
            Measure-Step 'llm_start' { Start-Llm $Profile }
            $result.llm_restored = $true
        }
        catch { $result.llm_restored = $false; $result.llm_error = $_.Exception.Message }
    }
    $result.vram_used_mib.end = Get-VramUsed
    $result.finished = (Get-Date).ToString('s')
    $log = Join-Path $runs ((Get-Date).ToString('yyyyMMdd-HHmmss') + '.json')
    $text = $result | ConvertTo-Json -Depth 5
    [IO.File]::WriteAllText($log, $text, (New-Object Text.UTF8Encoding $true))
    if ($ResultFile) {
        # 待っている側が書きかけを読まないよう、別名で書いてから置き換える
        [IO.File]::WriteAllText("$ResultFile.tmp", $text, (New-Object Text.UTF8Encoding $false))
        Move-Item -LiteralPath "$ResultFile.tmp" -Destination $ResultFile -Force
    }
    if ($lock) { $lock.Dispose() }
    $text
}
