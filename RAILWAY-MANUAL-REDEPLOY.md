# Railway Manual Redeploy Guide

## Railway Cache Sorunu - Manuel Redeploy

### Problem:
Railway cache kullanıyor ve servisler otomatik redeploy olmuyor.

### Çözüm:

#### Yöntem 1: Railway Dashboard (Önerilen)

1. **Railway Dashboard'a git:**
   ```
   https://railway.app/dashboard
   ```

2. **Her servis için:**

   **Synapse (CraveX1) Servisi:**
   - Servisi bul ve tıkla
   - "Deployments" sekmesine git
   - En son deployment'ın yanındaki "..." menüsüne tıkla
   - "Redeploy" seçeneğini seç
   - **"Clear build cache"** seçeneğini işaretle ✅
   - "Deploy" butonuna tıkla

   **Admin Panel Servisi:**
   - Aynı işlemi tekrarla

#### Yöntem 2: Railway CLI

```bash
# Railway CLI yüklüyse:
railway login
railway link  # Projeyi seç
railway redeploy --clear-cache
```

#### Yöntem 3: Force Push (Son Çare)

Eğer Railway hala eski commit'i kullanıyorsa:

```bash
# Önce remote'taki değişiklikleri çek
git fetch cravex1
git merge cravex1/main

# Sonra force push (DİKKAT: Bu remote'taki değişiklikleri siler!)
git push cravex1 main --force
```

### Kontrol:

1. Railway loglarını kontrol et
2. Deployment'ın "Building" durumuna geçtiğini gör
3. Build cache'in temizlendiğini gör (ilk build adımları uzun sürebilir)

### Notlar:

- Railway cache'i temizlemek için "Clear build cache" seçeneğini kullan
- İlk build uzun sürebilir (cache olmadan)
- Deploy sonrası logları kontrol et: ICE debug logları görünmeli

