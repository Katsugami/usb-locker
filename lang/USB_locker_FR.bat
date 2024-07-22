:: USB Locker v1.4
:: Auteur: g4xyk00
:: Traducteur fr: Katsugami
:: Teste sur Windows 7, 10, 11

echo off
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a")

:: Pour obtenir le SID actuel
For /f "tokens=2 delims=\" %%a in ('whoami') do (set currentUser=%%a)
wmic useraccount where name="%currentUser%" get sid | findstr "S-" > 0.txt
set /P currentSID=<0.txt
For /f "tokens=1 delims= " %%a in ('echo %currentSID%') do (set currentSID=%%a)
 
:ACTIVITE_PRINCIPALE
cls

echo         __    ___   _               _               
echo  /\ /\ / _\  / __\ ^| ^|  ___    ___ ^| ^| __ ___  _ __ 
echo / / \ \\ \  /__\// ^| ^| / _ \  / __^|^| ^|/ // _ \^| '__^|
echo \ \_/ /_\ \/ \/  \ ^| ^|^| (_) ^|^| (__ ^|   ^<^|  __/^| ^|   
echo  \___/ \__/\_____/ ^|_^| \___/  \___^|^|_^|\_\\___^|^|_^|   
@echo:
echo Cree par: Gary Kong (g4xyk00)
echo Traducteur fr: Katsugami
echo Version: 1.4
echo Page d'accueil: www.axcelsec.com                                               
													
@echo:
pushd %~dp0

:: Strategie locale de l'ordinateur > Configuration de l'ordinateur > Modeles d'administration > Systeme > Acces aux peripheriques de stockage amovibles
:: Toutes les classes de stockage amovible
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_All" > 1.txt
set /p AllClassesDeny=<1.txt
:: Desactive
IF "%AllClassesDeny:~-1%"=="0" ( set AllClassesDenyStatus=0 ) 
:: Active
IF "%AllClassesDeny:~-1%"=="1" ( set AllClassesDenyStatus=1 ) 
:: Non configure
IF "%AllClassesDeny:~-1%"=="~-1" ( set AllClassesDenyStatus=0 )  

:: Disques amovibles
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_Read" > 1.txt
set /p RemovableDenyRead=<1.txt
:: Desactive
IF "%RemovableDenyRead:~-1%"=="0" ( set RemovableDenyReadStatus=0 )  
:: Active
IF "%RemovableDenyRead:~-1%"=="1" ( set RemovableDenyReadStatus=1 )  
:: Non configure
IF "%RemovableDenyRead:~-1%"=="~-1" ( set RemovableDenyReadStatus=0 )  

type 0.txt | findstr /C:"Deny_Write" > 1.txt
set /p RemovableDenyWrite=<1.txt
:: Desactive
IF "%RemovableDenyWrite:~-1%"=="0" ( set RemovableDenyWriteStatus=0 ) 
:: Active 
IF "%RemovableDenyWrite:~-1%"=="1" ( set RemovableDenyWriteStatus=1 )  
:: Non configure
IF "%RemovableDenyWrite:~-1%"=="~-1" ( set RemovableDenyWriteStatus=0 )  

:: Peripheriques WPD
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_Read" > 1.txt
set /p WPDDenyRead=<1.txt
:: Desactive
IF "%WPDDenyRead:~-1%"=="0" ( set WPDDenyReadStatus=0 )  
:: Active
IF "%WPDDenyRead:~-1%"=="1" ( set WPDDenyReadStatus=1 )  
:: Non configure
IF "%WPDDenyRead:~-1%"=="~-1" ( set WPDDenyReadStatus=0 ) 
 

type 0.txt | findstr /C:"Deny_Write" > 1.txt
set /p WPDDenyWrite=<1.txt
:: Desactive
IF "%WPDDenyWrite:~-1%"=="0" ( set WPDDenyWriteStatus=0 )  
:: Active
IF "%WPDDenyWrite:~-1%"=="1" ( set WPDDenyWriteStatus=1 )  
:: Non configure
IF "%WPDDenyWrite:~-1%"=="~-1" ( set WPDDenyWriteStatus=0 )  

set /A AccessStatus = %AllClassesDenyStatus% + %RemovableDenyReadStatus% + %RemovableDenyWriteStatus% + %WPDDenyReadStatus% + %WPDDenyWriteStatus%
echo L'acces actuel aux peripheriques de stockage amovible (Ordinateur) est:
IF "%AccessStatus%" NEQ "0" ( call :PainText 02 "REFUSE" )
IF "%AccessStatus%" EQU "0" ( call :PainText 04 "AUTORISE" )


:: Strategie locale de l'ordinateur > Configuration de l'utilisateur > Modeles d'administration > Systeme > Acces aux peripheriques de stockage amovibles
:: Toutes les classes de stockage amovible
reg query HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_All" > 1.txt
set /p AllClassesDenyCurrent=<1.txt
:: Desactive
IF "%AllClassesDenyCurrent:~-1%"=="0" ( set AllClassesDenyStatusCurrent=0 ) 
:: Active
IF "%AllClassesDenyCurrent:~-1%"=="1" ( set AllClassesDenyStatusCurrent=1 ) 
:: Non configure
IF "%AllClassesDenyCurrent:~-1%"=="~-1" ( set AllClassesDenyStatusCurrent=0 )  

:: Disques amovibles
reg query HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_Read" > 1.txt
set /p RemovableDenyReadCurrent=<1.txt
:: Desactive
IF "%RemovableDenyReadCurrent:~-1%"=="0" ( set RemovableDenyReadStatusCurrent=0 )  
:: Active
IF "%RemovableDenyReadCurrent:~-1%"=="1" ( set RemovableDenyReadStatusCurrent=1 )  
:: Non configure
IF "%RemovableDenyReadCurrent:~-1%"=="~-1" ( set RemovableDenyReadStatusCurrent=0 )  

type 0.txt | findstr /C:"Deny_Write" > 1.txt
set /p RemovableDenyWriteCurrent=<1.txt
:: Desactive
IF "%RemovableDenyWriteCurrent:~-1%"=="0" ( set RemovableDenyWriteStatusCurrent=0 ) 
:: Active 
IF "%RemovableDenyWriteCurrent:~-1%"=="1" ( set RemovableDenyWriteStatusCurrent=1 )  
:: Non configure
IF "%RemovableDenyWriteCurrent:~-1%"=="~-1" ( set RemovableDenyWriteStatusCurrent=0 )  

:: Peripheriques WPD
reg query HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_Read" > 1.txt
set /p WPDDenyReadCurrent=<1.txt
:: Desactive
IF "%WPDDenyReadCurrent:~-1%"=="0" ( set WPDDenyReadStatusCurrent=0 )  
:: Active
IF "%WPDDenyReadCurrent:~-1%"=="1" ( set WPDDenyReadStatusCurrent=1 )  
:: Non configure
IF "%WPDDenyReadCurrent:~-1%"=="~-1" ( set WPDDenyReadStatusCurrent=0 ) 

type 0.txt | findstr /C:"Deny_Write" > 1.txt
set /p WPDDenyWriteCurrent=<1.txt
:: Desactive
IF "%WPDDenyWriteCurrent:~-1%"=="0" ( set WPDDenyWriteStatusCurrent=0 )  
:: Active
IF "%WPDDenyWriteCurrent:~-1%"=="1" ( set WPDDenyWriteStatusCurrent=1 )  
:: Non configure
IF "%WPDDenyWriteCurrent:~-1%"=="~-1" ( set WPDDenyWriteStatusCurrent=0 )  

set /A AccessStatusCurrent = %AllClassesDenyStatusCurrent% + %RemovableDenyReadStatusCurrent% + %RemovableDenyWriteStatusCurrent% + %WPDDenyReadStatusCurrent% + %WPDDenyWriteStatusCurrent%
echo L'acces actuel aux peripheriques de stockage amovible (Utilisateur actuel) est:
IF "%AccessStatusCurrent%" NEQ "0" ( call :PainText 02 "REFUSE" )
IF "%AccessStatusCurrent%" EQU "0" ( call :PainText 04 "AUTORISE" )
del 0.txt
del 1.txt

@echo:
@echo:

echo ***** Action ***** 
echo [1] Autoriser l'acces aux peripheriques de stockage amovibles
echo [2] Refuser l'acces aux peripheriques de stockage amovibles 
echo [3] Revenir aux parametres par defaut
echo [4] Creer un journal
echo [0] Quitter le programme
@echo:
SET /P A=Veuillez selectionner une action (par ex. 2) et appuyez sur ENTRER: 

IF %A%==0 GOTO END
IF %A%==1 GOTO ACCESS_ALLOW
IF %A%==2 GOTO ACCESS_DENY
IF %A%==3 GOTO ACCESS_CLEAR
IF %A%==4 GOTO CREATE_LOG

:ACCESS_ALLOW
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices /t REG_DWORD /v Deny_All /d 0 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Read /d 0 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Write /d 0 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Read /d 0 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Write /d 0 /f > nul 2>&1
reg add HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices /t REG_DWORD /v Deny_All /d 0 /f > nul 2>&1
reg add HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Read /d 0 /f > nul 2>&1
reg add HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Write /d 0 /f > nul 2>&1
reg add HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Read /d 0 /f > nul 2>&1
reg add HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Write /d 0 /f > nul 2>&1
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
echo L'acces aux peripheriques de stockage amovibles est maintenant AUTORISE!
@echo:
GOTO ACTIVITE_PRINCIPALE

:ACCESS_DENY
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices /t REG_DWORD /v Deny_All /d 1 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Read /d 1 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Write /d 1 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Read /d 1 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Write /d 1 /f > nul 2>&1
reg add HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices /t REG_DWORD /v Deny_All /d 1 /f > nul 2>&1
reg add HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Read /d 1 /f > nul 2>&1
reg add HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Write /d 1 /f > nul 2>&1
reg add HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Read /d 1 /f > nul 2>&1
reg add HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Write /d 1 /f > nul 2>&1
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
echo L'acces aux peripheriques de stockage amovibles est maintenant REFUSE!
@echo:
GOTO ACTIVITE_PRINCIPALE


:ACCESS_CLEAR
reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices /v Deny_All /f > nul 2>&1
reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /v Deny_Read /f > nul 2>&1
reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /v Deny_Write /f > nul 2>&1
reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /v Deny_Read /f > nul 2>&1
reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /v Deny_Write /f > nul 2>&1
reg delete HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices /v Deny_All /f > nul 2>&1
reg delete HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /v Deny_Read /f > nul 2>&1
reg delete HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /v Deny_Write /f > nul 2>&1
reg delete HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /v Deny_Read /f > nul 2>&1
reg delete HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /v Deny_Write /f > nul 2>&1
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
echo Revenu aux parametres par defaut!
@echo:
GOTO ACTIVITE_PRINCIPALE


:CREATE_LOG
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices /s > usblock_log.txt
reg query HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices >> usblock_log.txt
@echo:
GOTO ACTIVITE_PRINCIPALE


:PainText
<nul set /p "=%DEL%" > "%~2"
findstr /v /a:%1 /R "+" "%~2" nul
del "%~2" > nul
echo.
goto :eof

PAUSE
:END
