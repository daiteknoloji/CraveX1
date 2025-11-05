# 🔧 RAILWAY TURN SERVER ÇÖZÜMÜ

**Tarih:** 1 Kasım 2025  
**Sorun:** Railway TURN server çalışmıyor ama Synapse response'unda ilk sırada

---

## 🎯 ÇÖZÜM SEÇENEKLERİ

### Seçenek 1: Railway TURN Server Servisini Pause Et ✅ (ÖNERİLEN)

**Railway Dashboard'da:**

1. `turn-server` servisini seç
2. **Settings** → **Service Actions** → **Pause Service**
3. Veya **Settings** → **Delete Service**

**Sonuç:** Railway TURN server Synapse response'undan çıkacak, Metered.ca öncelikli olacak.

---

### Seçenek 2: Synapse Service Environment Variables'ı Kontrol Et ✅

**Railway Dashboard'da:**

1. **Synapse** servisini seç
2. **Settings** → **Variables** sekmesi
3. Şu variable'ları kontrol et:
   - `TURN_URIS`
   - `TURN_SERVER_URL`
   - `TURN_SERVER`
   - `TURN_URI`
   - `COTURN_URL`
   - Veya `TURN` içeren herhangi bir variable

4. **Eğer varsa:** Railway TURN server URL'ini içeren variable'ı kaldır veya düzenle

---

### Seçenek 3: Railway Private Networking ile TURN Server'ı Kullan ✅

**Railway TURN server çalışıyor mu kontrol et:**

Railway Dashboard → `turn-server` servis → **Logs** sekmesi:
- Coturn başladı mı?
- Port 3478'de dinliyor mu?
- Hata var mı?

**Eğer çalışıyorsa:** Railway TURN server'ı Railway internal network üzerinden kullan:
- `turn:turn-server.railway.internal:3478?transport=tcp`

**Ama:** Bu sadece Railway içinden çalışır, dışarıdan çalışmaz!

---

## 🚀 HIZLI ÇÖZÜM (ÖNERİLEN)

### Adım 1: Railway TURN Server Servisini Pause Et

1. Railway Dashboard → `turn-server` servisi
2. **Settings** → **Service Actions** → **Pause Service**
3. Veya servisi tamamen **Delete** et

### Adım 2: Synapse Service'i Redeploy Et

1. Railway Dashboard → **Synapse** servisi
2. **Settings** → **Service Actions** → **Redeploy**

**Sonuç:** 
- Railway TURN server listeden çıkacak
- Metered.ca server'ları öncelikli olacak
- Video call çalışacak ✅

---

## 🔍 ALTERNATİF: Railway TURN Server'ı Düzelt

**Eğer Railway TURN server'ı kullanmak istiyorsan:**

### Railway TURN Server Loglarını Kontrol Et:

Railway Dashboard → `turn-server` servisi → **Logs**

**Beklenen log'lar:**
```
coturn server listening on port 3478
```

**Sorun varsa:**
- Port 3478 expose edilmiş mi kontrol et
- `turnserver.conf` dosyasını kontrol et
- Railway TURN server servisini restart et

---

## 📊 SONUÇ

### En Kolay Çözüm:
1. ✅ Railway TURN server servisini **pause** veya **delete** et
2. ✅ Synapse service'i **redeploy** et
3. ✅ Video call'u test et

### Beklenen Sonuç:
- Railway TURN server Synapse response'undan çıkacak
- Metered.ca server'ları öncelikli olacak
- `relay` type candidate oluşacak
- Video call çalışacak ✅

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Çözüm adımları belirlendi

