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
function Render-PublicPage([string]$template, [hashtable]$replacements) {
    $html = Get-Content -LiteralPath (Join-Path $PSScriptRoot $template) -Raw
    foreach ($key in $replacements.Keys) { $html = $html.Replace('{{' + $key + '}}', [string]$replacements[$key]) }
    if ($html -match '\{\{[A-Z_]+\}\}') { throw "Unresolved public page placeholder in $template" }
    return $html
}
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
$publicValues = @{
    PUBLISHER = (Escape-Html $policy.publisher)
    SUPPORT_EMAIL = (Escape-Html $policy.supportEmail)
    UPDATED = (Escape-Html $policy.updated)
    RU_PUBLICATION_NOTICE = ''
    EN_PUBLICATION_NOTICE = ''
}
if ($policy.publicationApproved -ne $true) {
    $publicValues.RU_PUBLICATION_NOTICE = '<p class="warning">Подготовленная редакция для проверки оператором. Сведения о фактическом хранении резервных копий и журналов на хостинге ещё требуют подтверждения; см. политику конфиденциальности.</p>'
    $publicValues.EN_PUBLICATION_NOTICE = '<p class="warning">Prepared for operator review. Actual hosting retention for backups and technical logs still needs confirmation; see the privacy policy.</p>'
}
$privacyValues = $publicValues.Clone()
$privacyValues.RU_CONTENT = Render-Policy 'ru'
$privacyValues.EN_CONTENT = Render-Policy 'en'
$deletionValues = $publicValues.Clone()
$deletionValues.API_BASE = Escape-Html $apiBase
$pages = @(
    @{Name='privacy';Html=(Render-PublicPage 'privacy.template.html' $privacyValues)},
    @{Name='account-deletion';Html=(Render-PublicPage 'deletion.template.html' $deletionValues)},
    @{Name='about';Html=(Render-PublicPage 'about.template.html' $publicValues)},
    @{Name='terms';Html=(Render-PublicPage 'terms.template.html' $publicValues)},
    @{Name='support';Html=(Render-PublicPage 'support.template.html' $publicValues)}
)
foreach ($page in $pages) {
    $directory = Join-Path $appRoot ('web/' + $page.Name)
    New-Item -ItemType Directory -Force -Path $directory | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $directory 'index.html'), $page.Html, [System.Text.UTF8Encoding]::new($false))
}
Write-Host 'Public about, terms, support, privacy and authenticated account-deletion pages generated.'
