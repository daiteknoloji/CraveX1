# PowerShell TURN Server Test Komutları

## 1. Basit TCP Bağlantı Testi

```powershell
# TURN server'a TCP bağlantısı test et
Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478
```

**Beklenen sonuç:**
- `TcpTestSucceeded: True` → Server erişilebilir
- `TcpTestSucceeded: False` → Server erişilemiyor veya firewall engelliyor

## 2. Detaylı Bağlantı Testi

```powershell
# Detaylı bilgi ile test
Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478 -InformationLevel Detailed
```

## 3. Telnet ile Test (Eğer yüklüyse)

```powershell
# Telnet ile bağlantı testi
$tcpClient = New-Object System.Net.Sockets.TcpClient
try {
    $tcpClient.Connect("turn-server-production-2809.up.railway.app", 3478)
    if ($tcpClient.Connected) {
        Write-Host "✅ Bağlantı başarılı!" -ForegroundColor Green
        $tcpClient.Close()
    }
} catch {
    Write-Host "❌ Bağlantı başarısız: $_" -ForegroundColor Red
} finally {
    $tcpClient.Dispose()
}
```

## 4. TURN Protokolü Testi (Basit)

```powershell
# TURN server'a STUN binding request gönder (basit test)
$client = New-Object System.Net.Sockets.TcpClient
try {
    $client.Connect("turn-server-production-2809.up.railway.app", 3478)
    if ($client.Connected) {
        Write-Host "✅ TCP bağlantısı başarılı!" -ForegroundColor Green
        
        # Basit STUN binding request (0x0001)
        $stream = $client.GetStream()
        $stunRequest = [byte[]](0x00, 0x01, 0x00, 0x00, 0x21, 0x12, 0xA4, 0x42)
        $stream.Write($stunRequest, 0, $stunRequest.Length)
        
        Write-Host "STUN request gönderildi..." -ForegroundColor Yellow
        $client.Close()
    }
} catch {
    Write-Host "❌ Hata: $_" -ForegroundColor Red
} finally {
    $client.Dispose()
}
```

## 5. Hızlı Test Scripti

```powershell
# Tek komutla test
$server = "turn-server-production-2809.up.railway.app"
$port = 3478

Write-Host "`n🔍 TURN Server Test Ediliyor..." -ForegroundColor Cyan
Write-Host "Server: $server`nPort: $port`n" -ForegroundColor White

$result = Test-NetConnection -ComputerName $server -Port $port -WarningAction SilentlyContinue

if ($result.TcpTestSucceeded) {
    Write-Host "✅ TURN Server erişilebilir!" -ForegroundColor Green
    Write-Host "Remote Address: $($result.RemoteAddress)" -ForegroundColor Gray
    Write-Host "Remote Port: $($result.RemotePort)" -ForegroundColor Gray
} else {
    Write-Host "❌ TURN Server erişilemiyor!" -ForegroundColor Red
    Write-Host "Hata: $($result.TcpTestSucceeded)" -ForegroundColor Red
}
```

## Notlar

- TURN server çalışıyor olsa bile Railway'in public domain'e expose etmesi gerekiyor
- Eğer bağlantı başarısız olursa, Railway Dashboard'da port mapping'i kontrol et
- Railway'in UDP desteği sınırlı olabilir, sadece TCP çalışabilir

