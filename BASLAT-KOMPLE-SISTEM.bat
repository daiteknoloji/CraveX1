@echo off
cls
echo ========================================
echo MATRIX KOMPLE SİSTEM BASLATILIYOR
echo ========================================
echo.

cd /d "C:\Users\Can Cakir\Desktop\www-backup"

REM 1. Docker Servisleri
echo [1/4] Docker servisleri baslatiliyor...
docker-compose up -d
timeout /t 5 /nobreak >nul
echo Docker servisleri TAMAM!

REM 2. Element Web (Yarn)
echo.
echo [2/4] Element Web baslatiliyor (yeni pencere)...
start "Element Web :8080" cmd /k "cd /d C:\Users\Can Cakir\Desktop\www-backup\www\element-web && echo === ELEMENT WEB === && echo http://localhost:8080 && echo. && yarn start"

timeout /t 3 /nobreak >nul

REM 3. Admin Panel Synapse (Port 5173)
echo.
echo [3/4] Synapse Admin baslatiliyor (yeni pencere)...
start "Synapse Admin :5173" cmd /k "cd /d C:\Users\Can Cakir\Desktop\www-backup\www\admin && echo === SYNAPSE ADMIN === && echo http://localhost:5173 && echo. && yarn start"

timeout /t 3 /nobreak >nul

REM 4. Cravex Admin Panel (Port 9000)
echo.
echo [4/4] Cravex Admin Panel baslatiliyor (yeni pencere)...
start "Cravex Admin :9000" cmd /k "cd /d C:\Users\Can Cakir\Desktop\www-backup && echo === CRAVEX ADMIN PANEL === && echo http://localhost:9000 && echo Login: admin / admin123 && echo. && python admin-panel-server.py"

timeout /t 3 /nobreak >nul

cls
echo.
echo ========================================
echo    TUM SERVİSLER BASLATILDI!
echo ========================================
echo.
echo 4 YENI PENCERE ACILDI:
echo   1. Element Web (Yarn Dev Server)
echo   2. Synapse Admin (React Dev Server)  
echo   3. Cravex Admin (Python Flask)
echo   4. Bu pencere (Durum bilgisi)
echo.
echo ========================================
echo ERISIM LINKLERI:
echo ========================================
echo.
echo [BACKEND]
echo   Matrix Synapse:    http://localhost:8008
echo   PostgreSQL:        localhost:5432
echo.
echo [FRONTEND - KULLANICILAR]
echo   Element Web:       http://localhost:8080
echo     ^> Mesajlasma, oda olusturma
echo     ^> Kullanici: @1k:localhost, @2k:localhost vb.
echo.
echo [FRONTEND - ADMIN]
echo   Synapse Admin:     http://localhost:5173
echo     ^> Orijinal admin panel
echo     ^> Admin odada olmali
echo.
echo   Cravex Admin:      http://localhost:9000  ^<-- RECOMMENDED!
echo     ^> YENİ: Gelismis admin panel
echo     ^> Login: admin / admin123
echo     ^> TUM ODALARI yonetir
echo     ^> Uye ekleme/cikarma SINIR YOK!
echo     ^> Database direkt erisim
echo.
echo ========================================
echo.
echo Durdurmak icin: DURDUR-HER-SEY.bat
echo.
pause

