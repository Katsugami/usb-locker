:: USB Locker v1.5
:: Author: g4xyk00
:: Tested on Windows 11

echo off
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a")

:: To Obtain Current SID
For /f "tokens=2 delims=\" %%a in ('whoami') do (set currentUser=%%a)
powershell useraccount where name="%currentUser%" get sid | findstr "S-" > 0.txt
set /P currentSID=<0.txt
For /f "tokens=1 delims= " %%a in ('echo %currentSID%') do (set currentSID=%%a)
For /F "tokens=3" %%c in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start 2^>nul') do (set StartVal=%%c)

 
:MAIN_ACTIVITY
cls

echo         __    ___   _               _               
echo  /\ /\ / _\  / __\ ^| ^|  ___    ___ ^| ^| __ ___  _ __ 
echo / / \ \\ \  /__\// ^| ^| / _ \  / __^|^| ^|/ // _ \^| '__^|
echo \ \_/ /_\ \/ \/  \ ^| ^|^| (_) ^|^| (__ ^|   ^<^|  __/^| ^|   
echo  \___/ \__/\_____/ ^|_^| \___/  \___^|^|_^|\_\\___^|^|_^|   
@echo:
echo Created by: Gary Kong (g4xyk00)
echo Version: 1.4
echo Homepage: www.axcelsec.com                                               
													
@echo:
pushd %~dp0

:: Local Computer Policy > Computer Configuration > Administrative Templates > System > Removable Storage Access
:: All Removable Storage classes
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_All" > 1.txt
set /p AllClassesDeny=<1.txt
:: Disabled
IF "%AllClassesDeny:~-1%"=="0" ( set AllClassesDenyStatus=0 ) 
:: Enabled
IF "%AllClassesDeny:~-1%"=="1" ( set AllClassesDenyStatus=1 ) 
:: Not configured
IF "%AllClassesDeny:~-1%"=="~-1" ( set AllClassesDenyStatus=0 )  

:: Removable Disks
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_Read" > 1.txt
set /p RemovableDenyRead=<1.txt
:: Disabled
IF "%RemovableDenyRead:~-1%"=="0" ( set RemovableDenyReadStatus=0 )  
:: Enabled
IF "%RemovableDenyRead:~-1%"=="1" ( set RemovableDenyReadStatus=1 )  
:: Not configured
IF "%RemovableDenyRead:~-1%"=="~-1" ( set RemovableDenyReadStatus=0 )  

type 0.txt | findstr /C:"Deny_Write" > 1.txt
set /p RemovableDenyWrite=<1.txt
:: Disabled
IF "%RemovableDenyWrite:~-1%"=="0" ( set RemovableDenyWriteStatus=0 ) 
:: Enabled 
IF "%RemovableDenyWrite:~-1%"=="1" ( set RemovableDenyWriteStatus=1 )  
:: Not configured
IF "%RemovableDenyWrite:~-1%"=="~-1" ( set RemovableDenyWriteStatus=0 )  

:: WPD Devices
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_Read" > 1.txt
set /p WPDDenyRead=<1.txt
:: Disabled
IF "%WPDDenyRead:~-1%"=="0" ( set WPDDenyReadStatus=0 )  
:: Enabled
IF "%WPDDenyRead:~-1%"=="1" ( set WPDDenyReadStatus=1 )  
:: Not configured
IF "%WPDDenyRead:~-1%"=="~-1" ( set WPDDenyReadStatus=0 ) 
 

type 0.txt | findstr /C:"Deny_Write" > 1.txt
set /p WPDDenyWrite=<1.txt
:: Disabled
IF "%WPDDenyWrite:~-1%"=="0" ( set WPDDenyWriteStatus=0 )  
:: Enabled
IF "%WPDDenyWrite:~-1%"=="1" ( set WPDDenyWriteStatus=1 )  
:: Not configured
IF "%WPDDenyWrite:~-1%"=="~-1" ( set WPDDenyWriteStatus=0 )  

set /A AccessStatus = %AllClassesDenyStatus% + %RemovableDenyReadStatus% + %RemovableDenyWriteStatus% + %WPDDenyReadStatus% + %WPDDenyWriteStatus%
echo Existing removable storage access (Computer) is:
IF "%AccessStatus%" NEQ "0" ( call :PainText 02 "DENIED" )
IF "%AccessStatus%" EQU "0" ( call :PainText 04 "ALLOWED" )


:: Local Computer Policy > User Configuration > Administrative Templates > System > Removable Storage Access
:: All Removable Storage classes
reg query HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_All" > 1.txt
set /p AllClassesDenyCurrent=<1.txt
:: Disabled
IF "%AllClassesDenyCurrent:~-1%"=="0" ( set AllClassesDenyStatusCurrent=0 ) 
:: Enabled
IF "%AllClassesDenyCurrent:~-1%"=="1" ( set AllClassesDenyStatusCurrent=1 ) 
:: Not configured
IF "%AllClassesDenyCurrent:~-1%"=="~-1" ( set AllClassesDenyStatusCurrent=0 )  

:: Removable Disks
reg query HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_Read" > 1.txt
set /p RemovableDenyReadCurrent=<1.txt
:: Disabled
IF "%RemovableDenyReadCurrent:~-1%"=="0" ( set RemovableDenyReadStatusCurrent=0 )  
:: Enabled
IF "%RemovableDenyReadCurrent:~-1%"=="1" ( set RemovableDenyReadStatusCurrent=1 )  
:: Not configured
IF "%RemovableDenyReadCurrent:~-1%"=="~-1" ( set RemovableDenyReadStatusCurrent=0 )  

type 0.txt | findstr /C:"Deny_Write" > 1.txt
set /p RemovableDenyWriteCurrent=<1.txt
:: Disabled
IF "%RemovableDenyWriteCurrent:~-1%"=="0" ( set RemovableDenyWriteStatusCurrent=0 ) 
:: Enabled 
IF "%RemovableDenyWriteCurrent:~-1%"=="1" ( set RemovableDenyWriteStatusCurrent=1 )  
:: Not configured
IF "%RemovableDenyWriteCurrent:~-1%"=="~-1" ( set RemovableDenyWriteStatusCurrent=0 )  

:: WPD Devices
reg query HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_Read" > 1.txt
set /p WPDDenyReadCurrent=<1.txt
:: Disabled
IF "%WPDDenyReadCurrent:~-1%"=="0" ( set WPDDenyReadStatusCurrent=0 )  
:: Enabled
IF "%WPDDenyReadCurrent:~-1%"=="1" ( set WPDDenyReadStatusCurrent=1 )  
:: Not configured
IF "%WPDDenyReadCurrent:~-1%"=="~-1" ( set WPDDenyReadStatusCurrent=0 ) 

type 0.txt | findstr /C:"Deny_Write" > 1.txt
set /p WPDDenyWriteCurrent=<1.txt
:: Disabled
IF "%WPDDenyWriteCurrent:~-1%"=="0" ( set WPDDenyWriteStatusCurrent=0 )  
:: Enabled
IF "%WPDDenyWriteCurrent:~-1%"=="1" ( set WPDDenyWriteStatusCurrent=1 )  
:: Not configured
IF "%WPDDenyWriteCurrent:~-1%"=="~-1" ( set WPDDenyWriteStatusCurrent=0 )  

set /A AccessStatusCurrent = %AllClassesDenyStatusCurrent% + %RemovableDenyReadStatusCurrent% + %RemovableDenyWriteStatusCurrent% + %WPDDenyReadStatusCurrent% + %WPDDenyWriteStatusCurrent%
echo Existing removable storage access (Current User) is:
IF "%AccessStatusCurrent%" NEQ "0" ( call :PainText 02 "DENIED" )
IF "%AccessStatusCurrent%" EQU "0" ( call :PainText 04 "ALLOWED" )
echo L'acces aux Cles USB est :
if "%StartVal%"=="0x3" (
    call :PainText 04 "ALLOWED"
) else if "%StartVal%"=="0x4" (
    call :PainText 02 "DENIED"
) else (
    echo La valeur Start est inconnue ou absente : %StartVal%
)
del 0.txt
del 1.txt

@echo:
@echo:

echo ***** Action ***** 
echo [1] Allow removable storage access
echo [2] Deny removable storage access 
echo [3] Revert to default setting
echo [4] Create Log
echo [5] Enables USB Keys
echo [6] Disables USB Keys
echo [0] Exit Program
@echo:
SET /P A=Please select an action (e.g. 2) and press ENTER: 

IF %A%==0 GOTO END
IF %A%==1 GOTO ACCESS_ALLOW
IF %A%==2 GOTO ACCESS_DENY
IF %A%==3 GOTO ACCESS_CLEAR
IF %A%==4 GOTO CREATE_LOG
IF %A%==5 GOTO ENABLE_USB_KEYS
IF %A%==6 GOTO DISABLE_USB_KEYS

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
echo Removable storage access is now ALLOWED!
@echo:
GOTO MAIN_ACTIVITY

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
echo Removable storage access is now DENIED!
@echo:
GOTO MAIN_ACTIVITY


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
echo Reverted to Default Setting!
@echo:
GOTO MAIN_ACTIVITY

:ENABLE_USB_KEYS
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 3 /f
echo Access to USB Keys is now ALLOWED!
set "StartVal=0x3"
@echo:
GOTO MAIN_ACTIVITY

:DISABLE_USB_KEYS
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 4 /f
set "StartVal=0x4"
echo Access to USB Keys is now DENIED!
@echo:
GOTO MAIN_ACTIVITY

:CREATE_LOG
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices /s > usblock_log.txt
reg query HKU\%currentSID%\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices >> usblock_log.txt
@echo:
GOTO MAIN_ACTIVITY


:PainText
<nul set /p "=%DEL%" > "%~2"
findstr /v /a:%1 /R "+" "%~2" nul
del "%~2" > nul
echo.
goto :eof

PAUSE
:END
