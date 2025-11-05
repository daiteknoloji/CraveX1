# 🔍 VIDEO CALL CONSOLE LOG ANALİZİ - KRİTİK BULGULAR

**Tarih:** 1 Kasım 2025  
**Analiz:** Video call console log'ları incelendi

---

## 🎯 TESPİT EDİLEN SORUNLAR

### 1. 🔴 KRİTİK: TURN Server URI'leri UNDEFINED!

**Log:**
```
Available TURN servers: 1
TURN Server 1: {uris: undefined, username: '1762393329:@u2:cravex1-production.up.railway.app', credential: '***'}
```

**Sorun:** TURN server URI'leri `undefined`! Bu yüzden TURN server kullanılamıyor!

**Synapse'den Gelen TURN URI'ler:**
```
Got TURN URIs: turn:turn-server-production-2809.up.railway.app:3478?transport=tcp,turn:relay.metered.ca:80,turn:relay.metered.ca:443,...
```

**Çözüm:** TURN server response'u parse edilirken URI'ler kaybolmuş olabilir.

---

### 2. 🔴 KRİTİK: RELAY TYPE CANDIDATE YOK!

**ICE Candidates:**
```
got local ICE 0 candidate:2344779630 1 udp 2122260223 172.17.96.1 51569 typ host
got local ICE 0 candidate:4188501410 1 udp 2122194687 172.20.10.3 51570 typ host
got local ICE 0 candidate:3705584200 1 udp 1685987071 62.4.57.244 6429 typ srflx
```

**Sorun:** 
- ✅ `host` type candidate var (direkt bağlantı)
- ✅ `srflx` type candidate var (STUN server ile NAT discovery)
- ❌ **`relay` type candidate YOK!** (TURN server kullanılmıyor)

**Sonuç:** TURN server kullanılmadığı için NAT traversal başarısız oluyor!

---

### 3. 🔴 KRİTİK: ICE CONNECTION FAILED!

**Log:**
```
Call 1762307039246UTRdOb9pKpWC5dE7 onIceConnectionStateChanged() running (state=disconnected, conn=connecting)
Call 1762307039246UTRdOb9pKpWC5dE7 onIceConnectionStateChanged() ICE restarting because of ICE disconnected, (state=disconnected, conn=failed)
```

**Sorun:** ICE connection başarısız oluyor ve otomatik restart yapıyor ama yine başarısız!

---

### 4. 🟡 Railway TURN Server Hala Config'de!

**Log:**
```
Got TURN URIs: turn:turn-server-production-2809.up.railway.app:3478?transport=tcp,...
```

**Sorun:** Railway TURN server hala Synapse config'de ve ilk sırada! Bu server çalışmıyor olabilir.

---

## 🛠️ ÇÖZÜM ADIMLARI

### Adım 1: TURN Server URI'lerini Kontrol Et ✅

**Sorun:** Synapse'den gelen TURN URI'leri client'a aktarılmıyor.

**Kontrol:**
```javascript
// Browser console'da çalıştır:
const client = window.mxMatrixClientPeg?.get();
if (client) {
  client.getTurnServers().then(servers => {
    console.log('TURN Servers:', servers);
    servers.forEach((server, i) => {
      console.log(`Server ${i+1}:`, {
        uris: server.uris,
        username: server.username,
        credential: server.credential ? 'var' : 'yok'
      });
    });
  });
}
```

**Beklenen:** `uris` array'i dolu olmalı  
**Gerçek:** `uris: undefined` ❌

---

### Adım 2: Synapse TURN Response'u Kontrol Et ✅

**Browser console'da test et:**

```javascript
const client = window.mxMatrixClientPeg?.get();
if (client) {
  const token = client.getAccessToken();
  
  fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
    headers: { 'Authorization': 'Bearer ' + token }
  })
  .then(r => r.json())
  .then(d => {
    console.log('✅ Synapse TURN Response:', d);
    console.log('URIs:', d.uris);
    console.log('Username:', d.username);
    console.log('Password:', d.password ? 'var' : 'yok');
  });
}
```

**Log'da görünen:**
```
Got TURN URIs: turn:turn-server-production-2809.up.railway.app:3478?transport=tcp,turn:relay.metered.ca:80,...
```

**Sorun:** Bu URI'ler client'a aktarılmıyor veya parse edilirken kayboluyor!

---

### Adım 3: Railway TURN Server'ı Kaldır ✅

**Sorun:** Railway TURN server ilk sırada ama çalışmıyor olabilir.

**Synapse config'i güncelle:**

`synapse-railway-config/homeserver.yaml`:
```yaml
turn_uris:
  # Railway TURN server'ı kaldır - ilk sıradan
  # - "turn:turn-server-production-2809.up.railway.app:3478?transport=tcp"
  
  # Metered.ca'yı öncelikli yap
  - "turn:relay.metered.ca:80"
  - "turn:relay.metered.ca:443"
  - "turn:relay.metered.ca:80?transport=tcp"
  - "turn:relay.metered.ca:443?transport=tcp"
  - "turn:openrelay.metered.ca:80"
  - "turn:openrelay.metered.ca:443"
  - "turn:openrelay.metered.ca:80?transport=tcp"
  - "turn:openrelay.metered.ca:443?transport=tcp"
  
  # Matrix.org fallback
  - "turn:turn.matrix.org:3478?transport=udp"
  - "turn:turn.matrix.org:3478?transport=tcp"
  - "turns:turn.matrix.org:443?transport=tcp"
```

---

### Adım 4: TURN Server Response Format'ını Kontrol Et ✅

**Sorun:** Synapse TURN response format'ı client tarafından doğru parse edilmiyor olabilir.

**Beklenen Format:**
```json
{
  "uris": [
    "turn:relay.metered.ca:80",
    "turn:relay.metered.ca:443",
    ...
  ],
  "username": "...",
  "password": "...",
  "ttl": 86400
}
```

**Log'da görünen format:**
```
Got TURN URIs: turn:turn-server-production-2809.up.railway.app:3478?transport=tcp,turn:relay.metered.ca:80,...
```

**Sorun:** Bu bir string olarak geliyor, array değil! Client bunu parse edemiyor olabilir.

---

## 📊 SORUN ÖZETİ

### Ana Sorun: TURN Server URI'leri Client'a Aktarılmıyor

**Kanıtlar:**
1. ✅ Synapse TURN URI'leri gönderiyor
2. ❌ Client tarafında `uris: undefined`
3. ❌ `relay` type candidate hiç oluşmuyor
4. ❌ ICE connection başarısız oluyor

**Sonuç:** Video call TURN server olmadan çalışmaya çalışıyor ama NAT traversal başarısız!

---

## 🔧 HIZLI ÇÖZÜM

### 1. Railway TURN Server'ı Kaldır

`synapse-railway-config/homeserver.yaml` dosyasını düzenle ve Railway TURN server'ı kaldır.

### 2. Element Web Config'ini Kontrol Et

`www/element-web/config.json` dosyasında TURN server'ların doğru format'ta olduğundan emin ol.

### 3. Browser Console'da Test Et

```javascript
// TURN server'ları kontrol et
const client = window.mxMatrixClientPeg?.get();
client.getTurnServers().then(servers => {
  console.log('TURN Servers:', servers);
  if (servers.length === 0 || servers[0].uris === undefined) {
    console.error('❌ TURN server URI\'leri yok!');
  }
});
```

---

## 🎯 EN MUHTEMEL ÇÖZÜM

**Sorun:** Matrix JS SDK, Synapse'den gelen TURN URI string'ini parse edemiyor.

**Çözüm:** Synapse'in TURN response format'ını kontrol et ve düzelt.

**Alternatif:** Element Web config'inde TURN server'ları hardcode et (geçici çözüm).

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Kritik sorun tespit edildi - TURN server URI'leri undefined

