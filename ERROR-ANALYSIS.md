# 🔍 ELEMENT WEB HATA ANALİZİ

## 📊 TESPİT EDİLEN HATALAR

### ✅ **Normal Hatalar (Sorun Değil):**

```
404 - auth_metadata → OIDC kullanmıyorsunuz (normal)
404 - auth_issuer → OIDC kullanmıyorsunuz (normal)
404 - room_keys/version → E2E encryption kapalı (normal)
404 - dehydrated_device → Experimental feature (normal)
403 - register?kind=guest → Guest kaydı kapalı (normal)
```

**Bu hatalar ignore edilebilir.** Cravex'in şifreleme kapalı yapısıyla uyumlu.

---

### 🔴 **CİDDİ HATALAR:**

#### **1. Room ID Format Hatası:**
```
Error: leading sigil is incorrect or missing
at isEncryptionEnabledInRoom
```

**Sebep:** 
- Oda ID'si yanlış formatta
- "!" ile başlaması gereken room ID başlamıyor

**Çözüm:** Database temizlik düzeltecek

---

#### **2. Media Download Hataları:**
```
404 - /media/v3/download/.../WLTIRQoAhlXKRDieBhHTszvY
404 - /media/v3/download/.../iJVNyzIuUxsHhXLkJFDDxoMZ
```

**Sebep:**
- Eski mesajlardaki medya dosyaları kayıp
- Media repository temizlenmemiş

**Çözüm:** Database temizlik düzeltecek

---

#### **3. MatrixRTC Unknown Room:**
```
Got room state event for unknown room !KRglwhfpUIRbcdjGoV...
```

**Sebep:**
- Silinmiş oda ama event'ler kalmış
- Database inconsistency

**Çözüm:** Database temizlik düzeltecek

---

### 🔴 **VIDEO CALL SORUNU:**

**Belirtiler:**
- Ses yok
- Görüntü yok
- İki kullanıcı video call yapamıyor

**Olası Sebepler:**

1. **TURN/STUN Server Yok**
   - Element Web WebRTC için TURN server kullanır
   - config.json'da eksik olabilir

2. **Browser Permissions**
   - Mikrofon/kamera izni verilmemiş
   - Browser settings kontrol edin

3. **Jitsi Integration**
   - Jitsi widget doğru yapılandırılmamış

---

## 🔧 ÇÖZÜM ADIMLARI

### **1️⃣ DATABASE TEMİZLİK (ÖNCELİKLİ)**

```sql
-- Bu room ID ve media hatalarını düzeltecek
-- RAILWAY-DATABASE-CLEANUP.sql çalıştırın
```

**Sonuç:**
- ✅ Yanlış room ID'ler silinir
- ✅ Orphan media referansları temizlenir
- ✅ Sadece admin kalır

---

### **2️⃣ VIDEO CALL FIX**

config.json kontrol edin:

```json
{
  "jitsi": {
    "preferred_domain": "meet.jit.si"
  },
  "element_call": {
    "url": "https://call.element.io",
    "participant_limit": 8,
    "brand": "CraveX Call"
  }
}
```

**Eğer yoksa ekleyin!**

---

### **3️⃣ TURN SERVER EKLE (Video call için)**

config.json'a:

```json
{
  "default_server_config": {
    "m.homeserver": {
      "base_url": "https://cravex1-production.up.railway.app"
    }
  },
  "voip": {
    "turn_servers": [
      {
        "urls": ["turn:turn.matrix.org:3478?transport=udp", "turn:turn.matrix.org:3478?transport=tcp"],
        "username": "webrtc",
        "credential": "secret"
      }
    ]
  }
}
```

---

## ⚡ HIZLI ÇÖZÜM ÖNCELİĞİ

### **1. Database Temizlik (Şimdi)**
- Railway → Postgres → Data → SQL çalıştır
- Room ID hatalarını düzeltir
- Media hatalarını düzeltir

### **2. Config.json Kontrol (Sonra)**
- Jitsi ayarları var mı?
- TURN server var mı?

### **3. Video Call Test (En Son)**
- Browser permissions kontrol
- İki farklı tarayıcıda deneyin

---

## 🎯 ŞİMDİ NE YAPALIM?

**ÖNCELİK 1:** Database temizlik
**ÖNCELİK 2:** Video call config düzeltme

Hangisini önce yapalım?

