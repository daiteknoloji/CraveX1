# 🆕 YENİ NETLIFY PROJESİ - TEST REHBERİ

**Yeni Proje:** crvx2  
**URL:** https://crvx2.netlify.app  
**GitHub Repo:** https://github.com/daiteknoloji/CraveX1

---

## ✅ YAPILAN DÜZELTMELER

1. ✅ `@babel/plugin-transform-private-methods` eklendi
2. ✅ `@babel/plugin-transform-private-property-in-object` eklendi
3. ✅ Plugin'ler decorator'lardan önce sıralandı
4. ✅ `@babel/preset-typescript` doğru configure edildi
5. ✅ GitHub'a push yapıldı

---

## 🔍 YENİ DOMAIN'DE TEST EDİLMESİ GEREKENLER

### 1. Build Başarılı mı? ✅

**Kontrol:**
- Netlify Dashboard → **Deploys** sekmesi
- Son deploy'u kontrol et
- Build başarılı mı? (yeşil ✓)
- Hata var mı? (kırmızı ✗)

**Beklenen:**
- ✅ Build başarılı olmalı
- ✅ `private` keyword hatası OLMAMALI
- ✅ Webpack compile başarılı olmalı

---

### 2. Video Call Test 🎥

**Test Adımları:**

1. **Yeni Domain'i Aç:**
   - https://crvx2.netlify.app
   - Login ol

2. **Video Call Başlat:**
   - Başka bir kullanıcıyla video call başlat
   - Veya kendi hesabınla iki farklı browser'da test et

3. **Console Loglarını Kontrol Et:**
   - Browser Console'u aç (F12)
   - `[ICE Debug]` loglarını ara
   - `Got TURN URIs` logunu kontrol et

4. **TURN Server Kontrolü:**
   ```javascript
   const matrixClient = window.mxMatrixClientPeg.get();
   const turnServers = matrixClient.getTurnServers();
   console.log("TURN Servers:", turnServers);
   ```

**Beklenen:**
- ✅ Railway TURN server OLMAMALI
- ✅ Metered.ca ve Matrix.org TURN server'ları olmalı
- ✅ ICE connection başarılı olmalı

---

### 3. TURN Server Kontrolü 🔍

**Console'da Kontrol Et:**

```javascript
// TURN server'ları kontrol et
const matrixClient = window.mxMatrixClientPeg.get();
const turnServers = matrixClient.getTurnServers();
console.log("TURN Servers:", turnServers);

// Veya direkt API'den kontrol et
fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer')
  .then(r => r.json())
  .then(data => console.log("Synapse TURN Response:", data));
```

**Beklenen:**
- ✅ Railway TURN server OLMAMALI
- ✅ Metered.ca TURN server'ları olmalı
- ✅ Matrix.org TURN server'ları olmalı

---

### 4. Video Call Sorunları Kontrolü ⚠️

**Eğer Video Call Çalışmıyorsa:**

1. **ICE Connection Durumu:**
   - Console'da `[ICE Debug]` loglarını kontrol et
   - `connectionState` nedir?
   - `failed` görüyorsan TURN server sorunu var

2. **TURN Server Erişilebilirliği:**
   - Metered.ca TURN server'ları çalışıyor mu?
   - Matrix.org TURN server'ları çalışıyor mu?

3. **Network Sorunları:**
   - Firewall sorunu var mı?
   - NAT traversal sorunu var mı?

---

## 📋 TEST KONTROL LİSTESİ

- [ ] Build başarılı mı?
- [ ] Site açılıyor mu? (https://crvx2.netlify.app)
- [ ] Login olabiliyor musun?
- [ ] Video call başlatabiliyor musun?
- [ ] ICE connection başarılı mı?
- [ ] Railway TURN server listede mi? (OLMAMALI)
- [ ] Metered.ca TURN server çalışıyor mu?
- [ ] Matrix.org TURN server çalışıyor mu?

---

## 🔗 YENİ PROJE BİLGİLERİ

**Netlify Sites:**
1. **crvx2** (YENİ) - https://crvx2.netlify.app
2. **cozy-dragon-54547b** - https://cozy-dragon-54547b.netlify.app

**Her İkisi de Aynı Repo'dan Deploy Ediliyor:**
- GitHub Repo: https://github.com/daiteknoloji/CraveX1
- Branch: `main`

---

## 💡 ÖNEMLİ NOTLAR

1. **Build Sorunları:**
   - Eğer build hatası varsa → Babel config'i kontrol et
   - `private` keyword hatası varsa → Plugin'ler yüklenmiş mi kontrol et

2. **Video Call Sorunları:**
   - Build başarılı ama video call çalışmıyorsa → TURN server sorunu var
   - Railway TURN server hala listede mi kontrol et
   - Synapse'i redeploy et gerekirse

3. **Domain Farkı:**
   - Yeni domain sadece frontend'i değiştirir
   - Backend (Synapse) aynı → Railway'de
   - TURN server sorunları aynı kalabilir

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** ✅ Yeni proje oluşturuldu, test bekleniyor

