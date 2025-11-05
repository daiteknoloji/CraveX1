# Railway Port 3478 Expose Etme - Detaylı Açıklama

## Railway Dashboard'da Nerede?

### 1. Servis Seçimi
```
Railway Dashboard
  └─ Projen
      └─ TURN Server Servisi (turn-server-production-2809)
```

### 2. Settings Sekmesi
```
TURN Server Servisi Sayfası
  ├─ Overview (Ana sayfa)
  ├─ Deployments (Deploy geçmişi)
  ├─ Metrics (Metrikler)
  ├─ Logs (Loglar)
  ├─ Settings ⬅️ BU KISIMDA
  └─ Variables (Environment variables)
```

### 3. Networking Bölümü
```
Settings Sayfası
  ├─ General (Genel ayarlar)
  ├─ Variables (Environment variables)
  ├─ Networking ⬅️ BU KISIMDA
  │   ├─ Public Networking
  │   ├─ Ports
  │   └─ Domains
  └─ Delete Service
```

## Adım Adım Görsel Açıklama

### Adım 1: Railway Dashboard
1. https://railway.app/dashboard adresine git
2. Giriş yap
3. Projeni seç

### Adım 2: TURN Server Servisini Bul
- Sol tarafta servis listesi var
- "turn-server-production-2809" veya benzeri isimli servisi bul
- Servise tıkla

### Adım 3: Settings Sekmesine Git
- Üst menüde sekme'ler var:
  - Overview
  - Deployments
  - Metrics
  - Logs
  - **Settings** ⬅️ Buraya tıkla

### Adım 4: Networking Bölümünü Bul
Settings sayfasında şunlar görünür:
- **General** (servis adı, açıklama)
- **Variables** (environment variables)
- **Networking** ⬅️ Buraya tıkla veya aşağı kaydır
- **Delete Service** (servisi sil)

### Adım 5: Port Ekleme
Networking bölümünde:

**Eğer "Ports" sekmesi varsa:**
1. "Ports" sekmesine tıkla
2. "Add Port" veya "+" butonuna tıkla
3. Şu bilgileri gir:
   - **Port Number:** `3478`
   - **Protocol:** `TCP` (dropdown'dan seç)
   - **Public:** `Yes` veya checkbox'ı işaretle
4. "Save" veya "Add" butonuna tıkla

**Eğer "Public Networking" toggle'ı varsa:**
1. "Public Networking" toggle'ını aç (ON)
2. "Custom Port" veya "Port" bölümüne git
3. Port `3478` ekle
4. Protocol: `TCP` seç
5. Kaydet

**Eğer hiçbiri yoksa:**
Railway'in free tier'ında custom port expose etme özelliği olmayabilir. Bu durumda:
- Sadece HTTP/HTTPS portları otomatik expose edilir
- TURN server için Railway kullanamazsın
- Metered.ca server'larına güvenmek zorundasın

## Alternatif: Railway.json Dosyası

Eğer Railway Dashboard'da port expose seçeneği yoksa, proje root'unda `railway.json` dosyası oluştur:

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "DOCKERFILE",
    "dockerfilePath": "turnserver.Dockerfile"
  },
  "deploy": {
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

Ama Railway.json port expose için yeterli olmayabilir. Railway'in free tier'ında bu özellik sınırlı olabilir.

## Kontrol

Eğer port expose edildiyse:
1. Networking bölümünde port 3478 listelenir
2. Public URL oluşturulur (örn: `turn-server-production-2809.up.railway.app:3478`)
3. Test komutu çalışır:
   ```powershell
   Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478
   ```

## Önemli Not

Railway'in free tier'ında custom port expose etme özelliği **olmayabilir**. Bu durumda:
- Railway TURN server'ı kullanamazsın
- Metered.ca ve Matrix.org TURN server'ları zaten config'de var ve çalışıyor
- Bu server'lar yeterli olmalı

