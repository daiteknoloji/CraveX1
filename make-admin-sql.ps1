# Make User Admin via Railway PostgreSQL
# Railway connection info from your message

param(
    [string]$Username = "admin"
)

$PGHOST = "switchyard.proxy.rlwy.net"
$PGPORT = "33707"
$PGUSER = "postgres"
$PGPASSWORD = "fzxOiBSFhSVzABvXQTYUplJbrlwyEBUh"
$PGDATABASE = "railway"

$fullUserId = "@$Username`:cravex1-production.up.railway.app"

Write-Host ""
Write-Host "Checking users in database..." -ForegroundColor Cyan
Write-Host ""

# Set password environment variable
$env:PGPASSWORD = $PGPASSWORD

# Check if psql exists
$psqlExists = Get-Command psql -ErrorAction SilentlyContinue

if (-not $psqlExists) {
    Write-Host "psql not found. Using alternative method..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "MANUAL SQL QUERY FOR RAILWAY:" -ForegroundColor Cyan
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Go to Railway Dashboard" -ForegroundColor White
    Write-Host "2. Install psql OR use this PowerShell method:" -ForegroundColor White
    Write-Host ""
    Write-Host "First, check existing users:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "SELECT name, admin FROM users;" -ForegroundColor Green
    Write-Host ""
    Write-Host "Then make your user admin:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "UPDATE users SET admin = 1 WHERE name = '$fullUserId';" -ForegroundColor Green
    Write-Host ""
    
    # Alternative: Use PostgreSQL .NET library
    Write-Host "OR use this direct connection string in any PostgreSQL tool:" -ForegroundColor Cyan
    Write-Host "postgresql://$PGUSER`:$PGPASSWORD@$PGHOST`:$PGPORT/$PGDATABASE" -ForegroundColor White
    Write-Host ""
    exit 0
}

# If psql exists, run the queries
Write-Host "Listing current users..." -ForegroundColor Yellow
& psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT name, admin FROM users;"

Write-Host ""
Write-Host "Making user admin..." -ForegroundColor Yellow
& psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "UPDATE users SET admin = 1 WHERE name = '$fullUserId';"

Write-Host ""
Write-Host "SUCCESS! User is now admin!" -ForegroundColor Green
Write-Host "User: $fullUserId" -ForegroundColor White
Write-Host ""



