[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ImagePath,

    [string]$Folder = (Get-Date -Format 'yyyy/MM')
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$imageRoot = Join-Path $repoRoot 'source\images'
$resolvedImage = (Resolve-Path -LiteralPath $ImagePath).Path
$image = Get-Item -LiteralPath $resolvedImage

if ($image.PSIsContainer) {
    throw 'ImagePath must point to a file.'
}

$allowedExtensions = @('.png', '.jpg', '.jpeg', '.gif', '.webp', '.svg', '.avif')
if ($allowedExtensions -notcontains $image.Extension.ToLowerInvariant()) {
    throw "Unsupported image type: $($image.Extension). Use PNG, JPG, GIF, WEBP, SVG, or AVIF."
}

$cleanFolder = $Folder.Trim('/', '\')
if ([string]::IsNullOrWhiteSpace($cleanFolder) -or
    $cleanFolder -match '(^|[\\/])\.\.([\\/]|$)' -or
    $cleanFolder -match '^[\\/]' -or
    $cleanFolder -match '^[A-Za-z]:') {
    throw 'Folder must be a relative path inside source/images.'
}

$targetFolder = Join-Path $imageRoot ($cleanFolder -replace '/', '\')
New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null

$targetPath = Join-Path $targetFolder $image.Name
Copy-Item -LiteralPath $image.FullName -Destination $targetPath -Force

$relativePath = $targetPath.Substring($repoRoot.Length).TrimStart([char[]]('/\')) -replace '\\', '/'
$encodedPath = (($relativePath -split '/') | ForEach-Object { [Uri]::EscapeDataString($_) }) -join '/'
$cdnUrl = "https://cdn.jsdelivr.net/gh/JayAshore/jayashore.github.io@main/$encodedPath"

Write-Output "Copied: $relativePath"
Write-Output "CDN URL: $cdnUrl"
Write-Output "Markdown: ![$($image.BaseName)]($cdnUrl)"
