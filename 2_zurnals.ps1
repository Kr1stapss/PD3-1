# Definē ceļu uz failu lietotāja Documents mapē
$filePath = "$HOME\Documents\Errors.txt"

# Iegūst kļūdas no System žurnāla par pēdējām 7 dienām
$startDate = (Get-Date).AddDays(-7)
$errors = Get-WinEvent -FilterHashtable @{LogName='System'; Level=2; StartTime=$startDate} -ErrorAction SilentlyContinue

# Sagatavo virsraksta ziņojumu atkarībā no kļūdu skaita
if ($errors.Count -gt 10) {
    $header = "[CRITICAL] System is unstable!"
} else {
    $header = "[OK] Error level is normal."
}

# Izveido faila saturu: vispirms virsraksts, tad kļūdu saraksts (laiks un ziņojums)
$report = New-Object System.Collections.Generic.List[string]
$report.Add($header)
$report.Add("-" * 30)

foreach ($err in $errors) {
    $report.Add("$($err.TimeCreated) - $($err.Message)")
}

# Saglabā visu informāciju failā Errors.txt
$report | Out-File -FilePath $filePath -Encoding utf8

Write-Host "Analīze pabeigta. Rezultāti saglabāti: $filePath"
