# 🔑 METERED.CA SECRET KEY TEST VE KULLANIM

## 📊 PAYLAŞILAN BİLGİLER

**Metered Domain:** `cravex.metered.live`
**Secret KEY:** `8FkVSWwJteGEgzNgei5AgiufkntuvnIF2Wwk5a0r401L_ci8`
**API Key:** `3f22fb625f23a7e372842581a29d4368e2d5`

---

## 🧪 TEST: SECRET KEY ÇALIŞIYOR MU?

### Browser Console'da Test Et:

**1. API Key ile test:**
```javascript
fetch('https://cravex.metered.live/api/v1/turn/credentials?apiKey=3f22fb625f23a7e372842581a29d4368e2d5')
  .then(r => r.json())
  .then(data => {
    console.log('✅ Credentials (API Key):', data);
    console.log('Username:', data[0]?.username);
    console.log('Credential:', data[0]?.credential);
  })
  .catch(err => console.error('❌ Hata:', err));
```

**2. Secret KEY ile test:**
```javascript
fetch('https://cravex.metered.live/api/v1/turn/credentials?secretKey=8FkVSWwJteGEgzNgei5AgiufkntuvnIF2Wwk5a0r401L_ci8')
  .then(r => r.json())
  .then(data => {
    console.log('✅ Credentials (Secret KEY):', data);
    console.log('Username:', data[0]?.username);
    console.log('Credential:', data[0]?.credential);
  })
  .catch(err => console.error('❌ Hata:', err));
```

---

## 💡 HANGİ KEY KULLANILMALI?

### Secret KEY (Backend için):
- **Kullanım:** Backend (Synapse) için
- **Güvenlik:** Frontend'de kullanılmamalı
- **Endpoint:** `?secretKey=...`

### API Key (Frontend için):
- **Kullanım:** Frontend (Element Web) için
- **Güvenlik:** Frontend'de kullanılabilir
- **Endpoint:** `?apiKey=...`

---

## 🎯 ÖNERİLEN ÇÖZÜM

### Seçenek 1: Statik Credentials (ÖNERİLEN) ⭐

Metered.ca dashboard'undan credentials'ları al ve `config.json`'a ekle:

1. **Browser console'da API'yi test et:**
   ```javascript
   fetch('https://cravex.metered.live/api/v1/turn/credentials?apiKey=3f22fb625f23a7e372842581a29d4368e2d5')
     .then(r => r.json())
     .then(data => console.log('Credentials:', data));
   ```

2. **Response'dan credentials'ları kopyala:**
   - `username`: ...
   - `credential`: ...

3. **`config.json`'ı güncelle:**
   - Alınan credentials'ları `config.json`'daki `voip.turn_servers` bölümüne ekle

4. **Element Web'in `config.json` kullanmasını sağla:**
   - `MatrixClientPeg.ts`'de kod değişikliği gerekiyor

---

### Seçenek 2: REST API ile Dinamik Credentials (KARMAŞIK)

Element Web'in kaynak kodunu değiştirerek Metered.ca'nın REST API'sini kullanmak. Bu karmaşık ve Element Web'in kaynak kodunu değiştirmemiz gerekiyor.

---

## 📝 ADIMLAR

### 1. Browser Console'da Test Et

Browser console'u aç (F12) ve şu komutu çalıştır:

```javascript
fetch('https://cravex.metered.live/api/v1/turn/credentials?apiKey=3f22fb625f23a7e372842581a29d4368e2d5')
  .then(r => r.json())
  .then(data => {
    console.log('✅ Credentials:', data);
    console.log('Username:', data[0]?.username);
    console.log('Credential:', data[0]?.credential);
  })
  .catch(err => console.error('❌ Hata:', err));
```

### 2. Response'u Paylaş

Test sonucunu paylaş:
- Credentials geldi mi?
- Username ne?
- Credential ne?

### 3. config.json Güncelleme

Alınan credentials'ları `config.json`'a ekleyeceğiz.

---

## ✅ SONUÇ

**Secret KEY:** `8FkVSWwJteGEgzNgei5AgiufkntuvnIF2Wwk5a0r401L_ci8` (Backend için)
**API Key:** `3f22fb625f23a7e372842581a29d4368e2d5` (Frontend için)

**Sonraki Adım:** Browser console'da API'yi test et ve credentials'ları al. Sonra paylaş, `config.json`'ı güncelleyeceğim.

