# 🔍 SORUN ANALİZİ: ELEMENT WEB CONFIG.JSON TURN SERVERS KULLANMIYOR

## 📊 MEVCUT DURUM

### Loglar Gösteriyor:
```
[ICE Debug] Available TURN servers: 0
```

**Sorun:** Element Web `config.json`'daki `voip.turn_servers` bilgilerini okumuyor ve matrix-js-sdk'ya geçirmiyor!

---

## 🎯 SORUNUN KAYNAĞI

### Element Web'in TURN Server Mekanizması:

1. **Matrix-js-sdk:**
   - TURN server bilgilerini Synapse'den alıyor (`getTurnServers()`)
   - `config.json`'daki TURN server bilgilerini otomatik olarak kullanmıyor

2. **Element Web:**
   - `IConfigOptions.ts`'de `voip.turn_servers` tanımlı değildi
   - `MatrixClientPeg.ts`'de `config.json`'daki TURN server bilgilerini matrix-js-sdk'ya geçirmiyor

3. **Synapse:**
   - `turn_uris` listesinden TURN server URL'lerini veriyor
   - `turn_shared_secret` ile kendi username/password'unu oluşturuyor
   - Metered.ca'nın kendi credentials'larını kullanmıyor

---

## 💡 ÇÖZÜM

### Seçenek 1: Synapse'i Kullan (ÖNERİLEN) ⭐

Synapse'in TURN server bilgilerini geri almak ve Metered.ca TURN server URL'lerini eklemek.

**Not:** Synapse `turn_shared_secret` ile kendi username/password'unu oluşturuyor. Bu yüzden Metered.ca credentials'ları `config.json`'da kalacak ve Element Web'in `config.json`'daki TURN server bilgilerini kullanması için kod değişikliği gerekiyor.

**Sorun:** Element Web'in `config.json`'daki TURN server bilgilerini kullanması için kod değişikliği gerekiyor ama bu karmaşık.

---

### Seçenek 2: Element Web Kodunu Güncelle (KARMAŞIK)

`IConfigOptions.ts`'ye `voip.turn_servers` eklemek ve `MatrixClientPeg.ts`'de bu bilgileri matrix-js-sdk'ya geçirmek.

**Sorun:** Matrix-js-sdk'nın `setTurnServers()` fonksiyonu yok. TURN server bilgileri Synapse'den geliyor.

---

## 🎯 ÖNERİLEN ÇÖZÜM

### Synapse'in TURN Server Bilgilerini Geri Al

`homeserver.yaml`'da `turn_uris` listesini geri almak ve Metered.ca TURN server URL'lerini eklemek.

**Değişiklik:**
```yaml
## TURN/STUN Server for Video Calls ##
turn_uris:
  # Metered.ca TURN Server (Öncelikli)
  - "turn:relay.metered.ca:80"
  - "turn:relay.metered.ca:443"
  - "turn:relay.metered.ca:80?transport=tcp"
  - "turn:relay.metered.ca:443?transport=tcp"
  # Matrix.org TURN Server (Fallback)
  - "turn:turn.matrix.org:3478?transport=udp"
  - "turn:turn.matrix.org:3478?transport=tcp"
  - "turns:turn.matrix.org:443?transport=tcp"

turn_shared_secret: "n0t4ctu4lly4n4ctua1s3cr3t4t4ll"
turn_user_lifetime: 86400000
turn_allow_guests: true
```

**Sorun:** Synapse `turn_shared_secret` ile kendi username/password'unu oluşturuyor. Metered.ca credentials'ları kullanılmıyor.

---

## 📝 UYGULAMA

### Adım 1: homeserver.yaml Güncelle

`turn_uris` listesini geri al ve Metered.ca TURN server URL'lerini ekle.

### Adım 2: Element Web Kodunu Güncelle (GEREKLİ)

`IConfigOptions.ts`'ye `voip.turn_servers` eklemek ve `MatrixClientPeg.ts`'de bu bilgileri matrix-js-sdk'ya geçirmek gerekiyor. Ama matrix-js-sdk'nın `setTurnServers()` fonksiyonu yok.

### Adım 3: Alternatif Çözüm

Element Web'in `config.json`'daki TURN server bilgilerini kullanması için kod değişikliği gerekiyor ama bu karmaşık. En basit çözüm: Synapse'in TURN server bilgilerini kullanmak ve Metered.ca credentials'larını Synapse'e eklemek için özel bir çözüm bulmak.

---

## ✅ SONUÇ

**Sorun:** Element Web `config.json`'daki `voip.turn_servers` bilgilerini okumuyor ve matrix-js-sdk'ya geçirmiyor.

**Çözüm:** `IConfigOptions.ts`'ye `voip.turn_servers` eklemek ve `MatrixClientPeg.ts`'de bu bilgileri matrix-js-sdk'ya geçirmek gerekiyor. Ama matrix-js-sdk'nın `setTurnServers()` fonksiyonu yok, bu yüzden bu karmaşık.

**Geçici Çözüm:** Synapse'in TURN server bilgilerini geri almak ve Metered.ca TURN server URL'lerini eklemek. Ama Synapse `turn_shared_secret` ile kendi username/password'unu oluşturuyor, Metered.ca credentials'ları kullanılmıyor.

**En İyi Çözüm:** Element Web'in `config.json`'daki TURN server bilgilerini kullanması için kod değişikliği gerekiyor ama bu karmaşık ve Element Web'in kaynak kodunu değiştirmemiz gerekiyor.

