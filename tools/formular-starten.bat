@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0start-formular.ps1"
if errorlevel 1 (
	echo.
	echo Der Formularstarter ist mit einem Fehler beendet worden.
)
echo.
pause