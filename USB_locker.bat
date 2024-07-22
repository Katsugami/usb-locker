@echo off
setlocal

:: Demande de la langue
echo Select your language / Choisissez votre langue:
echo [1] English
echo [2] Francais
set /P lang=Enter the number corresponding to your choice / Entrez le numero correspondant a votre choix: 

if "%lang%"=="1" (
    set file=lang\USB_locker_EN.bat
    set errmsg=Error: USB_locker_EN.bat not found in the lang directory.
) else if "%lang%"=="2" (
    set file=lang\USB_locker_FR.bat
    set errmsg=Erreur : USB_locker_FR.bat est introuvable dans le repertoire lang.
) else (
    echo Invalid choice / Choix invalide
    goto :eof
)

:: Verification du fichier et lancement
if exist "%~dp0%file%" (
    echo Running %file% as administrator...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dp0%file%' -Verb RunAs"
    exit
) else (
    echo %errmsg%
)

:end
pause
