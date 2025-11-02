# Railway Matrix Synapse Deployment Guide

## 📋 Gereksinimler
- Railway account (var)
- PostgreSQL database (oluşturulacak)
- Matrix Synapse Docker image
- Domain: `matrix-synapse-production.up.railway.app`

---

## 🗄️ 1. POSTGRESQL DATABASE OLUŞTUR

### Railway Dashboard'da:
1. **New** → **Database** → **Add PostgreSQL**
2. Servis adı: `matrix-synapse-db`
3. Oluşturulduktan sonra **Variables** sekmesine bakın:
   - `PGHOST`
   - `PGPORT`
   - `PGUSER`
   - `PGPASSWORD`
   - `PGDATABASE`

Bu değerleri not edin! ✅

---

## 🐳 2. MATRIX SYNAPSE DOCKER SERVISI OLUŞTUR

### Railway Dashboard'da:
1. **New** → **Empty Service**
2. Servis adı: `matrix-synapse`
3. **Settings** sekmesine gidin

### **Source Section:**
- **Deploy from**: Docker Image
- **Image**: `matrixdotorg/synapse:latest`

### **Variables Section:**
Aşağıdaki environment variables ekleyin:

```bash
# Server Configuration
SYNAPSE_SERVER_NAME=matrix-synapse-production.up.railway.app
SYNAPSE_REPORT_STATS=no
SYNAPSE_NO_TLS=1

# PostgreSQL (yukarıda not ettiğiniz değerleri kullanın)
POSTGRES_HOST=${{matrix-synapse-db.PGHOST}}
POSTGRES_PORT=${{matrix-synapse-db.PGPORT}}
POSTGRES_USER=${{matrix-synapse-db.PGUSER}}
POSTGRES_PASSWORD=${{matrix-synapse-db.PGPASSWORD}}
POSTGRES_DB=${{matrix-synapse-db.PGDATABASE}}

# Public URL
PUBLIC_BASEURL=https://matrix-synapse-production.up.railway.app

# CORS - Synapse Admin UI için
WEB_CLIENT_LOCATION=https://synapse-admin-ui-production.up.railway.app
```

### **Networking Section:**
1. **Generate Domain** tıklayın
2. Domain: `matrix-synapse-production.up.railway.app` olmalı
3. **Target Port**: `8008`

---

## ⚙️ 3. START COMMAND AYARLARI

### **Settings** → **Deploy** → **Custom Start Command:**

```bash
sh -c "
  if [ ! -f /data/homeserver.yaml ]; then
    python -m synapse.app.homeserver \
      --server-name=\$SYNAPSE_SERVER_NAME \
      --config-path=/data/homeserver.yaml \
      --generate-config \
      --report-stats=no
  fi

  # CORS için ayarları güncelle
  python -m synapse.app.homeserver -c /data/homeserver.yaml
"
```

**SORUN:** Railway'de volume persistence yok, her deploy'da sıfırlanır!

---

## 🔧 4. ÇÖZÜM: HOMESERVER.YAML OLUŞTUR VE GITHUB'A EKLE

Synapse config dosyasını repo'ya ekleyelim:

### Dosya: `synapse-railway-config/homeserver.yaml`

Railway'de her seferinde bu dosyayı kullan.

---

## 🚨 5. ALTERNATİF: RAILWAY TEMPLATE KULLAN

Railway'de hazır Synapse template var mı kontrol edelim.

**Railway Template Marketplace:**
https://railway.app/templates

"Matrix Synapse" aratın. Eğer template varsa, tek tıkla deploy!

---

## 📝 SONRAKI ADIMLAR

1. ✅ PostgreSQL oluştur
2. ✅ Matrix Synapse servisi ekle
3. ✅ Environment variables ekle
4. ✅ homeserver.yaml config ekle
5. ⏳ Deploy tamamlansın
6. ⏳ Admin kullanıcı oluştur
7. ⏳ Synapse Admin UI ile test

---

## 🆘 SORUN ÇIKARSA

### Logs kontrol:
```bash
railway logs --service matrix-synapse
```

### Health check:
```
https://matrix-synapse-production.up.railway.app/_matrix/client/versions
```

Beklenen: JSON response
```json
{
  "versions": ["r0.0.1", "r0.1.0", ...]
}
```

---

## 🎯 BAŞLAYALIM!

Şimdi hangi adımı yapalım?
1. PostgreSQL oluştur
2. Template kullan (varsa)
3. Manuel setup

