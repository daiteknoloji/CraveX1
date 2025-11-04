@echo off
cls
echo ========================================
echo ELEMENT WEB BASLATILIYOR
echo ========================================
echo.

cd /d "C:\Users\Can Cakir\Desktop\www-backup\www\element-web\webapp"

echo Element Web Server
echo.
echo URL: http://localhost:8080
echo Matrix Server: http://localhost:8008
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

python -m http.server 8080

