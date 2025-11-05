# 🆕 YENİ NETLIFY PROJESİ - crvx2 TEST REHBERİ

**Yeni Proje:** crvx2  
**URL:** https://crvx2.netlify.app  
**Admin URL:** https://app.netlify.com/projects/crvx2  
**GitHub Repo:** https://github.com/daiteknoloji/CraveX1

---

## ✅ YENİ DOMAIN'DE TEST EDİLMESİ GEREKENLER

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

### 2. Site Açılıyor mu? 🌐

**Test:**
1. https://crvx2.netlify.app adresini aç
2. Site yükleniyor mu?
3. Login sayfası görünüyor mu?

**Beklenen:**
- ✅ Site açılmalı
- ✅ Element Web arayüzü görünmeli
- ✅ Login yapabilmelisin

---

### 3. Video Call Test 🎥

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

**Beklenen:**
- ✅ Video call başlatılabilmeli
- ✅ ICE connection başarılı olmalı
- ✅ Railway TURN server OLMAMALI

---

### 4. TURN Server Kontrolü 🔍

**Console'da Kontrol Et:**

```javascript
// TURN server'ları kontrol et
const matrixClient = window.mxMatrixClientPeg.get();
const turnServers = matrixClient.getTurnServers();
console.log("TURN Servers:", turnServers);

// Detaylı kontrol
turnServers.forEach((server, index) => {
    console.log(`TURN Server ${index + 1}:`, server);
    console.log("URIs:", server.uris);
});
```

**Beklenen:**
- ✅ Railway TURN server OLMAMALI
- ✅ Metered.ca TURN server'ları olmalı
- ✅ Matrix.org TURN server'ları olmalı

---

### 5. Synapse TURN Server API Kontrolü 🔍

**Console'da Kontrol Et:**

```javascript
// Synapse API'den direkt kontrol
fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer')
  .then(r => r.json())
  .then(data => {
      console.log("Synapse TURN Response:", data);
      console.log("TURN URIs:", data.uris);
      
      // Railway TURN server var mı kontrol et
      const hasRailway = data.uris && data.uris.some(uri => uri.includes('railway'));
      console.log("Railway TURN server var mı?", hasRailway);
  });
```

**Beklenen:**
- ✅ Railway TURN server OLMAMALI
- ✅ Metered.ca ve Matrix.org TURN server'ları olmalı

---

## ⚠️ OLASI SORUNLAR VE ÇÖZÜMLER

### Sorun 1: Build Başarısız ❌

**Neden:**
- Babel config sorunu
- Dependencies eksik
- `private` keyword hatası

**Çözüm:**
- Netlify build loglarını kontrol et
- `babel.config.js` dosyasını kontrol et
- Dependencies yüklü mü kontrol et

---

### Sorun 2: Video Call Çalışmıyor ❌

**Neden:**
- Railway TURN server hala listede
- TURN server'lar çalışmıyor
- ICE connection başarısız

**Çözüm:**
- Railway TURN server'ı kontrol et (silinmiş olmalı)
- Synapse'i redeploy et
- Metered.ca TURN server'ları test et

---

### Sorun 3: TURN Server Sorunları ❌

**Neden:**
- Synapse cache sorunu
- Railway service discovery
- Environment variables

**Çözüm:**
- Synapse'i force redeploy et
- Railway environment variables kontrol et
- Railway TURN server servisini kontrol et

---

## 📋 TEST KONTROL LİSTESİ

### Build Kontrolü:
- [ ] Build başarılı mı?
- [ ] `private` keyword hatası var mı? (OLMAMALI)
- [ ] Webpack compile başarılı mı?

### Site Kontrolü:
- [ ] Site açılıyor mu? (https://crvx2.netlify.app)
- [ ] Login olabiliyor musun?
- [ ] Element Web arayüzü görünüyor mu?

### Video Call Kontrolü:
- [ ] Video call başlatabiliyor musun?
- [ ] ICE connection başarılı mı?
- [ ] Railway TURN server listede mi? (OLMAMALI)
- [ ] Metered.ca TURN server çalışıyor mu?
- [ ] Matrix.org TURN server çalışıyor mu?

---

## 🔗 NETLIFY PROJELERİ

**Mevcut Projeler:**
1. **crvx2** (YENİ) - https://crvx2.netlify.app
2. **cozy-dragon-54547b** - https://cozy-dragon-54547b.netlify.app

**Her İkisi de Aynı Repo'dan Deploy Ediliyor:**
- GitHub Repo: https://github.com/daiteknoloji/CraveX1
- Branch: `main`

---

## 💡 ÖNEMLİ NOTLAR

1. **Domain Farkı:**
   - Yeni domain sadece frontend'i değiştirir
   - Backend (Synapse) aynı → Railway'de
   - TURN server sorunları aynı kalabilir

2. **Build Sorunları:**
   - Eğer build hatası varsa → Babel config'i kontrol et
   - `private` keyword hatası varsa → Plugin'ler yüklenmiş mi kontrol et

3. **Video Call Sorunları:**
   - Build başarılı ama video call çalışmıyorsa → TURN server sorunu var
   - Railway TURN server hala listede mi kontrol et
   - Synapse'i redeploy et gerekirse

---

## 🚀 SONRAKI ADIMLAR

1. **Netlify Dashboard'dan Build Kontrolü:**
   - https://app.netlify.com/projects/crvx2
   - Deploys sekmesi → Build durumunu kontrol et

2. **Site Test:**
   - https://crvx2.netlify.app → Site açılıyor mu?

3. **Video Call Test:**
   - Login ol → Video call başlat → Console loglarını kontrol et

4. **TURN Server Kontrolü:**
   - Console'da TURN server'ları kontrol et
   - Railway TURN server var mı?

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** ✅ Yeni proje bağlandı, test bekleniyor

