# 🎥 VIDEO CALL DEBUG & FIX

## ✅ İYİ HABERLER!

Log'lara göre **VIDEO CALL SİNYALLERİ ÇALIŞIYOR:**

```
✅ m.call.invite - Call başlatıldı
✅ m.call.answer - Karşı taraf cevapladı
✅ m.call.candidates - ICE candidates gönderildi
✅ m.call.negotiate - Negotiation başarılı
✅ /voip/turnServer - TURN server çalışıyor
```

**AMA ses/görüntü yok!**

---

## 🔴 SORUNLAR

### **1. WidgetStore Initialization Hatası**
```
ReferenceError: Cannot access 'B' before initialization
```

**Çözüm:** Browser cache temizlenmeli

### **2. Unknown Room Events**
```
Got room state event for unknown room !mmMVGyDqlSmTTThWzd...
Got room state event for unknown room !AvXLlmsfgxANAeTeJp...
```

**Çözüm:** Database temizlik (eski odalar)

---

## 🎯 ACİL ÇÖZÜM ADIMLARI

### **ADIM 1: HARD REFRESH (ÖNCELİKLİ!)**

**Her İki Tarayıcıda:**

```
Windows:
Ctrl + Shift + R

Mac:
Cmd + Shift + R

VEYA:
F12 → Network sekmesi → "Disable cache" işaretle
Sayfayı yenile
```

### **ADIM 2: INCOGNITO/PRIVATE MODE**

```
Chrome: Ctrl + Shift + N
Edge: Ctrl + Shift + P
Firefox: Ctrl + Shift + P

Incognito'da test edin:
https://vcravex1.netlify.app
```

### **ADIM 3: BROWSER PERMISSIONS**

**Chrome:**
```
1. Adres çubuğunun solundaki kilit/bilgi ikonuna tıklayın
2. "Site settings" / "Site ayarları"
3. Kamera: İzin ver ✅
4. Mikrofon: İzin ver ✅
5. Sayfayı yenile
```

**Edge:**
```
Ayarlar → Gizlilik → Site izinleri
→ vcravex1.netlify.app
→ Kamera & Mikrofon: İzin ver
```

### **ADIM 4: TARAYICI CONSOLE'U TEMİZLE**

```
F12 → Console
Sağ tık → "Clear console"
Sayfayı yenile (Ctrl + Shift + R)
Tekrar video call deneyin
```

---

## 🧪 VIDEO CALL TEST (Düzgün Yöntem)

### **Hazırlık:**

```
1. Chrome Incognito → user2 ile login
2. Edge Incognito → user1 ile login
3. YENİ bir oda oluşturun (eski odalarda sorun var)
4. Her iki kullanıcı da odaya girsin
```

### **Call Başlatma:**

```
User2 (Chrome):
1. Sağ üstte kamera ikonu 🎥
2. "Start voice call" veya "Start video call"
3. İzin ver (mikrofon/kamera)
4. Bekle...

User1 (Edge):
1. "Incoming call" bildirimi gelecek
2. "Accept" / "Kabul et" tıkla
3. İzin ver (mikrofon/kamera)
4. Bağlantı kurulsun...
```

### **Beklebönen:**

```
✅ Her iki tarafta da:
   - Kamera görüntüsü
   - Mikrofon ikonu
   - Ses duyulmalı
   - Video görünmeli
```

---

## 🆘 EĞER YİNE ÇALIŞMAZSA

### **Console'da Bakın:**

```
F12 → Console

ÖNEMLİ HATALAR:
- "getUserMedia" hatası → Browser izni yok
- "ICE failed" → TURN server problemi
- "DOMException" → Mikrofon/kamera erişim hatası
```

**Hangi hata varsa bana gönderin!**

---

## 💡 ALTERNATİF: JİTSİ KULLANIN

Eğer video call hiç çalışmazsa:

```
config.json'da zaten Jitsi var:
"jitsi": {
    "preferred_domain": "meet.jit.si"
}

Odada:
"+" menü → "Add widgets, bridges & bots"
→ "Video conference"
→ Jitsi Meet açılır (dış servis)
```

---

## 🎯 ŞİMDİ DENE:

**1. Hard Refresh (Ctrl + Shift + R)**  
**2. Incognito modda test**  
**3. YENİ oda oluştur**  
**4. Video call başlat**  

**Sonucu söyleyin!** 🚀

