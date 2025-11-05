# 🚀 NETLIFY CLI MANUEL DEPLOY REHBERİ

**Platform:** Windows PowerShell  
**Amaç:** Netlify CLI ile manuel deploy başlatmak

---

## 📋 GEREKSİNİMLER

1. **Netlify CLI kurulu olmalı:**
   ```powershell
   npm install -g netlify-cli
   ```

2. **Netlify'a giriş yapılmış olmalı:**
   ```powershell
   netlify login
   ```

---

## 🔧 ADIM ADIM DEPLOY

### ADIM 1: Proje Dizinine Git

```powershell
cd "C:\Users\Can Cakir\Desktop\www-backup"
```

### ADIM 2: Netlify Durumunu Kontrol Et

```powershell
netlify status
```

**Çıktı:**
- Current project: `cozy-dragon-54547b` veya `crvx2`
- Admin URL: `https://app.netlify.com/projects/...`
- Project URL: `https://...netlify.app`

### ADIM 3: Manuel Deploy Başlat

**Seçenek 1: Build ile Birlikte Deploy (ÖNERİLEN)**
```powershell
netlify deploy --prod --build
```

**Seçenek 2: Önce Build, Sonra Deploy**
```powershell
# Build yap
cd www/element-web
yarn install
yarn build
cd ../..

# Deploy et
netlify deploy --prod --dir=www/element-web/webapp
```

**Seçenek 3: Sadece Deploy (Build zaten yapılmışsa)**
```powershell
netlify deploy --prod --dir=www/element-web/webapp
```

---

## 📝 TAM KOMUT SETİ (Kopyala-Yapıştır)

```powershell
# Proje dizinine git
cd "C:\Users\Can Cakir\Desktop\www-backup"

# Netlify durumunu kontrol et
netlify status

# Manuel deploy başlat (build ile birlikte)
netlify deploy --prod --build
```

---

## 🔄 PROJE DEĞİŞTİRME

**cozy-dragon-54547b için:**
```powershell
netlify unlink
netlify link --name cozy-dragon-54547b
netlify deploy --prod --build
```

**crvx2 için:**
```powershell
netlify unlink
netlify link --name crvx2
netlify deploy --prod --build
```

---

## 🔍 DEPLOY DURUMU KONTROL

**Deploy loglarını görüntüle:**
```powershell
netlify open:admin
```

**Son deploy durumunu kontrol:**
```powershell
netlify status
```

---

## ⚠️ HATA ÇÖZÜMLERİ

### Sorun 1: "Not logged in"
```powershell
netlify login
```

### Sorun 2: "Project not linked"
```powershell
netlify link --name cozy-dragon-54547b
```

### Sorun 3: "Build failed"
- Build loglarını kontrol et: `netlify open:admin`
- Cache temizle ve tekrar dene

---

## 🔗 NETLIFY DASHBOARD LİNKLERİ

- **cozy-dragon-54547b:** https://app.netlify.com/projects/cozy-dragon-54547b
- **crvx2:** https://app.netlify.com/projects/crvx2

---

## 💡 İPUÇLARI

1. **İlk Deploy:**
   - `netlify login` → `netlify link` → `netlify deploy --prod --build`

2. **Sonraki Deploy'lar:**
   - Sadece `netlify deploy --prod --build`

3. **Cache Temizleme:**
   - Netlify Dashboard'dan "Clear cache and retry deploy"

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** ✅ PowerShell komutları hazır

