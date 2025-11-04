# Force add admin to rooms using database + Synapse API
# This creates proper Matrix events

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FORCE Add Admin to Rooms (Database + API)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

cd "C:\Users\Can Cakir\Desktop\www-backup"

# Get admin token
Write-Host "Getting admin token..." -ForegroundColor Yellow
$adminToken = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c "SELECT token FROM access_tokens WHERE user_id = '@admin:localhost' ORDER BY id DESC LIMIT 1;" 2>$null | ForEach-Object { $_.Trim() }

if (-not $adminToken) {
    Write-Host "ERROR: Admin token not found!" -ForegroundColor Red
    Write-Host "Please login to admin panel at http://localhost:5173" -ForegroundColor Yellow
    exit 1
}

Write-Host "Admin token: $adminToken" -ForegroundColor Green
Write-Host ""

# Get rooms where admin is not a member
Write-Host "Finding rooms without admin..." -ForegroundColor Yellow

$roomsQuery = @"
SELECT DISTINCT r.room_id 
FROM rooms r 
WHERE r.room_id NOT IN (
    SELECT room_id 
    FROM room_memberships 
    WHERE user_id = '@admin:localhost' AND membership = 'join'
)
AND EXISTS (
    SELECT 1 FROM room_memberships 
    WHERE room_id = r.room_id AND membership = 'join'
);
"@

$rooms = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c $roomsQuery 2>$null

if (-not $rooms) {
    Write-Host "Admin is already in all rooms!" -ForegroundColor Green
    exit 0
}

$roomList = $rooms -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

Write-Host "Found $($roomList.Count) rooms" -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$failCount = 0

foreach ($roomId in $roomList) {
    Write-Host "Room: $roomId" -ForegroundColor Cyan
    
    try {
        # Use admin API to force join
        $adminHeaders = @{
            "Authorization" = "Bearer $adminToken"
            "Content-Type" = "application/json"
        }
        
        $joinUrl = "http://localhost:8008/_synapse/admin/v1/join/$([uri]::EscapeDataString($roomId))"
        $joinBody = @{
            user_id = "@admin:localhost"
        } | ConvertTo-Json
        
        $response = Invoke-RestMethod -Uri $joinUrl -Headers $adminHeaders -Method POST -Body $joinBody -ErrorAction Stop
        
        Write-Host "  [SUCCESS] Admin joined!" -ForegroundColor Green
        $successCount++
        
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        
        if ($statusCode -eq 403) {
            Write-Host "  [403] Admin cannot force join (needs room membership)" -ForegroundColor Yellow
            $failCount++
        } elseif ($statusCode -eq 409) {
            Write-Host "  [OK] Admin already in room" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
            $failCount++
        }
    }
    
    Start-Sleep -Milliseconds 200
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Results:" -ForegroundColor Yellow
Write-Host "  [+] Success: $successCount" -ForegroundColor Green
Write-Host "  [X] Failed:  $failCount" -ForegroundColor Red
Write-Host ""

if ($failCount -gt 0) {
    Write-Host "For failed rooms, you need to:" -ForegroundColor Yellow
    Write-Host "  1. Login to Element Web with a room member" -ForegroundColor White
    Write-Host "  2. Invite @admin:localhost to the room" -ForegroundColor White
    Write-Host "  3. Or ignore these rooms (use admin panel only in accessible rooms)" -ForegroundColor White
    Write-Host ""
}

Write-Host "Rooms where admin IS a member:" -ForegroundColor Cyan
docker exec matrix-postgres psql -U synapse_user -d synapse -c "SELECT room_id FROM room_memberships WHERE user_id = '@admin:localhost' AND membership = 'join';"

Write-Host "========================================" -ForegroundColor Cyan

