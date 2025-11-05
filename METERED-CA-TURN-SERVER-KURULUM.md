# 🎯 METERED.CA TURN SERVER YAPILANDIRMASI

## 📋 METERED.CA DASHBOARD'DAN CREDENTIALS ALMA

### Adım 1: Metered.ca Dashboard'a Giriş Yap

1. https://dashboard.metered.ca/dashboard/app/690b61526dbcb23e770e7be0 adresine git
2. Giriş yap (email ve password ile)

### Adım 2: TURN Server Credentials'ları Bul

Metered.ca dashboard'unda şu bilgileri bulman gerekiyor:

#### Genellikle Şu Yerlerde Bulunur:

1. **"TURN Servers"** veya **"WebRTC"** sekmesi
2. **"Credentials"** veya **"API Keys"** bölümü
3. **"Settings"** veya **"Configuration"** sekmesi

#### İhtiyacımız Olan Bilgiler:

- **TURN Server URL'leri:**
  - `turn:relay.metered.ca:80`
  - `turn:relay.metered.ca:443`
  - `turn:relay.metered.ca:80?transport=tcp`
  - `turn:relay.metered.ca:443?transport=tcp`

- **Username:** (Metered.ca'dan alınan)
- **Password/Secret:** (Metered.ca'dan alınan)

### Adım 3: Bilgileri Paylaş

Bana şunları söyle:
1. **Username:** (Metered.ca'dan aldığın)
2. **Password/Secret:** (Metered.ca'dan aldığın)

**ÖNEMLİ:** Bu bilgileri güvenli bir şekilde paylaş! (config.json'da kullanacağız)

---

## 🔧 ALTERNATİF: METERED.CA DASHBOARD'DA BULAMAZSAN

Eğer Metered.ca dashboard'unda TURN server credentials'larını bulamazsan:

### Metered.ca'nın Genel Formatı:

Metered.ca genellikle şu formatta credentials verir:

```json
{
  "username": "XXXXX",  // Metered.ca'dan alınan username
  "password": "XXXXX"   // Metered.ca'dan alınan password/secret
}
```

### Dashboard'da Bakılacak Yerler:

1. **"TURN Servers"** sekmesi
2. **"WebRTC"** sekmesi
3. **"Credentials"** veya **"API Keys"** bölümü
4. **"Settings"** → **"TURN Configuration"**
5. **"Apps"** → **"Your App"** → **"TURN Servers"**

---

## 📝 SONRAKI ADIMLAR

Metered.ca'dan credentials'ları aldıktan sonra:

1. **config.json** güncelleyeceğim
2. **homeserver.yaml** güncelleyeceğim (opsiyonel)
3. Git commit ve push yapacağım
4. Netlify otomatik deploy yapacak

---

## ✅ HAZIR OLDUĞUNDA

Metered.ca dashboard'undan credentials'ları aldıktan sonra bana şunları söyle:

1. **Username:** (Metered.ca'dan aldığın)
2. **Password/Secret:** (Metered.ca'dan aldığın)

Sonra `config.json`'ı güncelleyeceğim!

