# 🚨 RAILWAY TURN SERVER HALA LİSTEDE - DETAYLI ÇÖZÜM

**Sorun:** Railway TURN server hala Synapse response'unda ❌  
**Config'de yok ama hala listede** → Railway'de environment variable olabilir!

---

## 🔍 SORUN ANALİZİ

### ✅ Kontrol Edilenler:
- ✅ `synapse-railway-config/homeserver.yaml` → Railway TURN server **YOK**
- ✅ `www/element-web/config.json` → Railway TURN server **YOK**
- ❌ **Railway TURN server hala Synapse response'unda** → Railway'de environment variable olabilir!

---

## 🛠️ ÇÖZÜM ADIMLARI

### Adım 1: Railway Dashboard'da Environment Variables Kontrol Et ✅

**Railway Dashboard'da:**

1. **Synapse** servisini seç
2. **Settings** → **Variables** sekmesi
3. **Şu variable'ları ara:**
   - `TURN_URIS`
   - `TURN_SERVER_URL`
   - `TURN_SERVER`
   - `TURN_URI`
   - `COTURN_URL`
   - `SYNAPSE_TURN_URIS`
   - Veya `TURN` içeren herhangi bir variable

4. **Eğer Railway TURN server URL'ini içeren variable varsa:**
   - Variable'ı **Delete** et
   - Veya Railway TURN server URL'ini kaldır, sadece Metered.ca ve Matrix.org bırak

---

### Adım 2: Railway TURN Server Servisini Kontrol Et ✅

**Railway Dashboard'da:**

1. **`turn-server`** servisini seç
2. **Deployments** sekmesi → Son deployment durumu nedir?
3. **Settings** → Servis **pause** mu yoksa **active** mi?

**Eğer active ise:**
- **Settings** → **Service Actions** → **Pause Service**
- Veya servisi **Delete** et

---

### Adım 3: Synapse Service'i Redeploy Et ✅

**Railway Dashboard'da:**

1. **Synapse** servisi
2. **Settings** → **Service Actions** → **Redeploy**
3. **Deployment tamamlanmasını bekle** (2-3 dakika)

---

### Adım 4: Railway Config File Kontrol Et ✅

**Railway Dashboard'da:**

1. **Synapse** servisi
2. **Settings** → **Config-as-code** sekmesi
3. **Railway Config File** var mı kontrol et
4. **Eğer varsa:** Railway TURN server URL'ini içeren satırı kaldır

---

## 🔍 ALTERNATİF: Railway TURN Server Private Network Kontrolü

**Railway TURN server private network üzerinden erişilebilir mi?**

Railway Dashboard → **Synapse** servisi → **Settings** → **Variables**:

- `TURN_SERVER` variable'ı `turn-server.railway.internal` içeriyor mu?
- Eğer içeriyorsa → Bu Railway internal network, dışarıdan çalışmaz!

**Çözüm:** Bu variable'ı kaldır veya dışarıdan erişilebilir bir URL kullan.

---

## 📊 BEKLENEN SONUÇ

### Railway Environment Variable Kaldırıldıktan Sonra:

**Synapse response'unda görülmesi gereken:**
```json
{
  "uris": [
    "turn:relay.metered.ca:80",
    "turn:relay.metered.ca:443",
    ...
  ]
}
```

**Railway TURN server olmamalı!**

---

## 🎯 HIZLI KONTROL KOMUTU

**Railway Dashboard'da kontrol et:**

1. **Synapse** servisi → **Settings** → **Variables**
2. **Arama:** `turn` veya `railway`
3. **Eğer Railway TURN server içeren variable bulursan:**
   - Variable'ı **Delete** et
   - **Synapse'i redeploy et**

---

## ⚠️ ÖNEMLİ NOTLAR

1. **Railway environment variable'lar config dosyasını override eder!**
2. **Railway TURN server servisi pause edilse bile**, environment variable varsa Synapse response'unda görünebilir
3. **Hem Railway TURN server servisini pause et** hem de **environment variable'ı kaldır**

---

## 🔄 SONRAKI ADIMLAR

1. ✅ Railway Dashboard → Synapse → Variables → Railway TURN server variable'ını kontrol et
2. ✅ Railway TURN server variable'ını kaldır
3. ✅ Railway TURN server servisini pause et
4. ✅ Synapse'i redeploy et
5. ✅ Test et

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Railway environment variable kontrolü eklendi

