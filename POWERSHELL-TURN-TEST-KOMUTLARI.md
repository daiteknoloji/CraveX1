# PowerShell TURN Server Test Komutları

## 1. Basit TCP Bağlantı Testi

```powershell
Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478
```

## 2. Detaylı TCP Bağlantı Testi

```powershell
Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478 -InformationLevel Detailed
```

## 3. Sonuçları Değişkenle Kaydet

```powershell
$result = Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478 -WarningAction SilentlyContinue

if ($result.TcpTestSucceeded) {
    Write-Host "✅ TURN Server çalışıyor!" -ForegroundColor Green
    Write-Host "Remote Address: $($result.RemoteAddress)" -ForegroundColor Gray
    Write-Host "Remote Port: $($result.RemotePort)" -ForegroundColor Gray
} else {
    Write-Host "❌ TURN Server çalışmıyor!" -ForegroundColor Red
    Write-Host "Ping: $($result.PingSucceeded)" -ForegroundColor Yellow
    Write-Host "TCP: $($result.TcpTestSucceeded)" -ForegroundColor Red
}
```

## 4. Metered.ca Server'larını Test Et

```powershell
# Metered.ca relay.metered.ca test
Write-Host "`n🔍 Metered.ca Server Test Ediliyor..." -ForegroundColor Cyan
$metered1 = Test-NetConnection -ComputerName relay.metered.ca -Port 80 -WarningAction SilentlyContinue
if ($metered1.TcpTestSucceeded) {
    Write-Host "✅ relay.metered.ca:80 çalışıyor" -ForegroundColor Green
} else {
    Write-Host "❌ relay.metered.ca:80 çalışmıyor" -ForegroundColor Red
}

$metered2 = Test-NetConnection -ComputerName relay.metered.ca -Port 443 -WarningAction SilentlyContinue
if ($metered2.TcpTestSucceeded) {
    Write-Host "✅ relay.metered.ca:443 çalışıyor" -ForegroundColor Green
} else {
    Write-Host "❌ relay.metered.ca:443 çalışmıyor" -ForegroundColor Red
}

$metered3 = Test-NetConnection -ComputerName openrelay.metered.ca -Port 80 -WarningAction SilentlyContinue
if ($metered3.TcpTestSucceeded) {
    Write-Host "✅ openrelay.metered.ca:80 çalışıyor" -ForegroundColor Green
} else {
    Write-Host "❌ openrelay.metered.ca:80 çalışmıyor" -ForegroundColor Red
}
```

## 5. Tüm TURN Server'ları Test Et (Tek Komut)

```powershell
Write-Host "`n🔍 TURN Server Test Başlıyor...`n" -ForegroundColor Cyan

# Railway TURN Server
Write-Host "1. Railway TURN Server:" -ForegroundColor Yellow
$railway = Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478 -WarningAction SilentlyContinue
if ($railway.TcpTestSucceeded) {
    Write-Host "   ✅ Çalışıyor" -ForegroundColor Green
} else {
    Write-Host "   ❌ Çalışmıyor (Ping: $($railway.PingSucceeded))" -ForegroundColor Red
}

# Metered.ca Server'ları
Write-Host "`n2. Metered.ca Servers:" -ForegroundColor Yellow
$m1 = Test-NetConnection -ComputerName relay.metered.ca -Port 80 -WarningAction SilentlyContinue
Write-Host "   relay.metered.ca:80 -> $(if ($m1.TcpTestSucceeded) {'✅'} else {'❌'})" -ForegroundColor $(if ($m1.TcpTestSucceeded) {'Green'} else {'Red'})

$m2 = Test-NetConnection -ComputerName relay.metered.ca -Port 443 -WarningAction SilentlyContinue
Write-Host "   relay.metered.ca:443 -> $(if ($m2.TcpTestSucceeded) {'✅'} else {'❌'})" -ForegroundColor $(if ($m2.TcpTestSucceeded) {'Green'} else {'Red'})

$m3 = Test-NetConnection -ComputerName openrelay.metered.ca -Port 80 -WarningAction SilentlyContinue
Write-Host "   openrelay.metered.ca:80 -> $(if ($m3.TcpTestSucceeded) {'✅'} else {'❌'})" -ForegroundColor $(if ($m3.TcpTestSucceeded) {'Green'} else {'Red'})

# Matrix.org TURN Server
Write-Host "`n3. Matrix.org TURN Server:" -ForegroundColor Yellow
$matrix = Test-NetConnection -ComputerName turn.matrix.org -Port 3478 -WarningAction SilentlyContinue
if ($matrix.TcpTestSucceeded) {
    Write-Host "   ✅ Çalışıyor" -ForegroundColor Green
} else {
    Write-Host "   ❌ Çalışmıyor" -ForegroundColor Red
}

Write-Host "`n✅ Test Tamamlandı`n" -ForegroundColor Cyan
```

## 6. Sürekli Test (Monitoring)

```powershell
# Her 5 saniyede bir test et
while ($true) {
    $result = Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478 -WarningAction SilentlyContinue
    $status = if ($result.TcpTestSucceeded) { "✅ ÇALIŞIYOR" } else { "❌ ÇALIŞMIYOR" }
    Write-Host "$(Get-Date -Format 'HH:mm:ss') - $status" -ForegroundColor $(if ($result.TcpTestSucceeded) {'Green'} else {'Red'})
    Start-Sleep -Seconds 5
}
```

## Sonuç

Railway TURN server test başarısız, bu yüzden:
1. Railway Dashboard'a git
2. "+ TCP Proxy" butonuna tıkla
3. Port: 3478, Protocol: TCP ekle
4. Kaydet ve deploy bekle
5. Tekrar test et


