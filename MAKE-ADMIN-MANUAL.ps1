# QUICK FIX: Make admin a server admin
# Simplified version - just run this!

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "QUICK FIX: Make Admin Server Admin" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$workspacePath = "C:\Users\Can Cakir\Desktop\www-backup"

# Database locations to try
$dbLocations = @(
    "$workspacePath\synapse-data\homeserver.db",
    "$workspacePath\data\homeserver.db",
    "$workspacePath\.synapse\homeserver.db"
)

Write-Host "Searching for database..." -ForegroundColor Yellow

$dbPath = $null
foreach ($loc in $dbLocations) {
    Write-Host "  Checking: $loc" -ForegroundColor Gray
    if (Test-Path $loc) {
        $dbPath = $loc
        Write-Host "  FOUND!" -ForegroundColor Green
        break
    }
}

if (-not $dbPath) {
    Write-Host ""
    Write-Host "Database not found automatically." -ForegroundColor Red
    Write-Host "Please enter the full path to homeserver.db:" -ForegroundColor Yellow
    $dbPath = Read-Host "Path"
    
    if (-not (Test-Path $dbPath)) {
        Write-Host "ERROR: File not found!" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Using database: $dbPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "Updating admin user..." -ForegroundColor Yellow

# Python command with full path
$pythonCmd = @"
import sqlite3; 
conn = sqlite3.connect(r'$dbPath'); 
cursor = conn.cursor(); 
cursor.execute("SELECT name, admin FROM users WHERE name = '@admin:localhost'"); 
before = cursor.fetchone(); 
print(f'Before: {before}'); 
cursor.execute("UPDATE users SET admin = 1 WHERE name = '@admin:localhost'"); 
conn.commit(); 
cursor.execute("SELECT name, admin FROM users WHERE name = '@admin:localhost'"); 
after = cursor.fetchone(); 
print(f'After: {after}'); 
print('Admin status:', 'ENABLED' if after[1] == 1 else 'FAILED'); 
conn.close()
"@

python -c $pythonCmd

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DONE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Stop Synapse:  .\DURDUR.ps1" -ForegroundColor White
Write-Host "  2. Start Synapse: .\BASLAT.ps1" -ForegroundColor White
Write-Host "  3. Login again to admin panel" -ForegroundColor White
Write-Host "  4. Try adding members to rooms" -ForegroundColor White
Write-Host ""

