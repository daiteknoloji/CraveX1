# Start Cravex Admin Panel on Port 9000

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Cravex Admin Panel" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

cd "C:\Users\Can Cakir\Desktop\www-backup"

Write-Host "Stopping old processes..." -ForegroundColor Yellow
Get-Process python -ErrorAction SilentlyContinue | Where-Object {
    $_.Id -eq 13540 -or $_.Id -eq 3240 -or $_.Id -eq 5412
} | Stop-Process -Force -ErrorAction SilentlyContinue

Start-Sleep -Seconds 2

Write-Host "Starting admin panel..." -ForegroundColor Green
Write-Host ""
Write-Host "URL: http://localhost:9000" -ForegroundColor Cyan
Write-Host "Login: admin / admin123" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

python admin-panel-server.py

