# Set the console output encoding to UTF8 to handle special characters correctly
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Checking for software updates using winget..." -ForegroundColor Cyan

# Run 'winget upgrade' and capture the output as a single string
# Using 'winget upgrade' without arguments lists all packages with available updates
$upgradeOutput = winget upgrade --accept-source-agreements | Out-String

# Split the output into individual lines
$lines = $upgradeOutput.Split([Environment]::NewLine)

# The output includes a header and a line showing the source update status. 
# We need to find the actual list of upgradable applications.
# The header line typically starts with "Name" or similar text. The lines that follow 
# (until a blank line or the end) represent the packages.
# A simpler way to count is to filter out the empty lines and header rows.

# Filter out empty lines and lines that are not package entries (e.g., the header or source update message)
# Package entries usually start with characters (e.g., 'Name' for the header, then the package names)
# We can use the fact that actual package lines are not empty and don't start with a specific non-package indicator.
# A more reliable method is to count lines that contain the word "upgrade" or just count non-empty lines after the header if the output format is consistent.

# The command 'winget list --upgrade-available' is better suited for counting, but the request asks for 'winget upgrade'.

# Let's process the raw output of 'winget upgrade'
$updateCount = 0
$inPackageList = $false

foreach ($line in $lines) {
    # Skip empty or whitespace-only lines
    if ([string]::IsNullOrWhiteSpace($line)) {
        continue
    }
    
    # Check for the line starting with "Name" which indicates the start of the package list header
    if ($line.Trim().StartsWith("Name")) {
        $inPackageList = $true
        continue
    }

    # If we are in the package list section and the line doesn't start with a non-package indicator (like progress bars or summary lines if they appear)
    if ($inPackageList) {
        # A simple check to ensure it's not a summary line which might appear at the end
        if (-not $line.Trim().StartsWith("Found") -and -not $line.Trim().StartsWith("No upgrades available")) {
             # Heuristic: The line should contain specific column data. Counting non-empty lines works if there are no extra lines.
             $updateCount++
        }
    }
}

# The above logic has issues with detecting the end of the list. 
# A more robust method involves using the Microsoft.WinGet.Client PowerShell module for object-based processing if possible.

# Alternative approach using the Microsoft.WinGet.Client module for easier, object-based counting:
try {
    Import-Module Microsoft.WinGet.Client -ErrorAction Stop

    $availableUpdates = Get-WinGetPackage | Where-Object { $_.IsUpdateAvailable }
    $count = $availableUpdates.Count
    Write-Host "`nTotal programs with updates available (via Module): $count" -ForegroundColor Green

} catch {
    Write-Host "`nCould not use the Microsoft.WinGet.Client module. Falling back to text parsing of 'winget upgrade' output." -ForegroundColor Yellow
    
    # Fallback to text processing
    # The 'winget upgrade' command output has a consistent structure. We can count the number of lines between the header and the end of output.
    # The output usually ends with a blank line.
    
    $packageLines = $lines | Where-Object { 
        -not [string]::IsNullOrWhiteSpace($_) -and 
        -not $_.Trim().StartsWith("Name") -and
        -not $_.Trim().StartsWith("---") -and # Filter out the separator line
        -not $_.Trim().StartsWith("No upgrades available") -and
        -not $_.Trim().StartsWith("Found") # Filter out summary lines
    }

    # Count the remaining lines
    $count = $packageLines.Count
    Write-Host "`nTotal programs with updates available (via Text Parsing): $count" -ForegroundColor Green
}

# Final output
Write-Host "Script finished." -ForegroundColor Cyan

