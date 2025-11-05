# 🔧 VIDEO CALL ÇÖZÜM PLANI

**Tarih:** 1 Kasım 2025  
**Durum:** TURN URI'ler var ama Railway TURN server ilk sırada ve çalışmıyor

---

## 📊 MEVCUT DURUM

### ✅ İyi Haberler:
- TURN URI'leri client'a geliyor (12 URI var)
- Metered.ca server'ları config'de
- Matrix.org fallback var

### ❌ Sorunlar:
- Railway TURN server ilk sırada (`turn-server-production-2809.up.railway.app`)
- Railway TURN server çalışmıyor olabilir
- Client Railway TURN server'ı deniyor, başarısız oluyor, ama diğerlerine geçemiyor
- `relay` type candidate oluşmuyor

---

## 🔍 SORUN ANALİZİ

### TURN Server Sırası (Synapse'den Gelen):

1. ❌ **Railway TURN** (`turn-server-production-2809.up.railway.app:3478?transport=tcp`)
2. ✅ Metered.ca (`relay.metered.ca`)
3. ✅ Metered.ca (`openrelay.metered.ca`)
4. ✅ Matrix.org (`turn.matrix.org`)

**Sorun:** Railway TURN server çalışmıyor ama ilk sırada, bu yüzden client onu deniyor ve başarısız oluyor.

---

## 🛠️ ÇÖZÜM ADIMLARI

### Adım 1: Railway TURN Server'ı Devre Dışı Bırak ✅

**Railway Dashboard'da:**

1. Railway Dashboard'a git: https://railway.app
2. Projenizi seç
3. TURN Server servisini bul
4. Servisi **pause** veya **delete** et

**VEYA**

**Railway Environment Variables'da:**

Railway Dashboard → Variables sekmesi:
- TURN server ile ilgili env variable'ları kontrol et
- TURN server URL'ini kaldır veya disable et

---

### Adım 2: Synapse Config'i Güncelle ✅

`synapse-railway-config/homeserver.yaml` dosyasında Railway TURN server zaten yok ✅

**Ama Railway'de başka bir config kullanılıyor olabilir.**

**Railway'de kontrol et:**
- Railway Dashboard → Synapse service → Settings → Environment Variables
- `TURN_SERVER_URL` veya benzeri bir variable var mı?
- Varsa kaldır veya boş bırak

---

### Adım 3: Element Web Config'ini Güncelle ✅

`www/element-web/config.json` dosyasında Railway TURN server yok ✅

**Ama production build'de farklı bir config kullanılıyor olabilir.**

**Kontrol:**
- `www/element-web/config.production.json` var mı?
- Netlify'da environment variable'lar var mı?

---

### Adım 4: Geçici Çözüm - Railway TURN Server'ı Bypass Et ✅

**Browser console'da test:**

```javascript
// TURN server'ları filtrele ve Railway'yi kaldır
const client = window.mxMatrixClientPeg?.get();
if (client) {
  // Mevcut TURN server'ları al
  const turnServers = await client.getTurnServers();
  console.log('Mevcut TURN Servers:', turnServers);
  
  // Railway TURN server'ı filtrele
  const filteredServers = turnServers.map(server => {
    if (server.uris) {
      const filteredUris = server.uris.filter(uri => 
        !uri.includes('turn-server-production-2809.up.railway.app')
      );
      return {
        ...server,
        uris: filteredUris
      };
    }
    return server;
  });
  
  console.log('Filtrelenmiş TURN Servers:', filteredServers);
}
```

**Not:** Bu sadece test için, kalıcı çözüm değil.

---

## 🎯 KALICI ÇÖZÜM

### Railway'de TURN Server'ı Kaldır

**Railway Dashboard'da:**

1. **TURN Server servisini bul:**
   - Railway Dashboard → Projeniz
   - Servisler listesinde `turn-server-production-2809` veya benzeri bir servis var mı?

2. **Servisi kaldır:**
   - Servisi seç → Settings → Delete Service
   - Veya servisi pause et

3. **Synapse service'ini kontrol et:**
   - Synapse service → Settings → Environment Variables
   - TURN server ile ilgili variable'ları kaldır

---

### Synapse Config'i Railway'de Güncelle

**Railway Dashboard'da:**

1. Synapse service → Settings → Variables
2. `TURN_URIS` veya benzeri bir variable var mı?
3. Varsa düzenle ve Railway TURN server'ı kaldır

**VEYA**

**Railway'de redeploy:**

1. `synapse-railway-config/homeserver.yaml` dosyasını güncelle
2. Railway'de redeploy yap
3. Railway otomatik olarak yeni config'i kullanacak

---

## 📝 HIZLI TEST

**Browser console'da:**

```javascript
// TURN server'ları kontrol et
const client = window.mxMatrixClientPeg?.get();
if (client) {
  client.getTurnServers().then(servers => {
    console.log('🔍 TURN Server Analizi:');
    
    servers.forEach((server, i) => {
      console.log(`\nServer ${i+1}:`);
      console.log('  URIs:', server.uris);
      
      if (server.uris) {
        const railwayServer = server.uris.find(uri => 
          uri.includes('railway')
        );
        
        if (railwayServer) {
          console.error('  ❌ Railway TURN server bulundu:', railwayServer);
        } else {
          console.log('  ✅ Railway TURN server yok');
        }
        
        const meteredServer = server.uris.find(uri => 
          uri.includes('metered.ca')
        );
        
        if (meteredServer) {
          console.log('  ✅ Metered.ca server bulundu:', meteredServer);
        }
      }
    });
  });
}
```

---

## 🎯 SONUÇ VE ÖNERİLER

### Şu Anki Durum:
- ✅ TURN URI'leri client'a geliyor
- ❌ Railway TURN server ilk sırada ve çalışmıyor
- ❌ Client Railway TURN server'ı deniyor, başarısız oluyor

### Çözüm:
1. **Railway Dashboard'da TURN server servisini kaldır/pause et**
2. **Synapse service'i redeploy et**
3. **Video call'u tekrar test et**

### Beklenen Sonuç:
- Railway TURN server listeden çıkacak
- Metered.ca server'ları öncelikli olacak
- `relay` type candidate oluşacak
- Video call çalışacak ✅

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Çözüm planı hazırlandı

