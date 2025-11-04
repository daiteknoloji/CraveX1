@echo off
echo ========================================
echo TUM SERVİSLER DURDURULUYOR
echo ========================================
echo.

cd /d "C:\Users\Can Cakir\Desktop\www-backup"

REM 1. Admin Panel durdur
echo [1/3] Admin Panel durduruluyor...
taskkill /F /FI "WINDOWTITLE eq *Cravex Admin Panel*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq *admin-panel-server*" >nul 2>&1

REM 2. Element Web durdur
echo [2/3] Element Web durduruluyor...
taskkill /F /FI "WINDOWTITLE eq *Element Web*" >nul 2>&1

REM 3. Docker servisleri durdur
echo [3/3] Docker servisleri durduruluyor...
docker-compose down

echo.
echo ========================================
echo TUM SERVİSLER DURDURULDU!
echo ========================================
echo.
pause

