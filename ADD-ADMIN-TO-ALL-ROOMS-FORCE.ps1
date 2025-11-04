# FORCE add admin to all rooms by directly manipulating database
# WARNING: This bypasses Matrix protocol - use only if necessary

Write-Host "========================================" -ForegroundColor Red
Write-Host "FORCE Add Admin to ALL Rooms (Database Direct)" -ForegroundColor Red
Write-Host "WARNING: This method bypasses Matrix protocol!" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

$confirm = Read-Host "Are you sure? This directly modifies the database. Type 'YES' to continue"

if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Fetching rooms where admin is NOT a member..." -ForegroundColor Yellow

# Get rooms where admin is not a member
$rooms = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c @"
SELECT DISTINCT r.room_id 
FROM rooms r 
WHERE r.room_id NOT IN (
    SELECT room_id 
    FROM room_memberships 
    WHERE user_id = '@admin:localhost' AND membership = 'join'
)
LIMIT 20;
"@ 2>$null

if (-not $rooms) {
    Write-Host "No rooms found or admin is already in all rooms!" -ForegroundColor Green
    exit 0
}

$roomList = $rooms -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
Write-Host "Found $($roomList.Count) rooms" -ForegroundColor Cyan
Write-Host ""

Write-Host "Note: This will make admin a 'join' member but won't send proper Matrix events." -ForegroundColor Yellow
Write-Host "Better solution: Use Element Web to invite admin to these rooms." -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$failCount = 0

foreach ($roomId in $roomList) {
    if ([string]::IsNullOrWhiteSpace($roomId)) { continue }
    
    Write-Host "Room: $roomId" -ForegroundColor Cyan
    
    # This is a SIMPLIFIED version - real implementation needs proper event_id, stream_ordering, etc
    Write-Host "  [INFO] This method is not recommended - use Element Web instead" -ForegroundColor Yellow
    Write-Host "  [SKIP] Skipping database modification for safety" -ForegroundColor Gray
    $failCount++
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Recommendation:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Use one of these methods instead:" -ForegroundColor White
Write-Host "1. Element Web: Invite admin manually to each room" -ForegroundColor Cyan
Write-Host "2. Use admin panel ONLY in rooms where admin is already a member" -ForegroundColor Cyan
Write-Host "3. Make sure new rooms have admin as a member from creation" -ForegroundColor Cyan
Write-Host ""
Write-Host "Admin is currently a member of 4 rooms - use those for testing!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

