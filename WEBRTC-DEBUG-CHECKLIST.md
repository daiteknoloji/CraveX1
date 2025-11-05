# WebRTC Video Call Debug Checklist

## Sorun: Video/Voice Call Çalışmıyor

### Kontrol Listesi:

1. **Railway TURN Server Logs:**
   - Railway Dashboard > TURN-SERVER service > Logs
   - Coturn başladı mı?
   - Port 3478'de dinliyor mu?

2. **Synapse TURN Server Response:**
   ```javascript
   fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
     headers: { 'Authorization': 'Bearer ' + window.mxMatrixClient.getAccessToken() }
   }).then(r => r.json()).then(d => console.log('TURN Response:', JSON.stringify(d, null, 2)));
   ```

3. **Browser Console Logs:**
   - Video call başlat
   - Console'da şu mesajları ara:
     - `Available TURN servers: X`
     - `TURN Server X:`
     - `ICE Candidate:`
     - `ICE Connection State:`

4. **Call Auto-Close Sorunu:**
   - ICE bağlantısı kurulamıyor
   - TURN server candidates oluşmuyor
   - Relay connection başarısız

### Çözümler:

1. **Railway TURN Server Çalışmıyorsa:**
   - TURN-SERVER service'i restart et
   - Logları kontrol et

2. **Synapse TURN Response Boşsa:**
   - Metered.ca TURN servers fallback olarak kullanılacak
   - Config'de Metered.ca öncelikli

3. **ICE Candidates Yoksa:**
   - TURN server bağlantısı başarısız
   - UDP/TCP port'ları kontrol et

