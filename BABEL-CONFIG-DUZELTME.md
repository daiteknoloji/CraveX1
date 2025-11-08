# Babel Configuration Fix - Railway Build Hatası Çözümü

## Sorun
Railway'de Element Web build'i başarısız oluyordu. Hata loglarında çok sayıda `SyntaxError: Unexpected token, expected "}"` hatası görülüyordu.

## Kök Neden
`babel.config.js` dosyasında `@babel/plugin-transform-typescript` plugin'ine geçersiz seçenekler (`isTSX` ve `allExtensions`) eklenmişti. Bu seçenekler **sadece** `@babel/preset-typescript` için geçerlidir, plugin için değil.

## Çözüm
1. **Açık TypeScript plugin'i kaldırıldı**: `@babel/preset-typescript` zaten `@babel/plugin-transform-typescript`'i içeriyor, bu yüzden açıkça eklemeye gerek yok.

2. **Preset konfigürasyonu korundu**: `@babel/preset-typescript` içinde `isTSX: true` ve `allExtensions: true` seçenekleri doğru şekilde ayarlanmış durumda.

## Değişiklikler
- ❌ Kaldırılan: `@babel/plugin-transform-typescript` plugin'i (geçersiz seçeneklerle)
- ✅ Korunan: `@babel/preset-typescript` preset'i (doğru seçeneklerle)

## Babel İşlem Sırası
1. **Presets** (ters sırada işlenir):
   - `@babel/preset-typescript` (son, ilk işlenir) - TSX dosyalarını parse eder
   - `@babel/preset-env` - Modern JavaScript'i dönüştürür
   - `@babel/preset-react` - JSX'i dönüştürür

2. **Plugins** (sırayla işlenir):
   - Export/import plugin'leri
   - Throw expressions plugin'i
   - Class-related plugin'ler (TypeScript preset'ten sonra çalışır)

## Commit
- Commit: `4fc3fd8`
- Mesaj: `fix: Remove invalid isTSX/allExtensions from TypeScript plugin - preset handles TSX`

## Beklenen Sonuç
Railway build'i artık başarılı olmalı. TypeScript ve TSX dosyaları `@babel/preset-typescript` tarafından doğru şekilde işlenecek.

## Notlar
- `@babel/preset-typescript` içindeki `isTSX: true` seçeneği TSX dosyalarını parse etmek için yeterli
- `allExtensions: true` seçeneği tüm dosya uzantılarını TypeScript olarak işler
- Preset ve plugin'i birlikte kullanmak çakışmalara neden olabilir, bu yüzden sadece preset kullanıyoruz

