param([switch]$ForStore)
$ErrorActionPreference = 'Stop'
$appRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$policy = Get-Content -LiteralPath (Join-Path $appRoot 'assets/legal/privacy.json') -Raw | ConvertFrom-Json
if ($ForStore -and ([string]::IsNullOrWhiteSpace($policy.publisher) -or [string]::IsNullOrWhiteSpace($policy.supportEmail))) {
    throw 'Store release blocked: publisher name and support email have not been supplied.'
}
if ($ForStore -and $policy.publicationApproved -ne $true) {
    throw 'Store release blocked: confirm privacy policy, including backup and log retention, before publication.'
}
if ($ForStore -and $policy.retention.hostingVerified -ne $true) {
    throw 'Store release blocked: actual hosting retention has not been verified.'
}
function Escape-Html([string]$value) { [System.Net.WebUtility]::HtmlEncode($value) }
function Render-Policy([string]$language) {
    $content = $policy.$language
    $html = '<h1>' + (Escape-Html $content.title) + '</h1><p>' + (Escape-Html $policy.updated) + '</p>'
    if ($policy.publicationApproved -ne $true) { $html += '<p class="warning">' + (Escape-Html $content.draft) + '</p>' }
    if ($policy.publisher -and $policy.supportEmail) {
        $html += '<p>' + (Escape-Html $policy.publisher) + ' · ' + (Escape-Html $policy.supportEmail) + '</p>'
    }
    foreach ($section in $content.sections) { $html += '<h2>' + (Escape-Html $section.title) + '</h2><p>' + (Escape-Html $section.text) + '</p>' }
    return $html
}
$envLines = Get-Content -LiteralPath (Join-Path $appRoot 'assets/env/.env')
$apiLine = $envLines | Where-Object { $_ -match '^BASE_URL_WEB=' } | Select-Object -First 1
if (!$apiLine) { throw 'Missing public BASE_URL_WEB.' }
$apiBase = $apiLine.Substring('BASE_URL_WEB='.Length).Trim()
if ($apiBase -notmatch '^https://[^\s]+/api/v1/?$') { throw 'Public deletion page requires an HTTPS API URL ending in /api/v1.' }
$privacy = (Get-Content -LiteralPath (Join-Path $PSScriptRoot 'privacy.template.html') -Raw).Replace('{{RU_CONTENT}}', (Render-Policy 'ru')).Replace('{{EN_CONTENT}}', (Render-Policy 'en'))
$deletion = (Get-Content -LiteralPath (Join-Path $PSScriptRoot 'deletion.template.html') -Raw).Replace('{{API_BASE}}', (Escape-Html $apiBase))
foreach ($page in @(@{Name='privacy';Html=$privacy}, @{Name='account-deletion';Html=$deletion})) {
    $directory = Join-Path $appRoot ('web/' + $page.Name)
    New-Item -ItemType Directory -Force -Path $directory | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $directory 'index.html'), $page.Html, [System.Text.UTF8Encoding]::new($false))
}
Write-Host 'Public privacy and authenticated account-deletion pages generated.'
