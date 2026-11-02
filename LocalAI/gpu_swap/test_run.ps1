# 試験用: Strata を runtime で起動して初回起動時間を計り、その後 swap_image を1回まわす。結果は runs\test-*.log
$ErrorActionPreference = 'Continue'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$log = Join-Path $here ('runs\test-' + (Get-Date).ToString('yyyyMMdd-HHmmss') + '.log')
New-Item -ItemType Directory -Path (Join-Path $here 'runs') -Force | Out-Null
Start-Transcript -Path $log | Out-Null

$sw = [Diagnostics.Stopwatch]::StartNew()
& D:\local-llm\Strata\terminal\current\bin\strata.cmd runtime start --profile orca-iq4_xs-256k --wait 600 --quiet
"cold_start_exit=$LASTEXITCODE"
while ($sw.Elapsed.TotalMinutes -lt 20) {
    $st = (& D:\local-llm\Strata\terminal\current\bin\strata.cmd runtime status --profile orca-iq4_xs-256k --json 2>$null | Out-String | ConvertFrom-Json).state
    if ($st -ne 'starting') { break }
    Start-Sleep -Seconds 2
}
"cold_start_state=$st seconds=$([math]::Round($sw.Elapsed.TotalSeconds,1))"
& D:\local-llm\Strata\terminal\current\bin\strata.cmd runtime status --profile orca-iq4_xs-256k --json

& (Join-Path $here 'swap_image.ps1') -Prompt 'A small cozy home laboratory at night, a desktop robot arm on a wooden workbench, warm lamp light, soft rain outside the window, anime illustration style'

& D:\local-llm\Strata\terminal\current\bin\strata.cmd runtime status --profile orca-iq4_xs-256k --json
Stop-Transcript | Out-Null
