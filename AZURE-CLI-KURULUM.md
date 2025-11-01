# 🔧 Azure CLI Kurulum Kılavuzu - Windows

Detaylı, adım adım Azure CLI kurulum rehberi.

---

## 📋 İçindekiler

1. [Sistem Gereksinimleri](#sistem-gereksinimleri)
2. [İndirme ve Kurulum](#indirme-ve-kurulum)
3. [Kurulum Sonrası Kontrol](#kurulum-sonrası-kontrol)
4. [Azure'a Giriş](#azurea-giriş)
5. [İlk Ayarlar](#ilk-ayarlar)
6. [Sorun Giderme](#sorun-giderme)

---

## 1️⃣ Sistem Gereksinimleri

### Minimum Gereksinimler:
- ✅ **İşletim Sistemi:** Windows 10/11 (64-bit)
- ✅ **RAM:** 4GB (önerilen 8GB+)
- ✅ **Disk Alanı:** 500MB boş alan
- ✅ **İnternet Bağlantısı:** Aktif
- ✅ **Yetki:** Administrator (kurulum için)

### Kontrolü:
```powershell
# Windows sürümünü kontrol et
winver

# PowerShell sürümünü kontrol et
$PSVersionTable.PSVersion

# En az PowerShell 5.1 olmalı
```

---

## 2️⃣ İndirme ve Kurulum

### Yöntem 1: MSI Installer (ÖNERİLEN - En Kolay)

#### Adım 1: İndirme

**A) Tarayıcıdan:**
1. Tarayıcını aç (Chrome, Edge, vb.)
2. Bu linke git: **https://aka.ms/installazurecli**
3. Otomatik indirme başlayacak
4. Dosya adı: `azure-cli-X.XX.X.msi` (örn: azure-cli-2.54.0.msi)

**B) PowerShell ile:**
```powershell
# PowerShell'i Administrator olarak aç
# Start → "PowerShell" yaz → Sağ tık → "Run as administrator"

# İndirme klasörüne git
cd $env:USERPROFILE\Downloads

# Azure CLI'yi indir
Invoke-WebRequest -Uri https://aka.ms/installazurecli -OutFile azure-cli.msi

# İndirme tamamlandı mı kontrol et
ls azure-cli.msi
```

#### Adım 2: Kurulum

**GUI ile (Basit):**
1. İndirilen `azure-cli.msi` dosyasına **çift tıkla**
2. **"User Account Control"** uyarısı çıkacak → **"Yes"** tıkla
3. **Azure CLI Setup** penceresi açılacak:
   - ✅ **"I accept the terms in the License Agreement"** → İşaretle
   - ✅ **"Next"** tıkla
4. **Installation Folder** (varsayılan olarak bırak):
   - `C:\Program Files\Microsoft SDKs\Azure\CLI2\`
   - ✅ **"Next"** tıkla
5. **Ready to install** → **"Install"** tıkla
6. Kurulum başlayacak (2-3 dakika sürer)
7. **"Completed"** yazısını gördükten sonra → **"Finish"** tıkla

**PowerShell ile (Otomatik):**
```powershell
# Administrator PowerShell'de
cd $env:USERPROFILE\Downloads

# Sessiz kurulum (hiçbir pencere açılmaz)
Start-Process msiexec.exe -Wait -ArgumentList '/I azure-cli.msi /quiet'

# Kurulum tamamlandı mesajı
Write-Host "✅ Azure CLI kurulumu tamamlandı!" -ForegroundColor Green
```

#### Adım 3: PowerShell'i Yeniden Başlat

```powershell
# Mevcut PowerShell penceresini KAPAT
exit

# YENİ bir PowerShell penceresi aç
# (PATH güncellemesi için gerekli)
```

---

### Yöntem 2: Winget (Windows 11 / Modern Yöntem)

```powershell
# PowerShell'i Administrator olarak aç
# Winget kurulu mu kontrol et
winget --version

# Azure CLI kur
winget install Microsoft.AzureCLI

# Kurulum tamamlandı
# PowerShell'i yeniden başlat
```

---

### Yöntem 3: Chocolatey (Gelişmiş Kullanıcılar)

```powershell
# PowerShell'i Administrator olarak aç

# Chocolatey kurulu mu kontrol et
choco --version

# Chocolatey yoksa önce onu kur:
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Azure CLI kur
choco install azure-cli -y

# PowerShell'i yeniden başlat
```

---

## 3️⃣ Kurulum Sonrası Kontrol

### Adım 1: Azure CLI'yi Test Et

```powershell
# YENİ bir PowerShell penceresi aç (Administrator değil, normal)

# Versiyon kontrolü
az --version

# Çıktı şöyle olmalı:
# azure-cli                         2.54.0
# core                              2.54.0
# telemetry                          1.1.0
# Dependencies:
# msal                              1.24.0b2
# azure-mgmt-resource               23.1.0b2
# ...
```

**✅ Başarılı:** Versiyon bilgileri göründüyse kurulum TAMAM!

**❌ Hata:** `'az' is not recognized...` hatası alıyorsan:
```powershell
# PATH'e manuel ekle
$env:Path += ";C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin"

# Tekrar dene
az --version

# Kalıcı olarak eklemek için:
[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin", [System.EnvironmentVariableTarget]::Machine)

# Bilgisayarı yeniden başlat
```

### Adım 2: Temel Komutları Dene

```powershell
# Yardım menüsü
az --help

# Kullanılabilir komutlar listesi
az find "container"

# Auto-completion aktif et (opsiyonel)
az config set auto-upgrade.enable=yes
```

---

## 4️⃣ Azure'a Giriş

### Adım 1: Azure Hesabı Kontrolü

**Hesabın var mı?**
- ✅ **VAR:** Direkt login yapabilirsin
- ❌ **YOK:** Önce hesap aç → https://azure.microsoft.com/free/

**Ücretsiz Hesap Açma:**
1. https://azure.microsoft.com/free/ → **"Start free"**
2. Microsoft hesabınla giriş yap (varsa) veya yeni hesap oluştur
3. **Telefon doğrulama** (SMS kodu gelecek)
4. **Kredi kartı bilgisi** (ücret kesilmez, sadece doğrulama)
5. **12 ay ücretsiz** + **$200 kredi** (30 gün)

### Adım 2: Login (Giriş)

```powershell
# PowerShell'de (normal kullanıcı, Administrator değil)
az login

# Ne olacak:
# 1. Varsayılan tarayıcın açılacak
# 2. Microsoft login sayfası gelecek
# 3. Email ve şifreni gir
# 4. "You have signed in" mesajını gördükten sonra tarayıcıyı kapat
# 5. PowerShell'de giriş bilgilerin görünecek
```

**Örnek Çıktı:**
```json
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "xxxx-xxxx-xxxx-xxxx",
    "id": "xxxx-xxxx-xxxx-xxxx",
    "isDefault": true,
    "name": "Azure subscription 1",
    "state": "Enabled",
    "tenantId": "xxxx-xxxx-xxxx-xxxx",
    "user": {
      "name": "sizin@email.com",
      "type": "user"
    }
  }
]
```

### Adım 3: Subscription Kontrolü

```powershell
# Aktif subscription'ı gör
az account show

# Tüm subscription'ları listele
az account list --output table

# Çıktı:
# Name                   CloudName    SubscriptionId                        State    IsDefault
# ---------------------  -----------  ------------------------------------  -------  -----------
# Azure subscription 1   AzureCloud   xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx      Enabled  True

# Başka bir subscription seç (birden fazla varsa)
az account set --subscription "Subscription Adı veya ID"
```

---

## 5️⃣ İlk Ayarlar

### Varsayılan Yapılandırmalar

```powershell
# Varsayılan output format (table daha okunabilir)
az config set core.output=table

# Varsayılan location (bölge)
az config set defaults.location=westeurope

# Varsayılan resource group (opsiyonel)
az config set defaults.group=cravex-rg

# Otomatik upgrade açık olsun
az config set auto-upgrade.enable=yes

# Telemetry kapat (istemiyorsan)
az config set core.collect_telemetry=false

# Yapılandırmaları gör
az config get
```

### Tab Completion Aktif Et (Opsiyonel)

```powershell
# PowerShell için auto-completion
Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    $completion_file = New-TemporaryFile
    $env:ARGCOMPLETE_USE_TEMPFILES = 1
    $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
    $env:COMP_LINE = $wordToComplete
    $env:COMP_POINT = $cursorPosition
    $env:_ARGCOMPLETE = 1
    $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
    $env:_ARGCOMPLETE_IFS = "`n"
    az 2>&1 | Out-Null
    Get-Content $completion_file | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
    Remove-Item $completion_file, Env:\_ARGCOMPLETE, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS
}

# PowerShell profiline kaydet (her açılışta aktif olsun)
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -Type File -Force }
Add-Content $PROFILE -Value @'
Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    $completion_file = New-TemporaryFile
    $env:ARGCOMPLETE_USE_TEMPFILES = 1
    $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
    $env:COMP_LINE = $wordToComplete
    $env:COMP_POINT = $cursorPosition
    $env:_ARGCOMPLETE = 1
    $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
    $env:_ARGCOMPLETE_IFS = "`n"
    az 2>&1 | Out-Null
    Get-Content $completion_file | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
    Remove-Item $completion_file, Env:\_ARGCOMPLETE, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS
}
'@
```

---

## 6️⃣ İlk Komutlarla Test

### Basit Testler

```powershell
# 1. Resource group listesi (boş olabilir, normal)
az group list

# 2. Location (bölge) listesi
az account list-locations --output table

# 3. Kullanılabilir VM boyutları (örnek)
az vm list-sizes --location westeurope --output table

# 4. Fiyatlandırma hesaplama
az consumption usage list --start-date 2025-11-01 --end-date 2025-11-30
```

### İlk Resource Group Oluştur (Test)

```powershell
# Test resource group oluştur
az group create --name test-rg --location westeurope

# Çıktı:
# Location    Name
# ----------  -------
# westeurope  test-rg

# Resource group'u gör
az group show --name test-rg

# Sil (test tamamlandı)
az group delete --name test-rg --yes --no-wait
```

---

## 🆘 Sorun Giderme

### Hata 1: `'az' is not recognized as an internal or external command`

**Sebep:** Azure CLI PATH'e eklenmemiş.

**Çözüm:**
```powershell
# 1. Kurulum dizinini kontrol et
Test-Path "C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd"

# True dönerse kurulum var, PATH problemi
# False dönerse kurulum yok, tekrar yükle

# 2. PATH'e manuel ekle (geçici)
$env:Path += ";C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin"

# 3. Kalıcı olarak ekle (Administrator PowerShell)
[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin", [System.EnvironmentVariableTarget]::Machine)

# 4. PowerShell'i yeniden başlat
exit
```

### Hata 2: `az login` çalışmıyor / Tarayıcı açılmıyor

**Çözüm 1 - Device Code ile Login:**
```powershell
# Tarayıcı açılmadan login
az login --use-device-code

# Çıktı:
# To sign in, use a web browser to open https://microsoft.com/devicelogin
# and enter the code: XXXXXX

# 1. Tarayıcıda https://microsoft.com/devicelogin aç
# 2. Kodu yapıştır
# 3. Microsoft hesabınla giriş yap
```

**Çözüm 2 - Service Principal ile (İleri seviye):**
```powershell
az login --service-principal \
  --username <app-id> \
  --password <password-or-cert> \
  --tenant <tenant-id>
```

### Hata 3: `ERROR: Please run 'az login' to setup account`

**Çözüm:**
```powershell
# Önce logout yap
az logout

# Önbelleği temizle
Remove-Item "$env:USERPROFILE\.azure" -Recurse -Force

# Tekrar login
az login
```

### Hata 4: Subscription bulunamıyor

**Çözüm:**
```powershell
# Subscription'ları listele
az account list --all

# Belirli bir subscription seç
az account set --subscription "SUBSCRIPTION_ID"

# Varsayılan subscription yap
az account set --subscription "Azure subscription 1"
```

### Hata 5: Yavaş çalışıyor

**Çözüm:**
```powershell
# Telemetry'yi kapat
az config set core.collect_telemetry=false

# Cache temizle
az cache purge

# Extension'ları güncelle
az extension update --name all
```

---

## 🔄 Güncelleme

### Manuel Güncelleme

```powershell
# Mevcut versiyon
az --version

# Güncelleme kontrolü
az upgrade

# Yeni versiyon varsa yükler
# PowerShell'i yeniden başlat
```

### Otomatik Güncelleme

```powershell
# Otomatik güncellemeyi aç
az config set auto-upgrade.enable=yes
az config set auto-upgrade.prompt=no
```

---

## 🗑️ Kaldırma (Uninstall)

### Windows Settings'ten

1. **Start** → **Settings** (⚙️)
2. **Apps** → **Apps & features**
3. **"Microsoft Azure CLI"** ara
4. **Uninstall** tıkla

### PowerShell ile

```powershell
# Administrator PowerShell
# MSI ID'yi bul
$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Azure CLI*" }

# Kaldır
$app.Uninstall()

# Alternatif (Chocolatey ile kurduysanız)
choco uninstall azure-cli -y

# Winget ile kurduysanız
winget uninstall Microsoft.AzureCLI
```

---

## 📚 Yararlı Kaynaklar

### Resmi Dökümanlar
- **Azure CLI Docs:** https://docs.microsoft.com/cli/azure/
- **Install Guide:** https://docs.microsoft.com/cli/azure/install-azure-cli-windows
- **Command Reference:** https://docs.microsoft.com/cli/azure/reference-index

### Interaktif Öğrenme
- **Azure CLI Interactive Mode:**
  ```powershell
  az interactive
  ```
- **Microsoft Learn:** https://learn.microsoft.com/training/modules/control-azure-services-with-cli/

### Cheat Sheet
```powershell
# En çok kullanılan komutlar
az login                           # Giriş
az logout                          # Çıkış
az account show                    # Hesap bilgisi
az group list                      # Resource group'lar
az group create                    # Resource group oluştur
az container create                # Container oluştur
az staticwebapp create             # Static web app oluştur
az --help                          # Yardım
az <command> --help                # Komut yardımı
```

---

## ✅ Kurulum Tamamlandı Kontrolü

Hepsini kontrol et:

```powershell
# 1. Versiyon kontrolü
az --version
# ✅ Versiyon numarası görünüyor mu?

# 2. Login durumu
az account show
# ✅ Email adresin görünüyor mu?

# 3. Subscription kontrolü
az account list --output table
# ✅ En az 1 subscription var mı?

# 4. Basit bir komut çalıştır
az group list
# ✅ Hata almadan çalıştı mı? (boş liste normal)
```

**Hepsi ✅ ise HAZIRSIN! Azure deployment'a geçebilirsin!** 🚀

---

**Sonraki Adım:** `.\azure-deploy.ps1` scripti ile deployment yap!

---

**Son Güncelleme:** 1 Kasım 2025  
**Windows Sürümü:** 10/11  
**Azure CLI Sürümü:** 2.54.0+

