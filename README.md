# Перевіряльник кошторисів підрядників — віртуальний працівник (Claude Code, шлях 1)

Бонус WS10 курсу «Modern Development with Agentic AI», продукт property-workflows. Звіт і докази —
[`docs/worker/README.md`](docs/worker/README.md). Дані — лише синтетичні.

Рахує скрипт (`scripts/check-estimate.mjs`), перевіряє незалежний субагент (`estimate-verifier`), Claude Code керує
процесом і пише звіт у `out/`. Погоджує й оплачує — лише менеджер.

```bash
node --test tests/golden.test.mjs                        # golden data без моделі
node scripts/check-estimate.mjs data/2026-11-batch-b     # чекліст пакета: таблиця, ###JSON###, код 0 / 1 / 2
claude                                                   # інтерактивно: /estimate-checker data/2026-11-batch-b
powershell -NoProfile -ExecutionPolicy Bypass -File .\run.ps1 -Batch 2026-11-batch-b   # без людини
```

Основа — `koldovsky/2026-quitcode-10-ai-features-hw/materials/worker-claude-code`.
