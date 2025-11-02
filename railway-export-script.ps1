# Railway Configuration Export Script
# Bu script ile Railway servislerinizin konfigürasyonunu otomatik export edin

Write-Host "🚂 Railway Configuration Export Tool" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Project bilgisi
Write-Host "📦 Project: grateful-manifestation" -ForegroundColor Yellow
Write-Host ""

# Output dosyası
$outputFile = "railway-config-export.json"

# Railway API Token (kullanıcıdan al)
Write-Host "⚠️  Railway API Token gerekli!" -ForegroundColor Red
Write-Host "1. Railway Dashboard → Account Settings → Tokens" -ForegroundColor Gray
Write-Host "2. 'Create Token' ile yeni token oluşturun" -ForegroundColor Gray
Write-Host "3. Token'ı kopyalayıp buraya yapıştırın" -ForegroundColor Gray
Write-Host ""

$token = Read-Host "Railway API Token"

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "❌ Token boş olamaz!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔍 Bilgiler çekiliyor..." -ForegroundColor Cyan

# Railway GraphQL API
$apiUrl = "https://backboard.railway.app/graphql/v2"

# Headers
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# GraphQL Query - Tüm projeleri al
$projectQuery = @{
    query = @"
    query {
      projects {
        edges {
          node {
            id
            name
            description
            services {
              edges {
                node {
                  id
                  name
                  createdAt
                }
              }
            }
          }
        }
      }
    }
"@
} | ConvertTo-Json

try {
    # API isteği
    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $projectQuery
    
    # Sonucu JSON olarak kaydet
    $response | ConvertTo-Json -Depth 10 | Out-File $outputFile
    
    Write-Host "✅ Export tamamlandı!" -ForegroundColor Green
    Write-Host "📄 Dosya: $outputFile" -ForegroundColor Green
    Write-Host ""
    Write-Host "Projeler:" -ForegroundColor Yellow
    
    foreach ($project in $response.data.projects.edges) {
        Write-Host "  - $($project.node.name) (ID: $($project.node.id))" -ForegroundColor Cyan
        Write-Host "    Servisler:" -ForegroundColor Gray
        foreach ($service in $project.node.services.edges) {
            Write-Host "      • $($service.node.name)" -ForegroundColor White
        }
    }
    
} catch {
    Write-Host "❌ Hata: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔧 Alternatif: Manuel Export" -ForegroundColor Yellow
    Write-Host "1. Railway Dashboard açın: https://railway.app/project/grateful-manifestation" -ForegroundColor Gray
    Write-Host "2. Her servisin Settings sayfasını açın" -ForegroundColor Gray
    Write-Host "3. Bilgileri kopyalayıp buraya yapıştırın" -ForegroundColor Gray
}

Write-Host ""
Read-Host "Devam etmek için Enter'a basın"

