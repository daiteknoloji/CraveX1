# 🚀 RAILWAY TURN SERVER KURULUMU - DEĞİŞİKLİKLER REHBERİ

## 📋 DEĞİŞİKLİK YAPILACAK YERLER

### 1. **RAILWAY DASHBOARD** ⭐ YENİ SERVİS

#### Adımlar:
1. Railway Dashboard → Projeni seç
2. **"New"** → **"Service"** tıkla
3. **"Deploy from Docker Hub"** seç
4. **Image:** `coturn/coturn:latest`
5. **Name:** `turn-server` (veya istediğin isim)

#### Environment Variables:
```
TURN_USERNAME=your_username
TURN_PASSWORD=your_password
TURN_REALM=cravex1-production.up.railway.app
TURN_LISTENING_PORT=3478
TURN_EXTERNAL_IP=$(railway run echo $RAILWAY_PUBLIC_DOMAIN)
```

#### Ports:
- **Port 3478** → **Public** (UDP ve TCP)
- Railway otomatik olarak public domain verecek: `turn-server-production-XXXX.up.railway.app`

#### ÖNEMLİ NOT:
Railway public domain'i otomatik verir, ama **statik olmayabilir**. Her deploy'da değişebilir. Bu yüzden **Railway Static Domain** kullanman önerilir (ücretli plan gerekebilir).

---

### 2. **config.json** ⭐ KOD DEĞİŞİKLİĞİ

**Dosya:** `www/element-web/config.json`

#### Değişiklik:
```json
{
  "voip": {
    "turn_servers": [
      {
        "urls": [
          "turn:turn-server-production-XXXX.up.railway.app:3478?transport=udp",
          "turn:turn-server-production-XXXX.up.railway.app:3478?transport=tcp"
        ],
        "username": "your_username",
        "credential": "your_password"
      },
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
}
```

**ÖNEMLİ:**
- Railway TURN server'ını **en üste** ekle (öncelikli olması için)
- Metered.ca ve Matrix.org'u **fallback** olarak tut (yedek)

**Neden Fallback Tutmalıyız?**
- Railway TURN server'ı geçici olarak down olabilir
- Network sorunları olabilir
- Yedek TURN server'lar **güvenlik** için önemli

---

### 3. **homeserver.yaml** ⭐ OPSİYONEL (ÖNERİLİR)

**Dosya:** `synapse-railway-config/homeserver.yaml`

#### Değişiklik:
```yaml
## TURN/STUN Server for Video Calls ##
turn_uris:
  # Railway TURN Server (Öncelikli)
  - "turn:turn-server-production-XXXX.up.railway.app:3478?transport=udp"
  - "turn:turn-server-production-XXXX.up.railway.app:3478?transport=tcp"
  
  # Fallback TURN Servers
  - "turn:relay.metered.ca:80"
  - "turn:relay.metered.ca:443"
  - "turn:relay.metered.ca:80?transport=tcp"
  - "turn:relay.metered.ca:443?transport=tcp"
  - "turn:openrelay.metered.ca:80"
  - "turn:openrelay.metered.ca:443"
  - "turn:openrelay.metered.ca:80?transport=tcp"
  - "turn:openrelay.metered.ca:443?transport=tcp"
  - "turn:turn.matrix.org:3478?transport=udp"
  - "turn:turn.matrix.org:3478?transport=tcp"
  - "turns:turn.matrix.org:443?transport=tcp"

turn_shared_secret: "n0t4ctu4lly4n4ctua1s3cr3t4t4ll"
turn_user_lifetime: 86400000
turn_allow_guests: true
```

**ÖNEMLİ:**
- Synapse'in TURN server bilgilerini client'lara vermesi için `turn_uris` güncellenmeli
- Railway TURN server'ını **en üste** ekle (öncelikli)
- Fallback TURN server'ları tut (yedek)

**Neden Önemli?**
- Synapse, client'lara `/voip/turnServer` endpoint'inden TURN server bilgilerini veriyor
- Eğer `homeserver.yaml`'da Railway TURN server yoksa, Synapse client'lara sadece eski TURN server'ları verecek
- `config.json`'daki TURN server'lar **fallback** olarak çalışır, ama Synapse'in verdiği TURN server'lar **öncelikli**

---

### 4. **NETLIFY** ✅ OTOMATİK

**Netlify'de değişiklik GEREKMEZ!**

**Neden?**
- `config.json` dosyası Git'te
- Netlify Git'ten otomatik deploy yapıyor
- `config.json` değiştiğinde Netlify otomatik build edecek
- Yeni deploy otomatik olarak yayınlanacak

**Yapılacaklar:**
- Hiçbir şey! Netlify otomatik deploy yapacak.

---

## 📝 ADIM ADIM KURULUM

### Adım 1: Railway'de TURN Server Kur

1. Railway Dashboard → Projeni seç
2. **"New"** → **"Service"**
3. **"Deploy from Docker Hub"**
4. **Image:** `coturn/coturn:latest`
5. **Name:** `turn-server`

#### Environment Variables:
```
TURN_USERNAME=turn_user
TURN_PASSWORD=your_secure_password_here
TURN_REALM=cravex1-production.up.railway.app
TURN_LISTENING_PORT=3478
```

#### Ports:
- **Port 3478** → **Public** (UDP ve TCP)

#### Railway Domain:
Railway otomatik olarak public domain verecek:
```
turn-server-production-XXXX.up.railway.app
```

**NOT:** Railway domain'i her deploy'da değişebilir. Statik domain için Railway'in ücretli planına geçmen gerekebilir.

---

### Adım 2: config.json Güncelle

**Dosya:** `www/element-web/config.json`

```json
{
  "voip": {
    "turn_servers": [
      {
        "urls": [
          "turn:turn-server-production-XXXX.up.railway.app:3478?transport=udp",
          "turn:turn-server-production-XXXX.up.railway.app:3478?transport=tcp"
        ],
        "username": "turn_user",
        "credential": "your_secure_password_here"
      },
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
          "turn:openrelay.metered.ca:80",
          "turn:openrelay.metered.ca:443",
          "turn:openrelay.metered.ca:80?transport=tcp",
          "turn:openrelay.metered.ca:443?transport=tcp"
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
}
```

**Değişiklikler:**
- Railway TURN server'ını **en üste** ekle
- Fallback TURN server'ları tut

---

### Adım 3: homeserver.yaml Güncelle

**Dosya:** `synapse-railway-config/homeserver.yaml`

```yaml
## TURN/STUN Server for Video Calls ##
turn_uris:
  # Railway TURN Server (Öncelikli)
  - "turn:turn-server-production-XXXX.up.railway.app:3478?transport=udp"
  - "turn:turn-server-production-XXXX.up.railway.app:3478?transport=tcp"
  
  # Fallback TURN Servers
  - "turn:relay.metered.ca:80"
  - "turn:relay.metered.ca:443"
  - "turn:relay.metered.ca:80?transport=tcp"
  - "turn:relay.metered.ca:443?transport=tcp"
  - "turn:openrelay.metered.ca:80"
  - "turn:openrelay.metered.ca:443"
  - "turn:openrelay.metered.ca:80?transport=tcp"
  - "turn:openrelay.metered.ca:443?transport=tcp"
  - "turn:turn.matrix.org:3478?transport=udp"
  - "turn:turn.matrix.org:3478?transport=tcp"
  - "turns:turn.matrix.org:443?transport=tcp"

turn_shared_secret: "n0t4ctu4lly4n4ctua1s3cr3t4t4ll"
turn_user_lifetime: 86400000
turn_allow_guests: true
```

**Değişiklikler:**
- Railway TURN server'ını **en üste** ekle
- Fallback TURN server'ları tut

---

### Adım 4: Git Commit ve Push

```bash
git add www/element-web/config.json
git add synapse-railway-config/homeserver.yaml
git commit -m "Railway TURN server eklendi"
git push cravex1 main
```

---

### Adım 5: Railway Synapse Yeniden Deploy

Railway Dashboard → Synapse servisi → **"Redeploy"**

**Neden?**
- `homeserver.yaml` değişti
- Synapse'in yeni TURN server bilgilerini alması için yeniden deploy gerekli

---

### Adım 6: Netlify Otomatik Deploy

Netlify otomatik olarak deploy yapacak:
1. Git push yapıldı
2. Netlify Git hook'u tetiklendi
3. Netlify otomatik build başladı
4. Yeni `config.json` build edildi
5. Deploy tamamlandı

**Yapılacaklar:**
- Hiçbir şey! Netlify otomatik deploy yapacak.

---

## ✅ ÖZET: DEĞİŞİKLİK YAPILACAK YERLER

| Yer | Değişiklik | Zorunlu mu? |
|-----|-----------|-------------|
| **Railway Dashboard** | Yeni servis ekle (Coturn) | ✅ Evet |
| **config.json** | Railway TURN server ekle | ✅ Evet |
| **homeserver.yaml** | Railway TURN server ekle | ⚠️ Önerilir |
| **Netlify** | Hiçbir şey | ❌ Gerekmez (otomatik) |
| **Git** | Commit ve push | ✅ Evet |

---

## 🎯 ÖNEMLİ NOTLAR

### 1. Railway Domain Değişebilir
Railway'in otomatik domain'i her deploy'da değişebilir:
```
turn-server-production-XXXX.up.railway.app
```

**Çözüm:**
- Railway'in **Static Domain** özelliğini kullan (ücretli plan gerekebilir)
- Veya domain'i manuel olarak güncelle

### 2. Fallback TURN Server'ları Tut
Railway TURN server'ı geçici olarak down olabilir:
- Metered.ca ve Matrix.org'u **fallback** olarak tut
- Video call'lar kesintisiz devam eder

### 3. Port Açma
Railway'de port 3478'i **Public** yap:
- **UDP** ve **TCP** her ikisini de aç
- WebRTC için gerekli

### 4. Authentication
Güçlü password kullan:
- Railway TURN server'ına erişim için
- `TURN_PASSWORD` environment variable'ında sakla

---

## 🔧 ALTERNATİF: METERED.CA ACCOUNT (DAHA KOLAY)

Eğer Railway'de TURN server kurmak istemiyorsan:

1. **Metered.ca account oluştur** (ücretsiz)
2. Sadece `config.json` güncelle
3. `homeserver.yaml` güncelleme gerekmez (opsiyonel)

**Değişiklikler:**
- ✅ `config.json` güncelle
- ❌ Railway'de yeni servis gerekmez
- ❌ `homeserver.yaml` güncelleme gerekmez (opsiyonel)

**Avantajlar:**
- Daha kolay kurulum
- Railway'de ekstra servis maliyeti yok

**Dezavantajlar:**
- Üçüncü taraf servis (güvenilirlik düşük)
- Ücretsiz plan limitli

---

## 📋 KARAR VER

### Seçenek 1: Railway'de TURN Server Kur
- ✅ Tam kontrol
- ✅ Güvenilirlik yüksek
- ⚠️ Railway'de ekstra servis maliyeti
- ⚠️ Kurulum biraz karmaşık

### Seçenek 2: Metered.ca Account Oluştur
- ✅ Kolay kurulum
- ✅ Ücretsiz
- ⚠️ Üçüncü taraf servis (güvenilirlik düşük)
- ⚠️ Ücretsiz plan limitli

Hangi seçeneği tercih edersin?

