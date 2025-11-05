# 🔧 TURN SERVER KONTROL KOMUTU (GÜNCELLEMİŞ)

**Sorun:** `const client` zaten tanımlı → Syntax hatası

**Çözüm:** Farklı bir variable adı kullan veya önceki tanımı temizle

---

## ✅ GÜNCELLEMİŞ KOMUT

**Browser Console'da:**

```javascript
// Önceki client tanımını temizle (opsiyonel)
// delete window.mxMatrixClientPeg;

// Yeni kontrol komutu
const matrixClient = window.mxMatrixClientPeg?.get();
if (matrixClient) {
  const token = matrixClient.getAccessToken();
  
  console.log('🔍 TURN Server Kontrolü Yapılıyor...');
  
  fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
    headers: {
      'Authorization': 'Bearer ' + token
    }
  })
  .then(r => r.json())
  .then(data => {
    console.log('✅ Synapse TURN Server Response:');
    console.log('URIs:', data.uris);
    
    if (data.uris && Array.isArray(data.uris)) {
      console.log('\n📊 URI Analizi:');
      data.uris.forEach((uri, i) => {
        const isRailway = uri.includes('railway') || uri.includes('turn-server-production');
        console.log(`  ${i + 1}. ${uri} ${isRailway ? '❌ (Railway)' : ''}`);
      });
      
      const railwayUris = data.uris.filter(uri => 
        uri.includes('railway') || uri.includes('turn-server-production')
      );
      
      if (railwayUris.length > 0) {
        console.error('\n❌ Railway TURN server hala var:', railwayUris);
        console.error('   → Synapse redeploy edildi mi kontrol et!');
        console.error('   → Birkaç dakika bekle ve tekrar dene!');
      } else {
        console.log('\n✅ Railway TURN server yok - Başarılı!');
        console.log('   → Video call\'u test et!');
        
        const meteredUris = data.uris.filter(uri => uri.includes('metered.ca'));
        console.log(`\n✅ Metered.ca server'lar: ${meteredUris.length} adet`);
        
        const matrixUris = data.uris.filter(uri => uri.includes('matrix.org'));
        console.log(`✅ Matrix.org server'lar: ${matrixUris.length} adet`);
      }
    } else {
      console.error('❌ URIs bulunamadı!');
      console.log('Response:', data);
    }
  })
  .catch(err => {
    console.error('❌ Hata:', err);
  });
} else {
  console.error('❌ Client bulunamadı! Sayfayı yenile ve login ol');
}
```

---

## 🔄 ALTERNATİF: Console'u Temizle

**Eğer sorun devam ederse:**

1. **Console'u temizle** (Ctrl+L veya Clear console butonu)
2. **Yukarıdaki komutu tekrar çalıştır**

---

## 📊 BASIT VERSİYON

**Sadece Railway TURN server kontrolü:**

```javascript
const cli = window.mxMatrixClientPeg?.get();
if (cli) {
  const t = cli.getAccessToken();
  fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
    headers: { 'Authorization': 'Bearer ' + t }
  })
  .then(r => r.json())
  .then(d => {
    const r = d.uris.filter(u => u.includes('railway'));
    if (r.length > 0) {
      console.error('❌ Railway TURN var:', r);
    } else {
      console.log('✅ Railway TURN yok');
    }
  });
}
```

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Komut güncellendi, variable adı değiştirildi

