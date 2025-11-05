# ❌ Railway PostgreSQL Bağlantı Sorunu

**Sorun:**
Synapse servisi Railway'de PostgreSQL veritabanına bağlanamıyor. Log'larda şu hata görülüyor:

```
psycopg2.OperationalError: connection to server at "localhost" (::1), port 5432 failed: Connection refused
```

**Neden:**
Railway'de her servis kendi container'ında çalışır. `localhost` veya `127.0.0.1` kullanarak başka bir servise bağlanamazsınız. PostgreSQL servisine bağlanmak için Railway'in servis keşfi (service discovery) mekanizmasını kullanmanız gerekir.

---

## 🔍 Teşhis

### 1. Railway Dashboard'da Environment Variables Kontrol Edin

Railway Dashboard → Synapse servisi → Variables sekmesine gidin.

**Gerekli Environment Variables:**
- `POSTGRES_HOST` - PostgreSQL servisinin host adresi
- `POSTGRES_PORT` - PostgreSQL portu (genellikle 5432)
- `POSTGRES_USER` - PostgreSQL kullanıcı adı
- `POSTGRES_PASSWORD` - PostgreSQL şifresi
- `POSTGRES_DB` - PostgreSQL veritabanı adı

**Bu değişkenler şu şekilde ayarlanmalı:**

```
POSTGRES_HOST=${{Postgres.PGHOST}}
POSTGRES_PORT=${{Postgres.PGPORT}}
POSTGRES_USER=${{Postgres.PGUSER}}
POSTGRES_PASSWORD=${{Postgres.PGPASSWORD}}
POSTGRES_DB=${{Postgres.PGDATABASE}}
```

**ÖNEMLİ:** `${{Postgres.PGHOST}}` syntax'ı Railway'in otomatik servis keşfi için gereklidir. `Postgres` kısmı Railway'deki PostgreSQL servisinizin adına göre değişebilir (örn: `${{PostgreSQL.PGHOST}}`).

---

## 💡 Çözüm Adımları

### Adım 1: PostgreSQL Servisini Synapse Servisine Link Edin

1. Railway Dashboard → Synapse servisi → **Settings** sekmesine gidin
2. **"Add Service"** veya **"Link Service"** butonuna tıklayın
3. PostgreSQL servisinizi seçin
4. Railway otomatik olarak environment variable'ları oluşturacaktır

### Adım 2: Environment Variables'ı Kontrol Edin

1. Synapse servisi → **Variables** sekmesine gidin
2. Yeni eklenen PostgreSQL environment variable'larını kontrol edin:
   - `POSTGRES_HOST`
   - `POSTGRES_PORT`
   - `POSTGRES_USER`
   - `POSTGRES_PASSWORD`
   - `POSTGRES_DB`

3. Eğer bu değişkenler yoksa, manuel olarak ekleyin:
   ```
   POSTGRES_HOST=${{Postgres.PGHOST}}
   POSTGRES_PORT=${{Postgres.PGPORT}}
   POSTGRES_USER=${{Postgres.PGUSER}}
   POSTGRES_PASSWORD=${{Postgres.PGPASSWORD}}
   POSTGRES_DB=${{Postgres.PGDATABASE}}
   ```

**NOT:** `Postgres` kısmı Railway'deki PostgreSQL servisinizin gerçek adına göre değişebilir. Eğer servis adınız farklıysa (örn: `postgres-db`), o zaman şu şekilde kullanmalısınız:
```
POSTGRES_HOST=${{postgres-db.PGHOST}}
```

### Adım 3: Synapse Servisini Yeniden Deploy Edin

1. Railway Dashboard → Synapse servisi → **Deployments** sekmesine gidin
2. **"Redeploy"** butonuna tıklayın
3. Logları kontrol edin - artık PostgreSQL'e bağlanabilmeli

---

## ✅ Doğrulama

Deploy tamamlandıktan sonra, Synapse loglarını kontrol edin:

```bash
# Railway Dashboard → Synapse servisi → Logs sekmesi
```

**Başarılı bağlantı için şu log mesajlarını görmelisiniz:**
- `✅ Configuration complete!`
- `🗄️ Database: <host>:<port>` (localhost değil!)
- `🚀 Starting Synapse...`
- `Starting synapse...` (Synapse başladı mesajı)

**Hata mesajları:**
- Eğer hala `connection to server at "localhost"` hatası görüyorsanız, environment variable'lar doğru ayarlanmamış demektir.
- Eğer `❌ ERROR: POSTGRES_HOST not set!` hatası görüyorsanız, environment variable'lar hiç tanımlanmamış demektir.

---

## 🔧 Manuel Kontrol

Eğer environment variable'ları Railway Dashboard'dan kontrol etmek isterseniz:

1. Railway Dashboard → Synapse servisi → **Variables** sekmesine gidin
2. Her bir `POSTGRES_*` değişkeninin değerini kontrol edin
3. `POSTGRES_HOST` değeri `localhost` veya `127.0.0.1` olmamalı!
4. `POSTGRES_HOST` değeri Railway'in PostgreSQL servisinin gerçek host adresi olmalı (örn: `containers-us-west-xxx.railway.app`)

---

## 📝 Notlar

- `start.sh` script'i artık `/tmp` dizinini kullanıyor (Railway'de yazılabilir)
- `homeserver.yaml` dosyasındaki `localhost` değeri `start.sh` tarafından otomatik olarak environment variable'larla değiştirilecek
- Railway'de `/data` dizini yazılabilir değil, bu yüzden tüm geçici dosyalar `/tmp` dizininde oluşturuluyor

---

## 🆘 Sorun Devam Ederse

1. Railway Dashboard → Synapse servisi → **Variables** sekmesinde tüm environment variable'ları kontrol edin
2. PostgreSQL servisinin Railway'de çalıştığından emin olun
3. PostgreSQL servisinin Synapse servisine link edildiğinden emin olun
4. Synapse servisini yeniden deploy edin
5. Logları tekrar kontrol edin

