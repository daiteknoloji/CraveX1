# Railway TURN Server Port Expose Etme Rehberi

## Railway Dashboard'da Port 3478'i Expose Etme

### Adım 1: Railway Dashboard'a Git
1. https://railway.app/dashboard adresine git
2. Giriş yap

### Adım 2: TURN Server Servisini Bul
1. Projeni seç
2. TURN server servisini bul (turn-server-production-2809 veya benzeri isim)
3. Servise tıkla

### Adım 3: Settings Sekmesine Git
1. Üst menüden "Settings" sekmesine tıkla
2. Veya sol menüden "Settings" seçeneğini bul

### Adım 4: Networking Bölümünü Bul
1. Settings sayfasında "Networking" veya "Ports" bölümünü bul
2. "Public Networking" veya "Expose Port" seçeneğini ara

### Adım 5: Port 3478'i Expose Et

**Yöntem 1: Port Mapping (Eğer varsa)**
1. "Ports" veya "Networking" sekmesine git
2. "Add Port" veya "+" butonuna tıkla
3. Port numarası: `3478`
4. Protocol: `TCP`
5. Public URL oluştur: `Enable` veya `Yes`
6. "Save" veya "Deploy" butonuna tıkla

**Yöntem 2: Environment Variables (Alternatif)**
1. "Variables" sekmesine git
2. Yeni variable ekle:
   - Key: `PORT`
   - Value: `3478`
3. "Deploy" butonuna tıkla

**Yöntem 3: Railway.json (Manuel)**
Eğer Railway.json dosyası varsa:
```json
{
  "deploy": {
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  },
  "networking": {
    "ports": [
      {
        "port": 3478,
        "protocol": "tcp",
        "public": true
      }
    ]
  }
}
```

### Adım 6: Kontrol Et

1. Railway Dashboard'da servisin "Deploying" durumuna geçtiğini gör
2. Deploy tamamlandıktan sonra "Networking" sekmesinde port 3478'in expose edildiğini kontrol et
3. Public URL'in oluşturulduğunu kontrol et

### Adım 7: Test Et

PowerShell'de test et:
```powershell
Test-NetConnection -ComputerName turn-server-production-2809.up.railway.app -Port 3478
```

**Beklenen sonuç:**
- `TcpTestSucceeded: True` → Başarılı!
- `TcpTestSucceeded: False` → Hala expose edilmemiş, tekrar kontrol et

## Sorun Giderme

### Eğer "Ports" veya "Networking" sekmesi yoksa:

1. **Railway'in free tier'ında custom port expose etme sınırlaması olabilir**
   - Bu durumda Railway TURN server'ı kullanamazsın
   - Metered.ca server'larına güvenmek zorundasın

2. **Railway'in HTTP/HTTPS portları otomatik expose edilir**
   - Custom port'lar (3478 gibi) için ekstra ayar gerekebilir
   - Railway Pro plan gerekebilir

3. **Alternatif: Railway'in otomatik public domain'i kullan**
   - Railway otomatik olarak `turn-server-production-2809.up.railway.app` domain'ini verir
   - Ama bu domain HTTP/HTTPS için çalışır, TURN için değil

## Not

Railway'in free tier'ında custom port expose etme özelliği sınırlı olabilir. Bu durumda:
- Railway TURN server'ı kullanamazsın
- Metered.ca ve Matrix.org TURN server'larına güvenmek zorundasın
- Bu server'lar zaten çalışıyor ve yeterli olmalı

