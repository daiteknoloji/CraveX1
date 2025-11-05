# 🚨 RAILWAY TURN SERVER KALDIRMA ADIMLARI

**Durum:** Railway TURN server hala Synapse response'unda ❌  
**Çözüm:** Railway TURN server'ı pause et ve Synapse'i redeploy et

---

## ✅ ADIM ADIM ÇÖZÜM

### Adım 1: Railway Dashboard'a Git

1. **Railway Dashboard:** https://railway.app
2. **Login ol**
3. **Projenizi seç**

---

### Adım 2: Railway TURN Server Servisini Pause Et

1. **`turn-server`** servisini bul
2. **Servisi seç**
3. **Settings** sekmesine git
4. **Service Actions** bölümünü bul
5. **Pause Service** butonuna tıkla
   - Veya servisi tamamen **Delete** edebilirsin

**Alternatif:** Eğer pause butonu görünmüyorsa:
- **Settings** → **Teardown** → Servisi durdur

---

### Adım 3: Synapse Service'i Redeploy Et

1. **Railway Dashboard'da** → **Synapse** servisini seç
2. **Settings** sekmesine git
3. **Service Actions** bölümünü bul
4. **Redeploy** butonuna tıkla
5. **Deployment tamamlanmasını bekle** (2-3 dakika)

---

### Adım 4: Test Et

**Sayfayı yenile ve tekrar kontrol et:**

```javascript
const client = window.mxMatrixClientPeg?.get();
if (client) {
  const token = client.getAccessToken();
  
  fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
    headers: {
      'Authorization': 'Bearer ' + token
    }
  })
  .then(r => r.json())
  .then(data => {
    console.log('🔍 Yeni TURN Server Response:');
    console.log('URIs:', data.uris);
    
    if (data.uris && Array.isArray(data.uris)) {
      const railwayUris = data.uris.filter(uri => 
        uri.includes('railway') || uri.includes('turn-server-production')
      );
      
      if (railwayUris.length > 0) {
        console.error('❌ Railway TURN server hala var:', railwayUris);
        console.error('   → Railway TURN server pause edildi mi kontrol et!');
        console.error('   → Synapse redeploy edildi mi kontrol et!');
      } else {
        console.log('✅ Railway TURN server yok - Başarılı!');
        console.log('   → Video call\'u test et!');
      }
    }
  });
}
```

---

## 🎯 BEKLENEN SONUÇ

### Railway TURN Server Kaldırıldıktan Sonra:

**Console'da görülmesi gereken:**
```
✅ Railway TURN server yok - Başarılı!
```

**TURN Server Response'unda görülmesi gereken:**
```json
{
  "uris": [
    "turn:relay.metered.ca:80",
    "turn:relay.metered.ca:443",
    "turn:relay.metered.ca:80?transport=tcp",
    "turn:relay.metered.ca:443?transport=tcp",
    "turn:openrelay.metered.ca:80",
    "turn:openrelay.metered.ca:443",
    "turn:openrelay.metered.ca:80?transport=tcp",
    "turn:openrelay.metered.ca:443?transport=tcp",
    "turn:turn.matrix.org:3478?transport=udp",
    "turn:turn.matrix.org:3478?transport=tcp",
    "turns:turn.matrix.org:443?transport=tcp"
  ],
  "username": "...",
  "credential": "..."
}
```

**Railway TURN server olmamalı!**

---

## 🔄 ALTERNATİF: Railway TURN Server'ı Delete Et

**Eğer pause çalışmazsa:**

1. **Railway Dashboard** → **`turn-server`** servisi
2. **Settings** → **General** → **Delete Service**
3. **Onayla**
4. **Synapse'i redeploy et**

---

## 📊 VIDEO CALL TESTİ

**Railway TURN server kaldırıldıktan sonra:**

1. **Sayfayı yenile** (F5)
2. **Video call başlat**
3. **Console'da kontrol et:**
   - `typ relay` candidate oluşuyor mu?
   - ICE connection `connected` oluyor mu?

**Beklenen log:**
```
Call ... onIceConnectionStateChanged() running (state=connected, conn=connected)
```

---

## ⚠️ ÖNEMLİ NOTLAR

1. **Railway TURN server'ı pause ettikten sonra** Synapse'i mutlaka **redeploy et**
2. **Synapse redeploy tamamlanmasını bekle** (2-3 dakika)
3. **Sayfayı yenile** ve login ol
4. **TURN server response'unu tekrar kontrol et**

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Railway TURN server kaldırma adımları belirlendi

