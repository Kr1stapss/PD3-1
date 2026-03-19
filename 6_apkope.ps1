# Definē ceļu uz žurnālfailu lietotāja Documents mapē
$logPath = Join-Path $home "Documents\Maintenance.log"

# Iegūst informāciju par C: disku
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$freePercent = ($disk.FreeSpace / $disk.Size) * 100

# Pašreizējais laiks formātā
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($freePercent -lt 25) {
    # Nomēra aizņemto vietu pirms tīrīšanas
    $sizeBefore = (Get-ChildItem $env:TEMP -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    
    # 1. Iztīra TEMP mapi
    Get-ChildItem $env:TEMP -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    
    # 2. Iztīra Atkritni (Recycle Bin)
    Clear-RecycleBin -DriveLetter C -Confirm:$false -ErrorAction SilentlyContinue
    
    # Nomēra aizņemto vietu pēc tīrīšanas (tiek pieņemts, ka starpība ir atbrīvotā vieta)
    # Tā kā Recycle Bin izmēru grūti precīzi nomērīt pirms dzēšanas ar standarta komandām, 
    # aprēķināsim pēc diska brīvās vietas izmaiņām:
    $diskAfter = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $freedBytes = $diskAfter.FreeSpace - $disk.FreeSpace
    $freedGB = [Math]::Round($freedBytes / 1GB, 2)

    $logMessage = "[$timestamp] Cleanup completed. $freedGB GB freed."
} else {
    $logMessage = "[$timestamp] Space sufficient."
}

# Ieraksta rezultātu log failā
Add-Content -Path $logPath -Value $logMessage
