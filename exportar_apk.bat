@echo off
chcp 65001 > nul
echo ===================================================================
echo     GAMELUX STORE - EXPORTADOR DE APK (CRITÉRIO 10 - SENAI)
echo ===================================================================
echo.
echo [1/3] Limpando compilações anteriores...
call flutter clean

echo.
echo [2/3] Baixando dependências do projeto (flutter pub get)...
call flutter pub get

echo.
echo [3/3] Compilando APK em modo Release otimizado...
call flutter build apk --release

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ===================================================================
    echo  SUCESSO! O arquivo APK foi gerado com sucesso em:
    echo  build\app\outputs\flutter-apk\app-release.apk
    echo ===================================================================
    echo.
    echo Para instalar diretamente no celular conectado via USB, execute:
    echo flutter install ou .\instalar_no_celular.bat
) else (
    echo.
    echo [ERRO] Ocorreu uma falha durante a exportação do APK.
    echo Verifique se o Android SDK está configurado no seu ambiente.
)
pause
