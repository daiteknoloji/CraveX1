# Make User Admin on Railway PostgreSQL
# Usage: .\MAKE-USER-ADMIN.ps1 -Username "yourusername"

param(
    [Parameter(Mandatory=$true)]
    [string]$Username
)

Write-Host ""
Write-Host "MAKING USER ADMIN ON RAILWAY" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""

# Railway PostgreSQL variables from environment or manual input
Write-Host "Enter Railway PostgreSQL connection info:" -ForegroundColor Yellow
Write-Host "(Find in Railway Dashboard -> Postgres -> Variables)" -ForegroundColor Gray
Write-Host ""

$PGHOST = Read-Host "PGHOST (e.g. containers-us-west-xxx.railway.app)"
$PGPORT = Read-Host "PGPORT (default: 5432)"
$PGUSER = Read-Host "PGUSER (default: postgres)"
$PGPASSWORD = Read-Host "PGPASSWORD" -AsSecureString
$PGDATABASE = Read-Host "PGDATABASE (default: railway)"

# Convert secure string to plain text
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PGPASSWORD)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Full user ID with domain
$fullUserId = "@$Username`:cravex1-production.up.railway.app"

Write-Host ""
Write-Host "Connecting to PostgreSQL..." -ForegroundColor Yellow

# SQL Query
$query = "UPDATE users SET admin = 1 WHERE name = '$fullUserId';"

# psql command (requires PostgreSQL client)
$env:PGPASSWORD = $PlainPassword

try {
    $result = & psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c $query 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "SUCCESS! User is now ADMIN!" -ForegroundColor Green
        Write-Host "=============================" -ForegroundColor Green
        Write-Host "User: $fullUserId" -ForegroundColor White
        Write-Host ""
        Write-Host "You can now login to Synapse Admin:" -ForegroundColor Yellow
        Write-Host "https://cravex-admin.netlify.app" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host "ERROR: Could not update user" -ForegroundColor Red
        Write-Host $result
    }
} catch {
    Write-Host ""
    Write-Host "ERROR: psql not found!" -ForegroundColor Red
    Write-Host "Install PostgreSQL client or use Railway web console" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Alternative: Use Railway Dashboard -> Postgres -> Data tab" -ForegroundColor Cyan
    Write-Host "Run this SQL query:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  UPDATE users SET admin = 1 WHERE name = '$fullUserId';" -ForegroundColor White
    Write-Host ""
}



