# Start AUTO-ADD-ADMIN script in background

$scriptPath = "C:\Users\Can Cakir\Desktop\www-backup\AUTO-ADD-ADMIN-TO-ROOMS.ps1"

Write-Host "Starting AUTO-ADD-ADMIN in background..." -ForegroundColor Cyan

# Start in a new hidden PowerShell window
$process = Start-Process powershell.exe -ArgumentList "-NoExit", "-ExecutionPolicy Bypass", "-File `"$scriptPath`"" -WindowStyle Minimized -PassThru

Write-Host "Started! Process ID: $($process.Id)" -ForegroundColor Green
Write-Host ""
Write-Host "To stop: Use Task Manager and kill process $($process.Id)" -ForegroundColor Yellow
Write-Host "Or run: Stop-Process -Id $($process.Id)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Check logs in the minimized PowerShell window." -ForegroundColor Cyan

