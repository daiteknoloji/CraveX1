# 🔍 RAILWAY CORS SORUNU - ÇÖZÜM REHBERİ

## ❌ Sorun

Frontend (Netlify: `cozy-dragon-54547b.netlify.app`) backend'e (Railway: `cravex1-production.up.railway.app`) bağlanamıyor:

```
Access to fetch at 'https://cravex1-production.up.railway.app/_matrix/client/versions' 
from origin 'https://cozy-dragon-54547b.netlify.app' has been blocked by CORS policy: 
No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

---

## 🔍 Neden Olabilir?

1. **Synapse başlamıyor**: Signing key veya diğer izin sorunları nedeniyle Synapse başlamıyor olabilir
2. **CORS ayarları eksik**: `cors_allowed_origins` doğru ayarlanmamış olabilir
3. **Railway reverse proxy**: Railway'in reverse proxy'si CORS headers'ı forward etmiyor olabilir

---

## ✅ ÇÖZÜM ADIMLARI

### 1. Railway'de Synapse Loglarını Kontrol Edin

Railway Dashboard → Synapse servisi → **Logs** sekmesine gidin ve şunları kontrol edin:

✅ **Synapse başarıyla başladı mı?**
- `Starting synapse with args -m synapse.app.homeserver` görünüyor mu?
- `PermissionError` hatası var mı?
- `Listening on` mesajı görünüyor mu?

❌ **Eğer hata varsa:**
- Signing key hatası: `/tmp/signing.key` izin sorunu olabilir
- Database hatası: PostgreSQL bağlantı sorunu olabilir

---

### 2. Synapse Health Check

Railway Dashboard → Synapse servisi → **Settings** → **Health Check**:

**Health Check Path:** `/health`
**Health Check Interval:** 30s

---

### 3. CORS Ayarlarını Doğrulayın

`synapse-railway-config/homeserver.yaml` dosyasında:

```yaml
cors_allowed_origins:
  - "https://vcravex1.netlify.app"
  - "https://cravex-admin.netlify.app"
  - "https://cozy-dragon-54547b.netlify.app"
```

✅ **Doğru mu?**
- Tüm Netlify domain'leri eklendi mi?
- Domain'ler tam URL mi? (https:// ile başlıyor mu?)

---

### 4. Railway Environment Variables Kontrol Edin

Railway Dashboard → Synapse servisi → **Variables**:

Şu variables'ların olduğundan emin olun:
- `SYNAPSE_SERVER_NAME`: `cravex1-production.up.railway.app`
- `SYNAPSE_NO_TLS`: `true` (Railway HTTPS handle ediyor)

---

### 5. Railway Port ve Public URL Kontrol Edin

Railway Dashboard → Synapse servisi → **Settings**:

✅ **Port:** `8008` expose edilmiş mi?
✅ **Public URL:** `https://cravex1-production.up.railway.app` doğru mu?

---

## 🎯 HIZLI TEST

### Browser Console'da Test:

```javascript
// Frontend'den backend'e direkt test
fetch('https://cravex1-production.up.railway.app/_matrix/client/versions')
  .then(r => r.json())
  .then(data => console.log('✅ Backend çalışıyor:', data))
  .catch(err => console.error('❌ Backend hatası:', err));
```

**Beklenen sonuç:**
- ✅ Eğer başarılı: Backend çalışıyor, CORS sorunu var
- ❌ Eğer hata: Backend çalışmıyor, Synapse başlamıyor

---

## 💡 ALTERNATİF ÇÖZÜMLER

### Seçenek 1: Railway Volume Ekle (ÖNERİLEN ama ÜCRETLİ)

Railway Dashboard → Synapse servisi → **Variables** → **Add Volume**:
- Mount path: `/data`
- **Create Volume**

Sonra `homeserver.yaml`'deki path'leri `/data`'ya geri çevirin.

---

### Seçenek 2: Railway'de CORS Headers Ekle (Nginx/Reverse Proxy)

Railway Dashboard → Synapse servisi → **Settings** → **Add Header**:

```yaml
Access-Control-Allow-Origin: https://cozy-dragon-54547b.netlify.app
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
```

---

### Seçenek 3: Netlify Proxy Kullan

`netlify.toml` dosyasına ekleyin:

```toml
[[redirects]]
  from = "/_matrix/*"
  to = "https://cravex1-production.up.railway.app/_matrix/:splat"
  status = 200
  force = true
  headers = {X-From = "Netlify"}
```

Bu sayede frontend ve backend aynı domain'den görünür (CORS sorunu olmaz).

---

## 📋 CHECKLIST

- [ ] Railway'de Synapse loglarını kontrol ettim
- [ ] Synapse başarıyla başladı mı kontrol ettim
- [ ] CORS ayarları doğru mu kontrol ettim
- [ ] Railway health check çalışıyor mu kontrol ettim
- [ ] Browser console'da test yaptım
- [ ] Railway port ve public URL doğru mu kontrol ettim

---

## 🆘 HALA ÇALIŞMIYORSA

1. Railway Dashboard → Synapse servisi → **Deployments** → **Redeploy**
2. Railway Dashboard → Synapse servisi → **Logs** → Tüm logları kontrol edin
3. Browser console'da CORS hatası hala var mı kontrol edin

---

**Son Güncelleme:** 5 Kasım 2025

