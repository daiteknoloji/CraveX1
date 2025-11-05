# 📞 VIDEO CALL SERVİS ANALİZİ

**Tarih:** 1 Kasım 2025  
**Soru:** Video call hangi servisler üzerinden yapılmaya çalışılıyor?

---

## 🎯 ŞU ANKİ DURUM

### Video Call Servisleri (Öncelik Sırasına Göre)

#### 1️⃣ **Metered.ca TURN Server** (1. Öncelik)
**Servis:** `relay.metered.ca`
- **Port:** 80 (HTTP), 443 (HTTPS)
- **Transport:** TCP ve UDP
- **Username:** `openrelayproject`
- **Password:** `openrelayproject`
- **Durum:** ✅ Aktif (config'de)
- **Tip:** Public/Free TURN server

**Kullanım Yerleri:**
- Element Web (`config.json`) - 1. öncelik
- Synapse (`homeserver.yaml`) - 1. öncelik

---

#### 2️⃣ **Metered.ca TURN Server (Alternatif)** (2. Öncelik)
**Servis:** `openrelay.metered.ca`
- **Port:** 80 (HTTP), 443 (HTTPS)
- **Transport:** TCP ve UDP
- **Username:** `openrelayproject`
- **Password:** `openrelayproject`
- **Durum:** ✅ Aktif (config'de)
- **Tip:** Public/Free TURN server

**Kullanım Yerleri:**
- Element Web (`config.json`) - 2. öncelik
- Synapse (`homeserver.yaml`) - 2. öncelik

---

#### 3️⃣ **Matrix.org TURN Server** (3. Öncelik / Fallback)
**Servis:** `turn.matrix.org`
- **Port:** 3478 (UDP/TCP), 443 (TLS)
- **Transport:** UDP, TCP, TLS
- **Username:** `webrtc`
- **Password:** `secret`
- **Durum:** ✅ Aktif (config'de)
- **Tip:** Matrix.org'un resmi TURN server'ı

**Kullanım Yerleri:**
- Element Web (`config.json`) - 3. öncelik
- Synapse (`homeserver.yaml`) - 3. öncelik

---

#### 4️⃣ **Google STUN Server** (Fallback)
**Servis:** `stun.l.google.com`
- **Port:** 19302
- **Transport:** UDP
- **Durum:** ✅ Aktif (config'de)
- **Tip:** STUN server (NAT discovery için)

**Kullanım Yerleri:**
- Element Web (`config.json`) - fallback STUN server

---

## 📊 KULLANIM DETAYLARI

### Element Web Config (`config.json`)

```json
"voip": {
  "turn_servers": [
    {
      // 1. ÖNCELİK: Metered.ca (relay.metered.ca)
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
      // 2. ÖNCELİK: Metered.ca (openrelay.metered.ca)
      "urls": [
        "turn:openrelay.metered.ca:80",
        "turn:openrelay.metered.ca:443",
        "turn:openrelay.metered.ca:80?transport=tcp",
        "turn:openrelay.metered.ca:443?transport=tcp"
      ],
      "username": "openrelayproject",
      "credential": "openrelayproject"
    },
    {
      // 3. ÖNCELİK: Matrix.org TURN
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

### Synapse Config (`homeserver.yaml`)

```yaml
turn_uris:
  # 1. ÖNCELİK: Metered.ca (relay.metered.ca)
  - "turn:relay.metered.ca:80"
  - "turn:relay.metered.ca:443"
  - "turn:relay.metered.ca:80?transport=tcp"
  - "turn:relay.metered.ca:443?transport=tcp"
  
  # 2. ÖNCELİK: Metered.ca (openrelay.metered.ca)
  - "turn:openrelay.metered.ca:80"
  - "turn:openrelay.metered.ca:443"
  - "turn:openrelay.metered.ca:80?transport=tcp"
  - "turn:openrelay.metered.ca:443?transport=tcp"
  
  # 3. ÖNCELİK: Matrix.org TURN
  - "turn:turn.matrix.org:3478?transport=udp"
  - "turn:turn.matrix.org:3478?transport=tcp"
  - "turns:turn.matrix.org:443?transport=tcp"

turn_shared_secret: "n0t4ctu4lly4n4ctua1s3cr3t4t4ll"
turn_user_lifetime: 86400000
turn_allow_guests: true
```

---

## 🔍 NASIL ÇALIŞIYOR?

### Video Call Başlatma Süreci:

1. **Browser (Element Web):**
   - Video call başlatıldığında WebRTC kullanır
   - Önce STUN server (`stun.l.google.com`) ile NAT discovery yapar
   - Direct connection kurulamazsa TURN server'lara bağlanır

2. **TURN Server Deneme Sırası:**
   ```
   1. Metered.ca (relay.metered.ca) - Denenecek ilk
   2. Metered.ca (openrelay.metered.ca) - İlk başarısız olursa
   3. Matrix.org TURN - İkinci de başarısız olursa
   ```

3. **Synapse (Backend):**
   - `/voip/turnServer` endpoint'inden TURN server bilgilerini sağlar
   - Client'a hangi TURN server'ları kullanacağını söyler

---

## ✅ ŞU ANKİ DURUM ÖZETİ

### Kullanılan Servisler:

| Servis | Tip | Öncelik | Durum |
|--------|-----|---------|-------|
| **relay.metered.ca** | TURN | 1️⃣ | ✅ Aktif |
| **openrelay.metered.ca** | TURN | 2️⃣ | ✅ Aktif |
| **turn.matrix.org** | TURN | 3️⃣ | ✅ Aktif |
| **stun.l.google.com** | STUN | Fallback | ✅ Aktif |

### Kullanılmayan Servisler:

| Servis | Neden |
|--------|-------|
| Railway TURN Server | ❌ Kaldırıldı (port expose sorunu) |

---

## 🧪 GERÇEKTE HANGİ SERVİS KULLANILIYOR?

**Browser console'da kontrol et:**

```javascript
// Hangi TURN server'ların kullanıldığını gör
const client = window.mxMatrixClientPeg?.get();
if (client) {
  client.getTurnServers().then(servers => {
    console.log('🔍 Kullanılan TURN Server\'lar:');
    servers.forEach((server, i) => {
      console.log(`${i+1}. ${server.uris.join(', ')}`);
    });
  });
}

// Video call sırasında hangi server'ın kullanıldığını görmek için:
// Console'da [ICE Debug] loglarını ara
// "relay" type candidate geliyorsa TURN server kullanılıyor demektir
```

---

## 🎯 SONUÇ

**Video call şu servisler üzerinden yapılmaya çalışılıyor:**

1. ✅ **Metered.ca** (`relay.metered.ca` ve `openrelay.metered.ca`) - **1. ve 2. öncelik**
2. ✅ **Matrix.org** (`turn.matrix.org`) - **3. öncelik / fallback**
3. ✅ **Google STUN** (`stun.l.google.com`) - **NAT discovery için**

**Railway TURN server kullanılmıyor** (kaldırıldı).

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Aktif servisler listelendi

