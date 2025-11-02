# 🚀 Railway + Netlify Deployment Rehberi

Cravex Chat sistemini Railway + Netlify'da canlıya almak için **adım adım** rehber.

---

## 📋 Genel Bakış

### Deployment Mimarisi:

```
┌─────────────────────────────────────────────────────────┐
│                    NETLIFY (Frontend)                    │
├──────────────────────────┬──────────────────────────────┤
│  Element Web             │  Synapse Admin               │
│  https://element.app     │  https://admin.app          │
└──────────────────────────┴──────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────┐
│                  RAILWAY (Backend)                       │
├──────────────┬─────────────────┬────────────────────────┤
│ PostgreSQL   │ Matrix Synapse  │ Admin Panel            │
│ (Native)     │ (Port 8008)     │ (Port 9000)           │
└──────────────┴─────────────────┴────────────────────────┘
```

### Servisler:
- **Netlify**: Element Web + Synapse Admin (Static files)
- **Railway**: PostgreSQL + Matrix Synapse + Admin Panel (Backend)

---

## 📦 Ön Gereksinimler

### Hesaplar:
1. **Netlify**: https://netlify.com (ücretsiz)
2. **Railway**: https://railway.app (ücretsiz $5 kredi)
3. **GitHub** (opsiyonel, ama önerilen)

### Yazılımlar:
```powershell
# Node.js 20+
node --version

# Yarn
npm install -g yarn

# Netlify CLI
npm install -g netlify-cli

# Railway CLI (opsiyonel)
npm install -g @railway/cli
```

---

## 🎯 DEPLOYMENT ADIMLARI

### BÖLÜM 1: NETLIFY DEPLOYMENT (Frontend)

#### 1.1 Element Web Deploy

```powershell
# 1. Element Web dizinine git
cd "C:\Users\Can Cakir\Desktop\www-backup\www\element-web"

# 2. Build et
yarn install
yarn build

# 3. Netlify'a login (ilk kez)
netlify login
# Tarayıcı açılır, email ile giriş yap

# 4. Deploy et
netlify deploy --prod --dir=webapp

# 5. Çıkan URL'i not al!
# Örnek: https://element-cravex.netlify.app
```

**✅ Element Web Netlify'da!**

#### 1.2 Synapse Admin Deploy

```powershell
# 1. Synapse Admin dizinine git
cd "C:\Users\Can Cakir\Desktop\www-backup\www\admin"

# 2. Build et
yarn install
yarn build

# 3. Deploy et
netlify deploy --prod --dir=dist

# 4. Çıkan URL'i not al!
# Örnek: https://synapse-admin-cravex.netlify.app
```

**✅ Synapse Admin Netlify'da!**

---

### BÖLÜM 2: RAILWAY DEPLOYMENT (Backend)

#### 2.1 Railway Hesabı Oluştur

1. https://railway.app → **Sign up** (GitHub ile önerilen)
2. **New Project** → **Deploy from GitHub**
3. Repo'nuzu seç veya **Empty Project** oluştur

#### 2.2 PostgreSQL Ekle

1. Railway Dashboard → Projenizi aç
2. **New** → **Database** → **PostgreSQL**
3. ✅ Otomatik environment variables oluştu!

**Not:** Değişkenler otomatik paylaşılır:
- `PGHOST`
- `PGPORT`
- `PGUSER`
- `PGPASSWORD`
- `PGDATABASE`
- `DATABASE_URL`

#### 2.3 Matrix Synapse Servisi Ekle

##### Yöntem A: GitHub Repo ile (Önerilen)

1. Railway Dashboard → **New** → **GitHub Repo**
2. Repo'nuzu seç: `www-backup`
3. **Add variables** tıkla
4. Aşağıdaki variables'ları ekle:

```bash
# PostgreSQL (Reference from Postgres service)
POSTGRES_HOST=${{Postgres.PGHOST}}
POSTGRES_PORT=${{Postgres.PGPORT}}
POSTGRES_USER=${{Postgres.PGUSER}}
POSTGRES_PASSWORD=${{Postgres.PGPASSWORD}}
POSTGRES_DB=${{Postgres.PGDATABASE}}

# Synapse Config
SYNAPSE_SERVER_NAME=${{RAILWAY_PUBLIC_DOMAIN}}
WEB_CLIENT_LOCATION=https://element-cravex.netlify.app

# Secrets (değiştirin!)
REGISTRATION_SHARED_SECRET=SuperGizliAnahtar123456!
MACAROON_SECRET_KEY=MacaroonSuperGizli987654!
FORM_SECRET=FormSuperGizli456789!
```

5. **Settings** → **Generate Domain**
6. Domain'i not al: `https://synapse-production-xxxx.up.railway.app`

##### Yöntem B: Dockerfile ile Manuel

```bash
# Railway CLI ile
railway login
railway init
railway up
```

**✅ Matrix Synapse Railway'de!**

#### 2.4 Admin Panel Servisi Ekle

1. Aynı projede **New** → **GitHub Repo** (aynı repo)
2. **Settings** → **Custom Start Command**:
   ```
   python -u admin-panel-server.py
   ```
3. **Variables** → PostgreSQL değişkenlerini paylaş:
   ```bash
   PGHOST=${{Postgres.PGHOST}}
   PGPORT=${{Postgres.PGPORT}}
   PGUSER=${{Postgres.PGUSER}}
   PGPASSWORD=${{Postgres.PGPASSWORD}}
   PGDATABASE=${{Postgres.PGDATABASE}}
   PORT=9000
   ```
4. **Settings** → **Generate Domain**
5. Domain'i not al: `https://admin-production-xxxx.up.railway.app`

**✅ Admin Panel Railway'de!**

---

### BÖLÜM 3: CONFIG GÜNCELLEMELERI

#### 3.1 Element Web Config Güncelle

Railway'den aldığınız Synapse domain'i ile güncelleyin:

```powershell
cd "C:\Users\Can Cakir\Desktop\www-backup\www\element-web"
notepad config.json
```

Değiştirin:
```json
{
    "default_server_config": {
        "m.homeserver": {
            "base_url": "https://synapse-production-xxxx.up.railway.app",
            "server_name": "synapse-production-xxxx.up.railway.app"
        }
    },
    "room_directory": {
        "servers": ["synapse-production-xxxx.up.railway.app"]
    }
}
```

Yeniden deploy:
```powershell
yarn build
netlify deploy --prod --dir=webapp
```

#### 3.2 Synapse Homeserver Config Güncelle

Railway'de Synapse service → **Variables** → Güncelle:

```bash
WEB_CLIENT_LOCATION=https://element-cravex.netlify.app
```

Railway otomatik restart eder.

---

## ✅ TEST

### 1. Matrix Synapse Test

Tarayıcıda aç:
```
https://synapse-production-xxxx.up.railway.app/_matrix/client/versions
```

Başarılı ise:
```json
{
  "versions": ["r0.0.1", "r0.1.0", ...]
}
```

### 2. Element Web Test

1. https://element-cravex.netlify.app
2. **Create Account** tıkla
3. Kullanıcı adı: `test`
4. Şifre: `Test123!`
5. Kayıt olmalı ✅

### 3. Admin Panel Test

1. https://admin-production-xxxx.up.railway.app
2. Login: `admin` / `admin123`
3. Mesajları görebilmeli ✅

### 4. Synapse Admin Test

1. https://synapse-admin-cravex.netlify.app
2. Homeserver: `https://synapse-production-xxxx.up.railway.app`
3. Username: `admin`
4. Password: (oluşturduğunuz admin şifresi)

---

## 🎉 BAŞARILI!

Artık 3 bacak da canlıda:

| Servis | URL | Açıklama |
|--------|-----|----------|
| **Element Web** | https://element-cravex.netlify.app | Chat arayüzü |
| **Synapse Admin** | https://synapse-admin-cravex.netlify.app | User management |
| **Admin Panel** | https://admin-production-xxxx.up.railway.app | Mesaj okuma |
| **Matrix Synapse** | https://synapse-production-xxxx.up.railway.app | Backend API |

---

## 💰 Maliyet Tahmini

### Netlify (Ücretsiz):
- ✅ 100 GB bandwidth/ay
- ✅ Sınırsız site
- ✅ Otomatik HTTPS

### Railway (Ücretli):
- **PostgreSQL**: ~$5/ay
- **Matrix Synapse**: ~$5-10/ay
- **Admin Panel**: ~$2-3/ay
- **TOPLAM**: ~$12-18/ay

**💡 TİP**: İlk ayı ücretsiz $5 kredi ile test edin!

---

## 🔧 Sorun Giderme

### Synapse başlamıyor

```bash
# Railway logs kontrol et
railway logs --service synapse

# Yaygın hatalar:
# 1. PostgreSQL bağlantı hatası → Env vars kontrol et
# 2. Port hatası → EXPOSE 8008 kontrol et
```

### Element Web bağlanamıyor

1. `config.json`'da Synapse URL doğru mu?
2. CORS ayarları kontrol et
3. Synapse `web_client_location` doğru mu?

### Admin Panel database'e bağlanamıyor

1. Railway'de PostgreSQL env vars paylaşıldı mı?
2. `PGHOST`, `PGPASSWORD` vs. doğru mu?

---

## 📚 Ek Kaynaklar

- [Railway Docs](https://docs.railway.app/)
- [Netlify Docs](https://docs.netlify.com/)
- [Matrix Synapse Docs](https://element-hq.github.io/synapse/latest/)

---

## 🆘 Yardım

Sorun yaşarsanız:

1. Railway logs kontrol edin
2. Netlify deploy logs kontrol edin
3. Browser console hataları bakın
4. Environment variables doğru mu kontrol edin

---

**Son Güncelleme:** 2 Kasım 2025  
**Versiyon:** 1.0  
**Platform:** Railway + Netlify

**Başarılar! 🚀**

