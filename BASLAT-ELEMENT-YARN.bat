@echo off
cls
echo ========================================
echo ELEMENT WEB BASLATILIYOR (YARN)
echo ========================================
echo.

cd /d "C:\Users\Can Cakir\Desktop\www-backup\www\element-web"

echo Yarn kontrolu...
where yarn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo HATA: Yarn bulunamadi!
    echo.
    echo Yarn yuklemek icin:
    echo   npm install -g yarn
    echo.
    pause
    exit /b 1
)

echo.
echo Element Web baslatiliyor...
echo.
echo URL: http://localhost:8080
echo Matrix Server: http://localhost:8008
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

yarn start

