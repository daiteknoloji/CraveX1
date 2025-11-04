@echo off
echo ========================================
echo ELEMENT WEB BASLATILIYOR
echo ========================================
echo.

cd /d "C:\Users\Can Cakir\Desktop\www-backup\www\element-web"

REM Check if nginx or http-server installed
where nginx >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Nginx ile baslatiliyor...
    start "Element Web - Nginx" nginx -c "C:\Users\Can Cakir\Desktop\www-backup\www\element-web\nginx.conf"
    goto :end
)

REM Try http-server (Node.js)
where http-server >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo http-server ile baslatiliyor...
    start "Element Web - HTTP Server" http-server -p 8080 -c-1
    goto :end
)

REM Try Python simple http server
echo Python HTTP server ile baslatiliyor...
start "Element Web - Python Server" python -m http.server 8080

:end
timeout /t 3 /nobreak >nul
echo.
echo ========================================
echo Element Web Baslatildi!
echo ========================================
echo.
echo URL: http://localhost:8080
echo.
echo Matrix Server: http://localhost:8008
echo.
pause

