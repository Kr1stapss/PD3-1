# 3_drosiba.ps1
# Iegūst Microsoft Defender statusu
$status = Get-MpComputerStatus

# Definē mainīgos no statusa objekta
$rtp = $status.RealTimeProtectionEnabled
$scanAge = $status.QuickScanAge

# Pārbauda nosacījumus: 
# 1. Vai reālā laika aizsardzība ir izslēgta ($false)
# 2. Vai kopš pēdējās ātrās skenēšanas pagājušas vairāk nekā 3 dienas
if ($rtp -eq $false -or $scanAge -gt 3) {
    Write-Host "System is at risk!" -ForegroundColor Red
}
else {
    Write-Host "System is safe." -ForegroundColor Green
}
