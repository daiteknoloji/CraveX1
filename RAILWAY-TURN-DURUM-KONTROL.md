# Railway TURN Server Durum Kontrolü

## Mevcut Durum (Ekrandan Görünen)

✅ **Public Domain:**
- `turn-server-production-2809.up.railway.app`
- Port: 3478
- Metal Edge

⚠️ **Dikkat:**
- Port 3478 görünüyor ama HTTP/HTTPS üzerinden expose edilmiş olabilir
- TURN server için **TCP Proxy** gerekebilir

## Kontrol Adımları

### 1. Önce Test Et (Değişiklik Yapmadan)

PowerShell'de:
```powershell
Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478
```

**Sonuç:**
- ✅ `TcpTestSucceeded: True` → Değişiklik gerekmez, çalışıyor!
- ❌ `TcpTestSucceeded: False` → TCP Proxy eklemen gerekiyor

### 2. Eğer Test Başarısızsa: TCP Proxy Ekle

1. "+ TCP Proxy" butonuna tıkla
2. Şu bilgileri gir:
   - **Port:** `3478`
   - **Protocol:** `TCP`
   - **Target Port:** `3478` (veya boş bırak)
3. "Add" veya "Save" butonuna tıkla
4. Deploy tamamlanana kadar bekle
5. Tekrar test et

### 3. Eğer Test Başarılıysa: Hiçbir Şey Yapma

- Port zaten çalışıyor
- Video call test et
- Çalışıyorsa değişiklik gerekmez

## Sonuç

**Önce test et, sonra karar ver:**
- Test başarılı → Değişiklik gerekmez ✅
- Test başarısız → TCP Proxy ekle ⚠️


