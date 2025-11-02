#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Railway + Netlify Deployment Master Script
    
.DESCRIPTION
    Bu script tüm deployment sürecini otomatikleştirir:
    1. Element Web build & deploy (Netlify)
    2. Synapse Admin build & deploy (Netlify)
    3. Railway deployment bilgilendirme
    
.EXAMPLE
    .\BUILD-AND-DEPLOY.ps1
#>

param(
    [switch]$SkipBuild,
    [switch]$OnlyBuild,
    [switch]$Help
)

# Renkli output fonksiyonları
function Write-Success { param($msg) Write-Host "✅ $msg" -ForegroundColor Green }
function Write-Info { param($msg) Write-Host "ℹ️  $msg" -ForegroundColor Cyan }
function Write-Warning { param($msg) Write-Host "⚠️  $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "❌ $msg" -ForegroundColor Red }
function Write-Header { param($msg) Write-Host "`n=== $msg ===" -ForegroundColor Magenta }

if ($Help) {
    Write-Host @"
🚀 Railway + Netlify Deployment Script

KULLANIM:
    .\BUILD-AND-DEPLOY.ps1                # Full deployment
    .\BUILD-AND-DEPLOY.ps1 -OnlyBuild     # Sadece build (deploy yok)
    .\BUILD-AND-DEPLOY.ps1 -SkipBuild     # Sadece deploy (build atla)
    .\BUILD-AND-DEPLOY.ps1 -Help          # Bu yardım mesajı

ÖNCELİKLE:
    1. Netlify hesabı oluşturun: https://netlify.com
    2. Netlify CLI kurulumu: npm install -g netlify-cli
    3. Login yapın: netlify login
    
RAILWAY IÇIN:
    - Railway.app'te hesap oluşturun
    - Proje oluşturup PostgreSQL ekleyin
    - Environment variables'ları .env.railway.template'ten kopyalayın
"@
    exit 0
}

Write-Header "CRAVEX CHAT - RAILWAY + NETLIFY DEPLOYMENT"

# Gerekli tool kontrolü
Write-Info "Gereksinimler kontrol ediliyor..."

$nodeVersion = node --version 2>$null
if (-not $nodeVersion) {
    Write-Error "Node.js bulunamadı! Lütfen Node.js 20+ kurun."
    exit 1
}
Write-Success "Node.js: $nodeVersion"

$yarnVersion = yarn --version 2>$null
if (-not $yarnVersion) {
    Write-Error "Yarn bulunamadı! npm install -g yarn"
    exit 1
}
Write-Success "Yarn: $yarnVersion"

# Netlify CLI kontrolü
$netlifyVersion = netlify --version 2>$null
if (-not $netlifyVersion) {
    Write-Warning "Netlify CLI bulunamadı!"
    $install = Read-Host "Netlify CLI kurmak ister misiniz? (Y/N)"
    if ($install -eq 'Y' -or $install -eq 'y') {
        npm install -g netlify-cli
    } else {
        Write-Error "Netlify CLI gerekli! Çıkılıyor..."
        exit 1
    }
} else {
    Write-Success "Netlify CLI: $netlifyVersion"
}

# ===========================================
# ELEMENT WEB BUILD & DEPLOY
# ===========================================

if (-not $SkipBuild) {
    Write-Header "ELEMENT WEB BUILD"
    
    Push-Location "www\element-web"
    
    Write-Info "Dependencies kuruluyor..."
    yarn install
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Yarn install başarısız!"
        Pop-Location
        exit 1
    }
    
    Write-Info "Element Web build ediliyor..."
    yarn build
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build başarısız!"
        Pop-Location
        exit 1
    }
    
    Write-Success "Element Web build başarılı! (webapp klasörü hazır)"
    Pop-Location
}

if (-not $OnlyBuild) {
    Write-Header "ELEMENT WEB DEPLOY (Netlify)"
    
    Push-Location "www\element-web"
    
    Write-Info "Netlify'a deploy ediliyor..."
    netlify deploy --prod --dir=webapp
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Element Web deploy edildi!"
        Write-Warning "⚠️  Domain URL'ini not alın ve config.json'da Synapse URL'ini güncelleyin!"
    } else {
        Write-Error "Deploy başarısız!"
    }
    
    Pop-Location
}

# ===========================================
# SYNAPSE ADMIN BUILD & DEPLOY
# ===========================================

if (-not $SkipBuild) {
    Write-Header "SYNAPSE ADMIN BUILD"
    
    Push-Location "www\admin"
    
    Write-Info "Dependencies kuruluyor..."
    yarn install
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Yarn install başarısız!"
        Pop-Location
        exit 1
    }
    
    Write-Info "Synapse Admin build ediliyor..."
    yarn build
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build başarısız!"
        Pop-Location
        exit 1
    }
    
    Write-Success "Synapse Admin build başarılı! (dist klasörü hazır)"
    Pop-Location
}

if (-not $OnlyBuild) {
    Write-Header "SYNAPSE ADMIN DEPLOY (Netlify)"
    
    Push-Location "www\admin"
    
    Write-Info "Netlify'a deploy ediliyor..."
    netlify deploy --prod --dir=dist
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Synapse Admin deploy edildi!"
        Write-Warning "⚠️  Domain URL'ini not alın!"
    } else {
        Write-Error "Deploy başarısız!"
    }
    
    Pop-Location
}

# ===========================================
# RAILWAY DEPLOYMENT BİLGİLENDİRME
# ===========================================

Write-Header "RAILWAY DEPLOYMENT ADIMLARI"

Write-Host @"

📦 RAILWAY'E DEPLOY İÇİN:

1️⃣  PostgreSQL Servisi Ekle:
   - Railway Dashboard → New → Database → PostgreSQL
   - Otomatik environment variables oluşacak

2️⃣  Matrix Synapse Servisi Ekle:
   - Railway Dashboard → New → GitHub Repo
   - Root directory: /
   - railway.json otomatik algılanacak
   - Environment variables ekle (.env.railway.template'ten)

3️⃣  Admin Panel Servisi Ekle:
   - Railway Dashboard → New → GitHub Repo (aynı repo)
   - railway-admin-panel.json kullan
   - PostgreSQL env vars'ı paylaş

4️⃣  Domains Al:
   - Her servis için Generate Domain
   - Not al:
     * Synapse: https://synapse-xxx.up.railway.app
     * Admin Panel: https://admin-xxx.up.railway.app

5️⃣  Config Güncellemeleri:
   - Element Web config.json → Synapse domain
   - Synapse homeserver.yaml → WEB_CLIENT_LOCATION
   - Yeniden deploy et

📚 Detaylı rehber: RAILWAY-NETLIFY-DEPLOYMENT-GUIDE.md

"@

Write-Success "`n✨ Build & Deploy scripti tamamlandı!"
Write-Info "Sonraki adımlar için rehberi okuyun."

