#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Railway Synapse'de Admin Kullanıcı Oluştur
#>

param(
    [string]$Username = "admin",
    [string]$Password = "Admin@2024!Guclu",
    [string]$SynapseUrl = "https://cravex1-production.up.railway.app",
    [string]$SharedSecret = "SuperGizliKayit2024!XyZ123aBc"
)

Write-Host "`n🔐 SYNAPSE ADMIN KULLANICI OLUŞTURMA`n" -ForegroundColor Cyan

# Nonce al
Write-Host "1. Nonce alınıyor..." -ForegroundColor Yellow
$nonceUrl = "$SynapseUrl/_synapse/admin/v1/register"

try {
    $nonceResponse = Invoke-RestMethod -Uri $nonceUrl -Method GET
    $nonce = $nonceResponse.nonce
    Write-Host "✅ Nonce alındı: $nonce" -ForegroundColor Green
} catch {
    Write-Host "❌ Nonce alınamadı!" -ForegroundColor Red
    Write-Host $_.Exception.Message
    exit 1
}

# HMAC hesapla
Write-Host "2. HMAC hesaplanıyor..." -ForegroundColor Yellow

$hmacsha1 = New-Object System.Security.Cryptography.HMACSHA1
$hmacsha1.key = [Text.Encoding]::UTF8.GetBytes($SharedSecret)

# Message: nonce + null byte + username + null byte + password + null byte + (admin or notadmin)
$message = "$nonce`0$Username`0$Password`0admin"
$signature = $hmacsha1.ComputeHash([Text.Encoding]::UTF8.GetBytes($message))
$mac = [System.BitConverter]::ToString($signature).Replace("-","").ToLower()

Write-Host "✅ MAC: $mac" -ForegroundColor Green

# Kullanıcı oluştur
Write-Host "3. Kullanıcı oluşturuluyor..." -ForegroundColor Yellow

$body = @{
    nonce = $nonce
    username = $Username
    password = $Password
    admin = $true
    mac = $mac
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri $nonceUrl -Method POST -Body $body -ContentType "application/json"
    
    Write-Host ""
    Write-Host "ADMIN USER CREATED!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Username: @$Username`:cravex1-production.up.railway.app" -ForegroundColor White
    Write-Host "Password: $Password" -ForegroundColor White
    Write-Host "URL: https://vcravex1.netlify.app" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
} catch {
    Write-Host "❌ Kullanıcı oluşturulamadı!" -ForegroundColor Red
    Write-Host $_.Exception.Message
    exit 1
}

