# Video Call Debug - Doğru JavaScript Komutları

## Sorun: Client ve Call Bulunamıyor

### 1. Client'ı Kontrol Et:

```javascript
// Client'ı kontrol et
const client = window.mxMatrixClientPeg?.get();
if (client) {
  console.log('✅ Client bulundu!');
  console.log('Access Token:', client.getAccessToken());
  console.log('TURN Servers:', client.getTurnServers());
  console.log('TURN Expiry:', new Date(client.getTurnServersExpiry()));
} else {
  console.log('❌ Client bulunamadı!');
}
```

### 2. Video Call Başlat ve Sonra Kontrol Et:

**Önce video call başlat**, sonra console'da şunu çalıştır:

```javascript
// Call handler'ı kontrol et
const callHandler = window.mxCallHandler;
console.log('Call Handler:', callHandler);

// Tüm aktif call'ları bul
const roomId = '!LFjbjtvUnFoKwpYjPj:cravex1-production.up.railway.app';
const call = callHandler?.getCallForRoom(roomId);
console.log('Call:', call);

if (call?.peerConn) {
  console.log('✅ Peer Connection bulundu!');
  console.log('ICE Connection State:', call.peerConn.iceConnectionState);
  console.log('ICE Gathering State:', call.peerConn.iceGatheringState);
  
  // ICE candidates'i dinle
  call.peerConn.addEventListener('icecandidate', (e) => {
    if (e.candidate) {
      console.log('ICE Candidate:', e.candidate.candidate);
      console.log('Type:', e.candidate.type);
      console.log('Protocol:', e.candidate.protocol);
    }
  });
} else {
  console.log('❌ Peer Connection bulunamadı!');
}
```

### 3. TURN Server Response (Client ile):

```javascript
const client = window.mxMatrixClientPeg?.get();
if (client) {
  fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
    headers: { 'Authorization': 'Bearer ' + client.getAccessToken() }
  }).then(r => r.json()).then(d => {
    console.log('✅ TURN Response:', JSON.stringify(d, null, 2));
  }).catch(err => console.error('❌ TURN Error:', err));
} else {
  console.log('❌ Client bulunamadı!');
}
```

### 4. Tüm Call'ları Listele:

```javascript
// Tüm aktif call'ları bul
const callHandler = window.mxCallHandler;
if (callHandler) {
  // Call handler'ın içindeki tüm call'ları görmek için
  console.log('Call Handler:', callHandler);
  
  // Room ID'yi manuel olarak deneyin
  const roomId = '!LFjbjtvUnFoKwpYjPj:cravex1-production.up.railway.app';
  const call = callHandler.getCallForRoom(roomId);
  console.log('Call for room:', call);
}
```

## Önemli Notlar:

1. **Video call başlatmadan önce** client'ın başlatıldığından emin ol
2. **Video call başlattıktan sonra** call'ı kontrol et
3. **ICE candidates** için call aktifken kontrol et

