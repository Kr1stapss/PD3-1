$defenderStatus = Get-MpComputerStatus

$isRealTimeOff = $defenderStatus.RealTimeProtectionEnabled -eq $false
$isScanOld = $defenderStatus.QuickScanAge -gt 3

if ($isRealTimeOff -or $isScanOld) {
    Write-Host "Sistema ir apdraudeta!" -ForegroundColor Red
} else {
    Write-Host "Sistema ir drosa." -ForegroundColor Green
}
