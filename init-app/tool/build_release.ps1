param([ValidateSet('Preview', 'Signed', 'Store')][string]$Mode = 'Preview')
$ErrorActionPreference = 'Stop'
$appRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$flutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
if (!$flutterCommand) { throw 'Flutter must be available in PATH.' }
if ($Mode -ne 'Preview' -and !(Test-Path -LiteralPath (Join-Path $appRoot 'android/key.properties'))) {
    throw 'Store build requires your permanent release signing key in android/key.properties.'
}
Push-Location $appRoot
$previousPreviewSigning = $env:NOT_SPENT_PREVIEW_SIGNING
$previousUnsignedPreview = $env:NOT_SPENT_UNSIGNED_PREVIEW
$previousStorePassword = $env:NOT_SPENT_STORE_PASSWORD
$previousKeyPassword = $env:NOT_SPENT_KEY_PASSWORD
try {
    if ($Mode -ne 'Preview') {
        $credentialPath = Join-Path $appRoot 'android/signing/release-signing.clixml'
        if (Test-Path -LiteralPath $credentialPath) {
            $signingCredential = Import-Clixml -LiteralPath $credentialPath
            $env:NOT_SPENT_STORE_PASSWORD = $signingCredential.GetNetworkCredential().Password
            $env:NOT_SPENT_KEY_PASSWORD = $env:NOT_SPENT_STORE_PASSWORD
        }
    }
    Remove-Item Env:NOT_SPENT_UNSIGNED_PREVIEW -ErrorAction SilentlyContinue
    & (Join-Path $PSScriptRoot 'prepare_public_pages.ps1') -ForStore:($Mode -eq 'Store')
    $version = ((Get-Content pubspec.yaml | Where-Object { $_ -match '^version:' }) -replace '^version:\s*', '').Trim()
    $distribution = Join-Path $appRoot ('build/distribution/not-spent-' + $version.Replace('+', '-'))
    New-Item -ItemType Directory -Path $distribution -Force | Out-Null
    & $flutterCommand.Source build web --release
    if ($LASTEXITCODE -ne 0) { throw 'Web build failed.' }
    Compress-Archive -Path (Join-Path $appRoot 'build/web/*') -DestinationPath (Join-Path $distribution 'not-spent-web.zip') -Force
    if ($Mode -eq 'Preview') { $env:NOT_SPENT_PREVIEW_SIGNING = '1' }
    else { Remove-Item Env:NOT_SPENT_PREVIEW_SIGNING -ErrorAction SilentlyContinue }
    & $flutterCommand.Source build apk --release
    if ($LASTEXITCODE -ne 0) { throw 'APK build failed.' }
    $apkName = if ($Mode -eq 'Store') { 'not-spent-rustore.apk' } elseif ($Mode -eq 'Signed') { 'not-spent-release.apk' } else { 'not-spent-preview.apk' }
    Copy-Item -LiteralPath (Join-Path $appRoot 'build/app/outputs/flutter-apk/app-release.apk') -Destination (Join-Path $distribution $apkName)
    # Never silently put a debug signature in the bundle intended for Google Play.
    Remove-Item Env:NOT_SPENT_PREVIEW_SIGNING -ErrorAction SilentlyContinue
    if ($Mode -eq 'Preview') { $env:NOT_SPENT_UNSIGNED_PREVIEW = '1' }
    & $flutterCommand.Source build appbundle --release
    if ($LASTEXITCODE -ne 0) { throw 'AAB build failed.' }
    $bundleName = if ($Mode -eq 'Store') { 'not-spent-google-play.aab' } elseif ($Mode -eq 'Signed') { 'not-spent-release.aab' } else { 'not-spent-unsigned.aab' }
    Copy-Item -LiteralPath (Join-Path $appRoot 'build/app/outputs/bundle/release/app-release.aab') -Destination (Join-Path $distribution $bundleName)
    & (Join-Path $PSScriptRoot 'generate_store_artwork.ps1') -OutputDirectory $distribution
    Write-Host "Build artifacts: $distribution"
    if ($Mode -eq 'Preview') { Write-Warning 'Preview APK / unsigned AAB are not upload-ready store releases.' }
    if ($Mode -eq 'Signed') { Write-Warning 'Signed release candidate: privacy/hosting verification and store setup still required before publication.' }
} finally {
    if ($null -eq $previousPreviewSigning) { Remove-Item Env:NOT_SPENT_PREVIEW_SIGNING -ErrorAction SilentlyContinue }
    else { $env:NOT_SPENT_PREVIEW_SIGNING = $previousPreviewSigning }
    if ($null -eq $previousUnsignedPreview) { Remove-Item Env:NOT_SPENT_UNSIGNED_PREVIEW -ErrorAction SilentlyContinue }
    else { $env:NOT_SPENT_UNSIGNED_PREVIEW = $previousUnsignedPreview }
    if ($null -eq $previousStorePassword) { Remove-Item Env:NOT_SPENT_STORE_PASSWORD -ErrorAction SilentlyContinue }
    else { $env:NOT_SPENT_STORE_PASSWORD = $previousStorePassword }
    if ($null -eq $previousKeyPassword) { Remove-Item Env:NOT_SPENT_KEY_PASSWORD -ErrorAction SilentlyContinue }
    else { $env:NOT_SPENT_KEY_PASSWORD = $previousKeyPassword }
    $signingCredential = $null
    Pop-Location
}
