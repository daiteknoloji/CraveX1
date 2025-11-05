# 🔍 CRAVEX1 PROJE ANALİZ RAPORU

**Analiz Tarihi:** 1 Kasım 2025  
**Proje:** Matrix Synapse Full Stack - Cravex v5  
**Konum:** `C:\Users\Can Cakir\Desktop\www-backup`  
**GitHub:** https://github.com/daiteknoloji/CraveX1

---

## 📋 İÇİNDEKİLER

1. [Proje Genel Bakış](#proje-genel-bakış)
2. [Mimari Yapı](#mimari-yapı)
3. [Teknoloji Stack](#teknoloji-stack)
4. [Bileşenler ve Servisler](#bileşenler-ve-servisler)
5. [Güvenlik Analizi](#güvenlik-analizi)
6. [Özellikler ve İşlevsellik](#özellikler-ve-işlevsellik)
7. [Deployment Stratejisi](#deployment-stratejisi)
8. [Kod Kalitesi ve Yapı](#kod-kalitesi-ve-yapı)
9. [Güçlü Yönler](#güçlü-yönler)
10. [Zayıf Yönler ve İyileştirme Önerileri](#zayıf-yönler-ve-iyileştirme-önerileri)
11. [Risk Analizi](#risk-analizi)
12. [Sonuç ve Öneriler](#sonuç-ve-öneriler)

---

## 🎯 PROJE GENEL BAKIŞ

### Proje Amacı

**CraveX1**, Matrix protokolü üzerine kurulu, şifreleme devre dışı bırakılmış, admin denetimli bir mesajlaşma sistemidir. Sistem, admin kullanıcının tüm mesajları görebilmesi ve yönetebilmesi için tasarlanmıştır.

### Temel Özellikler

- ✅ **Matrix Synapse** backend sunucusu
- ✅ **Element Web** frontend arayüzü
- ✅ **Synapse Admin Panel** yönetim paneli
- ✅ **PostgreSQL** veritabanı
- ✅ **Redis** cache sistemi
- ✅ **Otomatik Admin Ekleme** servisi
- ✅ **Video Call** desteği (Element Call)
- ✅ **Mobil Responsive** tasarım

### Kullanım Senaryosu

Sistem, kurumsal veya organizasyonel mesajlaşma için tasarlanmış, admin'in tüm sohbetleri izleyebildiği ve yönetebildiği bir platformdur.

---

## 🏗️ MİMARİ YAPI

### Sistem Mimarisi

```
┌─────────────────────────────────────────────────────────┐
│                    KULLANICILAR                         │
│  (admin, 1k, 2k, vb. - Web/Mobil Tarayıcılar)          │
└─────────────────────────────────────────────────────────┘
                          ↓ ↑
┌─────────────────────────────────────────────────────────┐
│              FRONTEND KATMANI                           │
│  ┌──────────────────┐    ┌──────────────────┐         │
│  │  ELEMENT WEB     │    │  SYNAPSE ADMIN   │         │
│  │  Port: 8080      │    │  Port: 5173     │         │
│  │  React/TypeScript│    │  React/Vite      │         │
│  │  Mesajlaşma UI   │    │  Yönetim Paneli  │         │
│  └──────────────────┘    └──────────────────┘         │
└─────────────────────────────────────────────────────────┘
                          ↓ ↑
┌─────────────────────────────────────────────────────────┐
│              BACKEND KATMANI                            │
│  ┌──────────────────────────────────────────┐           │
│  │      MATRIX SYNAPSE                      │           │
│  │      Port: 8008                          │           │
│  │      Python/Twisted                      │           │
│  │      REST API + WebSocket                │           │
│  └──────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────┘
                          ↓ ↑
┌─────────────────────────────────────────────────────────┐
│              VERİTABANI KATMANI                         │
│  ┌──────────────┐  ┌──────────────┐                    │
│  │ POSTGRESQL   │  │    REDIS     │                    │
│  │ Port: 5432   │  │  Port: 6379  │                    │
│  │ Veri Deposu  │  │  Önbellek    │                    │
│  └──────────────┘  └──────────────┘                    │
└─────────────────────────────────────────────────────────┘
                          ↓ ↑
┌─────────────────────────────────────────────────────────┐
│              OTOMATIK SERVİSLER                         │
│  ┌──────────────────────────────────────────┐           │
│  │   AUTO-ADD ADMIN SERVİSİ                 │           │
│  │   PowerShell Script                      │           │
│  │   Her 60 saniyede kontrol                │           │
│  └──────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────┘
```

### Deployment Mimarisi

#### Local Development
- **Backend:** Docker Compose (Synapse, PostgreSQL, Redis)
- **Frontend:** Node.js/Yarn dev server (Element Web, Synapse Admin)
- **Platform:** Windows 10/11

#### Production (Railway + Netlify)
- **Backend:** Railway.app (Synapse, PostgreSQL, Redis)
- **Frontend:** Netlify (Element Web static hosting)
- **TURN Server:** Metered.ca (üçüncü parti)
- **Domain:** Railway public domain

---

## 💻 TEKNOLOJI STACK

### Backend
- **Matrix Synapse:** vLatest (Python/Twisted)
- **PostgreSQL:** 15-alpine (Docker)
- **Redis:** 7-alpine (Docker)
- **Docker Compose:** Service orchestration

### Frontend
- **Element Web:** Latest (React, TypeScript, Matrix React SDK)
- **Synapse Admin:** Latest (React, TypeScript, Vite)
- **Build Tool:** Webpack (Element Web), Vite (Synapse Admin)
- **Package Manager:** Yarn

### Infrastructure
- **Containerization:** Docker Desktop
- **Orchestration:** Docker Compose
- **Cloud Platform:** Railway.app (Backend), Netlify (Frontend)
- **TURN Server:** Metered.ca (STUN/TURN)

### Scripting & Automation
- **PowerShell:** 5.1+ (Windows automation scripts)
- **Python:** (Bazı yardımcı scriptler)

---

## 🔧 BİLEŞENLER VE SERVİSLER

### 1. Matrix Synapse (Backend)

**Konum:** `synapse-config/homeserver.yaml`  
**Port:** 8008 (HTTP)  
**Özellikler:**
- ✅ Şifreleme varsayılan olarak kapalı
- ✅ Registration açık (verification yok)
- ✅ Federation desteği
- ✅ PostgreSQL veritabanı bağlantısı
- ✅ Redis cache (Railway'de disabled)
- ✅ Media store (50MB max upload)

**Konfigürasyon Önemli Ayarlar:**
```yaml
server_name: "localhost"
encryption_enabled_by_default_for_room_type: "off"
enable_registration: true
enable_registration_without_verification: true
```

### 2. Element Web (Frontend)

**Konum:** `www/element-web/`  
**Port:** 8080 (Local), Netlify (Production)  
**Teknolojiler:**
- React + TypeScript
- Matrix React SDK
- Webpack bundler
- Custom CSS (mobil responsive)

**Konfigürasyon:** `www/element-web/config.json`
- ✅ Şifreleme zorla kapalı (`force_disable_encryption: true`)
- ✅ TURN server: Metered.ca + Matrix.org
- ✅ Homeserver: Railway domain
- ✅ Default theme: Dark
- ✅ Brand: "CraveX"

**Özellikler:**
- Mobil responsive tasarım
- PWA desteği
- Video call desteği (Element Call)
- Emoji picker
- File upload
- Room creation

### 3. Synapse Admin Panel

**Konum:** `www/admin/`  
**Port:** 5173 (Local)  
**Teknolojiler:**
- React + TypeScript
- Vite dev server
- Admin API entegrasyonu

**Özellikler:**
- Kullanıcı yönetimi (create, delete, deactivate)
- Oda yönetimi (list, delete, join)
- Mesaj görüntüleme (Show Events)
- Kullanıcı import (CSV)
- Room statistics

### 4. PostgreSQL Database

**Konum:** Docker container  
**Port:** 5432  
**Özellikler:**
- Connection pooling (5-10 connections)
- Transaction limit: 10000
- Auto-initialization

**Önemli Tablolar:**
- `users` - Kullanıcı bilgileri
- `rooms` - Oda bilgileri
- `events` - Mesajlar ve event'ler
- `room_memberships` - Kullanıcı-oda ilişkileri
- `access_tokens` - Authentication tokens

### 5. Redis Cache

**Konum:** Docker container  
**Port:** 6379  
**Durum:** Local'de aktif, Railway'de disabled (free tier limit)

### 6. Auto-Add Admin Service

**Konum:** `AUTO-ADD-ADMIN.ps1`  
**Çalışma Şekli:**
- Her 60 saniyede bir yeni odaları kontrol eder
- Public odalara admin'i otomatik ekler
- Private odalar için log yazar
- Backend hazır olana kadar bekler

**Özellikler:**
- Health check (backend kontrolü)
- Token-based authentication
- Matrix Admin API kullanımı
- Error handling ve retry logic

### 7. PowerShell Scripts

**Ana Scriptler:**
- `BASLAT.ps1` - Tüm servisleri başlatır
- `DURDUR.ps1` - Tüm servisleri durdurur
- `DURUM.ps1` - Servis durumunu kontrol eder
- `AUTO-ADD-ADMIN.ps1` - Otomatik admin ekleme
- `get-all-messages.ps1` - Tüm mesajları export eder
- `get-room-messages.ps1` - Belirli odanın mesajlarını alır
- `force-add-admin-to-room.ps1` - Admin'i zorla odaya ekler
- `db-query-messages.ps1` - Database sorgulama

**Toplam Script Sayısı:** 50+ PowerShell script

---

## 🔒 GÜVENLİK ANALİZİ

### ⚠️ KRİTİK GÜVENLİK SORUNLARI

#### 1. Şifreleme Tamamen Devre Dışı
**Risk Seviyesi:** 🔴 YÜKSEK

**Durum:**
- End-to-end encryption (E2EE) tamamen kapalı
- Tüm mesajlar plaintext olarak saklanıyor
- Admin tüm mesajları görebiliyor

**Etki:**
- ✅ Proje amacına uygun (admin monitoring)
- ❌ Production'da güvenlik riski
- ❌ Compliance sorunları (GDPR, vb.)

**Not:** Bu kasıtlı bir tasarım kararıdır, ancak production'da dikkatli kullanılmalıdır.

#### 2. Hardcoded Şifreler
**Risk Seviyesi:** 🔴 YÜKSEK

**Durum:**
- Admin şifresi: `Admin@2024!Guclu` (kod içinde hardcoded)
- PostgreSQL şifresi: `SuperGucluSifre2024!`
- Registration secret: `GizliKayitAnahtari123456789`

**Konumlar:**
- `BASLAT.ps1`
- `AUTO-ADD-ADMIN.ps1`
- `docker-compose.yml`
- `synapse-config/homeserver.yaml`
- `force-add-admin-to-room.ps1`

**Öneri:**
- Environment variables kullanılmalı
- `.env` dosyası git'e eklenmemeli
- Secret management tool kullanılmalı

#### 3. Registration Açık (Verification Yok)
**Risk Seviyesi:** 🟡 ORTA

**Durum:**
```yaml
enable_registration: true
enable_registration_without_verification: true
```

**Etki:**
- Herkes hesap oluşturabilir
- Email verification yok
- Spam riski var

**Öneri:**
- En azından email verification açılmalı
- Rate limiting eklenmeli
- CAPTCHA eklenebilir

#### 4. HTTP Üzerinden Çalışma (Local)
**Risk Seviyesi:** 🟡 ORTA (Local), 🔴 YÜKSEK (Production)

**Durum:**
- Local: HTTP (localhost)
- Production: Railway HTTPS (otomatik)

**Etki:**
- Local development için normal
- Production'da HTTPS zorunlu (Railway otomatik sağlıyor)

#### 5. Port Exposure
**Risk Seviyesi:** 🟡 ORTA (Local)

**Durum:**
- PostgreSQL: 5432 exposed
- Redis: 6379 exposed (optional)
- Synapse: 8008 exposed

**Etki:**
- Local network'ten erişilebilir
- Firewall koruması önerilir

### ✅ GÜVENLİK İYİ UYGULAMALAR

1. **Docker Isolation:** Servisler container'larda çalışıyor
2. **Health Checks:** Container'lar health check yapıyor
3. **Production HTTPS:** Railway otomatik HTTPS sağlıyor
4. **Admin API:** Synapse Admin API kullanılıyor (doğru yetkilendirme)

### 🔐 GÜVENLİK ÖNERİLERİ

#### Kısa Vadeli
1. ✅ Şifreleri environment variables'a taşı
2. ✅ `.env` dosyasını `.gitignore`'a ekle
3. ✅ Registration'a email verification ekle
4. ✅ Rate limiting ekle

#### Uzun Vadeli
1. ✅ Secret management (HashiCorp Vault, AWS Secrets Manager)
2. ✅ Audit logging
3. ✅ Two-factor authentication (2FA)
4. ✅ IP whitelisting (admin panel için)
5. ✅ Backup encryption
6. ✅ Security monitoring (log analysis)

---

## 🎨 ÖZELLİKLER VE İŞLEVSELLİK

### Temel Özellikler

#### ✅ Mesajlaşma
- Real-time messaging
- Rich text formatting
- File sharing
- Emoji support
- Reactions
- Mentions (@username)

#### ✅ Oda Yönetimi
- Public rooms
- Private rooms
- Room creation
- Room deletion
- Room joining/leaving

#### ✅ Admin Özellikleri
- Tüm odaları görme
- Tüm mesajları okuma
- Kullanıcı yönetimi
- Oda yönetimi
- Otomatik admin ekleme

#### ✅ Video Call
- Element Call entegrasyonu
- TURN server desteği (Metered.ca)
- WebRTC bazlı

#### ✅ Mobil Desteği
- Responsive design
- PWA desteği
- Touch-friendly UI
- iOS Safari optimizasyonları

### Gelişmiş Özellikler

#### ✅ Database Query Scripts
- Mesaj arama
- Oda bazlı sorgular
- Export functionality

#### ✅ Automation
- Auto-add admin service
- Health monitoring
- Service management scripts

---

## 🚀 DEPLOYMENT STRATEJİSİ

### Local Development

**Platform:** Windows 10/11  
**Gereksinimler:**
- Docker Desktop
- Node.js v20+
- Yarn
- PowerShell 5.1+

**Başlatma:**
```powershell
.\BASLAT.ps1
.\AUTO-ADD-ADMIN.ps1
```

**Erişim:**
- Element Web: http://localhost:8080
- Synapse Admin: http://localhost:5173
- Backend API: http://localhost:8008

### Production Deployment

#### Railway (Backend)
- **Platform:** Railway.app
- **Servisler:** Synapse, PostgreSQL, Redis
- **Domain:** `cravex1-production.up.railway.app`
- **HTTPS:** Otomatik (Railway managed)
- **Scaling:** Otomatik (Railway free tier)

#### Netlify (Frontend)
- **Platform:** Netlify
- **Servis:** Element Web (static)
- **Build:** Yarn build
- **Deploy:** Git push ile otomatik

#### TURN Server
- **Provider:** Metered.ca
- **Purpose:** Video call NAT traversal
- **Railway TURN:** Disabled (port expose sorunları)

### Deployment Süreci

**Otomatik:**
1. Git push → Railway auto-deploy
2. Git push → Netlify auto-deploy

**Manuel:**
1. Railway dashboard → Redeploy
2. Netlify dashboard → Deploy site

---

## 📁 KOD KALİTESİ VE YAPI

### Dosya Organizasyonu

**Güçlü Yönler:**
- ✅ Scriptler kategorize edilmiş
- ✅ Config dosyaları ayrı klasörlerde
- ✅ Dokümantasyon kapsamlı
- ✅ Version control (Git)

**Zayıf Yönler:**
- ⚠️ Çok fazla script (50+ PowerShell script)
- ⚠️ Bazı scriptler duplicate
- ⚠️ Hardcoded path'ler (`C:\Users\Can Cakir\Desktop\www-backup`)
- ⚠️ Hardcoded credentials

### Kod Kalitesi

**PowerShell Scripts:**
- ✅ Error handling var
- ✅ Color output (UX)
- ✅ Parameter validation
- ⚠️ Hardcoded values
- ⚠️ Path dependency

**Config Files:**
- ✅ YAML formatı doğru
- ✅ JSON formatı doğru
- ⚠️ Şifreler açık

**Frontend Code:**
- ✅ TypeScript kullanımı
- ✅ React best practices
- ✅ Custom CSS modüler
- ✅ Component structure iyi

### Dokümantasyon

**Güçlü Yönler:**
- ✅ README.md kapsamlı
- ✅ Sistem özeti var (`SISTEM-OZET.md`)
- ✅ Deployment guide'ları var
- ✅ Troubleshooting guide'ları var
- ✅ Mobile guide var

**Dokümantasyon Dosyaları:**
- `README.md` - Ana dokümantasyon
- `SISTEM-OZET.md` - Sistem mimarisi
- `YAPILAN-DEĞİŞİKLİKLER.md` - Changelog
- `RAILWAY-DEPLOY.md` - Deployment guide
- `MOBİL-KULLANIM-KILAVUZU.md` - Mobile guide
- `SIFRELEME-DEVRE-DISI-KILAVUZU.md` - Encryption guide
- Ve daha fazlası...

---

## 💪 GÜÇLÜ YÖNLER

### 1. Kapsamlı Özellik Seti
- ✅ Tam fonksiyonel Matrix Synapse stack
- ✅ Admin panel entegrasyonu
- ✅ Video call desteği
- ✅ Mobil responsive

### 2. İyi Dokümantasyon
- ✅ Detaylı README
- ✅ Troubleshooting guide'ları
- ✅ Deployment guide'ları
- ✅ Kullanım kılavuzları

### 3. Otomasyon
- ✅ PowerShell scriptler ile otomasyon
- ✅ Auto-add admin service
- ✅ Service management scripts

### 4. Deployment Hazırlığı
- ✅ Railway deployment config
- ✅ Netlify deployment config
- ✅ Docker Compose setup
- ✅ Environment configuration

### 5. Developer Experience
- ✅ Hızlı başlatma (`BASLAT.ps1`)
- ✅ Durum kontrolü (`DURUM.ps1`)
- ✅ Color output (UX)
- ✅ Error messages açıklayıcı

### 6. Özelleştirme
- ✅ Custom CSS (mobil responsive)
- ✅ Brand customization (CraveX)
- ✅ Config customization
- ✅ Theme customization

---

## ⚠️ ZAYIF YÖNLER VE İYİLEŞTİRME ÖNERİLERİ

### 1. Güvenlik Sorunları

**Sorun:** Hardcoded şifreler  
**Öneri:**
```powershell
# .env dosyası kullan
$env:ADMIN_PASSWORD = Get-Content .env | Select-String "ADMIN_PASSWORD"
```

**Sorun:** Şifreleme kapalı  
**Öneri:** Production'da dikkatli kullan, compliance göz önünde bulundur

### 2. Kod Organizasyonu

**Sorun:** 50+ PowerShell script, bazıları duplicate  
**Öneri:**
- Script'leri modülerleştir
- Common functions library oluştur
- Duplicate script'leri birleştir

**Sorun:** Hardcoded path'ler  
**Öneri:**
```powershell
# Relative path kullan
$projectPath = Split-Path -Parent $MyInvocation.MyCommand.Path
```

### 3. Error Handling

**Sorun:** Bazı scriptlerde eksik error handling  
**Öneri:**
- Try-catch blokları ekle
- Logging mekanizması kur
- Error notification sistemi

### 4. Testing

**Sorun:** Test coverage yok  
**Öneri:**
- Unit tests ekle (PowerShell için Pester)
- Integration tests ekle
- E2E tests ekle (Playwright)

### 5. Monitoring

**Sorun:** Monitoring/logging eksik  
**Öneri:**
- Application logging ekle
- Health check endpoints
- Metrics collection (Prometheus)
- Alerting (Grafana)

### 6. Backup Strategy

**Sorun:** Backup stratejisi belirtilmemiş  
**Öneri:**
- Otomatik database backup
- Media store backup
- Disaster recovery plan

### 7. Scaling

**Sorun:** Scaling stratejisi belirtilmemiş  
**Öneri:**
- Horizontal scaling planı
- Load balancing
- Database replication
- Caching strategy

### 8. Documentation

**Sorun:** Bazı scriptlerde dokümantasyon eksik  
**Öneri:**
- Script başlıklarına açıklama ekle
- Parameter documentation
- Usage examples

---

## 🎯 RİSK ANALİZİ

### Yüksek Riskler

1. **🔴 Güvenlik:** Hardcoded credentials
   - **Etki:** Unauthorized access
   - **Olasılık:** Orta
   - **Öncelik:** Yüksek

2. **🔴 Veri Güvenliği:** Şifreleme kapalı
   - **Etki:** Veri sızıntısı
   - **Olasılık:** Düşük (local)
   - **Öncelik:** Orta (production'da yüksek)

3. **🔴 Registration:** Verification yok
   - **Etki:** Spam, abuse
   - **Olasılık:** Yüksek
   - **Öncelik:** Orta

### Orta Riskler

1. **🟡 Monitoring:** Logging eksik
   - **Etki:** Troubleshooting zorluğu
   - **Olasılık:** Orta
   - **Öncelik:** Orta

2. **🟡 Backup:** Otomatik backup yok
   - **Etki:** Veri kaybı
   - **Olasılık:** Düşük
   - **Öncelik:** Orta

3. **🟡 Scaling:** Scaling stratejisi yok
   - **Etki:** Performance sorunları
   - **Olasılık:** Düşük (küçük kullanıcı sayısı)
   - **Öncelik:** Düşük

### Düşük Riskler

1. **🟢 Path Dependency:** Hardcoded path'ler
   - **Etki:** Portability sorunları
   - **Olasılık:** Düşük (tek kullanıcı)
   - **Öncelik:** Düşük

---

## 📊 SONUÇ VE ÖNERİLER

### Genel Değerlendirme

**CraveX1**, Matrix protokolü üzerine kurulu, admin denetimli bir mesajlaşma sistemidir. Proje, temel özellikleri ile çalışır durumda ve iyi dokümante edilmiştir. Ancak production'a hazır hale getirmek için bazı iyileştirmeler gerekmektedir.

### Güçlü Yönler Özeti

1. ✅ Kapsamlı özellik seti
2. ✅ İyi dokümantasyon
3. ✅ Otomasyon scriptleri
4. ✅ Deployment hazırlığı
5. ✅ Developer experience

### İyileştirme Önerileri Özeti

#### Kısa Vadeli (1-2 Hafta)
1. ✅ Şifreleri environment variables'a taşı
2. ✅ `.env` dosyasını `.gitignore`'a ekle
3. ✅ Registration'a email verification ekle
4. ✅ Hardcoded path'leri relative yap

#### Orta Vadeli (1-2 Ay)
1. ✅ Monitoring ve logging ekle
2. ✅ Backup stratejisi oluştur
3. ✅ Test coverage ekle
4. ✅ Error handling iyileştir

#### Uzun Vadeli (3-6 Ay)
1. ✅ Secret management tool entegre et
2. ✅ 2FA ekle
3. ✅ Scaling stratejisi geliştir
4. ✅ Security audit yap

### Öncelik Sıralaması

1. **🔴 Yüksek Öncelik:** Güvenlik iyileştirmeleri (credentials, verification)
2. **🟡 Orta Öncelik:** Monitoring, backup, testing
3. **🟢 Düşük Öncelik:** Scaling, path dependency

### Sonuç

**CraveX1**, amacına uygun bir şekilde tasarlanmış ve iyi dokümante edilmiş bir projedir. Local development için mükemmel, production için bazı güvenlik iyileştirmeleri gerekiyor. Proje, Matrix ekosisteminin güçlü özelliklerini kullanarak admin denetimli bir mesajlaşma platformu sağlamaktadır.

---

## 📚 EK BİLGİLER

### Proje İstatistikleri

- **Toplam Dosya:** 1000+ dosya
- **PowerShell Script:** 50+ script
- **Markdown Dokümantasyon:** 30+ dosya
- **Config Dosyaları:** 10+ config
- **Frontend Dependencies:** 100+ npm package
- **Backend Services:** 3 Docker container

### Kullanılan Teknolojiler

- **Backend:** Python, Twisted, PostgreSQL, Redis
- **Frontend:** React, TypeScript, Webpack, Vite
- **Infrastructure:** Docker, Docker Compose, Railway, Netlify
- **Automation:** PowerShell, Bash
- **Protocol:** Matrix Protocol (E2EE disabled)

### Proje Yapısı

```
www-backup/
├── synapse-config/          # Synapse configuration
├── synapse-railway-config/   # Railway-specific config
├── www/
│   ├── element-web/         # Element Web frontend
│   ├── admin/               # Synapse Admin panel
│   └── call.cravex.chat/    # Element Call
├── *.ps1                     # PowerShell scripts
├── docker-compose.yml        # Docker services
├── *.md                      # Documentation
└── ...
```

---

**Analiz Tarihi:** 1 Kasım 2025  
**Analiz Eden:** AI Assistant (Composer)  
**Versiyon:** 1.0

