# TURN Server Test Komutları

## 1. PowerShell ile TCP Bağlantı Testi

```powershell
Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478
```

## 2. Browser Console'dan Test

```javascript
// TURN server response'u kontrol et
const client = window.mxMatrixClientPeg?.get();
if (client) {
  const turnServers = client.getTurnServers();
  console.log('TURN Servers:', turnServers);
  
  // Railway TURN server'ı bul
  const railwayTurn = turnServers.find(s => 
    s.uris.some(uri => uri.includes('turn-server-production-2809'))
  );
  console.log('Railway TURN:', railwayTurn);
}
```

## 3. Online Test Araçları

- https://icetest.info/
- https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/

Test parametreleri:
- TURN Server: `turn:turn-server-production-2809.up.railway.app:3478?transport=tcp`
- Username: `webrtc`
- Password: `secret`

## 4. Railway Dashboard Kontrolü

1. Railway Dashboard'a git
2. TURN server servisini bul
3. "Metrics" sekmesinde connection sayısını kontrol et
4. "Logs" sekmesinde connection attempt'leri kontrol et

## 5. Video Call Sırasında Test

Browser console'da şu logları ara:
- `[ICE Debug] ICE Candidate received`
- `[ICE Debug] ICE Connection State changed`
- `[TURN Debug] TURN server response`

Eğer Railway TURN server'dan `relay` type candidate geliyorsa çalışıyor demektir.

