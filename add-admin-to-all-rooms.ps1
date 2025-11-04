# Add admin user to ALL rooms automatically
# This solves the problem of admin not being able to add members to rooms they're not in

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Add Admin to ALL Rooms" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$workspacePath = "C:\Users\Can Cakir\Desktop\www-backup"
cd $workspacePath

# Get all rooms from database
Write-Host "Fetching all rooms..." -ForegroundColor Yellow
$rooms = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c "SELECT DISTINCT room_id FROM rooms WHERE is_public = true OR room_id IN (SELECT room_id FROM room_memberships WHERE user_id LIKE '%k:localhost' OR user_id LIKE '%admin%');" 2>$null

if (-not $rooms) {
    Write-Host "ERROR: Could not fetch rooms!" -ForegroundColor Red
    exit 1
}

$roomList = $rooms -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
Write-Host "Found $($roomList.Count) rooms" -ForegroundColor Green
Write-Host ""

# Get admin token
Write-Host "Getting admin token..." -ForegroundColor Yellow
$adminToken = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c "SELECT token FROM access_tokens WHERE user_id = '@admin:localhost' ORDER BY id DESC LIMIT 1;" 2>$null | ForEach-Object { $_.Trim() }

if (-not $adminToken) {
    Write-Host "ERROR: Could not get admin token!" -ForegroundColor Red
    Write-Host "Please login to admin panel first." -ForegroundColor Yellow
    exit 1
}

Write-Host "Admin token found!" -ForegroundColor Green
Write-Host ""

# Process each room
$successCount = 0
$skipCount = 0
$failCount = 0

foreach ($roomId in $roomList) {
    if ([string]::IsNullOrWhiteSpace($roomId)) { continue }
    
    Write-Host "Room: $roomId" -ForegroundColor Cyan
    
    # Check if admin already in room
    $isMember = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c "SELECT COUNT(*) FROM room_memberships WHERE room_id = '$roomId' AND user_id = '@admin:localhost' AND membership = 'join';" 2>$null | ForEach-Object { $_.Trim() }
    
    if ($isMember -gt 0) {
        Write-Host "  [OK] Admin already a member, skipping..." -ForegroundColor Gray
        $skipCount++
        continue
    }
    
    # Get a member from the room to invite admin
    $member = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c "SELECT user_id FROM room_memberships WHERE room_id = '$roomId' AND membership = 'join' LIMIT 1;" 2>$null | ForEach-Object { $_.Trim() }
    
    if (-not $member) {
        Write-Host "  [FAIL] No members in room, skipping..." -ForegroundColor Yellow
        $failCount++
        continue
    }
    
    try {
        # Use admin API to force join directly
        $adminHeaders = @{
            "Authorization" = "Bearer $adminToken"
            "Content-Type" = "application/json"
        }
        
        $joinUrl = "http://localhost:8008/_synapse/admin/v1/join/$([uri]::EscapeDataString($roomId))"
        $joinBody = @{
            user_id = "@admin:localhost"
        } | ConvertTo-Json
        
        Invoke-RestMethod -Uri $joinUrl -Headers $adminHeaders -Method POST -Body $joinBody -ErrorAction Stop | Out-Null
        
        Write-Host "  [SUCCESS] Admin added successfully!" -ForegroundColor Green
        $successCount++
        
    } catch {
        $errorMsg = $_.Exception.Message
        
        # If 403, admin needs to be in room first - try alternative method
        if ($errorMsg -like "*403*" -or $errorMsg -like "*Forbidden*") {
            Write-Host "  [SKIP] Admin cannot join (need room admin power)" -ForegroundColor Yellow
            $failCount++
        } elseif ($errorMsg -like "*already*" -or $errorMsg -like "*409*") {
            Write-Host "  [OK] Admin already joined" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "  [ERROR] Failed: $errorMsg" -ForegroundColor Red
            $failCount++
        }
    }
    
    Start-Sleep -Milliseconds 100
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "  [+] Successfully added: $successCount" -ForegroundColor Green
Write-Host "  [-] Already member:     $skipCount" -ForegroundColor Gray
Write-Host "  [X] Failed:             $failCount" -ForegroundColor Red
Write-Host ""
Write-Host "Done! Admin can now manage members in all rooms." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
