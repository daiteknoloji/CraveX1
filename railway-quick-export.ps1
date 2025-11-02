# Railway Hızlı Bilgi Toplama
# Tüm servislerin detaylarını toplar

Write-Host "🚂 Railway Servis Bilgileri Toplama" -ForegroundColor Cyan
Write-Host ""

$services = @("synapse-admin-ui", "considerate-adaptation", "matrix-synapse", "feisty-exploration")
$output = @{}

foreach ($service in $services) {
    Write-Host "📦 $service kontrol ediliyor..." -ForegroundColor Yellow
    
    try {
        # Service'e link ol
        railway link -s $service 2>$null
        
        # Variables al
        Write-Host "  → Variables alınıyor..." -ForegroundColor Gray
        $vars = railway variables 2>$null
        
        # Logs al (son 50 satır)
        Write-Host "  → Son deployment kontrol ediliyor..." -ForegroundColor Gray
        $logs = railway logs --limit 50 2>$null
        
        $output[$service] = @{
            "variables" = $vars
            "recent_logs" = $logs
            "timestamp" = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
        
        Write-Host "  ✅ Başarılı" -ForegroundColor Green
        
    } catch {
        Write-Host "  ⚠️  Bulunamadı veya erişim yok" -ForegroundColor Red
        $output[$service] = @{
            "error" = "Service not found or no access"
        }
    }
    
    Write-Host ""
}

# JSON olarak kaydet
$outputFile = "railway-services-export.json"
$output | ConvertTo-Json -Depth 10 | Out-File $outputFile

Write-Host "✅ Export tamamlandı: $outputFile" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Özet:" -ForegroundColor Cyan
foreach ($key in $output.Keys) {
    if ($output[$key].error) {
        Write-Host "  ❌ $key - Bulunamadı" -ForegroundColor Red
    } else {
        Write-Host "  ✅ $key - OK" -ForegroundColor Green
    }
}

