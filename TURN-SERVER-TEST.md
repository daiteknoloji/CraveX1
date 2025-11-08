# TURN Server Test ve Kontrol Kılavuzu

## 1. Railway TURN Server Durumu

Railway'de TURN server çalışıyor:
- **Domain**: `turn-server-production-2809.up.railway.app`
- **Port**: `3478`
- **Shared Secret**: `n0t4ctu4lly4n4ctua1s3cr3t4t4ll`

## 2. Synapse Config Kontrolü

`synapse-railway-config/homeserver.yaml` dosyasında TURN ayarları var:
```yaml
turn_uris:
  - "turn:turn-server-production-2809.up.railway.app:3478?transport=tcp"
turn_shared_secret: "n0t4ctu4lly4n4ctua1s3cr3t4t4ll"
turn_user_lifetime: 86400000
turn_allow_guests: true
```

## 3. TURN Server Test Komutları

### Browser Console'da Test:

```javascript
// 1. Matrix Client'i al
const client = window.mxMatrixClientPeg?.get();
if (!client) {
  console.error("Matrix client bulunamadı!");
}

// 2. TURN Server bilgilerini kontrol et
client.getTurnServers().forEach((server, index) => {
  console.log(`TURN Server ${index + 1}:`, {
    uris: server.uris,
    username: server.username,
    credential: server.credential ? "***" : "YOK"
  });
});

// 3. TURN Server endpoint'ini test et
fetch('https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer', {
  headers: {
    'Authorization': 'Bearer ' + client.getAccessToken()
  }
})
.then(r => r.json())
.then(data => {
  console.log('TURN Server Response:', JSON.stringify(data, null, 2));
})
.catch(err => console.error('TURN Server Hatası:', err));
```

## 4. TURN Server Bağlantı Testi

### Browser'da WebRTC Test:

```javascript
// TURN server bağlantısını test et
async function testTurnServer() {
  const client = window.mxMatrixClientPeg?.get();
  if (!client) {
    console.error("Matrix client yok!");
    return;
  }

  const turnServers = client.getTurnServers();
  if (turnServers.length === 0) {
    console.error("TURN server bulunamadı!");
    return;
  }

  const turnServer = turnServers[0];
  console.log("Test edilen TURN Server:", turnServer);

  // WebRTC peer connection oluştur
  const pc = new RTCPeerConnection({
    iceServers: turnServer.uris.map(uri => ({
      urls: uri,
      username: turnServer.username,
      credential: turnServer.credential
    }))
  });

  // ICE candidate eventi
  pc.onicecandidate = (event) => {
    if (event.candidate) {
      console.log("ICE Candidate:", event.candidate.candidate);
      console.log("ICE Type:", event.candidate.type);
    } else {
      console.log("ICE gathering tamamlandı");
    }
  };

  // ICE connection state
  pc.oniceconnectionstatechange = () => {
    console.log("ICE Connection State:", pc.iceConnectionState);
  };

  // ICE gathering state
  pc.onicegatheringstatechange = () => {
    console.log("ICE Gathering State:", pc.iceGatheringState);
  };

  // Dummy data channel oluştur (test için)
  const dataChannel = pc.createDataChannel("test");
  dataChannel.onopen = () => {
    console.log("Data channel açıldı!");
  };

  // Offer oluştur
  const offer = await pc.createOffer();
  await pc.setLocalDescription(offer);
  
  console.log("Test başlatıldı. ICE gathering bekleniyor...");
  
  // 10 saniye bekle
  setTimeout(() => {
    console.log("Final ICE Connection State:", pc.iceConnectionState);
    pc.close();
  }, 10000);
}

// Testi çalıştır
testTurnServer();
```

## 5. Railway'de TURN Server Logları

Railway dashboard'unda TURN server loglarını kontrol edin:
- Loglar `turnserver.conf` içinde `verbose` modunda çalışıyor
- Bağlantı girişlerini görebilmelisiniz

## 6. Synapse TURN Server Endpoint Testi

```bash
# cURL ile test (Railway terminal'den veya local'den)
curl -X GET \
  "https://cravex1-production.up.railway.app/_matrix/client/v3/voip/turnServer" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## 7. Sorun Giderme

### TURN Server bulunamıyor:
1. Synapse'i yeniden başlatın
2. `turn_uris` listesinin doğru olduğunu kontrol edin
3. Shared secret'ın eşleştiğini kontrol edin

### ICE bağlantısı başarısız:
1. Railway'de UDP desteği yoksa sadece TCP kullanın
2. `turnserver.conf` içinde `no-udp-relay` aktif olmalı
3. TURN URI'lerinde `?transport=tcp` kullanın

### Element Web'de TURN server görmüyor:
1. Browser console'da `client.getTurnServers()` çalıştırın
2. Eğer boş array dönüyorsa, Synapse endpoint'i kontrol edin
3. Network tab'de `/_matrix/client/v3/voip/turnServer` isteğini kontrol edin

## 8. Güncel Durum

✅ TURN server Railway'de çalışıyor
✅ Synapse config'inde TURN ayarları var
✅ Shared secret eşleşiyor
⏳ Element Web'de test edilmeli


