$status = Get-MpComputerStatus

$real = $status.RealTimeProtectionEnabled
$scan = $status.QuickScanAge

if($real -eq $false -or $scan -gt 3){
Write-Output "Sistēma ir apdraudēta!"
}
else{
Write-Output "Sistēma ir droša."
}
