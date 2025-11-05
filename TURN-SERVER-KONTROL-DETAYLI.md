# 🔍 TURN SERVER KONTROL - DETAYLI ADIMLAR

**Durum:** "Got TURN URIs" log'u görünmüyor.

**Olası Nedenler:**
1. Sayfa henüz yenilenmemiş
2. Login olmamış
3. TURN server bilgileri henüz yüklenmemiş
4. Log farklı bir formatta görünüyor

---

## ✅ ADIM ADIM KONTROL

### Adım 1: Sayfayı Yenile ve Login Ol

1. **Sayfayı yenile** (F5 veya Ctrl+R)
2. **Login ol** (eğer login olmadıysan)
3. **Console'u açık tut** (F12)

---

### Adım 2: Synapse API'den Direkt Çek

**Browser Console'da:**

```javascript
const client = window.mxMatrixClientPeg?.get();
if (client) {
  const token = client.getAccessToken();
  
  console.log('🔍 Synapse TURN Server API çağrısı yapılıyor...');
  
  fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
    headers: {
      'Authorization': 'Bearer ' + token
    }
  })
  .then(r => {
    console.log('Response Status:', r.status);
    return r.json();
  })
  .then(data => {
    console.log('✅ Synapse TURN Server Response:');
    console.log('URIs:', data.uris);
    console.log('Username:', data.username);
    console.log('Credential:', data.credential ? '***' : 'yok');
    
    if (data.uris && Array.isArray(data.uris)) {
      console.log('\n📊 URI Analizi:');
      data.uris.forEach((uri, i) => {
        const isRailway = uri.includes('railway') || uri.includes('turn-server-production');
        console.log(`  ${i + 1}. ${uri} ${isRailway ? '❌ (Railway)' : ''}`);
      });
      
      const railwayUris = data.uris.filter(uri => 
        uri.includes('railway') || uri.includes('turn-server-production')
      );
      
      if (railwayUris.length > 0) {
        console.error('\n❌ Railway TURN server bulundu:', railwayUris);
        console.error('   → Railway TURN server\'ı pause et ve Synapse\'i redeploy et!');
      } else {
        console.log('\n✅ Railway TURN server yok - Başarılı!');
        console.log('   → Video call çalışmalı!');
      }
      
      const meteredUris = data.uris.filter(uri => uri.includes('metered.ca'));
      if (meteredUris.length > 0) {
        console.log(`\n✅ Metered.ca server'lar: ${meteredUris.length} adet`);
      }
      
      const matrixUris = data.uris.filter(uri => uri.includes('matrix.org'));
      if (matrixUris.length > 0) {
        console.log(`✅ Matrix.org server'lar: ${matrixUris.length} adet`);
      }
    } else {
      console.error('❌ URIs bulunamadı veya array değil!');
      console.log('Response:', data);
    }
  })
  .catch(err => {
    console.error('❌ Hata:', err);
    console.error('   → Token kontrolü yap:', token ? 'Token var' : 'Token yok');
  });
} else {
  console.error('❌ Client bulunamadı!');
  console.error('   → Sayfayı yenile ve login ol');
}
```

---

### Adım 3: Client State'i Kontrol Et

**Browser Console'da:**

```javascript
const client = window.mxMatrixClientPeg?.get();
if (client) {
  console.log('🔍 Client State Kontrolü:');
  
  // TURN server bilgileri kontrolü
  const turnServers = client.getTurnServers();
  console.log('getTurnServers():', turnServers);
  console.log('Length:', turnServers ? turnServers.length : 'undefined');
  
  // TURN server expiry kontrolü
  if (typeof client.getTurnServersExpiry === 'function') {
    const expiry = client.getTurnServersExpiry();
    console.log('TURN Servers Expiry:', new Date(expiry));
    console.log('TURN Servers Valid:', expiry > Date.now());
  }
  
  // Client'ın TURN server ile ilgili property'leri
  const turnRelatedKeys = Object.keys(client).filter(k => 
    k.toLowerCase().includes('turn') || 
    k.toLowerCase().includes('voip') ||
    k.toLowerCase().includes('ice')
  );
  console.log('TURN/VoIP/ICE related keys:', turnRelatedKeys);
  
  // Eğer turnServers varsa, detaylarını göster
  if (turnServers && turnServers.length > 0) {
    console.log('\n📊 TURN Server Detayları:');
    turnServers.forEach((server, i) => {
      console.log(`Server ${i + 1}:`, JSON.stringify(server, null, 2));
    });
  } else {
    console.log('\n⚠️ TURN servers henüz yüklenmemiş olabilir');
    console.log('   → Birkaç saniye bekle ve tekrar dene');
  }
}
```

---

### Adım 4: Network Tab'den Kontrol Et

**Browser DevTools'da:**

1. **Network** sekmesini aç
2. **Filter:** `turnServer` yaz
3. **Sayfayı yenile** veya bir video call başlat
4. **turnServer** isteğini bul
5. **Response** sekmesini aç
6. **URIs** array'ini kontrol et

**Beklenen URL:**
```
https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer
```

---

## 🎯 HIZLI KONTROL

**En basit yöntem:**

1. **Sayfayı yenile** (F5)
2. **Login ol**
3. **5-10 saniye bekle** (TURN server bilgileri yüklenmesi için)
4. **Yukarıdaki "Adım 2" komutunu çalıştır**

---

## 📊 BEKLENEN SONUÇ

### Railway TURN Server Yoksa (Başarılı):

```json
{
  "uris": [
    "turn:relay.metered.ca:80",
    "turn:relay.metered.ca:443",
    ...
  ],
  "username": "...",
  "credential": "..."
}
```

### Railway TURN Server Varsa (Sorun):

```json
{
  "uris": [
    "turn:turn-server-production-2809.up.railway.app:3478?transport=tcp",
    "turn:relay.metered.ca:80",
    ...
  ],
  ...
}
```

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Detaylı kontrol adımları eklendi

