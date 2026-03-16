$topProcesses = Get-Process |
    Where-Object { $_.Name -ne 'svchost' } |
    Sort-Object -Property WS -Descending |
    Select-Object -First 5

$totalBytes = ($topProcesses | Measure-Object -Property WS -Sum).Sum

$totalMB = [Math]::Round($totalBytes / 1MB, 1)

Write-Host "Top 5 processes total RAM: $($totalMB) MB"
