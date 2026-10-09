param([string]$Owner = 'Aleksey Roslyakov')
$ErrorActionPreference = 'Stop'
if (!$IsWindows -and $PSVersionTable.PSEdition -ne 'Desktop') { throw 'Windows DPAPI is required to protect the signing password.' }
$appRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$directory = Join-Path $appRoot 'android/signing'
$keyPath = Join-Path $directory 'not-spent-release.keystore'
$credentialPath = Join-Path $directory 'release-signing.clixml'
$keytool = Join-Path $env:ProgramFiles 'Android/Android Studio/jbr/bin/keytool.exe'
if (!(Test-Path -LiteralPath $keytool)) { throw 'Android Studio keytool was not found.' }
if ((Test-Path -LiteralPath $keyPath) -or (Test-Path -LiteralPath $credentialPath)) {
    throw 'Existing signing material found. It will NOT be replaced; keep the permanent key for updates.'
}
New-Item -ItemType Directory -Force -Path $directory | Out-Null
$randomBytes = [byte[]]::new(32)
$randomGenerator = [System.Security.Cryptography.RandomNumberGenerator]::Create()
try { $randomGenerator.GetBytes($randomBytes) } finally { $randomGenerator.Dispose() }
$password = [Convert]::ToBase64String($randomBytes)
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = [System.Management.Automation.PSCredential]::new('not-spent-release', $securePassword)
# Export-Clixml protects SecureString with Windows DPAPI for this user/machine.
$credential | Export-Clixml -LiteralPath $credentialPath
$previousStorePassword = $env:NOT_SPENT_STORE_PASSWORD
$previousKeyPassword = $env:NOT_SPENT_KEY_PASSWORD
try {
    $env:NOT_SPENT_STORE_PASSWORD = $password
    $env:NOT_SPENT_KEY_PASSWORD = $password
    & $keytool -genkeypair -noprompt -keystore $keyPath -storetype PKCS12 -alias not-spent-release -keyalg RSA -keysize 4096 -sigalg SHA256withRSA -validity 10000 -dname ('CN=' + $Owner) -storepass:env NOT_SPENT_STORE_PASSWORD -keypass:env NOT_SPENT_KEY_PASSWORD
    if ($LASTEXITCODE -ne 0) { throw 'Key generation failed. Existing private files were preserved; inspect them before retrying.' }
    & $keytool -exportcert -rfc -keystore $keyPath -alias not-spent-release -storepass:env NOT_SPENT_STORE_PASSWORD -file (Join-Path $directory 'release-certificate.pem')
    if ($LASTEXITCODE -ne 0) { throw 'Public certificate export failed.' }
    Write-Host 'Permanent RSA-4096 signing key created. The password is encrypted locally, not printed.'
    Write-Host 'Back up the keystore AND its password. The DPAPI credential only works for this Windows user/machine.'
} finally {
    if ($null -eq $previousStorePassword) { Remove-Item Env:NOT_SPENT_STORE_PASSWORD -ErrorAction SilentlyContinue }
    else { $env:NOT_SPENT_STORE_PASSWORD = $previousStorePassword }
    if ($null -eq $previousKeyPassword) { Remove-Item Env:NOT_SPENT_KEY_PASSWORD -ErrorAction SilentlyContinue }
    else { $env:NOT_SPENT_KEY_PASSWORD = $previousKeyPassword }
    $password = $null
    [Array]::Clear($randomBytes, 0, $randomBytes.Length)
}
