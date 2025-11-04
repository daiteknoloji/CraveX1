@echo off
cls
echo ========================================
echo MATRIX + ELEMENT + ADMIN PANEL
echo TUM SERVİSLER BASLATILIYOR
echo ========================================
echo.

cd /d "C:\Users\Can Cakir\Desktop\www-backup"

REM 1. Docker Servisleri (Synapse + PostgreSQL + Redis)
echo [1/3] Docker servisleri baslatiliyor...
echo.
docker-compose up -d

timeout /t 5 /nobreak >nul

REM 2. Element Web (Python HTTP Server)
echo.
echo [2/3] Element Web baslatiliyor...
echo.
start "Element Web :8080" cmd /k "cd /d C:\Users\Can Cakir\Desktop\www-backup\www\element-web && echo Element Web Server && echo http://localhost:8080 && python -m http.server 8080"

timeout /t 2 /nobreak >nul

REM 3. Admin Panel (Port 9000)
echo.
echo [3/3] Admin Panel baslatiliyor...
echo.
start "Cravex Admin Panel :9000" cmd /k "cd /d C:\Users\Can Cakir\Desktop\www-backup && echo === CRAVEX ADMIN PANEL === && echo http://localhost:9000 && echo Login: admin / admin123 && echo. && python admin-panel-server.py"

timeout /t 3 /nobreak >nul

cls
echo.
echo ========================================
echo    TUM SERVİSLER BASLATILDI!
echo ========================================
echo.
echo 1. Matrix Synapse:  http://localhost:8008
echo 2. Element Web:     http://localhost:8080
echo 3. Admin Panel:     http://localhost:9000
echo.
echo ========================================
echo KULLANIM:
echo ========================================
echo.
echo ADMIN PANEL (Port 9000):
echo   - URL: http://localhost:9000
echo   - Login: admin / admin123
echo   - Ozellikler: 
echo     * Oda yonetimi (TUM ODALAR)
echo     * Uye ekleme/cikarma (SINIR YOK!)
echo     * Mesaj goruntuleme
echo     * Export (JSON/CSV)
echo.
echo ELEMENT WEB (Port 8080):
echo   - URL: http://localhost:8080
echo   - Matrix Server: http://localhost:8008
echo   - Normal kullanici gibi mesajlasma
echo.
echo ========================================
echo.
echo Durdurmak icin: DURDUR-HER-SEY.bat
echo.
pause

