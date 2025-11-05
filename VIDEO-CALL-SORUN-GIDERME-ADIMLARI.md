# 🔍 Video Call Sorun Giderme Adımları

## 1. ICE Debug Loglarını Kontrol Edin

Tarayıcı konsolunu açın (F12) ve bir video call başlatın. Sonra konsolda şunları arayın:

```javascript
// ICE Debug loglarını filtrele
console.log('%c[ICE Debug]', 'color: blue; font-weight: bold', 'Loglar:');
// Konsolda "[ICE Debug]" yazısını arayın
```

**Kontrol edilmesi gerekenler:**
- `[ICE Debug]` logları görünüyor mu?
- `relay` type candidate geliyor mu? (TURN server kullanılıyor mu?)
- `ICE connection state: connected` görünüyor mu?

---

## 2. TURN Server'ları Kontrol Edin

Konsolda şu komutu çalıştırın:

```javascript
// Matrix client'ı al
const matrixClient = window.mxMatrixClientPeg?.get();

if (!matrixClient) {
    console.error('❌ Matrix client bulunamadı!');
} else {
    // TURN server'ları kontrol et
    const turnServers = matrixClient.getTurnServers();
    console.log('📡 TURN Servers:', turnServers);
    
    // Her bir TURN server'ı kontrol et
    turnServers.forEach((server, index) => {
        console.log(`TURN Server ${index + 1}:`, {
            uris: server.uris,
            username: server.username,
            password: server.password?.substring(0, 10) + '...'
        });
    });
}
```

**Beklenen sonuç:**
- En az 3-4 TURN server URI'si görünmeli
- Railway TURN server (`turn-server-production-2809.up.railway.app`) **olmamalı**
- Metered.ca ve Matrix.org TURN server'ları olmalı

---

## 3. ReferenceError Hatası

`ReferenceError: Cannot access 'B' before initialization` hatası, Element Web'in store sisteminde bir circular dependency veya initialization order sorunu gösteriyor. Bu hata video call'ı engelliyor olabilir.

**Bu hatayı çözmek için:**
1. Netlify'da yeni bir build tetikleyin (deploy)
2. Tarayıcı cache'ini temizleyin (Ctrl+Shift+R veya Cmd+Shift+R)
3. Hard refresh yapın

---

## 4. Video Call Başlatma Testi

1. İki farklı tarayıcıda (veya iki farklı cihazda) Element Web'i açın
2. İki farklı kullanıcı ile giriş yapın
3. Birbirlerine mesaj gönderin
4. Video call başlatmayı deneyin

**Konsolda kontrol edin:**
- Call başlatıldığında `[ICE Debug]` logları görünüyor mu?
- `relay` type candidate geliyor mu?
- ICE connection state `connected` oluyor mu?

---

## 5. Network Tab'ı Kontrol Edin

Tarayıcı Developer Tools → Network sekmesine gidin ve call başlatırken:

1. `/_matrix/client/v3/voip/turnServer` isteğini kontrol edin
   - Status: 200 olmalı
   - Response'da Railway TURN server olmamalı

2. WebRTC bağlantılarını kontrol edin
   - Network tab'da `turn:` veya `stun:` ile başlayan bağlantılar görünmeli
   - Bu bağlantıların başarılı olduğunu kontrol edin

---

## 🆘 Sorun Devam Ederse

Eğer yukarıdaki adımlara rağmen video call çalışmıyorsa:

1. **TURN Server Test:** Konsolda şu komutu çalıştırın:
   ```javascript
   const matrixClient = window.mxMatrixClientPeg?.get();
   const turnServers = matrixClient?.getTurnServers();
   console.log('TURN Servers:', JSON.stringify(turnServers, null, 2));
   ```

2. **ICE Connection State:** Konsolda şu komutu çalıştırın:
   ```javascript
   // ICE connection state'leri için
   const pc = new RTCPeerConnection({
       iceServers: [
           { urls: 'stun:stun.l.google.com:19302' }
       ]
   });
   pc.oniceconnectionstatechange = () => {
       console.log('ICE Connection State:', pc.iceConnectionState);
   };
   ```

3. **Network Logları:** Network tab'da WebRTC bağlantılarını kontrol edin

4. **Browser Console:** Tüm hataları ve uyarıları kontrol edin

---

**Not:** `ReferenceError: Cannot access 'B' before initialization` hatası uygulamanın başlatılmasını engelliyor olabilir. Bu durumda video call fonksiyonları düzgün çalışmayabilir. Netlify'da yeni bir build tetikleyip tarayıcı cache'ini temizleyin.

