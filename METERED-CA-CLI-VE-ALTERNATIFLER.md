# 🔧 METERED.CA CLI VE ALTERNATİFLER

## ❌ METERED.CA CLI YOK

Metered.ca **resmi CLI (Command Line Interface)** sunmuyor.

### Neden?
- Metered.ca web tabanlı bir dashboard kullanıyor
- Hizmetleri web arayüzü veya API'ler aracılığıyla yönetiliyor
- CLI geliştirmemişler

---

## ✅ ALTERNATİFLER

### Seçenek 1: Web Dashboard (EN KOLAY) ⭐ ÖNERİLEN

**Avantajlar:**
- ✅ Görsel arayüz
- ✅ Kolay kullanım
- ✅ Credentials'ları doğrudan görebilirsin

**Adımlar:**
1. https://dashboard.metered.ca/ → Giriş yap
2. **"Create New App"** butonuna tıkla
3. App oluştur
4. Credentials'ları gör ve kopyala

---

### Seçenek 2: Metered.ca API (GELİŞMİŞ)

Metered.ca **REST API** sunuyor. API kullanarak credentials alabilirsin.

**API Endpoint'leri:**
- `POST /api/v1/apps` - Yeni app oluştur
- `GET /api/v1/apps/{app_id}` - App bilgilerini al
- `GET /api/v1/apps/{app_id}/credentials` - Credentials'ları al

**API Dokümantasyonu:**
- https://www.metered.ca/docs/rest-api

**Örnek API Kullanımı:**
```bash
# API Key ile yeni app oluştur
curl -X POST https://api.metered.ca/v1/apps \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "CraveX TURN Server",
    "type": "webrtc"
  }'

# Credentials'ları al
curl -X GET https://api.metered.ca/v1/apps/{app_id}/credentials \
  -H "Authorization: Bearer YOUR_API_KEY"
```

**Avantajlar:**
- ✅ Otomatikleştirilebilir
- ✅ Script'lerle entegrasyon

**Dezavantajlar:**
- ⚠️ API Key gerekiyor
- ⚠️ API dokümantasyonu okumak gerekiyor
- ⚠️ Daha karmaşık

---

### Seçenek 3: Manuel config.json Güncelleme

Eğer Metered.ca dashboard'undan credentials'ları aldıysan, doğrudan `config.json`'ı manuel olarak güncelleyebilirsin.

**Adımlar:**
1. Metered.ca dashboard'undan credentials'ları al
2. `config.json` dosyasını aç
3. `voip.turn_servers` bölümünü güncelle
4. Git commit ve push yap

---

## 🎯 ÖNERİ: WEB DASHBOARD KULLAN

**En kolay ve hızlı yöntem:**

1. Metered.ca dashboard'una git
2. Yeni app oluştur
3. Credentials'ları kopyala
4. Bana paylaş
5. Ben `config.json`'ı güncelleyeceğim

---

## 📝 SONRAKI ADIMLAR

### Web Dashboard Kullanarak:

1. **Metered.ca dashboard'una git:**
   - https://dashboard.metered.ca/
   - Giriş yap

2. **Yeni app oluştur:**
   - "Create New App" butonuna tıkla
   - App bilgilerini doldur

3. **Credentials'ları bul:**
   - App'in detay sayfasında "Credentials" sekmesine git
   - Username ve Password'u kopyala

4. **Bana paylaş:**
   - Username: ...
   - Password: ...

5. **Ben config.json'ı güncelleyeceğim:**
   - Metered.ca credentials'larını ekleyeceğim
   - Git commit ve push yapacağım
   - Netlify otomatik deploy yapacak

---

## ✅ HAZIR OLDUĞUNDA

Metered.ca dashboard'undan credentials'ları aldıktan sonra bana şunları paylaş:

1. **Username:** (Metered.ca'dan aldığın)
2. **Password/Secret:** (Metered.ca'dan aldığın)

Sonra `config.json`'ı güncelleyip Git'e push edeceğim!

