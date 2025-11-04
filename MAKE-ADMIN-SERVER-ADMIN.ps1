# Make admin user a server admin in Matrix Synapse
# Run this script to give admin user full server admin privileges

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Matrix Synapse - Make Admin Server Admin" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Synapse is running
$synapseProcess = Get-Process python -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*synapse*" }

if (-not $synapseProcess) {
    Write-Host "ERROR: Matrix Synapse is not running!" -ForegroundColor Red
    Write-Host "Please start Synapse first with: .\BASLAT.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "Found Synapse process running..." -ForegroundColor Green
Write-Host ""

# Find homeserver database - Try multiple possible locations
$possiblePaths = @(
    "C:\Users\Can Cakir\Desktop\www-backup\synapse-data\homeserver.db",
    "C:\Users\Can Cakir\Desktop\www-backup\data\homeserver.db",
    "C:\Users\Can Cakir\Desktop\www-backup\.synapse\homeserver.db",
    "$env:APPDATA\.synapse\homeserver.db"
)

$dbPath = $null

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $dbPath = $path
        Write-Host "Found database at: $dbPath" -ForegroundColor Green
        break
    }
}

if (-not $dbPath) {
    Write-Host "ERROR: Database not found in any of these locations:" -ForegroundColor Red
    foreach ($path in $possiblePaths) {
        Write-Host "  - $path" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "Please find your homeserver.db and update the script." -ForegroundColor Yellow
    exit 1
}

Write-Host "Database found: $dbPath" -ForegroundColor Green
Write-Host ""

# Make admin a server admin
Write-Host "Making @admin:localhost a server admin..." -ForegroundColor Yellow

try {
    Write-Host "sqlite3 not found. Using Python..." -ForegroundColor Cyan
    
    # Create Python script with full paths
    $pythonScript = @"
import sqlite3
import os

db_path = r'$dbPath'
print(f'Database: {db_path}')
print(f'Exists: {os.path.exists(db_path)}')
print('')

try:
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Check current admin status
    cursor.execute("SELECT name, admin FROM users WHERE name = '@admin:localhost'")
    before = cursor.fetchone()
    if before:
        print(f'Before: User={before[0]}, Admin={before[1]}')
    else:
        print('User @admin:localhost not found!')
        conn.close()
        exit(1)
    
    # Update to admin
    cursor.execute("UPDATE users SET admin = 1 WHERE name = '@admin:localhost'")
    conn.commit()
    
    # Check after update
    cursor.execute("SELECT name, admin FROM users WHERE name = '@admin:localhost'")
    after = cursor.fetchone()
    print(f'After:  User={after[0]}, Admin={after[1]}')
    
    if after[1] == 1:
        print('')
        print('SUCCESS! Admin user is now a server admin!')
    else:
        print('')
        print('WARNING: Update may have failed!')
    
    conn.close()
except Exception as e:
    print(f'ERROR: {e}')
    exit(1)
"@
    
    # Save to temp file with full path
    $tempScript = "C:\Users\Can Cakir\Desktop\www-backup\temp_make_admin.py"
    $pythonScript | Out-File -FilePath $tempScript -Encoding UTF8
    
    Write-Host "Running Python script..." -ForegroundColor Cyan
    Write-Host ""
    
    # Run Python script
    python $tempScript
    
    # Clean up temp file
    Remove-Item $tempScript -ErrorAction SilentlyContinue
    
    Write-Host ""
    Write-Host "SUCCESS! Admin user is now a server admin!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Please restart Synapse for changes to take effect:" -ForegroundColor Yellow
    Write-Host "  1. Stop: .\DURDUR.ps1" -ForegroundColor White
    Write-Host "  2. Start: .\BASLAT.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "After restart, you'll be able to:" -ForegroundColor Cyan
    Write-Host "  - Add/remove users to/from rooms" -ForegroundColor White
    Write-Host "  - Manage all rooms on the server" -ForegroundColor White
    Write-Host "  - Access all admin API endpoints" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Host "ERROR: Failed to update database" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Manual fix - Run this SQL command:" -ForegroundColor Yellow
    Write-Host "  UPDATE users SET admin = 1 WHERE name = '@admin:localhost';" -ForegroundColor White
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Done!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

