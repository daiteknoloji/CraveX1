# 🚀 CRAVEX CHAT - RAILWAY + NETLIFY DEPLOYMENT

**Projenizi 10 dakikada canlıya alın!**

---

## 📦 Hazırlanan Dosyalar

### ✅ Netlify Config Dosyaları:
```
www/element-web/netlify.toml          # Element Web build & deploy ayarları
www/admin/netlify.toml                # Synapse Admin build & deploy ayarları
```

### ✅ Railway Config Dosyaları:
```
railway.json                          # Matrix Synapse servisi config
railway-admin-panel.json              # Admin Panel servisi config
Dockerfile.synapse                    # Synapse Docker image
admin-panel.Dockerfile                # Admin Panel Docker image
synapse-railway-config/               # Synapse config klasörü
```

### ✅ Environment Variables:
```
RAILWAY-ENV-TEMPLATE.txt              # Tüm environment variables şablonu
```

### ✅ Config Şablonları:
```
www/element-web/config.production.template.json
www/admin/public/config.production.template.json
```

### ✅ Deployment Scriptleri:
```
BUILD-AND-DEPLOY.ps1                  # Ana deployment script
UPDATE-CONFIGS.ps1                    # Config güncelleme script
```

### ✅ Rehberler:
```
RAILWAY-NETLIFY-DEPLOYMENT-GUIDE.md   # Detaylı step-by-step rehber
QUICK-START.md                        # Hızlı başlangıç (5 dakika)
```

---

## 🎯 HIZLI BAŞLANGIÇ

### 1. Hesapları Oluştur (2 dk)
- [Netlify](https://netlify.com) - Email ile
- [Railway](https://railway.app) - GitHub ile

### 2. CLI Araçlarını Kur (1 dk)
```powershell
npm install -g netlify-cli
```

### 3. Deploy Script'ini Çalıştır (2 dk)
```powershell
.\BUILD-AND-DEPLOY.ps1
```

### 4. Railway'e Deploy (5 dk)
1. PostgreSQL ekle
2. Synapse servisi ekle
3. Admin Panel servisi ekle
4. Environment variables ayarla

**Detaylı adımlar:** `RAILWAY-NETLIFY-DEPLOYMENT-GUIDE.md`

---

## 📊 MİMARİ

```
┌─────────────────────────────────────────┐
│           NETLIFY (CDN)                 │
│  ┌─────────────┬──────────────────┐    │
│  │ Element Web │ Synapse Admin    │    │
│  │ (Port 8080) │ (Port 5173)      │    │
│  └─────────────┴──────────────────┘    │
└─────────────────┬───────────────────────┘
                  │ HTTPS
                  ▼
┌─────────────────────────────────────────┐
│         RAILWAY (Backend)               │
│  ┌────────┬────────────┬──────────┐    │
│  │ PostgreSQL │ Synapse │ Admin   │    │
│  │           │ (8008)  │ (9000)  │    │
│  └────────┴────────────┴──────────┘    │
└─────────────────────────────────────────┘
```

---

## 💡 KULLANIM

### Otomatik Deployment:
```powershell
# Tüm deployment işlemi
.\BUILD-AND-DEPLOY.ps1

# Sadece build (deploy yok)
.\BUILD-AND-DEPLOY.ps1 -OnlyBuild

# Sadece deploy (build atla)
.\BUILD-AND-DEPLOY.ps1 -SkipBuild
```

### Config Güncelleme:
```powershell
# Railway domain'leri ile config'leri güncelle
.\UPDATE-CONFIGS.ps1 -SynapseDomain "synapse-prod.up.railway.app" -ElementDomain "element.netlify.app"
```

---

## 🌐 SERVISLER

Deployment sonrası erişim URL'leri:

| Servis | Platform | Port | URL |
|--------|----------|------|-----|
| **Element Web** | Netlify | 8080 | https://element-xxx.netlify.app |
| **Synapse Admin** | Netlify | 5173 | https://admin-xxx.netlify.app |
| **Admin Panel** | Railway | 9000 | https://admin-xxx.up.railway.app |
| **Matrix Synapse** | Railway | 8008 | https://synapse-xxx.up.railway.app |

---

## 💰 MALİYET

### Netlify (Ücretsiz):
- ✅ 100 GB bandwidth/ay
- ✅ 300 build dakika/ay
- ✅ Sınırsız site
- ✅ Otomatik HTTPS + CDN

### Railway:
- **Ücretsiz Plan**: $5 kredi/ay (test için yeterli)
- **Hobby Plan**: $5/ay (hobi projeler)
- **Developer Plan**: $20/ay (production için önerilen)

**Tahmini Maliyet:**
- PostgreSQL: ~$5/ay
- Synapse: ~$5-10/ay
- Admin Panel: ~$2-3/ay
- **TOPLAM**: ~$12-18/ay

---

## 🔧 TROUBLESHOOTING

### Build Hatası
```powershell
# Node modules temizle
cd www\element-web
rm -rf node_modules
yarn install
yarn build
```

### Deploy Hatası
```powershell
# Netlify yeniden login
netlify logout
netlify login

# Yeniden deploy
netlify deploy --prod --dir=webapp
```

### Railway Connection Hatası
1. Environment variables kontrol et
2. PostgreSQL servisi çalışıyor mu?
3. Railway logs kontrol et: `railway logs`

---

## 📚 DOSYA AÇIKLAMALARI

### `BUILD-AND-DEPLOY.ps1`
Ana deployment script. Element Web ve Synapse Admin'i build edip Netlify'a deploy eder.

### `UPDATE-CONFIGS.ps1`
Railway domain'lerini kullanarak tüm config dosyalarını otomatik günceller.

### `RAILWAY-ENV-TEMPLATE.txt`
Railway dashboard'da kullanacağınız tüm environment variables.

### `netlify.toml`
Netlify build ayarları, cache policy, redirects.

### `railway.json`
Railway servis config (Dockerfile path, start command, restart policy).

---

## ✅ CHECKLIST

### Başlamadan Önce:
- [ ] Node.js 20+ kurulu
- [ ] Yarn kurulu
- [ ] Netlify CLI kurulu
- [ ] Netlify hesabı oluşturuldu
- [ ] Railway hesabı oluşturuldu

### Deployment Sırası:
- [ ] `BUILD-AND-DEPLOY.ps1` çalıştırıldı
- [ ] Element Web Netlify'da
- [ ] Synapse Admin Netlify'da
- [ ] Railway'de PostgreSQL eklendi
- [ ] Railway'de Synapse eklendi
- [ ] Railway'de Admin Panel eklendi
- [ ] Environment variables ayarlandı
- [ ] Config dosyaları güncellendi
- [ ] Test edildi

---

## 🆘 YARDIM

### Dokümantasyon:
- **Detaylı Rehber**: `RAILWAY-NETLIFY-DEPLOYMENT-GUIDE.md`
- **Hızlı Başlangıç**: `QUICK-START.md`
- **Env Template**: `RAILWAY-ENV-TEMPLATE.txt`

### Loglar:
```powershell
# Railway logs
railway logs

# Netlify logs
netlify logs

# Local build logs
yarn build
```

---

## 📄 LİSANS

Bu proje özel kullanım içindir.

---

**Son Güncelleme:** 2 Kasım 2025  
**Versiyon:** 1.0  
**Platform:** Railway + Netlify  
**Geliştirici:** Cravex Team

**Başarılar! 🚀**

