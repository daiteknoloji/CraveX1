@echo off
echo ========================================
echo TUM SERVİSLERİ BASLATILIYOR
echo ========================================
echo.

cd /d "C:\Users\Can Cakir\Desktop\www-backup"

REM 1. Docker servisleri baslat
echo [1/3] Docker servisleri kontrol ediliyor...
docker-compose up -d
timeout /t 5 /nobreak >nul

REM 2. Element Web kontrol
echo.
echo [2/3] Element Web durumu:
docker ps | findstr "element"

REM 3. Admin Panel baslat (yeni pencerede)
echo.
echo [3/3] Admin Panel baslatiliyor (yeni pencere)...
start "Cravex Admin Panel" cmd /k "cd /d C:\Users\Can Cakir\Desktop\www-backup && python admin-panel-server.py"

timeout /t 3 /nobreak >nul

echo.
echo ========================================
echo TUM SERVİSLER BASLATILDI!
echo ========================================
echo.
echo ERISIM LINKLERI:
echo.
echo ^> Matrix Synapse:    http://localhost:8008
echo ^> Element Web:       http://localhost:8080  
echo ^> Admin Panel (Old): http://localhost:5173
echo ^> Admin Panel (NEW): http://localhost:9000  ^<-- BU KULLAN!
echo.
echo Yeni Admin Panel Login:
echo   Username: admin
echo   Password: admin123
echo.
echo ========================================
echo.
pause

