# 🔍 SORUN ANALİZİ: METERED.CA CREDENTIALS KULLANILMIYOR

## 📊 MEVCUT DURUM

### Loglar Gösteriyor:
```
username: '1762440773:@user7:cravex1-production.up.railway.app'
credential: 'yWc0Rr8++WtspbJcAf9n7AtB6bc='
```

**Sorun:** Bu Synapse'in `turn_shared_secret` ile oluşturduğu credentials. Metered.ca'nın kendi credentials'ları (`58e02653cf68e2e327570c31` / `LzRLn4fKFlS1jiDc`) kullanılmıyor!

---

## 🎯 SORUNUN KAYNAĞI

### Synapse'in TURN Server Mekanizması:

1. **Synapse `/voip/turnServer` endpoint'i:**
   - `turn_shared_secret` kullanarak kendi username/password'unu oluşturuyor
   - Metered.ca'nın credentials'larını kullanmıyor
   - Format: `{timestamp}:{user_id}` ve `turn_shared_secret` ile sign ediliyor

2. **Element Web:**
   - Synapse'den gelen TURN server bilgilerini **öncelikli** olarak kullanıyor
   - `config.json`'daki TURN server bilgileri **fallback** olarak kullanılıyor
   - Ama Synapse'in verdiği bilgiler öncelikli olduğu için Metered.ca credentials'ları kullanılmıyor

---

## 💡 ÇÖZÜM SEÇENEKLERİ

### Seçenek 1: Synapse'i Devre Dışı Bırak (ÖNERİLEN) ⭐

Synapse'in TURN server bilgilerini kullanmak yerine, sadece `config.json`'daki TURN server bilgilerini kullan.

**Sorun:** Element Web'in Synapse'den TURN server bilgilerini ignore etme ayarı yok gibi görünüyor. Ama Synapse'in TURN server bilgilerini boş döndürmesi için `turn_uris` listesini boşaltabiliriz.

**Adımlar:**
1. `homeserver.yaml`'da `turn_uris` listesini boşalt veya kaldır
2. Synapse'in `/voip/turnServer` endpoint'i boş dönecek
3. Element Web `config.json`'daki TURN server bilgilerini kullanacak

**Dezavantaj:** Synapse'in TURN server bilgilerini kullanmayacağız, ama bu sorun değil çünkü Metered.ca credentials'larımız var.

---

### Seçenek 2: Synapse'in TURN Server Bilgilerini Kullan (KARMAŞIK)

Synapse'in Metered.ca TURN server'ını kullanması için `turn_shared_secret` ile Metered.ca credentials'larını birleştirmemiz gerekiyor. Ama bu mümkün değil çünkü Synapse TURN server bilgilerini `turn_shared_secret` ile sign ediyor.

**Alternatif:** Synapse'in TURN server bilgilerini kullanmak yerine, Metered.ca'nın credentials'larını `turn_shared_secret` ile birleştirmek gerekiyor. Ama bu Synapse'in mevcut mekanizması ile uyumlu değil.

---

### Seçenek 3: Metered.ca'yı Synapse Üzerinden Kullan (EN İYİ ÇÖZÜM)

Synapse'in Metered.ca TURN server'ını kullanması için Metered.ca'nın credentials'larını Synapse'in `turn_shared_secret` mekanizması ile birleştirmemiz gerekiyor. Ama bu mümkün değil çünkü Synapse TURN server bilgilerini `turn_shared_secret` ile sign ediyor.

**Çözüm:** Synapse'in TURN server bilgilerini kullanmak yerine, `config.json`'daki TURN server bilgilerini öncelikli kullanmak. Bunun için Synapse'in TURN server bilgilerini boş döndürmesi gerekiyor.

---

## 🎯 ÖNERİLEN ÇÖZÜM

### Synapse'in TURN Server Bilgilerini Devre Dışı Bırak

`homeserver.yaml`'da `turn_uris` listesini boşalt veya kaldır. Böylece Synapse'in `/voip/turnServer` endpoint'i boş dönecek ve Element Web `config.json`'daki Metered.ca credentials'larını kullanacak.

**Değişiklik:**
```yaml
## TURN/STUN Server for Video Calls ##
# Synapse'in TURN server bilgilerini devre dışı bırak
# Element Web config.json'daki Metered.ca credentials'larını kullanacak
turn_uris: []
# veya turn_uris satırını tamamen kaldır

turn_shared_secret: "n0t4ctu4lly4n4ctua1s3cr3t4t4ll"
turn_user_lifetime: 86400000
turn_allow_guests: true
```

**Avantajlar:**
- ✅ Metered.ca credentials'ları kullanılacak
- ✅ Sorun çözülecek
- ✅ Basit çözüm

**Dezavantajlar:**
- ⚠️ Synapse'in TURN server bilgilerini kullanmayacağız (ama sorun değil)

---

## 📝 UYGULAMA

### Adım 1: homeserver.yaml Güncelle

`turn_uris` listesini boşalt:

```yaml
## TURN/STUN Server for Video Calls ##
# Synapse'in TURN server bilgilerini devre dışı bırak
# Element Web config.json'daki Metered.ca credentials'larını kullanacak
turn_uris: []

turn_shared_secret: "n0t4ctu4lly4n4ctua1s3cr3t4t4ll"
turn_user_lifetime: 86400000
turn_allow_guests: true
```

### Adım 2: Git Commit ve Push

```bash
git add synapse-railway-config/homeserver.yaml
git commit -m "Synapse TURN server bilgilerini devre dışı bırak - config.json Metered.ca credentials kullanılacak"
git push cravex1 main
```

### Adım 3: Railway Synapse Redeploy

Railway Dashboard → Synapse servisi → **"Redeploy"**

### Adım 4: Test

Netlify deploy ve Railway Synapse redeploy tamamlandıktan sonra:
1. Video call test et
2. Browser console'da şu logları kontrol et:
   - `[ICE Debug] TURN Server 1:` → Metered.ca credentials görünüyor mu?
   - `username: '58e02653cf68e2e327570c31'` → Metered.ca username görünüyor mu?

---

## ✅ BEKLENEN SONUÇ

Synapse'in TURN server bilgilerini devre dışı bıraktıktan sonra:
1. Synapse'in `/voip/turnServer` endpoint'i boş dönecek
2. Element Web `config.json`'daki Metered.ca credentials'larını kullanacak
3. Video call'lar Metered.ca TURN server'ı ile çalışacak

