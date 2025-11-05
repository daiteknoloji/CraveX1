# Metered.ca TURN Server Test ve Doğrulama

## Web Search Sonuçları

✅ **Metered.ca Çalışıyor:**
- 100+ endpoint, 31+ bölge
- %99.999 uptime
- Son 30 gün içinde %100 çalışma süresi
- Güvenilir servis

## Test Yöntemleri

### 1. Browser Console'dan Test

```javascript
// TURN server'ları kontrol et
const client = window.mxMatrixClientPeg?.get();
if (client) {
  const turnServers = client.getTurnServers();
  console.log('Toplam TURN Server:', turnServers.length);
  
  turnServers.forEach((server, index) => {
    console.log(`Server ${index + 1}:`, {
      uris: server.uris,
      username: server.username,
      hasCredential: !!server.credential
    });
  });
  
  // Metered.ca server'larını bul
  const meteredServers = turnServers.filter(s => 
    s.uris.some(uri => uri.includes('metered.ca'))
  );
  console.log('Metered.ca Servers:', meteredServers);
}
```

### 2. Video Call Sırasında Test

Browser console'da şu logları ara:
- `[ICE Debug] ICE Candidate received`
- `[TURN Debug] TURN server response`

Eğer Metered.ca'dan `relay` type candidate geliyorsa çalışıyor demektir.

### 3. Online TURN Test Tool

- https://icetest.info/
- https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/

Test parametreleri:
```
TURN Server: turn:relay.metered.ca:80
Username: openrelayproject
Password: openrelayproject
```

### 4. PowerShell ile Test (Basit)

```powershell
# Metered.ca server'larına ping at
Test-Connection relay.metered.ca -Count 2
Test-Connection openrelay.metered.ca -Count 2
```

## Alternatif TURN Server'lar (Yedek)

Eğer Metered.ca çalışmazsa, şu alternatifler var:

### 1. Matrix.org TURN Server (Zaten config'de var)
```
turn:turn.matrix.org:3478
Username: webrtc
Password: secret
```

### 2. Google STUN Server (Fallback - config'de var)
```
stun:stun.l.google.com:19302
```

### 3. Twilio TURN Server (Ücretli ama güvenilir)
- Ücretsiz tier: 10GB/ay
- Güvenilir ve hızlı

## Sonuç

Metered.ca çalışıyor görünüyor ama kesin emin olmak için:
1. Browser console'dan test et
2. Video call sırasında ICE candidates'i kontrol et
3. Eğer çalışmıyorsa Matrix.org TURN server'ı kullan (zaten config'de var)

