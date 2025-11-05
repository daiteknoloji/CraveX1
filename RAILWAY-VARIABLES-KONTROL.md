# 🔍 RAILWAY ENVIRONMENT VARIABLES KONTROLÜ

**Durum:** Synapse servisinin Variables sekmesinde görünen variable'lar ✅  
**Kontrol:** Railway TURN server ile ilgili variable var mı?

---

## ✅ GÖRÜNEN VARIABLE'LAR

1. ✅ `FORM_SECRET`
2. ✅ `MACAROON_SECRET_KEY`
3. ✅ `POSTGRES_DB`
4. ✅ `POSTGRES_HOST`
5. ✅ `POSTGRES_PASSWORD`
6. ✅ `POSTGRES_PORT`
7. ✅ `POSTGRES_USER`
8. ✅ `REGISTRATION_SHARED_SECRET`
9. ✅ `SYNAPSE_SERVER_NAME`
10. ✅ `SYNAPSE_URL`
11. ✅ `WEB_CLIENT_LOCATION`

**Railway TURN server ile ilgili variable görünmüyor** ✅

---

## ⚠️ ÖNEMLİ: COLLAPSED SECTION KONTROL ET

**Görüntüde görünen:**
```
> 8 variables added by Railway
```

**Bu collapsed section'ı aç ve kontrol et:**

1. **Collapsed section'ı aç** (">" işaretine tıkla)
2. **Şu variable'ları ara:**
   - `TURN_URIS`
   - `TURN_SERVER_URL`
   - `TURN_SERVER`
   - `TURN_URI`
   - `SYNAPSE_TURN_URIS`
   - Veya `TURN` içeren herhangi bir variable

**Eğer Railway TURN server URL'ini içeren variable varsa:**
- Variable'ı **Delete** et
- **Synapse'i redeploy et**

---

## 🔍 ARANACAK VARIABLE İSİMLERİ

**Railway TURN server ile ilgili olabilecek variable'lar:**

- `TURN_URIS`
- `TURN_SERVER_URL`
- `TURN_SERVER`
- `TURN_URI`
- `SYNAPSE_TURN_URIS`
- `COTURN_URL`
- `TURN_SERVER_DOMAIN`
- `RAILWAY_TURN_SERVER`
- Veya `TURN` içeren herhangi bir variable

---

## ✅ ÇÖZÜM

**Eğer Railway TURN server ile ilgili variable bulursan:**

1. **Variable'ı seç**
2. **Delete** butonuna tıkla
3. **Synapse'i redeploy et**

**Eğer Railway TURN server ile ilgili variable yoksa:**

- ✅ Variable'lar temiz
- ✅ Sorun Railway'in otomatik service discovery'si olabilir
- ✅ Railway Support'a başvur

---

**Son Güncelleme:** 1 Kasım 2025  
**Durum:** Railway environment variables kontrolü eklendi

