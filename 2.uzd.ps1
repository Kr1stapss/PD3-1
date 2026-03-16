$errors = Get-WinEvent -LogName System | Where-Object {$_.LevelDisplayName -eq "Error" -and $_.TimeCreated -gt (Get-Date).AddDays(-7)}

$file = "$env:USERPROFILE\Documents\Errors.txt"

if($errors.Count -gt 10){
"[KRITISKI] Sistēma ir nestabila!" | Out-File $file
}
else{
"[OK] Kļūdu līmenis normāls." | Out-File $file
}

$errors | Select TimeCreated, Message | Out-File $file -Append
