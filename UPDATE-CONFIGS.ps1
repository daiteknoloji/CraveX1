#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Config dosyalarını Railway domain'leri ile günceller
    
.DESCRIPTION
    Railway'den aldığınız domain'leri kullanarak tüm config dosyalarını günceller
    
.PARAMETER SynapseDomain
    Railway Synapse domain (örn: synapse-production.up.railway.app)
    
.PARAMETER ElementDomain
    Netlify Element Web domain (örn: element-cravex.netlify.app)
    
.EXAMPLE
    .\UPDATE-CONFIGS.ps1 -SynapseDomain "synapse-prod.up.railway.app" -ElementDomain "element.netlify.app"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$SynapseDomain,
    
    [Parameter(Mandatory=$false)]
    [string]$ElementDomain = ""
)

function Write-Success { param($msg) Write-Host "✅ $msg" -ForegroundColor Green }
function Write-Info { param($msg) Write-Host "ℹ️  $msg" -ForegroundColor Cyan }
function Write-Error { param($msg) Write-Host "❌ $msg" -ForegroundColor Red }

Write-Host "`n🔧 CONFIG UPDATE TOOL`n" -ForegroundColor Magenta

# Domain'lerde https:// varsa temizle
$SynapseDomain = $SynapseDomain -replace '^https?://', ''
if ($ElementDomain) {
    $ElementDomain = $ElementDomain -replace '^https?://', ''
}

Write-Info "Synapse Domain: https://$SynapseDomain"
if ($ElementDomain) {
    Write-Info "Element Domain: https://$ElementDomain"
}

# ===========================================
# ELEMENT WEB CONFIG
# ===========================================

Write-Info "`nElement Web config.json güncelleniyor..."

$elementConfigPath = "www\element-web\config.json"

if (Test-Path $elementConfigPath) {
    $config = Get-Content $elementConfigPath -Raw | ConvertFrom-Json
    
    # Synapse domain güncelle
    $config.default_server_config.m.homeserver.base_url = "https://$SynapseDomain"
    $config.default_server_config.m.homeserver.server_name = $SynapseDomain
    $config.room_directory.servers = @($SynapseDomain)
    
    # Kaydet
    $config | ConvertTo-Json -Depth 10 | Set-Content $elementConfigPath
    
    Write-Success "Element Web config.json güncellendi!"
} else {
    Write-Error "Element Web config.json bulunamadı: $elementConfigPath"
}

# ===========================================
# SYNAPSE ADMIN CONFIG
# ===========================================

Write-Info "`nSynapse Admin config.json güncelleniyor..."

$adminConfigPath = "www\admin\public\config.json"

if (Test-Path $adminConfigPath) {
    $adminConfig = @{
        restrictBaseUrl = "https://$SynapseDomain"
        asManagedUsers = $false
    }
    
    $adminConfig | ConvertTo-Json -Depth 10 | Set-Content $adminConfigPath
    
    Write-Success "Synapse Admin config.json güncellendi!"
} else {
    Write-Error "Synapse Admin config.json bulunamadı: $adminConfigPath"
}

# ===========================================
# RAILWAY SYNAPSE CONFIG (homeserver.yaml)
# ===========================================

Write-Info "`nSynapse homeserver.yaml güncelleniyor..."

$homeserverPath = "synapse-railway-config\homeserver.yaml"

if (Test-Path $homeserverPath) {
    $yaml = Get-Content $homeserverPath -Raw
    
    # Server name güncelle
    $yaml = $yaml -replace 'server_name: ".*"', "server_name: `"$SynapseDomain`""
    $yaml = $yaml -replace 'public_baseurl: "https://.*/"', "public_baseurl: `"https://$SynapseDomain/`""
    
    # Web client location güncelle (eğer Element domain varsa)
    if ($ElementDomain) {
        $yaml = $yaml -replace 'web_client_location: "https://.*"', "web_client_location: `"https://$ElementDomain`""
    }
    
    # Kaydet
    $yaml | Set-Content $homeserverPath
    
    Write-Success "Synapse homeserver.yaml güncellendi!"
} else {
    Write-Error "homeserver.yaml bulunamadı: $homeserverPath"
}

# ===========================================
# ÖZET
# ===========================================

Write-Host "`n📋 GÜNCELLENDİ:" -ForegroundColor Green
Write-Host "   ✅ Element Web config.json"
Write-Host "   ✅ Synapse Admin config.json"
Write-Host "   ✅ Synapse homeserver.yaml"

Write-Host "`n🚀 SONRAKİ ADIMLAR:" -ForegroundColor Yellow
Write-Host "   1. Element Web'i yeniden build edin:"
Write-Host "      cd www\element-web"
Write-Host "      yarn build"
Write-Host "      netlify deploy --prod --dir=webapp"
Write-Host ""
Write-Host "   2. Synapse Admin'i yeniden build edin:"
Write-Host "      cd www\admin"
Write-Host "      yarn build"
Write-Host "      netlify deploy --prod --dir=dist"
Write-Host ""
Write-Host "   3. Railway'de Synapse servisini yeniden deploy edin"
Write-Host "      (homeserver.yaml değişti)"
Write-Host ""

Write-Success "`n✨ Config güncellemeleri tamamlandı!"

