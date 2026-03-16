#Requires -Module Microsoft.WinGet.Client
# Ensure the Microsoft.WinGet.Client module is installed and available
if (-not (Get-Module -ListAvailable -Name Microsoft.WinGet.Client)) {
    Write-Host "Installing Microsoft.WinGet.Client module..."
    try {
        Install-Module -Name Microsoft.WinGet.Client -Force -Scope CurrentUser -AllowClobber -SkipPublisherCheck | Out-Null
        Write-Host "Module installed. Please restart PowerShell session to use it."
        exit
    } catch {
        Write-Error "Failed to install Microsoft.WinGet.Client module. Ensure PowerShell Gallery is accessible and you have necessary permissions."
        exit
    }
}

# Import the module explicitly for use in the current session
Import-Module Microsoft.WinGet.Client -Force

Write-Host "Checking for available software updates using winget..." -ForegroundColor Cyan

# Get all packages with updates available and store them in a variable
$updates = Get-WinGetPackage | Where-Object { $_.IsUpdateAvailable }

# Count the number of updates
$updateCount = $updates.Count

# Output information about the software that can be updated
if ($updateCount -gt 0) {
    Write-Host "`nFound the following software with updates available:" -ForegroundColor Yellow
    # Display details of the updates
    $updates | Format-Table Name, InstalledVersion, AvailableVersion, Source

    Write-Host "`nThere are [$updateCount] programs on the system that need to be updated." -ForegroundColor Red
} else {
    Write-Host "`nThere are [0] programs on the system that need to be updated." -ForegroundColor Green
}

# Keep the window open if run outside of an interactive session, optional for your use case
# Read-Host -Prompt "Press Enter to exit"
