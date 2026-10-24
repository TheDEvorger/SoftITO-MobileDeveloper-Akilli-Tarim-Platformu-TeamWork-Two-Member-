@echo off
setlocal
cd /d "%~dp0.."
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter SDK bulunamadi. Once Flutter'i kur ve PATH'e ekle.
  exit /b 1
)
flutter doctor
flutter create --project-name akilli_tarim_platformu --platforms=android .
if errorlevel 1 exit /b 1
flutter pub get
if errorlevel 1 exit /b 1
flutter analyze
if errorlevel 1 exit /b 1
flutter test
if errorlevel 1 exit /b 1
flutter devices
endlocal
