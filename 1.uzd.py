$procesi = Get-Process | Where-Object {$_.ProcessName -ne "svchost"} | Sort-Object WorkingSet -Descendig | Select-Object -First 5

$summa = 0
foreach ($p in $procsi){
%ram = [math]::Round($p.WorkingSet / 1MB,2)
$summa += $ram
}

Write-Output "Top 5 procesu total RAM: $summa MB"
