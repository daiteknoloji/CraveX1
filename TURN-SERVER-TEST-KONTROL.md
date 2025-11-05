# TURN Server Test ve Kontrol Kılavuzu

## TURN Server Durumu (Loglardan)

### ✅ Çalışıyor:
- Port 3478'de TCP listener'lar açık
- UDP listener'lar açık
- Realm: `cravex1-production.up.railway.app`
- Shared secret authentication aktif

### ⚠️ Uyarılar:
- `--lt-cred-mech` ve `--use-auth-secret` aynı anda kullanılıyor (karışıklık olabilir)
- Config'de `no-udp-relay` var ama UDP listener'lar açık (çelişki)

## TURN Server Test Komutları

### 1. Basit TCP Bağlantı Testi

```bash
# PowerShell'de:
Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478

# Veya curl ile:
curl -v telnet://turn-server-production-2809.up.railway.app:3478
```

### 2. TURN Server Test (WebRTC Test Tool)

Online test araçları:
- https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/
- https://icetest.info/

Test parametreleri:
```
TURN Server URL: turn:turn-server-production-2809.up.railway.app:3478?transport=tcp
Username: webrtc
Password: secret
```

### 3. Browser Console'dan Test

```javascript
// TURN server response'u kontrol et
const client = window.mxMatrixClientPeg?.get();
if (client) {
  const turnServers = client.getTurnServers();
  console.log('TURN Servers:', turnServers);
  
  // Railway TURN server'ı bul
  const railwayTurn = turnServers.find(s => 
    s.uris.some(uri => uri.includes('turn-server-production-2809'))
  );
  console.log('Railway TURN:', railwayTurn);
}
```

### 4. Railway Dashboard'dan Kontrol

1. Railway Dashboard'a git
2. TURN server servisini bul
3. "Metrics" sekmesine git
4. "Connections" veya "Sessions" grafiğini kontrol et
5. Eğer hiç connection yoksa, server'a erişilemiyor demektir

## Sorun Giderme

### Eğer TURN server'a erişilemiyorsa:

1. **Railway Public Domain Kontrolü:**
   - Railway servisinin public domain'i var mı?
   - Port 3478 expose edilmiş mi?

2. **Config Düzeltmesi:**
   - `turnserver.conf`'da `--lt-cred-mech` kaldırılmalı (sadece `--use-auth-secret` kullan)
   - UDP relay gerekmiyorsa `no-udp-relay` kalabilir ama UDP listener'ları kapatmak daha iyi

3. **Railway Port Mapping:**
   - Railway'de port 3478'in public'e expose edildiğinden emin ol
   - Railway'in UDP desteği sınırlı olabilir

## TURN Server Config Düzeltmesi

`turnserver.conf` düzeltilmesi gereken yerler:

```conf
# lt-cred-mech kaldırılmalı (sadece use-auth-secret kullan)
# lt-cred-mech  # KALDIR

# UDP relay kapalı ama UDP listener açık - bu çelişki
# no-udp-relay zaten var, bu yeterli
```

## Test Sonuçları

### Başarılı Test:
- TCP bağlantısı başarılı
- TURN server response veriyor
- ICE candidates alınıyor

### Başarısız Test:
- TCP bağlantısı zaman aşımına uğruyor
- Connection refused hatası
- Railway domain'e erişilemiyor

## Sonraki Adımlar

1. Railway Dashboard'da TURN server servisini kontrol et
2. Public domain'in doğru olduğunu kontrol et
3. Port 3478'in expose edildiğini kontrol et
4. Browser console'da TURN server response'u kontrol et
5. Eğer çalışmıyorsa, config'i düzelt ve yeniden deploy et

