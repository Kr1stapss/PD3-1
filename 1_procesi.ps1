$topProcesses = Get-Process | 
    Where-Object { $_.ProcessName -ne "svchost" } | 
    Sort-Object WorkingSet64 -Descending | 
    Select-Object -First 5

$totalRam = ($topProcesses | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB

Write-Host "Top 5 processes total RAM: $($totalRam.ToString("F1")) MB"
