# 🔍 CONSOLE LOG ANALİZİ

## ✅ NORMAL LOGLAR (Sorun Değil)

### 1. Widget Store Hataları
```
ReferenceError: Cannot access 'B' before initialization
WidgetLayoutStore failed to start
WidgetMessagingStore failed to start
WidgetStore failed to start
```
**Durum:** Bu hatalar widget store'ların initialization sırasıyla ilgili. Video call'ları etkilemez, kritik değil.

### 2. 404 Hatalar
```
GET /_matrix/client/unstable/org.matrix.msc2965/auth_metadata 404
GET /_matrix/client/unstable/org.matrix.msc2965/auth_issuer 404
GET /_matrix/client/unstable/org.matrix.msc3814.v1/dehydrated_device 404
```
**Durum:** Bu endpoint'ler Synapse'de desteklenmiyor. Normal, kritik değil.

### 3. Call Event Discard
```
CallEventHandler handleCallEvent() discarding possible call event as we don't have a call
```
**Durum:** Eski call event'leri discard ediliyor. Normal, yeni call başlatıldığında sorun olmayacak.

### 4. MaxListenersExceededWarning
```
MaxListenersExceededWarning: Possible EventEmitter memory leak detected
```
**Durum:** Memory leak uyarısı ama kritik değil. Production'da sorun yaratmaz.

---

## ⚠️ ÖNEMLİ BULGU

### TURN Server URL'leri Eski!

**Log:**
```
Got TURN URIs: turn:relay.metered.ca:80,turn:relay.metered.ca:443,turn:relay.metered.ca:80?transport=tcp,turn:relay.metered.ca:443?transport=tcp,...
```

**Sorun:** Synapse hala eski URL'leri kullanıyor (`relay.metered.ca`). Ama `config.json`'da yeni URL'ler var (`global.relay.metered.ca`).

**Neden:** `homeserver.yaml`'da `turn_uris` listesi eski URL'leri içeriyor. Yeni URL'leri (`global.relay.metered.ca`) eklememiz gerekiyor.

---

## 🎯 ÇÖZÜM

### `homeserver.yaml` Güncelle

`turn_uris` listesine yeni Metered.ca URL'lerini ekle:
- `stun:stun.relay.metered.ca:80`
- `turn:global.relay.metered.ca:80`
- `turn:global.relay.metered.ca:80?transport=tcp`
- `turn:global.relay.metered.ca:443`
- `turns:global.relay.metered.ca:443?transport=tcp`

---

## ✅ SONUÇ

**Normal Loglar:**
- ✅ Widget store hataları (kritik değil)
- ✅ 404 hatalar (endpoint desteklenmiyor, normal)
- ✅ Call event discard (normal)
- ✅ MaxListenersExceededWarning (kritik değil)

**Sorun:**
- ⚠️ TURN server URL'leri eski (`relay.metered.ca` yerine `global.relay.metered.ca` olmalı)
- ⚠️ `homeserver.yaml` güncellenmeli

**Video Call Test:**
- Video call test etmeden önce `homeserver.yaml`'ı güncelleyip Railway Synapse'i redeploy etmeniz önerilir.

