$source = "$env:USERPROFILE\Documents\Errors.txt"
$date = Get-Date -Format "yyyy-MM-dd"
$zip = "$env:USERPROFILE\Documents\Atskaite_$date.zip"

Compress-Archive $source $zip -Force

$size = (Get-Item $zip).Length / 1KB
Write-Output "Arhīva izmērs: $([math]::Round($size,2)) KB"
