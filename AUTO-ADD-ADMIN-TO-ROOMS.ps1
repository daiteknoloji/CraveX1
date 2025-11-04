# Auto-add admin to all rooms every 30 seconds
# Run this in background to automatically add admin to new rooms

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Auto Add Admin to Rooms (Background Task)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will run continuously and check every 30 seconds" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

$checkInterval = 30 # seconds
$iteration = 0

while ($true) {
    $iteration++
    $timestamp = Get-Date -Format "HH:mm:ss"
    
    Write-Host "[$timestamp] Check #$iteration - Looking for rooms without admin..." -ForegroundColor Cyan
    
    try {
        # Get admin token
        $adminToken = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c "SELECT token FROM access_tokens WHERE user_id = '@admin:localhost' ORDER BY id DESC LIMIT 1;" 2>$null | ForEach-Object { $_.Trim() }
        
        if (-not $adminToken) {
            Write-Host "  [WARNING] Admin token not found - is admin logged in?" -ForegroundColor Yellow
            Start-Sleep -Seconds $checkInterval
            continue
        }
        
        # Find rooms where admin is NOT a member
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
)
LIMIT 5;
"@
        
        $rooms = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c $roomsQuery 2>$null
        
        if (-not $rooms) {
            Write-Host "  [OK] Admin is in all active rooms!" -ForegroundColor Green
            Start-Sleep -Seconds $checkInterval
            continue
        }
        
        $roomList = $rooms -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
        
        if ($roomList.Count -eq 0) {
            Write-Host "  [OK] No rooms to process" -ForegroundColor Green
            Start-Sleep -Seconds $checkInterval
            continue
        }
        
        Write-Host "  [INFO] Found $($roomList.Count) room(s) without admin" -ForegroundColor Yellow
        
        foreach ($roomId in $roomList) {
            Write-Host "  Processing: $roomId" -ForegroundColor Gray
            
            # Get a member from the room
            $member = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c "SELECT user_id FROM room_memberships WHERE room_id = '$roomId' AND membership = 'join' LIMIT 1;" 2>$null | ForEach-Object { $_.Trim() }
            
            if (-not $member) {
                Write-Host "    [SKIP] No members found" -ForegroundColor Gray
                continue
            }
            
            # Get member's token
            $memberToken = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c "SELECT token FROM access_tokens WHERE user_id = '$member' ORDER BY id DESC LIMIT 1;" 2>$null | ForEach-Object { $_.Trim() }
            
            if (-not $memberToken) {
                Write-Host "    [SKIP] Member $member has no token" -ForegroundColor Gray
                continue
            }
            
            try {
                # Step 1: Member invites admin
                $inviteHeaders = @{
                    "Authorization" = "Bearer $memberToken"
                    "Content-Type" = "application/json"
                }
                
                $inviteUrl = "http://localhost:8008/_matrix/client/r0/rooms/$([uri]::EscapeDataString($roomId))/invite"
                $inviteBody = '{"user_id": "@admin:localhost"}'
                
                $null = Invoke-RestMethod -Uri $inviteUrl -Headers $inviteHeaders -Method POST -Body $inviteBody -ErrorAction Stop
                
                # Step 2: Admin joins
                $adminHeaders = @{
                    "Authorization" = "Bearer $adminToken"
                    "Content-Type" = "application/json"
                }
                
                $joinUrl = "http://localhost:8008/_matrix/client/r0/rooms/$([uri]::EscapeDataString($roomId))/join"
                
                $null = Invoke-RestMethod -Uri $joinUrl -Headers $adminHeaders -Method POST -ErrorAction Stop
                
                Write-Host "    [SUCCESS] Admin added!" -ForegroundColor Green
                
            } catch {
                $errorMsg = $_.Exception.Message
                if ($errorMsg -like "*already*" -or $errorMsg -like "*409*") {
                    Write-Host "    [OK] Already invited/joined" -ForegroundColor Green
                } else {
                    Write-Host "    [ERROR] $errorMsg" -ForegroundColor Red
                }
            }
            
            Start-Sleep -Milliseconds 200
        }
        
    } catch {
        Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host "  Waiting $checkInterval seconds..." -ForegroundColor Gray
    Write-Host ""
    Start-Sleep -Seconds $checkInterval
}

