# 🚀 METERED.CA'DA YENİ TURN SERVER PROJESİ OLUŞTURMA

## 📋 ADIM ADIM REHBER

### Adım 1: Metered.ca Dashboard'a Giriş Yap

1. https://dashboard.metered.ca/ adresine git
2. Email ve password ile giriş yap

### Adım 2: Yeni App/Project Oluştur

Metered.ca dashboard'unda şu adımları takip et:

#### Seçenek 1: "Create New App" Butonu

1. Dashboard'un ana sayfasında **"Create New App"** veya **"New App"** butonunu bul
2. Butona tıkla

#### Seçenek 2: "+" veya "Add" Butonu

1. Dashboard'un üst kısmında **"+"** veya **"Add"** butonunu bul
2. **"New App"** veya **"Create App"** seçeneğini seç

#### Seçenek 3: "Apps" Menüsü

1. Sol menüden **"Apps"** veya **"Applications"** sekmesine git
2. **"Create New App"** veya **"New App"** butonuna tıkla

### Adım 3: App Bilgilerini Doldur

Yeni app oluştururken şu bilgileri doldur:

- **App Name:** (Örn: "CraveX TURN Server" veya istediğin isim)
- **Description:** (Opsiyonel - "WebRTC TURN Server for CraveX")
- **Type:** **"WebRTC"** veya **"TURN Server"** seç

### Adım 4: TURN Server Ayarları

App oluşturulduktan sonra şu bilgileri göreceksin:

#### TURN Server URL'leri:
```
turn:relay.metered.ca:80
turn:relay.metered.ca:443
turn:relay.metered.ca:80?transport=tcp
turn:relay.metered.ca:443?transport=tcp
```

#### Credentials:
- **Username:** (Metered.ca tarafından otomatik oluşturulur)
- **Password/Secret:** (Metered.ca tarafından otomatik oluşturulur)

**ÖNEMLİ:** Bu credentials'ları not al! (config.json'da kullanacağız)

### Adım 5: Credentials'ları Bul

App oluşturulduktan sonra credentials'ları bulmak için:

1. **App'in detay sayfasına** git
2. **"Credentials"** veya **"API Keys"** sekmesine git
3. **"TURN Server Credentials"** bölümünü bul

Veya:

1. **"Settings"** sekmesine git
2. **"TURN Configuration"** veya **"WebRTC Settings"** bölümünü bul
3. Username ve Password'u gör

---

## 🔍 EĞER "CREATE NEW APP" BUTONUNU BULAMAZSAN

### Alternatif Yöntemler:

#### 1. Dashboard'un Ana Sayfasına Bak
- Ana sayfada genellikle **"Get Started"** veya **"Create Your First App"** butonu olur
- Bu butona tıkla

#### 2. URL'yi Kontrol Et
- Eğer zaten bir app varsa, URL şöyle olabilir:
  - `https://dashboard.metered.ca/dashboard/app/690b61526dbcb23e770e7be0`
- Yeni app oluşturmak için:
  - `https://dashboard.metered.ca/dashboard/apps/new` veya
  - `https://dashboard.metered.ca/dashboard/new-app` gibi bir URL'ye git

#### 3. Sol Menüden Kontrol Et
- Sol menüde **"Apps"**, **"Projects"**, **"Services"** gibi bir sekme olabilir
- Bu sekmeye git ve **"Create New"** butonunu bul

---

## 📝 SONRAKI ADIMLAR

App oluşturulduktan ve credentials'ları aldıktan sonra:

1. **Username:** (Metered.ca'dan aldığın)
2. **Password/Secret:** (Metered.ca'dan aldığın)

Bu bilgileri bana paylaş, sonra `config.json`'ı güncelleyeceğim!

---

## ✅ HAZIR OLDUĞUNDA

Metered.ca'da yeni app oluşturduktan ve credentials'ları aldıktan sonra:

1. **Username:** (Metered.ca'dan aldığın)
2. **Password/Secret:** (Metered.ca'dan aldığın)

Bu bilgileri paylaş, devam edelim!

