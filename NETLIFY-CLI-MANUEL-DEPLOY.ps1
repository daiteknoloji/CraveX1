# Netlify CLI Manuel Deploy - PowerShell Script

# Netlify CLI ile manuel deploy başlatmak için PowerShell komutları

# ÖNEMLİ: Önce Netlify CLI kurulu olmalı:
# npm install -g netlify-cli

# ============================================
# ADIM 1: Netlify'a Giriş Yap
# ============================================
# netlify login

# ============================================
# ADIM 2: Projeyi Link Et (Sadece ilk kez)
# ============================================
# netlify link --name cozy-dragon-54547b
# VEYA
# netlify link --name crvx2

# ============================================
# ADIM 3: Manuel Deploy (Production)
# ============================================
# Build ve deploy (cache temizleme ile)
netlify deploy --prod --build

# Sadece build yapmadan deploy (önceden build edilmiş dosyalar varsa)
# netlify deploy --prod --dir=www/element-web/webapp

# ============================================
# ADIM 4: Build Hook ile Deploy (Alternatif)
# ============================================
# Build hook URL'i ile deploy tetikle
# Invoke-WebRequest -Uri "https://api.netlify.com/build_hooks/[BUILD_HOOK_ID]" -Method POST

# ============================================
# TAM KOMUT SETİ (Kopyala-Yapıştır)
# ============================================

# Proje dizinine git
cd "C:\Users\Can Cakir\Desktop\www-backup"

# Netlify durumunu kontrol et
netlify status

# Manuel deploy başlat (build ile birlikte)
netlify deploy --prod --build

# VEYA sadece build yap ve sonra deploy et
cd www/element-web
yarn install
yarn build
cd ../..
netlify deploy --prod --dir=www/element-web/webapp

