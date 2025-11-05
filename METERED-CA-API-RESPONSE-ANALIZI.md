# 🔍 METERED.CA API RESPONSE ANALİZİ

## 📊 API RESPONSE

**Sonuç:** `(5) [{…}, {…}, {…}, {…}, {…}]`

Bu, Metered.ca'nın 5 farklı TURN server credential'ı döndüğünü gösteriyor.

---

## 🧪 DETAYLI ANALİZ İÇİN

### Browser Console'da şu komutu çalıştır:

```javascript
fetch('https://cravex.metered.live/api/v1/turn/credentials?apiKey=3f22fb625f23a7e372842581a29d4368e2d5')
  .then(r => r.json())
  .then(data => {
    console.log('✅ Toplam TURN Server:', data.length);
    data.forEach((server, index) => {
      console.log(`\n📡 TURN Server ${index + 1}:`);
      console.log('URLs:', server.urls);
      console.log('Username:', server.username);
      console.log('Credential:', server.credential);
    });
    
    // İlk server'ı kullan
    const firstServer = data[0];
    console.log('\n🎯 Kullanılacak Credentials:');
    console.log('Username:', firstServer.username);
    console.log('Credential:', firstServer.credential);
    console.log('URLs:', firstServer.urls);
  })
  .catch(err => console.error('❌ Hata:', err));
```

---

## 💡 NE YAPMALIYIZ?

### 1. İlk TURN Server'ı Kullan

Genellikle ilk server (`data[0]`) en uygun olanıdır. İçeriğini görmek için:

**Console'da:**
```javascript
fetch('https://cravex.metered.live/api/v1/turn/credentials?apiKey=3f22fb625f23a7e372842581a29d4368e2d5')
  .then(r => r.json())
  .then(data => {
    console.log('İlk Server:', JSON.stringify(data[0], null, 2));
  });
```

### 2. Credentials'ları Paylaş

Bana şunları paylaş:
- `data[0].username`
- `data[0].credential`
- `data[0].urls`

### 3. config.json Güncelleme

Alınan credentials'ları `config.json`'a ekleyeceğiz.

---

## 📝 HIZLI KOMUT

Console'da şunu çalıştır ve sonucu paylaş:

```javascript
fetch('https://cravex.metered.live/api/v1/turn/credentials?apiKey=3f22fb625f23a7e372842581a29d4368e2d5')
  .then(r => r.json())
  .then(data => {
    const server = data[0];
    console.log('Username:', server.username);
    console.log('Credential:', server.credential);
    console.log('URLs:', server.urls);
  });
```

---

## ✅ SONUÇ

**Durum:** ✅ API çalışıyor, 5 TURN server credential döndü!

**Sonraki Adım:** İlk server'ın (`data[0]`) credentials'larını paylaş, `config.json`'ı güncelleyeceğim.

