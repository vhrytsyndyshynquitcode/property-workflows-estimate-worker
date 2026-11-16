# Запуск перевіряльника кошторисів без людини (Планувальник завдань Windows): claude -p (headless).
# Вхід — ваша підписка Claude (claude /login один раз). Лише для ОСОБИСТОГО використання (див. docs/worker/README.md).
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File .\run.ps1 -Batch 2026-11-batch-b
#
# Без --bare: він пропускає CLAUDE.md, скіли й .claude/agents і не читає вхід підпискою — працівника без них немає.
param(
  [string]$Batch = "2026-11-batch-b",
  [string]$ClaudeBin = "claude"
)
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

$stamp = Get-Date -Format "yyyy-MM-ddTHH-mm-ss"
New-Item -ItemType Directory -Force -Path "out\runs" | Out-Null
$outFile = "out\runs\$stamp.json"

# --permission-mode dontAsk: усе, що не дозволено явно, — відмова (без людини нема кому натиснути «так»).
# --allowedTools: те саме, що в .claude/settings.json; --max-turns: стеля кроків; --output-format json: кроки й вартість.
$allowed = "Skill(estimate-checker),Agent(estimate-verifier),Bash(node scripts/check-estimate.mjs *),PowerShell(node scripts/check-estimate.mjs *),Read,Grep,Glob,Edit(/out/**),Write(/out/**)"
$ErrorActionPreference = "Continue"
& $ClaudeBin -p "/estimate-checker data/$Batch" `
  --permission-mode dontAsk `
  --allowedTools $allowed `
  --max-turns 30 `
  --output-format json | Out-File -FilePath $outFile -Encoding utf8
$code = $LASTEXITCODE

Write-Output "Результат запуску: $outFile (код виходу $code); звіт — новий файл у out\"
exit $code
