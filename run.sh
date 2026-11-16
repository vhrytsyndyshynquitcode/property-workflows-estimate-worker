#!/usr/bin/env bash
# Запуск перевіряльника кошторисів без людини (cron, CI): claude -p (headless).
# Вхід — ваша підписка Claude (claude /login один раз). Лише для ОСОБИСТОГО використання (див. docs/worker/README.md).
#
#   ./run.sh                     # пакет за замовчуванням data/2026-11-batch-b
#   ./run.sh 2026-11-batch-a     # інший пакет
set -euo pipefail
cd "$(dirname "$0")"
export MSYS_NO_PATHCONV=1   # Git Bash не перетворює «/estimate-checker» на шлях Windows

BATCH="${1:-2026-11-batch-b}"
CLAUDE_BIN="${CLAUDE_BIN:-claude}"
STAMP="$(date +%Y-%m-%dT%H-%M-%S)"
mkdir -p out/runs

set +e
"$CLAUDE_BIN" -p "/estimate-checker data/${BATCH}" \
  --permission-mode dontAsk \
  --allowedTools "Skill(estimate-checker),Agent(estimate-verifier),Bash(node scripts/check-estimate.mjs *),PowerShell(node scripts/check-estimate.mjs *),Read,Grep,Glob,Edit(/out/**),Write(/out/**)" \
  --max-turns 30 \
  --output-format json \
  > "out/runs/${STAMP}.json"
code=$?
set -e

echo "Результат запуску: out/runs/${STAMP}.json (код виходу ${code}); звіт — новий файл у out/"
exit "$code"
