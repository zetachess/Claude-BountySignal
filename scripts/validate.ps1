param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'
Set-Location $Root

$manifest = Get-Content '.claude-plugin/plugin.json' -Raw | ConvertFrom-Json
if ($manifest.name -ne 'claude-bountysignal') { throw 'Unexpected plugin name.' }
if ($manifest.displayName -ne 'Claude-BountySignal') { throw 'Unexpected display name.' }
if ($manifest.version -ne '0.1.0') { throw 'Unexpected version.' }

$required = @(
    'README.md',
    'LICENSE',
    'SECURITY.md',
    'CONTRIBUTING.md',
    'CHANGELOG.md',
    'assets/claude-bountysignal-hero.png',
    'skills/hunt-auth-bypass/SKILL.md',
    'commands/auth-audit.md',
    'commands/auth-validate.md',
    'commands/auth-report.md',
    'templates/vulnerability-report.md',
    'docs/social-preview.md',
    'evals/cases/README.md'
)

foreach ($file in $required) {
    if (-not (Test-Path $file)) { throw "Missing required file: $file" }
}

$stale = rg -n 'GateProof|gateproof-auth-review' . --glob '!scripts/validate.ps1' --glob '!.git/**' 2>$null
if ($LASTEXITCODE -eq 0 -and $stale) { throw "Stale identity reference found:`n$stale" }

$forbidden = rg -n '(BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY|ghp_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{20,})' . --glob '!.git/**' 2>$null
if ($LASTEXITCODE -eq 0 -and $forbidden) { throw "Possible secret found:`n$forbidden" }

$caseCount = (Get-ChildItem 'evals/cases' -Filter '*.md' | Where-Object { $_.Name -ne 'README.md' }).Count
if ($caseCount -lt 7) { throw 'Expected at least seven synthetic evaluation cases.' }

Write-Output "Claude-BountySignal validation passed. Evaluation cases: $caseCount."
