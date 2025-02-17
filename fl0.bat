@PROMPT $

CD /D "%~DP0"

SETLOCAL
SET "SYSDIR=%SystemRoot%\system32"
SET "ProgFiles=%ProgramFiles%"
SET "CommonProgFiles=%CommonProgramFiles%"
IF EXIST W6432.dat (
	SET "SYSTEM=%SystemRoot%\SysWow64"
	SET "SysNative=%SystemRoot%\SysNative"
	SET "ProgFiles=%ProgramFiles(x86)%"
	SET "CommonProgFiles=%CommonProgramFiles(x86)%"
) ELSE SET "SYSTEM=%SystemRoot%\system32"

SET cfExt=3XE
SET "PATHEXT=.%cfext%;%pathext%"
SET "PATH=%CD%;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\system32\wbem;"
SET "Qrntn=%SystemDrive%\Qoobox\Quarantine"

SWXCACLS "%systemroot%\system32\cmd.exe" /P /GA:F /GS:F /GU:X /GP:X /I ENABLE /Q

GSAR -if -s\:000M:000i:000c:000r:000o -r\:001M:000i:000c:000r:000o "%systemroot%\system32\cmd.exe" cmd.3XE

SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" /DA:R /Q

SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /RESET /Q

SWREG ACL "HKLM\SOFTWARE\Microsoft\Command Processor" /RESET /Q

SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" /RESET /Q

IF EXIST Vista.krl (
	CALL :BFE
	) ELSE SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /DA:R /Q
	
PEV -tf -tpmz -t!o %Systemroot%\Installer\*000*.? -preg"%Systemroot:\=\\%\\Installer\\\{[^\\]*\}\\U\\[^\\]*\..$" > ZAFldr00.dat

FOR %%G IN (
%SystemDrive%\$RECYCLE.bin
%SystemDrive%\RECYCLER
%SystemDrive%\RECYCLED
) DO @IF EXIST %%G\S-1-5-18\ (
	SWXCACLS %%G\* /GA:F /S /Q
	SWXCACLS %%G\* /GA:F /S /Q
	PEV -tf %%G\*000*.? -preg"\\U\\[^\\]*\..$" >> ZAFldr00.dat
	PEV -tf %%G\*000*.? -preg"\\U\\[^\\]*\..$" >> ZAFldr00.dat
	RD /S/Q %%G
	)

SETPATH > TempPath.bat
ECHO.@>>TempPath.bat
CALL TempPath.bat
DEL /A/F TempPath.bat
IF NOT DEFINED LOCALAPPDATA SET "LOCALAPPDATA=%LOCAL APPDATA%"

IF EXIST "%ProgFiles%\Google\Desktop\Install\" PEV -td "%ProgFiles%\Google\Desktop\Install\*" | GREP -Fsq "\?" && GOTO ZA_B
IF EXIST "%LocalAppData%\Google\Desktop\Install\" PEV -td "%LocalAppData%\Google\Desktop\Install\*" | GREP -Fsq "\?" && GOTO ZA_B
GREP -sq . ZAFldr00.dat || GOTO :END


:ZA_B
IF EXIST Clist00 DEL /A/F Clist00

PAUSEP > CFPID00
FOR %%G IN ("%EXEPATH%") DO PAUSEP| SED -r "/%%~NXG/I!d; s/^[^\t]*\t//; s/\t.*//" > CFPID.dat
DEL /A/F CFPID00
FOR /F "TOKENS=*" %%G IN ( CFPID.dat ) DO PAUSEP %%G

IF NOT EXIST %SystemDrive%\Qoobox\Quarantine\Registry_backups\ MD %SystemDrive%\Qoobox\Quarantine\Registry_backups
IF NOT EXIST %SystemDrive%\Qoobox\Test MD %SystemDrive%\Qoobox\Test
IF NOT EXIST %SystemDrive%\Qoobox\TestC MD %SystemDrive%\Qoobox\TestC
IF NOT EXIST %SystemDrive%\Qoobox\LastRun MD %SystemDrive%\Qoobox\LastRun
IF NOT EXIST %SystemDrive%\Qoobox\BackEnv MD %SystemDrive%\Qoobox\BackEnv


REGSVR32.EXE /S %Systemroot%\System32\wbem\wbemess.dll
REGSVR32.EXE /S %Systemroot%\System32\wbem\fastprox.dll

%SYSTEMROOT%\System32\TASKLIST.EXE /m wbemess.dll /FI "imagename eq svchost.exe" /nh > tasklist00
FOR /F "TOKENS=2" %%G IN ( tasklist00 ) DO %SYSTEMROOT%\System32\TASKKILL.EXE /F /PID %%G
DEL tasklist00

PEV EXEC /S CSCRIPT.exe //NOLOGO //E:VBSCRIPT //B //T:15 "%~DP0KNetSvcs.vbs"

IF NOT EXIST W6432.dat (
	PV -kf svchost.exe -l"*netsvcs*"
	PEV -k alg.exe
	)

REGSVR32.EXE /S %Systemroot%\System32\wbem\wbemess.dll
REGSVR32.EXE /S %Systemroot%\System32\wbem\fastprox.dll

IF EXIST XP.mac PEV RIMPORT xpreg.dat

PEV -tf -tpmz -t!o %Systemroot%\Installer\*000*.? -preg"%Systemroot:\=\\%\\Installer\\\{[^\\]*\}\\U\\[^\\]*\..$" > ZAFldr00.dat
PEV -tf -tpmz -t!o %Systemroot%\Installer\*000*.? -preg"%Systemroot:\=\\%\\Installer\\\{[^\\]*\}\\U\\[^\\]*\..$" >> ZAFldr00.dat
SED -r "/\\U\\[^\\]*\..$/I!d; s///" ZAFldr00.dat > ZAFldr01.dat


IF DEFINED APPDATA PEV -tf -tpmz -t!o "%APPDATA%\?" -preg"%APPDATA:\=\\%\\\{[^\\]*\}\\.$" | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat
IF DEFINED APPDATA PEV -tf -tpmz -t!o "%APPDATA%\?" -preg"%APPDATA:\=\\%\\\{[^\\]*\}\\.$" | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat
IF DEFINED APPDATA PEV -tf -tpmz -t!o "%APPDATA%\?" -preg"%APPDATA:\=\\%\\\{[^\\]*\}\\.$" | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat
IF DEFINED LOCALAPPDATA PEV -tf -tpmz -t!o "%LOCALAPPDATA%\?" -preg"%LOCALAPPDATA:\=\\%\\\{[^\\]*\}\\.$" | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat
IF DEFINED LOCALAPPDATA PEV -tf -tpmz -t!o "%LOCALAPPDATA%\?" -preg"%LOCALAPPDATA:\=\\%\\\{[^\\]*\}\\.$" | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat
IF DEFINED LOCALAPPDATA PEV -tf -tpmz -t!o "%LOCALAPPDATA%\?" -preg"%LOCALAPPDATA:\=\\%\\\{[^\\]*\}\\.$" | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat

FOR %%G IN (
%SystemDrive%\$RECYCLE.bin
%SystemDrive%\RECYCLER
%SystemDrive%\RECYCLED
) DO @IF EXIST %%G\ (
	PEV -tf -tpmz -t!o %%G\?  | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat
	PEV -tf -tpmz -t!o %%G\?  | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat
	PEV -tf -tpmz -t!o %%G\?  | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat
	)

	
IF EXIST ZAGoogFldr01.dat DEL /A/F ZAGoogFldr01.dat

FOR %%G IN (
"%ProgFiles%\Google\Desktop\Install"
"%LOCALAPPDATA%\Google\Desktop\Install"
"%APPDATA%\Google\Desktop\Install"
) DO @IF EXIST "%%~G\" (
	DIR /A/D/X "%%~G" | SED -r "/:.*   <[^ ]*>   /!d; />    *\.{1,2}$/d; s/.*  <[^ ]*>   *([^ ]{3,6}~[0-9])    .*(\?.*|\.\..*| )$/\1/; s/.*  <[^ ]*>  .*     //" >ZAGoogFldr00.dat
	FOR /F "TOKENS=*" %%H IN ( ZAGoogFldr00.dat ) DO @CALL :FindXDir "%%~G\%%~H"
	IF EXIST ZAGoogFldr01.dat (
		GREP -F ~ ZAGoogFldr01.dat > ZAGoogFldr02.dat
		FOR /F "TOKENS=*" %%I IN ( ZAGoogFldr02.dat ) DO @(
			SWXCACLS "%%~I" /RESET /Q
			PEV -tf -t!o "%%~I\*" -preg"\\.\\[^\\]*\..$|\\@$" -limit1 > ZAGoogFldr03.dat &&(
				ECHO."%%~G">>ZAFldr01.dat
				SED -r "/~[0-9]\\/!d; s/(.*~[0-9])\\.*/\1/;" ZAGoogFldr03.dat >>ZAFldr01.dat
				)))
	DEL /A/F/Q ZAGoogFldr0?.dat
	)


REM SWREG QUERY "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >CuRun.dat
REM GREP -isq " Google Update.*REG_NONE" CuRun.dat &&(
REM 	SWREG SAVE HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run CURun.hiv
REM 	GSAR -o -s:x47:x00:x6F:x00:x6F:x00:x67:x00:x6C:x00:x65:x00:x20:x00:x55:x00:x70:x00:x64:x00:x61:x00:x74:x00:x65:x00:x00:x00:x2E:x20:x64:x27 -r:x47:x00:x6F:x00:x6F:x00:x67:x00:x6C:x00:x65:x00:x20:x00:x55:x00:x70:x00:x64:x00:x61:x00:x74:x00:x65:x00:x40:x00:x40:x00:x40:x00 CURun.hiv
REM 	SWREG RESTORE HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run CURun.hiv /F
REM 	SWREG DELETE HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "Google Update@@@"
REM 	)
REM DEL /A/F/Q CuRun.dat CURun.hiv


REM SWREG QUERY HKLM\SYSTEM\CurrentControlSet\Services >CCSServices.dat
REM GREP -Fisq "\services\?etadpug" CCSServices.dat &&(
REM 	SWREG SAVE HKLM\SYSTEM\CurrentControlSet\Services CCSServices.hiv
REM 	GSAR -o -s:x2E:x20:x65:x00:x74:x00:x61:x00:x64:x00:x70:x00:x75:x00:x67:x00 -r:x40:x00:x65:x00:x74:x00:x61:x00:x64:x00:x70:x00:x75:x00:x67:x00 CCSServices.hiv
REM 	SWREG RESTORE HKLM\SYSTEM\CurrentControlSet\Services CCSServices.hiv /F
REM 	SWREG NULL DELETE HKLM\SYSTEM\CurrentControlSet\Services\@etadpug
REM 	)
REM DEL /A/F/Q CCSServices.dat CCSServices.hiv


SORT.EXE ZAFldr01.dat | SED -r "$!N; /^(.*)\n\1$/I!P; D" >  ZAFldr02.dat
FOR /F "TOKENS=*" %%G IN ( ZAFldr02.dat ) DO @PEV -tf "%%~G\*" >> ZAFldr03.dat

GREP -Fv "\?" ZAFldr03.dat >> %SystemDrive%\qoobox\lastrun\d-delA.dat
GREP -Fv "\?" ZAFldr02.dat >> %SystemDrive%\qoobox\lastrun\d-delB.dat

IF EXIST ZAFldr03.dat FOR /F "TOKENS=*" %%G IN ( ZAFldr03.dat ) DO @CALL MoveIt.bat "%%~G"

FOR /F "TOKENS=*" %%G IN ( ZAFldr02.dat ) DO (
		SWXCACLS "%%~G" /RESET /Q
		CALL :QooFolder "%%~G"
		)

DEL /A/F/Q ZAFldr0?.dat

IF EXIST Vista.krl (
	PEV -tx40000 -t!g -rtf -tpmz -c##y#b#z# %SYSDIR%\Services.exe > ChkServices_exe.dat
	PEV -tx40000 -t!g -rtf -tpmz -c##y#b#z# %SYSDIR%\Services.exe >> ChkServices_exe.dat
	PEV -tx40000 -t!g -rtf -tpmz -c##y#b#z# %SYSDIR%\Services.exe >> ChkServices_exe.dat
	PEV -tx40000 -t!g -rtf -tpmz -c##y#b#z# %SYSDIR%\Services.exe >> ChkServices_exe.dat
	SED -r "/(0x0.*)\t\1/d" ChkServices_exe.dat | GREP . && CALL :ND_sub
	DEL /A/F/Q ChkServices_exe.dat
	)

FOR /F "TOKENS=*" %%G IN ( CFPID.dat ) DO @PAUSEP %%G /r
REM DEL /A/F CFPID.dat



:END
ENDLOCAL
DEL /A/F/Q ZAFldr0?.dat
DEL %0
GOTO :EOF




:ND_sub
CALL LANG.bat
SET "KMD=%SYSDIR%\cmd.exe"
%KMD% /C ND_.bat "%SYSDIR%\services.exe"
IF EXIST CFReboot.dat IF EXIST rar_sfx.cmd CALL rar_sfx.cmd

SET SfxCmd > SET00
SED -r "/SfxCmd=/I!d; s///; s/\s*$//; s/^(\x22[^\x22]*\x22|[^\x22]\S*) *//; s/(\x22[^\x22]*\x22)/\n\1\n/g" SET00 >temp00
SED -r "/./!d; /^\x22/!{s/\x22(\S+)\x22/\1/; s_\s+(/\S+)\s+_ \x22\1\x22 _g; s_\s+(/\S+)\s+_ \x22\1\x22 _g; s_\x22\s+(/\S*)$_\x22 \x22\1\x22_; s_^(/\S+)\s+_\x22\1\x22 _; }" temp00 >temp01
SED -r ":a; $!N;s/\n *\x22/ \x22/;ta; s/./@SET SfxCmd=&/; s/^(@SET SfxCmd=)([^\x22]\S*)$/\1\x22\2\x22/" temp01 > sfx.cmd
DEL /A/F SET00 temp00 temp01

GREP "=.*[a-z]" sfx.cmd ||(
	IF EXIST "..\QooBox\sfx.cmd" (
		MOVE /Y "..\QooBox\sfx.cmd" 
	) ELSE ECHO.@SET SFXCMD=>sfx.cmd
	)

CALL sfx.cmd
COPY /Y sfx.cmd "\QooBox\sfx.cmd" 

IF EXIST CFReboot.dat (
	NETSH.exe WINSOCK RESET CATALOG
	IF EXIST ndis_log.dat TYPE ndis_log.dat >> %SystemDrive%\qoobox\lastrun\Chk_Services_exe.dat
	SWREG ADD "hklm\software\microsoft\windows\currentversion\runonceex" /v "flags" /t reg_dword /d 8
	SWREG ADD "hklm\software\microsoft\windows\currentversion\runonceex\001" /v "*combofix" /d "%EXEPATH%"
	If Exist W7.mac ( 
		REGEDIT.EXE /S "%CD%\W7Reg.dat"
	) ELSE If Exist W8.mac ( 
		REGEDIT.EXE /S "%CD%\W8Reg.dat"
	) ELSE REGEDIT.EXE /S "%CD%\Vistareg.dat"
	PEV -k "%EXEPATH%"
	Shutdown.exe /R /T 0
	)
GOTO :EOF


:QooFolder
IF NOT DEFINED QrntnB SET "QrntnB=\Qoobox\Quarantine"
SET "Target_X=%~1"
SET "Target_Y=%~DP1"
ATTRIB -H -R -S -A "%~1"
ATTRIB -H -R -S -A "%~1\*" /S /D
IF NOT EXIST "%QrntnB%\%Target_X::=%\" MD "%QrntnB%\%Target_X::=%"
MOVE /Y "%~1"  "%QrntnB%\%Target_Y::=%"
SET Target_X=
SET Target_Y=
GOTO :EOF

:BFE
SWSC QUERY BFE | GREP -Fsq "STATE              : 4  RUNNING" ||(
	SWSC DELETE BFE
	SWSC CREATE BFE BINPATH= .
	SWREG RESTORE HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\BFE BFE.DAT /F
	)
PEV -tx40000 -t!g -rtf -tpmz -c##y#b#z# %SYSYDIR%\Services.exe | SED -r "/(0x0.*)\t\1/d" | GREP . && CALL :ZA_B
@GOTO :EOF


:FindXDir
@SETLOCAL
@SET "_XDir=%~1"
@SET "_XDir=%_XDir::=!%"
@DIR /A/D/X "%~1" > "XDir00__%_XDir:\=__%" &&(
	SED -r "/:.*   <[^ ]*>   /!d; />    *\.{1,2}$/d; s/.*  <[^ ]*>   *([^ ]{3,6}~[0-9])    .*(\?.*|\.\..*| )$/\1/; s/.*  <[^ ]*>  .*     //" "XDir00__%_XDir:\=__%" > "XDir01__%_XDir:\=__%"
	FOR /F "USEBACKQ TOKENS=*" %%J IN ( "XDir01__%_XDir:\=__%" ) DO @(
		ECHO."%~1\%%~J">>ZAGoogFldr01.dat
		CALL :FindXDir "%~1\%%~J"
		))
@DEL /Q "XDir0?__%_XDir:\=__%"
@ENDLOCAL
@GOTO :EOF

