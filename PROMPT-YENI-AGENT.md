# Video Call Sorunu - Durum Özeti ve Devam İçin Prompt

## Sorun
Video call çalışmıyor - ses ve görüntü yok. Railway TURN server çalışmıyor (port 3478 expose edilemedi).

## Yapılan Değişiklikler

### 1. Config Değişiklikleri
- `www/element-web/config.json`: Railway TURN server kaldırıldı, Metered.ca öncelikli yapıldı
- `synapse-railway-config/homeserver.yaml`: Railway TURN server kaldırıldı, Metered.ca öncelikli yapıldı

**Güncel TURN Server Sırası:**
1. Metered.ca (relay.metered.ca) - ✅ Çalışıyor
2. Metered.ca (openrelay.metered.ca) - ✅ Çalışıyor  
3. Matrix.org TURN - ✅ Çalışıyor

### 2. Debug Logging Eklendi
- `www/element-web/src/LegacyCallHandler.tsx`: ICE debug logging eklendi
  - ICE connection state monitoring
  - ICE candidates logging
  - TURN server response logging

### 3. TURN Server Config Düzeltildi
- `turnserver.conf`: `lt-cred-mech` kaldırıldı (use-auth-secret ile çakışıyordu)

## Git Durumu
Değişiklikler yapıldı ama henüz commit edilmedi.

## Sonraki Adımlar

1. **Git Commit ve Push:**
   ```powershell
   git add www/element-web/config.json synapse-railway-config/homeserver.yaml www/element-web/src/LegacyCallHandler.tsx turnserver.conf
   git commit -m "Remove Railway TURN server, prioritize Metered.ca, add ICE debug logging"
   git push origin main
   git push cravex1 main --force
   ```

2. **Deploy Bekle:**
   - Netlify otomatik deploy başlayacak
   - Railway Synapse otomatik redeploy olacak

3. **Test:**
   - Video call başlat
   - Browser console'da `[ICE Debug]` loglarını kontrol et
   - Metered.ca'dan `relay` candidate geliyorsa çalışıyor

## Beklenen Sonuç
Video call Metered.ca TURN server ile çalışmalı. Railway TURN server denenmeyecek.

## Önemli Dosyalar
- `www/element-web/config.json` - TURN server config
- `synapse-railway-config/homeserver.yaml` - Synapse TURN config
- `www/element-web/src/LegacyCallHandler.tsx` - ICE debug logging
- `turnserver.conf` - TURN server config (Railway'de çalışmıyor)


