# 1. Ceļš uz log failu
$logPath = Join-Path $home "Documents\Maintenance.log"
$timestamp = Get-Date -Format "dd.MM.yyyy HH:mm:ss"

# 2. Iegūst diskus drošā veidā
$disk = Get-Volume -DriveLetter C -ErrorAction SilentlyContinue

# Pārbaude: vai disks eksistē un vai tā izmērs nav 0
if ($null -ne $disk -and $disk.Size -gt 0) {
    
    $freePercent = ($disk.SizeRemaining / $disk.Size) * 100
    
    if ($freePercent -lt 25) {
        # Saglabājam brīvo vietu pirms tīrīšanas
        $bytesBefore = $disk.SizeRemaining

        # Tīrīšana (TEMP un Recycle Bin)
        Get-ChildItem $env:TEMP -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Clear-RecycleBin -DriveLetter C -Confirm:$false -ErrorAction SilentlyContinue

        # Pārmērām vietu pēc tīrīšanas
        $diskAfter = Get-Volume -DriveLetter C
        $bytesAfter = $diskAfter.SizeRemaining
        
        $freedBytes = $bytesAfter - $bytesBefore
        $freedGB = [Math]::Round($freedBytes / 1GB, 2)

        $logMessage = "[$timestamp] Cleanup completed. $freedGB GB freed."
    } else {
        $logMessage = "[$timestamp] Space sufficient."
    }
} else {
    $logMessage = "[$timestamp] Error: Could not read C: drive info."
}

# Ieraksta log failā
Add-Content -Path $logPath -Value $logMessage
