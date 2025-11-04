$username = "admin"
$password = "Admin@2024!Guclu"
$synapseUrl = "https://cravex1-production.up.railway.app"
$sharedSecret = "SuperGizliKayit2024!XyZ123aBc"

Write-Host "Creating admin user..." -ForegroundColor Cyan

# Get nonce
$nonceUrl = "$synapseUrl/_synapse/admin/v1/register"
$nonceResponse = Invoke-RestMethod -Uri $nonceUrl -Method GET
$nonce = $nonceResponse.nonce

Write-Host "Nonce received: $nonce" -ForegroundColor Green

# Calculate HMAC
$hmac = New-Object System.Security.Cryptography.HMACSHA1
$hmac.key = [Text.Encoding]::UTF8.GetBytes($sharedSecret)
$message = "$nonce`0$username`0$password`0admin"
$signature = $hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($message))
$mac = [System.BitConverter]::ToString($signature).Replace("-","").ToLower()

# Create user
$body = @{
    nonce = $nonce
    username = $username
    password = $password
    admin = $true
    mac = $mac
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri $nonceUrl -Method POST -Body $body -ContentType "application/json"

Write-Host ""
Write-Host "SUCCESS! Admin user created:" -ForegroundColor Green
Write-Host "Username: @admin:cravex1-production.up.railway.app" -ForegroundColor White
Write-Host "Password: $password" -ForegroundColor White
Write-Host ""
Write-Host "Login at: https://vcravex1.netlify.app" -ForegroundColor Yellow
Write-Host ""
