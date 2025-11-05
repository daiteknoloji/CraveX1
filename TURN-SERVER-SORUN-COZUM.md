# TURN Server Test Sonucu ve Çözüm

## Test Sonucu

```
PingSucceeded: True (72ms RTT)
TcpTestSucceeded: False ❌
```

### Analiz:
- ✅ Server çalışıyor (ping başarılı)
- ❌ Port 3478 public'e expose edilmemiş
- ❌ Railway port mapping yapılmamış

## Sorun

Railway'de port 3478'in public domain'e expose edilmesi gerekiyor. Railway'in UDP/TCP port desteği sınırlı olabilir.

## Çözüm Seçenekleri

### Seçenek 1: Railway Port Mapping (Önerilen)

1. Railway Dashboard'a git
2. TURN server servisini bul
3. "Settings" → "Networking" sekmesine git
4. Port 3478'i expose et:
   - Port: `3478`
   - Protocol: `TCP`
   - Public URL oluştur

### Seçenek 2: Railway Public Domain Kullan

Railway'in otomatik public domain'i kullan (örn: `turn-server-production-2809.up.railway.app`):
- Railway otomatik olarak HTTP/HTTPS portlarını expose eder
- Ama custom port (3478) için manuel mapping gerekebilir

### Seçenek 3: Fallback Server'lara Güven (Geçici)

Metered.ca ve Matrix.org TURN server'ları zaten çalışıyor:
- Config'de Railway TURN server'ı kaldır veya en alta al
- Metered.ca server'larına öncelik ver

### Seçenek 4: Railway UDP/TCP Limiti

Railway'in UDP desteği sınırlı olabilir:
- Sadece HTTP/HTTPS portları otomatik expose edilir
- Custom port'lar için ek ayar gerekebilir

## Hızlı Çözüm

Config'de Railway TURN server'ı kaldır veya en alta al:

```json
// config.json'da Railway TURN server'ı kaldır veya en alta al
"turn_servers": [
    {
        "urls": ["turn:relay.metered.ca:80", ...],
        "username": "openrelayproject",
        "credential": "openrelayproject"
    },
    // Railway TURN server'ı kaldır veya en alta al
]
```

## Railway Dashboard Kontrolü

1. Railway Dashboard → TURN server servisi
2. "Settings" → "Networking"
3. "Public Networking" bölümünü kontrol et
4. Port 3478'in expose edildiğini kontrol et
5. Eğer yoksa, "Expose Port" butonuna tıkla

## Not

Railway'in free tier'ında custom port expose etme sınırlaması olabilir. Bu durumda:
- Metered.ca server'larına güven (ücretsiz ve çalışıyor)
- Railway TURN server'ı sadece internal network için kullan

