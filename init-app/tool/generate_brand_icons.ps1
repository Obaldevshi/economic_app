# Original, code-drawn icon. No downloaded or third-party imagery is used.
Add-Type -AssemblyName System.Drawing

$appRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$sourcePath = Join-Path $appRoot 'assets/images/app_icon.png'
$webRoot = Join-Path $appRoot 'web'
$size = 1024
$bitmap = [System.Drawing.Bitmap]::new($size, $size)
$canvas = [System.Drawing.Graphics]::FromImage($bitmap)
$canvas.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$canvas.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

$background = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#272D34'))
$canvas.FillRectangle($background, 0, 0, $size, $size)

$coin = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#E58B60'))
$canvas.FillEllipse($coin, 432, 176, 288, 288)
$coinDetail = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#965238'), 16)
$coinDetail.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$coinDetail.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$coinDetail.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$canvas.DrawEllipse($coinDetail, 468.8, 212.8, 214.4, 214.4)
$pocket = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#FFFCF6'), 76.8)
$pocket.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$pocket.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$pocket.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$outline = [System.Drawing.Drawing2D.GraphicsPath]::new()
$outline.AddLine(224, 448, 224, 608)
$outline.AddBezier(224, 608, 224, 736, 352, 832, 512, 832)
$outline.AddBezier(512, 832, 672, 832, 800, 736, 800, 608)
$outline.AddLine(800, 608, 800, 448)
$canvas.DrawPath($pocket, $outline)
$points = [System.Drawing.PointF[]]@(
    [System.Drawing.PointF]::new(224, 448),
    [System.Drawing.PointF]::new(512, 640),
    [System.Drawing.PointF]::new(800, 448)
)
$canvas.DrawLines($pocket, $points)
$canvas.Dispose()
$pocket.Dispose()
$outline.Dispose()
$coinDetail.Dispose()
$coin.Dispose()
$background.Dispose()
$bitmap.Save($sourcePath, [System.Drawing.Imaging.ImageFormat]::Png)

function Save-ScaledIcon([int]$pixelSize, [string]$targetPath) {
    $output = [System.Drawing.Bitmap]::new($pixelSize, $pixelSize)
    $graphics = [System.Drawing.Graphics]::FromImage($output)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.DrawImage($bitmap, 0, 0, $pixelSize, $pixelSize)
    $graphics.Dispose()
    $output.Save($targetPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $output.Dispose()
}

Save-ScaledIcon 64 (Join-Path $webRoot 'favicon.png')
Save-ScaledIcon 192 (Join-Path $webRoot 'icons/Icon-192.png')
Save-ScaledIcon 512 (Join-Path $webRoot 'icons/Icon-512.png')
Save-ScaledIcon 192 (Join-Path $webRoot 'icons/Icon-maskable-192.png')
Save-ScaledIcon 512 (Join-Path $webRoot 'icons/Icon-maskable-512.png')
$bitmap.Dispose()
