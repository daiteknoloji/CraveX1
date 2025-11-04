# =============================================
# RAILWAY DATABASE CLEANUP - PowerShell Script
# =============================================
# SADECE ADMIN KALACAK - DİĞER HER ŞEY SİLİNECEK
# =============================================

Write-Host "`n╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║                                                               ║" -ForegroundColor Red
Write-Host "║          ⚠️  DATABASE TEMİZLİK İŞLEMİ  ⚠️                   ║" -ForegroundColor Yellow
Write-Host "║                                                               ║" -ForegroundColor Red
Write-Host "║     UYARI: Bu işlem GERİ ALINAMAZ!                          ║" -ForegroundColor Red
Write-Host "║     Tüm kullanıcılar, odalar, mesajlar SİLİNECEK!           ║" -ForegroundColor Red
Write-Host "║     Sadece ADMIN kullanıcısı kalacak                         ║" -ForegroundColor Red
Write-Host "║                                                               ║" -ForegroundColor Red
Write-Host "╚═══════════════════════════════════════════════════════════════╝`n" -ForegroundColor Red

# Railway database bilgileri
$RAILWAY_DB_HOST = "postgres.railway.internal"
$RAILWAY_DB_PORT = "5432"
$RAILWAY_DB_NAME = "railway"  # Veya sizin database adınız
$RAILWAY_DB_USER = "postgres"
# $RAILWAY_DB_PASSWORD = "???"  # Railway'den alın

Write-Host "📋 ADIMLAR:`n" -ForegroundColor Cyan

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Gray
Write-Host "YÖNTEM 1: RAILWAY CLI (EN KOLAY - ÖNERİLEN)" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Gray

Write-Host "1️⃣ Railway CLI kurulu mu kontrol edin:" -ForegroundColor Yellow
Write-Host "   railway --version`n" -ForegroundColor Magenta

Write-Host "   Eğer yoksa kurun:" -ForegroundColor Gray
Write-Host "   npm install -g @railway/cli`n" -ForegroundColor Magenta

Write-Host "2️⃣ Railway'e login olun:" -ForegroundColor Yellow
Write-Host "   railway login`n" -ForegroundColor Magenta

Write-Host "3️⃣ Projeye bağlanın:" -ForegroundColor Yellow
Write-Host "   railway link`n" -ForegroundColor Magenta

Write-Host "4️⃣ Postgres servisini seçin ve bağlanın:" -ForegroundColor Yellow
Write-Host "   railway run psql -U postgres -d railway`n" -ForegroundColor Magenta

Write-Host "5️⃣ SQL dosyasını çalıştırın:" -ForegroundColor Yellow
Write-Host "   \i RAILWAY-DATABASE-CLEANUP.sql`n" -ForegroundColor Magenta

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Gray
Write-Host "YÖNTEM 2: RAILWAY WEB SHELL (KOLAY)" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Gray

Write-Host "1️⃣ Railway Dashboard'a gidin:" -ForegroundColor Yellow
Write-Host "   https://railway.app/project/cfbd3afe-0576-4346-83de-472ef9148bee`n" -ForegroundColor Magenta

Write-Host "2️⃣ Postgres servisine tıklayın" -ForegroundColor Yellow

Write-Host "3️⃣ Sağ üstte 'Connect' veya 'Shell' butonuna tıklayın" -ForegroundColor Yellow

Write-Host "4️⃣ SQL komutlarını tek tek kopyala-yapıştır çalıştırın" -ForegroundColor Yellow
Write-Host "   (RAILWAY-DATABASE-CLEANUP.sql dosyasından)`n" -ForegroundColor Magenta

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Gray
Write-Host "YÖNTEM 3: POWERSHELL SCRIPT (OTOMATIK)" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Gray

Write-Host "Aşağıdaki komutu çalıştırın:`n" -ForegroundColor Yellow

$scriptContent = @'
# Railway database bağlantısı
railway connect Postgres

# SQL dosyasını çalıştır
railway run psql -U postgres -d railway -f RAILWAY-DATABASE-CLEANUP.sql

# Sonucu göster
railway run psql -U postgres -d railway -c "SELECT name, admin FROM users;"
'@

Write-Host $scriptContent -ForegroundColor Magenta

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Gray
Write-Host "YÖNTEM 4: MANUEL SQL KOMUTLARI (ADM ADIM)" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Gray

Write-Host "Railway Dashboard → Postgres → Shell açın, sonra:`n" -ForegroundColor Yellow

Write-Host "-- ÖNCE KONTROL:" -ForegroundColor Cyan
Write-Host @"
SELECT name, displayname FROM users WHERE name LIKE '%admin%';
"@ -ForegroundColor Magenta

Write-Host "`n-- TÜM ODALARI SİL:" -ForegroundColor Cyan
Write-Host @"
DELETE FROM room_memberships;
DELETE FROM current_state_events;
DELETE FROM events;
DELETE FROM rooms;
"@ -ForegroundColor Magenta

Write-Host "`n-- ADMIN DIŞINDA TÜM KULLANICILARI SİL:" -ForegroundColor Cyan
Write-Host @"
DELETE FROM access_tokens WHERE user_id NOT LIKE '%admin%';
DELETE FROM devices WHERE user_id NOT LIKE '%admin%';
DELETE FROM profiles WHERE user_id NOT LIKE '%admin%';
DELETE FROM users WHERE name NOT LIKE '%admin%';
"@ -ForegroundColor Magenta

Write-Host "`n-- VACUUM (Optimize):" -ForegroundColor Cyan
Write-Host @"
VACUUM FULL ANALYZE;
"@ -ForegroundColor Magenta

Write-Host "`n════════════════════════════════════════════════════════════════`n" -ForegroundColor Gray

Write-Host "🎯 HANGİ YÖNTEMI TERCİH EDERSİNİZ?`n" -ForegroundColor Yellow
Write-Host "   1 → Railway CLI (otomatik)" -ForegroundColor White
Write-Host "   2 → Railway Web Shell (kolay)" -ForegroundColor White
Write-Host "   3 → PowerShell Script (hızlı)" -ForegroundColor White
Write-Host "   4 → Manuel SQL (kontrollü)`n" -ForegroundColor White

Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Gray

# Kullanıcı seçimini bekle
$choice = Read-Host "Seçiminiz (1-4)"

switch ($choice) {
    "1" { 
        Write-Host "`n✅ Railway CLI yöntemi seçildi!" -ForegroundColor Green
        Write-Host "Komutları sırayla çalıştırın:`n" -ForegroundColor Yellow
        Write-Host "railway login" -ForegroundColor Magenta
        Write-Host "railway link" -ForegroundColor Magenta
        Write-Host "railway connect Postgres" -ForegroundColor Magenta
        Write-Host "railway run psql -U postgres -d railway -f RAILWAY-DATABASE-CLEANUP.sql" -ForegroundColor Magenta
    }
    "2" { 
        Write-Host "`n✅ Railway Web Shell yöntemi seçildi!" -ForegroundColor Green
        Write-Host "1. Railway Dashboard açın" -ForegroundColor Yellow
        Write-Host "2. Postgres → Shell" -ForegroundColor Yellow
        Write-Host "3. RAILWAY-DATABASE-CLEANUP.sql dosyasını kopyala-yapıştır" -ForegroundColor Yellow
    }
    "3" { 
        Write-Host "`n✅ PowerShell Script yöntemi seçildi!" -ForegroundColor Green
        Write-Host "Aşağıdaki komutları çalıştırın:`n" -ForegroundColor Yellow
        Write-Host "railway connect Postgres" -ForegroundColor Magenta
        Write-Host "railway run psql -U postgres -d railway -f RAILWAY-DATABASE-CLEANUP.sql" -ForegroundColor Magenta
    }
    "4" { 
        Write-Host "`n✅ Manuel SQL yöntemi seçildi!" -ForegroundColor Green
        Write-Host "RAILWAY-DATABASE-CLEANUP.sql dosyasını açın" -ForegroundColor Yellow
        Write-Host "Komutları tek tek Railway Shell'de çalıştırın" -ForegroundColor Yellow
    }
    default { 
        Write-Host "`n⚠️ Geçersiz seçim!" -ForegroundColor Red 
    }
}

Write-Host "`n🎯 NOT: SQL dosyası: RAILWAY-DATABASE-CLEANUP.sql" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Gray

