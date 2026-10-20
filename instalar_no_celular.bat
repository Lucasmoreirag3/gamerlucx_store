@echo off
chcp 65001 > nul
echo ===================================================================
echo     GAMELUX STORE - INSTALADOR NO DISPOSITIVO (CRITÉRIO 10)
echo ===================================================================
echo.
echo Verificando dispositivos móveis conectados via USB (Modo Depuração)...
adb devices

echo.
echo Instalando o APK gerado no dispositivo Android conectado...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    adb install -r "build\app\outputs\flutter-apk\app-release.apk"
    echo.
    echo [SUCESSO] Aplicativo GameLuX Store instalado no dispositivo!
) else (
    echo [AVISO] APK Release não encontrado. Tentando compilar e instalar diretamente via Flutter...
    flutter run --release
)

pause
