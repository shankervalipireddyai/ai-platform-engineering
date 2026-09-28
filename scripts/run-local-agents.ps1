# Start the CAIPE agent stack on Windows.
# Profiles and model settings come from .env (created from .env.example on first run).
$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $Root

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  throw "Docker is required. Start Docker Desktop, then run this script again."
}

if (-not (Test-Path -Path ".env")) {
  Copy-Item ".env.example" ".env"
  Write-Host "Created .env from .env.example."
}

$openaiKey = Select-String -Path ".env" -Pattern "^OPENAI_API_KEY=(.+)$" | Select-Object -First 1
if (-not $openaiKey) {
  Write-Host "OPENAI_API_KEY is empty in .env. The stack can start, but agents will not answer until a model key is set."
}

docker compose up -d
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

Write-Host "CAIPE UI: http://localhost:3000"
Write-Host "Dynamic agents API: http://localhost:8100"
