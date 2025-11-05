# 🔄 NETLIFY OTOMATİK DEPLOY KURULUMU

**Sorun:** GitHub'a push yapıldı ama Netlify otomatik deploy tetiklenmedi  
**Çözüm:** Netlify'da GitHub entegrasyonunu yapılandır

---

## 📋 NETLIFY'DA GITHUB ENTEGRASYONU KURULUMU

### Adım 1: Netlify Dashboard'a Git

1. **Netlify Dashboard:** https://app.netlify.com/projects/cozy-dragon-54547b
2. **Site settings** → **Build & deploy** → **Continuous Deployment**

### Adım 2: GitHub Repo Bağlantısını Kontrol Et

**Kontrol Et:**
- ✅ GitHub repo bağlı mı?
  - Eğer **"Connect to Git provider"** görüyorsan → Tıkla ve GitHub'ı bağla
  - Eğer repo bağlıysa → Repo adını kontrol et: `daiteknoloji/CraveX1`

### Adım 3: Build Ayarlarını Kontrol Et

**Build Settings:**
- **Branch to deploy:** `main` olmalı
- **Build command:** `chmod +x .netlify-build.sh && ./.netlify-build.sh`
- **Publish directory:** `www/element-web/webapp`

### Adım 4: Deploy Notification Ayarları (Opsiyonel)

**Notifications:**
- **Deploy notifications** → **Email notifications** → Açık olabilir
- Her deploy'ta email alırsın

---

## 🔧 MANUEL OLARAK REPO BAĞLAMA

### Eğer Repo Bağlı Değilse:

1. **Netlify Dashboard:**
   - **Site settings** → **Build & deploy** → **Continuous Deployment**
   - **"Connect to Git provider"** butonuna tıkla

2. **GitHub'ı Seç:**
   - **GitHub** seçeneğini seç
   - GitHub hesabına authorize et

3. **Repo'yu Seç:**
   - **Repository:** `daiteknoloji/CraveX1` seç
   - **Branch:** `main` seç

4. **Build Settings:**
   - **Build command:** `chmod +x .netlify-build.sh && ./.netlify-build.sh`
   - **Publish directory:** `www/element-web/webapp`

5. **"Save"** butonuna tıkla

---

## 🔍 GITHUB WEBHOOK KONTROLÜ

### GitHub'da Webhook Kontrolü

1. **GitHub Repo:**
   - https://github.com/daiteknoloji/CraveX1
   - **Settings** → **Webhooks** sekmesine git

2. **Netlify Webhook'unu Kontrol Et:**
   - Netlify webhook'u var mı?
   - URL: `https://api.netlify.com/build_hooks/...` veya `https://api.netlify.com/hooks/github`
   - Events: `push` seçili olmalı

3. **Eğer Webhook Yoksa:**
   - Netlify otomatik olarak oluşturur
   - Repo'yu bağladığında webhook otomatik eklenir

---

## 🚀 OTOMATİK DEPLOY TEST ETME

### Test Adımları:

1. **Küçük bir değişiklik yap:**
   ```bash
   echo "test" >> deploy-trigger.txt
   git add deploy-trigger.txt
   git commit -m "test: trigger netlify deploy"
   git push
   ```

2. **Netlify Dashboard'u Kontrol Et:**
   - 1-2 dakika içinde deploy başlamalı
   - **Deploys** sekmesinde yeni deploy görmelisin

3. **Deploy Durumunu İzle:**
   - Deploy başladı mı?
   - Build başarılı mı?
   - URL çalışıyor mu?

---

## ✅ KONTROL LİSTESİ

- [ ] Netlify Dashboard'a giriş yapıldı mı?
- [ ] GitHub repo bağlı mı?
- [ ] Branch: `main` olarak ayarlı mı?
- [ ] Build command doğru mu?
- [ ] Publish directory doğru mu?
- [ ] GitHub webhook'u var mı?
- [ ] Test deploy yapıldı mı?

---

## 🔗 NETLIFY DASHBOARD LİNKLERİ

- **Site Overview:** https://app.netlify.com/projects/cozy-dragon-54547b
- **Build & Deploy Settings:** https://app.netlify.com/sites/cozy-dragon-54547b/configuration/deploys
- **Deploys:** https://app.netlify.com/sites/cozy-dragon-54547b/deploys
- **Site Settings:** https://app.netlify.com/sites/cozy-dragon-54547b/configuration/general

---

## 💡 İPUÇLARI

1. **Otomatik Deploy Çalışmıyorsa:**
   - GitHub repo bağlantısını kontrol et
   - Webhook'ları kontrol et
   - Branch ayarlarını kontrol et

2. **Manuel Deploy:**
   - Her zaman Netlify Dashboard'dan manuel deploy tetikleyebilirsin
   - **Deploys** → **"Trigger deploy"** → **"Deploy site"**

3. **Build Hook (Alternatif):**
   - Site settings → Build & deploy → Build hooks
   - Build hook URL'i ile deploy tetikleyebilirsin

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** ✅ Otomatik deploy kurulum rehberi hazırlandı

