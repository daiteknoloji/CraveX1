# ⚡ Quick Start - Railway + Netlify Deployment

**5 dakikada canlıya alın!**

---

## 🎯 ÖNCELİKLE

### 1. Hesapları Oluşturun (2 dakika)
- ✅ [Netlify](https://netlify.com) - Email ile kayıt
- ✅ [Railway](https://railway.app) - GitHub ile kayıt

### 2. Araçları Kurun (1 dakika)
```powershell
npm install -g netlify-cli
```

---

## 🚀 DEPLOYMENT (2 dakika)

### Otomatik Script Kullan

```powershell
# Tüm klasöre git
cd "C:\Users\Can Cakir\Desktop\www-backup"

# Deploy scriptini çalıştır
.\BUILD-AND-DEPLOY.ps1
```

Script otomatik olarak:
1. ✅ Element Web'i build eder
2. ✅ Netlify'a deploy eder
3. ✅ Synapse Admin'i build eder
4. ✅ Netlify'a deploy eder
5. ℹ️ Railway adımlarını gösterir

---

## 📋 RAILWAY MANUEL ADIMLAR (2 dakika)

### 1. PostgreSQL Ekle
```
Railway Dashboard → New → Database → PostgreSQL
```

### 2. Synapse Ekle
```
Railway Dashboard → New → GitHub Repo → www-backup
Settings → Generate Domain
Variables → RAILWAY-ENV-TEMPLATE.txt'den kopyala
```

### 3. Admin Panel Ekle
```
Railway Dashboard → New → GitHub Repo → www-backup (aynı repo)
Settings → Custom Start Command: python -u admin-panel-server.py
Variables → PostgreSQL variables'ları paylaş
Settings → Generate Domain
```

---

## ✅ BITTI!

### URLs:
- 🌐 **Element Web**: Netlify'den aldığınız URL
- 🌐 **Synapse Admin**: Netlify'den aldığınız URL  
- 🌐 **Admin Panel**: Railway'den aldığınız URL
- 🌐 **Synapse API**: Railway'den aldığınız URL

### Son Güncelleme:
1. Element Web `config.json` → Railway Synapse URL
2. Netlify'a yeniden deploy: `netlify deploy --prod --dir=webapp`

---

## 🎉 Hazır!

Detaylı bilgi için: `RAILWAY-NETLIFY-DEPLOYMENT-GUIDE.md`

