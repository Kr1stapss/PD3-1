# Definē ceļu uz žurnālfailu (log file)
$logPath = "$home\Documents\Apkope.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Iegūst informāciju par C: disku
$drive = Get-PSDrive C
$totalSpace = $drive.Used + $drive.Free
$freePercent = ($drive.Free / $totalSpace) * 100

if ($freePercent -lt 25) {
    # Nomēra aizņemto vietu pirms tīrīšanas (TEMP un Recycle Bin)
    $sizeBefore = (Get-ChildItem $env:TEMP -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    # Piezīme: Recycle Bin precīza izmēra noteikšana caur PS ir ierobežota, tāpēc fokusējamies uz TEMP mapi

    # Veic tīrīšanu
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Clear-RecycleBin -Confirm:$false -ErrorAction SilentlyContinue

    # Aprēķina atbrīvoto vietu (salīdzinot diska brīvo vietu pēc procesa)
    $driveAfter = Get-PSDrive C
    $freedBytes = $driveAfter.Free - $drive.Free
    $freedGB = [Math]::Round($freedBytes / 1GB, 2)

    if ($freedGB -lt 0) { $freedGB = 0 }

    "[$timestamp] Cleanup completed. [$freedGB] GB freed." | Out-File -FilePath $logPath -Append
}
else {
    "[$timestamp] Enough space." | Out-File -FilePath $logPath -Append
}

