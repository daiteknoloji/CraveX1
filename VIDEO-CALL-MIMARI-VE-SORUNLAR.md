# 🎥 VIDEO CALL MİMARİSİ VE KOD DIŞI SORUNLAR ANALİZİ

## 📡 VIDEO CALL AKIŞI - VİDEOLAR NEREDEN SERVİS EDİLİYOR?

### 1. **MEDİA CAPTURE (Kamera/Mikrofon)**
```
Kullanıcının Bilgisayarı/Telefonu
    ↓
Browser API (getUserMedia)
    ↓
MediaStream (Video + Audio track'leri)
    ↓
Element Web React Component'leri
    (AudioFeed.tsx, VideoFeed.tsx)
```

**Kod Yeri:**
- `AudioFeed.tsx`: `<audio>` elementine stream'i bağlıyor
- `VideoFeed.tsx`: `<video>` elementine stream'i bağlıyor
- Browser'ın native WebRTC API'si kullanılıyor

---

### 2. **SIGNALING (Arama Başlatma)**
```
Element Web (Caller)
    ↓
Matrix Client SDK (matrix-js-sdk)
    ↓
Synapse Server (Railway)
    ↓
Matrix Events (m.call.invite, m.call.answer, m.call.candidates)
    ↓
Element Web (Receiver)
```

**Kod Yeri:**
- `LegacyCallHandler.tsx`: Call başlatma ve signaling yönetimi
- Synapse: Matrix protokolü üzerinden signaling mesajları gönderiyor
- **ÖNEMLİ:** Signaling sadece mesajlaşma için, video stream'i taşımıyor!

---

### 3. **ICE CANDIDATE EXCHANGE (Bağlantı Bulma)**
```
Caller Browser
    ↓
ICE Candidate'ları topla (STUN/TURN server'lardan)
    ↓
Matrix Event (m.call.candidates) → Synapse → Receiver
    ↓
Receiver Browser
    ↓
ICE Candidate'ları topla (STUN/TURN server'lardan)
    ↓
Matrix Event (m.call.candidates) → Synapse → Caller
```

**Kod Yeri:**
- Browser'ın native WebRTC API'si ICE candidate'ları üretiyor
- `matrix-js-sdk` bu candidate'ları Matrix event'leri olarak gönderiyor
- Synapse sadece **mesaj iletimi** yapıyor, video stream'i taşımıyor!

---

### 4. **PEER-TO-PEER CONNECTION (Doğrudan Bağlantı)**
```
Caller Browser ←→ INTERNET ←→ Receiver Browser
    ↓                              ↓
WebRTC PeerConnection          WebRTC PeerConnection
    ↓                              ↓
RTCPeerConnection              RTCPeerConnection
    ↓                              ↓
MediaStream (Video/Audio) ←→ MediaStream (Video/Audio)
```

**ÖNEMLİ:** 
- Video stream'leri **DOĞRUDAN** iki browser arasında akıyor!
- Synapse **HİÇBİR ZAMAN** video stream'ini görmüyor veya taşımıyor!
- Synapse sadece **signaling** ve **ICE candidate exchange** için kullanılıyor.

---

### 5. **TURN SERVER (NAT Traversal)**
```
Caller Browser
    ↓
NAT/Firewall var → Direkt bağlantı YOK
    ↓
TURN Server (relay.metered.ca, turn.matrix.org)
    ↓
TURN Server üzerinden relay yapıyor
    ↓
Receiver Browser
```

**Kod Yeri:**
- `config.json`: TURN server listesi
- `homeserver.yaml`: Synapse'in TURN server ayarları
- Browser WebRTC API'si otomatik olarak TURN server'ı kullanıyor

**ÖNEMLİ:**
- TURN server **video stream'ini relay ediyor** (gönderiyor)
- TURN server'lar **üçüncü taraf servisler** (Metered.ca, Matrix.org)
- Bu servisler **ücretsiz** ama **limitli** olabilir!

---

## 🔍 KOD DIŞI SORUNLAR (OLASILIKLAR)

### 1. **TURN SERVER SORUNLARI** ⚠️ EN YÜKSEK İHTİMAL

#### A. Metered.ca Authentication Sorunları
```json
{
  "username": "openrelayproject",
  "credential": "openrelayproject"
}
```

**Sorunlar:**
- Metered.ca'nın açık relay servisi (`openrelayproject`) **rate limit**'e takılmış olabilir
- Çok fazla istek geldiğinde servis **geçici olarak bloke** edebilir
- Ücretsiz servis olduğu için **güvenilirlik** düşük olabilir

**Test:**
```javascript
// Browser console'da test et:
const pc = new RTCPeerConnection({
  iceServers: [{
    urls: 'turn:relay.metered.ca:80',
    username: 'openrelayproject',
    credential: 'openrelayproject'
  }]
});

pc.onicecandidate = (e) => {
  if (e.candidate) {
    console.log('TURN candidate:', e.candidate.candidate);
    if (e.candidate.candidate.includes('relay')) {
      console.log('✅ TURN server çalışıyor!');
    }
  }
};
```

#### B. Matrix.org TURN Server Sorunları
```json
{
  "username": "webrtc",
  "credential": "secret"
}
```

**Sorunlar:**
- Matrix.org'un TURN server'ı **public** ama **limitli** olabilir
- Authentication bilgileri **eski** olabilir
- Matrix.org servisi **geçici olarak down** olabilir

---

### 2. **NETWORK/FIREWALL SORUNLARI** ⚠️ YÜKSEK İHTİMAL

#### A. NAT Traversal Başarısız
- Kullanıcıların **firewall**'ları WebRTC'yi engelliyor olabilir
- **Symmetric NAT** durumunda direkt bağlantı mümkün değil, TURN server **zorunlu**
- **Corporate firewall**'lar WebRTC'yi bloke edebilir

**Test:**
```javascript
// Browser console'da:
const pc = new RTCPeerConnection();
pc.onicecandidate = (e) => {
  if (e.candidate) {
    console.log('Candidate type:', e.candidate.type);
    // "host" = direkt bağlantı mümkün
    // "srflx" = STUN başarılı (NAT var ama çözülebilir)
    // "relay" = TURN server kullanılıyor (direkt bağlantı YOK)
  }
};
```

#### B. Port Blocking
- WebRTC **UDP** ve **TCP** portlarını kullanır
- Firewall'lar **belirli portları** bloke edebilir
- **UDP 3478** (STUN/TURN) ve **UDP 49152-65535** (RTP) portları açık olmalı

---

### 3. **BROWSER PERMISSIONS SORUNLARI** ⚠️ ORTA İHTİMAL

#### A. Kamera/Mikrofon İzinleri
- Browser **kamera/mikrofon** izni vermemiş olabilir
- Kullanıcı **"Deny"** seçmiş olabilir
- Browser **otomatik olarak** izin vermemiş olabilir

**Test:**
```javascript
// Browser console'da:
navigator.mediaDevices.getUserMedia({ video: true, audio: true })
  .then(stream => console.log('✅ İzin verildi:', stream))
  .catch(err => console.error('❌ İzin reddedildi:', err));
```

#### B. Browser Compatibility
- Eski browser'lar WebRTC'yi **tam desteklemiyor** olabilir
- **Safari** bazı WebRTC özelliklerini farklı implement ediyor
- **Firefox** bazı durumlarda farklı davranıyor

---

### 4. **STUN SERVER SORUNLARI** ⚠️ DÜŞÜK İHTİMAL

```json
"fallback_stun_server": "stun:stun.l.google.com:19302"
```

**Sorunlar:**
- Google STUN server **geçici olarak down** olabilir
- STUN server **rate limit**'e takılmış olabilir
- **DNS resolution** sorunları olabilir

**Test:**
```javascript
// Browser console'da:
const pc = new RTCPeerConnection({
  iceServers: [{ urls: 'stun:stun.l.google.com:19302' }]
});

pc.onicecandidate = (e) => {
  if (e.candidate) {
    console.log('STUN candidate:', e.candidate.candidate);
    if (e.candidate.type === 'srflx') {
      console.log('✅ STUN server çalışıyor!');
    }
  }
};
```

---

### 5. **SIGNALING SORUNLARI** ⚠️ DÜŞÜK İHTİMAL

#### A. Synapse Server Sorunları
- Synapse **yavaş** yanıt veriyor olabilir
- **Matrix event'leri** gecikmiş olabilir
- **CORS** sorunları (ama bunu çözdük)

**Test:**
```javascript
// Browser console'da:
const client = MatrixClientPeg.safeGet();
console.log('Synapse base URL:', client.baseUrl);
console.log('Turn servers:', client.getTurnServers());
```

#### B. Matrix Event Delivery
- `m.call.candidates` event'leri **geç** ulaşıyor olabilir
- ICE candidate'lar **timeout** olmuş olabilir (genellikle 20-30 saniye)

---

### 6. **MEDIA STREAM SORUNLARI** ⚠️ DÜŞÜK İHTİMAL

#### A. Codec Uyumsuzluğu
- Browser'lar **farklı codec'ler** destekliyor olabilir
- **VP8/VP9** vs **H.264** codec uyumsuzluğu
- Browser **codec seçimi** yapamıyor olabilir

#### B. Bandwidth Sorunları
- Kullanıcıların **internet bağlantısı** yavaş olabilir
- **Upload bandwidth** yetersiz olabilir
- **Network congestion** olabilir

---

## 🎯 EN OLASILIKLI SORUN: TURN SERVER AUTHENTICATION

### Mevcut Durum:
```json
// config.json
{
  "username": "openrelayproject",
  "credential": "openrelayproject"
}
```

### Sorun:
- Metered.ca'nın `openrelayproject` servisi **ücretsiz** ama **limitli**
- **Rate limit** veya **geçici bloke** olabilir
- **Authentication** bilgileri **eski** veya **geçersiz** olabilir

### Çözüm Önerileri:

#### 1. **Metered.ca Ücretsiz Account Oluştur**
- https://www.metered.ca/ adresinden **ücretsiz account** oluştur
- Kendi **username** ve **credential**'ını al
- `config.json`'a ekle

#### 2. **Kendi TURN Server Kur**
- Railway'de **Coturn** servisi kur
- Kendi **TURN server**'ını kullan
- Tam kontrol ve **güvenilirlik**

#### 3. **Alternatif TURN Server Kullan**
- **Twilio** (ücretli ama güvenilir)
- **Xirsys** (ücretli ama güvenilir)
- **Google Cloud TURN** (ücretli ama güvenilir)

---

## 🔧 TEST EDİLMESİ GEREKENLER

### 1. **TURN Server Test**
```javascript
// Browser console'da:
const pc = new RTCPeerConnection({
  iceServers: [
    {
      urls: 'turn:relay.metered.ca:80',
      username: 'openrelayproject',
      credential: 'openrelayproject'
    }
  ]
});

pc.onicecandidate = (e) => {
  if (e.candidate) {
    console.log('Candidate:', e.candidate.candidate);
    if (e.candidate.type === 'relay') {
      console.log('✅ TURN server çalışıyor!');
    }
  } else {
    console.log('❌ TURN server çalışmıyor veya timeout!');
  }
};

// Timeout ekle
setTimeout(() => {
  if (pc.iceGatheringState !== 'complete') {
    console.log('❌ ICE gathering timeout!');
  }
}, 10000);
```

### 2. **Network Test**
```javascript
// Browser console'da:
const pc = new RTCPeerConnection();
pc.onicecandidate = (e) => {
  if (e.candidate) {
    console.log('Candidate type:', e.candidate.type);
    // "host" = direkt bağlantı mümkün
    // "srflx" = STUN başarılı
    // "relay" = TURN server kullanılıyor
  }
};
```

### 3. **Media Permissions Test**
```javascript
// Browser console'da:
navigator.mediaDevices.getUserMedia({ video: true, audio: true })
  .then(stream => {
    console.log('✅ İzin verildi:', stream);
    console.log('Video tracks:', stream.getVideoTracks().length);
    console.log('Audio tracks:', stream.getAudioTracks().length);
  })
  .catch(err => console.error('❌ İzin reddedildi:', err));
```

---

## 📊 SONUÇ VE ÖNERİLER

### En Olası Sorunlar (Öncelik Sırasıyla):
1. **TURN Server Authentication** (Metered.ca `openrelayproject` servisi limitli)
2. **Network/Firewall** (NAT traversal başarısız)
3. **Browser Permissions** (Kamera/mikrofon izni yok)
4. **STUN Server** (Google STUN server geçici olarak down)
5. **Signaling** (Matrix event'leri gecikmiş)

### Acil Çözüm:
1. **Metered.ca account** oluştur ve kendi credential'larını kullan
2. **Alternatif TURN server** ekle (Matrix.org zaten var)
3. **Network test** yap (firewall/NAT durumu kontrol et)
4. **Browser permissions** kontrol et

### Uzun Vadeli Çözüm:
1. **Kendi TURN server** kur (Railway'de Coturn)
2. **Güvenilir TURN servis** kullan (Twilio, Xirsys)
3. **Monitoring** ekle (TURN server durumu izle)

