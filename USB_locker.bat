@echo off
setlocal enabledelayedexpansion

:: Chemin du fichier de configuration
set "config_file=%~dp0config.txt"

:: Lire le fichier de configuration s'il existe
if exist "%config_file%" (
    for /f "tokens=1,2 delims==" %%a in (%config_file%) do (
        if "%%a"=="lang" set lang=%%b
    )
)

:: Demande de la langue si non définie dans le fichier de configuration
if not defined lang (
    echo Select your language / Choisissez votre langue:
    echo [1] English
    echo [2] Francais
    set /P lang=Enter the number corresponding to your choice / Entrez le numero correspondant a votre choix: 

    if "!lang!"=="1" (
        set lang=en
    ) else if "!lang!"=="2" (
        set lang=fr
    ) else (
        echo Invalid choice / Choix invalide
        goto eof
    )
    echo !lang!
    :: Sauvegarder la langue choisie dans le fichier de configuration
    echo lang=!lang! > "%config_file%"
)

:: Définir le fichier et le message d'erreur en fonction de la langue
if "%lang%"=="en" (
    set file=lang\USB_locker_EN.bat
    set errmsg=Error: USB_locker_EN.bat not found in the lang directory.
) else if "%lang%"=="fr" (
    set file=lang\USB_locker_FR.bat
    set errmsg=Erreur : USB_locker_FR.bat est introuvable dans le repertoire lang.
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
