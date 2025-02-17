
@TITLE .
@ECHO ON
@PROMPT $
@CD /D "%~DP0"
@IF NOT DEFINED DeBug IF NOT EXIST DeBug.dat ECHO OFF
@COLOR 17

@CALL VerCF.bat
@IF EXIST Rboot.dat IF NOT EXIST ChkPrivs.dat CALL :ChkPrivs
@SETLOCAL
@IF NOT EXIST N_ MD N_ >NULL

@IF EXIST Rboot.dat IF EXIST W32Diag.dat SWXCACLS "%CD%" /RESET /Q >N_\%random% 2>&1

SET "PATH=%CD%;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\system32\wbem;"
IF EXIST CHCP.bat CALL CHCP.bat >N_\%random% 2>&1

IF EXIST wtf_tdssserv GOTO NT


:: It's okay if you want to take a peek at the script but ......
:: please bear in mind that if you have to copy, that means you can't script it on your own.
:: Copying means you don't understand enough. Also means you're not ready to make tools.
:: Do yourself & everybody else a favor. Don't release anything that you dont fully understand.
:: Chances of trashing a machine is high. Bide your time. If you work hard, your time shall come.



IF DEFINED sfxname GOTO NT
IF NOT EXIST %SystemRoot%\system32\cmd.exe GOTO NOT_NT


@SWREG.%cfext% query "hklm\system\currentcontrolset\control\productoptions" /v ProductType > WinNT00
@GREP -isq "ProductType.*WinNT" WinNT00 || GOTO Not_NT
@DEL /A/F WinNT00

IF EXIST XP.mac GOTO NT
IF EXIST W?.mac GOTO NT
IF EXIST Vista.mac GOTO NT
GOTO Not_NT
EXIT



:NT
@PEV RIMPORT EXE.reg >N_\%random% 2>&1
@IF EXIST c.mrk EXIT
@TYPE myNul.dat >c.mrk
@SET "SYSDIR=%SystemRoot%\system32"
@SET "ProgFiles=%ProgramFiles%"
@SET "CommonProgFiles=%CommonProgramFiles%"
@IF EXIST W6432.dat (
	SET "SYSTEM=%SystemRoot%\SysWow64"
	SET "SysNative=%SystemRoot%\SysNative"
	SET "ProgFiles=%ProgramFiles(x86)%"
	SET "CommonProgFiles=%CommonProgramFiles(x86)%"
) ELSE SET "SYSTEM=%SystemRoot%\system32"

@IF EXIST 32788R22FWJFW RD /S/Q 32788R22FWJFW
@IF EXIST W7.mac ECHO.W7>Vista.krl
@IF EXIST W8.mac ECHO.W8>Vista.krl
@IF EXIST Vista.mac ECHO.W7>Vista.krl

IF NOT DEFINED sfxname (
	SWREG QUERY "hklm\software\microsoft\windows\currentversion\app paths\combofix.exe" /ve | SED "/.*	/!d; s///" >sfxname01
	FOR /F "TOKENS=*" %%G IN  ( sfxname01 ) DO @SET "sfxname=%%G"
	DEL /Q sfxname0?
	)

IF NOT EXIST %SystemRoot%\System32\cryptsvc.dll (
	TYPE mynul.dat >%SystemRoot%\System32\cryptsvc.dll && DEL /A/F %SystemRoot%\System32\cryptsvc.dll
	HIDEC SWSC STOP CRYPTSVC 
	)>N_\%random% 2>&1
:: NIRCMD SERVICE STOP CRYPTSVC

IF NOT EXIST %SystemDrive%\Qoobox\Quarantine\Registry_backups\ MD %SystemDrive%\Qoobox\Quarantine\Registry_backups
IF NOT EXIST %SystemDrive%\Qoobox\Test MD %SystemDrive%\Qoobox\Test
IF NOT EXIST %SystemDrive%\Qoobox\TestC MD %SystemDrive%\Qoobox\TestC
IF NOT EXIST %SystemDrive%\Qoobox\LastRun MD %SystemDrive%\Qoobox\LastRun
IF NOT EXIST %SystemDrive%\Qoobox\BackEnv MD %SystemDrive%\Qoobox\BackEnv
@IF NOT EXIST SWREG.%cfext% COPY /Y /B SWREG.EXE SWREG.%cfext% >N_\%random% 2>&1

IF EXIST %SystemDrive%\Qoobox\LastRun\Res.bat (
	%KMD% /C  %SystemDrive%\Qoobox\LastRun\Res.bat
	FOR %%G IN ( %SystemDrive%\Qoobox\LastRun\SW_*.reg ) DO @(
		PEV RIMPORT "%%~G"
		SWREG IMPORT "%%~G"
		)
	DEL /A/F %SystemDrive%\Qoobox\LastRun\Res.bat
	DEL /A/F/Q %SystemDrive%\Qoobox\LastRun\SW_*.reg"
	)>N_\%random% 2>&1


SWREG QUERY "hklm\system\select" /v "current" |SED -r "/.*	/!d; s//00/; s/^[0-9]*(...) .*/@SET ControlSet=ControlSet\1\nSET CS000=HKEY_LOCAL_MACHINE\\system\\ControlSet\1\\Services/" > CCS.bat
@ECHO.@>> CCS.bat
CALL CCS.bat

@>desktop.ini ( ECHO.[.ShellClassInfo]&echo.CLSID={20D04FE0-3AEA-1069-A2D8-08002B30309D}&ECHO.IconResource=%SystemRoot%\system32\SHELL32.dll,4)
ATTRIB +S "%CD%"

IF NOT EXIST VolSnp.dat IF NOT EXIST W6432.dat (
	IF EXIST Volsnap_Handles00 CALL :VolSnap0 >N_\%random% 2>&1
	IF NOT EXIST VolSnp.dat FINDSTR -MR "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" "%System%\Drivers\Volsnap.sys" >N_\%random% 2>&1 ||CALL :ND_sub "%System%\Drivers\Volsnap.sys"
	IF EXIST VolSnp.dat CALL Boot-RK.cmd
	IF EXIST "%system%\drivers\sst*.sys" (
		PEV -c##k# -t!o -rtf -tpmz "%system%\drivers\*" -preg"\\sst\d.*\.sys$" | GREP -Fixsq volsnap.sys && CALL :VolSnap0 >N_\%random% 2>&1
		IF EXIST  VolSnp.dat CALL Boot-RK.cmd
		)
	DEL /A/F temp00 Volsnap_Handles00 >N_\%random% 2>&1
	)

	
@IF EXIST W32DiagBoot IF EXIST P.cmd DEL /A/F RBoot.dat >N_\%random% 2>&1
@IF EXIST VolSnp.dat DEL /A/F RBoot.dat VolSnp.dat >N_\%random% 2>&1
IF EXIST P.cmd DEL /A/F P.cmd
IF EXIST ChkPrivs.dat DEL /A/F ChkPrivs.dat


IF EXIST CatchmeTest.dat (
	CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -i
	DEL /A/F CatchmeTest.dat
	)>N_\%random% 2>&1
	
IF EXIST wtf_tdssserv GOTO ForeignC

GREP -sqx "REGEDIT4" Fin.dat || GOTO AbortD

ATTRIB +R *.%cfext%

@(
IF EXIST %SystemDrive%\bug.txt MOVE /Y %SystemDrive%\bug.txt
IF EXIST %SystemDrive%\CF-RC.txt DEL /A/F %SystemDrive%\CF-RC.txt
IF EXIST %SystemDrive%\start_.cmd DEL /A/F %SystemDrive%\start_.cmd
IF EXIST "cmd.%cfext%" DEL /A/F "cmd.%cfext%"
)>N_\%random% 2>&1


IF NOT EXIST kmd.dat ECHO.%KMD%>kmd.dat
IF NOT DEFINED KMD FOR /F "TOKENS=*" %%G IN ( kmd.dat ) DO SET "KMD=%%G"

@NIRCMDC EXEC SHOW "%CD%\%KMD%" /C " ECHO.&&ECHO.-------- ~%%CurrDate.yyyy-MM-dd%% - ~%%CurrTime.HH:mm:ss%%  -------------&&ECHO.">>%SystemDrive%\Qoobox\Quarantine\catchme.log

@ECHO.REGEDIT4>erunt.dat

@IF EXIST RkDetect*.dat IF EXIST Catch_KB.dat DEL /A/F Catch_KB.dat

CALL Lang.bat >N_\%random% 2>&1
IF EXIST Foreign?.dat GOTO NT-B


:ForeignC
GREP -Eisq "=.\/uninstall.| .\/uninstall. | .\/uninstall.$" sfx.cmd && GOTO abort
IF NOT EXIST "%SYSDIR%\cryptsvc.dll" CALL :CRYPT  >N_\%random% 2>&1

	
@(
ECHO.%system%\ntdll.dll
ECHO.%system%\kernel32.dll
ECHO.%system%\msvcrt.dll
ECHO.%system%\USER32.dll
ECHO.%system%\GDI32.dll
ECHO.%system%\ShimEng.dll
ECHO.%SystemRoot%\AppPatch\AcGenral.DLL
ECHO.%system%\ADVAPI32.dll
ECHO.%system%\RPCRT4.dll
ECHO.%system%\Secur32.dll
ECHO.%system%\WINMM.dll
ECHO.%system%\ole32.dll
ECHO.%system%\OLEAUT32.dll
ECHO.%system%\MSACM32.dll
ECHO.%system%\VERSION.dll
ECHO.%system%\SHELL32.dll
ECHO.%system%\SHLWAPI.dll
ECHO.%system%\USERENV.dll
ECHO.%system%\UxTheme.dll
ECHO.%system%\IMM32.DLL
ECHO.%system%\LPK.DLL
ECHO.%system%\USP10.dll
ECHO.%system%\comctl32.dll
ECHO.%system%\Apphelp.dll
ECHO.%system%\Normaliz.dll
ECHO.%system%\iertutil.dll
ECHO.%system%\mbx2midu.dll
IF EXIST Vista.krl ECHO.\Comctl32.dll
)>ForeignWht


SWXCACLS PV.%cfext% /P /GE:F /Q
PV -m %KMD% >ForeignC00 2>N_\%random%
SED -R "1,3d; /[4-9]\S{7}\s*\d* .:\\|\\detoured.dll$/Id; /.*(.:\\.*)/I!d; s//\1/" ForeignC00 >ForeignC01
GREP -Fixvf ForeignWht ForeignC01 >ForeignC02 &&(
	PEV -tx20000 -files:ForeignC02 -t!o -t!g >>ForeignA.dat && GOTO Foreign
	)
DEL /A/F/Q ForeignA.dat ForeignC0? >N_\%random% 2>&1
IF NOT EXIST W6432.dat IF EXIST wtf_tdssserv CALL NT-OS.cmd


:NT-B
SWREG QUERY HKLM\Software\Swearware /V "CF_Update"  >N_\%random% || GOTO LatestVer
SWREG DELETE HKLM\Software\Swearware /V "CF_Update" >N_\%random% 
CALL :PINGTEST >N_\pingtest 2>&1
@IF NOT EXIST "%SYSTEM%\dds_*_*.cmd" IF NOT EXIST Rboot.dat PING -n 2 -w 500 google.com >N_\%random% && CALL Update-CF.cmd
@IF EXIST LatestVer GOTO LatestVer

SWREG QUERY HKLM\Software\Swearware /v 44617465204572726F72 >N_\%random% &&(
	PEV -r -dg-1 -dl-90 and %systemdrive%\pagefile.sys or "%userprofile%\*" >Expired &&(
		IF DEFINED sfxname GREP -sq "FIXLSP.bat" "%sfxname%" && DEL /A/F "%sfxname%" >N_\%random% 2>&1
		GOTO ABORTB
	)|| SWREG DELETE HKLM\Software\Swearware /v 44617465204572726F72 >N_\%random% 2>&1
	)

PEV -rtf -dg365 .\md5sum.pif >N_\%random% || CALL :DateErr
PEV -rtf -dg-1 .\md5sum.pif >N_\%random% &&(
	REM NIRCMD Infobox "Date Error: ~%CurrDATE.yyyy-MM-dd%~n~nCheck your settings" "DATE ERROR"
	NIRCMD INFOBOX "%LINE31%" ""
	GOTO AbortC
	EXIT
	)


:LatestVer
IF NOT EXIST XPRD.NFO GREP -Eisq "=.\/SkipFix.| .\/SkipFix. | .\/SkipFix.$" sfx.cmd && TYPE myNul.dat >XPRD.NFO
GREP -Eisq "=.\/StepDel.| .\/StepDel. | .\/StepDel.$" sfx.cmd && TYPE myNul.dat >DoStepDel

IF EXIST Kill-All.cmd GREP -Eisq "=.\/killall.| .\/killall. | .\/killall.$" SFX.CMD &&(
	%KMD% /C Kill-All.cmd
	DEL /A/F Kill-All.cmd
	)>N_\Kill-All 2>&1

@IF DEFINED DeBug TYPE myNul.dat >DeBug.dat



@REM ECHO.Please wait."
@REM ECHO.ComboFix is preparing to run."
@ECHO.
@ECHO.%Line1%
@ECHO.%Line2%


@PEV -rtf -s-15728641 -c##5# .\* and { License.exe or %CFLDR%.exe or WinNT.exe or N_.exe or NULL.exe or temp0?.exe } -output:temp00 &&@(
	SWXCACLS PV.%cfext% /P /GE:F /Q
	PV -o%%f * > temp01
	ECHO.::::: >> temp01
	PEV -tx50000 -tf -t!o -files:temp01 -md5list:temp00 -c#@NIRCMD KILLPROCESS "#f"# -output:temp02.bat
	%KMD% /C temp02.bat >N_\%random% 2>&1
	DEL /A/F/Q temp0*
	)

GREP -lsq "k.a.v.s.t.a.r.t...e.x.e" %SystemRoot%\SoundMan.exe >>d-delA.dat && PEV -k SoundMan.exe >N_\%random% 2>&1

GREP -Eisq "=.\/killall.| .\/killall. | .\/killall.$" sfx.cmd ||@(
	SWXCACLS PV.%cfext% /P /GE:F /Q
	PV -o"%%i %%l" svchost.exe >KillSvchost00
	SED -r "/%system:\=\\%\\svchost( |\.exe )-k /Id; s/([0-9]*) .*/@PV -kfi \1/" KillSvchost00 >Kill.bat
	SWXCACLS PV.%cfext% /P /GE:F /Q
	%KMD% /C Kill.bat
	DEL /A/F Kill.bat KillSvchost00
	PEV -k * -preg"\\(([^\\]*cftmon[^\\]*|spool|iexplore|wscript|thguard|bryato|conime|fubcwj|severe|logo1_|rundl132|OSOflashy|trayicon|ntvdm|teatimer[^\\]*|ad-watch[^\\]*|SZServer|StopZilla[^\\]*|antiviirus|tmp.|userinit|wuauclt[^\\]*|ntsd|msmsgs|msnmsgr|LVPrcSrv|tmpzydf[^\\]*|df.jj32tmp[^\\]*|winfilse|tmplljydf.|winupgro|procmon|txp1atform|SonndMan|ANDRE|TOLO|jalang|jalangkung|jantungan|DOSEN|C3W3K4MPUS)\.exe|[^\\]*\.ext|verclsid\.dat|Merlin\.scr)$"
	PEV.exe -k *.%cfext% and not %ComSpec%
	)>N_\%random% 2>&1



:: Check Path + ComSpec
@SET "PathX=%%SystemRoot%%\system32;%%SystemRoot%%;%%SystemRoot%%\system32\wbem;"

SWREG QUERY "hklm\system\currentcontrolset\control\session manager\environment" /v path >path00
SED -r "/.*	/!d; s///; s/\\$//; s/\x22//g; s/\\\x3b/\n/g; s/\x3b/\n/g " path00 >path01

@(
ECHO.%%SystemRoot%%
ECHO.%%SystemRoot%%\system32
ECHO.%%SystemRoot%%\system32\wbem
ECHO.%SystemRoot%
ECHO.%SYSDIR%
ECHO.%SYSDIR%\wbem
)>path02

GREP -Fixvf path02 path01 >path03 2>N_\%random%
SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" path03 >path04
SED ":a; $!N; s/\n/\x3b/g; ta" path04 >path05
FOR /F "TOKENS=*" %%G IN ( path05 ) DO @SWREG ADD "hklm\system\currentcontrolset\control\session manager\environment" /V PATH /T REG_EXPAND_SZ /D "%PATHX%%%G"

@SET PathX=
@DEL /A/F/Q path0? N_\* >N_\Path$ 2>&1

IF EXIST netsvc.xp.dat (
	SWSC QUERY Cryptsvc| GREP -Fs ": 1060." >CryptSvcBroke.dat &&(
		IF EXIST XP.mac (
			SWSC Create CryptSvc binpath= "%SystemRoot%\system32\svchost.exe -k Netsvcs"
			) ELSE SWSC Create CryptSvc binpath= "%SystemRoot%\system32\svchost.exe -k NetworkService"
		)|| DEL CryptSvcBroke.dat
		)>N_\%random% 2>&1

IF EXIST safeboot.def.w7.dat IF EXIST XP.mac (
	DEL /A/F VistaReg.dat W7Reg.dat netsvc.dat netsvc.vista.dat DelClsid64.bat RegScan64.cmd safeboot.def.vista.dat Safeboot.def.w7.dat svchost.vista.dat svchost.w7.dat svchost.w7.x64.dat vWintemp.dacl  023w8.dat svchost.w8.dat svchost.w8.x64.dat Safeboot.def.w8.dat
	PEV RIMPORT xpreg.dat
	MOVE /Y netsvc.xp.dat netsvc.dat
	GREP -Eisq "=.\/SysRst.| .\/SysRst. | .\/SysRst.$" sfx.cmd && TYPE myNul.dat >SysRst
	GREP -Eisq "=.\/restorerun.| .\/restorerun. | .\/restorerun.$" sfx.cmd && TYPE myNul.dat >RestoreRun
	SWREG QUERY hklm\system\currentcontrolset\services\tcpip6 ||ECHO.6to4>>zhsvc.dat
	SWSC QUERY SRSERVICE >SRService00
	GREP -iwq "state.*RUNNING" SRService00 || (
		SWSC config sr start= boot binpath= system32\DRIVERS\sr.sys
		SWSC config srservice start= auto
		HIDEC SWSC start sr
		HIDEC SWSC start srservice
		)
	DEL /A/F SRService00
)>N_\%random% 2>&1 ELSE IF EXIST Vista.mac (
	DEL /A/F xpReg.dat W7Reg.dat 023w7.dat netsvc.dat netsvc.xp.dat svchost.dat svchost.w7.dat svchost.w7.x64.dat Safeboot.def.w7.dat 023w8.dat svchost.w8.dat svchost.w8.x64.dat Safeboot.def.w8.dat
	IF EXIST W6432.dat (
		IF EXIST "%Systemroot%\REGEDIT.exe" "%Systemroot%\REGEDIT.exe" /S Vistareg.dat
		MOVE /Y svchost.vista.x64.dat svchost.dat
		DEL /A/F svchost.vista.dat
		) ELSE (
		PEV RIMPORT Vistareg.dat
		MOVE /Y svchost.vista.dat svchost.dat
		DEL /A/F svchost.vista.x64.dat
		)
	GREP -Eisq "=.\/restorerun.| .\/restorerun. | .\/restorerun.$" sfx.cmd && TYPE myNul.dat >RestoreRun
	TYPE 023v.dat >>svc_wht.dat
	MOVE /Y netsvc.vista.dat netsvc.dat
	GREP -Eiv "^(dmadmin|dmserver|SRService|dmboot.sys|dmio.sys|dmload.sys|sr.sys)=" SafeBoot.def.dat >>SafeBoot.def.vista.dat
	MOVE /Y safeboot.def.vista.dat safeboot.def.dat
	ECHO.6to4>>zhsvc.dat
	ECHO.ClipSvr>>zhsvc.dat
)>N_\%random% 2>&1 ELSE IF EXIST W7.mac (
	DEL /A/F xpReg.dat VistaReg.dat netsvc.dat netsvc.xp.dat safeboot.def.vista.dat svchost.vista.dat svchost.vista.x64.dat 023w8.dat svchost.w8.dat svchost.w8.x64.dat Safeboot.def.w8.dat
	GREP -Eisq "=.\/restorerun.| .\/restorerun. | .\/restorerun.$" sfx.cmd && TYPE myNul.dat >RestoreRun
	TYPE 023v.dat 023w7.dat >>svc_wht.dat
	ECHO.BDESVC>>netsvc.vista.dat
	MOVE /Y netsvc.vista.dat netsvc.dat
	IF EXIST W6432.dat (
		IF EXIST "%Systemroot%\REGEDIT.exe" "%Systemroot%\REGEDIT.exe" /S W7Reg.dat
		MOVE /Y svchost.w7.x64.dat svchost.dat
		DEL /A/F svchost.w7.dat
		) ELSE (
		PEV RIMPORT W7Reg.dat
		MOVE /Y svchost.w7.dat svchost.dat
		DEL /A/F svchost.w7.x64.dat
		)
	GREP -Eiv "^(dmadmin|dmserver|SRService|dmboot.sys|dmio.sys|dmload.sys|sr.sys)=" SafeBoot.def.dat >>safeboot.def.w7.dat
	MOVE /Y safeboot.def.w7.dat safeboot.def.dat
	ECHO.6to4>>zhsvc.dat
	ECHO.ClipSvr>>zhsvc.dat
)>N_\%random% 2>&1 ELSE IF EXIST W8.mac (
	DEL /A/F xpReg.dat VistaReg.dat netsvc.dat netsvc.xp.dat safeboot.def.vista.dat svchost.vista.dat svchost.vista.x64.dat W7Reg.dat svchost.w7.dat svchost.w7.x64.dat Safeboot.def.w7.dat
	GREP -Eisq "=.\/restorerun.| .\/restorerun. | .\/restorerun.$" sfx.cmd && TYPE myNul.dat >RestoreRun
	TYPE 023v.dat 023w7.dat 023w8.dat >>svc_wht.dat
	ECHO.BDESVC>>netsvc.vista.dat
	ECHO.wlidsvc>>netsvc.vista.dat
	ECHO.SystemEventsBroker>>netsvc.vista.dat
	ECHO.DsmSvc>>netsvc.vista.dat
	ECHO.NcaSvc>>netsvc.vista.dat
	MOVE /Y netsvc.vista.dat netsvc.dat
	IF EXIST W6432.dat (
		IF EXIST "%Systemroot%\REGEDIT.exe" "%Systemroot%\REGEDIT.exe" /S W8Reg.dat
		MOVE /Y svchost.w8.x64.dat svchost.dat
		DEL /A/F svchost.w8.dat
		) ELSE (
		PEV RIMPORT W8Reg.dat
		MOVE /Y svchost.w8.dat svchost.dat
		DEL /A/F svchost.w8.x64.dat
		)
	GREP -UEiv "^(dmadmin|dmserver|SRService|dmboot.sys|dmio.sys|dmload.sys|sr.sys|vga.sys|vgasave.sys)=" SafeBoot.def.dat >>safeboot.def.w8.dat
	MOVE /Y safeboot.def.w8.dat safeboot.def.dat
	GREP -UFiv "vgasave.sys=" safeboot.dat > safeboot.dat.tmp
	MOVE /Y safeboot.dat.tmp safeboot.dat
	ECHO.6to4>>zhsvc.dat
	ECHO.ClipSvr>>zhsvc.dat
)>N_\%random% 2>&1 



IF EXIST CryptSvcBroke.dat DEL CryptSvcBroke.dat
START NIRKMD CMDWAIT 10000 EXEC HIDE PEV.exe -k SWSC.%cfExt%
SWSC START CryptSvc >N_\%random% 2>&1
PEV -k NIRKMD.%cfext%

@TYPE svc_wht.dat >>023.dat


IF NOT EXIST XP.mac ECHO.6to4>>zhsvc.dat
ECHO.IAS>>zhsvc.dat

IF NOT EXIST Vista.krl CALL RKEY.cmd >N_\%random% 2>&1
IF EXIST temp0? DEL /A/F/Q temp0? >N_\%random% 2>&1


IF NOT EXIST W8.mac PEV -fs32 -r -s-18000 "%SYSDIR%\lpk.dll" >N_\%random% &&CALL :ND_sub "%SYSDIR%\lpk.dll"

GREP -Fisq "themed32.dll" "%System%\uxtheme.dll" &&CALL :ND_sub "%System%\uxtheme.dll"

PEV -fs32 -r -t!k "%SYSDIR%\imm32.dll" >N_\%random% &&CALL :ND_sub "%SYSDIR%\imm32.dll"

GREP -Esq "\.text............................... ..à\.data|t5rc\.dll...jatydimofugclqu|\.reloc..............................@...\.NewIT" "%SYSDIR%\imm32.dll" &&(
	CALL :ND_sub "%SYSDIR%\imm32.dll"
	IF EXIST "%system%\Version.dll" PEV -rtg "%system%\Version.dll" >N_\%random% 2>&1 || CALL :ND_sub "%system%\Version.dll"
	)

FINDSTR -MI "notepad\.exe" "%System%\userinit.exe" >N_\%random% 2>&1 &&CALL :ND_sub "%System%\userinit.exe"


SWREG QUERY "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs >temp00
SED -r "/.*	/!d;s///;s/[ ,]/\n/g" temp00 | GREP -Fiv "winmm.dll"  >temp01
SWREG DELETE "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs >N_\%random% 2>&1

FOR /F %%G IN ( temp01 ) DO @GREP -Elsq "V.S._.V.E.R.S.I.O.N._.I.N.F.O|VS_VERSION_INFO" "%%~F$PATH:G" >>temp02
IF EXIST temp02 (
	SED ":a;$!N;s/\n/ /;ta" temp02 >temp03
	FOR /F "TOKENS=*" %%G IN ( temp03 ) DO @SWREG ADD "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /V AppInit_DLLs /D "%%G"
	)
SWREG QUERY "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" >MWindows.dat
IF NOT EXIST Vista.krl CALL RKEY.cmd RKEYB >N_\%random% 2>&1
DEL /A/F/Q temp0? >N_\%random% 2>&1




@FOR %%G IN (
%system%\SWXCACLS.exe
%system%\VFIND.exe
%SystemRoot%\VFIND.exe
%system%\fdsv.exe
%system%\sed.exe
%system%\grep.exe
%system%\zip.exe
%system%\SWREG.exe
%SystemRoot%\FDSV.exe
%SystemDrive%\PV.exe
) DO @IF EXIST "%%G" DEL /A/F "%%G" >N_\%random% 2>&1



@FOR %%G IN (
	"%SystemRoot%\SWXCACLS.exe"
	"%SystemRoot%\SWSC.exe"
	"%SystemRoot%\sed.exe"
	"%SystemRoot%\grep.exe"
	"%SystemRoot%\zip.exe"
	"%SystemRoot%\SWREG.exe"
	"%SystemRoot%\PEV.exe"
	"%SystemRoot%\NIRCMD.exe"
	"%SystemRoot%\MBR.exe"
) DO @(
	IF EXIST "%%~G" SWXCACLS "%%~G"  /P /GA:F /GS:F /GU:X /GP:X /I ENABLE /Q
	IF EXIST "%%~NG.%cfext%" COPY /Y /B "%%~NG.%cfext%" "%%~G"
	)>N_\%random% 2>&1


COPY /Y RMBR.%cfext% "%SystemRoot%\MBR.exe" >N_\%random% 2>&1

IF NOT EXIST CregC_.dat HIDEC %KMD% /C CregC.cmd

@DEL /A/F 0.23v.dat netsvc.vista.dat svchost.vista.dat %SystemDrive%\ComboFix_error.dat %system%\catchme.exe %SystemRoot%\catchme.exe >N_\%random% 2>&1

IF NOT EXIST %SystemRoot%\regedit.exe GOTO NoRegt
CALL :FREE "%SystemRoot%\regedit.exe" >N_\%random% 2>&1
COPY /Y /B %SystemRoot%\regedit.exe REGT.%cfext% >N_\%random% 2>&1
GSAR -o -s\:000P:000o:000l:000i -r\:001P:000o:000l:000i REGT.%cfext% >N_\%random% 2>&1
IF NOT EXIST REGT.%cfext% (
	COPY /Y /B %SystemRoot%\regedit.exe REGT.%cfext%
	IF NOT EXIST REGT.%cfext% CATCHME -c %SystemRoot%\regedit.exe REGT.%cfext%
	IF EXIST REGT.%cfext% GSAR -o -s\:000P:000o:000l:000i -r\:001P:000o:000l:000i REGT.%cfext%
	)>N_\%random% 2>&1

SWREG ADD "hkcu\software\microsoft\windows\currentversion\policies\system" /v "disableregistrytools" /t reg_dword /d 0 >N_\%random% 2>&1


:Sys
HIDEC SWSC CONFIG WINMGMT START= auto
HIDEC SWSC CONFIG WMI START= demand
@TYPE myNul.dat >"%username%.user.cf"
:: Remove old environments

IF NOT EXIST Rboot.dat IF EXIST CFVersionOld FOR /F "TOKENS=*" %%G IN ( CFVersionOld ) DO @IF /I "%%G" NEQ "%ver_CF%" (
	RD /S/Q "%SystemDrive%\qoobox\backenv"
	IF EXIST %systemdrive%\Qoobox\ComboFix-quarantined-files.txt DEL /A/F %systemdrive%\Qoobox\ComboFix-quarantined-files.txt
	GREP -Fisq "Beta" CFVersionOld &&ECHO.>CFVersionOld
	)>N_\%random% 2>&1

@SWREG ACL "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /RESET /Q
@SWREG ACL "HKCU\software\microsoft\Command Processor" /RESET /Q
@SWREG ACL "HKLM\software\microsoft\Command Processor" /RESET /Q
@SWREG ACL "HKCU\SOFTWARE\Policies\Microsoft\Windows\System" /RESET /Q
@SWREG ACL "HKCU\SOFTWARE\Microsoft\windows\CurrentVersion\Policies\System" /RESET /Q
@SWREG ACL "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /RESET /Q
@SWREG ACL "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /RESET /Q
@SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /RESET /Q
@SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /RESET /Q

PEV RIMPORT EXE.reg >N_\%random% 2>&1
PEV RIMPORT region.dat >N_\%random% 2>&1

START NIRCMD SYSREFRESH INTL
HIDEC SWSC START WINMGMT
:: NIRCMD SERVICE START WINMGMT

@IF EXIST %SYSDIR%\drivers\combo*fix.sys DEL /A/F/Q %SYSDIR%\drivers\combo*fix.sys


@IF EXIST %SystemDrive%\ComboFix.txt PEV -rtf -s+2000000 %SystemDrive%\ComboFix.txt >N_\%random% &&(
	TYPE myNul.dat >CFReboot.dat
	PEV MOVEEX %SystemDrive%\ComboFix.txt
	PEV MOVEEX CFreboot.dat
)||(
	IF EXIST %SystemDrive%\QooBox\ComboFix4.txt TYPE %SystemDrive%\QooBox\ComboFix4.txt >>\QooBox\ComboFix5.txt
	IF EXIST %SystemDrive%\QooBox\ComboFix3.txt MOVE /Y %SystemDrive%\QooBox\ComboFix3.txt %SystemDrive%\QooBox\ComboFix4.txt
	IF EXIST %SystemDrive%\QooBox\ComboFix2.txt MOVE /Y %SystemDrive%\QooBox\ComboFix2.txt %SystemDrive%\QooBox\ComboFix3.txt
	MOVE /Y %SystemDrive%\ComboFix.txt %SystemDrive%\QooBox\ComboFix2.txt
	)>N_\%random%


GREP -Eisq "=.\/SnapShot.| .\/SnapShot. | .\/SnapShot.$" sfx.cmd && SWREG DELETE HKLM\Software\Swearware /v snapshot >N_\%random%
GREP -Eisq "=.\/NoOrphans.| .\/NoOrphans. | .\/NoOrphans.$" sfx.cmd && TYPE myNul.dat >NoOrphans

IF NOT EXIST Resident.txt %KMD% /D /C AV.cmd >N_\%random% 2>&1


(TYPE myNul.dat >ndis.sys)>N_\%random% 2>&1
IF EXIST ndis.sys (
	DEL /A/F ndis.sys
	) ELSE (
	PEV -rtf -c##u# %SYSDIR%\drivers\ndis.sys -output:ndisB00
	FOR /F %%G IN ( ndisB00 ) DO @FOR %%H IN ( "%SYSDIR%\drivers\ndis.sys" ) DO @IF NOT %%~ZH == %%G DD if="%%~H" of="%CD%\MT_%%~nxH.tmp"
	DEL /A/F/Q ndis0?
	)>N_\%random% 2>&1


GREP -Eisq "=.\/f3m.| .\/f3m. | .\/f3m.$" sfx.cmd && (
	CALL SetEnvmt.bat >N_\%random% 2>&1
	IF NOT EXIST Rboot.dat (
		CALL List.bat
		DEL /A/F List.bat
		)
	CALL :LogHeader >N_\%random% 2>&1
	ECHO.>>ComboFix.txt
	START /I /B %ComSpec% /C CALL FIND3M.bat
	EXIT
	)


:DISCLAIM
IF EXIST %System%\sfcfiles.dll GREP -Esq "`.Sleep|CloseHandle" %System%\sfcfiles.dll &&CALL :ND_sub "%System%\sfcfiles.dll"
PEV -r -s-250000 "%System%\comres.dll" >N_\%random% &&(
	CALL :ND_sub "%System%\comres.dll"
	DEL comres.dll.ND_
)||PEV -r -s+10000000 "%System%\comres.dll" >N_\%random% &&(
	CALL :ND_sub "%System%\comres.dll"
	DEL comres.dll.ND_
	)

IF NOT EXIST "%System%\comres.dll" IF NOT EXIST W6432.dat (
	CALL :ND_sub "%System%\comres.dll"
	DEL comres.dll.ND_
	)

GREP -Eisq "\\(WindowsXP-KB310994-.*.exe|WinXP.*_BF.exe|CFScript)[^:\/\\]*$" sfx.cmd ||(
	GREP -isq ":\\." sfx.cmd &&(
		REM NIRCMD infobox "Were you trying to run CFScript?~n~nThe name, CFScript  appears to be incorrectly spelt" "CFScript Name Error"
		NIRCMD INFOBOX "%Line6%" ""
		GOTO AbortC
		)
	IF EXIST CFVersionOld FOR /F "TOKENS=*" %%G IN ( CFVersionOld ) DO @IF "%%G" GEQ "%ver_CF%" GOTO Autoscan
	)
DEL /A/F/Q N_\* >N_\%random% 2>&1

@IF EXIST RkDetect*.dat GOTO Autoscan
@IF EXIST DeBug???.dat GOTO Autoscan


FOR %%G IN (
"%SYSDIR%\vbscript.dll"
"%SYSDIR%\scrrun.dll"
"%SYSDIR%\wshom.ocx"
"%commonProgFiles%\System\msadc\msadco.dll"
"%commonProgFiles%\System\ado\msado15.dll"
) DO @IF EXIST %%G NIRCMD REGSVR REG %%G >N_\%random% 2>&1

IF NOT EXIST "%SYSDIR%\framedyn.dll" IF NOT EXIST "%SYSDIR%\wbem\framedyn.dll" IF EXIST "%SYSDIR%\dllcache\framedyn.dll" (
	COPY /Y /B %SYSDIR%\dllcache\framedyn.dll "%SYSDIR%\framedyn.dll"
	)>N_\%random% 2>&1


IF EXIST DisclaimED.dat GOTO DISCLAIMED
TITLE %Ver_CF%
NIRCMD WIN HIDE ITITLE "%Ver_CF%"
NIRCMD LOOP 2 80 BEEP 3000 200
IF NOT EXIST %SystemDrive%\qoobox\ComboFix?.txt (
	CALL :CHECK_CF
	DEL /A/F/Q sfxname0? CHECK_CF0?
	)>N_\%random% 2>&1

ECHO.>AbortB
NIRCMDC QBOXCOMTOP  "%DISCLAIMER%" "" FILLDELETE AbortB
IF EXIST ABORTB (
	NIRCMD WIN ACTIVATE ITITLE "%Ver_CF%"
	NIRCMD SENDKEY ENTER PRESS
	NIRCMD WIN HIDE ITITLE "%Ver_CF%"
	GOTO ABORTB
	)
NIRCMD WIN SHOW ITITLE "%Ver_CF%"
TITLE .


:DISCLAIMED
@IF EXIST "%Fonts%\svchost.exe" NIRCMD KillProcess "%Fonts%\svchost.exe"
@IF EXIST "%Fonts%\'\*.zip" DEL /A/F/Q "%Fonts%\'\*.zip" >N_\%random% 2>&1
@IF EXIST "%Fonts%\-\*.zip" DEL /A/F/Q "%Fonts%\-\*.zip" >N_\%random% 2>&1


IF NOT DEFINED SafeBoot @(
	@REM ECHO.Attempting to create a new System Restore point
	ECHO.
	ECHO.%Line7%
	START NIRKMD CMDWAIT 32000 EXEC HIDE PEV -k CSCRIPT.%cfext%
	CSCRIPT //NOLOGO //E:VBSCRIPT //T:30 restore_pt.vbs >restore_pt.dat 2>&1
	PEV -k NIRKMD.%cfext%
	)



:Autoscan
IF EXIST RkDetectA_tdssserv.dat IF NOT DEFINED SafeBoot @(
	START NIRKMD CMDWAIT 32000 EXEC HIDE PEV -k CSCRIPT.%cfext%
	CSCRIPT //NOLOGO //E:VBSCRIPT //T:30 restore_pt.vbs >restore_pt.dat 2>&1
	PEV -k NIRKMD.%cfext%
	)>N_\%random% 2>&1


START NIRKMD CMDWAIT 9000 EXEC HIDE PEV -k CSCRIPT.%cfext%
CSCRIPT //NOLOGO //E:VBSCRIPT //B //T:08 osid.vbs
PEV -k NIRKMD.%cfext%

:: NIRCMD EMPTYBIN
HIDEC SWSC STOP SCHEDULE
:: NIRCMD SERVICE STOP SCHEDULE


SWXCACLS PV.%cfext% /P /GE:F /Q
PV -o%%c\t%%u\t%%f\t%%i * >KillProcessHog00 2>N_\%random%
@ECHO.@>> KillProcessHog.bat
SWXCACLS PV.%cfext% /P /GE:F /Q
SED "/^[0-9][0-9]	%username%	/I!d; /%system:\=\\%\\cmd.exe\|%cd:\=\\%/Id; s/.*	/@PV -kfi /" KillProcessHog00 >> KillProcessHog.bat
%KMD% /C  KillProcessHog.bat >N_\%random% 2>&1
DEL /A/F/Q KillProcessHog* N_\* CHECKCF0? >N_\%random% 2>&1


:: NIRCMDC EXEC HIDE %SystemRoot%\PEV.exe -fs32 -tpmz -tx50000 -tf -t!o -s-1000000 -d:G90 -c##5#b#u#b#f#bc:#d#bp:#i#bn:#k#bv:#g# "%ProgFiles%\*" -output:progfile.dat
NIRCMDC EXEC HIDE %SystemRoot%\PEV.exe -fs32 -tx180000 -tpmz -tf -t!o -s-1600000 -d:G90 -c##5#b#u#b#f#b1:#d#b8:#i#b7:#k#b3:#g#b4:#o#b5:#j#b6:#l#b2:#e#b0:#q# "%ProgFiles%\*" -output:progfile.dat


IF EXIST "%username%.user.cf" IF EXIST Setpath.bat Call Setpath.bat >N_\%random% 2>&1
IF NOT DEFINED DesktopB CALL SetEnvmt.bat >N_\%random% 2>&1


@IF NOT EXIST VikPev00 (
ECHO.-fs32 -c##5#b#u#b#f#b1:#d#b8:#i#b7:#k# -rktf -t!o -tpmz and "%tmp%\*"
ECHO.or "%SystemRoot%\tasks\*"
IF DEFINED TASKS ECHO.or "%Tasks%\*"
IF DEFINED ActiveX ECHO.or "%ActiveX%\*"
IF DEFINED FONTS ECHO.or "%FONTS%\*"
ECHO.or "%SystemRoot%\Downloaded Program Files\*"
ECHO.or "%SystemRoot%\apppatch\*"
ECHO.or "%SystemRoot%\Config\*"
ECHO.or "%SystemRoot%\Debug\*"
ECHO.or "%SystemRoot%\FONTS\*"
ECHO.or "%SystemRoot%\Help\*"
ECHO.or "%SystemRoot%\Inf\*" 
ECHO.or "%SystemRoot%\media\*"
ECHO.or "%SystemRoot%\msagent\*"
ECHO.or "%SystemRoot%\msagent\intl\*"
ECHO.or "%SystemRoot%\addins\*"
ECHO.or "%SystemRoot%\assembly\*"
ECHO.or "%SystemRoot%\Cursors\*"
ECHO.or "%SystemRoot%\Driver Cache\*"
ECHO.or "%SystemRoot%\java\*"
ECHO.or "%SystemRoot%\Microsoft.NET\*"
ECHO.or "%SystemRoot%\Registration\*"
ECHO.or "%SystemRoot%\repair\*"
ECHO.or "%SystemRoot%\security\*"
ECHO.or "%SystemRoot%\ServicePackFiles\*"
ECHO.or "%SystemRoot%\Speech\*"
ECHO.or "%SystemRoot%\temp\*"
ECHO.or "%SystemRoot%\Web\*"
ECHO.or "%SystemRoot%\Windows Update Setup Files\*"
ECHO.or "%system%\Com\*"
ECHO.or "%system%\dllcache\*"
ECHO.or "%system%\Inf\*"
ECHO.or "%system%\Wbem\*"
ECHO.or "%system%\Config\*"
ECHO.or "%system%\inetsrv\*"
ECHO.or "%system%\Microsoft\*"
ECHO.or "%system%\ReinstallBackups\*"
ECHO.or "%system%\Drivers\*"
ECHO.or "%CommonProgFiles%\System\*" 
ECHO.or "%CommonProgFiles%\Plugin\*"
ECHO.or "%CommonProgFiles%\Companion Wizard\*"
ECHO.or "%CommonProgFiles%\Microsoft Shared\*"
ECHO.or "%ProgFiles%\Adobe\*"
ECHO.or "%ProgFiles%\Java\*"
ECHO.or "%ProgFiles%\Movie Maker\*"
ECHO.or "%ProgFiles%\MSN Gaming Zone\*"
ECHO.or "%ProgFiles%\Online Services\*"
ECHO.or "%ProgFiles%\Uninstall Information\*"
ECHO.or "%ProgFiles%\Windows Media Player\*"
ECHO.or "%ProgFiles%\WinRAR\*"
ECHO.or "%ProgFiles%\WinZip\*"
ECHO.or "%ProgFiles%\xerox\*"
ECHO.or "%ProgFiles%\NetMeeting\*"
ECHO.or "%ProgFiles%\Outlook\*"
ECHO.or "%ProgFiles%\Outlook Express\*"
ECHO.or "%ProgFiles%\Messenger\*"
ECHO.or "%ProgFiles%\Windows NT\*"
ECHO.or "%ProgFiles%\Windows Media Player\*"
ECHO.or "%ProgFiles%\Mozilla Firefox\*"
ECHO.or "%ProgFiles%\Internet Explorer\*"
ECHO.or "%ALLUSERSPROFILE%\*"
IF DEFINED ProfilesDirectory ECHO.or "%ProfilesDirectory%\*"
IF NOT EXIST Vista.krl IF EXIST Cfolders.dat SED -r "/NtUninstallKB/Id; s/\x22//g; s/.*/or \x22&\\*\x22/" Cfolders.dat
)>VikPev00
PEV -loadlineVikPev00 >Vikpev01
START NIRCMD abortshutdown
COPY /Y VikPev00 %systemdrive%\Qoobox\BackEnv\ >N_\%random% 2>&1


@IF NOT EXIST Vista.krl (
	SWREG QUERY "hklm\software\microsoft\windows\currentversion\setup" /v bootdir >BootDir00
	SED "/.*	/!d;s///" BootDir00 >BootDir01
	FOR /F %%G IN ( BootDir01 ) DO @IF EXIST "%%~GBoot.ini" SET "BootDir=%%~G"
	DEL /A/F/Q BootDir0? 
	)>N_\%random% 2>&1


IF EXIST XP.mac IF EXIST Hwid.pif (
	SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E96A-E325-11CE-BFC1-08002BE10318}" /s >AddDriver00
	SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E97B-E325-11CE-BFC1-08002BE10318}" /s >>AddDriver00
	SED -r "/^ +MatchingDeviceId	.*	/I!d; s///" AddDriver00| SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" >AddDriver01
	ECHO.:::::==::::>>AddDriver01
	GREP -Fif AddDriver01 Hwid.pif >AddDriver02
	FOR /F "TOKENS=1,2* DELIMS=	" %%G IN ( AddDriver02 ) DO @IF NOT EXIST "%BootDir%cmdcons\%%~H.sy?" (ECHO.%%G	%%H	%%I)>>AddDriver03
	DEL /A/F AddDriver00 AddDriver01
	IF EXIST "%SYSDIR%\drivers\iastor.sys" IF NOT EXIST "%BootDir%cmdcons\iastor*.sy?" ECHO.>IntelMatrix.dat
	IF EXIST "%SYSDIR%\drivers\viamraid.sys" IF NOT EXIST "%BootDir%cmdcons\viamraid.sy?" ECHO.>Via.dat
	PEV -rtf "%SYSDIR%\drivers\*" and { nvatabus.sys or nvata.sys or nvgts.sys or nvstor32.sys or nvrd32.sys or nvstor.sys } && IF NOT EXIST "%BootDir%cmdcons\nvatabus.sy?" ECHO.>nvidia.dat
	PEV -rtf "%SYSDIR%\drivers\*" and { sisraid.sys or siside.sys } && IF NOT EXIST "%BootDir%cmdcons\siside.sy?" ECHO.>SiSscsi.dat
	IF NOT EXIST SiSscsi.dat IF NOT EXIST Via.dat IF NOT EXIST nvidia.dat IF NOT EXIST IntelMatrix.dat IF NOT EXIST AddDriver03 IF EXIST %BootDir%cmdcons\bootsect.dat IF EXIST %BootDir%Boot.ini IF NOT EXIST %BootDir%Boot.ini\ (
		HANDLE %BootDir%Boot.ini | SED -R "/.*pid: (\d*)\s*([0-9a-f]*): .*/I!d; s//echo.y|HANDLE -p \1 -c \2/" >HandsOffBootIni.bat
		%KMD% /C HandsOffBootIni.bat
		DEL HandsOffBootIni.bat 
		GREP -isq "CMDCONS\\BOOTSECT.DAT" %BootDir%Boot.ini &&TYPE myNul.dat >RcRdy
		))>N_\%random% 2>&1
	
		
IF EXIST Hwid.pif IF EXIST XP.mac IF NOT EXIST RcRdy (
	IF EXIST sfx.cmd GREP -Ei "\\WindowsXP-KB310994-.*.exe|\\WinXP.*_BF.exe" sfx.cmd >InstallRC &&(
		CALL Install-RC.cmd
		)|| DEL /A/F InstallRC
	IF DEFINED LANG_CF IF NOT EXIST InstallRC (
		REM NIRCMD QBOXCOMTOP "This machine does not have the 'Microsoft Windows recovery console'~ninstalled. Alternately, an existing installation of the recovery console~nmay be present but requires updating.~n~nWithout it, ComboFix shall not attempt the fixing of some serious infections.~n~nClick 'Yes' to have ComboFix download/install it.~n~nNOTE: this requires an active internet connection." "Microsoft Windows Recovery Console" RETURNVAL 1 &&GOTO :EOF "
		@ECHO.>RcNo
		NircmdB.exe QBOXCOMTOP "%Line70%" "" FILLDELETE RcNo
		IF NOT EXIST RcNo CALL AUTO-RC.cmd
		))

DEL /A/F/Q *-RC.cmd AddDriver0? >N_\%random% 2>&1
IF EXIST RC\ RD /S/Q RC >N_\%random% 2>&1
IF EXIST Hwid.pif DEL /A/F Hwid.pif >N_\%random% 2>&1
IF EXIST AbortC GOTO AbortC


@HIDEC SWSC STOP BITS 
:: NIRCMD SERVICE STOP BITS
@PEV -k * -preg"\\(iexplore|firefox|opera|chrome)\..exe$"

@(
START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k ROUTE.%cfExt%
ROUTE PRINT 0.0.0.0 > Route00
PEV -k NIRKMD.%cfext%
SED -r "/^\s+0\.0\.0\.0\s+0\.0\.0\.0\s+(\S+)\s+.*/!d;s//\1/;" Route00 >Gateway
GREP -sq . Gateway || DEL /A/F Gateway 
IF EXIST Gateway (
	REGT /E TcpipParameters.reg "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
	START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k ROUTE.%cfExt%
	HIDEC ROUTE DELETE 0.0.0.0
	PEV -k NIRKMD.%cfext%
	COPY /Y Gateway \Qoobox\LastRun\
	)
)>N_\%random% 2>&1

@DIR \ >PreDir00
@SED -r "$!d;s/ +.*  +/%Pre-Run%: /" PreDir00 >PreDIR
@DEL /A/F Predir00

@IF EXIST TcpipParameters.reg REGT /S TcpipParameters.reg
@DEL /A/F/Q Route00 TcpipParameters.reg N_\* >N_\%random% 2>&1

CLS
@TITLE AutoScan
@REM ECHO.Scanning for infected files . . .
@REM ECHO.This typically doesn't take more than 10 minutes
@REM ECHO.However, scan times for badly infected machines may easily double
@ECHO.
@ECHO.%Line11%
@ECHO.%Line12%
@ECHO.%Line13%


TYPE myNul.dat >\test0123
%KMD% /D /C MoveIt.bat "%SystemDrive%\test0123" "MoveEx" >N_\%random% 2>&1
DEL /A/F %SystemDrive%\test0123

FOR %%G IN (
	"%SystemRoot%\ERDNT\SysHive_link"
	"%SystemDrive%\Qoobox\Quarantine\%systemroot::=%\ERDNT\MoveEx_SysHive_link.vir"
) DO @IF EXIST "%%G" PEV MOVEEX %%G >N_\%random% 2>&1



NIRCMDC exec hide "%CD%\%KMD%" /c "PEV -fs32 -tx15000 -tg -rtf "%SysDir%\wintrust.dll" -output:FdsvOK || DEL /A/F FdsvOk "

IF NOT EXIST dnd.dat (
	CALL List.bat
	@DEL /A/F/Q mdCheck0?.dat List.bat >N_\%random% 2>&1
	)

	

@IF EXIST ncmd.cfxxe MOVE /Y ncmd.cfxxe ncmd.com >N_\%random% 2>&1
@SED "s/\x22//g" Cfiles.dat >Clist.dat
@SED "/./!d; s/\x22//g; s/$/\\/" Cfolders.dat >ClistB.dat
@PEV PLIST >Plist00
@GREP -Ei "%systemroot:\=\\%\\[0-9]{8,}:[0-9]{3,}.exe" Plist00 >MaxTrap00 &&(
	TYPE MaxTrap00 >>CFiles.dat
	ECHO.Max_WinDir_ADS>W32Diag.dat
	ECHO.Max_WinDir_ADS>Max_WinDir_ADS
	SED -r "s/:[^:]*$//" Maxtrap00 > MaxTrap01
	FOR /F "TOKENS=*" %%G IN ( MaxTrap01 ) DO @IF EXIST "%%~G\" (
		ECHO."%%~G">>CFolders.dat
		SWXCACLS "%%~G" /RESET /Q
		RD /S/Q "%%~G"
		) ELSE IF EXIST "%%~G" (
		ECHO."%%~G">>CFiles.dat
		SWXCACLS "%%~G" /P /GE:F /Q
		DEL /A/F "%%~G"
		))>N_\%random% 2>&1
@DEL /A/F/Q MaxTrap0? >N_\%random% 2>&1
@GREP -Ev "^\\.|:[^\\]" Plist00 > Plist01
@ATTRIB -r ncmd.com
@GREP -Fixf Clist.dat Plist01 >>ncmd.com
@GREP -Fif ClistB.dat Plist01 >>ncmd.com
@ECHO.::::>>Plist01
@PEV -tx80000 -t!o -filesPlist01 -c##5#b#u#b#f#b1:#d#b8:#i#b7:#k#b3:#g# and not -preg"%cd:\=\\%|%systemroot:\=\\%\\(pev|swreg|swsc|sed|grep|zip|nircmd|swxcacls)\.exe|%system:\=\\%\\swsc\.exe" -output:Plist02
@SWXCACLS PEV.%cfext% /P /GE:F /Q
@GREP -Fisf srizbi.md5 Plist02 >Plist03
@GREP -Esf VInfo Plist02 >>Plist03
@SED -r "/.*	([c-z]:\\[^	]*)	.*/I!d; s//\1/" Plist03 | MTEE /+ ncmd.com >>d-del_A.dat
@SED -r "/.:------	/!d; s/.*(.:\\[^\t]*)	.*/\1/; /\\PEV\.|\.%cfext%$|\\NVIDIA Corporation\\NetworkAccessManager\\/Id" Plist02 >Plist04
@GREP -Fvxf ncmd.com Plist04 > Plist05 && MOVE /Y Plist05 Plist04 >N_\%random% 2>&1
@ECHO.::::>>Plist04
@PEV -tx50000 -t!o -filesPlist04 -t!g >>ncmd.com
@ATTRIB +r ncmd.com
@DEL /A/F/Q Plist0? Clist.dat >N_\%random% 2>&1
@MOVE /Y ncmd.com ncmd.cfxxe >N_\%random% 2>&1
PEV -loadlineVikPev00 >Vikpev01
@START NIRCMD abortshutdown 
@MOVE /Y ncmd.cfxxe ncmd.com >N_\%random% 2>&1

PEV VOLUME >Drives00
SED "s/\r/\n/g; s/:\\//" Drives00 >Drives.dat
SED "s/\r/\n/g; s/\\//" Drives00 >Drive.folder.dat
SED -r "s/\r/\n/g; /^.:\\$/!d; s/$/Autorun.inf/" Drives00 >>CFiles.dat
DEL /A/F Drives00


@(
ECHO.-fs32 -s-15728641 -c##5#b#u#b#f#b1:#d#b8:#i#b7:#k#b3:#g#b4:#o#b5:#j#b6:#l#b2:#e#b0:#q# -rtf -t!o -tp and %SystemDrive%\*
ECHO.or "%SystemRoot%\*"
ECHO.or "%ActiveX%\*"
ECHO.or "%Tasks%\*"
ECHO.or "%SystemRoot%\System\*"
ECHO.or "%SystemRoot%\apppatch\*"
ECHO.or "%SystemRoot%\Config\*"
ECHO.or "%SystemRoot%\Debug\*"
ECHO.or "%SystemRoot%\FONTS\*"
ECHO.or "%SystemRoot%\Help\*"
ECHO.or "%SystemRoot%\Inf\*" 
ECHO.or "%SystemRoot%\media\*"
ECHO.or "%SystemRoot%\msagent\*"
ECHO.or "%SystemRoot%\msagent\intl\*"
ECHO.or "%SystemRoot%\addins\*"
ECHO.or "%SystemRoot%\assembly\*"
ECHO.or "%SystemRoot%\Cursors\*"
ECHO.or "%SystemRoot%\Driver Cache\*"
ECHO.or "%SystemRoot%\java\*"
ECHO.or "%SystemRoot%\Microsoft.NET\*"
ECHO.or "%SystemRoot%\Registration\*"
ECHO.or "%SystemRoot%\repair\*"
ECHO.or "%SystemRoot%\security\*"
ECHO.or "%SystemRoot%\ServicePackFiles\*"
ECHO.or "%SystemRoot%\Speech\*"
ECHO.or "%SystemRoot%\Web\*"
ECHO.or "%SystemRoot%\Windows Update Setup Files\*"
ECHO.or "%system%\*"
ECHO.or "%system%\Com\*"
ECHO.or "%system%\Inf\*"
ECHO.or "%system%\Wbem\*"
ECHO.or "%system%\Config\*"
ECHO.or "%system%\inetsrv\*"
ECHO.or "%system%\Microsoft\*"
ECHO.or "%system%\ReinstallBackups\*"
ECHO.or "%system%\Drivers\*"
ECHO.or "%system%\Drivers\etc\*"
ECHO.or "%CommonProgFiles%\*"
ECHO.or "%CommonProgFiles%\System\*" 
ECHO.or "%CommonProgFiles%\Plugin\*"
ECHO.or "%CommonProgFiles%\Companion Wizard\*"
ECHO.or "%CommonProgFiles%\Microsoft Shared\*"
ECHO.or "%CommonProgFiles%\Microsoft Shared\HTMLView\*"
ECHO.or "%CommonProgFiles%\Microsoft Shared\MSInfo\*"
ECHO.or "%CommonProgFiles%\Microsoft Shared\System\*"
ECHO.or "%CommonProgFiles%\Microsoft Shared\Web Folders\*"
ECHO.or "%ProgFiles%\*"
ECHO.or "%ProgFiles%\NetMeeting\*"
ECHO.or "%ProgFiles%\Outlook\*"
ECHO.or "%ProgFiles%\Outlook Express\*"
ECHO.or "%ProgFiles%\Messenger\*"
ECHO.or "%ProgFiles%\Windows NT\*"
ECHO.or "%ProgFiles%\Windows NT\Accessories\*" 
ECHO.or "%ProgFiles%\Windows NT\Pinball\*"
ECHO.or "%ProgFiles%\Windows Media Player\*"
ECHO.or "%ProgFiles%\Windows Media Player\Icons\*" 
ECHO.or "%ProgFiles%\Windows Media Player\Skins\*"
ECHO.or "%ProgFiles%\Mozilla Firefox\*"
ECHO.or "%ProgFiles%\Mozilla Firefox\Components\*" 
ECHO.or "%ProgFiles%\Mozilla Firefox\Plugins\*"
ECHO.or "%ProgFiles%\Internet Explorer\*"
ECHO.or "%ProgFiles%\Internet Explorer\Plugins\*" 
ECHO.or "%ProgFiles%\Internet Explorer\Connection Wizard\*"
ECHO.or "%ProgFiles%\Internet Explorer\Signup\*"
ECHO.or "%ProfilesDirectory%\*"
SED -r "s/\x22//g; s/(.*)/&\n&\\Google\n&\\Microsoft/" LocalAppData.folder.dat >Temp.dat
SED -r "s/\x22//g; s/(.*)/&\n&\\Adobe\n&\\Google\n&\\Microsoft\n&\\Microsoft\\Dr Watson\n&\\Microsoft\\Office\\System\n&\\Microsoft\\Windows/" appdata.folder.dat >>Temp.dat
SED "s/\x22//g" Profiles.folder.dat Desktop.Folder.dat Startup.Folder.dat Drive.folder.dat Temp.dat >Vipev0a
SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/or \x22&\\*\x22/;" Vipev0a
)>ViPev00
SED -r "s/\x22 or /\x22\nor /Ig;" ViPev00 >Vipev0b 
GREP -F :\ Vipev0b >ViPev01
DEL /A/F Vipev0a Vipev0b


IF NOT EXIST W6432.dat (
	IF NOT EXIST XPRD.NFO CALL NT-OS.cmd
	CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -e pIofCallDriver >N_\%random% 2>&1
	)
IF EXIST Rboot.dat DEL /A/F Rboot.dat
IF EXIST sfx.cmd GREP -Eisq "\\CFScript[^:\/\\]*$" sfx.cmd && CALL CF-Script.cmd >N_\%random% 2>&1
DEL /A/F CF-Script.cmd Kill-All.cmd temp.dat
IF EXIST ABORTC GOTO ABORTC


CALL :LogHeader >N_\%random% 2>&1


>>ComboFix.txt (
IF EXIST XP.mac IF NOT EXIST RcRdy IF NOT EXIST "%BootDir%cmdcons\" ECHO.&&ECHO.%RecoveryConsole%

REM ECHO.- REDUCED FUNCTIONALITY MODE -
IF EXIST XPRD.NFO ECHO.&ECHO.%LINE44%
	
IF EXIST AbortFixCommonStartup TYPE AbortFixCommonStartup

@IF EXIST FileCFScript.dat GREP -Fsq :\ FileCFScript.dat && (
	ECHO.
	ECHO.FILE ::
	Type FileCFScript.dat
	DEL /A/F FileCFScript.dat
	)
@IF NOT EXIST cfscriptFCollect00 IF EXIST CatchZipped.dat (
	ECHO.
	SED -r "/ -> .*/!d;s///; s/\\(Collect|Suspect)_(.*).vir/\\\2/I" CatchZipped.dat
	DEL /A/F CatchZipped.dat
	)
@IF NOT EXIST %SYSDIR%\vbscript.dll @ECHO.%SYSDIR%\vbscript.dll %is missing%
@IF NOT EXIST "%SYSDIR%\framedyn.dll" IF NOT EXIST "%SYSDIR%\wbem\framedyn.dll" @ECHO.framedyn.dll %is missing%
@ECHO.
@IF EXIST Foreign.dat @(
	ECHO.%The following files were disabled during the run%:
	SED "s/	.*//; s/\x22//g" Foreign.dat
	ECHO.
	)
@GREP -lsq "::::" Cfiles.dat Cfolders.dat borlander_file.dat borlander_folder.dat vundonames.dat Goldun.dat  >temp00
SED "s/.*/  Error: &/" temp00
) 2>N_\%random%

@DEL /A/F/Q temp0? N_\* restore_pt.vbs >N_\%random% 2>&1


@IF EXIST f_system @(
	IF NOT DEFINED SAFEBOOT_OPTION (
		SWREG ACL "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components" /DE:F /Q
		PEV -k explorer.exe
		START NIRCMD.EXE CMDWAIT 5000 EXEC HIDE SWREG.%cfext% ACL "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components" /RESET /Q
		)
	SF.exe %SYSDIR% >ads00
	SF.exe %SYSDIR%\drivers >>ads00
	SF.exe %SystemRoot% >>ads00
	SF.exe %Systemdrive% >>ads00
	SF.exe %SYSDIR%\svchost.exe >>ads00
	SF.exe %SYSDIR%\ntoskrnl.exe >>ads00
	SF.exe %SystemRoot%\explorer.exe >>ads00
	SF.exe %SYSDIR%\win32k.sys >>ads00
	IF EXIST %SYSDIR%\netcfgx.dll SF %SYSDIR%\netcfgx.dll >>ads00
	IF EXIST "%ProgFiles%\Microsoft Games\Windows" SF.exe "%ProgFiles%\Microsoft Games\Windows" >>ads00
	IF EXIST ADS.dat FOR /F "TOKENS=*" %%G IN ( ADS.dat ) DO @SF.exe "%%~G" >>ads00
	SED "/: deleted/I!d; s/.*/[i] ADS - & [\/i]/" ads00 >>combofix.txt
	DEL /A/F ads00
	)>N_\%random% 2>&1




@ECHO.(((((((((((((((((((((((((((((((((((((((   %Drivers/Services%   )))))))))))))))))))))))))))))))))))))))))))))))))>SvcTarget.dat
@ECHO.>>SvcTarget.dat
@ECHO..>>SvcTarget.dat

@IF EXIST RKBootSvc (
	TYPE RKBootSvc >>SvcTarget.dat
	DEL /A/F RKBootSvc
	)

@IF EXIST %systemdrive%\Qoobox\LastRun\Whistler.old TYPE %systemdrive%\Qoobox\LastRun\Whistler.old >> Whistler.dat
@IF EXIST %SystemDrive%\qoobox\lastrun\cregC.old TYPE %SystemDrive%\qoobox\lastrun\CregC.old >>CregC.dat
@IF EXIST %SystemDrive%\qoobox\lastrun\zhsvc.old TYPE %SystemDrive%\qoobox\lastrun\zhsvc.old >>zhsvc.dat

@IF NOT EXIST FileLook.cfscript IF EXIST %SystemDrive%\qoobox\lastrun\FileLook.cfscript TYPE %SystemDrive%\qoobox\lastrun\FileLook.cfscript >> FileLook.cfscript
@IF NOT EXIST DirLook.cfscript IF EXIST %SystemDrive%\qoobox\lastrun\DirLook.cfscript TYPE %SystemDrive%\qoobox\lastrun\DirLook.cfscript >> DirLook.cfscript
@IF NOT EXIST SrPeek.cfscript IF EXIST %SystemDrive%\qoobox\lastrun\SrPeek.cfscript TYPE %SystemDrive%\qoobox\lastrun\SrPeek.cfscript >> SrPeek.cfscript

@IF EXIST %SystemDrive%\qoobox\lastrun\d-delA.dat (
	TYPE %SystemDrive%\qoobox\lastrun\d-delA.dat >>d-del_A.dat
	DEL /A/F/Q %SystemDrive%\qoobox\lastrun\d-del_A.dat
	)>N_\%random% 2>&1

@IF EXIST %SystemDrive%\qoobox\lastrun\d-del_A.dat TYPE %SystemDrive%\qoobox\lastrun\d-del_A.dat >>d-del_A.dat

@IF EXIST %SystemDrive%\qoobox\lastrun\RK_Catch_KB.dat (
	TYPE %SystemDrive%\qoobox\lastrun\RK_Catch_KB.dat >>d-del_A.dat
	DEL /A/F %SystemDrive%\qoobox\lastrun\RK_Catch_KB.dat
	)>N_\%random% 2>&1

@IF EXIST %SystemDrive%\qoobox\lastrun\d-delB.dat TYPE %SystemDrive%\qoobox\lastrun\d-delB.dat >>d-del_B.dat
@IF EXIST %SystemDrive%\qoobox\lastrun\d-del?.dat DEL /A/F/Q %SystemDrive%\qoobox\lastrun\d-del?.dat >N_\%random% 2>&1

@IF EXIST %SystemDrive%\qoobox\lastrun\ndis_HDCntrl.old (
	SED -R "/.* %system:\=\\%\\Drivers\\(\S*\.sys) .*/I!d; s//\1/" %SystemDrive%\qoobox\lastrun\ndis_HDCntrl.old >ndis_HDCntrl.chk
	FOR /F "TOKENS=*" %%G IN ( ndis_HDCntrl.chk ) DO @PEV -rt!g "%SystemDrive%\Qoobox\Quarantine\%system::=%\Drivers\%%~G.vir*" &&(
		GREP -FA1 "%%~G" %SystemDrive%\qoobox\lastrun\ndis_HDCntrl.old >>ndis_log.dat
		)||DEL /A/F/Q "%SystemDrive%\Qoobox\Quarantine\%system::=%\Drivers\%%~G.*"
	DEL /A/F ndis_HDCntrl.chk %SystemDrive%\qoobox\lastrun\ndis_HDCntrl.old
	)>N_\%random% 2>&1

@IF EXIST %SystemDrive%\qoobox\lastrun\ndis_log.old (
	ECHO.-- %Previous Run% --&ECHO.
	TYPE %SystemDrive%\qoobox\lastrun\ndis_log.old 
	ECHO.--------& ECHO.
	)>>ndis_log.dat

@IF EXIST %SystemDrive%\qoobox\lastrun\Chk_Services_exe.dat (
	TYPE %SystemDrive%\qoobox\lastrun\Chk_Services_exe.dat >> ndis_log.dat
	DEL /A/F/Q %SystemDrive%\qoobox\lastrun\Chk_Services_exe.dat >N_\%random% 2>&1
	)

@IF EXIST %SystemDrive%\qoobox\lastrun\*.dat (
	COPY /Y %SystemDrive%\qoobox\lastrun\*.dat >N_\%random%
	DEL /A/F/Q %SystemDrive%\qoobox\lastrun\*.dat >N_\%random% 2>&1
	)
	

@IF EXIST Whistler.dat CALL :Whistler3 >N_\%random% 2>&1

SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify" >HklmNotify00
SED "/HKEY.*notify\\/!d; s///" HklmNotify00 >HklmNotify01

GREP -Fixvf notifykeys.dat HklmNotify01 >Suspect_ntfy.dat ||DEL /A/F Suspect_ntfy.dat
PEV -k NircmdB.exe
DEL /A/F/Q HklmNotify0? N_\* >N_\%random% 2>&1


%KMD% /D /C List-C.bat 2>ErrTrap1


:MiscFixB
PEV -k NIRCMD.%cfext%
IF EXIST WowErr01 DEL /A/F WowErr01
IF EXIST WowErr.dat SED "1!d; s/.*_//; s/ .*//" WowErr.dat >WowErr01
IF EXIST WowErr.dat DEL /A/F WowErr.dat
DIR /A-D/O-D/B ErrTrap* >FindErrTrap00 2>N_\%random%
SED q FindErrTrap00 >WowErr02
DEL /A/F FindErrTrap00 >N_\%random% 2>&1

IF EXIST WowErr01 FOR /F "TOKENS=*" %%G IN ( WowErr01 ) DO (
	PEV.exe -k *.%cfext% and not %ComSpec% >N_\%random% 2>&1
	ECHO.	/wow section - STAGE %%G>>ComboFix.txt
	FOR /F "TOKENS=*" %%H IN ( WowErr02 ) DO @SED -r "/system cannot find the file|process cannot access the file/Id; /,$/N;s/,\n.*//;" "%%H" >>ComboFix.txt
	ECHO.>>ComboFix.txt
	%KMD% /D /C List-C.bat %%G 2>ErrTrap%%G
	IF EXIST WowErr.dat GOTO MiscFixB
	)

PEV -k NIRCMD.%cfext%

IF NOT EXIST WowDone.dat ECHO.	/wow section %not completed%>>ComboFix.txt
	
@ECHO.>>ComboFix.txt
@DEL /A/Q List-C.bat WowDone.dat WowErr0? >N_\%random% 2>&1
@ECHO.


:NTOSKRNL
IF EXIST XPRD.NFO GOTO CatchM
GREP -lisq update_load %System%\ntoskrnl.exe && CALL :ND_sub "%System%\ntoskrnl.exe" "update_load"
GREP -lisq update_load %System%\ntkrnlpa.exe && CALL :ND_sub "%System%\ntkrnlpa.exe" "update_load"


:CatchM
IF EXIST W6432.dat GOTO RemMtPtB
IF EXIST drev.dat (
	PEV -tx80000 -files:drev.dat -tf -output:CatchM00
	TYPE CatchM00 >> catch_E.dat
	TYPE CatchM00 >>catch_k.dat
	DEL /A/F TYPE CatchM00
	)
GREP -Fsq :\ catch_k.dat || GOTO CatchMB
SED "/:\\/!d; s/^\s*//g; s/\s*$//g" catch_k.dat >catch_kk.dat
MOVE /Y catch_kk.dat catch_k.dat >N_\%random%
FOR /F "TOKENS=*" %%G IN ( catch_k.dat ) DO @CALL Catch-sub.cmd "%%~G" >N_\%random%
IF EXIST f_system GOTO CatchMB


:CatchM-E
IF EXIST catch_E.dat (
	FOR /F "TOKENS=*" %%G IN ( catch_E.dat ) DO @(
		Catchme -l N_\%random% -i "%%~G"
		Catchme -l N_\%random% -E "%%~G"
		)
	DEL /A/F catch_E.dat
	)>N_\%random% 2>&1


:CatchMB
IF NOT EXIST catch_k*.dat GOTO RemMtPtB

TYPE catch_k*.dat >temp00 2>N_\%random%
SED "/:\\/!d; s/\x22//g; s/.*/\x22&\x22/" temp00 > temp01
SORT /M 65536 temp01 /O temp02
SED -r "$!N; /^(.*)\n\1$/I!P; D" temp02 >>d-del4AV.dat
DEL /A/F/Q temp0? >N_\%random% 2>&1


IF EXIST catch_k.dat GREP -iqs "\.sys.?$" catch_k.dat && IF EXIST suspectSvc.dat  (
	FOR /F "TOKENS=*" %%G IN ( suspectSvc.dat ) DO @(
		SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%G">temp00
		SED "/Imagepath.*\.sys$/I!d; s/.*	//; s/^system32/%%G	%system:\=\\%/I; s/^systemroot/%%G	%systemroot:\=\\%/I; s/^\\??\\/%%G	/" temp00 >>suspectSvcB.dat
		DEL /A/F temp00
		)
	SED "/\.sys$/I!d; s/\\\_/\\\\_/g; s/\\\x7B/\\\\\x7B/g; s/\\@/\\\\@/g; s/\\\^/\\\\\^/g; s/\$/\\\$/g; s/\\\~/\\\\\~/g; s/\\\./\\\\./g" catch_k.dat >catch_k_drv.dat
	ECHO.::::>>catch_k_drv.dat
	GREP -Fif catch_k_drv.dat suspectSvcB.dat >catch03
	FOR /F "DELIMS=	" %%G IN ( catch03 ) DO @(
		SWREG EXPORT "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\services_%%~G.reg.dat" >N_\%random%
		ECHO.[-HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%G]>>CregC.dat
		ECHO.[-hkey_users\temphive\%controlset%\services\%%~G]>>erunt.dat
		SWREG restore "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G" cfdummy /F >N_\%random% 2>&1
		)
	DEL /A/F/Q catch0? N_\*
	)>N_\%random% 2>&1


IF EXIST d-del4AV.dat (
	SORT /M 65536 d-del4AV.dat /O d-del4AV00
	SED -r "$!N; /^(.*)\n\1$/I!P; D" d-del4AV00 >\qoobox\lastrun\d-del4AV.dat
	COPY /Y %SystemDrive%\qoobox\lastrun\d-del4AV.dat
	DEL /A/F d-del4AV00
	)>N_\%random% 2>&1

IF EXIST %SystemDrive%\qoobox\lastrun\catch_k* DEL /A/F/Q %SystemDrive%\qoobox\lastrun\catch_k* N_\* >N_\%random% 2>&1
SED -r "/\x3b::@@::/,$!d; /\x3b::@@::/d" CregC.dat >\qoobox\lastrun\CregC.old
COPY /Y erunt.dat %SystemDrive%\qoobox\lastrun\ >N_\%random%


:RemMtPtB
IF NOT EXIST W32Diag.dat GOTO LSPWait
@PEV -td -te "%SystemRoot%\*" -output:RemMtPts
@FOR /F "TOKENS=*" %%G IN ( RemMtPts ) DO @(
	SWXCACLS "%%~G" /GA:F /Q
	RD "%%~G" 
	)>N_\%random% 2>&1
@DEL /A/F RemMtPts

SET count_LSP=0
:LSPWait
IF NOT EXIST LSPDone PEV WAIT 2500
Set /a count_LSP+=2 >N_\%random%
If %count_LSP% LSS 20 IF NOT EXIST LSPDone GOTO LSPWait
set count_LSP=


ECHO.REGEDIT4>CregB.dat
ECHO.>>CregB.dat
SED -r "/\[-hkey_local_machine\\system\\currentcontrolset\\Enum/I!d" Creg.dat >>CregB.dat
SED -r "/\[-hkey_local_machine\\system\\currentcontrolset\\Enum/I!d" CregC.dat >>CregB.dat
PEV EXEC /S "%CD%\REGT.%cfext%" /S "%CD%\CregB.dat"
@title .

IF EXIST drev.dat IF NOT EXIST CFReboot.dat (
	SED "s/\x22//g" drev.dat >MemCheck00
	ECHO.::::>>MemCheck00
	PV -s -q >MemCheck01
	SED -r "/.*	/!d; s///; s/.*/\L&/s" MemCheck01 >MemCheck02
	IF EXIST MemCheck02 GREP -Fixsqf MemCheck00 MemCheck02 && TYPE myNul.dat >CfReboot.dat
	DEL /A/F/Q MemCheck0?
	IF EXIST W32BDiag.dat SWXCACLS PV.%cfext% /P /GE:F /Q
	)>N_\%random% 2>&1


IF NOT EXIST CFReboot.dat GREP -sq \\ erunt.dat d-del4AV.dat d-del3??.dat && TYPE myNul.dat >CfReboot.dat


IF EXIST CfReboot.dat (
	DEL /A/F CfReboot.dat
	CALL Boot.bat
	EXIT
	)


START /I /B %ComSpec% /C CALL FIND3M.bat
EXIT



:Abort
NIRCMD WIN HIDE TITLE .
NIRCMD WIN HIDE ITITLE ": ."
ECHO.GetObject("winmgmts:" ^& "{impersonationLevel=impersonate}!\\" ^& "." ^& "\root\default:SystemRestore").Disable("")>SR.vbs
ECHO.GetObject("winmgmts:" ^& "{impersonationLevel=impersonate}!\\" ^& "." ^& "\root\default:SystemRestore").Enable("")>>SR.vbs
	
SWREG copy "hkcu\control panel\international_combofixbackup" "hkcu\control panel\international" /s >N_\%random% 2>&1
SWREG copy "hku\.default\control panel\international_combofixbackup" "hku\.default\control panel\international" /s >N_\%random% 2>&1
PEV -rtf "%SYSDIR%\config\Sys_link00" && PEV MOVEEX "%SYSDIR%\config\Sys_link00"	

SWREG QUERY "HKLM\Software\Swearware" /V SPTD >N_\%random% 2>&1 &&(
	SWREG ADD "HKLM\System\CurrentControlSet\Services\SPTD" /V Start /t REG_DWORD /d 0
	)>N_\%random% 2>&1
	
SWREG QUERY "HKLM\Software\Swearware" /V Alcohol >Alcohol00 2>&1 &&(
	SED -r "/.*	/!d; s///" Alcohol00 > Alcohol01
	SWREG DELETE "HKLM\Software\Swearware" /V Alcohol
	FOR /F "TOKENS=*" %%G IN ( Alcohol01 ) DO @SWREG ADD "HKLM\System\CurrentControlSet\Services\%%~G" /V Start /t REG_DWORD /d 0
	)>N_\%random% 2>&1

ECHO.REGEDIT4>rehide.reg
ECHO.>>rehide.reg
ECHO.[hkey_current_user\software\microsoft\windows\currentversion\explorer\advanced]>>rehide.reg
ECHO."hidden"=dword:00000002 >>rehide.reg
ECHO."hidefileext"=dword:00000001 >>rehide.reg
ECHO."showsuperhidden"=dword:00000000 >>rehide.reg
ECHO.[-hkey_local_machine\software\microsoft\windows\currentversion\app paths\combofix.exe]>>rehide.reg
ECHO.[-hkey_current_user\control panel\international_combofixbackup]>>rehide.reg
ECHO.[-hkey_users\.default\control panel\international_combofixbackup]>>rehide.reg
ECHO.[-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PEVSystemStart]>>rehide.reg
ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\swearware]>>rehide.reg
ECHO."SPTD"=->>rehide.reg
ECHO."Alcohol"=->>rehide.reg
REGEDIT.EXE /s rehide.reg

SWXCACLS "%systemdrive\qoobox" /reset /q
IF EXIST %SystemRoot%\erdnt\cfrecovery.bat DEL /A/F %SystemRoot%\erdnt\cfrecovery.bat

RD /S/Q %SystemDrive%\Qoobox >N_\%random% 2>&1
FOR %%G IN (
"%SystemDrive%\VundoFix Backups"
%SystemDrive%\Deckard
%SystemDrive%\_OTMoveIt
%SystemDrive%\Avenger
"%SystemRoot%\!submit"
%SystemDrive%\SDFix
) DO @IF EXIST "%%~G" (
	RD "%%~G"
	IF EXIST "%%~G" RD /S/Q "%%~G"
	)>N_\%random% 2>&1
RD /S/Q %SystemRoot%\erdnt\subs >N_\%random% 2>&1
RD /S/Q %SystemRoot%\erdnt\Hiv-backup >N_\%random% 2>&1
NIRCMD exec hide "%CD%\%KMD%" /c " CSCRIPT //E:VBSCRIPT //NOLOGO //B "%~DP0SR.vbs" "
COPY /Y /B NircmdB.exe %SystemRoot%\NIRCMD.exe >N_\%random% 2>&1
IF EXIST Vista.krl IF EXIST "%SYSDIR%\VSSADMIN.EXE" VSSADMIN.EXE DELETE SHADOWS /ALL /QUIET >N_\%random% 2>&1
:: NIRCMD.exe infobox "ComboFix is uninstalled" "Info"
NIRCMD.EXE INFOBOX "%LINE50%" ""


:AbortB
PEV -k %SystemRoot%\* and { SWXCACLS.exe or SWSC.exe or PEV.exe or sed.exe or grep.exe or zip.exe or mbr.exe } or %SYSDIR%\SWSC.exe

FOR %%G IN (
%SystemRoot%\SWREG.exe
%SystemRoot%\SWXCACLS.exe
%SystemRoot%\SWSC.exe
%SYSDIR%\SWSC.exe
%SystemRoot%\PEV.exe
%SystemRoot%\sed.exe
%SystemRoot%\grep.exe
%SystemRoot%\zip.exe
%SystemRoot%\mbr.exe
%SystemDrive%\bug.txt
%SystemDrive%\CF-Submit.htm
) DO @IF EXIST %%G DEL /A/F %%G >N_\%random% 2>&1

IF DEFINED sfxname IF NOT EXIST abortB GREP -Esq "FIXLSP.bat|C.o.m.b.o.F.i.x" "%sfxname%" && DEL /A/F "%sfxname%" >N_\%random% 2>&1


:AbortC
NIRCMD WIN HIDE TITLE .
NIRCMD WIN HIDE ITITLE ": ."
PEV.exe -k { *.%cfext% or NIRCMD.exe } and not %ComSpec%
%SystemRoot%\regedit.exe /s "%~DP0fin.dat"
SWREG copy "hkcu\control panel\international_combofixbackup" "hkcu\control panel\international" /s
SWREG copy "hku\.default\control panel\international_combofixbackup" "hku\.default\control panel\international" /s
SWREG COPY "hkcu\console_combofixbackup" "hkcu\console" /s >N_\%random% 2>&1
SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32" /RESET /Q
SWREG DELETE "hkcu\console_combofixbackup" >N_\%random% 2>&1

START NircmdB.exe SYSREFRESH INTL
COPY /Y /B NircmdB.exe %SystemRoot%\NIRCMD.exe
@CALL RKEY.cmd

CD ..
IF EXIST %~DP0Vista.krl IF NOT EXIST %SystemDrive%\Qoobox CSCRIPT.exe //NOLOGO //E:VBSCRIPT //T:30 "%~DP0restore_pt.vbs"
START NIRCMD.exe CMDWAIT 5000 EXECMD DEL /A/F %SystemRoot%\NIRCMD.exe
START NIRCMD.exe EXECMD "RD /S/Q "%~DP0"
START NIRCMD.exe WIN CLOSE CLASS #32770
IF EXIST "%SYSDIR%\config\Sys_link00" NirCmd.exe exitwin reboot
EXIT

:AbortD
:: Start NIRCMD infobox "Interference detected~n~nPlease perform a Rootkit Scan" "Abort!"
START NIRCMD INFOBOX "%LINE66%" ""
EXIT

:Not_NT
PAUSE
CLS
START NircmdB.exe INFOBOX "Incompatible OS. ComboFix only works for Windows 2000 and XP~n~nOS incompatible. ComboFix ne fonctionne que pour Windows 2000 et XP~n~nOS niet compatibel. ComboFix kan enkel gebruikt worden voor Windows 2000 en XP~n~nInkompatibles Betriebssystem. ComboFix läuft nur unter Windows 2000 und XP~n~nKäyttöjärjestelmä ei ole yhteensopiva. ComboFix toimii vain Windows 2000- ja XP-käyttöjärjestelmissä.~n~nSistema Operativo Incompat¡vel. ComboFix apenas funciona em Windows 2000 e XP~n~nSO. Incompatible. ComboFix funciona únicamente en Windows 2000 y XP~n~nOS Incompatibile. Combofix funziona solo su windows 2000 e XP" "Error - Win32 only"
EXIT

:DateErr
SWREG ADD "HKLM\Software\Swearware" /v 44617465204572726F72 /d "idk"
TYPE myNul.dat >ABORTB
:: CALL NircmdB.exe QBOXCOMTOP "Current date is ~%CurrDate.yyyy-MM-dd%. ComboFix has expired~n~nClick 'Yes' to run in REDUCED FUNCTIONALITY mode~n~nClick 'No' to exit" "Version_%%ver_CF%%" RETURNVAL 5"
CALL NircmdB.exe QBOXCOMTOP "%Line5%" "" FILLDELETE ABORTB
PEV -rtf -dl10 .\md5sum.pif >Expired &&(
	IF DEFINED sfxname GREP -sq "FIXLSP.bat" "%sfxname%" && DEL /A/F "%sfxname%" >N_\%random% 2>&1
	GOTO ABORTB
	)
IF EXIST ABORTB GOTO ABORTB
TYPE myNul.dat >XPRD.NFO
GOTO :EOF
EXIT


:Foreign
REM - NIRCMD INFOBOX "The following files were trying to attach to ComboFix. They shall be disabled~nKindly note down on paper, the name of each file. We may need it later~n~n%%G" "Parasites found !!""
SED ":a; $!N;s/\n/~n/;ta;P;D" ForeignA.dat >Foreign_Comment
FOR /F "TOKENS=*" %%G IN ( Foreign_Comment ) DO @NIRCMD INFOBOX "%Line75%" ""
DEL Foreign_Comment


FOR /F "TOKENS=*" %%G IN ( ForeignA.dat ) DO @IF EXIST "%%~G" @(
	ECHO."%%G"	"%%~G.vir">>Foreign.dat
	CALL :FREE "%%G"
	SWXCACLS "%%~DPG" /OA
	SWXCACLS "%%~DPG" /GA:F /Q
	MOVE /Y "%%~G" "%%~G.vir"
	IF EXIST "%%~G" (
		ECHO.%%G>>ForeignB.dat
		) ELSE PEV MoveEx "%%~G.vir" "%%~G"
		)>N_\%random% 2>&1 ELSE ECHO.%%G>>ForeignB.dat

IF EXIST ForeignB.dat GOTO ForeignB

IF NOT EXIST W6432.dat IF EXIST wtf_tdssserv (
	CALL NT-OS.cmd
	EXIT
	)

DEL /A/F c.mrk
START "." %KMD% /D /C C.bat %sfxcmd%
EXIT


:ForeignB
TYPE ForeignB.dat >>d-delA.dat
FOR /F "TOKENS=*" %%G IN ( ForeignB.dat ) DO @(
	ECHO.%%G>>Catch_KB.dat
	CALL Catch-sub.cmd "%%~G"
	)>N_\%random% 2>&1

IF EXIST Catch_KB.dat COPY /Y Catch_KB.dat %SystemDrive%\Qoobox\LastRun\RK_Catch_KB.dat >N_\%random% 2>&1
IF NOT EXIST W6432.dat CALL NT-OS.cmd
@GOTO :EOF


:NoRegt
NIRCMD beep 3000 200
:: NIRCMD infobox "%SystemRoot%\regedit.exe is missing~n~nCopy one from another machine" "Terminal Error - Missing file"
NIRCMD INFOBOX "%LINE4%" ""
CD \
NIRCMD.EXE EXECMD RD /S/Q "%~DP0"
EXIT


:LogHeader
SWREG QUERY "HKLM\Software\Swearware" /v runs | SED "/.*	/!d; s///" >cfrun
@FOR /F "TOKENS=*" %%G IN ( cfrun ) DO SET "CFRUN=%%G"
@SET /A cfrun+=1
SWREG ADD "HKLM\Software\Swearware" /v Runs /d %cfrun%

@IF NOT EXIST f_system SET "F_System=FAT32"
@IF EXIST W6432.dat SET "Processor_Architecture=x64"

ECHO."ComboFix %ver_CF% - %username% %date:~-10%  %time:~,-3%.%cfrun%.%NUMBER_OF_PROCESSORS% - %F_System%%Processor_Architecture% %SafeBoot_option%">LogHeader00
SED -r "s/\x22//g; s/\s*$//g " LogHeader00 >ComboFix.txt
DEL LogHeader00
@SET cfrun=
@SET F_System=


ECHO.X5O!P%%@AP[4\PZX54(P^^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*/ >"%temp%\Av-test.txt"

>>ComboFix.txt (
IF EXIST OsId.txt GREP . OsId.txt
IF DEFINED sfxname ECHO."%Running from%: %sfxname%"| SED -r "s/\x22//g; s/\s*$//g "
IF DEFINED sfxcmd ECHO."%Command switches used%" :: %sfxcmd%| SED "s/\x22//g"
IF EXIST Resident.txt SORT /M 65536 Resident.txt | SED -r "$!N; /^(.*)\n\1$/I!P; D"
IF EXIST restore_pt.dat GREP -q "new restore point" restore_pt.dat && ECHO.%RestorePoint%&& DEL restore_pt.dat
TYPE "%temp%\Av-test.txt" >N_\Av-test.txt 2>&1 ||(
	ECHO. * %Resident AV is active%
	ECHO.
	) )

@GOTO :EOF



:PINGTEST
@HIDEC PING -n 1 -w 250 127.0.0.1
@PV -d2000 -xa PING.%cfext% ||@(
	PV -m PING.%cfext% >pingtest00
	SED -R "1,3d; /((10|4)00000|[4-9]\S{7})\s*\d* .:\\/d; /%system:\=\\%\\(xpsp2res|Normaliz|urlmon|odbcint|imon)\.dll/Id; /\)|\\/I!d; s/.*(.:\\)/\1/" pingtest00 >pingtest01
	GREP -Fixf ForeignWht pingtest01 >pingtest02 &&PEV -tx50000 -files:pingtest02 -tf -t!o "%%~G" -output:pingtest03
	IF NOT EXIST pingtest03 MOVE /Y pingtest02 pingtest03
	FOR /F "TOKENS=*" %%G IN ( pingtest03 ) DO @CATCHME -l N_\%random% -i "%%~G" >CatchDeny
	PEV -k PING.%cfext%
	DEL /Q pingtest0?
	)
IF EXIST W32BDiag.dat SWXCACLS PV.%cfext% /P /GE:F /Q
@GOTO :EOF


:CHECK_CF
@IF NOT DEFINED sfxname (
	@SWREG QUERY "hklm\software\microsoft\windows\currentversion\app paths\combofix.exe" /ve |SED "/.*	/!d; s///" >sfxname01
	@FOR /F "TOKENS=*" %%G IN  ( sfxname01 ) DO @SET "sfxname=%%G"
	)
	
@SET SFXNAME >sfxname0a
GREP -Fisq %SystemDrive% sfxname0a ||GOTO :EOF
@SETPATH >SETPATH00.bat
@CALL SETPATH00.bat
@DEL SETPATH00.bat
@GREP -Eisq "https*:\/\/(subs.geekstogo.com|(download.bleepingcomputer.com)\/sUBs)\/" "%Cache%\Content.IE5\index.dat" "%LocalAppData%\Google\Chrome\User Data\Default\Cache\data_1" "%AppData%\Opera\Opera\Profile\download.dat" &&GOTO :EOF
@IF EXIST "%AppData%\Mozilla\Firefox\" PEV -tx50000 -tf -d:G15 "%AppData%\Mozilla\Firefox\Profiles\*" and places.sqlite or downloads.sqlite -output:CHECK_CF00
@GREP -F :\ CHECK_CF00 >CHECK_CF01
@SED ":a; $!N; s/\n/\x22 \x22/; ta; s/.*/\x22&\x22/" CHECK_CF01 >CHECK_CF02
@FOR /F "TOKENS=*" %%G IN  ( CHECK_CF02 ) DO @GREP -Eisq "https*:\/\/(download.bleepingcomputer.com)\/sUBs\/" %%G &&GOTO :EOF
@REM NIRCMD INFOBOX "http://download.bleepingcomputer.com/sUBs/ComboFix.exe~n~nComboFix.exe may be downloaded from any of the above sites. If you~nhave downloaded from some other site, there's a likely chance that it~nmay be tainted. For peace of mind, I suggest that you delete the current~ncopy and get a fresh one." "Caution"
@NIRCMD INFOBOX "%Line84%" ""
@GOTO :EOF


:CRYPT
@IF EXIST "%SYSDIR%\dllcache\cryptsvc.dll" (
	ATTRIB -H -R -S "%SYSDIR%\dllcache\cryptsvc.dll"
	COPY /Y "%SYSDIR%\dllcache\cryptsvc.dll" "%SYSDIR%\cryptsvc.dll"
	)
	
@IF NOT EXIST "%SYSDIR%\cryptsvc.dll" (
	PEV -fs32 -tx50000 -limit:1 -samdate -tf "%SystemRoot%\cryptsvc.dll" -output:crypt || PEV -fs32 -tx50000 -limit:1 -samdate -tf "%SystemDrive%\I386\cryptsvc.dll" -output:crypt
	FOR /F "TOKENS=*" %%G IN ( crypt ) DO @(
		ATTRIB -H -R -S "%%~G"
		COPY /Y "%%~G" "%SYSDIR%\cryptsvc.dll"
		))
		
@GREP -Fisq :\ crypt ||	CALL ND_.bat "%SYSDIR%\cryptsvc.dll" "FINDNOW"
	
@IF EXIST ND_05 (
	SED 1!d ND_05 >ND_06
	FOR /F "TOKENS=*" %%G IN ( ND_06 ) DO @(
		CALL :FREE "%%~G"
		COPY /Y "%%~G" "%SYSDIR%\cryptsvc.dll"
		)
	DEL /A/F/Q ND0?
	)

@DEL /A/F crypt
@GOTO :EOF


:ND_sub
@ECHO.
@ECHO.System file is infected !! Attempting to restore
@ECHO.  "%~1"
@%KMD% /D /C ND_.bat "%~1" >N_\%random% 2>&1
@GOTO :EOF

:W32Diag
REM - obsolete
@GOTO :EOF
IF NOT EXIST kmd.dat ECHO.%KMD%>kmd.dat
PEV -rtf -t!o -s=0 -DG1 "%SystemRoot%\*" -output:W32Diag00
FOR /F "TOKENS=*" %%G IN ( W32Diag00 ) DO @(
	ECHO.%%G>W32DiagBoot
	SWXCACLS.%cfext% "%%G" /P /GA:F /GS:F /GP:X /GU:X /Q
	ATTRIB +R "%%G"
	)
@DEL /A/F W32Diag00
@IF EXIST W32DiagBoot CALL Boot-RK.cmd
@GOTO :EOF

:SPTD
@SWREG ADD "HKLM\System\CurrentControlSet\Services\SPTD" /V Start /t REG_DWORD /d 4 >N_\%random% 2>&1
@SWREG ADD "HKLM\Software\Swearware" /V SPTD /d SPTD >SPTD.dat 2>N_\%random%
@IF NOT EXIST "%ProgFiles%\Alcohol Soft\*" GOTO ALCOHOLC

:ALCOHOL
@(
ECHO.ACPI	
ECHO.isapnp	
ECHO.msisadrv	
ECHO.partmgr	
ECHO.pci	
ECHO.vdrvroot	
)>BBE00

@SWSC QUERY sojubus | GREP -Eisq "STATE +:.* RUNNING" &&(
	CALL :ALCOHOLB sojubus
	)||(
	SWSC QUERYEX OPTIONS= config TYPE= DRIVER GROUP= "Boot Bus Extender" >BBE01
	SED -r "/(SERVICE|BINARY_PATH)_NAME *: +/!d; s///; s/.*\\System32\\Drivers\\/  %system:\=\\%\\Drivers\\/I" BBE01 | SED -r ":a; $!N;s/\n +/	/;ta;P;D" >BBE02
	GREP -ivf BBE00 BBE02 | GREP -Fi "	%SYSDIR%\drivers" >BBE03
	FOR /F "TOKENS=1* DELIMS=	" %%G IN ( BBE03 ) DO @GREP -Fisq "c:\pnpa.pdb" "%%~H" &&CALL :ALCOHOLB "%%~G"
	)
@DEL /A/F/Q BBE0? >N_\%random% 2>&1
@IF EXIST SPTD.dat GOTO ALCOHOLC
@GOTO :EOF
		
:ALCOHOLB
@DEL /A/F/Q BBE0? >N_\%random% 2>&1
@SWREG ADD "HKLM\System\CurrentControlSet\Services\%~1" /V Start /t REG_DWORD /d 4 >Alcohol 2>N_\%random%
@SWREG ADD "HKLM\Software\Swearware" /V Alcohol /d "%~1" >N_\%random% 2>&1

:ALCOHOLC
@IF EXIST SPTD.dat DEL /A/F SPTD.dat >N_\%random% 2>&1
@NIRCMD WIN HIDE TITLE .
@NIRCMD LOOP 2 80 BEEP 3000 200
@REM NIRCMD INFOBOX "~t!! Warning !!~n~NCD-emulation drivers are running on this machine.~nComboFix needs to temporarily disable them.~n~nWhen you uninstall ComboFix, they will be re-enabled." "CD-emulation !!"
@NIRCMD INFOBOX "%Line86%" ""
@IF EXIST c.mrk DEL /A/F c.mrk
@SWREG ADD "hklm\software\microsoft\windows\currentversion\runonce" /v "combofix" /d "\"%cd%\%KMD%\" /c \"%cd%\C.bat\""
@SWREG ADD "hklm\software\microsoft\windows\currentversion\run" /v "combofix" /d "\"%cd%\%KMD%\" /c \"%cd%\C.bat\""
@NIRCMD EXITWIN REBOOT FORCE
@PEV WAIT 20000
@Catchme -U
@EXIT


:Whistler3
@FOR /F %%G IN ( Whistler.dat ) DO @(
	dd if="%%G" of=%%~NG_Head.dat bs=32k count=1 || ECHO.%%G>dd_stop
	IF EXIST %%~NG_Head.dat (
		dd if=%%~NG_Head.dat of=%%~NG_sector0.dat bs=512 count=1
		dd if=%%~NG_Head.dat of=%%~NG_sector8.dat bs=4608 count=1
		TYPE %%~NG_sector0.dat >> %%~NG_sector8.dat
		dd if=%%~NG_sector8.dat of="%%G" bs=5k count=1
		DEL /A/F %%~NG_Head.dat %%~NG_Sector0.dat %%~NG_Sector8.dat
		))
@GOTO :EOF

:ChkPrivs
@IF EXIST Vista.krl HIDEC SWSC STOP iphlpsvc
@(
TYPE myNul.dat > ..\TestPrivs.txt
)2>NULL ||(
	START PEV EXEC %~DP0NIRCMD.%cfExt% EXEC SHOW %COMSPEC% /c %~DP0C.bat
	EXIT
	)
@DEL /A/F ..\TestPrivs.txt
@IF EXIST WhistlerVBR.dat IF EXIST VBR.PIF CALL :VBR_B >N_\%random% 2>&1
@GOTO :EOF

:VBR_B
@PEV UZIP VBR.PIF VBR\
@IF EXIST Vista.krl (
	FOR /L %%G IN ( 2049,1,2064 ) DO @RMBR -w %%G VBR\VBR_%%G.DAT
	RMBR -c 2049 1 test.vbr
	FC test.vbr VBR\VBR_2049.DAT && ECHO.\\.\PhysicalDrive0 - Bootkit Cidox was found and disinfected>Cidox.dat
) ELSE (
	FOR /L %%G IN ( 64,1,78 ) DO @RMBR -w %%G VBR\VBR_%%G.DAT
	RMBR -c 64 1 test.vbr
	FC test.vbr VBR\VBR_64.DAT && ECHO.\\.\PhysicalDrive0 - Bootkit Cidox was found and disinfected>Cidox.dat
	)
@RD /S/Q VBR
@DEL /A/F VBR.PIF test.vbr
@IF EXIST Cidox.dat ECHO.>>Cidox.dat
@GOTO :EOF


:FREE
@SWXCACLS "%~1" /OA
@SWXCACLS "%~1" /P /GE:F /I ENABLE /Q
@ATTRIB -H -R -S -A "%~1"
@GOTO :EOF

:VolSnap0
@IF EXIST NoMbr.dat GOTO :EOF
@START NIRCMD CMDWAIT 3000 EXEC HIDE PEV -k RMBR.%cfExt%
@RMBR -t 
@PEV -k NIRCMD.%cfext%
@GREP -Fsq ">>UNKNOWN [" mbr.log && CALL :VolSnap
@DEL /A/F mbr.log
@GOTO :EOF
			
:VolSnap
@CATCHME -i
@PEV -rtg "%system%\drivers\volsnap.sys" &&(
	ECHO.>VolSnp.dat
	IF NOT EXIST "\QooBox\32788R22FWJFW" MD "\QooBox\32788R22FWJFW"
	CALL :FREE "%system%\drivers\volsnap.sys"
	PEV -zip"volsnap.sys.zip" "%system%\drivers\volsnap.sys"
	PEV UZIP "volsnap.sys.zip" "%CD%"
	PEV -rtf -s-1500 "%CD%\volsnap.sys" && COPY /Y "%system%\drivers\volsnap.sys"
	IF EXIST Volsnap_Handles00 (
		START NIRCMD INFOBOX "The driver 'VOLSNAP.SYS' is patched with a rootkit.~n~nAttempting disinfection.~n~nBe patient as this may take several minutes" "Patched Volsnap.sys !!"
		PEVB PDUMP >Pdump00
		SED "/./{H;$!d;};x;/\nSYSTEM (The Kernel)/I!d;" Pdump00 | SED -R "/^Thread: \((\d*)\) .*\(0x[^)]*\)$/!d; s//\1/" >Pdump01
		FOR /F %%G IN ( Pdump01 ) DO @PEVB TSUSPEND %%G
		DEL /A/F/Q Pdump0?
		HANDLE "%system%\drivers\volsnap.sys" >temp01
		SED -R "/.*pid: (\d*) +(\S*): .:\\.*/I!d;s//@Handle -c \2 -y -p \1/" temp01 >Handle_Volsnap.bat
		CALL Handle_Volsnap.bat
		DEL /A/F temp01 Handle_Volsnap.bat Volsnap_Handles00
		PEV -k NIRCMD.%cfext%
		)
	MOVE /Y "%system%\drivers\volsnap.sys" "\QooBox\32788R22FWJFW"		
	MOVE /Y "volsnap.sys" "%system%\Drivers"
	CATCHME -l N_\%random% -i "%system%\drivers\volsnap.sys"
	DEL /A/F "volsnap.sys.zip"
	)
@GOTO :EOF

