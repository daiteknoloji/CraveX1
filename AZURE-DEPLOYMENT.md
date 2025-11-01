# 🚀 Azure Deployment Kılavuzu - Cravex v5

Bu kılavuz Cravex v5'i Azure'a nasıl deploy edeceğinizi adım adım anlatır.

## 📋 Gereksinimler

### Hesaplar
- ✅ **Azure Hesabı** - [Ücretsiz Hesap Aç](https://azure.microsoft.com/free/)
  - 12 ay ücretsiz servisler
  - $200 kredi (30 gün)
- ✅ **Supabase Hesabı** - [Ücretsiz Kayıt](https://supabase.com)
  - PostgreSQL database (500MB ücretsiz)
  - ✅ HAZIR (db.tsmewoznjeixsojqqlud.supabase.co)

### Yazılımlar
- Azure CLI - [İndir](https://aka.ms/installazurecli)
- Git
- Node.js 20+

---

## 🎯 Deployment Adımları

### 1️⃣ Azure CLI Kurulumu ve Giriş

```powershell
# Azure CLI kurulumunu kontrol et
az --version

# Giriş yap
az login

# Hesabını kontrol et
az account show

# Subscription listesi
az account list --output table
```

### 2️⃣ Backend Deployment (Matrix Synapse)

#### Otomatik Deployment (ÖNERİLEN)

```powershell
# PowerShell scripti ile deploy et
.\azure-deploy.ps1
```

#### Manuel Deployment

```powershell
# Resource group oluştur
az group create --name cravex-rg --location westeurope

# Container deploy et
az container create `
  --resource-group cravex-rg `
  --name matrix-synapse `
  --image matrixdotorg/synapse:latest `
  --dns-name-label cravex-matrix `
  --ports 8008 8448 `
  --cpu 2 `
  --memory 4 `
  --environment-variables `
    SYNAPSE_SERVER_NAME=cravex-matrix.westeurope.azurecontainer.io `
    SYNAPSE_REPORT_STATS=no `
    POSTGRES_DB=postgres `
    POSTGRES_USER=postgres `
    POSTGRES_HOST=db.tsmewoznjeixsojqqlud.supabase.co `
    POSTGRES_PORT=5432 `
  --secure-environment-variables `
    POSTGRES_PASSWORD=1A6qjJG41TMjee6z

# Durum kontrolü
az container show `
  --resource-group cravex-rg `
  --name matrix-synapse `
  --query "{FQDN:ipAddress.fqdn,Status:instanceView.state}" `
  --output table

# Log'ları görüntüle
az container logs --resource-group cravex-rg --name matrix-synapse
```

### 3️⃣ Admin Panel Deployment (Static Web Apps)

#### A) Azure Portal'dan

1. **Azure Portal'a Git**: https://portal.azure.com
2. **Static Web Apps** ara → **Create**
3. **Ayarlar:**
   - **Resource Group:** `cravex-rg`
   - **Name:** `cravex-admin-panel`
   - **Region:** `West Europe`
   - **Deployment source:** `GitHub`
   - **GitHub Account:** Giriş yap
   - **Organization:** `daiteknoloji`
   - **Repository:** `Cravexv5`
   - **Branch:** `main`
   
4. **Build Details:**
   - **Build Presets:** `Custom`
   - **App location:** `/www/admin/dist`
   - **Api location:** _(boş bırak)_
   - **Output location:** _(boş bırak)_

5. **Review + Create** → **Create**

6. GitHub'a otomatik workflow dosyası eklenecek

#### B) GitHub Actions ile Otomatik

1. Azure Static Web Apps API Token'ı al:
```powershell
az staticwebapp secrets list `
  --name cravex-admin-panel `
  --resource-group cravex-rg
```

2. GitHub Secret'a ekle:
   - GitHub Repo → Settings → Secrets → New repository secret
   - Name: `AZURE_STATIC_WEB_APPS_API_TOKEN`
   - Value: Token'ı yapıştır

3. Push yap:
```powershell
git add .
git commit -m "Azure deployment setup"
git push origin main
```

### 4️⃣ Admin Kullanıcısı Oluştur

```powershell
# Container'a bağlan
az container exec `
  --resource-group cravex-rg `
  --name matrix-synapse `
  --exec-command "/bin/bash"

# Container içinde:
register_new_matrix_user -c /data/homeserver.yaml http://localhost:8008

# Bilgileri gir:
# Username: admin
# Password: Admin@2024!Guclu
# Make admin: yes
```

---

## 🌐 Erişim URL'leri

Deployment sonrası:

| Servis | URL | Açıklama |
|--------|-----|----------|
| **Matrix Synapse** | `http://cravex-matrix.westeurope.azurecontainer.io:8008` | Backend API |
| **Admin Panel** | Azure Portal'dan kontrol et | Static Web App URL |
| **PostgreSQL** | `db.tsmewoznjeixsojqqlud.supabase.co:5432` | Supabase Database |

---

## 🔧 Yapılandırma Dosyaları

### Element Web Config

`www/admin/public/config.json` dosyasını güncelle:

```json
{
  "default_server_config": {
    "m.homeserver": {
      "base_url": "http://cravex-matrix.westeurope.azurecontainer.io:8008",
      "server_name": "cravex-matrix.westeurope.azurecontainer.io"
    }
  }
}
```

---

## 📊 Yönetim Komutları

### Container Durumu

```powershell
# Durum görüntüle
az container show `
  --resource-group cravex-rg `
  --name matrix-synapse `
  --output table

# Log'ları görüntüle
az container logs `
  --resource-group cravex-rg `
  --name matrix-synapse `
  --follow

# Yeniden başlat
az container restart `
  --resource-group cravex-rg `
  --name matrix-synapse
```

### Database Bağlantısı

```powershell
# PostgreSQL'e bağlan (psql gerekli)
psql "postgresql://postgres:1A6qjJG41TMjee6z@db.tsmewoznjeixsojqqlud.supabase.co:5432/postgres"

# Veya Supabase Dashboard:
# https://supabase.com/dashboard
```

---

## 💰 Maliyet Tahmini

### Ücretsiz Tier (12 ay)
- ✅ Static Web Apps: **ÜCRETSİZ**
- ✅ Supabase PostgreSQL: **ÜCRETSİZ** (500MB)
- ⚠️ Container Instances: **~$30-40/ay** (2 CPU, 4GB RAM)

### Toplam: ~$30-40/ay

### Maliyet Azaltma
- Container'ı sadece gerektiğinde çalıştır
- Daha küçük instance kullan (1 CPU, 2GB = ~$15/ay)

---

## 🗑️ Silme

```powershell
# Tüm kaynakları sil
az group delete --name cravex-rg --yes --no-wait

# Sadece container'ı sil
az container delete `
  --resource-group cravex-rg `
  --name matrix-synapse `
  --yes
```

---

## 🔒 Güvenlik Notları

### ⚠️ ÖNEMLİ - Production Öncesi

1. **HTTPS Ekle** - Azure Application Gateway veya CloudFlare
2. **Şifreleri Değiştir** - Güçlü random şifreler
3. **Firewall Kuralları** - Sadece gerekli portları aç
4. **Azure Key Vault** - Şifreleri güvenli sakla
5. **Backup Yapılandır** - Supabase otomatik backup açık mı?

### Önerilen Güncellemeler

```powershell
# Environment variables'ı Azure Key Vault'tan çek
# Örnek değil, production'da yapılmalı
```

---

## 🆘 Sorun Giderme

### Container başlamıyor

```powershell
# Log'ları kontrol et
az container logs --resource-group cravex-rg --name matrix-synapse --tail 100

# Container durumunu kontrol et
az container show `
  --resource-group cravex-rg `
  --name matrix-synapse `
  --query "instanceView.state"
```

### Database bağlantı hatası

```powershell
# PostgreSQL bağlantısını test et
Test-NetConnection -ComputerName db.tsmewoznjeixsojqqlud.supabase.co -Port 5432

# Supabase Dashboard'dan database durumunu kontrol et
```

### Admin Panel açılmıyor

```powershell
# Static Web App durumunu kontrol et
az staticwebapp show `
  --name cravex-admin-panel `
  --resource-group cravex-rg

# GitHub Actions log'unu kontrol et
# https://github.com/daiteknoloji/Cravexv5/actions
```

---

## 📚 Kaynaklar

- [Azure Container Instances Docs](https://docs.microsoft.com/azure/container-instances/)
- [Azure Static Web Apps Docs](https://docs.microsoft.com/azure/static-web-apps/)
- [Supabase Docs](https://supabase.com/docs)
- [Matrix Synapse Docs](https://matrix-org.github.io/synapse/)

---

## 🎯 Sonraki Adımlar

1. ✅ Backend deploy edildi
2. ✅ Admin Panel deploy edildi
3. ⏳ Domain ayarları (opsiyonel)
4. ⏳ HTTPS/SSL sertifikası
5. ⏳ Email servisi (kayıt için)
6. ⏳ Monitoring/Alerting

---

**Son Güncelleme:** 1 Kasım 2025  
**Deployment Version:** 1.0  
**Destek:** GitHub Issues

