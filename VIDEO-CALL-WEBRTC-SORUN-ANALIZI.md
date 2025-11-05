# 🔍 VIDEO CALL / WEBRTC SORUN ANALİZİ

**Tarih:** 1 Kasım 2025  
**Sorun:** 2 kişi video call yapamıyor, WebRTC ile ilgili sorun var

---

## 📋 SORUN ÖZETİ

Video call başlatıldığında:
- ❌ Ses gelmiyor
- ❌ Görüntü gelmiyor
- ❌ Call otomatik kapanıyor olabilir

**Muhtemel Neden:** WebRTC ICE (Interactive Connectivity Establishment) bağlantısı kurulamıyor.

---

## 🔎 TESPİT EDİLEN SORUNLAR

### 1. 🔴 TURN SERVER YAPILANDIRMASI TUTARSIZLIĞI

**Sorun:** Element Web ve Synapse config'lerinde TURN server sıralaması farklı.

**Element Web (`config.json`):**
```json
"turn_servers": [
  {
    "urls": ["turn:relay.metered.ca:80", ...],  // 1. Öncelik
    "username": "openrelayproject",
    "credential": "openrelayproject"
  },
  {
    "urls": ["turn:openrelay.metered.ca:80", ...],  // 2. Öncelik
    "username": "openrelayproject",
    "credential": "openrelayproject"
  },
  {
    "urls": ["turn:turn.matrix.org:3478", ...],  // 3. Öncelik
    "username": "webrtc",
    "credential": "secret"
  }
]
```

**Synapse (`homeserver.yaml`):**
```yaml
turn_uris:
  - "turn:relay.metered.ca:80"  # 1. Öncelik
  - "turn:openrelay.metered.ca:80"  # 2. Öncelik
  - "turn:turn.matrix.org:3478"  # 3. Öncelik
```

**Sorun:** Railway TURN server kaldırılmış ama hala config'lerde referanslar olabilir.

**Etki:** Client ve server farklı TURN server'ları deniyor olabilir.

---

### 2. 🟡 METERED.CA AUTHENTICATION SORUNU

**Sorun:** Metered.ca TURN server'ları için authentication bilgileri doğru mu?

**Mevcut Config:**
```json
"username": "openrelayproject",
"credential": "openrelayproject"
```

**Kontrol Gereken:**
- ✅ Bu credentials Metered.ca'nın açık relay projesi için doğru mu?
- ✅ Rate limiting var mı?
- ✅ IP whitelist gerekli mi?

**Potansiyel Sorun:** Bu credentials herkes tarafından kullanılıyor olabilir ve rate limit'e takılıyor olabilirsiniz.

---

### 3. 🟡 ICE CANDIDATE TOPLAMA SORUNU

**Sorun:** Browser ICE candidate'ları toplayamıyor olabilir.

**Nedenler:**
- NAT/Firewall port'ları bloke ediyor
- TURN server'a bağlanılamıyor
- STUN server çalışmıyor
- Browser permissions (camera/microphone) verilmemiş

**Debug Log'larda Görülecek:**
```javascript
[ICE Debug] ICE Gathering State: gathering
[ICE Debug] ICE Candidate received: {...}
```

Eğer `gathering` state'den çıkamıyorsa veya candidate gelmiyorsa sorun burada.

---

### 4. 🔴 SYNAPSE TURN SERVER RESPONSE SORUNU

**Sorun:** Synapse `/voip/turnServer` endpoint'i doğru response dönüyor mu?

**Test Edilmeli:**
```javascript
// Browser console'da çalıştır:
fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
  headers: { 
    'Authorization': 'Bearer ' + window.mxMatrixClient?.getAccessToken() 
  }
})
.then(r => r.json())
.then(d => console.log('TURN Response:', JSON.stringify(d, null, 2)))
.catch(e => console.error('TURN Error:', e));
```

**Beklenen Response:**
```json
{
  "uris": [
    "turn:relay.metered.ca:80?transport=udp",
    "turn:relay.metered.ca:443?transport=tcp",
    ...
  ],
  "username": "...",
  "password": "...",
  "ttl": 86400
}
```

**Sorun Olabilir:**
- ❌ Boş response dönüyor
- ❌ Authentication token geçersiz
- ❌ Synapse TURN config'i yanlış

---

### 5. 🟡 NETWORK/FIREWALL SORUNLARI

**Sorun:** Kullanıcıların network'ü TURN server'lara bağlanamıyor olabilir.

**Nedenler:**
- Corporate firewall UDP/TCP port'ları bloke ediyor
- NAT traversal çalışmıyor
- Port 3478, 80, 443, 49152-65535 bloke

**Test:**
```powershell
# Metered.ca server'larına bağlantı testi
Test-Connection relay.metered.ca -Count 2
Test-Connection openrelay.metered.ca -Count 2
```

---

### 6. 🟡 BROWSER PERMISSIONS

**Sorun:** Browser camera/microphone izni verilmemiş.

**Belirtiler:**
- Browser izin popup'ı çıkmıyor
- Call başlıyor ama media stream yok
- `getUserMedia` hatası

**Kontrol:**
- Browser console'da `getUserMedia` error'ları var mı?
- Browser settings'te camera/microphone izni var mı?

---

### 7. 🔴 ICE CONNECTION STATE FAILED

**Sorun:** ICE connection başarısız oluyor.

**Debug Log'larda Görülecek:**
```javascript
[ICE Debug] ICE Connection State changed: failed
[ICE Debug] ICE Connection failed or disconnected!
```

**Nedenler:**
- TURN server'lara bağlanılamıyor
- STUN server çalışmıyor
- Peer connection kurulamıyor
- NAT traversal başarısız

---

### 8. 🟡 ELEMENT CALL CONFIG SORUNU

**Sorun:** `feature_element_call_video_rooms` kapalı!

**Mevcut Config:**
```json
"features": {
  "feature_video_rooms": false,
  "feature_element_call_video_rooms": false,
  ...
}
```

**Sorun:** Bu özellikler kapalı olduğu için Element Call kullanılamıyor olabilir.

**Ama:** Legacy call handler kullanılıyor, bu yüzden sorun olmayabilir.

---

## 🛠️ ÇÖZÜM ÖNERİLERİ

### Öncelik 1: TURN Server Config Tutarlılığı ✅

**Element Web ve Synapse config'lerini senkronize et:**

1. **Element Web (`config.json`):**
```json
"voip": {
  "turn_servers": [
    {
      "urls": [
        "turn:relay.metered.ca:80",
        "turn:relay.metered.ca:443",
        "turn:relay.metered.ca:80?transport=tcp",
        "turn:relay.metered.ca:443?transport=tcp"
      ],
      "username": "openrelayproject",
      "credential": "openrelayproject"
    },
    {
      "urls": [
        "turn:turn.matrix.org:3478?transport=udp",
        "turn:turn.matrix.org:3478?transport=tcp",
        "turns:turn.matrix.org:443?transport=tcp"
      ],
      "username": "webrtc",
      "credential": "secret"
    }
  ],
  "fallback_stun_server": "stun:stun.l.google.com:19302"
}
```

2. **Synapse (`homeserver.yaml`):**
```yaml
turn_uris:
  - "turn:relay.metered.ca:80"
  - "turn:relay.metered.ca:443"
  - "turn:relay.metered.ca:80?transport=tcp"
  - "turn:relay.metered.ca:443?transport=tcp"
  - "turn:turn.matrix.org:3478?transport=udp"
  - "turn:turn.matrix.org:3478?transport=tcp"
  - "turns:turn.matrix.org:443?transport=tcp"

turn_shared_secret: "n0t4ctu4lly4n4ctua1s3cr3t4t4ll"
turn_user_lifetime: 86400000
turn_allow_guests: true
```

---

### Öncelik 2: Browser Console Debug ✅

**Video call başlatırken console'da şunları kontrol et:**

1. **ICE Debug Logları:**
```javascript
// Console'da ara:
[ICE Debug]
```

2. **TURN Server Response:**
```javascript
// Console'da ara:
TURN Server response
Available TURN servers
```

3. **ICE Connection State:**
```javascript
// Console'da ara:
ICE Connection State changed
```

4. **Hata Mesajları:**
```javascript
// Console'da ara:
Error
Failed
Exception
```

---

### Öncelik 3: Synapse TURN Endpoint Test ✅

**Browser console'da test et:**

```javascript
// Token al
const client = window.mxMatrixClientPeg?.get();
if (!client) {
  console.error('Client bulunamadı!');
} else {
  const token = client.getAccessToken();
  
  // TURN server response al
  fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
    headers: { 
      'Authorization': 'Bearer ' + token 
    }
  })
  .then(r => r.json())
  .then(d => {
    console.log('✅ TURN Response:', JSON.stringify(d, null, 2));
    
    if (!d.uris || d.uris.length === 0) {
      console.error('❌ TURN server URI\'leri boş!');
    } else {
      console.log(`✅ ${d.uris.length} TURN server URI bulundu`);
      d.uris.forEach((uri, i) => {
        console.log(`  ${i+1}. ${uri}`);
      });
    }
  })
  .catch(e => {
    console.error('❌ TURN Server Request Failed:', e);
  });
}
```

---

### Öncelik 4: Metered.ca Test ✅

**Online TURN Test Tool kullan:**

1. https://icetest.info/ adresine git
2. Şu bilgileri gir:
   ```
   TURN Server: turn:relay.metered.ca:80
   Username: openrelayproject
   Password: openrelayproject
   ```
3. Test'i çalıştır
4. Sonuçları kontrol et

**Alternatif:**
- https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/

---

### Öncelik 5: Browser Permissions ✅

**Kontrol et:**

1. Browser console'da:
```javascript
navigator.mediaDevices.getUserMedia({ video: true, audio: true })
  .then(stream => {
    console.log('✅ Camera/Microphone izni var');
    stream.getTracks().forEach(track => track.stop());
  })
  .catch(e => {
    console.error('❌ Camera/Microphone izni yok:', e);
  });
```

2. Browser Settings:
   - Chrome: `chrome://settings/content/camera`
   - Firefox: `about:preferences#privacy`
   - Safari: Preferences > Websites > Camera/Microphone

---

### Öncelik 6: Network/Firewall Test ✅

**PowerShell ile test:**

```powershell
# Metered.ca server'larına bağlantı testi
Test-Connection relay.metered.ca -Count 2
Test-Connection openrelay.metered.ca -Count 2

# Port testi (PowerShell 7+)
Test-NetConnection -ComputerName relay.metered.ca -Port 80
Test-NetConnection -ComputerName relay.metered.ca -Port 443
```

**Sorun:** Eğer bağlantı başarısızsa, firewall veya network sorunu var.

---

## 🔍 DEBUG CHECKLIST

### Call Başlatmadan Önce ✅

- [ ] Browser console açık
- [ ] Network tab açık
- [ ] Browser permissions verilmiş (camera/microphone)
- [ ] Her iki kullanıcı da aynı homeserver'da
- [ ] Her iki kullanıcı da aynı odaya üye

### Call Başlatırken ✅

- [ ] Console'da `[ICE Debug]` logları görünüyor mu?
- [ ] `Available TURN servers: X` mesajı var mı?
- [ ] `ICE Candidate received` mesajları geliyor mu?
- [ ] `ICE Connection State changed` mesajları var mı?
- [ ] Herhangi bir error mesajı var mı?

### Call Başarısız Olursa ✅

- [ ] ICE connection state ne? (`failed`, `disconnected`, `closed`?)
- [ ] TURN server response boş mu?
- [ ] Browser console'da hata var mı?
- [ ] Network tab'da failed request var mı?

---

## 🎯 EN MUHTEMEL SORUNLAR (Öncelik Sırasına Göre)

### 1. 🔴 TURN Server Authentication Sorunu
**Olasılık:** %40  
**Neden:** Metered.ca credentials yanlış veya rate limit'e takılmış  
**Çözüm:** Matrix.org TURN server'ını öncelikli yap veya Metered.ca credentials doğrula

### 2. 🔴 Synapse TURN Endpoint Yanıt Vermiyor
**Olasılık:** %30  
**Neden:** Synapse config yanlış veya endpoint çalışmıyor  
**Çözüm:** `/voip/turnServer` endpoint'ini test et, config'i kontrol et

### 3. 🟡 ICE Candidate Toplama Başarısız
**Olasılık:** %20  
**Neden:** Firewall/NAT sorunları, TURN server'lara bağlanılamıyor  
**Çözüm:** Network testleri yap, firewall ayarlarını kontrol et

### 4. 🟡 Browser Permissions
**Olasılık:** %10  
**Neden:** Camera/microphone izni verilmemiş  
**Çözüm:** Browser permissions kontrol et, test et

---

## 📊 SONUÇ VE ÖNERİLER

### Hemen Yapılacaklar:

1. ✅ **Browser console'da debug log'ları kontrol et**
   - Video call başlat
   - `[ICE Debug]` loglarını gözlemle
   - Hata mesajlarını not et

2. ✅ **Synapse TURN endpoint'ini test et**
   - Browser console'da test script'i çalıştır
   - Response'u kontrol et

3. ✅ **Metered.ca credentials doğrula**
   - Online TURN test tool kullan
   - Alternatif TURN server (Matrix.org) dene

### Uzun Vadeli:

1. ✅ **Twilio TURN Server kullan** (ücretli ama güvenilir)
2. ✅ **Kendi TURN server'ını kur** (AWS/Azure/Google Cloud)
3. ✅ **TURN server monitoring ekle** (log analysis)

---

## 🔗 FAYDALI KAYNAKLAR

- **WebRTC Debug:** https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/
- **TURN Test:** https://icetest.info/
- **Metered.ca Docs:** https://www.metered.ca/tools/help/stun-turn
- **Matrix TURN:** https://github.com/matrix-org/synapse/blob/develop/docs/turn-howto.md

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Analiz tamamlandı, debug adımları belirlendi

