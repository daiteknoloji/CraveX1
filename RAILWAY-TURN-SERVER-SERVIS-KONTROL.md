# 🔍 RAILWAY TURN SERVER NEDEN HALA LİSTEDE?

**Durum:** Railway environment variable'larında Railway TURN server yok ✅  
**Sorun:** Railway TURN server hala Synapse response'unda ❌

---

## 🔍 OLASI NEDENLER

### 1. Railway TURN Server Servisi Hala Çalışıyor

**Railway'in otomatik service discovery özelliği olabilir:**
- Railway TURN server servisi çalışıyorsa
- Railway otomatik olarak onu Synapse'e ekliyor olabilir

**Çözüm:** Railway TURN server servisini pause et veya delete et

---

### 2. Railway Private Network Discovery

**Railway internal network üzerinden keşfediliyor olabilir:**
- Railway TURN server `turn-server.railway.internal` üzerinden erişilebilir
- Synapse otomatik olarak internal network'teki servisleri keşfediyor olabilir

**Çözüm:** Railway TURN server servisini pause et

---

### 3. Railway Config File

**Railway Config File'da tanımlı olabilir:**
- Railway Dashboard → Synapse → Settings → Config-as-code
- Railway Config File'da Railway TURN server tanımlı olabilir

**Çözüm:** Railway Config File'ı kontrol et ve Railway TURN server'ı kaldır

---

## ✅ ÇÖZÜM ADIMLARI

### Adım 1: Railway TURN Server Servisini Kontrol Et

**Railway Dashboard'da:**

1. **`turn-server`** servisini seç
2. **Deployments** sekmesi → Son deployment durumu nedir?
3. **Settings** → Servis **pause** mu yoksa **active** mi?

**Eğer active ise:**
- **Settings** → **Service Actions** → **Pause Service**
- Veya servisi **Delete** et

---

### Adım 2: Railway Config File Kontrol Et

**Railway Dashboard'da:**

1. **Synapse** servisi
2. **Settings** → **Config-as-code** sekmesi
3. **Railway Config File** var mı kontrol et
4. **Eğer varsa:** Railway TURN server URL'ini içeren satırı kaldır

---

### Adım 3: Synapse Service'i Redeploy Et

**Railway Dashboard'da:**

1. **Synapse** servisi
2. **Settings** → **Service Actions** → **Redeploy**
3. **Deployment tamamlanmasını bekle** (2-3 dakika)

---

### Adım 4: Test Et

**Sayfayı yenile ve tekrar kontrol et:**

```javascript
const client = window.mxMatrixClientPeg?.get();
if (client) {
  const token = client.getAccessToken();
  
  fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
    headers: { 'Authorization': 'Bearer ' + token }
  })
  .then(r => r.json())
  .then(data => {
    const railwayUris = data.uris.filter(uri => uri.includes('railway'));
    if (railwayUris.length > 0) {
      console.error('❌ Railway TURN hala var:', railwayUris);
      console.error('   → Railway TURN server servisini pause et!');
    } else {
      console.log('✅ Railway TURN yok - Başarılı!');
    }
  });
}
```

---

## 🎯 EN ÖNEMLİ ADIM

**Railway TURN Server Servisini Pause Et:**

1. Railway Dashboard → **`turn-server`** servisi
2. **Settings** → **Service Actions** → **Pause Service**
3. **Synapse'i redeploy et**

---

## 📊 BEKLENEN SONUÇ

### Railway TURN Server Servisi Pause Edildikten Sonra:

**Synapse response'unda görülmesi gereken:**
```json
{
  "uris": [
    "turn:relay.metered.ca:80",
    "turn:relay.metered.ca:443",
    ...
  ]
}
```

**Railway TURN server olmamalı!**

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Railway TURN server servisi kontrolü eklendi

