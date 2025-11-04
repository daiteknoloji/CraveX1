@echo off
echo ========================================
echo Element Web Baslatiliyor...
echo ========================================
echo.

cd /d "C:\Users\Can Cakir\Desktop\www-backup"

echo Element Web calisiyor mu kontrol ediliyor...
docker ps | findstr "nginx" >nul 2>&1

if %ERRORLEVEL% EQU 0 (
    echo Element Web zaten calisiyor!
    echo URL: http://localhost:8080
) else (
    echo Element Web baslatilamadi!
    echo Docker kontrol ediliyor...
    docker ps
)

echo.
echo ========================================
echo.
pause

