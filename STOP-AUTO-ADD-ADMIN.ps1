# Stop AUTO-ADD-ADMIN background process

Write-Host "Looking for AUTO-ADD-ADMIN processes..." -ForegroundColor Yellow

$processes = Get-Process powershell | Where-Object {
    $_.MainWindowTitle -like "*AUTO-ADD-ADMIN*" -or
    ($_.CommandLine -like "*AUTO-ADD-ADMIN-TO-ROOMS.ps1*")
}

if (-not $processes) {
    Write-Host "No AUTO-ADD-ADMIN process found." -ForegroundColor Gray
    
    # Show all PowerShell processes for manual selection
    Write-Host ""
    Write-Host "All PowerShell processes:" -ForegroundColor Cyan
    Get-Process powershell | Format-Table Id, ProcessName, StartTime -AutoSize
    
    Write-Host ""
    $processId = Read-Host "Enter Process ID to stop (or press Enter to cancel)"
    
    if ($processId) {
        Stop-Process -Id $processId -Force
        Write-Host "Process $processId stopped." -ForegroundColor Green
    }
} else {
    Write-Host "Found $($processes.Count) process(es):" -ForegroundColor Green
    $processes | Format-Table Id, ProcessName, StartTime -AutoSize
    
    Write-Host ""
    $confirm = Read-Host "Stop all these processes? (Y/N)"
    
    if ($confirm -eq "Y") {
        $processes | ForEach-Object {
            Stop-Process -Id $_.Id -Force
            Write-Host "Stopped process $($_.Id)" -ForegroundColor Green
        }
    }
}

