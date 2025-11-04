# Add admin user to a specific room
# Usage: .\ADD-ADMIN-TO-ROOM.ps1

param(
    [string]$RoomId = "!CQAmxEKSiSBGkjlrlu:localhost"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Add Admin to Room" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# PostgreSQL'den admin token al
Write-Host "Getting admin access token..." -ForegroundColor Yellow

$token = docker exec matrix-postgres psql -U synapse_user -d synapse -t -c "SELECT token FROM access_tokens WHERE user_id = '@admin:localhost' ORDER BY id DESC LIMIT 1;" 2>$null
$token = $token.Trim()

if ([string]::IsNullOrEmpty($token)) {
    Write-Host "ERROR: Could not get admin token!" -ForegroundColor Red
    Write-Host "Please login to admin panel first." -ForegroundColor Yellow
    exit 1
}

Write-Host "Token found!" -ForegroundColor Green
Write-Host "Room ID: $RoomId" -ForegroundColor Cyan
Write-Host ""

# Admin kullanıcısını odaya ekle
Write-Host "Adding admin user to room..." -ForegroundColor Yellow

try {
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    
    $body = @{
        user_id = "@admin:localhost"
    } | ConvertTo-Json
    
    $url = "http://localhost:8008/_synapse/admin/v1/join/$([uri]::EscapeDataString($RoomId))"
    
    Write-Host "URL: $url" -ForegroundColor Gray
    Write-Host ""
    
    $response = Invoke-RestMethod -Uri $url -Headers $headers -Method POST -Body $body -ErrorAction Stop
    
    Write-Host ""
    Write-Host "SUCCESS! Admin added to room!" -ForegroundColor Green
    Write-Host "Room ID: $($response.room_id)" -ForegroundColor White
    Write-Host ""
    Write-Host "Now you can add other members from the admin panel!" -ForegroundColor Cyan
    
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorMessage = $_.Exception.Message
    
    Write-Host ""
    Write-Host "ERROR: Could not add admin to room" -ForegroundColor Red
    Write-Host "Status Code: $statusCode" -ForegroundColor Yellow
    Write-Host "Message: $errorMessage" -ForegroundColor Yellow
    Write-Host ""
    
    # Eğer admin zaten odadaysa
    if ($statusCode -eq 409 -or $errorMessage -like "*already*") {
        Write-Host "Admin is already in the room!" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
