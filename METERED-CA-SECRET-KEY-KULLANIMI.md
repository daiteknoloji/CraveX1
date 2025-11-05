# 🔑 METERED.CA SECRET KEY KULLANIMI

## 📊 PAYLAŞILAN BİLGİLER

**Metered Domain:** `cravex.metered.live`
**Secret KEY:** `8FkVSWwJteGEgzNgei5AgiufkntuvnIF2Wwk5a0r401L_ci8`
**API Key:** `3f22fb625f23a7e372842581a29d4368e2d5` (önceden paylaşılan)

---

## 🔍 METERED.CA API KULLANIMI

### 1. REST API ile Credentials Alma

Metered.ca'nın REST API'sini kullanarak TURN server credentials'larını almak için:

**Endpoint:**
```
GET https://cravex.metered.live/api/v1/turn/credentials?apiKey=3f22fb625f23a7e372842581a29d4368e2d5
```

**VEYA Secret KEY ile:**
```
GET https://cravex.metered.live/api/v1/turn/credentials?secretKey=8FkVSWwJteGEgzNgei5AgiufkntuvnIF2Wwk5a0r401L_ci8
```

**Response Format:**
```json
[
  {
    "urls": [
      "turn:global.relay.metered.ca:80",
      "turn:global.relay.metered.ca:443",
      "turn:global.relay.metered.ca:80?transport=tcp",
      "turns:global.relay.metered.ca:443?transport=tcp"
    ],
    "username": "...",
    "credential": "..."
  }
]
```

---

## 💡 ÇÖZÜM SEÇENEKLERİ

### Seçenek 1: Statik Credentials Kullan (ÖNERİLEN)

Metered.ca dashboard'undan credentials'ları al ve `config.json`'a ekle. Ama Element Web'in bunları kullanması için kod değişikliği gerekiyor.

### Seçenek 2: REST API ile Dinamik Credentials (KARMAŞIK)

Element Web'in kaynak kodunu değiştirerek Metered.ca'nın REST API'sini kullanmak. Bu karmaşık.

### Seçenek 3: Secret KEY'i Test Et (ÖNERİLEN)

Önce Secret KEY'in doğru çalışıp çalışmadığını test et:

```javascript
// Browser console'da test et:
fetch('https://cravex.metered.live/api/v1/turn/credentials?apiKey=3f22fb625f23a7e372842581a29d4368e2d5')
  .then(r => r.json())
  .then(data => console.log('✅ Credentials:', data))
  .catch(err => console.error('❌ Hata:', err));
```

VEYA Secret KEY ile:

```javascript
fetch('https://cravex.metered.live/api/v1/turn/credentials?secretKey=8FkVSWwJteGEgzNgei5AgiufkntuvnIF2Wwk5a0r401L_ci8')
  .then(r => r.json())
  .then(data => console.log('✅ Credentials:', data))
  .catch(err => console.error('❌ Hata:', err));
```

---

## 🎯 ÖNERİLEN ADIMLAR

1. **Browser console'da API'yi test et:**
   - Secret KEY veya API Key ile credentials al
   - Sonuçları kontrol et

2. **Metered.ca Dashboard'dan credentials'ları kontrol et:**
   - Dashboard'da "Credentials" veya "TURN Servers" sekmesine git
   - Username ve Password'u kopyala

3. **config.json'ı güncelle:**
   - Alınan credentials'ları `config.json`'a ekle

4. **Element Web'in config.json kullanmasını sağla:**
   - `MatrixClientPeg.ts`'de kod değişikliği gerekiyor
   - Bu karmaşık ama en doğru çözüm

---

## 📝 METERED.CA CREDENTIALS NASIL BULUNUR?

### Dashboard'dan:

1. Metered.ca dashboard'una git: https://dashboard.metered.ca/
2. Giriş yap
3. Projeni seç (`cravex.metered.live`)
4. "Credentials" veya "TURN Servers" sekmesine git
5. Username ve Password'u kopyala

### REST API ile:

1. API Key veya Secret KEY ile endpoint'i çağır
2. Response'dan credentials'ları al
3. `config.json`'a ekle

---

## ✅ SONUÇ

**Secret KEY:** `8FkVSWwJteGEgzNgei5AgiufkntuvnIF2Wwk5a0r401L_ci8`
**API Key:** `3f22fb625f23a7e372842581a29d4368e2d5`
**Domain:** `cravex.metered.live`

**Test:** Browser console'da API'yi test et ve credentials'ları al. Sonra `config.json`'a ekle.

