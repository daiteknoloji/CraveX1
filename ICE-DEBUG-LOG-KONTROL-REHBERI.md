# 🔍 ICE DEBUG LOGLARINI KONTROL ETME REHBERİ

**Tarih:** 1 Kasım 2025  
**Amaç:** Video call sırasında hangi TURN server'ların kullanıldığını görmek

---

## 📋 ADIM ADIM REHBER

### 1️⃣ Browser Console'u Aç

**Chrome/Edge:**
- `F12` tuşuna bas
- Veya `Ctrl + Shift + I` (Windows) / `Cmd + Option + I` (Mac)
- Veya Sağ tık → "Inspect" → "Console" sekmesi

**Firefox:**
- `F12` tuşuna bas
- Veya `Ctrl + Shift + K` (Windows) / `Cmd + Option + K` (Mac)

**Safari:**
- `Cmd + Option + C` (Mac)
- Önce Developer Menu'yi aç: Preferences → Advanced → "Show Develop menu"

---

### 2️⃣ Console'u Temizle ve Hazırla

**Console'u temizlemek için:**
- Console'da sağ tık → "Clear console"
- Veya `Ctrl + L` (Windows) / `Cmd + K` (Mac)

**Filter ayarları:**
- Console'da üstteki filter çubuğuna tıkla
- "Verbose" seçeneğini aç (tüm logları görmek için)

---

### 3️⃣ Video Call Başlat

1. Element Web'de bir odaya gir
2. Video call butonuna tıkla (telefon ikonu)
3. Karşı taraf çağrıyı kabul etsin

---

### 4️⃣ ICE Debug Loglarını Ara

**Console'da şu logları ara:**

#### A) ICE Connection State Logları:
```
[ICE Debug] ICE Connection State changed: checking
[ICE Debug] ICE Connection State changed: connected
[ICE Debug] ICE Connection State changed: failed
```

#### B) ICE Candidate Logları:
```
[ICE Debug] ICE Candidate received: {type: "relay", ...}
[ICE Debug] ICE Candidate received: {type: "host", ...}
[ICE Debug] ICE Candidate received: {type: "srflx", ...}
```

#### C) TURN Server Logları:
```
Available TURN servers: 3
TURN Server 1: {...}
TURN Server 2: {...}
```

---

### 5️⃣ Logları Filtreleme

**Console filter çubuğuna yaz:**

1. **ICE Debug loglarını görmek için:**
   ```
   ICE Debug
   ```

2. **TURN server loglarını görmek için:**
   ```
   TURN Server
   ```

3. **Sadece hataları görmek için:**
   ```
   Error
   ```

4. **Tüm logları görmek için:**
   ```
   (boş bırak)
   ```

---

## 🔍 ARANACAK LOGLAR VE ANLAMLARI

### ✅ Başarılı TURN Server Kullanımı:

```
[ICE Debug] ICE Candidate received: {
  type: "relay",
  candidate: "candidate:... relay.metered.ca ...",
  ...
}
```

**Anlam:** TURN server başarıyla kullanılıyor! ✅

---

### ⚠️ Direkt Bağlantı (TURN gerekmiyor):

```
[ICE Debug] ICE Candidate received: {
  type: "host",
  candidate: "candidate:... 192.168.1.100 ...",
  ...
}
```

**Anlam:** Aynı network'te olduğunuz için direkt bağlantı kuruldu. TURN gerekmedi.

---

### ❌ TURN Server Başarısız:

```
[ICE Debug] ICE Connection State changed: failed
[ICE Debug] ICE Connection failed or disconnected!
```

**Anlam:** TURN server'lara bağlanılamadı veya ICE bağlantısı başarısız oldu.

---

## 🧪 MANUEL TEST KOMUTLARI

### 1. TURN Server'ları Kontrol Et:

Console'da şunu çalıştır:

```javascript
// TURN server'ları göster
const client = window.mxMatrixClientPeg?.get();
if (!client) {
  console.error('❌ Matrix client bulunamadı!');
} else {
  client.getTurnServers().then(servers => {
    console.log('🔍 Kullanılabilir TURN Server\'lar:');
    console.log(`Toplam: ${servers.length} server`);
    
    servers.forEach((server, index) => {
      console.log(`\n${index + 1}. TURN Server:`);
      console.log('  URIs:', server.uris);
      console.log('  Username:', server.username || 'yok');
      console.log('  Credential:', server.credential ? 'var' : 'yok');
    });
  }).catch(err => {
    console.error('❌ TURN server\'lar alınamadı:', err);
  });
}
```

---

### 2. ICE Connection State'i İzle:

Console'da şunu çalıştır:

```javascript
// Mevcut call'ları kontrol et
const callHandler = window.mxLegacyCallHandler;
if (callHandler) {
  const calls = callHandler.getAllActiveCalls();
  console.log('📞 Aktif Call\'lar:', calls.length);
  
  calls.forEach((call, index) => {
    console.log(`\nCall ${index + 1}:`);
    if (call.peerConn) {
      console.log('  ICE Connection State:', call.peerConn.iceConnectionState);
      console.log('  ICE Gathering State:', call.peerConn.iceGatheringState);
      console.log('  Signaling State:', call.peerConn.signalingState);
    } else {
      console.log('  PeerConnection henüz oluşturulmadı');
    }
  });
} else {
  console.error('❌ Call handler bulunamadı!');
}
```

---

### 3. Synapse TURN Endpoint'i Test Et:

Console'da şunu çalıştır:

```javascript
// Synapse'den TURN server bilgilerini al
const client = window.mxMatrixClientPeg?.get();
if (!client) {
  console.error('❌ Matrix client bulunamadı!');
} else {
  const token = client.getAccessToken();
  
  fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
    headers: { 
      'Authorization': 'Bearer ' + token 
    }
  })
  .then(r => {
    console.log('📡 Response Status:', r.status);
    return r.json();
  })
  .then(d => {
    console.log('✅ TURN Server Response:');
    console.log(JSON.stringify(d, null, 2));
    
    if (!d.uris || d.uris.length === 0) {
      console.error('❌ TURN server URI\'leri boş!');
    } else {
      console.log(`✅ ${d.uris.length} TURN server URI bulundu:`);
      d.uris.forEach((uri, i) => {
        console.log(`  ${i+1}. ${uri}`);
      });
    }
  })
  .catch(e => {
    console.error('❌ TURN Server Request Failed:', e);
  });
}
```

---

### 4. Camera/Microphone İzinlerini Test Et:

Console'da şunu çalıştır:

```javascript
// Media permissions kontrolü
navigator.mediaDevices.getUserMedia({ video: true, audio: true })
  .then(stream => {
    console.log('✅ Camera/Microphone izni var!');
    console.log('Video tracks:', stream.getVideoTracks().length);
    console.log('Audio tracks:', stream.getAudioTracks().length);
    
    // Stream'i kapat
    stream.getTracks().forEach(track => track.stop());
  })
  .catch(e => {
    console.error('❌ Camera/Microphone izni yok:', e);
    console.error('Hata tipi:', e.name);
    console.error('Hata mesajı:', e.message);
  });
```

---

## 📊 LOG ÖRNEKLERİ

### ✅ Başarılı Video Call:

```
[ICE Debug] Setting up ICE monitoring for call abc123
[ICE Debug] Initial ICE state: new, Gathering: new, Signaling: stable
[ICE Debug] ICE Gathering State changed: gathering
[ICE Debug] ICE Candidate received: {type: "host", ...}
[ICE Debug] ICE Candidate received: {type: "srflx", ...}
[ICE Debug] ICE Candidate received: {type: "relay", candidate: "... relay.metered.ca ..."}
[ICE Debug] ICE Gathering State changed: complete
[ICE Debug] ICE Connection State changed: checking
[ICE Debug] ICE Connection State changed: connected
✅ Video call başarılı!
```

---

### ❌ Başarısız Video Call:

```
[ICE Debug] Setting up ICE monitoring for call abc123
[ICE Debug] ICE Gathering State changed: gathering
[ICE Debug] ICE Candidate received: {type: "host", ...}
[ICE Debug] ICE Connection State changed: checking
[ICE Debug] ICE Connection State changed: failed
[ICE Debug] ICE Connection failed or disconnected!
❌ Video call başarısız!
```

---

## 🎯 HIZLI KONTROL CHECKLIST

Video call başlatırken şunları kontrol et:

- [ ] Console açık mı? (`F12`)
- [ ] Filter'da "Verbose" açık mı?
- [ ] `[ICE Debug]` logları görünüyor mu?
- [ ] `relay` type candidate geliyor mu? (TURN server kullanılıyor)
- [ ] `ICE Connection State: connected` görünüyor mu?
- [ ] Herhangi bir error mesajı var mı?

---

## 🔧 SORUN GİDERME

### Loglar görünmüyorsa:

1. **Console filter'ı kontrol et:**
   - Filter çubuğunda "Verbose" seçeneği açık olmalı
   - Filter'da "All levels" seçili olmalı

2. **Sayfayı yenile:**
   - `Ctrl + R` (Windows) / `Cmd + R` (Mac)
   - Veya hard refresh: `Ctrl + Shift + R`

3. **Cache'i temizle:**
   - Browser settings → Clear browsing data → Cached images and files

---

### Sadece hataları görmek istiyorsan:

Console filter çubuğuna yaz:
```
Error Failed Exception
```

---

## 📝 NOTLAR

1. **ICE Debug logları** sadece video call başlatıldığında görünür
2. **TURN server logları** call başlatılmadan önce de görülebilir
3. **`relay` type candidate** geliyorsa TURN server kullanılıyor demektir
4. **`host` type candidate** direkt bağlantı demektir (TURN gerekmiyor)

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Rehber hazırlandı

