param([Parameter(Mandatory=$true)][string]$OutputDirectory)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$appRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$output = (Resolve-Path -LiteralPath $OutputDirectory).Path
$icon = [System.Drawing.Image]::FromFile((Join-Path $appRoot 'web/icons/Icon-512.png'))
$canvas = [System.Drawing.Bitmap]::new(1024,500,[System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$graphics = [System.Drawing.Graphics]::FromImage($canvas)
$ink = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#272D34'))
$copper = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#AD6848'))
$pale = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#DED6C8'))
$line = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#272D34'),3)
try {
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.Clear([System.Drawing.ColorTranslator]::FromHtml('#F3EFE7'))
    $graphics.DrawImage($icon, 70,90,320,320)
    # Original, font-free visual: one avoided purchase becomes a growing reserve.
    $graphics.DrawLine($line,460,380,954,380)
    for ($column=0; $column -lt 6; $column++) {
        $height = 20 + 7*$column*$column
        $graphics.FillRectangle($pale,480+76*$column,380-$height,42,$height)
        $graphics.FillEllipse($copper,485+76*$column,365-$height,32,12)
    }
    $graphics.FillEllipse($ink, 462,180,14,14)
    $graphics.DrawLine($line,484,187,596,187)
    $canvas.Save((Join-Path $output 'feature-graphic-1024x500.png'),[System.Drawing.Imaging.ImageFormat]::Png)
    $icon.Save((Join-Path $output 'store-icon-512.png'),[System.Drawing.Imaging.ImageFormat]::Png)
} finally { $line.Dispose();$pale.Dispose();$copper.Dispose();$ink.Dispose();$graphics.Dispose();$canvas.Dispose();$icon.Dispose() }
Write-Host 'Original store icon and feature graphic generated; no third-party images or embedded fonts.'
