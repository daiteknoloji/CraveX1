# ÜCRETSİZ TURN SERVER KURULUM REHBERİ - RAILWAY

## ✅ ADIM 1: Railway'de Yeni Service Oluştur

1. Railway dashboard'a git: https://railway.app
2. Projenize girin (CraveX1)
3. "New Service" butonuna tıklayın
4. "GitHub Repo" seçin
5. Repo: `daiteknoloji/CraveX1` veya `daiteknoloji/Cravexv5`
6. Service adı: `turn-server` veya `coturn`

## ✅ ADIM 2: Dockerfile Ayarları

1. Service ayarlarına gidin (Settings)
2. "Build" sekmesine gidin
3. "Dockerfile Path": `turnserver.Dockerfile`
4. "Root Directory": `/` (repo root)

## ✅ ADIM 3: Port Ayarları

1. "Settings" → "Networking" sekmesine gidin
2. Port: `3478` (UDP ve TCP)
3. Public port oluşturun (UDP ve TCP)

## ⚠️ ÖNEMLİ NOTLAR:

- Railway UDP desteği sınırlı olabilir
- UDP port forwarding çalışmayabilir
- Eğer çalışmazsa alternatif çözümler deneyeceğiz

## ✅ ADIM 4: Railway Service URL'ini Al

1. Service deploy olduktan sonra
2. "Settings" → "Networking" → Public domain'i kopyalayın
3. Örnek: `turn-server-production.up.railway.app`

## ✅ ADIM 5: Config Dosyalarını Güncelle

Railway TURN server URL'ini config dosyalarına ekleyeceğiz:
- `www/element-web/config.json`
- `synapse-railway-config/homeserver.yaml`

## 🔄 ALTERNATİF ÇÖZÜMLER (Railway çalışmazsa):

1. **STUN + Peer-to-Peer**: NAT sorunluysa çalışmayabilir
2. **Başka ücretsiz TURN servisleri**: Araştırmaya devam ediyoruz
3. **Geçici çözüm**: Metered.ca servislerinin çalışmasını beklemek

