# 🔧 TURN SERVER KONTROL KOMUTU (DÜZELTİLMİŞ)

**Sorun:** `getTurnServers()` Promise döndürmüyor, senkron bir fonksiyon.

**Çözüm:** Direkt çağır, `.then()` kullanma!

---

## ✅ DOĞRU KULLANIM

### Browser Console'da Çalıştır:

```javascript
// TURN server'ları kontrol et
const client = window.mxMatrixClientPeg?.get();
if (client) {
  const turnServers = client.getTurnServers();
  
  console.log('🔍 TURN Server Analizi:');
  console.log('Toplam Server:', turnServers.length);
  
  turnServers.forEach((server, i) => {
    console.log(`\nServer ${i + 1}:`);
    console.log('  URIs:', server.uris);
    console.log('  Username:', server.username);
    console.log('  Credential:', server.credential ? '***' : 'yok');
    
    if (server.uris) {
      const railwayServer = server.uris.find(uri => 
        uri.includes('railway') || uri.includes('turn-server-production')
      );
      
      if (railwayServer) {
        console.error('  ❌ Railway TURN server bulundu:', railwayServer);
      } else {
        console.log('  ✅ Railway TURN server yok');
      }
      
      const meteredServer = server.uris.find(uri => 
        uri.includes('metered.ca')
      );
      
      if (meteredServer) {
        console.log('  ✅ Metered.ca server bulundu:', meteredServer);
      }
      
      const matrixServer = server.uris.find(uri => 
        uri.includes('matrix.org')
      );
      
      if (matrixServer) {
        console.log('  ✅ Matrix.org server bulundu:', matrixServer);
      }
    } else {
      console.error('  ❌ URIs undefined!');
    }
  });
  
  // Özet
  const railwayCount = turnServers.reduce((count, server) => {
    if (server.uris) {
      return count + server.uris.filter(uri => uri.includes('railway')).length;
    }
    return count;
  }, 0);
  
  if (railwayCount > 0) {
    console.error(`\n❌ ${railwayCount} Railway TURN server URI'si bulundu!`);
  } else {
    console.log('\n✅ Railway TURN server yok - Başarılı!');
  }
} else {
  console.error('❌ Client bulunamadı!');
}
```

---

## 📊 BASIT VERSİYON

**Sadece Railway TURN server kontrolü:**

```javascript
const client = window.mxMatrixClientPeg?.get();
if (client) {
  const turnServers = client.getTurnServers();
  let railwayFound = false;
  
  turnServers.forEach((server, i) => {
    if (server.uris) {
      const railway = server.uris.find(uri => uri.includes('railway'));
      if (railway) {
        console.error(`❌ Server ${i+1}: Railway TURN bulundu:`, railway);
        railwayFound = true;
      }
    }
  });
  
  if (!railwayFound) {
    console.log('✅ Railway TURN server yok - Başarılı!');
  }
}
```

---

## 🎯 DETAYLI ANALİZ

**Tüm TURN server bilgilerini göster:**

```javascript
const client = window.mxMatrixClientPeg?.get();
if (client) {
  const turnServers = client.getTurnServers();
  
  console.log('📊 TURN Server Detayları:');
  console.log(JSON.stringify(turnServers, null, 2));
  
  // TURN server URI'lerini listeleyin
  turnServers.forEach((server, i) => {
    console.log(`\nServer ${i + 1}:`);
    if (server.uris && Array.isArray(server.uris)) {
      server.uris.forEach((uri, j) => {
        const isRailway = uri.includes('railway');
        console.log(`  URI ${j + 1}: ${uri} ${isRailway ? '❌ (Railway)' : ''}`);
      });
    } else {
      console.log('  URIs:', server.uris);
    }
  });
}
```

---

## ✅ TEST ADIMLARI

1. **Browser console'u aç** (F12)
2. **Yukarıdaki komutu yapıştır ve Enter'a bas**
3. **Sonuçları kontrol et:**
   - Railway TURN server varsa → ❌ Railway TURN server'ı pause et
   - Railway TURN server yoksa → ✅ Başarılı!

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Komut düzeltildi, senkron kullanım için güncellendi

