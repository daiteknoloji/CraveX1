# 🚀 RAILWAY TURN SERVER KURULUMU - ADIM ADIM REHBER

## ✅ ADIM 1: RAILWAY DASHBOARD'DA YENİ SERVİS OLUŞTUR

### Yapılacaklar:

1. **Railway Dashboard'a Git:**
   - https://railway.app/ → Projeni seç

2. **Yeni Servis Ekle:**
   - Sağ üstte **"New"** butonuna tıkla
   - **"Service"** seçeneğini seç

3. **Docker Hub'dan Deploy:**
   - **"Deploy from Docker Hub"** seçeneğini seç
   - **Image:** `coturn/coturn:latest` yaz
   - **Name:** `turn-server` yaz (veya istediğin isim)

4. **Environment Variables Ekle:**
   - Servis oluşturulduktan sonra, **"Variables"** sekmesine git
   - Şu değişkenleri ekle:

   ```
   TURN_USERNAME=turn_user
   TURN_PASSWORD=GüçlüBirŞifre123!
   TURN_REALM=cravex1-production.up.railway.app
   TURN_LISTENING_PORT=3478
   ```

   **ÖNEMLİ:** `TURN_PASSWORD` için güçlü bir şifre kullan! (sonra config.json'da kullanacağız)

5. **Port Ayarları:**
   - **"Settings"** sekmesine git
   - **"Ports"** bölümüne git
   - Port **3478** ekle
   - **Protocol:** Hem **UDP** hem **TCP** seç
   - **Visibility:** **Public** yap

6. **Railway Domain'i Al:**
   - Railway otomatik olarak bir domain verecek
   - Örnek: `turn-server-production-XXXX.up.railway.app`
   - Bu domain'i not al! (sonraki adımlarda kullanacağız)

---

### ✅ Kontrol Listesi:

- [ ] Railway Dashboard'da yeni servis oluşturuldu mu?
- [ ] Docker image: `coturn/coturn:latest` mı?
- [ ] Servis adı: `turn-server` (veya istediğin isim) mı?
- [ ] Environment variables eklendi mi?
  - [ ] `TURN_USERNAME`
  - [ ] `TURN_PASSWORD`
  - [ ] `TURN_REALM`
  - [ ] `TURN_LISTENING_PORT`
- [ ] Port 3478 eklendi mi? (UDP + TCP)
- [ ] Port Public yapıldı mı?
- [ ] Railway domain'i not edildi mi?

---

### 📝 Notlar:

- Railway domain'i her deploy'da değişebilir
- Eğer statik domain istersen Railway'in ücretli planına geçmen gerekebilir
- Şimdilik otomatik domain'i kullanacağız

---

### 🎯 Sonraki Adım:

Bu adımı tamamladıktan sonra bana şunları söyle:
1. ✅ "Adım 1 tamam" veya "1. adım bitti"
2. Railway domain'ini paylaş (örn: `turn-server-production-XXXX.up.railway.app`)
3. `TURN_USERNAME` ve `TURN_PASSWORD` değerlerini paylaş (güvenlik için önemli!)

Sonra **Adım 2**'ye geçeceğiz: `config.json` güncelleme

