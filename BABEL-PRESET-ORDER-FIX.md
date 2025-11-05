# ✅ BABEL PRESET ORDER DÜZELTİLDİ

**Tarih:** 1 Kasım 2025  
**Commit:** `e73b405`  
**Hata:** `TypeScript 'declare' fields must first be transformed by @babel/plugin-transform-typescript` ve `Unexpected reserved word 'private'`

---

## 🔍 SORUN

Netlify build'i, çok sayıda dosyada aşağıdaki hatalarla başarısız oluyordu:

1. **`declare` field hatası:**
   ```
   SyntaxError: TypeScript 'declare' fields must first be transformed by @babel/plugin-transform-typescript.
   ```

2. **`private` keyword hatası:**
   ```
   SyntaxError: Unexpected reserved word 'private'.
   ```

**Etkilenen Dosyalar:**
- `EmbeddedPage.tsx`
- `RoomStatusBar.tsx`
- `RoomView.tsx`
- `UserMenu.tsx`
- `UserView.tsx`
- `SoftLogout.tsx`
- `MessageContextMenu.tsx`
- `PersistentApp.tsx`
- `RoomAliasField.tsx`
- `LocationPicker.tsx`
- `MAudioBody.tsx`
- `MFileBody.tsx`
- `MImageBody.tsx`
- `MLocationBody.tsx`
- `MPollBody.tsx`
- `MVideoBody.tsx`
- `TextualBody.tsx`
- `AliasSettings.tsx`
- `EventTile.tsx`
- `LegacyRoomList.tsx`
- `MessageComposer.tsx`
- `AudioFeed.tsx`
- `VideoFeed.tsx`
- `PollStartEventPreview.ts`
- Ve diğerleri...

**Toplam:** 30+ dosya

---

## 🔍 KÖK NEDEN

Babel preset'leri **ters sırada** işler (son → ilk). Önceki yapılandırmada:

1. TypeScript preset **ilk** sıradaydı → **son** çalışıyordu (yanlış!)
2. Class-properties plugin'i TypeScript'ten **önce** çalışıyordu
3. Bu yüzden `declare` field'ları TypeScript işlemeden önce class-properties plugin'i tarafından işlenmeye çalışılıyordu

---

## ✅ ÇÖZÜM

TypeScript preset'i **presets dizisinin sonuna** taşındı. Böylece:

1. **Presets çalışma sırası (ters):**
   - TypeScript preset (son → **ilk çalışır** ✅)
   - Env preset
   - React preset

2. **Plugins çalışma sırası (normal):**
   - class-properties
   - private-methods
   - private-property-in-object
   - decorators

3. **Sonuç:**
   - TypeScript preset `declare` field'ları **önce** işler
   - Sonra class-related plugin'ler çalışır
   - `private` keyword'leri doğru şekilde parse edilir

---

## 📝 YAPILAN DEĞİŞİKLİKLER

### `www/element-web/babel.config.js`

**Önceki Sıralama:**
```javascript
presets: [
    "@babel/preset-typescript",  // ❌ İlk → Son çalışır (yanlış!)
    "@babel/preset-env",
    "@babel/preset-react",
]
```

**Yeni Sıralama:**
```javascript
presets: [
    "@babel/preset-react",
    "@babel/preset-env",
    "@babel/preset-typescript",  // ✅ Son → İlk çalışır (doğru!)
]
```

---

## 🎯 SONUÇ

Artık Babel yapılandırması:
- ✅ TypeScript preset'i **önce** çalıştırır
- ✅ `declare` field'ları doğru şekilde işler
- ✅ `private` metodları doğru şekilde parse eder
- ✅ Class-related plugin'ler doğru sırada çalışır

Netlify build'inin başarılı olması bekleniyor.

---

## 📚 REFERANSLAR

- [Babel Preset Ordering](https://babeljs.io/docs/en/presets#preset-ordering)
- [Babel TypeScript Declare Fields](https://babeljs.io/docs/en/babel-plugin-transform-typescript#allowdeclarefields)
- [Babel Private Methods](https://babeljs.io/docs/en/babel-plugin-transform-private-methods)

