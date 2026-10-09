# Run Flutter through HTTP rather than opening the source index.html.
$ErrorActionPreference = 'Stop'
$appRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Push-Location $appRoot
try {
    Write-Host 'Local website: http://localhost:3000'
    Write-Host 'Keep this terminal open. Press Ctrl+C to stop.'
    & flutter run -d web-server --web-hostname 127.0.0.1 --web-port 3000
    if ($LASTEXITCODE -ne 0) { throw "Flutter exited with code $LASTEXITCODE" }
} finally {
    Pop-Location
}
