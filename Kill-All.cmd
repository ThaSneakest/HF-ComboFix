
@IF NOT DEFINED SFXNAME GOTO :EOF

@REGT /S region.dat
@IF NOT EXIST CFReboot.dat TYPE myNul.dat >CfReboot.dat

@(
ECHO.\\
ECHO.%systemroot%\explorer.exe
ECHO.%systemroot%\system32\smss.exe
ECHO.%systemroot%\system32\csrss.exe
ECHO.%systemroot%\system32\winlogon.exe
ECHO.%systemroot%\system32\services.exe
ECHO.%systemroot%\system32\lsass.exe
ECHO.%systemroot%\system32\svchost.exe
ECHO.%systemroot%\system32\dmadmin.exe
ECHO.%cd%\
ECHO.%systemroot%\system32\wbem\wmiprvse.exe
ECHO.%systemroot%\PEV.exe
ECHO.%systemroot%\NIRCMD.exe
ECHO.%systemroot%\sed.exe
ECHO.%systemroot%\grep.exe
)>KiLLNot

@IF EXIST Vista.krl @(
ECHO.%systemroot%\system32\wininit.exe
ECHO.%systemroot%\system32\lsm.exe
ECHO.%systemroot%\system32\dwm.exe
)>>KiLLNot

SETLOCAL

SET temp=%cd%
Catchme -l N_\%random% -Iapx >KillAll00
SED "/\\/!d; s/\\??\\//;s/^\\systemroot/%systemroot:\=\\%/I;s/^\\/%systemdrive%&/" KillAll00 >KillAll01

ENDLOCAL

GREP -Fivf KiLLNot KillAll01 >KillAll02

SED -R "s/.*\[(\d*)].*/\1/" KillAll02 >KillAll03

SED ":a;N;s/\n/ /;ta" KillAll03 >KillAll04

FOR /F "TOKENS=*" %%G IN ( KillAll04 ) DO @PV -kfi %%G

PV -o"%%i %%l" svchost.exe >KillAll05

SED -r "/%system:\=\\%\\svchost( |\.exe )-k /Id; s/([0-9]*) .*/@PV -kfi \1/" KillAll05 >KillAll.bat

@ECHO.@ECHO.^>NULL >> KillAll.bat
CALL KillAll.bat

@DEL /A/F/Q KillAll*

@GOTO :EOF

