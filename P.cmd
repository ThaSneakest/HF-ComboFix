
IF ["%~1"]==["ZA_B"] GOTO ZA_B
IF EXIST %SystemDrive%\32788R22FWJFW\NoLaunch.dat EXIT
ECHO.> %SystemDrive%\32788R22FWJFW\NoLaunch.dat

PROMPT $
CD /D %SystemDrive%\32788R22FWJFW
SET cfExt=3XE
SET "Comspec=%CD%\cmd.%cfext%"

PEV.%cfext% RIMPORT %SystemDrive%\32788R22FWJFW\EXE.reg

IF NOT EXIST %SystemRoot%\system32\cmd.exe GOTO Not_NT


:NT
SWREG.%cfext% QUERY "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_{79007602-0CDB-4405-9DBF-1257BB3226ED}\0000\Control" /v ActiveService && CALL :MtPts
REM SWREG.%cfext% QUERY "HKLM\SYSTEM\CurrentControlSet\Enum\Root\*PNP0296\0000\Control" /v ActiveService >MtPt00 && CALL :PNP296
CALL :PNP296
IF EXIST PNP296_0? DEL /A/F/Q PNP296_0?

IF NOT EXIST W8.mac NIRCMD.%cfext% WIN CLOSE CLASS "#32770"
IF EXIST ncmd.cfxxe MOVE /Y ncmd.cfxxe ncmd.com

IF EXIST rar_sfx.cmd (
	CALL rar_sfx.cmd
	ECHO.Nsis>DisclaimED.dat
	REM DEL /A/F rar_sfx.cmd
	)
SETLOCAL

SWREG.%cfext% QUERY "HKLM\System\Currentcontrolset\Control\ProductOptions" /v ProductType > WinNT00
GREP.%cfext% -isq "ProductType.*WinNT" WinNT00 || GOTO Not_NT
DEL /A/F WinNT00 fl0.bat

SET>Set.txt
SET EXEPATH=
IF EXIST setpath_N.cmd (
	ECHO.@SET "Qrntn=%SystemDrive%\Qoobox\Quarantine">>SetPath_N.cmd
	CALL SetPath_N.cmd
	)
SET "SYSTEM=%SystemRoot%\system32"
SET "SYSDIR=%SystemRoot%\system32"
SET "ProgFiles=%ProgramFiles%"
SET "CommonProgFiles=%CommonProgramFiles%"
SET "PATHEXT=.%cfext%;%pathext%"
SET "PATH=%CD%;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\system32\wbem;"
SET "KMD=CF%random%.%cfext%"
SET "Qrntn=%SystemDrive%\Qoobox\Quarantine"
SET "CFLDR=32788R22FWJFW"
SET "Ver_CF=19-11-04.01"
ECHO.@SET "Ver_CF=%VerCF%">VerCF.bat


PEV -c##g# "%SYSDIR%\kernel32.dll" > CurVer
IF EXIST XP.mac FINDSTR -B "5.1.2" CurVer ||GOTO CompatibilityMode
IF EXIST Vista.mac FINDSTR -B "6.0.6" CurVer ||GOTO CompatibilityMode
IF EXIST W7.mac FINDSTR -B "6.1.760" CurVer ||GOTO CompatibilityMode
IF EXIST W8.mac FINDSTR -B "6.2.9200" CurVer ||GOTO CompatibilityMode
DEL CurVer

IF NOT EXIST SWREG.%cfext% COPY SWREG.exe SWREG.%cfext%
IF NOT EXIST hidec.%cfext% COPY hidec.exe hidec.%cfext%
IF EXIST SWREG.exe DEL /A/F SWREG.exe
IF EXIST hidec.exe DEL /A/F hidec.exe
HIDEC SWSC START CryptSvc

IF DEFINED CommonProgramW6432 PEV -rtd %SystemRoot%\Sysnative || IF EXIST "%SystemRoot%\SysNative\" (
	REM GOTO Not_NT REM SysWow64
	SET "System=%SystemRoot%\SysWow64"
	SET "SysNative=%SystemRoot%\SysNative"
	IF EXIST XP.mac GOTO Not_NT
	ECHO.>W6432.dat
	)

IF EXIST W6432.dat IF NOT DEFINED ProgramW6432 GOTO Not_NT
IF EXIST W6432.dat GREP -isq "processorArchitecture=.amd64." "%SysNative%\csrss.exe" || GOTO Not_NT

IF EXIST "%system%\ntcore.dll" %COMSPEC% /D /C Move "%system%\ntcore.dll" "%system%\ntcore.dll.vir"

START NIRCMD CMDWAIT 6000 EXEC HIDE PEV -k CSCRIPT.exe
IF NOT EXIST CFPID.dat CSCRIPT.exe //NOLOGO //E:VBSCRIPT //B //T:05 "%CD%\ksvchost.vbs"
PEV -k NIRCMD.%cfext%

SWREG DELETE HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Option > N_\%random% 2>&1
SWREG ADD HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\procexp90.Sys /D Driver
SWREG ADD HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\procexp90.Sys /D Driver

IF EXIST W7.mac ECHO.W7>Vista.krl
IF EXIST W8.mac ECHO.W8>Vista.krl
IF EXIST Vista.mac ECHO.Vista>Vista.krl
SETLOCAL
IF EXIST Vista.krl CALL :Vista
ENDLOCAL

IF NOT EXIST NircmdB.exe COPY /Y Nircmd.%cfext% NircmdB.exe
PEV UZIP License\pv_5_2_2.zip .\
MOVE /Y PV.exe PV.%cfext%
IF NOT EXIST PEV.exe COPY /Y PEV.%cfext% PEV.exe


SWREG QUERY "HKLM\Software\Swearware" /V LastDir | SED -r "/.*	(.:\\[^\\]*)$/!d; s//\1/" > LastDir
FOR /F "TOKENS=*" %%G IN ( LastDir ) DO @IF EXIST "%%~G\*.%cfext%" (
	PEV -tpmz -tx50000 -tf -outputtemp00 "%%~G\*.exe"
	GREP -c . temp00 | GREP -Esqx "[4-8]" && RD /S/Q "%%~G" 
	DEL temp00
	)


FOR /F %%G IN ( md5sum00.pif ) DO @SET "Chksum=%%~G"
DEL /A/F md5sum00.pif LastDir
IF NOT EXIST %SystemDrive%\Qoobox\Quarantine\Registry_backups MD %SystemDrive%\Qoobox\Quarantine\Registry_backups

DEL /A/F/Q temp0* OriPath* ksvchost.vbs

PEV -outputtemp00 -rtf -c:##5# .\* and { License.exe or %CFLDR%.exe or WinNT.exe or N_.exe } &&(
	PV -o%%f * > temp01
	PEV -tx50000 -tf -t!o -files:temp01 -c:##5#b#f# -output:temp02
	GREP -Fif temp00 temp02 > temp03
	SED "/.*	/!d; s///" temp03 > temp04
	SED  ":a; $!N; s/\n/\x22 \x22/; ta; s/.*/\x22&\x22/" temp04 > temp05
	FOR /F "TOKENS=*" %%G IN ( temp05 ) DO @NIRCMD KILLPROCESS %%G
	)

DEL /A/F/Q temp0* pv.txt

CALL LANG.bat
IF NOT EXIST %SystemRoot%\System32\sfc.dll GOTO NOSFC

SWREG QUERY hklm\system\currentcontrolset\enum\root\system ||@(
	REM NIRCMD infobox "You need Administrative privileges to run this tool" "Not Admin !!"
	NIRCMD INFOBOX "%Line3%" ""
	GOTO END
	EXIT
	)


IF NOT EXIST DisclaimED.dat SET SfxCmd | GREP -Fisq "/NoDisclaimer" ||CALL :DISCLAIMER
MOVE /Y Nir.PIF NIRKMD.%cfext%
SWSC DELETE MBR
RMBR -u

HANDLE -p System >temp00
GREP -Fic "%system%\drivers\volsnap.sys" temp00 | GREP -E "^[5-9]$|.." >Volsnap_Handles00 2>&1 &&(
	CATCHME -l NULL -i"%system%\drivers\volsnap.sys"
	)|| DEL Volsnap_Handles00
DEL temp00

IF EXIST %systemdrive%\Qoobox\BackEnv\ SWXCACLS %systemdrive%\Qoobox\BackEnv /RE:F /Q
IF EXIST %systemdrive%\Qoobox\BackEnv\VikPev00 (
	COPY /Y %systemdrive%\Qoobox\BackEnv\VikPev00
	PEV -loadlineVikPev00
	)
	
CALL :MDCheck

IF NOT DEFINED sfxname GOTO END


SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /RESET /Q
SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" /RESET /Q
IF NOT EXIST W6432.dat (
	SWREG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" > temp00
	SED -r "/^   (aux|midi|mixer|wave)([1-9]	|	).*\\/I!d; s/%%SystemRoot%%/%systemroot:\=\\%/I; s/.*\t//; s/(\.(old|dat|bak|tmp)) [0-9][a-z][A-Z]{8}$/\1/" temp00 > temp01
	GREP -F \ temp01 && CALL :Aux
	)
DEL /A/F/Q temp0? dnl.dat Nircmd.chm Set.txt



IF NOT EXIST Vista.krl CALL RKEY.cmd RKEYB 

SWREG QUERY "hklm\software\microsoft\windows\currentversion\app paths\combofix.exe" /ve > Oldsfxname00
SWREG ADD "hklm\software\microsoft\windows\currentversion\app paths\combofix.exe" /ve /d "%sfxname%"
SWREG QUERY "hklm\software\microsoft\windows nt\currentversion\winlogon" /v Userinit > Userinit00
GREP -Fi "%SysDir%\userinit.exe" Userinit00 ||SWREG ADD "hklm\software\microsoft\windows nt\currentversion\winlogon" /v Userinit /d "%SysDir%\userinit.exe,"
DEL /A/F Userinit00


SET SfxCmd > SET00
SED -r "/SfxCmd=/I!d; s///; s/\s*$//; s/^(\x22[^\x22]*\x22|[^\x22]\S*) *//; s/(\x22[^\x22]*\x22)/\n\1\n/g" SET00 >temp00
SED -r "/./!d; /^\x22/!{s/\x22(\S+)\x22/\1/; s_\s+(/\S+)\s+_ \x22\1\x22 _g; s_\s+(/\S+)\s+_ \x22\1\x22 _g; s_\x22\s+(/\S*)$_\x22 \x22\1\x22_; s_^(/\S+)\s+_\x22\1\x22 _; }" temp00 >temp01
SED -r ":a; $!N;s/\n *\x22/ \x22/;ta; s/./@SET SfxCmd=&/; s/^(@SET SfxCmd=)([^\x22]\S*)$/\1\x22\2\x22/" temp01 > sfx.cmd
DEL /A/F SET00 temp00 temp01


FOR %%G IN ( ATTRIB CSCRIPT PING ROUTE ) DO @IF NOT EXIST %%G.%cfext% IF EXIST W6432.dat (
	SWXCACLS %SysNative%\%%G.exe /P /GA:F /GS:F /GU:X /GP:X /I ENABLE /Q
	COPY /Y /B %SysNative%\%%G.exe %%G.%cfext%
	) ELSE (
	SWXCACLS %system%\%%G.exe /P /GA:F /GS:F /GU:X /GP:X /I ENABLE /Q
	COPY /Y /B %system%\%%G.exe %%G.%cfext%
	)
	

ECHO."%SFXNAME%">MSName00
GREP -Ei "\\(wscntfy|winlogon|wininit|nvsvc|lsm|lsass|iexplore|svchost|spoolsv|smss|slsvc|services|explorer|ctfmon|csrss|alg)\.....$" MSName00 &&(
	CALL :MSNAME "%SFXNAME%"
	ECHO.@ECHO.>> MsName.bat
	CALL MsName.bat
	)
GREP -Ei "\\uninstall\.....$" MSName00 &&ECHO.="/uninstall">sfx.cmd
GREP -Ei "\\NoMbr\.....$" MSName00 && ECHO..>NoMbr.dat
GREP -Ei "\\iexplore\.exe.$" MSName00 &&(
	%ComSpec% /C Kill-All.cmd
	DEL /A/F Kill-All.cmd
	)>N_\Kill-All 2>&1
SED -r "/.*\\CF@C([1-9][0-9])M([1-9])\.....$/I!d; s//\1\t\2/" MSName00 | GREP . > SearchDateRange.dat || DEL /A/F SearchDateRange.dat
DEL MSName00


PEV -tf -tpmz -t!o %Systemroot%\Installer\*000*.? -preg"%Systemroot:\=\\%\\Installer\\\{[^\\]*\}\\U\\[^\\]*\..$" > ZAFldr00.dat && IF EXIST W6432.dat (
		%SysNative%\cmd.exe /C "%~0" ZA_B
		) ELSE CALL :ZA_B
		
FOR %%G IN (
%SystemDrive%\$RECYCLE.bin
%SystemDrive%\RECYCLER
%SystemDrive%\RECYCLED
) DO @IF EXIST %%G\ (
	SWXCACLS %%G\* /GA:F /S /Q
	PEV -tf -tpmz -t!o %%G\*000*.? -preg"\\U\\[^\\]*\..$" >> ZAFldr00.dat && IF EXIST W6432.dat (
		%SysNative%\cmd.exe /C "%~0" ZA_B
		) ELSE CALL :ZA_B
	)

FOR %%G IN (
%SystemDrive%\$RECYCLE.bin
%SystemDrive%\RECYCLER
%SystemDrive%\RECYCLED
) DO @IF EXIST %%G\ RD /S/Q %%G


DEL /A/F/Q ZAFldr0?.dat

ATTRIB +R "%sfxname%"



GREP "=.*[a-z]" sfx.cmd ||(
	IF EXIST "..\QooBox\sfx.cmd" (
		MOVE /Y "..\QooBox\sfx.cmd" 
	) ELSE ECHO.@SET SFXCMD=>sfx.cmd
	)
CALL sfx.cmd

GREP -Eisq "=.\/NoMbr| .\/NoMbr. | .\/NoMbr.$" sfx.cmd && ECHO..>NoMbr.dat
GREP -Eisq "\\CFScript[^:\/\\]*$" sfx.cmd &&(
	TYPE %sfxcmd% | GREP -Fixsq "NoMbr::"  && ECHO..>NoMbr.dat
	)

(
ECHO.@SET "Ver_CF=%Ver_CF%"
ECHO.@SET "cfExt=%cfExt%"
ECHO.@SET SfxCmd=%SfxCmd%
ECHO.@SET "SfxName=%SfxName%"
ECHO.@SET "PathExt=%PathExt%"
ECHO.@SET "KMD=%KMD%"
ECHO.@SET "ChkSum=%ChkSum%"
)>>VerCF.bat

IF EXIST CFPID.dat ( DEL /A/F CFPID.dat ) ELSE CALL AV.cmd


PEV -k * -preg"\\((ntvdm|teatimer[^\\]*|ad-watch[^\\]*|SZServer|StopZilla[^\\]*|userinit|procmon|txp1atform|SonndMan|ANDRE|TOLO|jalang|jalangkung|jantungan|DOSEN|C3W3K4MPUS)\.exe)$"


GREP -Fx "REGEDIT4" Fin.dat ||(
	ECHO.>"%temp%\tdsstdss"
	PEV -output:temp00 -rtf "%temp%\tdsstdss" ||(
		ECHO.>wtf_tdssserv
		CALL c.bat
		GOTO END
		)
	@DEL /A/F "%temp%\tdsstdss"
	GOTO AbortD
	)


IF /I "%cd%" NEQ "%SystemDrive%\%cfldr%" GOTO Abort
IF EXIST "%temp%\%cfldr%%cfldr%.log" DEL /A/F "%temp%\%cfldr%%cfldr%.log"
IF EXIST "%SystemDrive%\ComboFix" DEL /A/F/Q "%SystemDrive%\ComboFix"


FOR /F "TOKENS=*" %%G IN ("%sfxname%") DO (
	SET "FileName=%%~NG"
	SET "FilePath=%%~DPG"
	)


SET FileName > FileName

GREP -ix "FileName=[-[:alnum:]@_.]*" FileName || GOTO AbortB
DEL /A/F FileName

DIR /AD/B %SystemDrive%\* > DirName00
GREP -ivx ComboFix DirName00 > DirName01
GREP -Fisqx "%FileName%" DirName01 && CALL :NameChk
IF EXIST DirName0? DEL /A/F/Q DirName0?
IF EXIST Oldsfxname00 DEL /A/F Oldsfxname00


IF EXIST "%SystemDrive%\%FileName%\" RD "%SystemDrive%\%FileName%"
IF EXIST "%SystemDrive%\%FileName%\" (
	SWXCACLS "%SystemDrive%\%FileName%" /RESET /Q
	RD /S/Q "%SystemDrive%\%FileName%"
	IF EXIST "%SystemDrive%\%FileName%\" (
		PEV -k "%SystemDrive%\%FileName%\*"
		RD /S/Q "%SystemDrive%\%FileName%"
		)
	IF EXIST "%SystemDrive%\%FileName%\" (
		HANDLE "%SystemDrive%\%FileName%" > temp00
		SED -R "/.* pid: (\d*) +(\S*):.*/I!d;s//@Handle -c \2 -y -p \1/" temp00 > temp00.bat
		ECHO.@ECHO.>> temp00.bat
		CALL temp00.bat
		DEL /A/F temp00.bat temp00
		RD /S/Q "%SystemDrive%\%FileName%"
		))


IF EXIST "%SystemDrive%\%FileName%\" RD /S/Q "%SystemDrive%\%FileName%"
IF EXIST "%SystemDrive%\%FileName%\" GOTO :EOF
PEV UZIP "License\streamtools.zip" License &&MOVE /Y License\SF.exe
GREP -Eisq "=.\/uninstall| .\/uninstall. | .\/uninstall.$" sfx.cmd && IF EXIST MsName.bat (ECHO.@SET SfxCmd=>sfx.cmd) ELSE echo..>ItsBeenPhun
DEL /A/F/Q No*Launch.dat MsName.bat

IF EXIST Firefox.exe DEL /A/F Firefox.exe
MD "%SystemDrive%\%FileName%"
IF EXIST MUI FOR /F "TOKENS=*" %%G IN ( MUI ) DO @(
	MD "%SystemDrive%\%FileName%\%%~G"
	COPY /Y /B "%%~G\*" "%SystemDrive%\%FileName%\%%~G\" 
	)

IF EXIST W6432.dat COPY /Y /B "%SysNative%\cmd.exe" "%SystemDrive%\%FileName%\%KMD%"
IF NOT EXIST "%SystemDrive%\%FileName%\%KMD%" COPY /Y /B cmd.%cfext% "%SystemDrive%\%FileName%\%KMD%"

SET "COMSPEC=%SystemDrive%\%FileName%\%KMD%"

@(
ECHO.@SET "Ver_CF=%Ver_CF%"
ECHO.@SET "cfExt=%cfExt%"
ECHO.@SET SfxCmd=%SfxCmd%
ECHO.@SET "SfxName=%SfxName%"
ECHO.@SET "PathExt=%PathExt%"
ECHO.@SET "KMD=%KMD%"
ECHO.@SET "ChkSum=%ChkSum%"
ECHO.@SET "ComSpec=%ComSpec%"
)>>VerCF.bat

IF NOT EXIST Vista.krl IF EXIST XP.mac SWREG QUERY HKLM\SYSTEM\CurrentControlSet\Services\iphlpsvc && SWREG QUERY HKLM\SYSTEM\CurrentControlSet\Services\tdx &&(
	SWSC DELETE iphlpsvc
	SWREG ACL "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IPHLPSVC" /OA
	SWREG ACL "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IPHLPSVC" /GE:F /Q
	SWREG DELETE "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IPHLPSVC"
	TYPE UndoW7_XP.dat >> CregC.dat
	PEV RIMPORT UndoW7_XP.dat
	ECHO.>CFReboot.dat
	)
DEL /A/F UndoW7_XP.dat

PEV -rtf -s=0 "%SystemRoot%\erdnt\Hiv-backup\*" && RD /S/Q "%SystemRoot%\erdnt\Hiv-backup" 

IF EXIST W32BDiag.dat (
	SWXCACLS PV.%cfext% /P /GE:F /Q
	SWXCACLS PEV.%cfext% /P /GE:F /Q
	)

(
ECHO.PEV -k * -preg"\\(cmd\.exe|cmd\.%cfext%|Nircmd\.%cfext%)$"
ECHO.IF EXIST %cd%\Start_dat EXIT
ECHO.ECHO.^>%cd%\Start_dat
ECHO.ATTRIB -H -S "%cd%\*"
ECHO.MOVE /Y "%cd%\*" "%SystemDrive%\%FileName%"
ECHO.RD /S/Q "%cd%"
IF EXIST "%SystemDrive%\%cfldr%.0.tmp\" ECHO.RD /S/Q "%SystemDrive%\%cfldr%.0.tmp"
IF EXIST "%~dp0ItsBeenPhun" ECHO."%SystemDrive%\%FileName%\NIRCMD.%cfext%" EXEC2 HIDE "%SystemDrive%\%FileName%" "%comspec%" /c c.bat
IF NOT EXIST "%~dp0ItsBeenPhun" ECHO.START "." /d"%SystemDrive%\%FileName%" "%comspec%" /k c.bat
ECHO.DEL /A/F %SystemDrive%\Start_.cmd %SystemDrive%\Bug.txt
)>..\Start_.cmd

PEV -k SWSC.%cfext%
CD ..

SWREG ADD "HKLM\Software\Swearware" /V LastDir /D "%SystemDrive%\%FileName%"

START /I /B HIDEC "%COMSPEC%" /F:OFF /D /C %SystemDrive%\Start_.cmd
PEV WAIT 2000

IF EXIST c.bat START /I /B NIRCMD EXEC HIDE "%COMSPEC%" /F:OFF /D /C %SystemDrive%\Start_.cmd
PEV WAIT 2000

IF EXIST c.bat START /I /B "%COMSPEC%" /F:OFF /D /C %SystemDrive%\Start_.cmd

DEL /A/F %0
EXIT

:VISTA
CALL RKEY.cmd
:: IF EXIST W6432.dat SET "System=%SysNative%"

SWSC QUERY BFE | GREP -Fsq "STATE              : 4  RUNNING" ||(
	SWSC DELETE BFE
	SWSC CREATE BFE BINPATH= .
	SWREG RESTORE HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\BFE BFE.DAT /F
	PEV -tx40000 -t!g -rtf -tpmz -c##y#b#z# %SysNative%\Services.exe | SED -r "/(0x0.*)\t\1/d" | GREP . && IF EXIST W6432.dat (
		%SysNative%\cmd.exe /C "%~0" ZA_B
		) ELSE CALL :ZA_B
		)
		
SWREG ADD "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Persisted" /V "%SFXNAME%" /T REG_DWORD /D 1
:: FIND LOCAL MUI STORAGE

SWREG QUERY "HKCU\Control Panel\Desktop\MuiCached" /v "MachinePreferredUILanguages" > MUI00
SWREG QUERY "HKCU\Control Panel\International" /v LocaleName >> MUI00
SED.%cfext% -r "/.*	/!d; s///; s/(\\0)*$//; s/\\0/\n/g" MUI00 | SED.%cfext% -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" > MUI
GREP.%cfext% -Fsqix en-US MUI || ECHO.en-US>>MUI
CALL :MUI1
IF NOT EXIST cmdMui00 CALL :MUI2

FOR /F "TOKENS=*" %%G IN ( MUI ) DO @(
	IF NOT EXIST "%%~G\" MD "%%~G"
	FOR %%H IN ( ATTRIB CSCRIPT PING ROUTE REGT CMD %KMD:~0,-4% ) DO @IF NOT EXIST "%CD%\%%~G\%%H.%cfext%.mui" (
		IF NOT EXIST MuiSubst.dat PEV -limit1 -rtf -sasize "%CD%\%%~G\*.%cfext%.mui" > MuiSubst.dat
		FOR /F "TOKENS=*" %%I IN ( MuiSubst.dat ) DO @COPY /Y "%%I" "%CD%\%%~G\%%H.%cfext%.mui"
		))

DEL /A/F/Q MUI0? cmdMui00 MuiSubst.dat
GOTO :EOF

:MUI1
FOR /F "TOKENS=*" %%G IN ( MUI ) DO @IF NOT EXIST "%%~G\" MD "%%~G"
FOR /F "TOKENS=*" %%G IN ( MUI ) DO @(
	FOR %%H IN ( ATTRIB CSCRIPT PING ROUTE ) DO @IF EXIST "%system%\%%~G\%%H.exe.mui" IF NOT EXIST "%CD%\%%~G\%%H.%cfext%.mui" (
		COPY /Y "%system%\%%~G\%%H.exe.mui" "%CD%\%%~G\%%H.%cfext%.mui"
		)
	IF NOT EXIST "%CD%\%%~G\REGT.%cfext%.mui" IF EXIST "%SystemRoot%\%%~G\Regedit.exe.mui" COPY /Y "%SystemRoot%\%%~G\Regedit.exe.mui" "%CD%\%%~G\REGT.%cfext%.mui"
	IF NOT EXIST "%CD%\%%~G\cmd.%cfext%.mui" IF EXIST "%system%\%%~G\cmd.exe.mui" (
		ECHO."%system%\%%~G\cmd.exe.mui" > cmdMui00
		SWXCACLS.%cfext% "%system%\%%~G\cmd.exe.mui" /OA /Q
		SWXCACLS.%cfext% "%system%\%%~G\cmd.exe.mui" /P /GA:F /GS:F /GP:X /GU:X /Q
		COPY /Y "%system%\%%~G\cmd.exe.mui" "%CD%\%%~G\cmd.%cfext%.mui"
		COPY /Y "%system%\%%~G\cmd.exe.mui" "%CD%\%%~G\%KMD%.mui"
		SWXCACLS.%cfext% "%system%\%%~G\cmd.exe.mui" /g SID#S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464:f /GA:X /GS:X /GP:X /GU:X /Q
		SWXCACLS.%cfext% "%system%\%%~G\cmd.exe.mui" /o SID#S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464 /Q
		))

FOR /F "TOKENS=*" %%G IN ( MUI ) DO @IF /I "%%G" NEQ "en-US" (
	FOR %%H IN ( ATTRIB CSCRIPT PING ROUTE REGT CMD %KMD:~0,-4% ) DO @IF NOT EXIST "%CD%\%%~G\%%H.%cfext%.mui" IF EXIST "%CD%\en-US\%%H.%cfext%.mui" COPY /Y "%CD%\en-US\%%H.%cfext%.mui" "%CD%\%%~G\%%H.%cfext%.mui"
		)

FOR /F "TOKENS=*" %%G IN ( MUI ) DO @IF NOT EXIST cmdMui00 IF EXIST "%%~G\cmd.%cfext%.mui" ECHO."%%~G\cmd.%cfext%.mui" > cmdMui00
GOTO :EOF


:MUI2	
HANDLE.%cfext% svchost.exe.mui > MUI00
HANDLE.%cfext% lsm.exe.mui >> MUI00
SED.%cfext% -r "/.*%SYSDIR:\=\\%\\(..-..)\\[^\\]*$/I!d; s//\1/" MUI00 | SED.%cfext% -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" > MUI
GOTO MUI1
GOTO :EOF


:NameChk
SET "FileName=%FileName%%random%%FileName:~0,1%"
IF EXIST "%SystemDrive%\%Filename%\" GOTO :NameChk
GOTO :EOF

FOR %%G IN ("%allusersprofile%\..") DO ECHO.%%~NG>DirName03

(
ECHO.%systemroot:~3%
ECHO.%ProgFiles:~3%
ECHO,Program Files
ECHO.Recycler
ECHO.$Recycle.Bin
ECHO.cmdcons
ECHO.Documents and Settings
ECHO.QooBox
ECHO.System Volume Information
ECHO.MSOCache
ECHO.NVIDIA
ECHO.PerfLogs
ECHO.ProgramData
ECHO.symbols
ECHO.Users
ECHO.Windows
)>>DirName03

IF EXIST W6432.dat ECHO,Program Files (x86)>>DirName03


GREP -Fix "%FileName%" DirName03 &&GOTO AbortB

IF EXIST "%SystemDrive%\%FileName%\*.%cfext%" GOTO :EOF
IF EXIST "%SystemDrive%\%FileName%\Combo-Fix.sys" GOTO :EOF
IF EXIST "%SystemDrive%\%FileName%\Creg.dat" GOTO :EOF
PEV -tx50000 -tf "%SystemDrive%\%FileName%\*" -output:DirName04
GREP -sq .  DirName04 || GOTO :EOF
IF EXIST Oldsfxname00 FOR /F "SKIP=5 TOKENS=*" %%G IN ( Oldsfxname00 ) DO IF /I "%%~NG" EQU "%FileName%" IF EXIST "..\%%~NG\N_\" GOTO :EOF


:AbortB
DEL /A/F/Q DirName0?
CALL :MSNAME "%SFXNAME%"
:: CALL NircmdB.exe infobox "You cannot rename ComboFix as %%FileName%%~n~nPlease use another name, preferably made up of alphanumeric characters" ""
CALL NircmdB.exe INFOBOX "%LINE67%" ""
GOTO END


:Abort
IF EXIST "%temp%\%cfldr%%cfldr%.log" GOTO AbortC
SWREG DELETE "HKCU\Software\WinRAR SFX"
SWREG DELETE "HKLM\Software\WinRAR SFX"
ECHO. > "%temp%\%cfldr%%cfldr%.log"
START "." "%sfxname%" %sfxcmd%
GOTO END


:AbortC
:: NircmdB.exe infobox "%cd% not in expected location~n~n       Inform sUBs now!!" ""
CALL NircmdB.exe INFOBOX "%LINE68%" ""

:END
CALL RKEY.cmd
IF EXIST "%SystemRoot%\system32\cmd.%cfext%" MOVE /Y "%SystemRoot%\system32\cmd.%cfext%" "%temp%"
CD ..
IF DEFINED cfldr START NIRCMD CMDWAIT 200 EXECMD " DEL /A/F Bug.txt && RD /S/Q "%cfldr%" "
IF NOT DEFINED cfldr START NIRCMD CMDWAIT 200 EXECMD DEL /A/F Bug.txt
EXIT

:CompatibilityMode
START Nircmd.%cfext% infobox "Warning!!~n~nDo not run ComboFix in Compatibility Mode.~nDoing so may damage the machine." "Warning - Compatibility Mode"
GOTO END


:Not_NT
CALL RKEY.cmd
CLS
CHCP 1252

START Nircmd.%cfext% infobox "Incompatible OS.~n~nOS incompatible.~n~nOS niet compatibel.~n~nInkompatibles Betriebssystem.~n~nKäyttöjärjestelmä ei ole yhteensopiva.~n~nSistema Operativo Incompat¡vel.~n~nSO. Incompatible.~n~nOS Incompatibile." "Error"

GOTO :EOF
EXIT



:AbortD
:: Start NircmdB.exe infobox "Interference detected~n~nPlease perform a Rootkit Scan" "Abort!"
START NircmdB.exe INFOBOX "%LINE66%" ""
GOTO END


:Aux
SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" /da:r /q
PEV -filestemp01 -tx50000 -tf -c##f#b#d#i#k#g# | SED "/	------------------------$/!d; s///" > temp02
FOR /F "TOKENS=*" %%G IN ( temp02 ) DO @GREP -Elsqf dnl.dat %%~SG &&(
	IF NOT EXIST CatchDeny ECHO.%%~SG>CatchDeny
	ECHO.%%~SG>>d-del_A.dat
	CALL Catch-sub.cmd "%%~SG"
	CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -i %%~SG
	CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -E %%~SG
	ECHO..>CFReboot.dat
	)

SWREG EXPORT "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E96C-E325-11CE-BFC1-08002BE10318}" temp03 /nt4
SED -R "/\\{4D36E96C-E325-11CE-BFC1-08002BE10318\}\\\d*\\Drivers\\(wave|aux|midi|mixer)\\[^\\]*$/I,/^$/!d; /^\x22(Alias|Driver)\x22|^$/I!d; s/^.Alias.=//I; s/.*=/=/" temp03 > temp04
ECHO.[HKEY_LOCAL_MACHINE\software\microsoft\windows nt\currentversion\drivers32]>> CregC.dat
SED -r "/^   (aux|midi|mixer|wave)([1-9]	|	)/I!d; s/^ +([^	]*)	.*/\x22\1\x22=-/;" temp00 >> CregC.dat
SED -r "/./{$!N;s/\n//; s/^(=\x22[^\x22]*\x22)(\x22.*)/\2\1/}; /./!d" temp04 >> CregC.dat
SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" /RESET /Q
PEV RIMPORT CregC.dat
GOTO :EOF


:MDCheck
DEL /A/F md5sum00.pif
REM PEV -rtf -md5%ChkSum% .\md5sum.pif ||(PEV -rtf -md5%ChkSum% .\md5sum.pif || CALL :MDFaiL ChkSum_Fail )
PEV -tx50000 -tf -files:files.pif -c:##5#b#f# -output:mdCheck00.dat
GREP -vs "^!" mdCheck00.dat > mdCheck0a.dat
GREP -Fvf md5sum.pif mdCheck0a.dat > mdCheck01.dat
GREP -sq . mdCheck01.dat &&CALL :MDFaiL
DEL /A/F/Q mdCheck0?.dat
GOTO :EOF


:MDFail
:: NIRCMD INFOBOX "!! ALERT !! It is NOT SAFE to continue!~n~nThe contents of the ComboFix package has been compromised.~nPlease download a fresh copy from:~n~nhttp://www.bleepingcomputer.com/combofix/how-to-use-combofix~n~nNote: You may be infected with a file patching virus 'Virut'" "Error"
ECHO.>File_Infector_is_present.dat
NIRCMD INFOBOX "%Line80%" ""
:: NIRCMD QBOXCOMTOP "!! ALERT !! It is NOT SAFE to continue!~n~nThe contents of the ComboFix package has been compromised.~nYou may be infected with a file patching virus 'Virut'~n~nPlease download a fresh copy from:~nhttp://www.bleepingcomputer.com/combofix/how-to-use-combofix~n~nClick 'Yes' to exit (recommended)~nClick 'No' to proceed at own risk (dangerous)" "Error" "" RETURNVAL 1 &&GOTO :EOF
IF EXIST "%sfxname%" IF NOT EXIST "%sfxname%\" DEL /A/F "%sfxname%"
IF DEFINED EXEPATH IF EXIST "%EXEPATH%" IF NOT EXIST "%EXEPATH%\" DEL /A/F "%EXEPATH%"
:: CALL Kollect.bat P.cmd %1
GOTO END
GOTO :EOF


:MsName
IF EXIST "%~DP1ComboFix.exe" DEL /A/F "%~DP1ComboFix.exe"
ATTRIB -H -R -S "%SFXNAME%"
REN "%SFXNAME%" ComboFix.exe
ECHO.SET "SFXNAME=%~DP1ComboFix.exe">MsName.bat
SWREG ADD "hklm\software\microsoft\windows\currentversion\app paths\combofix.exe" /ve /d "%~DP1ComboFix.exe"
GOTO :EOF


:Disclaimer
SWREG QUERY HKLM\Software\Swearware /v combofix_wow > CFVersionOld00 ||ECHO.>NewCFUser
SED "/.*	/!d; s/// " CFVersionOld00 > CFVersionOld
DEL /A/F CFVersionOld00
FOR /F "TOKENS=*" %%G IN ( CFVersionOld ) DO @IF "%%G" GEQ "%ver_CF%" GOTO :EOF

NIRCMD LOOP 2 80 BEEP 3000 200
ECHO.>AbortP
NIRCMDC QBOXCOMTOP  "%DISCLAIMER%" "" FILLDELETE AbortP
IF EXIST AbortP GOTO END
SWREG ADD HKLM\Software\Swearware /v combofix_wow /d "%ver_CF%"
DEL /A/F AbortB
ECHO."%username%">DisclaimED.dat
GOTO :EOF

:PNP296
SWREG.%cfext% QUERY "HKLM\SYSTEM\CurrentControlSet\Enum\Root" > PNP296_00
GREP.%cfext% -Eix "HKEY_.*\\root\\\*PNP[^\\]*" PNP296_00 > PNP296_01
FOR /F "TOKENS=*" %%G IN ( PNP296_01 ) DO @SWREG.%cfext% QUERY "%%~G\0000\Control" /V ActiveService >> PNP296_02
IF EXIST PNP296_02 GREP.%cfext% -B1 -Eix "  *ActiveService	.*	(.{4}[0-9a-f]{4}|[0-9]{10,})" PNP296_02 > PNP296_03 &&(
	SED.%cfext% -r "/HKEY.*\\Root\\([^\\]*)\\.*|.*\t(.*)/I!d; s//\1\2/" PNP296_03 >> zhsvc.dat
	SED.%cfext% -r "/(HKEY.*\\Root\\[^\\]*)\\.*/I!d; s//\1/" PNP296_03 >PNP296_04
	ECHO.::>Files.pif
	FOR /F "TOKENS=*" %%G IN ( PNP296_04 ) DO @(
		SWREG.%cfext% ACL "%%~G" /OA /Q
		SWREG.%cfext% ACL "%%~G\0000" /RESET /Q
		SWREG.%cfext% ACL "%%~G" /GA:F /Q
		SWREG.%cfext% DELETE "%%~G"
		)
	GOTO MtPts
	)
GOTO :EOF

:MtPts
PEV.%cfext% RemMtPts
SWXCACLS.%cfext% "%CD%" /RESET /Q
ECHO.>W32Diag.dat
GOTO :EOF

:PNP296_
SED.%cfext% -r "/.*\t(.{4}[0-9a-f]{4})$/!d; s//%systemroot:\=\\%\\System32\\drivers\\\1.sys/" MtPt00 > W32BDiag.dat
ECHO.:::::>> W32BDiag.dat
PEV.%cfext% -filesW32BDiag.dat -t!o -t!g -c##f#b#d#i#k# | SED.%cfext% -r "/\t-{18}$/!d; s///" | MTEE.%cfext% W32B_Diag.dat >>d-del_A.dat
SWXCACLS.%cfext% "%CD%" /RESET /Q
GOTO :EOF

:NOSFC
NIRCMD beep 3000 200
:: NIRCMD infobox "%SystemRoot%\system32\sfc.dll is missing~n~nCopy one from another machine and reboot once" "Terminal Error - Missing file"
NIRCMD INFOBOX "%LINE102%" ""
CD \
NIRCMD EXECMD RD /S/Q "%~DP0"
EXIT


:ZA_B
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

SET "PATHEXT=.%cfext%;%pathext%"
SET "PATH=%CD%;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\system32\wbem;"
SET "Qrntn=%SystemDrive%\Qoobox\Quarantine"

IF NOT EXIST %SystemDrive%\Qoobox\Quarantine\Registry_backups\ MD %SystemDrive%\Qoobox\Quarantine\Registry_backups
IF NOT EXIST %SystemDrive%\Qoobox\LastRun MD %SystemDrive%\Qoobox\LastRun

REGSVR32.EXE /S %Systemroot%\System32\wbem\wbemess.dll

IF EXIST XP.mac (
	PEV EXEC /S CSCRIPT.exe //NOLOGO //E:VBSCRIPT //B //T:15 "%~DP0KNetSvcs.vbs"
	PV -kf svchost.exe -l"*netsvcs*"
	PEV -k Explorer.exe
	PEV -k alg.exe
	PEV RIMPORT xpreg.dat
	)
	
PEV -tf -tpmz -t!o %Systemroot%\Installer\*000*.? -preg"%Systemroot:\=\\%\\Installer\\\{[^\\]*\}\\U\\[^\\]*\..$" >> ZAFldr00.dat
SED -r "/\\U\\[^\\]*\..$/I!d; s///" ZAFldr00.dat > ZAFldr01.dat

SETPATH > TempPath.bat
ECHO.@>>TempPath.bat
CALL TempPath.bat
DEL /A/F TempPath.bat

IF DEFINED APPDATA PEV -tf -tpmz -t!o "%APPDATA%\?" -preg"%APPDATA:\=\\%\\\{[^\\]*\}\\.$" | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat
IF DEFINED LOCALAPPDATA PEV -tf -tpmz -t!o "%LOCALAPPDATA%\?" -preg"%LOCALAPPDATA:\=\\%\\\{[^\\]*\}\\.$" | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat

FOR %%G IN (
%SystemDrive%\$RECYCLE.bin
%SystemDrive%\RECYCLER
%SystemDrive%\RECYCLED
) DO @IF EXIST %%G\ (
	PEV -tf -tpmz -t!o %%G\?  | SED -r "s/\\[^\\]*$//" >> ZAFldr01.dat
	)
	
SORT  ZAFldr01.dat | SED -r "$!N; /^(.*)\n\1$/I!P; D" >  ZAFldr02.dat
FOR /F "TOKENS=*" %%G IN ( ZAFldr02.dat ) DO @PEV -tf "%%~G\*" >> ZAFldr03.dat

TYPE ZAFldr03.dat >> %SystemDrive%\qoobox\lastrun\d-delA.dat
TYPE ZAFldr02.dat >> %SystemDrive%\qoobox\lastrun\d-delB.dat

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

ENDLOCAL
DEL /A/F/Q ZAFldr0?.dat
GOTO :EOF


:ND_sub
CALL LANG.bat
@SET "KMD=%SYSDIR%\cmd.exe"
@%KMD% /D /C ND_.bat "%SYSDIR%\services.exe"

IF EXIST CFReboot.dat IF NOT EXIST sfx.cmd IF EXIST rar_sfx.cmd CALL rar_sfx.cmd

IF NOT EXIST sfx.cmd (
	SET SfxCmd > SET00
	SED -r "/SfxCmd=/I!d; s///; s/\s*$//; s/^(\x22[^\x22]*\x22|[^\x22]\S*) *//; s/(\x22[^\x22]*\x22)/\n\1\n/g" SET00 >temp00
	SED -r "/./!d; /^\x22/!{s/\x22(\S+)\x22/\1/; s_\s+(/\S+)\s+_ \x22\1\x22 _g; s_\s+(/\S+)\s+_ \x22\1\x22 _g; s_\x22\s+(/\S*)$_\x22 \x22\1\x22_; s_^(/\S+)\s+_\x22\1\x22 _; }" temp00 >temp01
	SED -r ":a; $!N;s/\n *\x22/ \x22/;ta; s/./@SET SfxCmd=&/; s/^(@SET SfxCmd=)([^\x22]\S*)$/\1\x22\2\x22/" temp01 > sfx.cmd
	DEL /A/F SET00 temp00 temp01
	)

GREP "=.*[a-z]" sfx.cmd ||(
	IF EXIST "..\QooBox\sfx.cmd" (
		MOVE /Y "..\QooBox\sfx.cmd" 
	) ELSE ECHO.@SET SFXCMD=>sfx.cmd
	)

CALL sfx.cmd
COPY /Y sfx.cmd "\QooBox\sfx.cmd" 
	
@IF EXIST CFReboot.dat (
	NETSH.exe WINSOCK RESET CATALOG
	NIRCMD INFOBOX "%Line10A%" ""
	IF EXIST ndis_log.dat TYPE ndis_log.dat >> %SystemDrive%\qoobox\lastrun\Chk_Services_exe.dat
	SWREG ADD "hklm\software\microsoft\windows\currentversion\runonceex" /v "flags" /t reg_dword /d 8
	SWREG ADD "hklm\software\microsoft\windows\currentversion\runonceex\001" /v "*combofix" /d "%EXEPATH%"
	If Exist W7.mac ( 
		REGEDIT.EXE /S "%CD%\W7Reg.dat"
	) ELSE If Exist W8.mac ( 
		REGEDIT.EXE /S "%CD%\W8Reg.dat"
	) ELSE REGEDIT.EXE /S "%CD%\Vistareg.dat"
	SHUTDOWN.EXE /R /T 0
	)
@GOTO :EOF


:QooFolder
@IF NOT DEFINED QrntnB SET "QrntnB=\Qoobox\Quarantine"
@SET "Target_X=%~1"
@SET "Target_Y=%~DP1"
@ATTRIB -H -R -S -A "%~1"
@ATTRIB -H -R -S -A "%~1\*" /S /D
@IF NOT EXIST "%QrntnB%\%Target_X::=%\" MD "%QrntnB%\%Target_X::=%"
@MOVE /Y "%~1"  "%QrntnB%\%Target_Y::=%"
@SET Target_X=
@SET Target_Y=
@GOTO :EOF

