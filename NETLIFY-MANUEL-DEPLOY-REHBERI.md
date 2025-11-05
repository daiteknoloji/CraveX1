# 🚀 NETLIFY MANUEL DEPLOY REHBERİ

**Durum:** GitHub push yapıldı ama Netlify otomatik deploy tetiklemedi  
**Çözüm:** Netlify Dashboard'dan manuel deploy tetikle

---

## 📋 NETLIFY DASHBOARD'DAN MANUEL DEPLOY

### Yöntem 1: Trigger Deploy Butonu (En Kolay)

1. **Netlify Dashboard'a Git:**
   - https://app.netlify.com/
   - CraveX1 projesini seç

2. **Deploys Sekmesine Git:**
   - Sol menüden **"Deploys"** sekmesine tıkla

3. **Trigger Deploy:**
   - Sağ üstte **"Trigger deploy"** butonuna tıkla
   - **"Deploy site"** seçeneğini seç
   - Netlify son commit'i deploy edecek

### Yöntem 2: Latest Deploy'i Redeploy Et

1. **Deploys Sekmesine Git**
2. **En son deploy'i bul**
3. **"..." (üç nokta)** menüsüne tıkla
4. **"Trigger deploy"** seçeneğini seç

---

## 🔍 GITHUB ENTEGRASYONU KONTROLÜ

### GitHub Repo Bağlantısını Kontrol Et

1. **Netlify Dashboard:**
   - **Site settings** → **Build & deploy** → **Continuous Deployment**

2. **Kontrol Et:**
   - ✅ GitHub repo bağlı mı?
   - ✅ Branch: `main` olarak ayarlı mı?
   - ✅ Build command doğru mu? (`chmod +x .netlify-build.sh && ./.netlify-build.sh`)
   - ✅ Publish directory: `www/element-web/webapp` mı?

3. **Eğer Repo Bağlı Değilse:**
   - **"Link to Git provider"** butonuna tıkla
   - GitHub'ı seç ve authorize et
   - Repo'yu seç: `daiteknoloji/CraveX1`
   - Ayarları yapılandır

---

## 🔄 GITHUB WEBHOOK KONTROLÜ

### GitHub'da Webhook Kontrolü

1. **GitHub Repo'ya Git:**
   - https://github.com/daiteknoloji/CraveX1

2. **Settings → Webhooks:**
   - Repo'da **Settings** → **Webhooks** sekmesine git
   - Netlify webhook'u var mı kontrol et
   - URL: `https://api.netlify.com/build_hooks/...`
   - Events: `push` seçili olmalı

3. **Eğer Webhook Yoksa:**
   - Netlify'da **Site settings** → **Build & deploy** → **Build hooks**
   - **"Add build hook"** butonuna tıkla
   - Hook'u GitHub webhook'larına ekle

---

## 🛠️ NETLIFY CLI İLE MANUEL DEPLOY

### Netlify CLI Kurulumu

```bash
npm install -g netlify-cli
```

### Netlify'da Login Ol

```bash
netlify login
```

### Deploy Et

```bash
# Proje dizinine git
cd www/element-web

# Build yap
yarn install
yarn build

# Deploy et
netlify deploy --prod --dir=webapp
```

---

## 📝 NETLIFY BUILD HOOK İLE DEPLOY

### Build Hook Oluştur

1. **Netlify Dashboard:**
   - **Site settings** → **Build & deploy** → **Build hooks**
   - **"Add build hook"** butonuna tıkla
   - İsim ver: `manual-deploy`
   - Branch: `main`

2. **Build Hook URL'ini Kopyala:**
   ```
   https://api.netlify.com/build_hooks/xxxxxxxxxxxxxxxx
   ```

3. **cURL ile Deploy Tetikle:**
   ```bash
   curl -X POST -d {} https://api.netlify.com/build_hooks/xxxxxxxxxxxxxxxx
   ```

---

## ✅ KONTROL LİSTESİ

- [ ] Netlify Dashboard'a giriş yapıldı mı?
- [ ] GitHub repo bağlı mı?
- [ ] Build command doğru mu?
- [ ] Publish directory doğru mu?
- [ ] Latest commit'te deploy var mı?
- [ ] Manuel deploy tetiklendi mi?

---

## 🔗 NETLIFY DASHBOARD LİNKLERİ

- **Netlify Dashboard:** https://app.netlify.com/
- **Site Settings:** https://app.netlify.com/sites/[SITE_NAME]/settings
- **Deploys:** https://app.netlify.com/sites/[SITE_NAME]/deploys
- **Build Logs:** https://app.netlify.com/sites/[SITE_NAME]/deploys/[DEPLOY_ID]

---

## 💡 İPUÇLARI

1. **Deploy Durumu:**
   - Netlify Dashboard'da deploy durumunu kontrol et
   - Build loglarını incele
   - Hata varsa logları paylaş

2. **Otomatik Deploy:**
   - GitHub'da push yaptıktan sonra 1-2 dakika bekle
   - Netlify dashboard'da deploy otomatik başlamalı
   - Eğer başlamazsa manuel tetikle

3. **Build Süresi:**
   - İlk build: ~3-5 dakika
   - Sonraki build'ler: ~2-3 dakika (cache sayesinde)

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** ✅ Netlify manuel deploy rehberi hazırlandı

