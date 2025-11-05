# ✅ METERED.CA TURN SERVER BİLGİLERİ GÜNCELLENDİ

## 📊 YAPILAN DEĞİŞİKLİKLER

### `config.json` Güncellendi

**Eski URL'ler:**
- `turn:relay.metered.ca:80`
- `turn:relay.metered.ca:443`
- `turn:relay.metered.ca:80?transport=tcp`
- `turn:relay.metered.ca:443?transport=tcp`

**Yeni URL'ler:**
- `stun:stun.relay.metered.ca:80` (STUN server eklendi)
- `turn:global.relay.metered.ca:80`
- `turn:global.relay.metered.ca:80?transport=tcp`
- `turn:global.relay.metered.ca:443`
- `turns:global.relay.metered.ca:443?transport=tcp`

**Credentials:**
- Username: `58e02653cf68e2e327570c31`
- Credential: `LzRLn4fKFlS1jiDc`

---

## 🔑 API KEY BİLGİSİ

Metered.ca API Key: `3f22fb625f23a7e372842581a29d4368e2d5`

**Not:** Bu API Key REST API çağrısı için kullanılabilir. Şu anda statik credentials kullanıyoruz, ama gelecekte dinamik credentials almak için API kullanılabilir.

**REST API Endpoint:**
```
https://cravex.metered.live/api/v1/turn/credentials?apiKey=3f22fb625f23a7e372842581a29d4368e2d5
```

---

## 📝 SONRAKI ADIMLAR

### 1. Netlify Otomatik Deploy
Netlify otomatik deploy yapacak (Git push yapıldı).

### 2. Railway Synapse Redeploy (Gerekirse)
Eğer `homeserver.yaml`'da `turn_uris` güncellenmişse, Railway Synapse'i redeploy etmeniz gerekebilir.

### 3. Test
Netlify deploy tamamlandıktan sonra:
1. Browser console'u aç (F12)
2. Video call başlat
3. Şu logları kontrol et:
   - `[ICE Debug] Available TURN servers:` → Sayı 0'dan fazla olmalı
   - `[ICE Debug] TURN Server 1:` → Metered.ca credentials görünüyor mu?
   - `username: '58e02653cf68e2e327570c31'` → Metered.ca username görünüyor mu?
   - `[ICE Debug] ICE Candidate received:` → Relay candidate'lar görünüyor mu?
   - `isRelay: true` → TURN server kullanılıyor mu?

---

## ⚠️ ÖNEMLİ NOT

Element Web'in `config.json`'daki `voip.turn_servers` bilgilerini kullanması için kod değişikliği gerekiyor. Şu anda Element Web Synapse'den gelen TURN server bilgilerini kullanıyor.

**Çözüm:** Element Web'in `config.json`'daki TURN server bilgilerini kullanması için `MatrixClientPeg.ts`'de kod değişikliği gerekiyor. Bu değişiklik yapılmadığı sürece, Element Web Synapse'den gelen TURN server bilgilerini kullanmaya devam edecek.

---

## ✅ ÖZET

- ✅ Metered.ca TURN server URL'leri güncellendi
- ✅ STUN server eklendi (`stun:stun.relay.metered.ca:80`)
- ✅ `global.relay.metered.ca` URL'leri kullanılıyor
- ✅ Credentials aynı (`58e02653cf68e2e327570c31` / `LzRLn4fKFlS1jiDc`)
- ✅ Git commit ve push yapıldı
- ⚠️ Element Web'in `config.json`'daki TURN server bilgilerini kullanması için kod değişikliği gerekiyor

Netlify deploy tamamlandıktan sonra test edin ve sonuçları paylaşın.

