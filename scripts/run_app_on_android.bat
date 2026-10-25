@echo off
echo ========================================================
echo  Bereket Ovasi - Android Simulator Baslatici
echo ========================================================
echo.

set ADB="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"
set EMULATOR="%LOCALAPPDATA%\Android\Sdk\emulator\emulator.exe"

echo 1. Android Simulator kontrol ediliyor...
%ADB% devices | findstr "emulator" > nul
if errorlevel 1 (
    echo Simulator kapali, baslatiliyor (Medium_Phone_API_37.0)...
    start "" %EMULATOR% -avd Medium_Phone_API_37.0
    echo Simulatorun acilmasi bekleniyor...
    %ADB% wait-for-device
) else (
    echo Simulator zaten aktif!
)

echo.
echo 2. Bereket Ovasi uygulamasi calistiriliyor...
cd /d "%~dp0\.."
call flutter run -d android

pause
