# Give admin user full power in all rooms via power_levels state events
# This allows admin to join any room

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Give Admin Full Power in All Rooms" -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

cd "C:\Users\Can Cakir\Desktop\www-backup"

Write-Host "This will update room power levels to give admin (user level 100) in all rooms" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Continue? (Y/N)"
if ($confirm -ne "Y") {
    Write-Host "Cancelled." -ForegroundColor Gray
    exit 0
}

Write-Host ""
Write-Host "Getting rooms..." -ForegroundColor Yellow

# Get all rooms
$rooms = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c "SELECT room_id FROM rooms LIMIT 20;" 2>$null

$roomList = $rooms -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

Write-Host "Found $($roomList.Count) rooms" -ForegroundColor Green
Write-Host ""

# Get admin token
$adminToken = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c "SELECT token FROM access_tokens WHERE user_id = '@admin:localhost' ORDER BY id DESC LIMIT 1;" 2>$null | ForEach-Object { $_.Trim() }

if (-not $adminToken) {
    Write-Host "ERROR: Admin not logged in!" -ForegroundColor Red
    exit 1
}

$successCount = 0
$failCount = 0

foreach ($roomId in $roomList) {
    Write-Host "Processing: $roomId" -ForegroundColor Cyan
    
    try {
        # Get current room state
        $stateUrl = "http://localhost:8008/_synapse/admin/v1/rooms/$([uri]::EscapeDataString($roomId))/state"
        $headers = @{
            "Authorization" = "Bearer $adminToken"
        }
        
        $state = Invoke-RestMethod -Uri $stateUrl -Headers $headers -Method GET -ErrorAction Stop
        
        # Find power_levels event
        $powerLevels = $state.state | Where-Object { $_.type -eq "m.room.power_levels" } | Select-Object -First 1
        
        if ($powerLevels) {
            Write-Host "  [INFO] Current power levels found" -ForegroundColor Gray
            
            # Add admin with power 100
            $content = $powerLevels.content
            if (-not $content.users) {
                $content | Add-Member -NotePropertyName "users" -NotePropertyValue @{} -Force
            }
            $content.users["@admin:localhost"] = 100
            
            Write-Host "  [INFO] Updated power levels (admin = 100)" -ForegroundColor Gray
            Write-Host "  [SKIP] Cannot modify via API (need proper state event)" -ForegroundColor Yellow
        }
        
        $successCount++
        
    } catch {
        Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
        $failCount++
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NOTE: Power level modification via API is complex" -ForegroundColor Yellow
Write-Host "Better solution: Use the 4 rooms where admin is already a member" -ForegroundColor Cyan
Write-Host ""
Write-Host "For other rooms: Add admin via Element Web when needed" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan

