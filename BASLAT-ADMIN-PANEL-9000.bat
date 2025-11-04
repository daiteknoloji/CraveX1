@echo off
echo ========================================
echo CRAVEX ADMIN PANEL BASLATILIYOR
echo ========================================
echo.
echo URL: http://localhost:9000
echo Login: admin / admin123
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

cd /d "C:\Users\Can Cakir\Desktop\www-backup"

REM Eski processleri durdur
taskkill /F /FI "WINDOWTITLE eq *admin-panel-server*" >nul 2>&1

python "C:\Users\Can Cakir\Desktop\www-backup\admin-panel-server.py"

pause

