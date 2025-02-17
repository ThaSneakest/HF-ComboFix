
@IF EXIST mdCheck00.dat DEL /A/F mdCheck00.dat
@IF EXIST CHCP.bat CALL CHCP.bat >N_\%random% 2>&1
@IF NOT EXIST debug???.dat ECHO OFF

IF EXIST XPRD.NFO GOTO DozhSvc
IF NOT DEFINED ControlSet CALL CCS.bat
IF NOT [%1]==[] GOTO STAGE%1

@ECHO:%Stage%1 >WowErr.dat


PEV -k SWSC.*
START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k Handle.%cfext%
Handle . >Handle00
PEV -k NIRKMD.%cfext%
GREP -Fivf unhand.dat Handle00 >HandleList

SED -r "/^System +pid:.*: (.:\\.*\.(dll|sys))$/I!d; s//\1/" HandleList >temp0001
SORT /M 65536 temp0001 /T "%CD%" /O temp0002
SED -r "$!N; /^(.*)\n\1$/I!P; D" temp0002 >temp000A
DEL /A/F temp0001 temp0002

SED -r "/^winlogon.exe +pid:.*: (.:\\.*\....)$/I!d; s//\1/" HandleList >temp0001
SORT /M 65536 temp0001 /T "%CD%" /O temp0002
SED -r "$!N; /^(.*)\n\1$/I!P; D" temp0002 >temp000B
DEL /A/F temp0001 temp0002

TYPE temp000A temp000B >Unhandled.dat 2>N_\%random%

IF EXIST FdsvOK (
	ECHO.::::>> temp000A
	PEV -fs32 -tx25000 -files:temp000A -t!o -t!g -tpmz -t!j | MTEE Suspect_feixue >>d-del_A.dat
	ECHO.::::::>>Suspect_feixue
	GREP -Fisf Suspect_feixue HandleList >temp0001
	SED -R "/^System +pid: (\d*) +(\S*): .:\\.*\.(dll|sys)$/I!d;s//@Handle -c \2 -y -p \1/" temp0001 >HandleIt.bat
	DEL /A/F temp0001
	ECHO.::::>> temp000B
	PEV -fs32 -tx25000 -files:temp000B -t!o -t!g -tpmz -output:temp000C
	GREP -Fsq :\  temp000C &&(
		GREP -Fisf temp000C HandleList >temp0001
		SED -R "/.* +pid: (\d*) +(\S*): .*/I!d; s//@Handle -c \2 -y -p \1/" temp0001 >temp0002
		SORT /M 65536 temp0002 /T %cd% /O temp0003
		SED -r "$!N; /^(.*)\n\1$/I!P; D" temp0003 >>HandleIt.bat
		SED "/:\\/!d;s/$/ [/" temp000C >temp000D
		DEL /A/F temp0001 temp0002 temp0003
		)
	)>N_\%random% 2>&1



SETLOCAL
SET "Temp=%cd%"
IF NOT EXIST W6432.dat GREP -Fsq :\ temp000D &&(
	IF EXIST W6432.dat (
		PEV PLIST > temp0001
		) ELSE Catchme -l N_\%random% -Iapx >temp0001
	SED -r "s/ \[[0-9]+\] 0x[0-9a-f]+$//I; s/^\\SystemRoot\\/%SystemRoot:\=\\%\\/I; s/^\\\?\?\\//; s/^\\/%systemdrive%&/; /:\\/!d" temp0001 > temp0002
	GREP -Fisf temp000D temp0002 > temp0003
	SED -r "/:\\/!d; s_.*_@PEV EXEC /S NIRCMD KILLPROCESS \x22&\x22_" temp0003 >>HandleIt.bat
	DEL /A/F temp0001 temp0002 temp0003
	)>N_\%random% 2>&1
ENDLOCAL


@ECHO.@ECHO.^>NULL >> HandleIt.bat
START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k Handle.%cfext%
Call HandleIt.bat >N_\%random% 2>&1
PEV -k NIRKMD.%cfext%
DEL /A/F/Q HandleIt.bat temp000? Handle00 HandleList >N_\%random% 2>&1


IF EXIST %SystemDrive%\zzz.sys START NIRCMD service stop zzz


IF EXIST KiLLNot (
	IF EXIST DoStepDel Call :PreRunDel
	ECHO.&ECHO:%Stage%1
	GOTO Stage1
	)

NIRCMD WIN CLOSE ITITLE "Project"
NIRCMD WIN CLOSE TITLE "kill"
PEV -k * -preg"\\(wscript|temp[12]|[^\\]*\..)\.exe$"

@IF DEFINED ActiveX ECHO."%ActiveX%\">temp0000
@IF DEFINED SysTemp ECHO."%SysTemp%\">>temp0000
@IF DEFINED Temp_LFN ECHO."%Temp_LFN%\">>temp0000
@IF DEFINED Cache ECHO."%Cache%\">>temp0000
@IF DEFINED DefaultCache ECHO."%DefaultCache%\">>temp0000
@IF DEFINED temp ECHO."%temp%\">>temp0000
@IF DEFINED Fonts ECHO."%Fonts%\">>temp0000

SED -r "/^..../!d; /\*|\?/d; s/\x22//g" temp0000 >temp0001
PV -o"%%i\t%%f" >temp0002
GREP -Fif temp0001 temp0002 >temp0003
SED -r "s/(.*)	.*/@PV -kfi \1/" temp0003 >temp0004.bat
@ECHO.@ECHO.^>NULL >> temp0004.bat
CALL temp0004.bat >N_\%random% 2>&1
@DEL /A/F/Q temp000? temp0004.bat >N_\%random% 2>&1

PV -o%%c\t%%u\t%%f\t%%i * >temp0000
SED "/^[0-9][0-9]	%username%	/I!d; /%SYSDIR:\=\\%\\cmd.exe\|%cd:\=\\%/Id; s/.*	/@PV -kfi /" temp0000 >>del03.bat
@ECHO.@ECHO.^>NULL >> del03.bat
CALL del03.bat >N_\%random% 2>&1
DEL /A/F/Q del03.bat temp000? >N_\%random% 2>&1

IF EXIST DoStepDel Call :PreRunDel
ECHO.&ECHO:%Stage%1


:STAGE1
@Echo:%Stage%2 >WowErr.dat
@Echo:%Stage%2

HIDEC %KMD% /c " %SystemRoot%\PEV.exe -loadline:ViPev01 -output:ViPev02 &&DEL /A/F ViPev01"

:: - Enumerating Services
START NIRKMD CMDWAIT 10000 EXEC HIDE PEV -k CSCRIPT.%cfext%
NircmdB.exe exec hide %KMD% /C CSCRIPT //E:VBSCRIPT //NOLOGO SvcDrv.vbs


SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services" >temp0100
SED "/^H.*\\services\\/I!d; s///" temp0100 >SvcFull
SED -r "$!N; /^(.*)\n\1$/P; D" SvcFull >temp0101
GREP . temp0101 >RKPresent || DEL /A/F RKPresent
DEL /A/F/Q temp010? >N_\%random% 2>&1

GREP -Fixsq "?etadpug" SvcFull &&(
	SWREG SAVE HKLM\SYSTEM\CurrentControlSet\Services CCSServices.hiv
	GSAR -o -s:x2E:x20:x65:x00:x74:x00:x61:x00:x64:x00:x70:x00:x75:x00:x67:x00 -r:x40:x00:x65:x00:x74:x00:x61:x00:x64:x00:x70:x00:x75:x00:x67:x00 CCSServices.hiv
	SWREG RESTORE HKLM\SYSTEM\CurrentControlSet\Services CCSServices.hiv /F
	SWREG NULL DELETE HKLM\SYSTEM\CurrentControlSet\Services\@etadpug
	)>N_\%random% 2>&1
DEL /A/F/Q CCSServices.hiv >N_\%random% 2>&1

SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root" >temp0100
SED "/^H.*\\LEGACY_/I!d;s///" temp0100 >LegacyFull
GREP -Fixvf SvcFull LegacyFull >LegacyNoSvc
:: GREP -Fixvf LegacyFull SvcFull >SvcNoLegacy

TYPE zhsvc.dat svc_wht.dat >SvcCovered 2>N_\%random%
:: GREP -Fixvf SvcCovered LegacyNoSvc >SuspectLegacy

SWREG QUERY "hklm\system\select" /v "current"  >CurrentCS00
SED -r "/.*	/!d; s//00/; s/^[0-9]*(...) .*/@SET ControlSet=ControlSet\1\nSET CS000=HKEY_LOCAL_MACHINE\\system\\ControlSet\1\\Services/" CurrentCS00 >CCS.bat
@ECHO.@ECHO.^>NULL >> CCS.bat
CALL CCS.bat
DEL /A/F CurrentCS00

@IF NOT EXIST %SystemRoot%\erdnt\Hiv-backup\System START /WAIT ERUNT %SystemRoot%\erdnt\Hiv-backup SYSREG CURUSER OTHERUSERS /NOCONFIRMDELETE /NOPROGRESSWINDOW
IF EXIST "%SystemRoot%\erdnt\Hiv-backup\system" (
	IF EXIST Vista.krl (
		DumpHive -e "%SystemRoot%\erdnt\Hiv-backup\system" System.dump00
		SED "s/^\[[^\\\x5D]*/[HKEY_LOCAL_MACHINE\\System/" System.dump00 >System.dump
		DEL /A/F System.dump00
		)
	IF NOT EXIST System.dump DumpHive -e "%SystemRoot%\erdnt\Hiv-backup\system" System.dump HKEY_LOCAL_MACHINE
)>N_\%random% 2>&1 ELSE IF NOT EXIST W6432.dat (
	CATCHME -l N_\%random% -c "%system%\config\system" system
	IF EXIST Vista.krl (
		DumpHive -e system System.dump00
		SED "s/^\[[^\\]*\\/[HKEY_LOCAL_MACHINE\\System\\/" System.dump00 >System.dump
		DEL /A/F System.dump00
		)
	IF NOT EXIST System.dump DumpHive -e system System.dump HKEY_LOCAL_MACHINE
	DEL /A/F System
	)>N_\%random% 2>&1


SED "/./{H;$!d;};x;/\[%CS000:\=\\%/I!d" System.dump >System.dump00
SED ":a;/\\$/N; s/\\\n  //; ta" System.dump00 >System.dump01
SED -r "/^\x22|^\[/I!d; /^\x22Security\x22/Id; s/^\[/\n&/; s/\\\\/\\/g;s/=expand:/=/" System.dump01 >System.dump02
SED "/./{H;$!d;};x;/=/I!d" System.dump02 >SvcDumpFull
DEL /A/F/Q temp010? System.dump01 System.dump02 >N_\%random% 2>&1

SED -r "/^\x22(ServiceDLL|ImagePath)\x22|^\[/I!d; s/\\\x22//g" SvcDumpFull >SvcDumpFull00
SED ":a; $!N;s/\n\x22/	/;ta;P;D" SvcDumpFull00 >SvcDumpFull01
SED "/	/!d;" SvcDumpFull01 >SvcDumpFull02
SED -r -e "s/^[^	]*\\Services\\//I; s/][^=]*\x22=/	/; s/\x22//g;s/\\\?\?\\//g; s/%%systemroot\%%|%%windir\%%/\L%systemroot:\=\\%/Ig; s/	\\systemroot\\/	\L%systemroot:\=\\%\\/Ig; s/	system32\\/\L	%SYSDIR:\=\\%\\/Ig" -f Env.sed  SvcDumpFull02 >temp0103
SED -r "/./{H;$!d;};x;/\n\[HKEY_LOCAL_MACHINE\\system\\ControlSet...\\Services\\[^\\]*]\n/I!d; /\n\x22ImagePath\x22/Id; s/.*\\([^\\]*)]\n.*/\1	\L%SYSDIR:\=\\%\E\\driVERs\\\1.sys/" SvcDumpFull >>temp0103
SORT /M 65536 temp0103 /T %cd% /O SvcDump

SED -r -e "s/.*	//" SvcDump -f run.sed >ServiceFiles00
ECHO.::::>>ServiceFiles00
PEV -s-15728641 -filesServiceFiles00 -t!o -c##5#b#u#b#f#b1:#d#b8:#i#b7:#k#b3:#g#b4:#o#b5:#j#b6:#l#b2:#e#b0:#q# >ServiceFiles.dat
SWXCACLS PEV.%cfext% /P /GE:F /Q
GSAR -o -s:x1a -r:x3F ServiceFiles.dat >N_\%random% 2>&1
SED -r ":a; $!N;s/\n[A-F0-9]{32}\t/&/; tb; s/\n/?/; ta :b; P;D" ServiceFiles.dat >ServiceFiles_temp
MOVE /Y ServiceFiles_temp ServiceFiles.dat >N_\%random% 2>&1
SED -r "/^!HASH:/!d; s/.*(.:\\[^\t]*).*/\1/" ServiceFiles.dat >LockedServiceFiles00
FOR /F "TOKENS=*" %%G IN ( LockedServiceFiles00 ) DO @IF NOT EXIST W6432.dat (
	Catchme -l N_\%random% -c "%%G" N_\testme
	PEV -rtf -s=0 N_\testme && Catchme -l N_\%random% -c "%%G" N_\testme
	PEV -c##5#b#u#b%%G#b1:#d#b8:#i#b7:#k#b3:#g#b4:#o#b5:#j#b6:#l#b2:#e#b0:#q# N_\testme >>ServiceFiles.dat
	DEL /A/F N_\testme
	)>N_\%random% 2>&1
DEL /A/F/Q temp010? SvcDumpFull0? LockedServiceFiles00 >N_\%random% 2>&1

SED "/^\[[^]]*\\Services\\[^\\]*]/I!d; s/.*\\//; s/]//" System.dump00 >SvcDumpB
GREP -Fivxf SvcFull SvcDumpB >SvcDiff
TYPE SvcDiff >> SvcFull
GREP -Fixvf SvcCovered SvcFull >suspectSvc.dat


SED -r "/^\x22Start\x22=dword:00000000|^\[/I!d" SvcDumpFull >SvcDumpFull00
SED ":a; $!N;s/\n\x22/	/;ta;P;D" SvcDumpFull00 > SvcDumpFull01
SED -r "/.*\\(.*)]	.*/!d; s//\1	/" SvcDumpFull01 >BootSvcs
GREP -Fif BootSvcs SvcDump >SvcDump00
SED "s/.*	//" SvcDump00 >BootDrivers
ECHO.::::>>BootDrivers
PEV -fs32 -files:BootDrivers -tx50000 -tf -t!p -s-1025 >>d-del_A.dat
SWXCACLS PEV.%cfext% /P /GE:F /Q
DEL /A/F/Q temp010? System.dump BootDrivers BootSvcs System.dump0? SvcDumpFull0? SvcDump0? >N_\%random% 2>&1


:: Rustock Rootkit
:: non default file extensions
SED -r "/\....\x22/!d;/\.(dll|sys|exe)\x22/Id" SvcDump >temp0100

FOR /F "TOKENS=1-2 DELIMS=	" %%G IN ( temp0100 ) DO @SWREG QUERY "HKLM\System\CurrentControlSet\Services\%%~G" >N_\%random% ||(
	GREP -sq . "%%~FH" ||(
		PUSHD "%%~DPH"
		GREP -sq . "%%~NXH" &&(
			SWREG LINK ADD "HKLM\System\CurrentControlSet\Services\deleteme"  "HKLM\System\CurrentControlSet\Services\%%~G" /temp
			SWREG ADD "HKLM\System\CurrentControlSet\Services\deleteme" /V START /T REG_DWORD /D 4
			SWREG LINK DELETE "HKLM\System\CurrentControlSet\Services\deleteme"
			ECHO.[-HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~NG]>>"%~DP0CregC.dat"
			ECHO."%%~FH">>"%~DP0d-del_A.dat"
			ECHO.%%~G| MTEE /+ "%~DP0SvcTargeted" >>"%~DP0zhsvc.dat"
			)
		POPD
		))>%~DP0N_\%random% 2>&1

DEL /A/F temp0100


::RustockB
IF EXIST W6432.dat GOTO STAGE2
SED -r "/./{H;$!d;};x;/\n\x22(RulesData\x22=.*5c,00,(64,00,72,00,69,00,76,00,65,00,72,00,73,00,5c,00,73,00,74,00,72,00,2e,00,73,00,79,00,73|4d,00,41,00,43,00,48,00,49,00,4e,00,45,00,5c,00,53,00,59,00,53,00,54,00,45,00,4d,00,5c,00,43,00,6f,00,6e,00,74,00,72,00,6f,00,6c,00,53,00,65,00,74)|_MAIN\x22=.*5C,00,63,00,61,00,74,00,63,00,68,00,6D,00,65,00,2E,00,73,00,79,00,73)/I!d;" SvcDumpFull >temp0100
SED -r "/^\x22ImagePath\x22=/I!d; s/^\x22.*\x22=\x22.*(.:\\[^\x22:/<>]*).*/\1/; s/^\x22.*\x22=\x22System32(\\drivers\\[^\\\x22]*)\x22$/%system:\=\\%\1/I" temp0100 >RustB00
FOR /F "TOKENS=*" %%G IN ( RustB00 ) DO @(
	Catchme -l N_\%random% -c "%%~G" "%%~DPGCF_%%~NG.vir"
	IF EXIST "%%~DPGCF_%%~NG.vir" (
		GSAR -s:x83:xC1:x01:x8B:x45:xEC:x99:xF7:xF9 "%%~DPGCF_%%~NG.vir" >temp0101
		GREP -Esql "ÈINIT.{32} ..â\.rsrc" "%%~DPGCF_%%~NG.vir" >>temp0101
		PEV -fs32 -rtf -c##d#i#k#b#f# "%%~DPGCF_%%~NG.vir" | SED -r "/^-{18}	/!d; s///" >>temp0101
		GREP -Eisq "\.vir:|\.vir$" temp0101 &&(
			ECHO.%%G>>d-del_A.dat
			GREP -Fi %%G svcdump >RustB01
			SED "s/	.*//" RustB01 >>ZhSvc.dat
			)
		DEL /A/F "%%~DPGCF_%%~NG.vir"
		))>N_\%random% 2>&1
DEL /A/F/Q RustB0? temp0100 temp0101 >N_\%random% 2>&1

SED -r "/\t%systemroot:\=\\%\\[0-9]{6,}:[0-9]{6,}\.exe/I!d; s/\t.*//" SvcDump >>zhsvc.dat


:STAGE2
PEV -k NIRKMD.%cfext%
SWREG ACL "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components" /RESET /Q
START NIRKMD CMDWAIT 40000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%3 >WowErr.dat
@Echo:%Stage%3
IF NOT EXIST W6432.dat (
	COPY /Y/B catchme.%cfExt% Catchme.tmp  >N_\%random% 2>&1
	NIRCMDC EXEC HIDE catchme.tmp -l N_\%random% -qDf "%system%\drivers" >katch00
	)

IF EXIST %SystemDrive%\pos*.tmp DEL /A/F/Q %SystemDrive%\pos*.tmp >N_\%random% 2>&1
FOR /F "TOKENS=*" %%G IN ( attr.dat ) DO @IF EXIST "%%~G" PEV -fs32 -rtf "%%~G" >>d-del_A.dat
@DEL /A/F/Q attr.dat N_\* >N_\%random% 2>&1



>temp0201 2>&1 (
	PEV -rtf %SystemDrive%\* and -preg"\\((ok|Installer)\d\.exe$|[^\\]*[0-9A-F]{7}[^\\]*\.vbs|\d{4}.*\.exe$|-\d{10}|wlong\d*\.sys)$"  or "* " or { -s10000-24000 -t!pMz and -preg"\\.(exe|dll|mui|cpl|drv|scr)$" } or { -s=0 and *.tmp } and not { arcsetup.exe or arcldr.exe }
	PEV -rtf %Systemroot%????* not -preg" "
	IF EXIST "%ProfilesDirectory%\*.exe" PEV -rtf "%ProfilesDirectory%\[0-9]*.exe"
	PEV -rtf "%ProgFiles%\*" -preg"\\((\d{3}[^\\]*|[^\\]*\d{4}[^\\]*)\.exe|[0-5]_\D{10}\.\D{5}|[a-z]{10}\.[a-z]{5})$"

	IF EXIST %system%\XP-*.exe PEV -rtf -dG3M -s+1000000 -s-1600000 %system%\* and -preg"\\XP-[\dA-F]{8}.EXE$"
	IF EXIST "%system%\dllcache\" PEV -rtf "%system%\dllcache\*" and -preg"(\\(try\d{4}\.dll|msn\d{4}\.dll|fly\d\d[^\\]*)|\.dll[a-z][^.]{3,}|\.dll\.[^.]{4,5}|\.ime[a-z][^.]{3,}|\.ime\.[^.]{4,5})$"
	PEV -rtf %system%\drivers\* and -preg"(\\(skynet|uac).{10,}|\\esqul.{4,}\.sys|\\ad2\d\d\.exe|vbma.{4}\.sys|sst\d*\..{3}| | \....|\\m[a-z]{1,2}(zuchi|ziche)\.exe)$" or { -s10000-24000 -t!pMz and -preg"\.(exe|dll|mui|cpl|drv|scr)$" } or { -s-5 and -preg"\.(txt|hm)$" }

	PEV -rtf -t!o %SystemRoot%\* and -preg"((\\((update\d\d|aa\d{3}.{2,}|[^\\]*[0-9A-F]{8}[^\\]*|aa\d{5,8}|cs\d\d|rising.\d\d|romeo\d\d|.\d|bill\d{3}|ms[a-z]|other[^\\]*\d{3}[^\\]*|ld[012]\d|pp[012]\d|doll\d[^\\]*|\d{5,}[^\\]*text|extext\d\d[^\\]*t|[a-z]{4}\d{4}|.{2,4}_\d{5}[^\\]*)\.exe|(doll\d[^\\]*|[a-z]{4}\d{4}|ad_..\d\d|[^\\]*[0-9A-F]{7}[^\\]*)\.dll|-\d{10,}|(tmp\d{5,}|KBPK09[01]\d[0-3]\d)\.log|.\.tmp|fwit\d\d[^\\]*\.[^\\]*|ro\d{4}[^\\]*.dat))| )$" or { -s10000-24000 -t!pMz and -preg"\.(exe|dll|mui|cpl|drv|scr|_sy)" }

	IF EXIST %SystemRoot%\ServicePackFiles\mmshst??.exe PEV -rtf %SystemRoot%\ServicePackFiles\mmshst?[0-9][0-9].exe
	PEV -rtf %SystemRoot%\system\* and -preg"(\\(ad|fc|setup)[^\\]*\d\d\.exe|\\kb\d{4,}\....| | \....)$" or { -s10000-24000 -t!pMz and -preg"\.(exe|dll|mui|cpl|drv|scr)$" } or { -tp and { -t!k or -t!j } } and not -preg"\\(winaspi\.dll|wowpost\.exe|Bison.0.\.dll)$"

	PEV -rtf -t!o "%system%\*" and -preg"(\\((-\d[^\\]*|[^\\]*[0-9A-F]{8}[^\\]*|lib32wa[o-r].|bd\d|dial\d\d|svchost.|ctfmon.{1,5}|u\d\d|GTH\d{5}|lhys\d{2,4}|c_\d{5}\D|gth\d{5}|aa[1-4]\d|ssfwss\d|system\d.exead_..\d\d|Other_Setup_[^\\]*\d\d|[^\\]*adfweds\d|hkcmd\d|download\d\d[^\\]*|winupd_KB[^\\]*\d{3}|clcl.\d|KB.\d{3}[^\\]*|system\d{6}|atlsystem\d{3}[^\\]*|update\d{3}[^\\]*|w32sys\d|game\d|gqd\d|aa\d|tbpi\d[^\\]*|mssv[^\\]*\d[^\\]*|KCA\d|wini\d\d[^\\]*|\D\d{3,})\.EXE|(try\d{4,}|[0-9A-F]{8}[^\\]*|(m|)ws\d{6}|[^\\]*3232|dh2[^\\]*\d{3}[^\\]*|syslib\d|Process[a-z]|v[^b]\d{5}|Msenfi\d.{2,}|mt\d\d\d...m|kb\d{8,9}|xinstall\d{3,})\.DLL|[a-z]{4}\d{4}.ocx|mgt\d{4,}.ocx|ucfe\d{2,}.ocx|windch\d\d[^\\]*|winpsv\d\d\.bin|\d\d[^\\]*\.flv|L_hy.{2,}\d[^\\]*|MT_xx\d\dxx\d\d\.txt|SKYNET.{8,}|UAC.{10,}|ESQUL.{5,}|dbr\d{3,}\....|ttjj[0-2]\d\.ini|-\d{10,}|t3\d{5}\.[^\\]*)|\.dll[a-z][^.]{3,}|\.dll\.[^.]{4,5}|\.ime[a-z][^.]{3,}|\.ime\.[^.]{4,5}| |\\\d{1,}\.ime|\\winsh\d{3})$" or { -s-1500 and [0-9]*.dat }

	PEV -rtf -t!o -t!pmz -s+2300 -s-19000 { %SystemRoot%\* or %system%\* } and { { [0-9abcdefz][0-9abcdefz]????*[0-9abcdefzsrm][0-9abcdefz][^\\]* and *[0-9]*[0-9]*[0-9]*[0-9]*[^\\]* and { *.exe or *.cpl or *.bin or *.dll or *.ocx } } or { -preg"[^\\]*((hack|.ack|h.ck|ha.k||hac.)[^\\]*(.ool|t.ol|to.l|too.)|(.pam|s.am|sp.m|spa.)[^\\]*(.ot|b.t|bo.)|orm|w.rm|wo.m|wor|hief|t.ief|th.ef|thi.f|thie|teal|s.eal|st.al|ste.l|stea|hreat|t.reat|th.eat|thr.at|thre.t|threa|rojan|t.ojan|tr.jan|tro.an|troj.n|troja|irus|v.rus|vi.us|vir.s|viru|(ack|b.ck|ba.k|bac)[^\\]*(oor|d.or|do.r|doo)|(own|d.wn|do.n|dow)[^\\]*(oad|l.ad|lo.d|loa)|(py|s.y|sp|a|d)[^\\]*(are|w.re|wa.e|war))[^\\]*\.(exe|cpl|bin|dll|ocx)" } }

	PEV -rtf -t!o %SystemRoot%\msagent\* and -preg"\\[a-z]{3}\d{4}$"

	IF EXIST "%CommonProgFiles%\microsoft shared\web folders" PEV -tx50000 -tf "%CommonProgFiles%\microsoft shared\web folders\ibm0*"
	PEV -rtpmz -t!o -dcg30 "%CommonProgFiles%\System\*" not -preg"\.(exe|dll|ocx|mui|cpl\drv)$"
	PEV -rtf -t!o "%CommonProgFiles%\[0-9][0-9][0-9]*" -preg"\.(dll|exe|tmp)$"
	PEV -rtf -t!p -t!o and { "%SystemRoot%\Help\*[1-9][0-9][0-9][0-9].hlp" or "%SystemRoot%\Help\*[1-9][0-9][0-9][0-9]" or "%SystemRoot%\Help\*.dll" or "%SystemRoot%\msagent\*[0-9][0-9][0-9][0-9].tlb" or "%SystemRoot%\system\*[0-9][0-9][0-9][0-9]" or "%SystemRoot%\system\*[0-9][0-9][0-9][0-9].drv" or "%SystemRoot%\Web\*[0-9][0-9][0-9][0-9].htt" }
	PEV -rtf -dG30 -t!pMZ -t!o -s+10000 -s-20000 "%CommonProgFiles%\*" and -preg"\.(scr|exe|com|dll|pif|dl|sys|_dl|bat|bin|ban|._sy|reg|vbs)$"
	PEV -rtf -dG30 -t!pMZ -t!o -s+10000 -s-20000 and { "%system%\*" or "%SystemRoot%\*" } and -preg"\.(scr|exe|dll|pif|dl|sys|_dl|bat|bin|ban|._sy|reg|vbs)$"
	PEV -rtf -t!o -tpmz -dcg30 and { "%system%\*" or "%systemroot%\*" or "%systemroot%\system\*" or "%system%\drivers\*" } -preg"\\[^\\]*((.)\2)\1\1[^\\]*$"
	)


GREP -sq "^  " temp0201 || SED "/:\\/!d; s/.*/\x22&\x22/" temp0201 >>d-del_A.dat
DEL /A/F/Q temp020? >N_\%random% 2>&1


CALL List-B.bat
DEL /A/F List-B.bat



IF EXIST Xp.mac IF EXIST "%SystemDrive%\Documents and Settings\NetworkService\Application Data\" (
	PEV -rtd -dcG30 "%SystemDrive%\Documents and Settings\NetworkService\Application Data\????????" -output:temp0200
	FOR /F "TOKENS=*" %%G IN ( temp0200 ) DO @IF EXIST "%%~G\Profiles.ini" (
		FINDSTR -MXSC:"# Mozilla User Preferences" "%%~G\Profiles\prefs.js" &&(
		SED "s/\x22//g; /^.:\\/!d; s/$/\\%%~NG/; s/.*/\x22&\x22/" localappdata.folder.dat appdata.folder.dat >temp0201
		SED ":a; $!N; s/\n/ or /;ta; s/.*/{ & }/" temp0201 >temp202
		PEV -loadline:temp0202 -rtd -dcg30 >>CFolders.dat
		DEL temp0201 temp0202
		))
	DEL /A/F/Q temp020?
	)>N_\%random% 2>&1




SED "/:\\/!d; s/\x22//g" appdata.folder.dat localappdata.folder.dat localsettings.folder.dat profiles.folder.dat | SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/-rtf -t!o -tp { \x22&\\*\x22 }/;" >hotspot00
PEV -loadline:hotspot00 and { -t!k or { -tsh -dcg30 } } >>d-del_A.dat
PEV -loadline:hotspot00 and -t!g -t!j >>d-del_A.dat
PEV -loadline:hotspot00 -tk -tj -c##f#bc:#d#k# and not -preg"\\(PnkBstrK.sys|ezpinst\.exe|inst.exe|FullRemove.exe)$" | SED -r "/	c:-{12}$/!d; s///" >>d-del_A.dat
DEL /A/F hotspot00 >N_\%random% 2>&1


SED "/:\\/!d; s/\x22//g" appdata.folder.dat >temp0200
SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" temp0200 >temp0201
GREP . temp0201 >appdata.folder00.dat ||ECHO.::::>appdata.folder00.dat


SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" AppFileB.dat >temp0202
@(
ECHO.-rtf and {
TYPE appdata.folder00.dat
ECHO.} and {
SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/" temp0202
ECHO.} not {
ECHO.DynuEncrypt.dll
ECHO.} or {
ECHO.-dG30 -t!pMZ -s+10000 -s-20000 and { *.scr or *.exe or *.com or *.dll or *.pif or *.dl or *.sys or *._dl or *.bin or *.ban or *._sy or *.lib }
ECHO.}
)>AppFile00.dat
PEV -loadline:AppFile00.dat >AppFile99 2>&1 && GREP -sq "^  " AppFile99 ||SED "s/.*/\x22&\x22/" AppFile99 >>d-del_A.dat


SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" AppFolderB.dat purity.dat rogues.dat >temp0203
@(
ECHO.-rtd and {
TYPE appdata.folder00.dat
ECHO.} and {
SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/" temp0203
ECHO.}
)>AppFolder00.dat
PEV -loadline:AppFolder00.dat >AppFolder99 2>&1 && GREP -sq "^  " AppFolder99 ||SED "s/.*/\x22&\x22/" AppFolder99 >>CFolders.dat

DEL /A/Q AppFileB.dat AppFile00.dat AppFolderB.dat AppFolder00.dat appdata.folder00.dat temp020? >N_\%random% 2>&1


FOR /F "TOKENS=*" %%G IN ( Appdata.folder.dat ) DO @(
	FOR /F "TOKENS=*" %%H IN ( AppFileD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtf "%%~G\%%~H">>d-del_A.dat
	FOR /F "TOKENS=*" %%H IN ( AppFolderC.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtd "%%~G\%%~H">>d-del_B.dat
	FOR /F "TOKENS=*" %%H IN ( AppFolderD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtd "%%~G\%%~H">>CFolders.dat
	FOR /F "TOKENS=1* DELIMS=	" %%H IN ( AppFolderE.dat ) DO @IF EXIST "%%~G\%%~H" ECHO. "%%~G\%%~I">>CFolders.dat
	PEV -rtf -dG30 "%%~G\*" and { *.inf or *.bat or *.vbs or *.log } | FINDSTR -MRF:/ "                       " >>d-del_A.dat
	PEV -rtf "%%~G\*" -preg"\\[^\\]*(backup|directx|Display|ifier|manage|online|policy|profile|service|tray|update)[^\\]*(backup|ifier|manage|online|policy|profile|service|Tray|update)[^\\]*\.dll$" >>d-del_A.dat
	PEV -rtf "%%~G\*" -preg"\\[a-z0-9]{10,}.txt$" | SED -r "/\\[^\\]*[A-Z][^\\]*[A-Z][^\\]*[A-Z][^\\]*\....$/!d; /\\[^\\]*[a-z][^\\]*[a-z][^\\]*\....$/!d; " >>d-del_A.dat
	PEV -rtf -t!o -tpmz "%%~G\*" -preg"\.(jpg|jpeg|bmp|gif|png|txt|bat|cmd|htm|html|mht|pdf|tmp|avi|mov|mpg|mpeg|wmv|mp3|cab|zip|rar|doc|log|inf|ini|\d..|.{2})$" >>d-del_A.dat
	PEV -rt!pmz -dG30 "%%~G\*" -preg"\.(dll|scr|exe)$" >>d-del_A.dat
	PEV -tf -t!o -tpmz { "%%~G\Identities\*" or "%%~G\Microsoft\Credentials\*" or "%%~G\Microsoft\Crypto\*" or "%%~G\Microsoft\AddIns\*" or "%%~G\Microsoft\SystemCertificates\*" or "%%~G\Microsoft\Protect\*" } >>d-del_A.dat
	IF EXIST "%%~G\Microsoft\*" PEV -rtf -tpmz -t!o -t!g -c##f#b#d#j# "%%~G\Microsoft\*" | SED "/	.*Microsoft/d; s/	.*//" >>d-del_A.dat
	IF EXIST "%%~G\Microsoft Corporation\*" PEV -rtf -tpmz -t!o -t!g -c##f#b#d#j# "%%~G\Microsoft\*" | SED "/	.*Microsoft/d; s/	.*//" >>d-del_A.dat
	PEV -rtd -dcG25 "%%~G\*" -preg"\\(~WinRar[0-9]{3,}.*|-\d{9,})$" >>CFolders.dat
	REM PEV -rtd -dcG20 "%%~G\*" -preg"\\[a-f0-9]{8,}$" -output:temp0200
	PEV -rtd -dcG20 "%%~G\*" -preg"\\[a-z0-9]{8,}$" AND "*[0-9]*[0-9]*[0-9]*" -output:temp0200
	FOR /F "TOKENS=*" %%H IN ( temp0200 ) DO @IF EXIST "%%~H\%%~NH.exe" (
		ECHO.%%H>>CFolders.dat
		IF EXIST "%CommonAppData%\%%~H.ini" ECHO."%CommonAppData%\%%~H.ini">>d-del_A.dat
		) ELSE (
		IF EXIST "%%~H\svc?ost*.exe" ECHO.%%H
		IF EXIST "%%~H\jusched*.exe" ECHO.%%H
		)>>CFolders.dat
	PEV -rtd -dcG60 "%%~G\*" -preg"\\[^\\ ]{26,}$" -output:temp0200
	FOR /F "TOKENS=*" %%H IN ( temp0200 ) DO @(
		IF EXIST "%%~H\?.exe" ECHO.%%H
		PEV -rtf "%%~H\*.exe" -preg"\\[0-9A-F]{12,}.exe$" >>d-del_A.dat && ECHO.%%H
		)>>CFolders.dat
	PEV -rtd -dcG30 "%%~G\*" -output:temp0200
	SED -r "/./!d; s/.*\\([^\\]*)$/&\t\1/; :a; s/\t(.*) (.*)/\t\1\2/; ta;" temp0200 > temp0201
	FOR /F "TOKENS=1* DELIMS=	" %%H IN ( temp0201 ) DO @IF EXIST "%%~H\%%~I.dll" IF EXIST "%%~H\%%~ISvc.dll" (
		PEV -tf "%%~H\*" | GREP -c . | GREP -Esqx "[2-3]" && ECHO."%%~H"
		)>>CFolders.dat
	DEL /A/F temp0201
	SED -r "/\\[^\\]{8}$/!d" temp0200 > temp0201
	FOR /F "TOKENS=*" %%H IN ( temp0201 ) DO @FOR %%I IN ( "%%~H\*.exe.lnk" ) DO @IF EXIST "%%~DPNI" (
		PEV -tf "%%~H\*" | GREP -c . | GREP -Esqx "[2-3]" && ECHO."%%~H"
		)>>CFolders.dat
	DEL /A/F temp0200
	PEV -rtd -dcG60 "%%~G\Microsoft\Windows\*[0-9]*" -preg"\\[^\\ ]{5,}$" -output:temp0200
	FOR /F "TOKENS=*" %%H IN ( temp0200 ) DO @IF EXIST "%%~H\%%~NXH.nfo" IF EXIST "%%~H\%%~NXH.svr" ECHO.%%H>>CFolders.dat
	DEL /A/F temp0200

	PEV -rtd -dcG60 "%%~G\*" -preg"\\[^\\ ]{15,}$" -output:temp0200
	FOR /F "TOKENS=*" %%H IN ( temp0200 ) DO @(
		IF EXIST "%%~H\fcabafaaddeafad.exe" ECHO.%%H
		IF EXIST "%%~H\enemies-names.txt" ECHO.%%H
		IF EXIST "%%~H\gotnewupdate*.exe" ECHO.%%H
		IF EXIST "%%~H\secureapp*.exe" ECHO.%%H
		IF EXIST "%%~H\svcnost.exe" ECHO.%%H
		IF EXIST "%%~H\livesp.exe" ECHO.%%H
		IF EXIST "%%~H\mssece*.exe" ECHO.%%H
		)>>CFolders.dat
	PEV -rtf -t!o -tp ""%%~G\*" AND { [0-9]*.exe OR [0-9]*.dll  OR { { -t!k or -t!j } -d:G120 } } >>d-del_A.dat
	PEV -rtf -t!o -tp -dG60 "%%~G\*" -c##f#b1:#d#b8:#i#b7:#k#b3:#g#b#y# | SED -r "/	.*(Microsoft|Adobe|Google|Yahoo|Mozilla|Svchost|Realtek|Doctor Web|:ESET |:Opera | hack|crack|keygen|:.	:.|0x0{8}$)/I!d; s/\t.*//; /\\DynuEncrypt.dll$/Id" >>d-del_A.dat
	PEV -rtf -t!o "%%~G\*" and { *.exe or *.dll }  | FINDSTR -MBRF:/ "MZKERNEL32.DLL F.i.l.e.n.a.m.e...W.i.n.R.A.R...e.x.e"  >>d-del_A.dat
	PEV -rtf -t!o -s-70000 -d:G30 "%%~G\Google\*.dll" | FINDSTR -MF:/ ZwQuerySystemInformation >>d-del_A.dat
	PEV -rtf -t!o -s-135000 -d:G30 "%%~G\Google\*.exe" | FINDSTR -MF:/ "Security.Center.Alert" >>d-del_A.dat
	IF EXIST "%%~G\Macromedia\Common\*.dll" FINDSTR -MI "gmer.*bat O.L.E.3.2...E.x.t.e.n.s.i.o.n.s...f.o.r...W.i.n.3.2" "%%~G\Macromedia\Common\*.dll" >>d-del_A.dat
	IF EXIST "%%~G\Mozilla\Firefox\Profiles\"  (
		PEV -tx50000 -tf "%%~G\Mozilla\Firefox\Profiles\*" and { overlay.xul or xulcache.jar } >>XUL00
		PEV -tx50000 -tf "%%~G\Mozilla\Firefox\Profiles\*" and { webalta-search.xml  or LicenseValidator.exe } >>d-del_A.dat
		PEV -tx50000 -tf "%%~G\Mozilla\Firefox\Profiles\bootstrap.js" -preg"\\Mozilla\\Firefox\\Profiles\\[^\\]*\\extensions\\" | FINDSTR -MLIF:/ ".justplug.it" | SED -r "/\\[^\\]*$/!d; s///" >>CFolders.dat
		PEV -tx50000 -tf "%%~G\Mozilla\Firefox\Profiles\bg.js" -preg"\\Mozilla\\Firefox\\Profiles\\[^\\]*\\extensions(\\Staged|)\\[^\\]*\\content\\bg.js$" | FINDSTR -MIF:/ "jpiproxy\.co\.il japproxy\.net jpionline\.co\.il syncjpionline\.co\.il syncerjpi\.com jpisync\.co\.il url:zycript.decode jpiconfdata_full:null" | SED -r "/\\content\\[^\\]*$/I!d; s///" >>CFolders.dat
		PEV -tx50000 -tf "%%~G\Mozilla\Firefox\Profiles\*_CrossriderAppUtils.js" -preg"\\Mozilla\\Firefox\\Profiles\\[^\\]*\\extensions\\[^\\]*\\extensionData\\plugins\\[^\\]*_CrossriderAppUtils.js$" | SED -r "/\\extensionData\\plugins\\[^\\]*$/I!d; s///" >>CFolders.dat
		PEV -tx50000 -tf "%%~G\Mozilla\Firefox\Profiles\searchSettings.js" -preg"\\Mozilla\\Firefox\\Profiles\\[^\\]*\\extensions\\[^\\]*\\chrome\\content\\core\\searchSettings.js$" | FINDSTR -MIF:/ "CROSSRIDER_PRE_INSTALLED_APP" | SED -r "/\\chrome\\content\\core\\searchSettings.js$/I!d; s///" >>CFolders.dat
		)
	CALL :SoftAV "%%~G"
	)2>N_\%random%

DEL /A/F/Q temp020? >N_\%random% 2>&1

GREP -Eiv "%SYSDIR:\=\\%|\\Default User\\." Appdata.folder.dat >temp0200

FOR /F "TOKENS=*" %%G IN ( temp0200 ) DO @(
	FOR /F "TOKENS=*" %%H IN ( AppFileC.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtf "%%~G\%%~H" >>d-del_A.dat
	)2>N_\%random%
@DEL /A/F/Q AppF?l*.dat temp0200 >N_\%random% 2>&1



:STAGE3
@MOVE /Y ncmd.com ncmd.cfxxe >N_\%random% 2>&1
PEV -k NIRKMD.%cfext%
@MOVE /Y ncmd.cfxxe ncmd.com >N_\%random% 2>&1
START NIRKMD CMDWAIT 80000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%4 >WowErr.dat
@Echo:%Stage%4


SED "/:\\/!d; s/\x22//g" Profiles.folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" | GREP . >Profiles.folder00.dat ||ECHO.::::>Profiles.folder00.dat

@(
ECHO.-rtf and {
TYPE Profiles.folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" ProfilesFileB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>ProfilesFile00.dat
PEV -loadline:ProfilesFile00.dat >ProfilesFile99 2>&1 && GREP -sq "^  " ProfilesFile99 ||SED "s/.*/\x22&\x22/" ProfilesFile99 >>d-del_A.dat


@(
ECHO.-rtd and {
TYPE Profiles.folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" ProfilesFolderB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>ProfilesFolder00.dat
PEV -loadline:ProfilesFolder00.dat >ProfilesFolder99 2>&1 && GREP -sq "^  " ProfilesFolder99 ||SED "s/.*/\x22&\x22/" ProfilesFolder99 >>CFolders.dat


FOR /F "TOKENS=*" %%G IN ( Profiles.folder.dat ) DO @(
	FOR /F "TOKENS=*" %%H IN ( ProfilesFileC.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtf "%%~G\%%~H">>d-del_A.dat
 	FOR /F "TOKENS=*" %%H IN ( ProfilesFolderD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtd "%%~G\%%~H">>d-del_B.dat
	PEV -rtd -dcg30 "%%~G\*[0-9]*[0-9]*[0-9]*" -output:tempAA
	FOR /F "TOKENS=*" %%H IN ( tempAA ) DO @(
		IF EXIST "%%H\-alldone.inf" CALL :REMDIR "%%H" 2
		IF EXIST "%%H\wndsksi.inf" CALL :REMDIR "%%H" 2
		)>N_\%random% 2>&1
	DEL /A/F tempAA
	PEV -rtd -dcg30 "%%~G\*" -preg"\\[0-9a-f]{5,}$" -output:tempAA
	FOR /F "TOKENS=*" %%H IN ( tempAA ) DO @IF EXIST "%%H\config\exitd.vxd" ECHO."%%H">>CFolders.dat
	DEL /A/F tempAA
	PEV -rtshd -dcg30 "%%~G\*" -preg"\\[^\\]{4,5}$" -output:tempAA
	FOR /F "TOKENS=*" %%H IN ( tempAA ) DO @PEV -rtd "%%~H\*" >N_\%random% ||(
		PEV -rtshf -s-10 "%%~H\*" | GREP -c . | GREP -sq ... && IF EXIST "%%~H\*.vbs" IF EXIST "%%~H\settings.ini" ECHO."%%~H">>CFolders.dat
		IF EXIST "%%~H\*.exe" FINDSTR -MR "AutoIt.script A.u.t.o.I.t...s.c.r.i.p.t" "%%~H\*.exe" >N_\%random% && ECHO."%%~H">>CFolders.dat
		)
	DEL /A/F tempAA
	PEV -rtf -dG30 "%%~G\*" and { *.inf or *.bat or *.vbs } | FINDSTR -MRF:/ "                       " >>d-del_A.dat
	PEV -rtf -t!o -tpmz "%%~G\*" -preg"\.(jpg|jpeg|bmp|gif|png|txt|bat|cmd|htm|html|mht|pdf|tmp|avi|mov|mpg|mpeg|wmv|mp3|cab|zip|rar|doc|log|inf|ini|\d..|.{2})$" >>d-del_A.dat
	PEV -rt!pmz -dG30 "%%~G\*" -preg"\.(dll|scr|exe)$" >>d-del_A.dat
	PEV -rtf -t!o -tp -dG60 "%%~G\*" -c##f#b1:#d#b8:#i#b7:#k#b3:#g#b#y# | SED -r "/	.*(Adobe|Google|Yahoo|Mozilla|Svchost|Realtek|Doctor Web|:ESET |:Opera | hack|crack|keygen|[a-z]{3,}|:.	:.|0x0{8}$)/I!d; s/\t.*//"  >>d-del_A.dat
	IF EXIST "%%~G\*.exe" (
		PEV -rtf -t!o -tp { -t!k or -t!j } -d:G120 "%%~G\*.exe" >>d-del_A.dat
		PEV -rtf -dG30 "%%~G\*.exe" and { -s=61440 or -s=163328 or -s=176128 or -s=184320 or -s=138240 or -s=221184 or -s=192512 or -s=233472 or -s=167936 or -s=204800 or -s=159744 or -s=241664 or -s=126976 or -s=208896 or -s=169984 or -s=131072 or -s=172032 or -s=153088 or -s=128512 or -s=356352 or -s=86528 } >>d-del_A.dat
		PEV -rtf -t!o -t!pMZ -d:G120 "%%~G\*" and { *.exe or *.dll or *.mui or *.cpl or *.drv or *.scr } >>d-del_A.dat
		PEV -rtf -t!o -tpmz -d:G90 -s-200000 "%%~G\*" -output:tempxx
		FINDSTR -MF:tempxx "sandbox.*honey.*vmware.*currentuser.*nepenthes </user><realm>@secureroot</realm> \\lTlqTpjPHfg.pdb ZwQuerySystemInformation 0.u..>.u:F.u...:.t.<.u..>.u.F.u...:.t.<.v..]..E.P...@...E..t...E....>.v.F.u...j yrH.wrQ.xr..wrmLxr0jxr RTo54po6565k7l6k7868768 Vo456o4p6598685768678 DFG5po4p6o57 MZKERNEL32.DLL Studio\\VB98.6.OLBp I.n.t.e.r.n.a.l.N.a.m.e...m.s.n.m.s.g.r...e.x.e MZKERNEL32.DLL" >>d-del_A.dat 2>N_\%random%
		DEL /A/F tempxx 2>N_\%random%
		))

@DEL /A/F/Q ProfilesFile?.dat ProfilesFolder?.dat ProfilesF*00.dat Profiles.folder0?.dat N_\* >N_\%random% 2>&1




SED "/:\\/!d; s/\x22//g" Programs.folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" | GREP . >Programs.folder00.dat ||ECHO.::::>Programs.folder00.dat

@(
ECHO.-rtf and {
TYPE Programs.folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" ProgramsFileB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>ProgramsFile00.dat
PEV -loadline:ProgramsFile00.dat >ProgramsFile99 2>&1 && GREP -sq "^  " ProgramsFile99 ||SED "s/.*/\x22&\x22/" ProgramsFile99 >>d-del_A.dat


@(
ECHO.-rtd and {
TYPE Programs.folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" ProgramsFolderB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>ProgramsFolder00.dat
PEV -loadline:ProgramsFolder00.dat >ProgramsFolder99 2>&1 && GREP -sq "^  " ProgramsFolder99 ||SED "s/.*/\x22&\x22/" ProgramsFolder99 >>CFolders.dat

FOR /F "TOKENS=*" %%G IN ( Programs.Folder.dat ) DO @(
 	FOR /F "TOKENS=*" %%H IN ( ProgramsFileD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtf "%%~G\%%~H">>d-del_A.dat
 	FOR /F "TOKENS=*" %%H IN ( ProgramsFolderD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtd "%%~G\%%~H">>d-del_B.dat
	PEV -rtf -t!o -tpmz "%%~G\*" -preg"\.(jpg|jpeg|bmp|gif|png|txt|bat|cmd|htm|html|mht|pdf|tmp|avi|mov|mpg|mpeg|wmv|mp3|cab|zip|rar|doc|log|inf|ini|\d..|.{2})$" >>d-del_A.dat
	PEV -rt!pmz -dG30 "%%~G\*" -preg"\.(dll|scr|exe)$" >>d-del_A.dat
 	)
@DEL /A/Q Programs*f*.dat N_\* >N_\%random% 2>&1




:: GREP -Fiv %system% Startup.Folder.dat >Startup.Folder00.dat
SED "/:\\/!d; s/\x22//g" Startup.Folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" | GREP . >Startup.Folder00.dat ||ECHO.::::>Startup.Folder00.dat
@(
ECHO.-rtf and {
TYPE Startup.Folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" StartUpFileB.dat  | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>StartUpFile00.dat
PEV -loadline:StartUpFile00.dat >StartUpFile99 2>&1 && GREP -sq "^  " StartUpFile99 ||SED "s/.*/\x22&\x22/" StartUpFile99 >>d-del_A.dat

FOR /F "TOKENS=*" %%G IN ( Startup.Folder.dat ) DO @(
	PEV -rtf -t!o -tp { -t!k or -t!j } -d:G120 "%%~G\*.exe"
	PEV -rtf -t!o -tp -c##d#i#k#g#y#b#f# "%%~G\*[0-9]*.exe" | SED -r "/^-{24}|0x0{8}	/!d; s/.*\t//"
	PEV -rtf -t!o -tpmz "%%~G\*" -preg"\.(jpg|jpeg|bmp|gif|png|txt|bat|cmd|htm|html|mht|pdf|tmp|avi|mov|mpg|mpeg|wmv|mp3|cab|zip|rar|doc|log|inf|ini|\d..|.{2})$"
	PEV -rt!pmz -dG30 "%%~G\*" -preg"\.(dll|scr|exe)$" >>d-del_A.dat
	PEV -mrtd -th -dcg60 "%%~G\*.{*-*-*-*}" >>CFolders.dat
	FOR %%H IN ( "%%~G\*.dll" ) DO @IF EXIST "%%~DPNH.exe" (
		ECHO."%%~DPNH.exe"
		ECHO."%%~DPNH.dll"
		))>>d-del_A.dat
@DEL /A/F/Q StartUpFile*.dat Startup.Folder0?.dat N_\* >N_\%random% 2>&1




SED "/:\\/!d; s/\x22//g" Desktop.Folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" | GREP . >Desktop.Folder00.dat ||ECHO.::::>Desktop.Folder00.dat

@(
ECHO.-rtf and {
TYPE Desktop.Folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" DesktopFileB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>DesktopFile00.dat
PEV -loadline:DesktopFile00.dat >DesktopFile99 2>&1 && GREP -sq "^  " DesktopFile99 ||SED "s/.*/\x22&\x22/" DesktopFile99 >>d-del_A.dat


@(
ECHO.-rtd and {
TYPE Desktop.Folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" DesktopFolderB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>DesktopFolder00.dat
PEV -loadline:DesktopFolder00.dat >DesktopFolder99 2>&1 && GREP -sq "^  " DesktopFolder99 ||SED "s/.*/\x22&\x22/" DesktopFolder99 >>CFolders.dat

FOR /F "TOKENS=*" %%G IN ( Desktop.Folder.dat ) DO @(
	FOR /F "TOKENS=*" %%H IN ( DesktopFileD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtf "%%~G\%%~H">>d-del_A.dat
	)
@DEL /A/F/Q DesktopFile00.dat Desktop*Folder0?.dat N_\* >N_\%random% 2>&1




SED "/:\\/!d; s/\x22//g" Favorites.Folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" | GREP . >Favorites.Folder00.dat ||ECHO.::::>Favorites.Folder00.dat

@(
ECHO.-rtf and {
TYPE Favorites.Folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" FavFileB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>FavFile00.dat
PEV -loadline:FavFile00.dat >FavFile99 2>&1 && GREP -sq "^  " FavFile99 ||SED "s/.*/\x22&\x22/" FavFile99 >>d-del_A.dat

FOR /F "TOKENS=*" %%G IN ( Favorites.Folder.dat ) DO @(
	FOR /F "TOKENS=*" %%H IN ( FavFileD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtf "%%~G\%%~H">>d-del_A.dat
	FOR /F "TOKENS=*" %%H IN ( FavFolderD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtd "%%~G\%%~H">>d-del_B.dat
	PEV -rtf -t!o -tpmz "%%~G\*" -preg"\.(jpg|jpeg|bmp|gif|png|txt|bat|cmd|htm|html|mht|pdf|tmp|avi|mov|mpg|mpeg|wmv|mp3|cab|zip|rar|doc|log|inf|ini|\d..|.{2})$" >>d-del_A.dat
	PEV -rt!pmz -dG30 "%%~G\*" -preg"\.(dll|scr|exe)$" >>d-del_A.dat
	IF EXIST "%%~G\*.exe" PEV -tx50000 -tf "%%~G\*.exe" >>d-del_A.dat
	)
@DEL /A/F/Q FavFile*.dat Favorites.Folder*.dat N_\* >N_\%random% 2>&1




SED "/:\\/!d; s/\x22//g" StartMenu.Folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" | GREP . >StartMenu.Folder00.dat ||ECHO.::::>StartMenu.Folder00.dat

@(
ECHO.-rtf and {
TYPE StartMenu.Folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" MenuFileB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>MenuFile00.dat
PEV -loadline:MenuFile00.dat >MenuFile99 2>&1 && GREP -sq "^  " MenuFile99 ||SED "s/.*/\x22&\x22/" MenuFile99 >>d-del_A.dat


@(
ECHO.-rtd and {
TYPE StartMenu.Folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" MenuFolderB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>MenuFolder00.dat
PEV -loadline:MenuFolder00.dat >MenuFolder99 2>&1 && GREP -sq "^  " MenuFolder99 ||SED "s/.*/\x22&\x22/" MenuFolder99 >>CFolders.dat

FOR /F "TOKENS=*" %%G IN ( StartMenu.Folder.dat ) DO @(
	FOR /F "TOKENS=*" %%H IN ( MenuFileD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtf "%%~G\%%~H">>d-del_A.dat
	PEV -rtf -t!o -tpmz "%%~G\*" -preg"\.(jpg|jpeg|bmp|gif|png|txt|bat|cmd|htm|html|mht|pdf|tmp|avi|mov|mpg|mpeg|wmv|mp3|cab|zip|rar|doc|log|inf|ini|\d..|.{2})$" >>d-del_A.dat
	PEV -rt!pmz -dG30 "%%~G\*" -preg"\.(dll|scr|exe)$" >>d-del_A.dat
	FOR /F "TOKENS=*" %%H IN ( MenuFolderD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtd "%%~G\%%~H">>d-del_B.dat
	)
@DEL /A/F/Q MenuFile*.dat MenuFolder*.dat StartMenu*F*.dat N_\* >N_\%random% 2>&1



SED "/:\\/!d; s/\x22//g" Templates.Folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" | GREP . >Templates.Folder00.dat ||ECHO.::::>Templates.Folder00.dat

@(
ECHO.-rtf and {
TYPE Templates.Folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" TemplatesFileB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>TemplatesFile00.dat
PEV -loadline:TemplatesFile00.dat >TemplatesFile99 2>&1 && GREP -sq "^  " TemplatesFile99 ||SED "s/.*/\x22&\x22/" TemplatesFile99 >>d-del_A.dat


@(
ECHO.-rtd and {
TYPE Templates.Folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" TemplatesFolderB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>TemplatesFolder00.dat
PEV -loadline:TemplatesFolder00.dat >TemplatesFolder99 2>&1 && GREP -sq "^  " TemplatesFolder99 ||SED "s/.*/\x22&\x22/" TemplatesFolder99 >>CFolders.dat


FOR /F "TOKENS=*" %%G IN ( Templates.Folder.dat ) DO @(
	PEV -rtf -t!o -tp { -t!k or -t!j } -d:G120 "%%~G\*.exe" >>d-del_A.dat
	PEV -rtf -s-3072 -dcg30 "%%~G\?????*[0-9]?????????*" -preg"\\[0-9a-z]*$" >>d-del_A.dat
	PEV -tx50000 -tf -s-1000000 "%%~G\*" >tempxx && FINDSTR -MIF:tempxx rggzs.com >>d-del_A.dat
	PEV -rtf -t!o -tpmz "%%~G\*" -preg"\.(jpg|jpeg|bmp|gif|png|txt|bat|cmd|htm|html|mht|pdf|tmp|avi|mov|mpg|mpeg|wmv|mp3|cab|zip|rar|doc|log|inf|ini|\d..|.{2})$" >>d-del_A.dat
	PEV -rt!pmz -dG30 "%%~G\*" -preg"\.(dll|scr|exe)$" >>d-del_A.dat
	PEV -rtd "%%~G\[0-9]??????" -output:templates00
	FOR /F "TOKENS=*" %%H IN ( templates00 ) DO @FINDSTR -MI dmcast "%%~H\?.*" >>d-del_A.dat
	DEL /A/F Templates00 tempxx
	)2>N_\%random%
@DEL /A/F/Q TemplatesFile*.dat TemplatesFolder*.dat Templates*F*.dat N_\* >N_\%random% 2>&1



GREP -v "ECURIT~1\|SCURIT~1" purity.dat >purityB.dat


SED "/:\\/!d; s/\x22//g" Personal.Folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" | GREP . >Personal.Folder00.dat ||ECHO.::::>Personal.Folder00.dat
@(
ECHO.-rtf and {
TYPE Personal.Folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" DesktopFileB.dat PersonalFileB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.} or {
ECHO.-dG30 -t!pMZ -s+10000 -s-20000 and { *.scr or *.exe or *.com or *.dll or *.pif or *.dl or *.sys or *._dl or *.bin or *.ban or *._sy }
ECHO.}
)>PersonalFile00.dat
PEV -loadline:PersonalFile00.dat >PersonalFile99 2>&1 && GREP -sq "^  " PersonalFile99 ||SED "s/.*/\x22&\x22/" PersonalFile99 >>d-del_A.dat


@(
ECHO.-rtd and {
TYPE Personal.Folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" purityB.dat PersonalFolderB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>PersonalFolder00.dat
PEV -loadline:PersonalFolder00.dat >PersonalFolder99 2>&1 && GREP -sq "^  " PersonalFolder99 ||SED "s/.*/\x22&\x22/" PersonalFolder99 >>CFolders.dat

FOR /F "TOKENS=*" %%G IN ( Personal.Folder.dat ) DO @(
	PEV -rtf -t!o -tpmz "%%~G\*" -preg"\.(jpg|jpeg|bmp|gif|png|txt|bat|cmd|htm|html|mht|pdf|tmp|avi|mov|mpg|mpeg|wmv|mp3|cab|zip|rar|doc|log|inf|ini|\d..|.{2})$" >>d-del_A.dat
	PEV -rt!pmz -dG30 "%%~G\*" -preg"\.(dll|scr|exe)$" >>d-del_A.dat
	PEV -rtf -dG30 "%%~G\*" and { *.inf or *.bat or *.vbs or *.log } | FINDSTR -MRF:/ "                       " >>d-del_A.dat
	FOR /F "TOKENS=*" %%H IN ( PersonalFolderD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtd "%%~G\%%~H">>CFolders.dat
	IF EXIST "%%~G\ECURIT~1" PEV -tx50000 -tf "%%~G\ECURIT~1\*" -output:temp0300 && GREP -c . temp0300 | GREP -sqx [1-3] &&ECHO."%%~G\ECURIT~1">>CFolders.dat
	IF EXIST "%%~G\pos*.tmp" DEL /A/F/Q "%%~G\pos*.tmp"
	IF EXIST "%%~G\pos*.tmp" PEV -rtf "%%~G\pos*.tmp">>d-del_A.dat
	IF EXIST "%%~G\MSDCSC\*" PEV -tx50000 -tf "%%~G\MSDCSC\msdcsc.exe" >>d-del_A.dat
	PEV -rtd -dcG20 "%%~G\My Music\*" -preg"\\[a-z0-9]{8,}$" AND "*[0-9]*[0-9]*[0-9]*" -output:temp0300
	FOR /F "TOKENS=*" %%H IN ( temp0300 ) DO @IF EXIST "%%~H\%%~NH.exe" (
		ECHO.%%H>>CFolders.dat
		IF EXIST "%CommonAppData%\%%~H.ini" ECHO."%CommonAppData%\%%~H.ini">>d-del_A.dat
		) ELSE (
		IF EXIST "%%~H\svc?ost*.exe" ECHO.%%H
		IF EXIST "%%~H\jusched*.exe" ECHO.%%H
		)>>CFolders.dat
	)>N_\%random% 2>&1

@DEL /A/F/Q Desktop*F*.dat Personal*F*.dat purityB.dat temp030? N_\* >N_\%random% 2>&1




SED "/:\\/!d; s/\x22//g" LocalAppData.folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" | GREP . >LocalAppData.folder00.dat ||ECHO.::::>LocalAppData.folder00.dat
@(
ECHO.-rtf and {
TYPE LocalAppData.folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" LocalAppDataFileB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.} or {
ECHO.-dG30 -t!pMZ -s+10000 -s-20000 and { *.scr or *.exe or *.com or *.dll or *.pif or *.dl or *.sys or *._dl or *.bin or *.ban or *._sy }
ECHO.}
)>LocalAppDataFile00.dat
PEV -loadline:LocalAppDataFile00.dat >LocalAppDataFile99 2>&1 && GREP -sq "^  " LocalAppDataFile99 ||SED "s/.*/\x22&\x22/" LocalAppDataFile99 >>d-del_A.dat


@(
ECHO.-rtd and {
TYPE LocalAppData.folder00.dat
ECHO.} and {
SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" LocalAppDataFolderB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/"
ECHO.}
)>LocalAppDataFolder00.dat
PEV -loadline:LocalAppDataFolder00.dat >LocalAppDataFolder99 2>&1 && GREP -sq "^  " LocalAppDataFolder99 ||SED "s/.*/\x22&\x22/" LocalAppDataFolder99 >>CFolders.dat


IF EXIST temp0302_gg DEL /A/F temp0302_gg

FOR /F "TOKENS=*" %%G IN ( LocalAppData.folder.dat ) DO @(
	FOR /F "TOKENS=*" %%H IN ( LocalAppDataFileD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtf "%%~G\%%~H">>d-del_A.dat
 	FOR /F "TOKENS=*" %%H IN ( LocalAppDataFolderD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtd "%%~G\%%~H">>d-del_B.dat
	PEV -rtf -t!o -tpmz "%%~G\*" -preg"\.(jpg|jpeg|bmp|gif|png|txt|bat|cmd|htm|html|mht|pdf|tmp|avi|mov|mpg|mpeg|wmv|mp3|cab|zip|rar|doc|log|inf|ini|\d..|.{2})$" >>d-del_A.dat
	PEV -rt!pmz -dG30 "%%~G\*" -preg"\.(dll|scr|exe)$" >>d-del_A.dat
	PEV -rtf -dG30 "%%~G\*" and { *.inf or *.bat or *.vbs or *.log } | FINDSTR -MRF:/ "                       " >>d-del_A.dat 2>N_\%random%
	PEV -rtf -t!o -tp -dG60 "%%~G\*" -c##f#b1:#d#b8:#i#b7:#k#b3:#g#b#y# | SED -r "/	.*(Microsoft|Adobe|Google|Yahoo|Mozilla|Svchost|Realtek|Doctor Web|:ESET |:Opera | hack|crack|keygen|[a-z]{3,}|:.	:.|0x0{8}$)/I!d; s/\t.*//"  >>d-del_A.dat
	PEV -tf -t!o -tpmz { "%%~G\Identities\*" or "%%~G\Microsoft\Credentials\*" or "%%~G\Microsoft\corecon\*" or "%%~G\Microsoft\Crypto\*" or "%%~G\Microsoft\AddIns\*" or "%%~G\Microsoft\SystemCertificates\*" or "%%~G\Microsoft\Protect\*" or "%%~G\Microsoft\Windows\TabbtnEx.exe" } >>d-del_A.dat
	IF EXIST "%%~G\Microsoft Corporation\*" PEV -rtf -tpmz -t!o -t!g -c##f#b#d#j# "%%~G\Microsoft\*" | SED "/	.*Microsoft/d; s/	.*//" >>d-del_A.dat
	IF EXIST "%%~G\*.exe" (
		FINDSTR -M AU3!EA06 "%%~G\*.exe"
		PEV -rtf -t!o -tp { -t!k or -t!j } -d:G120 "%%~G\*.exe"
		)>>d-del_A.dat 2>N_\%random%
	PEV -rtd -dcG20 "%%~G\*" -preg"\\[a-f0-9]{8,}$" -output:temp0300
	FOR /F "TOKENS=*" %%H IN ( temp0300 ) DO @IF EXIST "%%~H\%%~NH.exe" (
		ECHO.%%H>>CFolders.dat
		) ELSE (
		IF EXIST "%%~H\svc?ost*.exe" ECHO.%%H
		IF EXIST "%%~H\jusched*.exe" ECHO.%%H
		)>>CFolders.dat
	PEV -rtd -dcG60 "%%~G\*" -preg"\\[^\\]{32,}$" -output:temp0300
	FOR /F "TOKENS=*" %%H IN ( temp0300 ) DO @(
		IF EXIST "%%~H\enemies-names.txt" ECHO.%%H
		IF EXIST "%%~H\gotnewupdate*.exe" ECHO.%%H
		IF EXIST "%%~H\secureapp*.exe" ECHO.%%H
		IF EXIST "%%~H\svcnost.exe" ECHO.%%H
		IF EXIST "%%~H\livesp.exe" ECHO.%%H
		PEV -rtf "%%~H\*.exe" -preg"\\[0-9A-F]{12,}.exe$" >>d-del_A.dat && ECHO.%%H
		)>>CFolders.dat
	PEV -rtf "%%~G\*_nav*.dat" -output:temp0300
	SED "s/_nav.*//I " temp0300 >temp0301
	SORT /M 65536 temp0301 /T %cd% /O temp0302
	SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" temp0302 >temp0303
	FOR /F "TOKENS=*" %%H IN ( temp0303 ) DO @(
		PEV -rtf "%%~H.exe"
		PEV -rtf "%%~H*.dat"
		)>>d-del_A.dat
	DEL /A/F/Q temp030?

	IF EXIST ChromeSearchXtension* DEL /A/F/Q ChromeSearchXtension*
	FOR %%H IN ( "Chromatic Browser" "Comodo\Dragon" "Google\Chrome SxS" Torch "Google\Chrome" ) DO @IF EXIST "%%~G\%%~H\User Data\Default\Extensions\" (
		PEV -tx50000 -tf "%%~G\%%~H\User Data\Default\Extensions\crossriderManifest.json" -preg"\\User Data\\Default\\Extensions\\[^\\]*\\[^\\]*\\crossriderManifest.json$" | SED -r "/\\[^\\]*\\crossriderManifest.json$/I!d; s///" >> temp0302_gg
		PEV -tx50000 -tf "%%~G\%%~H\User Data\Default\Extensions\background.html" | SED -r "/\\[^\\]*$/!d; s///" > temp0300

		IF EXIST "%%~G\%%~H\\User Data\Default\Local Storage\chrome-extension_*_0.localstorage" (
			FINDSTR -MIR "a.d.v.a.n.c.e.l.o.a.n.\..o.r.g a.l.e.r.t.f.u.n.c.t.i.o.n.s.\..c.o.m a.m.a.i.z.i.n.g.s.e.a.r.c.h.e.s b.a.b.a.V.i.r.a.l.\..c.o.m c.o.o.l.w.e.b.s.e.a.r.c.h h.o.m.e.s.e.a.r.c.h b.y.c.o.n.t.e.x.t.\..c.o.m r.e.l.e.v.a.n.t.s.e.a.r.c.h s.e.a.r.c.h.b.o.m.b s.e.a.r.c.h.r.o.c.k.e.t w.i.s.e.s.e.a.r.c.h" "%%~G\%%~H\User Data\Default\Local Storage\chrome-extension_*_0.localstorage" > ChromeSearchXtension00
			SED -r "s/.*\\chrome-extension_([a-z]{32})_0.localstorage$/\1/I;" ChromeSearchXtension00 > ChromeSearchXtension01
			TYPE ChromeSearchXtension01 >> Chrome_SearchXtension.txt
			IF EXIST ChromeSearchXtension02 DEL /A/F ChromeSearchXtension02
			FOR /F "TOKENS=*" %%I IN ( ChromeSearchXtension01 ) DO @IF EXIST "%%~G\%%~H\User Data\Default\Extensions\%%~I\" ECHO."%%~G\%%~H\User Data\Default\Extensions\%%~I">> ChromeSearchXtension02
			TYPE ChromeSearchXtension02 >> temp0300
			TYPE ChromeSearchXtension02 >> temp0302_gg
			DEL /A/F/Q ChromeSearchXtension*
			)

		IF EXIST temp0301 DEL /A/F temp0301
		FOR /F "TOKENS=*" %%I IN ( temp0300 ) DO @IF EXIST "%%~I\*.js" (
			FINDSTR -MI "jpiproxy\.co\.il japproxy\.net jpionline\.co\.il syncjpionline\.co\.il syncerjpi\.com jpisync\.co\.il" "%%~I\*.js" >> temp0301
			IF EXIST "%%~I\lsdb.js" FINDSTR -MI "url:zycript" "%%~I\*.js" >> temp0301
			)
		SED -r "/(\\Extensions\\[^\\]*)\\[^\\]*\\[^\\]*.js$/I!d ; s//\1/" temp0301 >> temp0302_gg
		GREP -sq . temp0302_gg && PEV -rtf "%%~G\%%~H\User Data\Default\Preferences" >>d-del_A.dat
		)

	CALL :SoftAV "%%~G"
	CALL :LocalAppD "%%~G"

	IF EXIST "%%~G\Google\Desktop\Install\" (
		DIR /A/D/X "%%~G\Google\Desktop\Install" | SED -r "/:.*   <[^ ]*>   /!d; />    *\.{1,2}$/d; s/.*  <[^ ]*>   *([^ ]{3,6}~[0-9])    .*(\?.*|\.\..*| )$/\1/; s/.*  <[^ ]*>  .*     //" >ZAGoogFldr00.dat
		FOR /F "TOKENS=*" %%H IN ( ZAGoogFldr00.dat ) DO @CALL :FindXDir "%%~G\Google\Desktop\Install\%%~H"
		IF EXIST ZAGoogFldr01.dat (
			GREP -F ~ ZAGoogFldr01.dat > ZAGoogFldr02.dat
			FOR /F "TOKENS=*" %%I IN ( ZAGoogFldr02.dat ) DO @(
				SWXCACLS "%%~I" /RESET /Q
				PEV -tf -t!o "%%~I\*" -preg"\\.\\[^\\]*\..$|\\@$" -limit1 > ZAGoogFldr03.dat &&(
					ECHO."%%~G\Google\Desktop\Install">>CFolders.dat
					SED -r "/~[0-9]\\/!d; s/(.*~[0-9])\\.*/\1/;" ZAGoogFldr03.dat >>CFolders.dat
					)))
		DEL /A/F/Q ZAGoogFldr0?.dat
		)
	PEV -tx50000 -tf %%G and { overlay.xul or xulcache.jar } >>XUL00
	) >N_\%random% 2>&1


IF EXIST temp0302_gg GREP -sq . temp0302_gg && (
	TYPE temp0302_gg >>CFolders.dat
	SED -r "/.*\\/!d; s///; /.{8}/!d " temp0302_gg > temp0303_gg
	IF EXIST Chrome_SearchXtension.txt  TYPE Chrome_SearchXtension.txt >>  temp0303_gg
	SORT /M 65536 temp0303_gg /T "%cd%" /O temp0304_gg
	SED -r "$!N; /^(.*)\n\1$/I!P; D" temp0304_gg >temp0305_gg
	ECHO.::::__:::::>>temp0305_gg
	FOR /F "TOKENS=*" %%G IN ( LocalAppData.folder.dat ) DO @(
		FOR %%H IN ( "Chromatic Browser" "Comodo\Dragon" "Google\Chrome SxS" Torch "Google\Chrome" ) DO @IF EXIST "%%~G\%%~H\User Data\Default\Extensions\" (
			PEV -rtf "%%~G\%%~H\User Data\Default\Local Storage\*" | GREP -Fif temp0305_gg >>d-del_A.dat
			PEV -rtd "%%~G\%%~H\User Data\Default\databases\*" | GREP -Fif temp0305_gg >>CFolders.dat
			PEV -rtd "%%~G\%%~H\User Data\Default\Local Extension Settings\*" | GREP -Fif temp0305_gg >>CFolders.dat
			))
	IF EXIST Profiles_wo_ntuser.Folder.dat FOR /F "TOKENS=*" %%G IN ( Profiles_wo_ntuser.Folder.dat ) DO @(
		PEV -tf "%%~G\*" | GREP -Fi "User Data\Default" | GREP -Fif temp0305_gg >>d-del_A.dat
		PEV -td "%%~G\*" | GREP -Fi "User Data\Default" | GREP -Fif temp0305_gg >>CFolders.dat
		))
DEL /A/F/Q temp030? temp030?_gg N_\* Chrome_SearchXtension.txt >N_\%random% 2>&1




SED -r "/\}\\chrome\\(xulcache.jar|content\\overlay.xul)$/I!d; s//}/" XUL00 >XUL01
FOR /F "TOKENS=*" %%G IN ( XUL01 ) DO @FINDSTR -IR "em:hidden[>=].*true" "%%~G\install.rdf" >N_\%random% 2>&1 &&@(
	ECHO.%%G>>CFolders.dat
	IF NOT EXIST XUL02 SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla\Firefox\Extensions" >XUL02
	GREP -Fis "%%~G" XUL02 | SED -r "/^   ([^	]*)	.*/!d; s//\n[HKEY_LOCAL_MACHINE\\SOFTWARE\\Mozilla\\Firefox\\Extensions]\n\x22\1\x22=-/" >>CregC.dat
	)

DEL /A/F/Q XUL0? N_\*  LocalAppDataFile?.dat LocalAppData*0?.dat LocalAppDataFolder*.dat >N_\%random% 2>&1


IF EXIST MyPictures.folder.dat FOR /F "TOKENS=*" %%G IN ( MyPictures.folder.dat ) DO @(
	IF EXIST "%%~G\1e40~1.lnk" ECHO."%%~G\1e40~1.lnk">>d-del_A.dat
	IF EXIST "%%~G\downloadmanager.lnk" ECHO."%%~G\downloadmanager.lnk">>d-del_A.dat
	IF EXIST 	"%%~G\7d1e~1" ECHO."%%~G\7d1e~1">>CFolders.dat
	IF EXIST 	"%%~G\d592~1" ECHO."%%~G\d592~1">>CFolders.dat
	IF EXIST 	"%%~G\navangel" ECHO."%%~G\navangel">>CFolders.dat
	IF EXIST 	"%%~G\28d1~1" ECHO."%%~G\28d1~1">>CFolders.dat
	)



IF EXIST Cache.folder.dat (
	SED "/:\\/!d; s/\x22//g" Cache.folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" | GREP . >Cache.folder00.dat ||ECHO.::::>Cache.folder00.dat
	@ECHO.-rtf and {>CacheFile00.dat
	@TYPE Cache.folder00.dat >>CacheFile00.dat
	@ECHO.} and not {>>CacheFile00.dat
	@ECHO.Desktop.ini or SuggestedSites.dat or counters.dat>>CacheFile00.dat
	@ECHO.}>>CacheFile00.dat
	PEV -loadline:CacheFile00.dat >CacheFile99 2>&1 && GREP -sq "^  " CacheFile99 ||SED "s/.*/\x22&\x22/" CacheFile99 >>d-del_A.dat

	@ECHO.-rtd and {>CacheFolder00.dat
	@TYPE Cache.folder00.dat >>CacheFolder00.dat
	@ECHO.} and {>>CacheFolder00.dat
	@ECHO._KC or "{5617ECA9-488D-4BA2-8562-9710B9AB78D2}">>CacheFolder00.dat
	@ECHO.}>>CacheFolder00.dat
	PEV -loadline:CacheFolder00.dat >CacheFolder99 2>&1 && GREP -sq "^  " CacheFolder99 ||SED "s/.*/\x22&\x22/" CacheFolder99 >>CFolders.dat
	DEL /A/F Cache.folder00.dat CacheFile00.dat CacheFolder00.dat
	)


IF EXIST Cookies.folder.dat (
	SED "/:\\/!d; s/\x22//g" Cookies.folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/-rtf { \x22&\\*\x22 } and { -tpMz or *.scr or *.exe or *.com or *.dll or *.pif or *.dl or *.sys or *._dl or *.bat or *.bin or *.lib or *.db or *.ban or *._sy or *.reg or *.vbs or *.inf }/;" | GREP . >Cookies.folder00.dat ||ECHO.::::>Cookies.folder00.dat
	PEV -loadline:Cookies.folder00.dat >CookiesFile99 2>&1 && GREP -sq "^  " CookiesFile99 ||SED "s/.*/\x22&\x22/" CookiesFile99 >>d-del_A.dat
	DEL /A/F/Q Cookies.folder*.dat
	)


FOR %%G IN (
"%SystemRoot%\-ff93~1.url"
"%system%\8b70f~1"
"%system%\e703~1"
) DO @IF EXIST "%%~G" ECHO."%%~G">>d-del_A.dat

FOR %%G IN (
"%ProgFiles%\7a99~1"
"%ProgFiles%\61ef~1.lnk"
"%ProgFiles%\d592~1"
"%ProgFiles%\cc40~1"
) DO @IF EXIST "%%~G" ECHO."%%~G">>CFolders.dat



IF EXIST LocalSettings.folder.dat (
	SED "/:\\/!d; s/\x22//g" LocalSettings.folder.dat| SED ";:a; $!N; s/\n/\\*\x22 or \x22/; ta; s/.*/\x22&\\*\x22/;" | GREP . >LocalSettings.folder00.dat ||ECHO.::::>LocalSettings.folder00.dat
	@ECHO.-rtf and {>LocalSettingsFile00.dat
	@TYPE LocalSettings.folder00.dat >>LocalSettingsFile00.dat
	@ECHO.} and {>>LocalSettingsFile00.dat
	@SED -r "s/\x22//g; s/^(-|(NOT|AND|XOR|OR|IF|ELSE|\{|}) )/\\\1/" LocalSettingsFileB.dat | SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/" >>LocalSettingsFile00.dat
	@ECHO.}>>LocalSettingsFile00.dat
	PEV -loadline:LocalSettingsFile00.dat >LocalSettingsFile99 2>&1 && GREP -sq "^  " LocalSettingsFile99 ||SED "s/.*/\x22&\x22/" LocalSettingsFile99 >>d-del_A.dat

	FOR /F "TOKENS=*" %%G IN ( LocalSettings.folder.dat ) DO @(
		PEV -rtf -t!o -tpmz "%%~G\*" -preg"\.(jpg|jpeg|bmp|gif|png|txt|bat|cmd|htm|html|mht|pdf|tmp|avi|mov|mpg|mpeg|wmv|mp3|cab|zip|rar|doc|log|inf|ini|\d..|.{2})$" >>d-del_A.dat
		PEV -rt!pmz -dG30 "%%~G\*" -preg"\.(dll|scr|exe)$" >>d-del_A.dat
		PEV -rtf -t!o -tpmz ""%%~G\*" AND { [0-9]*.exe OR [0-9]*.dll  OR { { -t!k or -t!j } -d:G120 } } >>d-del_A.dat
		REM FOR /F "TOKENS=*" %%H IN ( LocalSettingsFileD.dat ) DO @IF EXIST "%%~G\%%~H" PEV -rtf "%%~G\%%~H">>d-del_A.dat
		)
	DEL /A/F/Q LocalSettings.*0?.dat LocalSettingsF*.dat
	)


GREP -lsq "^  " *99. |SED "s/99$//; s/./PEV Error: &/" >>ComboFix.txt
NIRCMD.exe exec hide %KMD% /c "  %SystemRoot%\PEV.exe -tx50000 -tf %SystemDrive%\* and { _desktop.ini or desktop_.ini or cnsmin* or _install.exe or desktop_[12].ini or "%computername%.eml" or readme.eml } or { -s+40000 ws2help.dll } -output:DirRoot"



:STAGE4
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 15000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%5 >WowErr.dat
@Echo:%Stage%5

IF EXIST %SystemRoot%\uninstall ECHO.%SystemRoot%\uninstall>>SearchMetoo.dat


>>CFolders.dat (
	PEV -rtd and { { %SystemDrive%\restore\* or %SystemDrive%\system\* or %SystemDrive%\Config\* } and ?-?-?-??-*-*-* }

	PEV -rtd "%system%\*" and -preg"\\(\d{5,}|[a-z]\d{1,2}|o\d\dPrEz|b\d\dFdUe|f\d\dWtR|vMW\d\da|oTt0\de|rMa\d\dyy|nGpxx\d\d|\{\$....-....-....-....\$\})$" and not x64
	PEV -rtd -dcg30 %system%\boot[0-9][0-9] or  %system%\1441[0-9]  or %system%\com\1.[0-9].[0-9] or %SystemRoot%\net\net[0-9][0-9] or { %SystemRoot%\* and for[0-9][0-9] or int[0-9][0-9] or ap0calypse_* or NewBorn_* }
	FOR /D %%G IN ( %system%\$.* ) DO @IF EXIST "%Systemdrive%\Recycler\%%~NXG\" (ECHO.%%G) ELSE IF EXIST "%Systemdrive%\$Recycle.Bin\%%~NXG\" ECHO.%%G

	PEV -rtd "%SystemRoot%\*" and -preg"\\(_VOID[^\\]*|PRAGMA.{10}|.|\d{1,2}|20110\d{3}|[\d-]{7,}|XXXXXX[^\\]*|Win.ows Publ.{2,4}|[0-9a-f]{8})$"
	PEV -rtd "%SystemRoot%\ime\[0-9][0-9][0-9]" or "%systemroot%\web\printers\[0-9][0-9][0-9]"

	PEV -td -dcg60 "%ProgFiles%\*" -preg"%ProgFiles:\=\\%\\([0-9a-f]{10,}|baidu\\\d{2,5}|\d{3,}soft|(jishu_|ajsksdf|chaoji_|soft|msupdate|date|play)\d{3}[^\\]*|speed[^y]|Win.ows Publ.{2,4}|flash[^eiy]|soft\d{2,}|taobao.|(Internet Explorer|WinRAR\\ComDlls|(Movie Maker|Microsoft Works|Intel|Google Map|Google|NetMeeting|Outlook Express|Gvod)\\Common)\\\d{4,})$"
	PEV -mrtd "%ProgFiles%\*×ÀÃæ°æ"
	PEV -mrtd "%CommonProgFiles%\*" -preg"\\(\{|Chrome Browser.\{|[^\\]*\.\{2227A280-3AEA-1069-A2DE-08002B30309D\})"
	PEV -dcg30 -rtd "%CommonProgFiles%\*" and -preg"\\\d{1,5}$"
	PEV -tx50000 -tf "%CommonProgFiles%\*" and -preg"%CommonProgFiles:\=\\%\\([a-z]{4})\\\1.\\class-barrel$" | FINDSTR -MF:/ _Adult_Anal | SED -r "/\\.{18}$/!d; s///"

	PEV -rtd -dcg30 "%systemdrive%\*" -preg"([^\\]*xxx.exe|RXZZ_V2011-.*)$"
	PEV -tx50000 -tf -dcg1M %SystemDrive%\* and -preg":\\0{3}[A-Z].{4}\\c_754.nls" | SED "s/\\[^\\]*$//"

	IF DEFINED Fonts  PEV -rtd "%Fonts%\*" and -preg"\\\d*$"
	IF DEFINED activex PEV -rtd "%activex%\*" and not -preg"%ActiveX:\=\\%\\(conflict.*|webex|MyWebEx|opswat)"
	REM PEV -rtd -dcg30 "%CommonAppData%\boost_interprocess\201???????????.??????"
	PEV -rtd -dcg30 "%CommonAppData%\microsoft[0-9]*"
	PEV -tx50000 -tf "%CommonAppData%\*" -preg"%CommonAppData:\=\\%\\([^\\ ]{32,})\\\1....$" | FINDSTR -MIF:/ "jpiproxy\.co\.il japproxy\.net jpionline\.co\.il syncjpionline\.co\.il syncerjpi\.com jpisync\.co\.il" | SED -r "/\\[^\\]*$/!d; s///"

	FOR /D %%G IN ( "%ProgFiles%\Compana???" ) DO @IF EXIST "%%~G\OldPro???" ECHO."%%~G"

	)2>N_\%random%


PEV -rtd -t!o -output:temp0400 { %system%\* or %systemroot%\* or %system%\drivers\* or %system%\wbem\* or %systemroot%\system\* or "%ProgFiles%\*" or "%CommonProgFiles%\*" or %systemdrive%\* or "%userprofile%\*" or "%AppData%\*" or "%LocalAppData%\*" } and { *.exe or *.dll }
FOR /F "TOKENS=*" %%G IN ( temp0400 ) DO @PEV -limit1 -tpmz "%%~G\*" >N_\%random% && ECHO.%%G>>CFolders.dat

IF EXIST "%ProgFiles%\?*client" (
	PEV -rtd -dcG30 "%ProgFiles%\?*client" and not "* *" >temp00
	FOR /F "TOKENS=*" %%G IN ( temp00 ) DO @IF EXIST "%%~G\%%~NXGup.exe" IF EXIST "%%~G\%%~NXG.dll" SWREG QUERY "HKCR\SOFTWARE\Classes\%%~NXG.%%~NXGObj" >N_\%random% 2>&1 &&@(
		ECHO.%%G>>CFolders.dat
		ECHO.[-HKEY_LOCAL_MACHINE\SOFTWARE\%%~NXG]>>Creg.dat
		ECHO.[-HKEY_CURRENT_USER\Software\%%~NXG]>>Creg.dat
		ECHO.[-HKEY_LOCAL_MACHINE\SOFTWARE\Classes\%%~NXG.%%~NXGObj]>>Creg.dat
		ECHO.[-HKEY_LOCAL_MACHINE\SOFTWARE\Classes\%%~NXG.%%~NXGObj.1]>>Creg.dat
		ECHO.[-HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AppID\%%~NXG.DLL]>>Creg.dat
		))

PEV -tx50000 -tf -th -ts -dcg30 { %SystemDrive%\System\* or %SystemDrive%\restore\* or %SystemDrive%\data\deleted\* or %SystemDrive%\root\system\* } and desktop.ini -output:temp0400
FINDSTR -MLIF:temp0400 {645FF040-5081-101B-9F08-00AA002F954E} >>temp0401
FOR /F "TOKENS=*" %%G IN ( temp0401 ) DO @(
	PEV -limit:6 -tx50000 -tf "%%~DPG*" -output:temp0402
	GREP -c . temp0402 | GREP -sqx [1-5] &&ECHO.%%~DPG| SED "s/\\$//" >>CFolders.dat
	DEL /A/F temp0402
	)>N_\%random% 2>&1

DEL /A/F/Q temp040? *99. N_\* >N_\%random% 2>&1


:STAGE5
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 20000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%6 >WowErr.dat
@Echo:%Stage%6

:: LOCATE FILES BY SIZE/DATE
>>d-del_A.dat (
	PEV -rtf -t!o -s=0 -DG1 "%SystemRoot%\*" -preg"\\\d{7,}$"
	IF EXIST Vista.krl PEV -rtf  and { -s!4608 and %system%\null.sys } or { -s!6144 and %system%\beep.sys }
	IF EXIST XP.mac PEV -rtf { -s!2944 and %system%\null.sys } or { -s!4224 and %system%\beep.sys }
	IF EXIST %system%\mst120.dll PEV -rtf -s-15000 %system%\mst120.dll
	IF DEFINED Recent PEV -rtf "%Recent%\*" and not { *.lnk or desktop.ini }
	IF DEFINED ActiveX PEV -rtf -s-1751 "%ActiveX%\*" and -preg"\.(.fon|dll|ttf|nls)$" and not -preg"\\(bdcore|libfn)\.dll$"
	IF EXIST %SystemDrive%\drivers\nl?.exe PEV -rtf  %SystemDrive%\drivers\nl[0-9].exe
	IF EXIST %system%\*.exe.dlc PEV -rtf -s-30 %system%\*.exe.dlc
	IF EXIST %system%\*.exe PEV -rtf -dcg30 -t!pmz %systemdrive%\*.exe
	IF EXIST "%system%\??????.jdx" PEV -rtf -s-100 -dg20 "%system%\??????.jdx"

	IF EXIST %system%\ShellExt\* PEV -t!o -rth -tpmz %system%\ShellExt\*
	PEV -rtf -s-2 %system%\* and -preg"\.(dll.tmp|exe.tmp|scr)$"
	PEV -rtf -d:G90 -s-700 { %SystemRoot%\*  or %system%\* } and { *.dll or *.exe }
	PEV -rtf %SystemRoot%\Help\*[0-9][0-9][0-9][0-9]*.exe
	PEV -rtf -s+2048 "%ProgFiles%\*.pif"
	PEV -rtf -t!o -s-1000 -d:G30 %system%\????????.nls
	PEV -rtf -t!o -s-3000 "%system%\*" and -preg"\\sh\d{5}\.(add|ini)$"
	PEV -rtf -t!o -tpmz %system%\c_??????.nls
	PEV -t!o -rtf -tp -t!k -DG15 -DCL85 -DCG105 "%system%\????????.exe"
	PEV -rtf -tpmz and { "%SystemRoot%\*" or "%system%\*" or "%systemdrive%\*" or "%SystemRoot%\System\*" } and -preg"\.(bmp|jpg|pic|tmp|log|txt|doc|gif|bat|cmd|cab|zip|rar|avi|cfg|inf|ini|css|.)$"
	PEV -rtf -t!o -s=2 %SystemRoot%\t55*.dat
	IF DEFINED LocalAppData PEV -tf "%LocalAppData%\*" -preg"%LocalAppData:\=\\%\\[^\\]*\\(..[^\\]*Upd)ate\\\1t32\.(dll|exe)$"
	PEV -dcg30 -t!o -s-2048 -rtf "%CommonAppData%\*" and -preg"\\(~|)[0-9a-z]{8,}$"
	PEV -tf -t!o -t!G %system%\MUI\*.exe
	PEV -rtf -t!o "%system%\sysprep\*.exe" -preg"\\[0-9A-F]{8,}.exe$"
	PEV -tf -tpmz -t!o "%Systemroot%\Installer\syshost.exe"
	)

PEV -tx50000 -tf "%CommonAppData%.\microsoft\iehelper*" | MTEE /+ d-del_A.dat >temp0501
IF EXIST f_system FOR /F "TOKENS=*" %%G IN ( temp0501 ) DO @SWXCACLS "%%~G" /P /GE:F /Q
DEL /A/F/Q temp050? N_\* >N_\%random% 2>&1

PEV -rtf -t!o %SystemDrive%\[0-9]* and -preg"\\\d*\.(dll|exe)" >>d-del_A.dat



:STAGE6
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 30000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%6A >WowErr.dat
@Echo:%Stage%6A

(
PEV -fs32 -rtf -tpmz -t!o -dg3M "%SystemRoot%\Microsoft.NET\Framework\*.exe" -c##d#i#k#g#b#f# | SED -r "/^-{24}	/!d; s///"
PEV -fs32 -rtf -t!o -dg30 -s148000-205000 -c##f#b#y#b#z#b#d#i#k#g#e#j# %SystemRoot%\??????.exe | SED -r "/	0x(\S*)	0x(\1)	/d; /	.*	-{36}$/!d; s///"
IF EXIST %system%\ns??*.dll PEV -fs32 -rtf -c##f#b#d#i#k#g# -s+684500 -s-694500 -dG3M %system%\ns??*.dll | SED -r "/(\\ns[a-z][0-9].{4,5})	-{24}$/!d; s//\1/"
PEV -fs32 -rtf -dcg20 -dg20 -t!o -t!k -tp -t!g %system%\* and -preg"\\([a-z]{9}|[\da-z]{7})\.exe" -c##f#b#d#b#k# | SED -r "/	(-{6}	-{6}|\S+\s+\S+\S[^	]*	)$/!d; s---"
PEV -fs32 -rtf -dcg30 -tpmz %SystemRoot%\java\trustlib\????????.dll -c##f#b#d#i#k#g#| SED -r "/	-{24}$/!d; s///"
PEV -fs32 -rtf -t!o -tpmz -dg30 -s-140000 -c##f#b#y#b#z#b#d#i#k# %system%\spool\prtprocs\w32x86\* not *.exe | SED -r "/	0x(0{8}	0x|.{8}	(|-{18})$)/!d; s/\t.*//"
PEV -fs32 -rtf -s650000-799000 -dcg30 -c##d#k#b#f# %system%\drivers\???????.sys  | SED -r "/^-{12}	/!d; s///" | FINDSTR -MIF:/ "P.ZwQuerySystemInformation..A.ExAllocatePoolWithTag.N.ExFreePoolWithTag"
PEV -rtf -t!o -tp -d:G120 "%CommonProgFiles%\*" -c##d#i#k#g#b#f# | SED -r "/^-{24}	/!d; s///"
PEV -rtf -t!o -dcg30 -s22000-100000 "%System%\*.??" |FINDSTR -MRF:/ "rundll32\.exe.%%s,mymain QQDllProc\.dll.mymain"
PEV -rtf -t!o "%ProgFiles%\Internet Explorer\PLUGINS\*.exe"" -c##d#i#k#g#b#f# | SED -r "/^-{24}	/!d; s///"

)>>d-del_A.dat 2>N_\%random%

(
IF EXIST %system%\winhlp32.exe FINDSTR -MI MZKERNEL32 %system%\winhlp32.exe
IF EXIST "%CommonProgFiles%\*.dll" FINDSTR -MIR "svchost.exe.-k.netsvcs UrlSearchHooks UIEMonitor.pas" "%CommonProgFiles%\*.dll"
IF DEFINED Fonts PEV -fs32 -tx50000 -tf -tpmz -t!o "%FONTS%\*" | FINDSTR -MRF:/ "PE..L...FSG! KickRole CurrentVersion\\Game client\.exe verclsid.exe MZKERNEL32.DLL UpackByDwing rem0teregistry dfc8ac3ed7da\.COMResModuleInstance WININET.dll InternetReadFile NETAPI32.dll CreateServiceA"
IF EXIST "%ProgFiles%\mozilla Firefox\firefox.exe" FINDSTR -MR "S........hlp\.dat yedekler PEBundle" "%ProgFiles%\mozilla Firefox\firefox.exe" &&ECHO.>PatchedBrowsers.dat
IF EXIST "%LocalAppData%\Google\Chrome\Chrome.exe" FINDSTR -MR "S........hlp\.dat PEBundle" "%LocalAppData%\Google\Chrome\Chrome.exe" &&ECHO.>PatchedBrowsers.dat
IF EXIST "%ProgFiles%\Opera\Opera.exe" FINDSTR -MR "S........hlp\.dat PEBundle" "%ProgFiles%\Opera\Opera.exe" &&ECHO.>PatchedBrowsers.dat
IF EXIST "%CommonProgFiles%\*.??" FINDSTR -MC:"rundll32.exe %%s,mymain" "%CommonProgFiles%\*.??"
)>>d-del_A.dat 2>N_\%random%

(
FINDSTR -M "PE..L...FSG!" "%SystemRoot%\Help\*.exe" "%SystemRoot%\Media\*.exe" "%SystemRoot%\Web\*.exe"
FINDSTR -MIL "http://" %SystemRoot%\Web\deskmovr.htt %SystemRoot%\Web\safemode.htt
IF EXIST "%ActiveX%\??????*.cur" FINDSTR -MR "dfc8ac3ed7da\.COMResModuleInstance" "%ActiveX%\??????*.cur"
IF EXIST "%tasks%\*.job" FINDSTR -MI "r.u.n.d.l.l.3.2...e.x.e.*\..d.l.l...,.d A.d.d.R.e.f.A.c.t.C.t.x m.s.h.t.a.\..e.x.e.....h.t.t.p.: B.u.n.g.a._.X A.R.E.S.T.R.A._._.b.e.s.t...e.x.e d.a.t.a.$.~...c.m.d d.a.t.a.$.....c.m.d \*.E.x.p.l.o.r.e.r.\*.\..\*" "%Tasks%\*.job"
IF EXIST "%tasks%\at*.job" FINDSTR -MIRC:".c.m.d.\..e.x.e..*/.c. .d.e.l. ." "%Tasks%\at*.job"
IF EXIST %system%\conime.exe FINDSTR -MI MZKERNEL32 %system%\conime.exe
IF EXIST "%commonProgFiles%\Microsoft Shared\HTMLView\*.exe" FINDSTR -MI a.u.t.o.i.t.s.c.r.i.p.t.\..c.o.m "%commonProgFiles%\Microsoft Shared\HTMLView\*.exe"
IF EXIST "%system%\??????4.exe" GREP -Flsqf asp.str %system%\??????4.exe
IF EXIST "%system%\4???cfsb.dll" PEV -fs32 -rtf "%system%\4???cfsb.dll" | FINDSTR -MIF:/ 6bd97c5b-7a34-4ae9-8b0d-4e03f37a8dbf
IF EXIST %system%\drivers\*.tmp PEV -fs32 -rtf %system%\drivers\*.tmp | FINDSTR -MF:/ W.i.n.P.c.a.p.O.e.m
IF EXIST "%system%\nod??*krns.exe" PEV -fs32 -rtf -d:G60 -s-99000 "%system%\nod??*krns.exe" | FINDSTR -MF:/ "PE..L...FSG!" "%system%\Setup\*.exe"
IF EXIST %system%\?.tmp PEV -fs32 -rtf -ts -th -s=374272 %system%\[a-z].tmp |FINDSTR -MF:/ XPTPSW
IF EXIST "%CommonAppData%.\adobe\*" PEV -fs32 -rtf -s-1000000 "%CommonAppData%.\adobe\*" | FINDSTR -MIF:/ /c:"nsis error"
IF EXIST %SystemRoot%\ms?.exe PEV -fs32 -rtf -t!o -s+91651 -s-98309 -dcg1M %SystemRoot%\ms?.exe |FINDSTR -MRF:/ "\.OkENDF \.BKhgGg \.Jkhsp"
IF EXIST "%SystemRoot%\System\?????.DRV" PEV -fs32 -rtf -dG60 "%SystemRoot%\System\?????.DRV" | FINDSTR -MRF:/ "Stolor\.dll.DllMoveFile TianLongBaBu fuckingboy servername..\\config\.ini QQhxgame\.exe InternetOpenUrlA....InternetOpenA"
IF EXIST "%system%\???.reg" PEV -fs32 -rtf "%system%\[0-9][0-9][0-9].reg" | FINDSTR -MF:/ "ISPSERVICE"
IF EXIST "%system%\??????.imk" PEV -fs32 -rtf -s=1 -dg30 "%system%\0?????.imk" | FINDSTR -MF:/ 0
IF EXIST "%CommonAppData%\DAEMON Tools Lite\*" PEV -fs32 -tpmz -rtf -s2600000-3100000 "%CommonAppData%\DAEMON Tools Lite\my[0-9][0-9][0-9]*.dll" | FINDSTR -MRF:/ "Q.Q.\..e.x.e"
)>>d-del_A.dat 2>N_\%random%


:STAGE6A
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 60000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%7 >WowErr.dat
@Echo:%Stage%7


(
PEV -fs32 -rtf -t!o -d:G90 -s-1000000 %system%\[0-9][0-9][0-9]*.wsf | FINDSTR -MIRF:/ "qwertybot.exe WshShell.Exec..[0-9]*\.exe"
PEV -fs32 -rtf -d:G90 -t!o -s-60000 %SystemRoot%\?????.exe | FINDSTR -MF:/ "PE..L.*nsp2.wp"
PEV -fs32 -rtf -d:G90 -t!o -s=102400 %system%\*.dll | FINDSTR -MIF:/ "26987fc02c\.dll out\.dll"
PEV -fs32 -rtf -d:G90 -t!o -s=158208 %system%\????????*.dll | FINDSTR -MILF:/ BannerRotator.DLL
PEV -fs32 -rtf -t!o -s-1000000 -d:G90 "%system%\ns*.dll" | FINDSTR -MF:/ fotomoto.DLL
PEV -fs32 -rtf -t!o -s-1000000 "%CommonProgFiles%\microsoft shared\msinfo\*" | FINDSTR -MIRF:/ "www.163.com SratMain.dll.DoMainService WolfUpdate"
PEV -fs32 -rtf -t!o -s-1000000 "%SystemRoot%\media\*.mid" | FINDSTR -MF:/ PECompact2
PEV -fs32 -rtf -t!o -s-60000 "%system%\*" and -preg"\\r\d{5}\.exe$" |FINDSTR -MIF:/ "R.u.n.d.l.l.\..e.x.e"
PEV -fs32 -rtf -t!o -s-40000 "%system%\*" and -preg"\\sh\d{5}\.dll$" |FINDSTR -MIF:/ "sohu\.com"
PEV -fs32 -rtf -t!o -s-86017 "%system%\*" and -preg"\\u\d{6}.*\.dll$" |FINDSTR -MIF:/ "www.luckffxi.com"
PEV -fs32 -rtf -s+400000 "%ProgFiles%\Mozilla Firefox\components\*.dll" |FINDSTR -MIF:/ "SidebarFF.dll"
PEV -fs32 -tx50000 -tf -t!o -tpmz -ts -th -dcg30 -s100000-110000 "%ProgFiles%\*" | FINDSTR -MLF:/ "usrinit_t.exe"
PEV -fs32 -rtf -t!o -dg30 -s-200000 %SystemDrive%\*.exe | FINDSTR -MRF:/ "qbyggmgts\.pdb </user><realm>@secureroot</realm>"
PEV -fs32 -rtf -s+41500 -s-43500 -t!o -t!g %system%\drivers\nsr???.sys | FINDSTR -MRF:/ "f.E.r.f.E.m.f.E.a.f.E.t.f.E.i.f.E.o.f.E.n.f.u..P.xV4..E...9...E.X.E.P.......E.P.E.P.......E....=....Vh"
PEV -fs32 -rtf -tp -t!k -t!o -s-3000 %system%\????????.exe | FINDSTR -MF:/ wininet.dll.PrivacyGetZonePreferenceW
PEV -fs32 -rtf -s=236040 -dG2008 %system%\*.d* and { ????????.dat or ???????.dll } | FINDSTR -MRF:/ "software\\%%s.\{%%s-%%s-%%s-%%s-%%s\}"
PEV -fs32 -rtf -t!o -s=63729 "%system%\*.exe" |FINDSTR -MF:/ RegisterMessagePumpHook
PEV -fs32 -rtf -t!o -s+100000 -s-140000 -dcG1M %system%\drivers\????????.sys |FINDSTR -MF:/ fs_rec.pdb
PEV -fs32 -rtf -s=306202 %system%\[a-z][a-z][a-z][a-z][a-z][a-z][a-z][a-z].exe |FINDSTR -MF:/ D.E.S.2.\..e.x.e
PEV -fs32 -rtf -dg3M { -s+48230 -s-48280 %system%\??????????*.exe } or { %system%\??????????*.dll-uninst.exe } |FINDSTR -MLF:/ NullsoftInst
PEV -fs32 -rtf -s+208000 -s-208999 %SystemDrive%\*.exe | FINDSTR -MRF:/ -C:":.5..  ..install.exe"

REM 10-05-07
PEV -fs32 -rtf -tsh -s41000-46000 -dcg30 %system%\???????*.exe | FINDSTR -MRF:/ "wOx.........DDDDDOx"

)>>d-del_A.dat 2>N_\%random%


PEV -fs32 -rtf -s-500000 and { %SystemRoot%\system\* or %system%\* or %SystemRoot%\* } and { *.exe or *.dll and { ?????*0[89][01][0-9][0-9][0-9]*.??? or ??*0[89][01][0-9][0-9][0-9]*.??? } } -output:temp0600
FINDSTR -MIF:temp0600 "auto.exe.*autorun MZKERNEL32.DLL mydown hitpop windll16.dll Policies\\Explorer\\run shell\\explore\\command" >>d-del_A.dat 2>N_\%random%


PEV -fs32 -rtf -t!o -s=249856 %system%\????????.dll -output:temp0600 &&(
	FINDSTR -MIRF:temp0600 "amnesia WindowsSecurityCenter.html SystemErrorFixer Ultimate.Fixer SystemDefender SpyShredder PCPrivacyTool"
	)>>d-del_A.dat 2>N_\%random%


PEV -fs32 -rtf -t!o -s-132000 -d:G60 and { "%CommonAppData\*" or "%system%\*" or "%SystemRoot%\*" } and ????????.dll >>temp0600
FINDSTR -MF:temp0600 "out.dll.DllCanUnloadNow.DllGetClassObject cda17e20e1.dll 26987fc02c.dll 7b66f3721d.dll f486bb9894.dll CMSTransponder solution.DLL exec.DLL" >>d-del_A.dat 2>N_\%random%
DEL /A/F/Q temp06?? >N_\%random% 2>&1



:STAGE7
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 40000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%8 >WowErr.dat
@Echo:%Stage%8

:: STRINGS/SIZE

PEV -fs32 -rtf -s+600000 -s-800000 -d:G90 "%activeX%.\*.dll" | FINDSTR -MRF:/ "cies\\Explorer\\Run Always.CallByControl.GetPlayerVersion.*Stop.playAd" >>d-del_A.dat 2>N_\%random%

PEV -fs32 -rtf -t!o -s+210000 -s-300000 "%system%\wbem\?????.dll" | FINDSTR -MILF:/ system\currentcontrolset\services >>d-del_A.dat 2>N_\%random%
PEV -fs32 -rtf -t!o -s44000-46000 -d:G90 "%system%\??????.exe" | FINDSTR -VILXG:v_wht.dat | FINDSTR -MF:/ "stf%%c%%c%%c%%c%%c\.exe" >>d-del_A.dat 2>N_\%random%
PEV -fs32 -rtf -t!o -d:G90 "%system%\*.exe" and -preg"\\.{5,7}\.exe" and not fixmapi.exe | FINDSTR -MRF:/ "mapistub.dll....NB10......};....fixmapi.pdb" >>d-del_A.dat 2>N_\%random%


SWREG QUERY "hkcu\software\microsoft\internet explorer\desktop\components" /s >temp0700
FINDSTR -IR "Source.*%ProgFiles%" temp0700 >temp0701 2>N_\%random%
FOR /F "TOKENS=2*" %%G IN ( temp0701 ) DO @FINDSTR -MIR "var.pe=new.Array iframe.src=.*k8l.info" "%%H" 2>N_\%random% | MTEE /+ d-del_A.dat >>temp0702
@ECHO.privacy_danger>>temp0702
IF EXIST temp0702 (
	SED "s/\\/\\\\/g" temp0702 >temp0703
	FOR /F "TOKENS=*" %%G IN ( temp0703 ) DO @(
		SWREG QUERY "hkcu\software\microsoft\internet explorer\desktop\components" /s >temp0704
		SED "/./{H;$!d;};x; /%%G/I!d" temp0704 | SED "/^HKEY_.*/I!d; s//[-&]/" >>CregC.dat
		DEL /A/F temp0704 2>N_\%random%
		))
DEL /A/F/Q temp07*. >N_\%random% 2>&1

PEV -fs32 -rtf -s+17000 -s-22000 %SystemRoot%\[a-z][a-z][a-z][a-z][a-z][a-z].exe AND { -d:L36M -d:G39M } or -d:G3M | FINDSTR -MIF:/ "MZKERNEL32.DLL FSG! ByDwing!" >>d-del_A.dat 2>N_\%random%

PEV -fs32 -rtf -t!o -s+19000 -s-20000 %SystemRoot%\[a-z][a-z][a-z][a-z][a-z][a-z][a-z][a-z].exe AND { -d:L36M -d:G39M } or -d:G3M >temp0700
PEV -fs32 -rtf -t!o -s+17000 -s-20000 %system%\????????.exe >>temp0700
PEV -fs32 -rtf -t!o -s+17000 -s-20000 "%system%\*[0-9].exe" AND { -d:L36M -d:G39M } or -d:G3M >>temp0700
PEV -fs32 -rtf -t!o -s+7000 -s-8000 -d:G39M %system%\*[0-9].exe AND { -d:L36M -d:G39M } or -d:G3M >>temp0700
PEV -fs32 -lrtf -t!o -s-20000 %system%\[a-z]???????[0-9][0-9][0-9][0-9]*.exe >temp0701
GREP -E "\\[a-z][a-z][A-Z]{6}[0-9]{4,}\....$" temp0701 >>temp0700
FINDSTR -MIF:temp0700 MZKERNEL32 >>d-del_A.dat 2>N_\%random%
DEL /A/F/Q temp07*. >N_\%random% 2>&1

PEV -fs32 -lrtf -t!o -s-139000 %system%\??????*.dll AND { -d:L36M -d:G39M } or -d:G3M >temp0700
SED -r "/-/!d;  /( 2[5-9]| 3[0-47]| 4[15]|13[48]),.*\\[a-z]{6,8}.dll/!d; s/^.{47}//" temp0700 >temp0701
FINDSTR -VILXG:v_wht.dat temp0701 | FINDSTR -MF:/ "Yf=okt.f=adt  Yf=okt.f=upt" >>d-del_A.dat 2>N_\%random%
DEL /A/F/Q temp07*. >N_\%random% 2>&1

PEV -fs32 -rtf -t!o -d:G3M "%system%\??????.dll" AND { -s+211000 -s-215000 or -s+222000 -s-223000 } >temp0700 &&FINDSTR -VILXG:v_wht.dat temp0700 | FINDSTR -MIF:/ dLL_Main >>d-del_A.dat 2>N_\%random%

PEV -fs32 -tx50000 -tf -t!o { "%system%\wbem\*" or "%system%\oobe\*" } and svchost.exe | MTEE temp0700 >>d-del_A.dat
FOR /F "TOKENS=*" %%G IN ( temp0700 ) DO @CALL :REMDIR "%%~DPG" >N_\%random% 2>&1

PEV -fs32 -rtd -dCG45 %system%\[a-z][a-z][a-z][a-z][a-z][a-z][a-z][a-z]  and not { dllcache or shellext or macromed } >temp0700
FOR /F %%G IN ( temp0700 ) DO @PEV -fs32 -rtf -t!o -s-1000000 "%%G\%%~NXG?.exe" | FINDSTR -MF:/ /c:"Nous-Tech Solutions" >>d-del_A.dat 2>N_\%random% &&ECHO."%system%\%%G">>CFolders.dat
DEL /A/F/Q temp07*. >N_\%random% 2>&1



:STAGE8
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 20000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%9 >WowErr.dat
@Echo:%Stage%9

PEV -fs32 -rtf -t!o -s+19000 -s-42000 -dc:G20 %system%\????????.exe -output:temp0800
SED -r ":a;$!N; s/\n/\x22 \x22/;ta; s/.*/\x22&\x22/;s/(.{3500}[^\x22]*\x22) /\1\n/g" temp0800 >temp0801
FOR /F "TOKENS=*" %%G IN ( temp0801 ) DO @GSAR -sQf`U:x8b:xec:x83:xec:x0c:x83:xec:x0c %%G| SED "/: .*/!d;s///" >>d-del_A.dat 2>N_\%random%

PEV -fs32 -rtf -t!o -s+540000 -s-542000 -d:G90 "%system%\??????????*.dll" -output:temp0800 &&FINDSTR -VILXG:v_wht.dat temp0800 | FINDSTR -MIRF:/ BrowserHelper\.dll >>d-del_A.dat 2>N_\%random%

DEL /A/F/Q temp080? N_\* >N_\%random% 2>&1



:STAGE9
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 70000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%10 >WowErr.dat
@Echo:%Stage%10

IF EXIST Clsid.hiv @(
	DUMPHIVE -e Clsid.hiv ClsidDumped
	SED.exe -r "s/^@=expand:/@=/I; s/\\\x22//g; s/\\\\/\\/g; /^\[CLSID\\[^\\]*\\(Local|Inproc)Server32\]|^@=\x22|^$/I!d; s/\[CLSID\\//" ClsidDumped | SED.exe -r -n "/]$/{$!N; s/\\(Local|Inproc)server32]\n@=/	/Ip}" >ClsidFiles
	IF EXIST W6432.dat (
		SED -r "s/^\[clsid\\//; " ClsidFiles > ClsidFiles00
		MOVE /Y ClsidFiles00 ClsidFiles
		)
	FINDSTR -BIG:badclsid ClsidFiles | SED -r "s/\x22//g; s/.*	//; s/(.*\\..)(..)(.*)/\1\U\2\L\3/" >BadClsidFiles00
	SED.exe -r "/^\{[^	]*[^-0-9a-f][^	]*\}	/I!d;" ClsidFiles > Q_Clsids
	SED -r "s/\x22//g; s/.*	//; s/(.*\\..)(..)(.*)/\1\U\2\L\3/" Q_Clsids >> BadClsidFiles00
	SED "/	.*/!d; s///" Q_Clsids >delclsid00
	CALL delclsid.bat
	FOR /F "TOKENS=*" %%G in ( BadClsidFiles00 ) DO @GREP -Fic "%%G" ClsidFiles | GREP -sqx [0-2] &&ECHO.%%G>>BadClsidFiles
	ECHO.::::>>BadClsidFiles
	PEV -fs32 -filesBadClsidFiles -tx50000 -tf -t!o -t!g | FINDSTR -VILXG:v_wht.dat >>d-del_A.dat
	GREP -Fi "javascript:" ClsidFiles >Poweliks.dat && FOR /F "TOKENS=1* DELIMS=	" %%G IN ( Poweliks.dat ) DO @IF EXIST W6432.dat (
		IF EXIST "%systemroot%\System32\REGINI.exe" (
			PEV -k dllhost.exe
			@ECHO.HKEY_CLASSES_ROOT\CLSID\%%~G [1 5 7 11 17]>Reg_ini.dat
			@ECHO.HKEY_CLASSES_ROOT\CLSID\%%~G\LocalServer32 [1 5 7 11 17]>>Reg_ini.dat
			"%systemroot%\System32\REGINI.exe" Reg_ini.dat
			REG.EXE SAVE "HKCR\CLSID\%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\CLSID_%%~G.hiv.dat" /Y
			REGT /e /s "%SystemDrive%\Qoobox\Quarantine\Registry_backups\CLSID_%%~G.reg.dat" "HKEY_CLASSES_ROOT\CLSID\%%~G"
			REG.EXE DELETE "HKCR\CLSID\%%~G\LocalServer32" /va /F
			RNullFix64 \registry\user -f -s > RNull00
			GREP -Fi "%%~G\localserver32" RNull00 | SED -r "/.*(\\registry\\user\\.*)/I!d; s//\1/" >RNull01
			FOR /F "TOKENS=*" %%H IN ( RNull01 ) DO @RNullFix64 %%H -r -s
			REG.EXE DELETE "HKCR\CLSID\%%~G\LocalServer32" /F
			DEL /A/F/Q RNull0?
			)>N_\%random% 2>&1
		) ELSE (
		SWREG SAVE "HKCR\CLSID\%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\CLSID_%%~G.hiv.dat"
		REGT /e /s "%SystemDrive%\Qoobox\Quarantine\Registry_backups\CLSID_%%~G.reg.dat" "HKEY_CLASSES_ROOT\CLSID\%%~G"
		PEV -k dllhost.exe
		SWREG ACL "HKCR\CLSID\%%~G" /RESET /Q
		SWREG NULL DELETE "HKCR\CLSID\%%~G\LocalServer32"
		)
	DEL /A/F BadClsidFiles Clsid.hiv badclsid BadClsidFiles00 Q_Clsids
	)>N_\%random% 2>&1

:: STRINGS/SIZE RANGE
:: New Files


PEV -fs32 -rtf -d:G30 "%system%\*[0-9][0-9].sys" -output:temp0900
SED -R "/\\[a-z]{3,5}\d\d\.sys$/I!d" temp0900 >temp0901
FINDSTR -MF:temp0901 ZwDeleteKey 2>N_\%random% | FINDSTR -MF:/ KeServiceDescriptorTable >>d-del_A.dat
DEL /A/F/Q temp090? >N_\%random% 2>&1


PEV -fs32 -rtf -t!o "%system%\*.dll" AND { -s+8400 -s-8500 or -s+18200 -s-18300 or -s+19300 -s-19500 } -output:temp0900 &&FINDSTR -VILXG:v_wht.dat temp0900 | FINDSTR -MIF:/ MZKERNEL32\.DLL >>d-del_A.dat 2>N_\%random%

IF EXIST "%tasks%\wsock32.dll" IF EXIST "%ProgFiles%\wsock32.dll" IF EXIST Drives.dat (
	FOR /F "TOKENS=*" %%G IN ( Drives.dat ) DO @VOL %%G: &&PEV -fs32 -s-20000 "%%G:\wsock32.dll" >>temp0900
	IF EXIST temp0900 GREP -Fiv "%SystemRoot%" temp0900 >>d-del_A.dat
	DEL /A/F temp0900
	)>N_\%random% 2>&1

IF EXIST DoStepDel IF EXIST d-del_A.dat GREP -ivq "::::" d-del_A.dat &&( Call :PreRunDel )|| DEL /A/F d-del_A.dat


:STAGE10
PEV -k NIRKMD.%cfext%
PEV.exe -fs32 -loadlineVikPev00 >Vikpev01
@Echo:%Stage%11 >WowErr.dat
@Echo:%Stage%11



:STAGE11
START NIRKMD CMDWAIT 18000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%12>WowErr.dat
@Echo:%Stage%12

@PEV -fs32 -rtf -s+550000 .\clsid.dat >N_\%random% || PEV.exe CLSID d clsid.c clsid.dat
DEL /A/F/Q temp110? clsid.c N_\* >N_\%random% 2>&1


:: SSODL - WINDOWS\Resources
PEV -fs32 -rtf -t!o -s-20000 %SystemRoot%\resources\*.dll -output:temp1100 && FINDSTR -MIF:temp1100 PECompact2 >temp110A 2>N_\%random% &&@(
	Type temp110A >>d-del_A.dat
	SWREG QUERY "hklm\software\microsoft\windows\currentversion\shellserviceobjectdelayload" >SSDOLQuery.dat
	SED -r "/	/!d; s/^ +// " SSDOLQuery.dat >temp1102
	FINDSTR -vilg:clsid.dat temp1102 >temp1103
	FOR /F "TOKENS=1,2* DELIMS=	" %%G IN ( temp1103 ) DO @(
		SWREG QUERY "hkcr\clsid\%%I\Inprocserver32" /ve >temp1104
		GREP -Fisqf temp110A temp1104 &&(
			ECHO.[hkey_local_machine\software\microsoft\windows\currentversion\shellserviceobjectdelayload]>>CregC.dat
			ECHO."%%G"=->>CregC.dat
			ECHO.[-HKEY_CLASSES_ROOT\CLSID\%%I]>>CregC.dat
			)
		DEL /A/F temp1104 2>N_\%random%
		))
DEL /A/F/Q temp110? >N_\%random% 2>&1


:STAGE12
PEV -k NIRKMD.%cfext%
@Echo:%Stage%13>WowErr.dat
@Echo:%Stage%13

IF EXIST "%ProgFiles%\winrar\rar\" (
	PEV -rtd -dcg30 "%ProgramFiles%\winrar\rar\????" > temp1200
	FOR /F "TOKENS=*" %%G IN ( temp1200 ) DO @IF EXIST "%%G.exe" (
		ECHO."%%G.exe">> d-del_A.dat
		CALL :RemDir "%%G" 3
		))
DEL /A/F/Q temp120? >N_\%random% 2>&1



:STAGE13
@Echo:%Stage%14 >WowErr.dat
@Echo:%Stage%14

PEV -fs32 -rtf -t!o "%system%\*hk.dll" -output:temp1300
SED -r "s/%system:\=\\%\\(.*)hk\.dll$/\1/" temp1300 > temp1301
FOR /F "TOKENS=*" %%G IN  ( temp1301 ) DO @IF EXIST "%system%\%%G.exe" IF EXIST "%system%\%%Gr.exe" IF EXIST "%system%\%%Gwb.dll" (
	@ECHO."%system%\%%G.exe"
	@ECHO."%system%\%%Gr.exe"
	@ECHO."%system%\%%Gwb.dll"
	@ECHO."%system%\%%Ghk.dll"
	)>>d-del_A.dat
DEL /A/F/Q temp130? >N_\%random% 2>&1



:STAGE14
@Echo:%Stage%15 >WowErr.dat
@Echo:%Stage%15

:: random alphanumeric named service



:STAGE15
START NIRKMD CMDWAIT 15000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%16 >WowErr.dat
@Echo:%Stage%16

:: Feixue variants - locked files
PEV -fs32 -lrtf  -t!o -s-57000 "%system%\drivers\?????*.sys" and not { 1394bus.sys or amdk8.sys or lsi_sas2.sys or UAGP35.SYS or viac7.sys } -output:temp1500
SED -r "/ (19,104|4[7-9]|5.),.*:\\.*\\[^\\]*[0-9][^\\]*$/!d; s/.{47}//" temp1500 >temp1501
IF EXIST Suspect_feixue FINDSTR -IE "%SYSDIR:\=\\%\\drivers\\[^\\]*\.sys" Suspect_feixue >>temp1501

FINDSTR -MIRF:temp1501 "I.o.C.r.e.a.t.e.S.y.m.b.o.l.i.c.L.i.n.k" 2>locked|FINDSTR -MRF:/ "K.e.S.e.r.v.i.c.e.D.e.s.c.r.i.p.t.o.r.T.a.b.l.e P.s.S.e.t.C.r.e.a.t.e.P.r.o.c.e.s.s.N.o.t.i.f.y.R.o.u.t.i.n.e" | MTEE /+ d-del_A.dat >temp1503

CALL :Locked >N_\%random% 2>&1

FOR /F "TOKENS=*" %%G IN ( LockedB ) DO @(
	FINDSTR -MIR "I.o.C.r.e.a.t.e.S.y.m.b.o.l.i.c.L.i.n.k" "%%~DPG_%%~NG_%%~XG.vir" 2>N_\%random% |(
		FINDSTR -MRF:/ "K.e.S.e.r.v.i.c.e.D.e.s.c.r.i.p.t.o.r.T.a.b.l.e P.s.S.e.t.C.r.e.a.t.e.P.r.o.c.e.s.s.N.o.t.i.f.y.R.o.u.t.i.n.e"
			)>N_\%random% && ECHO.%%G| MTEE /+ d-del_A.dat >>temp1503
	DEL /A/F "%%~DPG_%%~NG_%%~XG.vir" 2>N_\%random%
	)

DEL /A/F/Q lockedB N_\* >N_\%random% 2>&1


PEV -fs32 -rtf -t!o -s-20000 "%system%\drivers\?????*.sys" -output:temp1504
FINDSTR -MIRF:temp1504 "feixue my123 Autolive system32\\%%s" 2>>locked | MTEE /+ d-del_A.dat >>temp1503

CALL :Locked >N_\%random% 2>&1

FOR /F "TOKENS=*" %%G IN ( lockedB ) DO @(
	FINDSTR -MIR "feixue my123 Autolive system32\\%%s" "%%~DPG_%%~NG_%%~XG.vir" >N_\%random% 2>&1 && ECHO.%%G| MTEE /+ d-del_A.dat >>temp1503
	DEL /A/F "%%~DPG_%%~NG_%%~XG.vir" 2>N_\%random%
	)

DEL /A/F/Q lockedB N_\* >N_\%random% 2>&1


FOR /F "TOKENS=*" %%G IN ( temp1503 ) DO @(
	ECHO.%%~NG| MTEE /+ SvcTargeted >>zhSvc.dat
	FINDSTR -MIR "my123 Autolive coolxuen" "%system%\%%~NG.dll" >>d-del_A.dat 2>N_\%random% && (
		SWREG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Runonce" /v "%%~NG" /f >N_\%random% 2>&1
		))

:: Newer routine for feixue (modified 08-08-16)
PEV -fs32 -lrtf -s-163841 %system%\????*.dll -output:temp1505
SED -r "/( 45,056|163,840|159,744).*\\[^\\]{4,9}\.dll$/I!d; s/.{47}//" temp1505 >temp1506
IF EXIST Suspect_feixue FINDSTR -IE .dll Suspect_feixue >>temp1506
FOR /F "TOKENS=*" %%G IN ( temp1506 ) DO @GREP -Elisq "[^a-z][a-z]{11}\.dll.DllUnregisterServer|f=9!ZX|WinExec.*InternetReadFile" "%%~G" >>d-del_A.dat 2>N_\%random%

DEL /A/F/Q feixue_fileBB Suspect_feixue temp150? N_\* >N_\%random% 2>&1



:STAGE16
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 15000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%17 >WowErr.dat
@Echo:%Stage%17


@(
ECHO.C.u.r.r.e.n.t.C.o.n.t.r.o.l.S.e.t.\\.S.e.r.v.i.c.e.s.\\.%%.s...U........SVWj
ECHO.\\.D.o.s.D.e.v.i.c.e.s.\\.a.g.o.n.y
ECHO.\\RootKit\\i386\\agony\.pdb
ECHO.F.i.l.e.D.e.s.c.r.i.p.t.i.o.n.....I.E.M.o.n.i.t.o.r
ECHO.M.i.c.r.o.s.o.f.t...R.P.C...A.P.I...H.e.l.p.e.r
ECHO.r.a.w.v.f.i.l.e.\..d.l.l
ECHO.runtime3\.pdb
ECHO.\\protect\.pdb
ECHO.KeServiceDescriptorTable..k.ZwSetValueKey
ECHO.L^|o^|o^|p
ECHO.s.y.s.t.e.m.3.2.\\.%%.s...d.l.l.,.D.l.l.U.n.r.e.g.i.s.t.e.r.S.e.r.v.e.r dX^)q`4...,{5gAd
ECHO.objfre_wxp_x86\\i386\\CORE\.pdb
ECHO.\\i386\\d\.pdb
ECHO.objfre_wxp_x86\\i386\\drive4.pdb
ECHO.s.v.c.h.o.s.t...e.x.e...-.k...n.e.t.s.v.c.s
ECHO.svchost.exe.-k.netsvcs
ECHO.ROOTKIT:.OnUnload.called
ECHO.objchk_wlh_x86\\i386\\HIDE.pdb
ECHO.testsys\\objfre_wxp_x86\\i386\\ndissyn.pdb
ECHO.\\.D.e.v.i.c.e.\\._._.m.a.x.+.+
ECHO.fireasseye\.com
ECHO.\\.?.?.\\.K.L.a.n.S.y.m.b.o.l.s
ECHO.\\.B.a.s.e.N.a.m.e.d.O.b.j.e.c.t.s.\\.{.6.1.4.B.7.6.2.4.-.1.5.8.9.-.C.2.2.8.-.F.8.4.B.-.4.A.1.1.C.C.5.7.4.1.3.D.5.5.B.E.}
ECHO.:\\Zorg\\sys\\objfre\\i386\\syringe.pdb
ECHO.pc\\rootkit2\\Release\\DrvFltIp.pdb
ECHO.c:\\users\\icyheart\\docume~1\\visual~1\\projects\\download\\driver\\objfre_wxp_x86\\i386\\Driver.pdb
ECHO.\\.D.o.s.D.e.v.i.c.e.s.\\.r.g.a.d.t.a
ECHO.\\.D.o.s.D.e.v.i.c.e.s.\\.k.i.l.l.v.v
ECHO.\\qq\\protect9\\objfre_wxp_x86\\i386\\kiss.pdb
ECHO.\\!!BOTSRC!!!\\objfre\\i386\\bot.pdb
ECHO.\\.D.e.v.i.c.e.\\.m.n.d.i.s.k
ECHO.\\.D.o.s.D.e.v.i.c.e.s.\\.{.0.0.D.0.E.D.A.F.-.2.1.0.D.-.4.e.b.5.-.A.0.0.F.-.F.4.A.2.4.5.A.A.7.2.0.A.}
ECHO.\\.D.o.s.D.e.v.i.c.e.s.\\.D.a.r.k.2.1.1.8
ECHO.\\.D.e.v.i.c.e.\\.3.6.0.T.i.m.e.P.r.o.t
ECHO.\\.D.e.v.i.c.e.\\.3.6.0.S.u.p.e.r.K.i.l.l
ECHO.eclipse\\branch\\botnet\\1.020\\drivers\\Bin\\i386\\kernel.pdb
ECHO.\\.D.e.V.i.C.e.\\.R.e.1.9.8.6.S.D.T
ECHO.\\.D.e.v.i.c.e.\\.F.i.x.M.o.n
ECHO.services\\cdnprot
ECHO.\\.D.e.v.i.c.e.\\.m.m.w.i.z.e.d.k.b.3.2
ECHO.\.pak0...............................`..`\.pak1...............................`..`\.pak2
ECHO.\\.D.e.v.i.c.e.\\.l.i.n.g.a.x
ECHO.f:\\VC5\\release\\nthost\.pdb
ECHO.\\.R.e.g.i.s.t.r.y.\\.M.a.c.h.i.n.e.\\.S.Y.S.T.E.M.\\.C.o.n.t.r.o.l.S.e.t.0.0.2.\\.S.e.r.v.i.c.e.s
ECHO.\\rkit_dll_7.1.0\\objchk\\i386\\bound.pdb
ECHO.\\.D.o.s.D.e.v.i.c.e.s.\\.H.D.C.D.E.V.I.C.E.M.G.R
ECHO.\\MyRootKit\\objfre\\i386\\MyRootKit.pdb
ECHO.FALSE....\\rootkit\.c.EX:
ECHO.:\\eclipse\\botnet\\drivers\\Bin
ECHO.\\.D.e.v.i.c.e.\\.3.6.0.S.u.p.e.r.K.i.l.l.
ECHO.clickdomain
ECHO.disableredirectwhencontainheader
ECHO.\\.D.o.s.D.e.v.i.c.e.s.\\.i.a.l.d.n.w.x.f.
ECHO.Gootkit
ECHO.Fuck.you
ECHO.disableredirectwhencontainheader
ECHO.\\.D.e.v.i.c.e.\\.g.s.s.i.t...\\.
ECHO.\\.D.o.s.D.e.v.i.c.e.s.\\.z.x.s.d.e.r.f.b.u.k.j.f.y.s.h.l.h
ECHO.C:\\5\\amdk8\\Driver\\objfre\\i386\\amdk8\.pdb
ECHO.\\rootkit\.cpp
ECHO.\\.D.e.v.i.c.e.\\.s.w.a.p.b.u.r.n.....\\.D.o.s
ECHO.serverd.adv.ourmobile.cc
ECHO.\\.g.l.o.b.a.l.r.o.o.t.\\.D.e.v.i.c.e.\\.s.v.c.h.o.s.t...e.x.e.\\.s.v.c.h.o.s.t.\..e.x.e
ECHO.\\.A.C.P.I.#.P.N.P.0.3.0.3.#.2...d.a.1.a.3.f.f...0.\\.%%.0.8.x.\..s.y.s
ECHO.c:\\sys\\objfre_wxp_x86\\i386\\rgr.pdb
ECHO.\\moneyback\\drvprot\\release\\stub.pdb
ECHO.\\outerdrv\\objfre_wxp_x86\\i386\\OuterDrv.pdb
ECHO.\\eclipse\\botnet\\.
ECHO.\\.D.e.v.i.c.e.\\.D.a.y.s.t.e.r...\\.
ECHO.\\.A.C.P.I.#.P.N.P.0.3.0.3.#.2...d.a.1.a.3.f.f...0.\\.
ECHO.\\.D.e.v.i.c.e.\\.S.i.x.s.e.r
ECHO.Tell.that.bitch.to
ECHO.\\.D.e.v.i.c.e.\\.s.b.a.h.n...\\.D.o.s
)>DrvStr

PEV -fs32 -rtf -t!o "%system%\drivers\*.sys" and not ndis.sys | FINDSTR -MRG:DrvStr /F:/ >>d-del_A.dat 2>Locked
CALL :Locked >N_\%random% 2>&1
FOR /F "TOKENS=*" %%G IN ( LockedB ) DO @(
	FINDSTR -MRG:DrvStr "%%~DPG_%%~NG_%%~XG.vir" &&ECHO.%%G>>d-del_A.dat
	DEL /A/F "%%~DPG_%%~NG_%%~XG.vir"
	)>N_\%random% 2>&1
DEL /A/F LockedB DrvStr >N_\%random% 2>&1

PEV -fs32 -s+20000 -s-55000 -t!o -t!j -t!g %system%\drivers\*.sys | FINDSTR -MF:/ IofCompleteRequest..,.ObfDereferenceObject >>d-del_A.dat 2>N_\%random%

PEV -fs32 -c##f#b#d#i#k#g# -rtf -s=153728 -t!o -t!g %system%\drivers\?????[0-9][0-9].sys | SED -r "/	-{24}$/!d; s///" | FINDSTR -MRF:/ "EC~-...m..Q.MR..Fm.T/x..Y..N.VawxB....1.]..p.6.I'9Mm..4S.a.........+...({W/.No....g8" >>d-del_A.dat 2>N_\%random%


:STAGE17
PEV -k NIRKMD.%cfext%
@Echo:%Stage%18 >WowErr.dat
@Echo:%Stage%18

:: 110728
IF EXIST SvcDump GREP -Eis "%CommonAppData:\=\\%\\[^\\]*\\[^\\]*\.bin$" SvcDump >temp1800 &&(
	SED "s/\t.*//" temp1800 >> zhsvc.dat
	SED "s/.*\t//" temp1800 >> d-del_A.dat
	)>N_\%random% 2>&1
DEL /A/F/Q temp180? N_\* >N_\%random% 2>&1



:STAGE18
@Echo:%Stage%19 >WowErr.dat
@Echo:%Stage%19



:STAGE19
START NIRKMD CMDWAIT 20000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%

@Echo:%Stage%19B >WowErr.dat
@Echo:%Stage%19B


TYPE zhsvc.dat svc_wht.dat >SvcCovered 2>N_\%random%
GREP -Fixvf SvcCovered SvcFull >suspectSvc.dat || DEL /A/F suspectSvc.dat
IF NOT EXIST suspectSvc.dat GOTO STAGE20


SWREG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost" /v netsvcs >temp1900
SED "/.*	/!d; s///; s/[\\0]*$//; s/\\0/\n/g" temp1900 >temp1901
GREP -xivf netsvc.dat temp1901 >SuspectB_netsvc.dat
GREP -xsif suspectSvc.dat SuspectB_netsvc.dat >temp1902

FOR /F "TOKENS=*" %%G IN ( temp1902 ) DO @(
	FINDSTR -BILC:"%%G\parameters	" SvcDump >temp1903
	SED "s/\\.*	/=/" temp1903 >>suspect_netsvcs.dat
	)
DEL /A/F/Q temp190? N_\* >N_\%random% 2>&1

:: Borlander - random 4 character ProgramFiles folders + Services


IF EXIST DoStepDel IF EXIST d-del_A.dat GREP -ivq "::::" d-del_A.dat &&( Call :PreRunDel )|| DEL /A/F d-del_A.dat



:STAGE19B
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 20000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%

@Echo:%Stage%20 >WowErr.dat
@Echo:%Stage%20
IF EXIST W6432.dat GOTO STAGE20

FOR /F "TOKENS=*" %%G IN ( SuspectB_netsvc.dat ) DO (
	SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Services\%%~G\Parameters" /v ServiceDll >temp19B03
	SED "/.*	/!d; s///" temp19B03 >temp19B04
	FOR /F "TOKENS=*" %%H IN ( temp19B04 ) DO @CALL ECHO."%%~H">temp19B05
	IF EXIST temp19B05 FOR /F "TOKENS=*" %%I IN ( temp19B05 ) DO @PEV -rt!i "%%~I" && Catchme -l N_\%random% -c "%%~I" "%%~DPI_%%~NXI_.vir" >N_\%random%1 &&(
		FINDSTR -RI "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" "%%~DPI_%%~NXI_.vir" ||(
			ECHO.%%~G| MTEE /+ zhSvc.dat >>netsvc.bad.dat
			TYPE temp19B05 >>d-delA.dat
			)
		DEL /A/F "%%~DPI_%%~NXI_.vir"
		)
	DEL /A/F temp19B03 temp19B04 temp19B05 temp19B06
	)>N_\%random% 2>&1
DEL /A/F/Q temp19B0? >N_\%random% 2>&1




:STAGE20
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 30000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%21 >WowErr.dat
@Echo:%Stage%21

PEV -fs32 -rtf -t!o -s+75000 -s-85000 -d:G90 "%system%\???????.dll" -output:temp2000
FINDSTR -VILXG:v_wht.dat temp2000 | FINDSTR -MIRF:/ "smlrx32\.dll  WLEventLogon" >>V-FilesB.dat 2>N_\%random%

IF NOT EXIST suspect_ntfy.dat GOTO STAGE21
:: Winlogon Infections - Delf Rootkit/???

IF EXIST suspect_netsvcs.dat (
	SED -r "/^.{8}$/!d" suspect_ntfy.dat >temp2000
	FOR /F "TOKENS=*" %%G IN ( temp2000 ) DO @(
		SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%%G" /v dllname >temp2001
		SED -r "/	.{7,8}\.dll/I!d; s/.*	//" temp2001 >temp2002
		FOR /F "TOKENS=*" %%H IN ( temp2002 ) DO @(
			GREP -Fie "%%H" suspect_netsvcs.dat >temp2003
			FOR /F "TOKENS=1,2 DELIMS==" %%I IN ( temp2003 ) DO (
				ECHO.%%I| MTEE /+ zhsvc.dat /+ SvcTargeted >>netsvc.bad.dat
				ECHO.%%J>>d-del_A.dat
				ECHO.[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%%G]>>CregC.dat
				ECHO.[-hkey_users\temphive2\microsoft\windows nt\currentversion\winlogon\notify\%%~G]>>erunt.dat
				)
			DEL /A/F temp2003 >N_\%random% 2>&1
			)
		DEL /A/F temp2001 temp2002 >N_\%random% 2>&1
		)
	DEL /A/F/Q temp200? N_\* >N_\%random% 2>&1
	)


FOR /F "TOKENS=*" %%G IN ( suspect_ntfy.dat ) DO @(
	SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%%G" /v DLLName >temp2000
	SED "/.*	/!d; s///; /^.:\\/!s/.*/%system:\=\\%\\&/" temp2000 >DLLName00
	FINDSTR -MIRF:DLLName00 "PECompact2 double_hooka.dll" >temp2001 2>N_\%random% &&@(
			IF EXIST temp2001 TYPE temp2001 >>d-del_A.dat
			ECHO.[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%%G]>>CregC.dat
			FOR /F "TOKENS=*" %%H IN ( temp2001 ) DO @IF EXIST "%SystemRoot%\%%~NH.tmp" (
				FINDSTR -MI "double_hooka.dll" "%SystemRoot%\%%~NH.tmp" )>>d-del_A.dat 2>N_\%random%
			IF NOT EXIST STS00 SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\sharedtaskscheduler" >STS00
			FINDSTR -LI "%%~G" STS00 >temp2002
			FOR /F %%H IN ( temp2002 ) DO @(
				ECHO.[-HKEY_CLASSES_ROOT\CLSID\%%H]>>CregC.dat
				ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\sharedtaskscheduler]>>CregC.dat
				ECHO."%%H"=->>CregC.dat
				))
	FINDSTR -MIRF:DLLName00 "smlrx32\.dll" >temp2003 2>N_\%random% &&@(
			IF EXIST temp2003 TYPE temp2003 | MTEE /+ v-filesB.dat >>d-del_A.dat
			ECHO.[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%%~G]>>CregC.dat
			ECHO.[-hkey_users\temphive2\microsoft\windows nt\currentversion\winlogon\notify\%%~G]>>erunt.dat
			)
	DEL /A/F/Q DLLName00 temp200? N_\* >N_\%random% 2>&1
	)
DEL /A/F/Q STS00 >N_\%random% 2>&1


:STAGE21
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 20000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%22 >WowErr.dat
@Echo:%Stage%22

TYPE zhsvc.dat svc_wht.dat >SvcCovered 2>N_\%random%
GREP -Fixvf SvcCovered SvcFull >suspectSvc.dat
IF NOT EXIST suspectSvc.dat GOTO STAGE22
:: Recursive Services Search .. autolive



:STAGE22
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 30000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%23 >WowErr.dat
@Echo:%Stage%23
:: Recursive Services Search .. Microsoft.RPC.API.Helper


SWREG QUERY "hklm\system\currentcontrolset\control\session manager\appcertdlls" /v appsecdll >temp2200
GREP -Eisq "%SYSDIR:\=\\%\\appcert\\wsil32.dll|%SYSDIR:\=\\%\\(wincert|mscert|mshlps|curlib|mswins)\.dll|%userprofile:\=\\%" temp2200 &&@(
	GREP -Fisq "%system%\appcert\wsil32.dll" temp2200 && ECHO."%system%\appcert">>d-delB.dat
	ECHO.[-hkey_local_machine\system\currentcontrolset\control\session manager\appcertdlls]
	ECHO.[-hkey_local_machine\software\microsoft\appcert]
	)>>CregC.dat

@(
ECHO.DllMain.DllRegisterServer.DllUnregisterServer.ServiceMain
ECHO.O.r.i.g.i.n.a.l.F.i.l.e.n.a.m.e...S.t.d.M.F.C.3.2...d.l.l
ECHO.A.l.c.o.h.o.l...S.o.f.t...D.e.v.e.l.o.p.m.e.n.t
)>Str00

PEV -fs32 -lrtf -t!o -s-128000 %system%\*.dll and not MFC71.dll -output:temp2201
SED -r "/(54,7|57,[38]|59,3|67,5|68,6|83,|84,9|86,|88,|89,8|91,6|92,|93,1|94,2|96,|98,|10.,|110,|123,|127,).*:\\/!d; s/.*(.:\\)/\1/" temp2201 >temp2202
PEV -fs32 -sdIname -rtf %system%\*.dll | SED -n -r "$!N; /^(.*)(.dll)\n(\1[a-z]\2)$/Is//\3/p; ta; /^(.*)(.dll)\n(\1.\2)$/Is//\1\2/p; :a; D;" >temp2203
ECHO.::::>>temp2203
PEV -fs32 -filestemp2203 -tx50000 -tf -t!o -t!g >>temp2202

FINDSTR -VILXG:v_wht.dat temp2202 >temp2204
FINDSTR -MF:temp2204 -G:Str00 >temp2205 2>N_\%random%
FOR /F "TOKENS=*" %%G IN ( temp2205 ) DO @(
	PEV -fs32 -rtf -t!o "%%G*"
	PEV -fs32 -rtf -t!o "%%~DPNG.1"
	)| MTEE /+ UploadThese >>d-del_A.dat


DEL /A/F/Q Str00 temp220? N_\* >N_\%random% 2>&1


PEV -fs32 -s+11000 -s-23425 %system%\drivers\* and { *.sys or *.dat } -c##k#b#u#b#f# -output:temp2200
SORT /M 65536 temp2200 /T %cd% /O temp2201
SED -n -r "/^------	/d; $!N; /^(.*	).*	.*\n\123424(.*\\[^\\]{12})$/Ip; D;" temp2201 | SED -r "/^(.*)	.*\\\1$/d; /.*	23424	(.*\\[^\\]{12})$/!d;s//\1/" >temp2202
SED -n -r "/^------	23424	/!d; s///p" temp2201 >temp2203
FINDSTR -MF:temp2203 ZwQuerySystemInformation.*KeServiceDescriptorTable |MTEE /+ UploadThese >>d-del_A.dat 2>locked
TYPE temp2202 >>temp2203
FOR /F "TOKENS=*" %%G IN ( temp2203 ) DO @GREP -c V.S._.V.E.R.S.I.O.N._.I.N.F.O %%G | GREP -sq [2-9] &&ECHO.%%G|MTEE /+ temp2202  /+ UploadThese >>d-del_A.dat
SED "/FINDSTR: Cannot open /I!d; s///" locked >>temp2202

GREP -sq . temp2202 ||GOTO Stage23
SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" temp2202 >temp2203

Set "DelfStr=5c,00,62,00,72,00,6f,00,77,00,73,00,65,00,72,00,20,00,68,00,65,00,6c,00,70,00,65,00,72,00,20,00,6f,00,62,00,6a,00,65,00,63,00,74,00,73,00"

SED -r "s/.*\\([^\\]*)\.(sys|dat)$/\1/" temp2203 >temp2204
GREP -Fixvf svc_wht.dat temp2204 | GREP -Fixvf 023.dat >temp2205
SED "/../!d; s/.*/&\\..../" temp2205 >temp2206
FINDSTR -RIEG:temp2206 temp2203 >temp2207 2>N_\%random%

FOR /F "TOKENS=*" %%G IN ( temp2207 ) DO @(
	IF NOT EXIST DelfSuspect SED "/./{H;$!d;};x;/%DelfStr%/!d" SvcDumpFull >DelfSuspect
	SED -r "/./{H;$!d;};x;/\\%%~NG\]\n.*\x22ImagePath\x22=[^\n]*\\drivers\\%%~NXG/I!d" DelfSuspect >temp2208
	GREP -ix ".Group.=.Boot Bus Extender." temp2208 &&@(
		PEV EXEC /S "%CD%\HIDEC.%cfExt%" SWREG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_%%~NG\0000" /v ConfigFlags /t reg_dword /d 1
		ECHO.%%~NG| MTEE /+ SvcTargeted /+ Rustock.dat >>zhsvc.dat
		ECHO.%%~G|MTEE /+ UploadThese >>d-del_A.dat
		SWREG EXPORT "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~NG" "aa_%%~NG.dat" /nt4
		))>N_\%random% 2>&1

DEL /A/F/Q DelfSuspect temp220? SvcDumpFull N_\* locked >N_\%random% 2>&1

Set DelfStr=
IF NOT EXIST aa_*.dat GOTO STAGE23

FOR %%G IN ( aa_*.dat ) DO @(
	SED "s/00,//g; s/system\\currentcontrolset\\services/software\\swearware\\temp/Ig; s/hex:/hex(2):/Ig" "%%G" >"bb_%%~NG.dat"
	REGT /S "bb_%%~NG.dat" >N_\%random% 2>&1
	PEV WAIT 500
	SWREG QUERY "HKLM\Software\Swearware\temp" /s >"cc_%%~NG.dat"
	SWREG DELETE "HKLM\Software\Swearware\temp" >N_\%random% 2>&1
	SED "/reg_.*System32\\/I!d; s/.*System32\\/%SYSDIR:\=\\%\\/I" "cc_%%~NG.dat"  | MTEE /+ d-del_A.dat >"baks_%%~NG.dat"
	SED "/.*\\registry\\machine\\/I!d; s//[-hkey_local_machine\\/; s/\x7d\\inprocserver32$/\x7d/I; s/.*/&]/"  "cc_%%~NG.dat" | MTEE /+ CregC.dat >temp2200
	SED "/.*winlogon\\notify/I!d; s/.*\\notify\\/\x5b-hkey_users\\temphive2\\microsoft\\windows nt\\currentversion\\winlogon\\notify\\/I" temp2200 >>erunt.dat

	IF EXIST "baks_%%~NG.dat" (
		GREP -Esx .{8} suspectSvc.dat >temp2201
		TYPE "baks_%%~NG.dat" >temp2202
		FOR /F "TOKENS=*" %%I IN ( temp2202 ) DO @(
			IF EXIST "%%~I.*" PEV -fs32 -rtf -t!o -d:G30 "%%~DPNI.*" |MTEE /+ UploadThese >>d-del_A.dat
			FOR /F "TOKENS=*" %%J IN ( temp2201 ) DO @(
				FINDSTR -BLIC:"%%J\parameters	%%~I" SvcDump >temp2203 2>N_\%random%
				SED "s/\\.*//" temp2203 | MTEE /+ zhSvc.dat /+ SvcTargeted >>netsvc.bad.dat
				DEL /A/F temp2203 >N_\%random% 2>&1
				))
		DEL /A/F temp2201 temp2202 >N_\%random% 2>&1
		)

	DEL /A/F temp2200 "bb_%%~NG.dat" "cc_%%~NG.dat" "baks_%%~NG.dat" >N_\%random% 2>&1
	)


:STAGE23
PEV -k NIRKMD.%cfext%
:: IF EXIST UploadThese CALL :SUBMIT >N_\%random% 2>&1
DEL /A/F/Q temp220? N_\* aa_*.dat >N_\%random% 2>&1
@Echo:%Stage%24 >WowErr.dat
@Echo:%Stage%24

TYPE zhsvc.dat svc_wht.dat >SvcCovered 2>N_\%random%
GREP -Fixvf SvcCovered SvcFull >suspectSvc.dat

IF EXIST "%TEMP%\smtmp\1\" CALL :smtmp >N_\23_%random% 2>&1


:STAGE24
START NIRKMD CMDWAIT 12000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%25 >WowErr.dat
@Echo:%Stage%25

:: Navipromo, SpyEyes, Zbot

SWREG SAVE HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run CuRun.hiv >N_\%random% 2>&1
DumpHive CuRun.hiv CuRun.dmp >N_\%random% 2>&1

GREP -Fisq "javascript:" CuRun.dmp &&(
	PEV -k dllhost.exe
	SWREG EXPORT "HKCU\software\microsoft\windows\currentversion\run" HKCU_RUN.reg.dat
	SWREG NULL DELETE "HKCU\software\microsoft\windows\currentversion\run"
	SWREG IMPORT HKCU_RUN.reg.dat
	SWREG NULL DELETE "HKCU\software\microsoft\windows\currentversion\run" /ve
	)>N_\%random% 2>&1


REM SED -r "s/\\\\/\\/g; /^\x22([^\x22]*)\x22=\x22.*((%LocalAppData:\=\\%\\.*|%userprofile:\=\\%|%profilesdirectory:\=\\%)\\\1[^\\]*)\x22$/I!d; s//\2/; s/ *\/.*//" CuRun.dmp |MTEE /+ d-del_A.dat >>catch_k.dat
SED -r "s/\\\\/\\/g; /^\x22([^\x22]*)\x22=\x22.*((%LocalAppData:\=\\%|%userprofile:\=\\%|%profilesdirectory:\=\\%)\\\1[^\\]*)\x22$/I!d; s//\2/; s/ *\/.*//" CuRun.dmp |MTEE /+ d-del_A.dat >>catch_k.dat
SED -r "s/\\\\/\\/g; /.*\x22=\x22.*(%systemdrive:\=\\%\\[^\\ ]{6,}\\[0-9A-F]{9,15}\.exe).*/I!d; s//\1/" CuRun.dmp |MTEE /+ d-del_A.dat >>catch_k.dat
SED -r "s/\\\\/\\/g; /^\x22([a-z]*\.exe)\x22=\x22.*(%systemdrive:\=\\%\\\1\\\1)\x22$/I!d; s//\2/" CuRun.dmp >SpyEyes00
SED -r "s/\\\\/\\/g; /^\x22(.{6,})\.exe\x22=\x22.*(%systemdrive:\=\\%\\\1\\\1\.exe)\x22$/I!d; s//\2/" CuRun.dmp >>SpyEyes00

GREP -Fs :\ SpyEyes00 >>d-del_A.dat &&(
	TYPE myNul.dat >CfReboot.dat
	FOR /F "TOKENS=*" %%G IN ( SpyEyes00 ) DO CALL :RemDir "%%~DPG" 2
	)>N_\%random% 2>&1
DEL SpyEyes00 SpyEyes01 >N_\%random% 2>&1
DEL /A/F CuRun.hiv CuRun.dmp >N_\%random% 2>&1


FOR %%G IN ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" ) DO @(
	SWREG QUERY %%G >temp2400
	GREP -Ei "(%system:\=\\%|%LocalAppdata:\=\\%)\\([a-z]*)\.exe .*" temp2400 >temp2401 &&(
		FOR /F %%H IN ( temp2401 ) DO @GREP -iq "%%~H.*%%~H\.exe %%~H" temp2401 &&(
			ECHO.[%%~G]>>CregC.dat
			ECHO."%%~H"=->>CregC.dat
			SED -r "/^ *%%~H/!d; s/.*	(.*) %%~H/\1/" temp2401 >temp2402
			FOR /F "TOKENS=*" %%I IN ( temp2402 ) DO @(
				NIRCMD killprocess "%%~I"
				%KMD% /C PEV -fs32 -rtf -t!o "%%~I" >>d-del_A.dat
				%KMD% /C PEV -fs32 -rtf -t!o "%%~DPNI*.dat" >>d-del_A.dat ||(
					ECHO."%%~I">>Navipromo.dat
					TYPE myNul.dat >CfReboot.dat
					) )
			DEL /A/F temp2402 >N_\%random% 2>&1
			) )
	DEL /A/F/Q temp240? >N_\%random% 2>&1
	)

PEV -fs32 -rtf "%system%\*_nav*.dat" -output:temp2400
SED "s/_nav.*//I" temp2400 >temp2401
SORT /M 65536 temp2401 /T %cd% /O temp2402
SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" temp2402 >temp2403
FOR /F "TOKENS=*" %%G IN ( temp2403 ) DO @(
	PEV -fs32 -rtf -t!o "%%~G.exe"
	PEV -fs32 -rtf -t!o "%%~G*.dat"
	)>>d-del_A.dat
DEL /A/F/Q temp240? N_\* >N_\%random% 2>&1


:: SpyEyes ; hidden root folders
PEV -rtd %systemdrive%\* -output:temp2400
PEV EXEC /S PEV -rtd %systemdrive%\* -output:"%CD%\temp2401"
ECHO.::::>>temp2400
GREP -Fivxf temp2400 temp2401 | SED -r "/:\\.{6,}/!d; s/.:\\(.*)/&\t\1/" > temp2402
FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp2402 ) DO @IF EXIST "%%~G\config.bin" (
	IF EXIST "%%~G\%%~H" ECHO."%%~G\%%~H">>d-delA.dat && CALL :RemDir "%%~G" 2
	IF EXIST "%%~G\%%~H.exe" ECHO."%%~G\%%~H.exe">>d-delA.dat && CALL :RemDir "%%~G"
	)

FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp2402 ) DO @(
	ATTRIB "%%G\*"  > temp2403
	GREP -Eisq "\\[0-9A-F]{9,}\.exe$" temp2403 &&(
		SED -r "/\\[0-9A-F]{9,}\.exe$/I!d; s/.*(.:\\)/\1/" temp2403 >> d-delA.dat
		CALL :RemDir "%%G" 3
		)
	DEL temp2403
	)>N_\%random% 2>&1

DEL /A/F/Q temp240? N_\* >N_\%random% 2>&1


:STAGE25
PEV -k NIRKMD.%cfext%
@Echo:%Stage%26 >WowErr.dat
@Echo:%Stage%26



:STAGE26
START NIRKMD CMDWAIT 15000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%27 >WowErr.dat
@Echo:%Stage%27

:: FLASH DRIVE INFECTIONS
:: NIRCMD emptybin

IF EXIST Drives.dat FOR /F "TOKENS=*" %%G IN ( Drives.dat ) DO @VOL %%G: >N_\%random% 2>&1 &&(
	IF EXIST "%%G:\usp10.dll" PEV -fs32 -tx50000 -tf -s-100000 -t!o -t!g "%%G:\usp10.dll"
	IF EXIST "%%G:\FlySoft\" ECHO.%%G:\FlySoft>>Cfolders.dat
	IF EXIST "%%G:\WinsUp\" ECHO.%%G:\WinsUp>>Cfolders.dat
	IF EXIST "%%G:\Images\_PAlbTN\" ECHO.%%G:\Images\_PAlbTN>>Cfolders.dat
	IF EXIST "%%G:\resycled\" ECHO.%%G:\resycled>>Cfolders.dat
	IF EXIST "%%G:\Recyded\" ECHO.%%G:\Recyded>>Cfolders.dat
	IF EXIST "%%G:\Winup\" ECHO.%%G:\Winup>>Cfolders.dat
	IF EXIST "%%G:\ssphall\" ECHO.%%G:\ssphall>>Cfolders.dat
	IF EXIST "%%G:\ssshall\" ECHO.%%G:\ssshall>>Cfolders.dat
	IF EXIST "%%G:\driver\info\Desktop.ini" ECHO.%%G:\driver\info>>Cfolders.dat
	IF EXIST "%%G:\Windows Media Player\Program Files\" ECHO.%%G:\Windows Media Player>>Cfolders.dat
	IF EXIST "%%G:\Program\3608\" ECHO.%%G:\Program\3608>>Cfolders.dat
	IF EXIST "%%G:\ghos\giex" ECHO.%%G:\ghos>>Cfolders.dat
	IF EXIST "%%G:\Recycled.{645FF040-5081-101B-9F08-00AA002F954E}\" ECHO.%%G:\Recycled.{645FF040-5081-101B-9F08-00AA002F954E}>>Cfolders.dat

	FOR /D %%H IN ( %%G:\RECYCLER* ) DO @IF /I NOT "%%~H"=="%%G:\RECYCLER" ECHO.%%H>>Cfolders.dat

	IF EXIST "%%G:\%ProgFiles:~3%\Happygame V1.0\" ECHO."%%G:\%ProgFiles:~3%\Happygame V1.0">>Cfolders.dat
	IF EXIST "%%G:\%ProgFiles:~3%\Happygame\" ECHO."%%G:\%ProgFiles:~3%\Happygame">>Cfolders.dat
	IF EXIST "%%G:\SystemÿVolumeÿInformation\" ECHO."%%G:\SystemÿVolumeÿInformation">>Cfolders.dat
	IF EXIST "%%G:\360Downloads\" ECHO."%%G:\360Downloads">>Cfolders.dat
	IF EXIST "%%G:\prdy2175418941\" ECHO."%%G:\prdy2175418941">>Cfolders.dat
	IF EXIST "%%G:\VolumeDH\" ECHO."%%G:\VolumeDH">>Cfolders.dat
	IF EXIST "%%G:\BEF\tmp\" ECHO."%%G:\BEF">>Cfolders.dat
	IF EXIST "%%G:\FSI\tmp\" ECHO."%%G:\FSI">>Cfolders.dat
	IF EXIST "%%G:\MEA\tmp\" ECHO."%%G:\MEA">>Cfolders.dat
	IF EXIST "%%G:\RECYCLERNNKH\" ECHO."%%G:\RECYCLERNNKH">>Cfolders.dat
	IF EXIST "%%G:\Gao\tmp\" ECHO."%%G:\GAO">>Cfolders.dat
	IF EXIST "%%G:\Dosame\" ECHO."%%G:\Dosame">>Cfolders.dat
	IF EXIST "%%G:\pchd\" ECHO."%%G:\pchd">>Cfolders.dat
	IF EXIST "%%G:\skajhdjashugdkahusgdnkwuaeq\" ECHO."%%G:\skajhdjashugdkahusgdnkwuaeq">>Cfolders.dat
	IF EXIST "%%G:\C0MM\" ECHO."%%G:\C0MM">>Cfolders.dat
	IF EXIST "%%G:\CB30~1\" ECHO."%%G:\CB30~1">>Cfolders.dat
	IF EXIST "%%G:\fontpage\" ECHO."%%G:\fontpage">>Cfolders.dat
	IF EXIST "%%G:\game\msning\*.bat" ECHO."%%G:\game\msning">>Cfolders.dat
	IF EXIST "%%G:\DrivesGuideInfo\S-1-7-21-1439977401-7444491467-600013330-9141\" ECHO."%%G:\DrivesGuideInfo\S-1-7-21-1439977401-7444491467-600013330-9141">>Cfolders.dat
	IF EXIST "%%G:\System Volume Information\com1.{20D04FE0-3AEA-1069-A2D8-08002B30309D}\" ECHO."%%G:\System Volume Information\com1.{20D04FE0-3AEA-1069-A2D8-08002B30309D}">>Cfolders.dat
	IF EXIST "%%G:\TrashBin.{645FF040-5081-101B-9F08-00AA002F954E}\" ECHO."%%G:\TrashBin.{645FF040-5081-101B-9F08-00AA002F954E}">>Cfolders.dat
	IF EXIST "%%G:\TNRIKN\CDRXJE.exe\" ECHO."%%G:\TNRIKN\CDRXJE.exe">>Cfolders.dat
	IF EXIST "%%G:\FavoriteVideo\InvisibleFolder\" ECHO."%%G:\FavoriteVideo\InvisibleFolder">>Cfolders.dat
	IF EXIST "%%G:\recycle.{645FF040-5081-101B-9F08-00AA002F954E}\" ECHO."%%G:\recycle.{645FF040-5081-101B-9F08-00AA002F954E}">>Cfolders.dat
	IF EXIST "%%G:\System Volume Information\com1.{20D04FE0-3AEA-1069-A2D8-08002B30309D}\" ECHO."%%G:\System Volume Information\com1.{20D04FE0-3AEA-1069-A2D8-08002B30309D}">>Cfolders.dat
	IF EXIST "%%G:\Program\Thunder\Thunder\Program\" ECHO."%%G:\Program\Thunder">>Cfolders.dat
	IF EXIST "%%G:\$RECYCLE.BIN\{5F229C11-5039-40E4-8537-6950BB1C9ECC}\" ECHO.%%G:\$RECYCLE.BIN\{5F229C11-5039-40E4-8537-6950BB1C9ECC}>>Cfolders.dat
	IF EXIST "%%G:\RECYCLER\*" DEL /A/F/Q/S "%%G:\RECYCLER\*" >N_\%random% 2>&1 && PEV -fs32 -tx50000 -tf -tpmz "%%G:\RECYCLER\*" and not { INFO2 or DC[0-9]* or Desktop.ini or -preg":\\[^\\]*\\Nprotect\\." }
	IF EXIST "%%G:\RECYCLED\*" DEL /A/F/Q/S "%%G:\RECYCLED\*" >N_\%random% 2>&1 && PEV -fs32 -tx50000 -tf -tpmz "%%G:\RECYCLED\*" and not { INFO2 or DC[0-9]* or Desktop.ini or -preg":\\[^\\]*\\Nprotect\\." }
	IF EXIST "%%G:\$RECYCLE.BIN\*" DEL /A/F/Q/S "%%G:\$RECYCLE.BIN\*" >N_\%random% 2>&1 && PEV -fs32 -tx50000 -tf -tpmz "%%G:\$RECYCLE.BIN\*" and not { $[RI]?????? or $[RI]??????.* }

	PEV -fs32 -tpmz -t!o -t!g -tshr -dcg30 -rtf -s93000-125000 -c##f#b#y#d#e#g#i#j#k# %%G:\* and -preg"\\[a-z0-9]*\....$" and -preg"\\(.*\d.*[a-z]\..{3}|.{1,4}\..{3}|[^aeiou]*\.exe|.*\d.*[a-z].*\d.*\.exe)$" | SED "/	0x00000000------------------------------------$/!d; s///"
	PEV -fs32 -rtf -s-120000 -d:G90 "%%G:\?????.exe" >temp2600
	FINDSTR -VR [0-9] temp2600 | FINDSTR -MF:/ DDDDDDDDDDDDD 2>N_\%random% | FINDSTR -MF:/ URLDownloadToFile >>bad~.dat
	PEV -fs32 -rtf -tpmz %%G:\* and { *.bat or *.cmd or *.xls.exe or *.pif } >>bad~.dat
	GSAR -bs:x17:x86:x20:xAAS:xE7N:xF9S:xE7N:xF9S:xE7N:xF9S:xE7O:xF9:xD9:xE6N:xF9:x90:xE8:x13:xF9P:xE7N:xF9:x90:xE8:x12:xF9R:xE7N:xF9:x90:xE8:x10:xF9R:xE7N:xF9:x90:xE8A:xF9V:xE7N:xF9:x90:xE8:x11:xF9:x8E:xE7N:xF9:x90:xE8:x2E:xF9W:xE7N:xF9:x90:xE8:x14:xF9R:xE7N:xF9RichS:xE7N %%G:\*.exe %%G:\*.com 2>&1 | SED -r "/: 0x80$/!d; s///" >>bad~.dat
	PEV -fs32 -rtf "%%G:\*" >temp2601
	FINDSTR -EIRG:autorun_inf.dat temp2601
	FOR /F "TOKENS=*" %%X IN ( DriveFile.dat ) DO @PEV -rtf "%%~G:\%%~X"
	FOR /F "TOKENS=*" %%X IN ( autorun_infB.dat ) DO @IF EXIST "%%~G:\%%~X" ECHO."%%~G:\%%~X"
	IF EXIST "%%G:\autorun.bat" FINDSTR -MI autorun.vbs "%%G:\autorun.bat"
	IF EXIST "%%G:\autorun.reg" FINDSTR -MI userinit.exe.autorun.bat "%%G:\autorun.reg"
	IF EXIST "%%~G\auto.exe" GREP -ls "pcbe.<=fgx <<;}`x)ek+rq.\|.aspack\|h!;<ugh'ki)vkev.\|MZKERNEL32.DLL" "%%~G\auto.exe"

	IF EXIST "%%G:\autorun.inf" IF NOT EXIST "%%G:\autorun.inf\" (
		TYPE "%%G:\autorun.inf" 2>N_\%random% | FINDSTR -IRG:autorun_inf.dat >N_\%random% && ECHO."%%G:\autorun.inf"
		IF EXIST "bad~.dat" TYPE "%%G:\autorun.inf" 2>N_\%random% | GREP -Fiqf "bad~.dat" && ECHO."%%G:\autorun.inf"
		)

	IF EXIST "%%G:\copy.exe" FINDSTR -MI \\svch "%%G:\copy.exe"
	IF EXIST "%%G:\host.exe" FINDSTR -MI \\shell\\open\\command "%%G:\host.exe"

	IF EXIST "%%G:\autorun.exe" FINDSTR -MIR "5D83AD9C-3BF 4B55-B87D-264934EBEAED" "%%G:\autorun.exe" 2>N_\%random% &&(
		IF EXIST "%%G:\autorun.inf" FINDSTR -MI "autorun\.exe" "%%G:\autorun.inf"
		)

	IF EXIST "%%G:\?.exe" GREP -l AU3!EA06 %%G:\?.exe

	IF EXIST "%%G:\setup.exe" (

		FINDSTR -MI InternetOpenA "%%G:\setup.exe" | FINDSTR -MF:/ a\/lock &&(
			IF EXIST "%%G:\autorun.inf" IF NOT EXIST "%%G:\autorun.inf\" FINDSTR -MI setup.exe "%%G:\autorun.inf"
			)

		FINDSTR -MI InternetOpenA "%%G:\setup.exe" | FINDSTR -MF:/ /c:"umeaj _" &&(
			IF EXIST "%%G:\autorun.inf" IF NOT EXIST "%%G:\autorun.inf\" FINDSTR -MI setup.exe "%%G:\autorun.inf"
			)

		FINDSTR -MI WINDOTS "%%G:\setup.exe" &&(
			IF EXIST "%%G:\autorun.inf" IF NOT EXIST "%%G:\autorun.inf\" FINDSTR -MI setup.exe "%%G:\autorun.inf"

			))
	IF EXIST bad~.dat TYPE bad~.dat && DEL /A/F bad~.dat
		)>>d-del_A.dat 2>N_\%random%

@DEL /A/F/Q autorun_inf?.dat temp260? N_\* >N_\%random% 2>&1


@SET "mountpoints=HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2"
@SWREG DELETE "%mountpoints%" >N_\%random% 2>&1
DEL /A/F/Q temp260? >N_\%random% 2>&1
SET mountpoints=


IF EXIST "%ProgFiles%\*.inf" FINDSTR -MI oxjsybe\.exe "%ProgFiles%\*.inf" >>d-del_A.dat 2>N_\%random%


:STAGE27
PEV -k NIRKMD.%cfext%
@Echo:%Stage%28 >WowErr.dat
@Echo:%Stage%28



:STAGE28
START NIRKMD CMDWAIT 20000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%29 >WowErr.dat
@Echo:%Stage%29

PEV -fs32 -rtf -t!o -d:G90 "%system%\*.exe" AND { -s=28634 or -s=30320 or -s=63235 } -output:temp2800
FINDSTR -MIF:temp2800 "MZKERNEL32.DLL" >>_bot.dat 2>>Lock_bot.dat

GREP -sq FINDSTR Lock_bot.dat &&@(
	SED "/FINDSTR: Cannot open /I!d; s///" Lock_bot.dat >Suspect_bot.dat
	Handle .exe >temp2802
	FINDSTR -ILG:suspect_bot.dat temp2802 >temp2803 2>N_\%random%
	SED "/.*pid: /!d; s///; s/ .*//" temp2803 >temp2804
	FOR /F "TOKENS=*" %%G IN ( temp2804 ) DO @PEV EXEC /S "%CD%\NIRCMD.%cfExt%" KILLPROCESS /%%G
	title .
	PEV WAIT 800
	FINDSTR -MIF:Suspect_bot.dat "MZKERNEL32.DLL" >>_bot.dat 2>N_\%random%
	DEL /A/F temp2802 temp2803 temp2804
	)

GREP -s . _bot.dat >>d-del_A.dat &&(
	FINDSTR -ILG:_bot.dat SvcDump >temp2802 2>N_\%random%
	SED "s/	.*//" temp2802 | MTEE /+ SvcTargeted >>zhSvc.dat
	)

@DEL /A/F/Q *_bot.dat temp280? N_\* >N_\%random% 2>&1



:STAGE29
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 10000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%30 >WowErr.dat
@Echo:%Stage%30

:: Srizbi
IF NOT EXIST W6432.dat GREP -sq . SvcDiff &&(
	SED "s/$/	/" SvcDiff >temp2900
	GREP -Fif temp2900 SvcDump >temp2901
	FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp2901 ) DO @IF NOT EXIST "%%~H" GREP -sq . "%%~H"  &&(
		Catchme -l N_\%random% -c "%%~H" N_\testme
		IF EXIST N_\testme FINDSTR -MI "ZwQuerySystemInformation.*RtlImageDirectoryEntryToData" N_\testme &&(
			SWREG link add "HKLM\System\CurrentControlSet\Services\deleteme" "HKLM\System\CurrentControlSet\Services\%%~G" /temp
			SWREG ADD "HKLM\System\CurrentControlSet\Services\deleteme" /v Start /t reg_dword /d 4
			SWREG link delete "HKLM\System\CurrentControlSet\Services\deleteme"
			ECHO."%%~G"| SED "s/\x22//g" | MTEE /+ SvcTargeted >>zhsvc.dat
			ECHO.[-HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G]>>CregC.dat
			ECHO."%%~FH">>srizbi.dat
			)
		DEL /A/F N_\testme
		)
	DEL /A/F/Q temp290?
	) >N_\%random% 2>&1


PEV -fs32 -md5list:srizbi.md5 -rtf -t!o -d:G10 { "%SystemRoot%\??????*.exe" or "%system%\??????*.exe" } AND { -s=163840 or -s=167936 or -s=172032 or -s=176128 or -s=180224 or -s=192512 } >>d-del_A.dat &&(
	PEV -fs32 -rtf -t!o -s-192513 -d:G1 { "%SystemRoot%\??????*.exe" or "%system%\??????*.exe" } -output:temp2904
	FINDSTR -MF:temp2904 FlushInstructionCache | FINDSTR -MF:/ wsprintfA
	)>>d-del_A.dat 2>N_\%random%

DEL /A/F/Q temp290? >N_\%random% 2>&1
IF EXIST DoStepDel IF EXIST d-del_A.dat GREP -ivq "::::" d-del_A.dat &&( Call :PreRunDel )|| DEL /A/F d-del_A.dat


:STAGE30
PEV -k NIRKMD.%cfext%
PEV -fs32 -loadlineVikPev00 >Vikpev01
START NIRKMD CMDWAIT 22000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%31 >WowErr.dat
@Echo:%Stage%31

:: Goldun Files
@FOR /F "TOKENS=*" %%G IN ( Goldun.dat ) DO @(
	IF EXIST %%G ECHO.%%G>>catch_k.dat
	IF NOT EXIST %%G (
		IF NOT EXIST "%%~DPG" (
			MD "%%~DPG"
			ECHO.> "FolderCreated_%%~NXG"
			)
		TYPE myNul.dat >"%%~G"
		IF NOT EXIST "%%~G" ECHO.%%G>>catch_k.dat
		IF EXIST "%%~G" DEL /A/F "%%~G" || ECHO.%%G>>catch_k.dat
		IF EXIST "FolderCreated_%%~NXG" (
			RD /S/Q "%%~DPG"
			DEL "FolderCreated_%%~NXG"
			)) )>N_\%random% 2>&1


@FOR %%G IN (
	"%SystemRoot%\spooldr.exe"
	"%system%\spooldr.sys"
) DO @IF EXIST %%G ( ECHO.%%G>>catch_kB.dat
	) ELSE @(
		TYPE myNul.dat >"%SystemDrive%\Qoobox\Test\%%~NXG"
		IF EXIST "%SystemDrive%\Qoobox\Test\%%~NXG" ( DEL /A/F "%SystemDrive%\Qoobox\Test\%%~NXG" ) ELSE ECHO.%%G>>catch_kB.dat
		)2>N_\%random%


START NIRKMD CMDWAIT 3000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
IF EXIST catch_kB.dat TYPE myNul.dat >fBoot.dat

IF EXIST catch_k.dat FINDSTR -I ntndis catch_k.dat >N_\%random% &&ECHO.%system%\drivers\ntndis.exe>>d-del2AA.dat
PEV -k NIRKMD.%cfext%

IF EXIST catch_k.dat GREP -Fiq "%system%\drivers\reveal32.sys" catch_k.dat &&(
	ECHO.@SWREG QUERY "hkcr\clsid\{a3bc5e20-0235-1abf-9ce1-00aa00512037}\inprocserver32" /ve ^>temp3000
	ECHO.@SED "/.*	/!d; s///" temp3000 ^>^>"%~DP0d-del2A.dat"
	ECHO.@DEL /A/F temp3000
	)>>auxx.bat


PEV -fs32 -rtf -t!o { %system%\* or %SystemRoot%\* or %system%\drivers\* } AND { *.exe or *.dll or *.scr } NOT *[A-Z]*.??? >>d-del_A.dat

@DEL /A/F/Q temp300? Goldun.dat N_\* >N_\%random% 2>&1


IF NOT EXIST W6432.dat IF EXIST katch00 (
	SED "/ 25088 bytes .*/!d;s///" katch00 >katch01
	FOR /F "TOKENS=*" %%G IN ( katch01 ) DO @(
		Catchme -l N_\%random% -c "%%G" "%SystemDrive%\Qoobox\Test\_%%~NXG_.vir"
		FINDSTR -MI "r.a.w.v.f.i.l.e.\..d.l.l" "%SystemDrive%\Qoobox\Test\_%%~NXG_.vir" &&(
			ECHO.%%G>>catch_k.dat
			FINDSTR -IL "%%~G" svclist.dat >katch02
			SED -r "s/;.*//; s/.*	//" katch02 | MTEE /+ SvcTargeted >>zhSvc.dat
			DEL /A/F katch02
			)
		DEL /A/F "%SystemDrive%\Qoobox\Test\_%%~NXG_.vir"
		)
	DEL /A/F/Q katch0? N_\*
	)>N_\%random% 2>&1



:STAGE31
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 60000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%32 >WowErr.dat
@Echo:%Stage%32

@(
ECHO.CREW\.DLL.DllCanUnloadNow.DllGetClassObject
ECHO.MZKERNEL32\.DLL
ECHO.BlankVm\.dll
ECHO.\\Start\.pdb
ECHO.=L\\l{'7FVeu
ECHO.@P_o~\*:IYix$3CSbr
ECHO.Cr=l7e0
ECHO.RegValueUpdater.dll
ECHO.botnet.Jack
REM ECHO.\..a.f.t.e.r.B.e.g.i.n
ECHO.N.o.t.i.f.i.c.a.t.i.o.n...P.a.c.k.a.g.e.s.*A.p.p.I.n.i.t._.D.L.L.s
ECHO././.8.5.\..1.2.\..4.3.\..7.4./.
ECHO.harvest512\.dll.DllCanUnloadNow
ECHO.Widget\.dll.DllCanUnloadNow
ECHO.e.x.e.c.u.t.i.b.l.e
ECHO.85\.12\.43\.75.\/go\/?eventid
ECHO.AVCBannerRotator
REM ECHO.G.r.e.e.k. .I.B.M. .3.1.9. .K.e.y.b.o.a.r.d. .L.a.y.o.u.t
ECHO.LoadIconA.USER32\.dll....SelectClipPath....Arc.GDI32\.dll...PrintDlgExA.comdlg32.dll....RegQueryValueExW..ADVAPI32\.dll
REM ECHO.ExitProcess.S.CreateFileA...GetSystemInfo...............].GetSystemMetrics....SystemParametersInfoA
REM ECHO.c.h.e.c.k.e.r.s...d.l.l.....2.....P.r.o.d.u.c.t.N.a.m.e.....Z.o.n.e...c.o.m
ECHO.CheckSave.CheckStack.OpenSave.ShellPath.Unreal
ECHO.ViPaLo.dll
ECHO.GetFnPath.s
ECHO.AddAtomA.AddRefActCtx
ECHO.AddRefActCtx.AllocConsole
ECHO.j.g.a.w.4.0.0.\..d.l.l
REM ECHO.a7t2......#.D1\\...0..a4uwP
ECHO.S.t.a.t.s.R.e.a.d.e.r...E.X.E
ECHO.M.P.E.G. .S.e.t.t.i.n.g.s...C.h.e.c.k.e.r.....6
ECHO.BannerModifier_dummy
ECHO.iTrackerCore.dll
ECHO.tvmeinv
ECHO.SetProcessShutdownParameters.*VkKeyScanExW
ECHO.\\.i.n.s.t.s.p.2.\..e.x.e
ECHO.Q.t.G.u.i.V.B.o.x.4.\..d.l.l
ECHO.pkbw.dll.CoRegCleanup
REM ECHO.O.r.i.g.i.n.a.l.F.i.l.e.n.a.m.e...S.t.d.M.F.C.3.2...d.l.l
ECHO.lsp.dll.NSPStartup
ECHO.svchost\.exe.-k.krnlsrvc
ECHO.svchost\.exe.-k..krnlsrvc
ECHO.SysNotifier\.exe
ECHO.InOleObj\.DLL
REM ECHO.O.r.i.g.i.n.a.l.F.i.l.e.n.a.m.e...d.o.t.n.e.t.i.n.s.t.a.l.l.e.r...e.x.e
REM ECHO.O.r.i.g.i.n.a.l.F.i.l.e.n.a.m.e...I.C.Q.R.u.n...e.x.e
ECHO.Bender.DllMain
ECHO.vl;popurl.o..c.OWNLOAD.abe
ECHO.CreateCaretMEUED
ECHO.rundll32\.exe.%%s,s
ECHO.adpluseReinstallEvent1_1.
ECHO.UpdateNewBot\\Sink.pas
ECHO.dfc8ac3ed7da\.COMResModuleInstance
ECHO.s.v.c.h.o.s.t.\..e.x.e...-.k.....%%.s
ECHO.microsoft_lock
ECHO.a.u.r.a.-.s.e.a.r.c.h...n.e.t
ECHO.\\killkb.pdb
ECHO.bensorty\.dll
ECHO.autorun.inf.rar.exe.f0016
REM ECHO.c=%%s^&h=%%d^&v=%%s^&ep=%%s^&db=%%d.2009062907
ECHO.\\\\.\\KILLPS_Drv
ECHO.\\.?.?.\\.K.L.a.n.S.y.m.b.o.l.s
REM ECHO.B.q.......0....e.Q^<.=J.........i...g......?...hQ.........i0...c.A....X.O18....\\.e.i.0....^^.6K..V/..jT6
ECHO.Image.File.Execution.Options\\..svchost\.exe
ECHO.C.:f....6V.xhuW5WBE....oB
ECHO.n1M..EL2.?.o.3.~\[DC.....g...k....Dm1........btIOU^)^^^(i....P.....7RA..%%c..}S..\*\[,.l.U...\/...5VpwwfV5gD
REM ECHO.9E.3.hsyo.ll............u.D1.....x.?\[l..7I^&.....g......_...J.oohf6.V..nM..y_@......`BzD.hcEU,cn....4.p.nj
ECHO.SratMain.dll.DoMainService.MainService.MainWork.ServiceMain
ECHO.start= disabled....taskkill.exe./im....cmd./c.sc.delete
ECHO.77.74.48.101
ECHO.gudmun.com
ECHO.85.12.43.91
ECHO.77.74.48.104
ECHO.K:\\Programming\\Final\\TirgBot\\Sink.pas
REM ECHO.R.%%....+^>...qcF...I.....4w...F.....f/..;..2.,.j.rSa....}..dW.85ndGT..}..cCBsS..^>O.fZBg....r.Lf.....Iv
ECHO.COMCTL32.dll.6.ImageList_Copy.].InitCommonControlsEx.WINMM.dll
REM ECHO.47.j....GDI32\.dll.T....'?S...a.isH...2..1D.^&4.$^|comdlg32\.dll....Q..g..~.Wn.....M........$.Z^&!...............P..2!..........3
ECHO.pkm\.dll.DllCanUnloadNow
ECHO.mmioSetInfo.kERNEL32.dll
ECHO.mmioStringToFOURCCA.kERNEL32.dll
ECHO.KHPWRRMRNWONUPPNLNLQXLOWIIKO
ECHO.CookieTerminator\.dll
REM ECHO.NB10....@.cF....T:\\o\\i386\\d.pdb
ECHO.222\.dll.DllCanUnloadNow.DllGetClassObject.a.s
ECHO.ressigname..SYSTEM\\CurrentControlSet\\Control\\Session Manager....PendingFileRenameOperations
ECHO.Session Manager....PendingFileRenameOperations.....ressigname
ECHO.wINMM\.dll...mmioSeek...mmioRead...mmioStringToFOURCCW
ECHO.wINMM\.dll...mmioSeek...mmioWrite...mmioRead...mmioStringToFOURCCW
ECHO.wINMM\.dll...mmioFlush...mmioRead...mmioSeek...mmioSetInfo
ECHO.wINMM\.dll...mmioStringToFOURCCW
ECHO.wINMM\.dll...timeKillEvent...mmioRead...mmioAdvance
ECHO.wINMM\.dll...mmioCreateChunk...mmioSeek...mmioRead
ECHO.DNSChangerWin.dll
ECHO.222.dll.a.s.DllCanUnloadNow
ECHO.NetFilter.dll.DllMain.DllRegisterServer.DllUnregisterServer.WSPStartup
REM ECHO.O.r.i.g.i.n.a.l.F.i.l.e.n.a.m.e...3.c.s.h.t.d.w.n.\..e.x.e
ECHO.C:\\ca\.txt
ECHO.funds.opened.mentioned
ECHO.ones.loved.unique
ECHO.svchost\.dll
ECHO.Release\\adshot\.pdb
ECHO.VariantInit.dsound\.dll....DirectSoundCreate
ECHO.2....DownModule\.dll.Execute
ECHO.\$U....ExecuteModule\.dll.Execute
ECHO.SYSTEM\\ControlSet001\\Services\\
ECHO.\\curlib.dll
ECHO.M.y.T.e.s.t.3.\..D.L.L
ECHO.SOFTWARE\\Softfy\\.
ECHO.\\Programming\\Trojan\\.
ECHO.QMDispatch\.DLL
ECHO.LspClicker\.dll
ECHO.adprssoClient\.DLL
ECHO.client.dll\.CreateProcessNotify\.DllEntryPoint
ECHO.:.\\.U.s.e.r.s.\\.X.i.n.f.i.l.t.r.a.t.e.\\.D.o.c.u.m.e.n.t.s.\\.
ECHO.\\Programming\\Trojan\\.
ECHO.djeClnt\.DLL
ECHO.Mystic.Compressor
ECHO.micros..oft_lock
ECHO.final\.dll.DllMain.WSPStartup
ECHO.\\.I.E.A.d.B.l.o.c.k.e.r.\..v.b.p
ECHO.WZS.dll.ServiceMain
ECHO.HlMain.dll.ServiceMain
ECHO.client.dll.CreateProcessNotify.DllGetVersion
ECHO.m.y.s.m.a.l.l.b.l.o.g.\..n.e.t
ECHO.dll\\Release\\LinkSave2\.pdb
ECHO..http://adsrv24.com/
ECHO.Downloader\.dll.ServiceMain
ECHO.DllGetClassObject.DllPost32\.DllRegisterServer
ECHO.usermode-rootkit\.pdb

)>v_str.dat


@(
ECHO.CloseDriver.,.joyReleaseCapture.............ExitProcess.S.CreateFileA.................SystemParametersInfoA
ECHO.CloseDriver...........-.PathFileExistsA.............V.CreateFileW...ExitProcess.................PrintDlgExW
ECHO.CloseDriver...........e.PathQuoteSpacesA..;.PathGetCharTypeA..3.PathFindNextComponentA..............V.CreateFileW...ExitPro
ECHO.mmioClose...CloseDriver...........V.CreateFileW...ExitProcess.................PrintDlgExW
ECHO.CloseDriver.^).joyGetPos.............ExitProcess.S.CreateFileA.................SystemParametersInfoA...............ArcTo...Arc
ECHO.CloseDriver...mmioWrite...........V.CreateFileW...ExitProcess...............'.CreateBitmap..............PrintDlgExW
ECHO.CloseDriver.-.joySetCapture.............ExitProcess.S.CreateFileA.................SystemParametersInfoA.............'.CreateB
ECHO.CloseDriver.............ExitProcess.S.CreateFileA.................SystemParametersInfoA...............ArcTo...Arc
ECHO.+.={...]M...M-UDaPT....9.l.O^^.^&...6.sF #.....i...d.=a........d..ZK8.......vi
ECHO.6q........ExitProcess.S.CreateFileA...............].GetSystemMetrics....SystemParametersInfoA...............ArcTo...Arc
)>v_str00.dat


PEV -fs32 -rtf -t!o -s=209526 -d:G90 %system%\*.exe >temp3100 && FINDSTR -MF:temp3100 VMToolTip\.dll >>d-del_A.dat 2>>Locked
PEV -fs32 -rtf -t!o -s=2580 -d:G90 "%system%\????????.exe" >temp3100 && FINDSTR -MF:temp3100 "AllowCookie\.pdb >>d-del_A.dat 2>N_\31_%random%

PEV -fs32 -rtf -t!o -d:G90 %system%\????????.exe AND { -s=2048 or -s=2112 or -s=2356 or -s=2560 or -s=2624 } -output:temp3100 &&(
	FINDSTR -MLF:temp3100 "wininet.dll AppInit_DLLs" )>>d-del_A.dat 2>N_\31_%random%

PEV -fs32 -rtf -t!o -s-4673 -d:G90 "%system%\????????.exe" -output:temp3100
PEV -fs32 -rtf -t!o -s+29000 -s-400000 -d:G90 { "%system%\?????.exe" or "%SystemRoot%\?????.exe" } >>temp3100
FINDSTR -MF:temp3100 "65.243.103.62 Release\\Start\.pdb A.l.e.x.a...T.o.o.l" >>d-del_A.dat 2>N_\31_%random%

PEV -fs32 -lrtf -s+47000 -s-121000 -d:G90 { "%system%\?????.exe" or "%SystemRoot%\?????.exe" } -output:temp3100
SED -r "/\\/!d; /47,[89]|49,2|58,[78]|105,[2-5]|120,9/!d; s/.{47}//" temp3100 >temp3101
FINDSTR -MLF:temp3101 .RLPack >>d-del_A.dat 2>N_\31_%random%
DEL /A/F/Q temp310?  >N_\31_%random% 2>&1

FOR /F "TOKENS=*" %%G IN ( Vundonames.dat ) DO @IF EXIST "%%~G" IF NOT EXIST "%%~G\" ECHO.%%~G>>d-del_A.dat
DEL /A/Q Vundonames.dat
IF EXIST %system%\drivers\dp.sys ECHO.%system%\drivers\dp.sys>>d-del_A.dat



SWREG QUERY "hklm\software\microsoft\windows\currentversion\explorer\browser helper objects" >BHOQuery.dat
SED "/{/!d; s/.*{/{/ " BHOQuery.dat >temp3101
FINDSTR -VILG:clsid.dat temp3101 >temp3102
FOR /F "TOKENS=*" %%G IN ( temp3102 ) DO @(
	SWREG QUERY "hkcr\clsid\%%G\inprocserver32" /ve >temp3103
	SED "/.*	/!d; s//%%G /" temp3103 >>BHO.dat
	DEL /A/F temp3103
	)>N_\31_%random% 2>&1
DEL /A/F/Q temp310? N_\* >N_\31_%random% 2>&1
TYPE myNul.dat >>BHO.dat


SED "s/.*	//" BHO.dat > BHOFiles00.dat
ECHO.::::>>BHOFiles00.dat
PEV -fs32 -t!o -filesBHOFiles00.dat -c##5#b#u#b#f#b1:#d#b8:#i#b7:#k#b3:#g#b4:#o#b5:#j#b6:#l#b2:#e#b0:#q# -output:BHOFiles.dat
:: PEV -fs32 -t!o -filesBHOFiles00.dat -c##5#b#u#b#f#bc:#d#bp:#i#bn:#k#bv:#g# -output:BHOFiles.dat
DEL BHOFiles00.dat >N_\31_%random% 2>&1


(
PEV -rtf -t!o -s-1000000 -dcG40 "%system%\*" -preg"\.(dll|dll\.tmp|dll\.vir)$"
PEV -rtf -t!o -s-1000000 -dcG40 "%SystemRoot%\*" -preg"\.(dll|dll\.tmp|dll\.vir)$"
PEV -rtf -t!o -s-1000000 "%system%\*.dll" AND { -d:G30 or -d:-1990 }
PEV -rtf -t!o -ts -th -s-1000000 -d:G182 "%system%\*" -preg"\.(dll|dll\.tmp)$"
PEV -rtf -t!o -ts -th -s-1000000 -d:G182 "%SystemRoot%\*" -preg"\.(dll|dll\.tmp)$"
PEV -rtf -t!o -s-1000000 -d+2008 -t!j "%SystemRoot%\*" -preg"\.(dll|dll\.tmp|dll\.vir)$"
PEV -rtf -t!o -s-1000000 -d+2008 -tj "%SystemRoot%\???????*.dll" and not ?????????*.
PEV -tx50000 -tf -t!o -ts -th -s-1000000 -d:G90 "%ProgFiles%\*.dll"
)>temp3100 2>N_\31_%random%

PEV -fs32 -c##k#b#f# -rtf -t!o -dg24M -s-1000000 { %system%\*.dll or %SystemRoot%\*.dll } and not "%system%\hal.dll" -output:WrgNameDLL00
SED -r "s/\x00//g; /^(.*\....)	.*\\\1$/Id; /^(.*[^.]...)	.*\\\1\....$/Id; s/.*	//"  WrgNameDLL00 >WrgNameDLL
DEL /A/F WrgNameDLL00 >N_\31_%random% 2>&1
TYPE WrgNameDLL >>temp3100

FINDSTR -VILXG:v_wht.dat temp3100 >temp3101

(
PV -m winlogon.exe
PV -m lsass.exe
PV -m explorer.exe
PV -m csrss.exe
)>temp3102 2>N_\31_%random%

TYPE v_wht.dat >>vRun_DLL
GREP -Fivf vRun_DLL temp3102 >temp3103
SED -r "/.*(%system:\=\\%\\[^\\]*\.dll)/I!d; s//\1/" temp3103 >temp3104
SED -r "/.*(.:\\.*)/!d; s//\1/" BHO.dat >>temp3104

SWREG QUERY "hkcu\software\microsoft\windows\currentversion\run" >RegRun
:: zbots
SED -r "/^ +\{.{36}\}	.*(%Appdata:\=\\%\\[^\\]{4,6}\\[^\\]{4,6}\.exe).*/I!d; s//\1/" RegRun >>d-del_A.dat
:: generic
SED -r "/^ +(\S*)	.*	\x22*(%ProgFiles:\=\\%\\\1 Software)\\\1\\\1\.exe\x22* *-min/I!d; s//\2/" RegRun >RogueFolder
FOR /F "TOKENS=*" %%G IN ( RogueFolder ) DO @PEV -rtd -dcG30 "%%~G" >>CFolders.dat

SWREG QUERY "hklm\software\microsoft\windows\currentversion\run" >>RegRun
SWREG QUERY "hku\.default\software\microsoft\windows\currentversion\run" >>RegRun
SED -r "/.{600}/d; /.*	Rundll32[^\x22]*\x22(.:\\[^\x22]*\.dll|.{6,8}\.dll)\x22.*$/I!d;s//\1/; s/^.[^:]/%system:\=\\%\\&/;" RegRun | MTEE RegRun01 >>temp3104
SED -r "/.{600}/d; /.*	Rundll32[^\x22]*\x22(.:\\[^\x22]*\.dll|.{6,8}\.dll)\x22,(.|DllRegisterServer)$/I!d;s//\1/; s/^.[^:]/%system:\=\\%\\&/;" RegRun >CLSIDFiles01
PV -m explorer.exe winlogon.exe lsass.exe svchost.exe smss.exe csrss.exe services.exe >temp3105 2>N_\31_%random%
SED -R "/^ |((10|4)00000|[4-9]\S{7})\s*\d* .:\\/d; s/.*(.:\\)/\1/; /%system:\=\\%\\(xpsp2res|Normaliz|urlmon|odbcint)\.dll/Id;" temp3105 >>temp3104
ECHO.::::>>temp3104
PEV -fs32  -tx50000 -tf -t!o -files:temp3104 -s-1000000 >>temp3101
SORT /M 65536 temp3101 /T %cd% /O temp3106
SED -r "$!N; /^(.*)\n\1$/I!P; D" temp3106 >VList


ECHO.::::>>RegRun01
PEV -fs32 -filesRegRun01 -tx50000 -tf -t!o -tp and { -t!k or -t!g } >>d-del_A.dat
PEV -fs32 -filesRegRun01 -tx50000 -tf -t!o -tp -t!g -t!j  >>d-del_A.dat
DEL /A/F/Q RegRun RogueFolder temp310? N_\* >N_\31_%random% 2>&1


IF EXIST Vista.krl (
	IF DEFINED temp DEL /A/F/Q "%temp%\*"
	IF DEFINED temp PEV -fs32 -rtf -s-1000000 -d:G6M "%temp%\*.dll" and not catchme.dll >>VList
	IF EXIST "%CommonAppData%\Temp\*" DEL /A/F/Q "%CommonAppData%\Temp\*"
	PEV -fs32 -rtf -s-1000000 -d:G6M "%CommonAppData%\Temp\*.dll" and not catchme.dll >>VList
	DEL /A/F/Q temp310?
	)>N_\31_%random% 2>&1



FINDSTR -MRG:v_str.dat /F:VList >>d-del_A.dat 2>>Locked
IF EXIST progfile.dat SED -r "/^.*	299...	(.:\\[^	]*\.dll)	.*/I!d; s//\1/" progfile.dat >prog3100
FINDSTR -MRG:v_str.dat /F:prog3100 >>d-del_A.dat 2>>Locked
DEL /A/F prog3100

FINDSTR -MRF:VList "(8@8G8O8T8X8\\8.*82989<9@9D9.*:+:]:d:h:l:p:t:x:" >temp3100 2>N_\31_%random%
FINDSTR -MRF:temp3100 "GetDesktopWindow.*GetDC.USER32.dll.*LineTo..GDI32.dll" >>d-del_A.dat

FINDSTR -MRF:Vlist "XPTPSW"  >temp3100 2>N_\31_%random%
FINDSTR -MRF:temp3100 "A.d.o.b.e...S.y.s.t.e.m.s...I.n.c.o.r.p.o.r.a.t.e.d S.i.m.p.l.e...S.o.f.t.w.a.r.e L.e.x.t.e.k...I.n.t.e.r.n.a.t.i.o.n.a.l" >>d-del_A.dat


ECHO.::::>>d-del_A.dat
GREP -Fivxf d-del_A.dat VList >VList00
MOVE /Y VList00 VList >N_\31_%random% 2>&1
ECHO.::::>VList01
TYPE VList >>VList01
PEV -fs32 -tx50000 -tf -files:VList01 -c##h#b#u#b#f#b#y#b#z#b1:#d#b8:#i#b7:#k#b3:#g# -output:VList02
SED -r "/^2012-07-16 ..:..:..	.....	([^	]*)	0x.{8}	.{10}	1:-{6}	8:-{6}	7:-{6}	3:-{6}/!d; s//\1/" VList02 >>d-del_A.dat
SED -r "/^2008-05-0[89] ..:..:..	.....	([^	]*)	0x00000000	.{10}	1:-{6}	8:-{6}	7:-{6}	3:-{6}/!d; s//\1/" VList02 >Vlist03
FINDSTR -MF:VList03 -G:v_str00.dat >>d-del_A.dat 2>N_\31_%random%
DEL /A/F/Q VList0? v_str00.dat >N_\31_%random% 2>&1



IF NOT EXIST vista.krl (
	PEV -fs32 -tx50000 -tf %SystemRoot%\ntp2.ini -output:temp3100
	TYPE temp3100 >>d-del_A.dat
	GREP -Fiv "%system%" temp3100 >temp3101
	FOR /F "TOKENS=*" %%G IN ( temp3101 ) DO @(
		PEV -fs32 -rtf -t!o -th -d:G90 "%%~DPG*.dll" -output:temp3102
		FINDSTR -MRG:v_str.dat /F:temp3102 >>d-del_A.dat 2>>Locked
		DEL /A/F temp3102
		)
	DEL /A/F/Q temp310? N_\*
	)>N_\31_%random% 2>&1


PEV -s=266240 -dg90 -tpmz -t!o "%SystemRoot%\*.dll" -skip"%SystemRoot%\Winsxs" | FINDSTR -MRG:v_str.dat /f:/ >>d-del_A.dat 2>>Locked

SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify" /s >temp3100
SED -r "/dllname	.*:\\*.*\.tmp(\x0a|\x0d|$)/I!d; s/   dllname	.*	//I" temp3100 >temp3101
FOR /F "TOKENS=*" %%G IN ( temp3101 ) DO @IF EXIST "%%~G" ECHO.%%~G>>d-del_A.dat
DEL /A/F/Q temp310?  >N_\31_%random% 2>&1


IF EXIST Locked CALL :Locked >N_\31_%random% 2>&1
FOR /F "TOKENS=*" %%G IN ( LockedB ) DO @(
	FINDSTR -MRG:v_str.dat "%%~DPG_%%~NG_%%~XG.vir" &&ECHO.%%~G>>d-del_A.dat
	DEL /A/F "%%~DPG_%%~NG_%%~XG.vir"
	)>N_\31_%random% 2>&1
DEL /A/F LockedB >N_\31_%random% 2>&1


IF EXIST suspect_ntfy.dat FINDSTR -XIR win...32 suspect_ntfy.dat >temp3100 2>N_\31_%random%
IF EXIST temp3100 FOR /F "TOKENS=*" %%G IN ( temp3100 ) DO @(
	SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%%G" /v startup >temp3101
	GREP -Fsq EvtStartup temp3101 &&(
		SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%%G" /v DLLName >temp3102
		SED "/.*	/!d; s///" temp3102 >temp3103
		FOR /F "TOKENS=*" %%H IN ( temp3103 ) DO @FINDSTR -MR "PECompact2 PEC2" "%system%\%%~NXH" >>d-del_A.dat 2>N_\31_%random% &&(
				ECHO.[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%%G]>>CregC.dat
				) )
	DEL /A/F temp3101 temp3102 temp3103 >N_\31_%random% 2>&1
	)


:STAGE32
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 60000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%32A >WowErr.dat
@Echo:%Stage%32A


IF EXIST d-del_A.dat GREP -Fsq :\ d-del_A.dat &&(GREP -Fivf d-del_A.dat VList >VListB)|| Type VList >VListB
SED "/./!d" VlistB| SED -r ":a;$!N; s/\n/\x22 \x22/;ta; s/.*/\x22&\x22/;s/(.{3500}[^\x22]*\x22) /\1\n/g" >temp3100
FOR /F "TOKENS=*" %%G IN ( temp3100 ) DO @(
	GSAR -c42 -sPhp %%G | SED "/: .*PhpC..è....è....3À@‰Eä$/!d; s///" >>d-del_A.dat
	GSAR -b -sPhpC:x02:x10 %%G | SED -r "/: 0x11...$/I!d;s///" >>d-del_A.dat
	GSAR -x64 -s:x00:x00:x00:x8A:x06:x88:x01:x83:xC1:x01 %%G | SED -r "/: $/{:a; $!N; s/\n0x\S*:(.{48}).*/\1/;ta; s/(\S\S) /\1/g; }" |(
		GREP -Ei "c74424(0c|10)01000000(9090909090|)e9(1[af]|2[49])0000008a06880183c101(9090909090|)83c601(9090909090|)897424(20|18|24)(9090909090|)C74424(10|0c)00000000(9090909090|)894c24(24|1c)(9090909090|)837c24" | SED "s/: .*//" )>>d-del_A.dat
	GREP -Elsqf Vun.dat %%G >>d-del_A.dat
	)>N_\31_%random% 2>&1


IF EXIST d-del_A.dat GREP -Fsq :\ d-del_A.dat &&(GREP -Fivf d-del_A.dat VListB >VList)|| Type VListB >VList
REM FOR /F "TOKENS=*" %%G IN ( Vlist ) DO @(
REM 	TAIL -1 "%%~G" | GSAR -F -s:x1a -r:030 >temp3101
REM 	SED -r "/[0-9A-F]{44}11D[CD][0-9A-F]{12}FFFF$|\x00{1440}[^\x00]{75,90}$|[24]\x00$|[0-9A-F]{12}11D[CD][0-9A-F]{11}FFFFF[0-9A-F]{32}error|\x00{64}\x10\x04\x00\x10\x11\x01\x00{3}/!d" temp3101 >temp3102
REM 	GREP -sq . temp3102 &&ECHO."%%~G">>d-del_A.dat
REM 	DEL /A/F/Q temp310?
REM 	)>N_\31_%random% 2>&1


IF EXIST d-del_A.dat GREP -Fsq :\ d-del_A.dat &&(GREP -Fivf d-del_A.dat VList >VListB)|| Type VList >VListB
GREP -Eiv "%system:\=\\%\\(bcmwlrmt|mpg4c32|mfc45|hp[^\\]*)\.dll$|\\Avira\\AntiVir Desktop\\avsda.dll$" VListB >VList
ECHO.::::>>VList
PEV -fs32 -files:VList -t!k -tx50000 -tf -tp -t!o -c##f#b1:#d#b8:#i#b7:#k# | SED -r "/	(1:(|------)	8:\2	7:\2|.*	7:(halacpi.dll|AutoIt.exe))/!d; s///" >>d-del_A.dat
DEL /A/F/Q N_\* temp310?  VList* >N_\31_%random% 2>&1


@IF NOT EXIST PathSearch ECHO."%PATH%";| SED "s/\x22//g; s/\(\\\|\);/\\*\n/g" | SED "/.:\\./!d;"| SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/" >PathSearch
CALL :Vun_LSA  >N_\31_%random% 2>&1
DEL /A/F/Q VunLSA0? >N_\31_%random% 2>&1


PEV -tx50000 -tf "%SystemRoot%\*" -preg"\.(tmp|bak|ini)[12]$" -skip"%systemroot%\winsxs" -output:v-tmp0.dat
SORT /M 65536 v-tmp0.dat /T %cd% /O temp3100
SED -r "$!N; /^(.*)\n\1$/I!P; D" temp3100 >v-tmp.dat
DEL /A/F temp3100 v-tmp0.dat >N_\31_%random% 2>&1

FOR /F "TOKENS=*" %%G IN ( v-tmp.dat ) DO @(
	PEV -fs32 -rtf -t!o %%~DPNG.* -output:temp3100
	FINDSTR -IR "\.bak1$ \.bak2$ \.ini$ \.ini2$ \.tmp$ \.tmp2$" temp3100 >>d-del_A.dat
	DEL /A/F temp3100 >N_\31_%random% 2>&1
	)

GREP -sql "^­âpRÓ" %SystemRoot%\*.ini %system%\*.ini >>d-del_A.dat

IF EXIST suspect_ntfy.dat FOR /F "TOKENS=*" %%G IN ( suspect_ntfy.dat ) DO @(
	SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%%G" /v dllname >temp3100
	SED "/.*	/!d; s///" temp3100 >temp3101
	FOR /F "TOKENS=*" %%H IN ( temp3101 ) DO @FINDSTR -I "%%~NXH" d-del_A.dat >N_\31_%random% &&ECHO.[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%%G]>>CregC.dat
	DEL /A/F/Q temp310? >N_\31_%random% 2>&1
	)


FINDSTR -ILG:d-del_A.dat BHO.dat 2>N_\31_%random% | SED "s/}\s.*/}/" >delclsid00
CALL delclsid.bat >N_\31_%random% 2>&1


:STAGE32A
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 13000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%33 >WowErr.dat
@Echo:%Stage%33

SWREG QUERY "HKLM\software\microsoft\shared tools\msconfig\startupreg" /s >temp3200
SED -r -e "/^ +command	.*	/I!d;s///" -f run.sed -e "/\.exe$/I!d" temp3200 >temp3201
GREP -F :\ temp3201 >OriO4
GREP -Fv :\ temp3201 >temp3202
FOR /F "TOKENS=*" %%G IN ( temp3202 ) DO @ECHO."%%~F$PATH:G">>OriO4

SWREG QUERY "hklm\software\microsoft\windows\currentversion\run" >temp3203
SWREG QUERY "hkcu\software\microsoft\windows\currentversion\run" >>temp3203

FOR /F "TOKENS=*" %%G IN ( Startup.folder.dat ) DO @(
	PEV -rtf "%%~G\*.lnk" >>lnkfiles00
	PEV -rtpmz "%%~G\*.exe" >>temp3203
	)
IF EXIST lnkfiles00 FOR /F "TOKENS=*" %%G IN ( lnkfiles00 ) DO @PEV LINKRESOLVE "%%~G" >>lnkfiles01
IF EXIST lnkfiles01 (
	SED -r "/:\\Qoobox\\Quarantine\\/Id; s@ */.*@@; s@(\.exe) .*@\1@;" lnkfiles01 > lnkfiles02
	PEV -fs32 -files:lnkfiles02 -tpmz -rtf -t!o > lnkfiles03
	TYPE lnkfiles03 >>temp3203
	REM GREP -Ei "\\[^\\ ]{26,}\\[^\\]{1,}\.exe$" lnkfiles03 >>d-del_A.dat
	)
DEL /A/F/Q lnkfiles0? >N_\%random% 2>&1

SED -r "/:.*\.exe/I!d; /\.exe.*\.dll/Id; s/.*	//g; s/\x3b //g; s/\x22//g; s/\.exe .*/\.exe/I" temp3203 >>OriO4
ECHO.::::>> OriO4
PEV -fs32 -filesOriO4 -tpmz -rtf -t!o -tp -t!g { -t!k or -t!j } -c##d#k#b#f# | SED -r "/------	|^	|		|	 +	/!d; s/.*	//" >>d-del_A.dat

SWREG QUERY "hklm\software\microsoft\windows\currentversion\runonce" >>temp3203
SWREG QUERY "hklm\software\microsoft\windows\currentversion\RunServices" >>temp3203
SWREG QUERY "hkcu\software\microsoft\windows\currentversion\runonce" >>temp3203
SWREG QUERY "hkcu\software\microsoft\windows\currentversion\RunServices" >>temp3203
SWREG QUERY "hku\.default\software\microsoft\windows\currentversion\runonce" >>temp3203
SED -r "/:.*\.exe/I!d; /\.exe.*\.dll/Id; s/.*	//g; s/\x3b //g; s/\x22//g; s/\.exe .*/\.exe/I" temp3203 >>temp3204
:: id files with multiple load pts e.g. bots
SORT /M 65536 temp3204 | SED -r "/%ProgFiles:\=\\%\\/Id; $!N; s/^(.*)\n\1$/\1/; t; D" | SED -r "$!N; /^(.*)\n\1$/I!P; D" >temp3205
ECHO.::::>>temp3205
PEV -fs32 -rtf -t!o -t!g -filestemp3205 >>d-del_A.dat
DEL /A/F/Q temp320? >N_\%random% 2>&1


SORT /M 65536 OriO4 | SED -r "$!N; /^(.*)\n\1$/I!P; D" >OriO4b
ECHO.::::>> OriO4b
PEV -fs32 -t!o -t!g -tx15000 -filesOriO4b -c##5#b#u#b#f#b1:#d#b8:#i#b7:#k#b3:#g#b4:#o#b5:#j#b6:#l#b2:#e#b0:#q# -output:OriO4Files.dat
GSAR -o -s:x1a -r:x3F OriO4Files.dat >N_\%random% 2>&1
SED -r ":a; $!N;s/\n[A-F0-9]{32}\t/&/; tb; s/\n/?/; ta :b; P;D" OriO4Files.dat >OriO4Files_temp
MOVE /Y OriO4Files_temp OriO4Files.dat >N_\%random% 2>&1

SORT /M 65536 OriO4Files.dat | SED -r "/1((:-{6})	)8\17\13\14\15\16\12\10\2$/!d; $!N; s/^([^\t]*)	.*\n\1	.*$/\1/; t; D;" >DHash
:: PEV -fs32 -t!o -filesOriO4b -c##5#b#u#b#f#bc:#d#bp:#i#bn:#k#bv:#g# -output:OriO4Files.dat
:: SORT /M 65536 OriO4Files.dat | SED -r "/c:------	p:------	n:------	v:------/!d; $!N; s/^([^\t]*)	.*\n\1	.*$/\1/; t; D" >DHash
GREP -sq . DHash &&(
	FINDSTR -BIG:DHASH OriO4Files.dat | SED -r "/.*(.:\\[^	]*)	.*/!d; s//\1/" >RenVSuspect
	TYPE DHash >>srizbi.MD5
	)
DEL /A/F DHash


PEV -tx15000 -fs32 -t!o -filesOriO4b -c##h#b#d#i#k#g#e#j#b#f# -output:OriO4FilesB.dat
SORT /M 65536 OriO4FilesB.dat /O temp3200
ECHO.>>temp3200
SED -n -r "/	-{18}|		/d; :a; $!N; s/\n/&/4; tz; $!ba; q; :z; s/^([^\n]*)\t.*\n\1[^\n]*\'/&/; tc; D; $!ba; q; :c; $!N; s/^([^\n]*)\t.*\n\1[^\n]*\'/&/; tc; h; s/(.*)\n.*/\1/p; g; s/^([^\n]*)\t[^\t]*\n.*\n([^\n]*)\'/\1\n\2/; D;" temp3200 | SED "s/.*\t//" | MTEE /+ RenVSuspect >>d-del_A.dat
DEL /A/F/Q temp320? >N_\%random% 2>&1


FINDSTR -MLF:OriO4b "users32.dat" >Beep_sys.dat 2>N_\%random% || DEL /A/F Beep_sys.dat >N_\%random% 2>&1
IF EXIST "%SystemRoot%\windows.ext" FINDSTR -LMF:OriO4b "@.WYCaio [LordPE]" >>d-del_A.dat 2>N_\%random%
FINDSTR -MIRF:OriO4b "shell32.dll.ShellExecuteA.%system:\=\\%\\[^\\]*\.exe A.C.P.I.#.P.N.P.0.3.0.3.#.2...d.a.1.a.3.f.f" 2>N_\%random% | MTEE /+ d-del_A.dat >patched.af
PEV -fs32 -files:OriO4b -dcg1M -output:OriO400
FINDSTR -MIRF:OriO400 "W.I.N.M.O.D...L.Z.W.M.O.D...R.C._.P.I.C mvqr?-\*uru+.*47525 runouce\.exe 1.2.7...0...0...1...v.i.r.u.s.t.o.t.a.l...c.o.m" >>d-del_A.dat 2>N_\%random%
DEL /A/F OriO400


SET "GsarStr=@GSAR -o -susers64.dat -r:000:000:000:000:000:000:000:000:000:000:000"
FINDSTR -MLF:OriO4b "users64.dat" >Beep_sys64.dat 2>N_\%random% &&(
	SED -r "/.+/!d; s//@START NIRCMD KILLPROCESS \x22&\x22/" Beep_sys64.dat >Beep_sys64.bat
	SED "/./!d" Beep_sys64.dat| SED -r ":a;$!N; s/\n/\x22 \x22/;ta; s/.*/%GsarStr% \x22&\x22/;s/(.{3500}[^\x22]*\x22) /\1\n%GsarStr% /g" >>Beep_sys64.bat
	SED -r "/.+/!d; s/$/ ... hex repaired/" Beep_sys64.dat >>Beep_sys.dat
	%KMD% /C Beep_sys64.bat
	)>N_\%random% 2>&1
DEL /A/F Beep_sys64.dat Beep_sys64.bat >N_\%random% 2>&1
SET "GsarStr="


FINDSTR -MRF:OriO4b "Themida ThemidCa" 2>N_\%random% | FINDSTR -MIF:/ "s.e.t.u.p" >>d-del_A.dat
PEV -fs32 -c:##5# -rtf and "%SystemDrive%\Qoobox\Quarantine\%AppData::=%\drivers\winupgro.exe.vir" or { "%SystemDrive%\Qoobox\Quarantine\%system::=%\drivers\*" and hldrrr.exe.vir or winfilse.exe.vir } or "%AppData%\drivers\winupgro.exe" or { "%system%\drivers\*" and hldrrr.exe or winfilse.exe } -output:BagleM5
ECHO.D614840E3B7D9C4399807B502DFEDE3F>>BagleM5
PEV -fs32 -md5list:BagleM5 -files:OriO4b -tx50000 -tf >>d-del_A.dat


SED -r "/:\\/!d; s/(.*\S) +(\....)$/\1\2/" OriO4b >OriO4c
FOR /F "TOKENS=*" %%G IN ( OriO4C ) DO @IF EXIST "%%~DPNG %%~XG" (
	PEV -fs32 -t!o -tpmz -rtf -dg30 "%%~DPNG*" -preg"\\%%~NG *\%%~XG$" >>temp3200
	) ELSE IF EXIST "%%~DPNG" IF NOT EXIST "%%~DPNG\" PEV -fs32 -t!o -tpmz -rtf -dg30 { "%%~G" or "%%~DPNG" } >>temp3200

IF EXIST temp3200 (
	FINDSTR -MIRF:temp3200 "BlankVm\.dll \\Start\.pdb _.__C.CpC.CFC.C.C.KsK\{K.K.K.K.K.s.s.s.s.sDs.s.s.s.sks Stub.exe.?calculate_0@@YAHH@Z WriteFileEx...DuplicateHandle" >>temp3201 2>>Locked
	IF EXIST RenVSuspect GREP -Fixf RenVSuspect temp3200 >>temp3201
	SED "/./!d" temp3200 | SED -r ":a;$!N; s/\n/\x22 \x22/;ta; s/.*/\x22&\x22/;s/(.{3500}[^\x22]*\x22) /\1\n/g" >temp320A
	FOR /F "TOKENS=*" %%G IN ( temp320A ) DO @GREP -Elsqf powp.dat %%G >>temp3201
	DEL temp320A RenVSuspect
	)>N_\%random% 2>&1

IF EXIST Locked (
	CALL :Locked
	FOR /F "TOKENS=*" %%G IN ( LockedB ) DO @(
		FINDSTR -MIR "BlankVm\.dll \\Start\.pdb _.__C.CpC.CFC.C.C.KsK\{K.K.K.K.K.s.s.s.s.sDs.s.s.s.sks Stub.exe.?calculate_0@@YAHH@Z WriteFileEx...DuplicateHandle" "%%~DPG_%%~NG_%%~XG.vir" >N_\%random% 2>&1 && ECHO.%%G>>temp3201
		DEL /A/F "%%~DPG_%%~NG_%%~XG.vir"
		)
	DEL /A/F LockedB
	)>N_\%random% 2>&1


IF EXIST temp3201 SORT /M 65536 temp3201 | SED -r "$!N; /^(.*)\n\1$/I!P; D" >RenVFound
TYPE myNul.dat >>RenVFound
GREP -Fs :\ RenVFound >RenVDel.dat &&(
	PEV -t!o -tpmz -fs32 -tx50000 -tf "%SystemDrive%\*" -preg"( .exe|\\[^.]*)$" -output:temp3202
	GREP -Fivxf RenVFound temp3202 >temp3203
	FINDSTR -MIRF:temp3203 "BlankVm\.dll \\Start\.pdb _.__C.CpC.CFC.C.C.KsK\{K.K.K.K.K.s.s.s.s.sDs.s.s.s.sks Stub.exe.?calculate_0@@YAHH@Z help.happh WriteFileEx...DuplicateHandle" >>RenVDel.dat 2>N_\%random%
	SED -r "/:\\/!d; /%system:\=\\%\\cmd *\.exe/Id" temp3203 >temp3204
	SED -r "s/^(.*\S) +(\.exe)$/\1\2/I" temp3204 >temp3205
	FINDSTR -MIF:temp3205 "BlankVm\.dll \\Start\.pdb _.__C.CpC.CFC.C.C.KsK\{K.K.K.K.K.s.s.s.s.sDs.s.s.s.sks Stub.exe.?calculate_0@@YAHH@Z help.happh WriteFileEx...DuplicateHandle" >>RenVDel.dat 2>N_\%random%

	GREP -Fixvsf RenVDel.dat temp3203 >temp3206
	SED -r "/:\\/!d; /%system:\=\\%\\cmd *\.exe|~[0-9] *\.exe/Id" temp3206 >temp3207
	SED -r "/^(.*\S) +(\.exe)$/I!d; s//&	\1\2/;" temp3207 >temp3208
	SED -r "/:\\.*~[0-9] *\.exe/I!d" temp3203 >temp3209
	SED -r "s/^(.*\S) +(\.exe)$/&	\1\2/I;s/\\/\\\\/g" temp3209 >temp320A
	FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp320A ) DO @(
		ECHO."%%~FH">temp320B 2>N_\%random%
		SED "s/^/%%G	&/" temp320B >>temp3208
		DEL /A/F temp320B >N_\%random% 2>&1
		)
	FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp3208 ) DO @GREP -Fisq "%%~DPNH" RenVDel.dat &&ECHO."%%~G"	"%%~H">>RenV2Move.dat
	SED -r "/ +(\.exe)/Id; s/.*/&	&.exe/I;" temp3207 >temp32A0
	FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp32A0 ) DO @GREP -Fisq "%%~DPNH" RenVDel.dat &&ECHO."%%~G"	"%%~H">>RenV2Move.dat
	)
DEL /A/F/Q temp320? temp32A? RenVFound BagleM5 N_\* Locked OriO4? >N_\%random% 2>&1




:STAGE33
PEV -k NIRKMD.%cfext%
@Echo:%Stage%34 >WowErr.dat
@Echo:%Stage%34
@IF EXIST W6432.dat GOTO STAGE34

START NIRKMD CMDWAIT 15000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
:: RUSTOCK random hexcharacter drivers

PEV -fs32 -rtf -t!o -c##5#b#f#b#d#i#k#g# %system%\drivers\[0-9a-f][0-9a-f][0-9a-f]*[0-9a-f][0-9a-f][0-9a-f].sys -output:temp3300
SED -r "/^!HASH: .*	(.:\\.*)	-{24}$/!d; s//\1/" temp3300 >>d-del_A.dat
FINDSTR -BIG:srizbi.md5 temp3300 | SED -r "/.*(.:\\.*)	.*/!d; s//\1/" >>d-del_A.dat
SED -r "/.*!MD5: .*(.:\\.*)	.*/I!d; s//\1/" temp3300 >temp3301

FOR /F "TOKENS=*" %%G IN ( temp3301 ) DO @(
	CATCHME -l N_\%random% -c "%%~G" "%SystemDrive%\Qoobox\Test\_%%~NG_"
	IF EXIST "%SystemDrive%\Qoobox\Test\_%%~NG_" PEV -fs32 -tx50000 -tf -c:##5# "%SystemDrive%\Qoobox\Test\_%%~NG_" | FINDSTR -BIG:srizbi.md5 &&(
		ECHO.%%~G>>catch_E.dat
		ECHO.%%~G>>d-del_A.dat
		GREP -Fixs "%%~NG" SuspectSvc.dat | MTEE /+ SvcTargeted >>zhSvc.dat
		)
	DEL /A/F "%SystemDrive%\Qoobox\Test\_%%~NG_"
	)>N_\%random% 2>&1

DEL /A/F/Q temp330? N_\* >N_\%random% 2>&1


PEV -fs32 -rtf -t!o -dcG30 -dG30 -s+89000 -s-117060 %system%\drivers\[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f].sys -output:temp3300
SED ":a; $!N; s/\n/ /; ta;" temp3300 >temp3301
FOR /F "TOKENS=*" %%G IN ( temp3301 ) DO @GREP -Elf Rust.str %%G >>d-del_A.dat 2>>temp3302
IF EXIST temp3302 SED -r "/GREP: (.:\\.*): .*/I!d; s//\1/" temp3302 >temp3303

IF EXIST temp3303 FOR /F "TOKENS=*" %%G IN ( temp3303 ) DO @(
	CATCHME -l N_\%random% -c "%%~G" "%SystemDrive%\Qoobox\Test\_%%~NG_"
	IF EXIST "%SystemDrive%\Qoobox\Test\_%%~NG_" GREP -Esqf Rust.str "%SystemDrive%\Qoobox\Test\_%%~NG_" &&(
		ECHO.%%~G| MTEE /+ catch_E.dat >>d-del_A.dat
		GREP -Fixs "%%~NG" SuspectSvc.dat | MTEE /+ SvcTargeted >>zhSvc.dat
		)
	DEL /A/F "%SystemDrive%\Qoobox\Test\_%%~NG_"
	)>N_\%random% 2>&1

DEL /A/F/Q temp330? N_\*  >N_\%random% 2>&1



PEV -rtf -t!o -t!g -s530000-850000 %system%\drivers\* -preg"\\[a-z]{5,8}\.sys$" -c##5#b#f# -output:temp3300
SED -r "/^!HASH:/!d; s/.*\t//" temp3300 > temp3301

FOR /F "TOKENS=*" %%G IN ( temp3301 ) DO @(
	CATCHME -l N_\%random% -c "%%~G" "%SystemDrive%\Qoobox\Test\Locked00"
	GREP -Esql "(.){3}.[]\1{13} \1\1â\.reloc\1\1|ÈINIT.{32} ..â\.reloc|(.) \2\2à\.pak0\2{3}..\2{3}€\2{3}.\2{3}.\2{14}`\2\2`\.pak1\2\2|C.o.d.e.n.a.m.e. .L.o.n.g.h.o.r.n. .D.D.K. .p.r.o.v.i.d.e.r" "%SystemDrive%\Qoobox\Test\Locked00" &&(
		ECHO.%%~G>>catch_E.dat
		ECHO.%%~G>>d-del_A.dat
		)
	DEL /A/F "%SystemDrive%\Qoobox\Test\Locked00"
	)>N_\%random% 2>&1

DEL /A/F/Q temp330? N_\* >N_\%random% 2>&1



:STAGE34
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 10000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%35 >WowErr.dat
@Echo:%Stage%35

DEL /A/Q tempV01.dat >N_\%random% 2>&1

:: - CmdService
SED "/^cmdservice	/I!d; s///" SvcDump >temp3402

FOR /F "TOKENS=*" %%G IN ( temp3402 ) DO @(
	IF EXIST "%%~G" ECHO."%%~G">>d-del_A.dat
	CALL :REMDIR "%%~DPG" 3
	)>N_\%random% 2>&1

DEL /A/F/Q temp340? N_\* >N_\%random% 2>&1



:Stage35
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 15000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%36 >WowErr.dat
@Echo:%Stage%36
:: asc355* service

SWREG QUERY "hklm\system\currentcontrolset\control\session manager" /v pendingfilerenameoperations >temp3500
SED "/.*	/!d; s///; s/\\0\\0/\n/g" temp3500 >temp3501
SED "/\\0.*\\/!d; s/\\0/\n/g" temp3501 >temp3502
SED "s/^\\??\\//; s/\\Systemroot\\/%systemroot:\=\\%\\/Ig" temp3502 >temp3503

SED -n "/\\asc355.*\.sys$/I{H;g;p;};h" temp3503 >temp3504
GREP -s . temp3504 >temp3505 &&@ (
	TYPE temp3505 >>CFiles.dat
	SED -r -e "/\\asc355.*\.sys$/I!d; s/.*\\//g; s/\..*//g; /asc3550$/Id" temp3505 | MTEE /+ SvcTargeted >>zhSvc.dat
	)

DEL /A/F/Q temp350? N_\* >N_\%random% 2>&1


:Stage36
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 15000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%37 >WowErr.dat
@Echo:%Stage%37
:: Malware Protector

SWREG QUERY "HKLM\Software" >temp3600
SED "/HKEY_.*\\[rs]hc...j0e...$/I!d" temp3600 | MTEE temp3601 >temp3602
SED "s/.*/\n[-&]/" temp3602 >>CregC.dat
FOR /F "TOKENS=*" %%G IN ( temp3601 ) DO @SWREG NULL delete "%%~G\Settings*" /n * >N_\%random% 2>&1
DEL /A/F/Q temp360? N_\* >N_\%random% 2>&1

SWREG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" >temp3600
SED "/HKEY_.*\\[rs]hc...j0e...$/I!d; s/.*/[-&]/" temp3600 >>CregC.dat

IF EXIST "%ProgFiles%\?hc???j0e???" (
	PEV -fs32 -rtd "%ProgFiles%\?hc???j0e???" | MTEE /+ d-delB.dat >temp3600
	SED -r "s/.*\\.{5}//" temp3600 >temp3601
	FOR /F "TOKENS=*" %%G IN ( temp3601 ) DO @(
		PEV -fs32 -rtf -t!o "%system%\*%%~G.*" >>d-del_A.dat
		FOR /F "TOKENS=*" %%H IN ( Appdata.folder.dat ) DO @IF EXIST "%%~H\*%%~G" PEV -fs32 -rtd "%%~H\*%%~G" >>d-delB.dat
		) )
DEL /A/F/Q temp360? N_\* >N_\%random% 2>&1


FOR %%G IN ( "%system%\?phc???j0e???.exe" ) DO @ECHO.%%G>>temp3600

IF EXIST temp3600 FOR /F "TOKENS=*" %%G IN ( temp3600 ) DO @(
	PEV -fs32 -rtf -t!o -s=%%~ZG "%system%\*exe" -output:temp3601
	FOR /F "TOKENS=*" %%H IN ( temp3601 ) DO @FC.exe "%%~G" "%%~H" >N_\%random% 2>&1 &&ECHO.%%H
	DEL /A/F temp3601 >N_\%random% 2>&1
	)>>d-del_A.dat
IF EXIST temp360? DEL /A/F/Q temp360? N_\* >N_\%random% 2>&1


:STAGE37
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 30000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%38 >WowErr.dat
@Echo:%Stage%38

SWREG ACL "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /RESET /Q

:: Orphans take care of this now
@>roguesB00 (
TYPE rogues.dat
SED -r "/^@SET \x22(Cookies|Favorites|NetHood|PrintHood|Recent|SendTo|StartMenu|Programs|Cache|History|Fonts|Common(StartMenu|Favorites)|Default(AppData|Cookies|PrintHood|Recent|SendTo|LocalSettings|Cache|History)|SysTemp)=/I!d; s///; s/\x22//; /:\\/!d; s/$/\\/" Setpath.bat
ECHO."%SystemRoot%\temp\"
ECHO."%system%\dllcache\"
ECHO."%TEMP%\"
IF DEFINED Temp_LFN ECHO."%Temp_LFN%"
ECHO.":\Recycler\"
ECHO.":\Recycled\"
ECHO.":\$Recycle.BIN\"
ECHO.":\temp\"
ECHO.":\System Volume Information\"
ECHO.":\Cmdcons\"
ECHO.":\Documents and Settings\Default User\"
ECHO.":\Documents and Settings\LocalService\"
ECHO.":\Documents and Settings\NetworkService\"
ECHO."%system%\config\systemprofile\"
ECHO."%SystemRoot%\ServiceProfiles\"
ECHO."%userprofile%\%username%.exe"
)
SED "s/\x22//g" RoguesB00 >RoguesB.dat
DEL /A/F RoguesB00 >N_\%random% 2>&1


@ECHO.>>CregC.dat
@ECHO.[hkey_classes_root\applications\iexplore.exe\shell\open\command]>>CregC.dat
@ECHO.@="\"%ProgramFiles:\=\\%\\Internet Explorer\\iexplore.exe\" %%1">>CregC.dat
@ECHO.[hkey_classes_root\ftp\shell\open\command]>>CregC.dat
@ECHO.@="\"%ProgramFiles:\=\\%\\Internet Explorer\\iexplore.exe\" %%1">>CregC.dat
@ECHO.[hkey_classes_root\htmlfile\shell\open\command]>>CregC.dat
@ECHO.@="\"%ProgramFiles:\=\\%\\Internet Explorer\\iexplore.exe\" %%1">>CregC.dat
@ECHO.[hkey_classes_root\htmlfile\shell\opennew\command]>>CregC.dat
@ECHO.@="\"%ProgramFiles:\=\\%\\Internet Explorer\\iexplore.exe\" %%1">>CregC.dat
@ECHO.[-hkey_classes_root\http\shell\open\command]>>CregC.dat
@ECHO.[hkey_classes_root\http\shell\open\command]>>CregC.dat
@ECHO.@="\"%ProgramFiles:\=\\%\\Internet Explorer\\iexplore.exe\" %%1">>CregC.dat

@ECHO.[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List]>>CregC.dat
@ECHO."%system:\=\\%\\rundll32.exe"=->>CregC.dat
@ECHO."%system:\=\\%\\lsass.exe"=->>CregC.dat
@ECHO."%system:\=\\%\\winlogon.exe"=->>CregC.dat
@ECHO."%system:\=\\%\\services.exe"=->>CregC.dat
@ECHO."%system:\=\\%\\logonui.exe"=->>CregC.dat
@ECHO."%system:\=\\%\\ctfmon.exe"=->>CregC.dat
@ECHO."%system:\=\\%\\notepad.exe"=->>CregC.dat
@ECHO."%system:\=\\%\\svchost.exe"=->>CregC.dat
@ECHO."%system:\=\\%\\spoolsv.exe"=->>CregC.dat
@ECHO."%systemroot:\=\\%\\explorer.exe"=->>CregC.dat
@ECHO."%system:\=\\%\\userinit.exe"=->>CregC.dat
@ECHO."%SYSDIR:\=\\%\\rundll32.exe"=->>CregC.dat
@ECHO."%SYSDIR:\=\\%\\lsass.exe"=->>CregC.dat
@ECHO."%SYSDIR:\=\\%\\winlogon.exe"=->>CregC.dat
@ECHO."%SYSDIR:\=\\%\\services.exe"=->>CregC.dat
@ECHO."%SYSDIR:\=\\%\\logonui.exe"=->>CregC.dat
@ECHO."%SYSDIR:\=\\%\\ctfmon.exe"=->>CregC.dat
@ECHO."%Systemroot:\=\\%\\notepad.exe"=->>CregC.dat
@ECHO."%SYSDIR:\=\\%\\notepad.exe"=->>CregC.dat
@ECHO."%SYSDIR:\=\\%\\svchost.exe"=->>CregC.dat
@ECHO."%SYSDIR:\=\\%\\spoolsv.exe"=->>CregC.dat
@ECHO."%SYSDIR:\=\\%\\userinit.exe"=->>CregC.dat
@ECHO."%systemroot:\=\\%\\Microsoft.NET\\Framework\\v2.0.50727\\vbc.exe"=->>CregC.dat

SETLOCAL
IF EXIST W6432.dat (
	SET "ProgramFiles=%ProgramFiles(x86)%"
	SET "CommonProgramFiles=%CommonProgramFiles(x86)%"
	)

@ECHO."%ProgramFiles:\=\\%\\Internet Explorer\\iexplore.exe"=->>CregC.dat

@ECHO.[hkey_classes_root\internetshortcut\shell\open\command]>>CregC.dat
@IF EXIST "%SYSDIR%\ieframe.dll" (
	ECHO.@="rundll32.exe ieframe.dll,OpenURL %%l">>CregC.dat
	ECHO.[HKEY_CLASSES_ROOT\CLSID\{FBF23B40-E3F0-101B-8488-00AA003E56F8}\InProcServer32]>>CregC.dat
	ECHO.@=hex^(2^):25,57,49,4e,44,49,52,25,5c,73,79,73,74,65,6d,33,32,5c,69,65,66,72,61,6d,65,2e,64,6c,6c,00>>CregC.dat
) ELSE IF EXIST "%SYSDIR%\shdocvw.dll" (
	ECHO.@="rundll32.exe shdocvw.dll,OpenURL %%l">>CregC.dat
	ECHO.[HKEY_CLASSES_ROOT\CLSID\{FBF23B40-E3F0-101B-8488-00AA003E56F8}\InProcServer32]>>CregC.dat
	ECHO.@="shdocvw.dll">>CregC.dat
	)

@ECHO.[hkey_classes_root\scriptletfile\shell\generate typelib\command]>>CregC.dat
@ECHO.@="\"%SYSDIR:\=\\%\\rundll32.exe\" %SYSDIR:\=\\%\\scrobj.dll,GenerateTypeLib %%1">>CregC.dat
@ECHO.[-hkey_local_machine\software\microsoft\windows nt\currentversion\image file execution options\userinit.exe]>>CregC.dat
@ECHO.[hkey_local_machine\software\microsoft\windows nt\currentversion\winlogon]>>CregC.dat
@ECHO."Userinit"="%SYSDIR:\=\\%\\userinit.exe,">>CregC.dat
@ECHO."Shell"="Explorer.exe">>CregC.dat
@ECHO."ntdll.dll"=->>CregC.dat
@ECHO.[hkey_local_machine\software\clients\startmenuinternet\iexplore.exe\shell\open\command]>>CregC.dat
@ECHO.@="\"%ProgramFiles:\=\\%\\Internet Explorer\\iexplore.exe\"">>CregC.dat
@ECHO.[hkey_local_machine\software\microsoft\windows\currentversion\SharedDlls]>>CregC.dat
@ECHO."%CommonProgramFiles:\=\\%\\WinAntiVirus Pro 2007\\WAPChk.dll"=->>CregC.dat
@ECHO."%CommonProgramFiles:\=\\%\\AVSystemCare\\UGaChk.dll"=->>CregC.dat
@ECHO."%SYSDIR:\=\\%\\pc.dll"=->>CregC.dat
@ECHO."%ProgramFiles:\=\\%\\engagesidebar\\effbar.dll"=->>CregC.dat
@IF DEFINED ActiveX ECHO."%ActiveX:\=\\%\\setup.dll"=->>CregC.dat
ENDLOCAL

SWREG QUERY hkcr >temp3700
SED -r "/\.(Windows Shell|TIEBHOCom|IEExtend|TCHONGABHO|Microsoft Update Service)$|\\(TBSB[0-9]*)\.(\2$|\2\.3$|IEToolbar($|\.1$))|\\Toolbar3\.(TBSB[0-9.]*|XBTB.*)$|\\ToolBand\.XTTB.*$/I!d;s/.*/[-&]/" temp3700 >>CregC.dat


@ECHO.[-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%SystemDrive%]>>CregC.dat


FOR %%G IN (
	"hkey_local_machine\software\microsoft\windows\currentversion\run"
	"hkey_current_user\software\microsoft\windows\currentversion\run"
	"hkey_users\.default\software\microsoft\windows\currentversion\run"
	"hkey_current_user\software\microsoft\windows\currentversion\policies\explorer\run"
	"hkey_local_machine\software\microsoft\windows\currentversion\policies\explorer\run"
	"hkey_users\.default\software\microsoft\windows\currentversion\policies\explorer\run"
) DO @(
	SWREG QUERY %%G >Run00
	SED -r "/HKEY.+run$/I,/^$/!d; s/^   (.*)	.*	/\x22\1\x22=/" Run00 >Run01
	@ECHO.[%%~G]>>CregC.dat
	GREP -Fif roguesB.dat Run01 | SED "/\x22=.*/!d;s//\x22=-/" >>CregC.dat
	SED -R "/^(.{3,}drv\x22=).*Rundll32[^\x22]*\x22(.:\\[^\x22]*\.dll|.{6,8}\.dll)\x22,(.|DllRegisterServer)$|^(\x22(\d+|.{1,2})\x22=).*/I!d; s//\1\4-/" run01 >>CregC.dat
	DEL /A/F/Q Run0?
	)>N_\%random% 2>&1



SWREG QUERY hkcr\txtfile\shell\open\command >temp3700
GREP -Eiq "notedad\.exe|system\.exe|ghrtyiyu575fghgh\.exe|jky7u64thng5thb\.exe|rund1132\.exe|sysedit32\.exe|nxtepad\.exe|network\.exe|winlog\.EXE|msdumprep\.exe|Sysexp32\.exe" temp3700 &&@(
		ECHO.[hkey_classes_root\inifile\shell\open\command]
		ECHO.@=hex^(2^):25,53,79,73,74,65,6d,52,6f,6f,74,25,5c,73,79,73,74,65,6d,33,32,5c,4e,4f,54,45,50,41,44,2e,45,58,45,20,25,31,00
		ECHO.[hkey_classes_root\txtfile\shell\open\command]
		ECHO.@=hex^(2^):25,53,79,73,74,65,6d,52,6f,6f,74,25,5c,73,79,73,74,65,6d,33,32,5c,4e,4f,54,45,50,41,44,2e,45,58,45,20,25,31,00
		ECHO.[HKEY_CLASSES_ROOT\batfile\shell\edit\command]
		ECHO.@="NOTEPAD.EXE %%1"
		ECHO.[HKEY_CLASSES_ROOT\cmdfile\shell\edit\command]
		ECHO.@="NOTEPAD.EXE %%1"
		ECHO.[HKEY_CLASSES_ROOT\regfile\shell\edit\command]
		ECHO.@="NOTEPAD.EXE %%1"
		)>>CregC.dat


@(
SWREG QUERY "hklm\software"
SWREG QUERY "hkcu\software"
)>temp3700
GREP -Ei "^HKEY.*\\(({|)[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(}|)|\{.*[0-9].*[0-9].*[0-9].*\}|[a-f0-9]{32}|[0-9]{8}|X[BT]TB[0-9]*)$" temp3700 | SED "/^HKEY.*/I!d; s//\n[-&]/" >>CregC.dat

@(
SWREG QUERY "hklm\software\microsoft\windows\currentversion\app paths"
SWREG QUERY "hklm\software\microsoft\windows\currentversion\uninstall"
SWREG QUERY "hkcu\software\microsoft\windows\currentversion\uninstall"
)>>temp3700
GREP -Fif rogues.dat temp3700 | SED "/HKEY_.*/I!d;s//\n[-&]/" >>CregC.dat


SWREG QUERY "hklm\software\microsoft\windows\currentversion\moduleusage" >temp3700
SED -r "/egdaccess|eg_auth|eglivecam|egaccess|p2esocks|egdhtml|egcomservice/I!d;" temp3700 >temp3701
SED -r "s/.*/[-&]/" temp3701 >>CregC.dat

DEL /A/Q temp370?  aa.dat temprun >N_\%random% 2>&1


@IF EXIST XP.mac TYPE xpreg.dat >>CregC.dat
@IF EXIST Vista.mac TYPE vistareg.dat >>CregC.dat
@IF EXIST W7.mac TYPE W7reg.dat >>CregC.dat
@IF EXIST W8.mac TYPE W8reg.dat >>CregC.dat
DEL /A/F/Q ??*reg.dat roguesB.dat >N_\%random% 2>&1

IF EXIST %SystemRoot%\shell.exe (
	SWREG QUERY "hklm\software\microsoft\windows nt\currentversion\winlogon" /v shell >temp3700
	SED -r "/	|\\/I!d;" temp3700 >temp3701
	SED -r "s/^HKEY.*/[&]/; s/.*	/\x22Shell\x22=\x22/; s/ %systemroot:\=\\%\\shell\.exe//I; /=/s/.*/&\x22/" temp3701 >>CregC.dat
	DEL /A/F/Q temp370? >N_\%random% 2>&1
	)


SWREG export HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters %SystemDrive%\Qoobox\Quarantine\Registry_backups\tcpip.reg /nt4
SED -r "s/^(\x22(dhcpnameserver|nameserver)\x22=\x22)(125\.43\.78\.104|160\.213\.|193\.104\.110\.38|193\.202\.121\.50|200\.172\.222\.2|212\.227\.57\.172|213\.109\.[67].\.|213\.174\.139\.72|217\.23\.1.\.|217\.173\.42\.46|219\.141\.136\.10|220\.181\.66\.21|221\.234\.47\.129|61\.54\.28\.13|69\.64\.36\.29|77\.68\.42\.1|77\.74\.48\.113|77\.78\.240\.21|83\.149\.115\.|85\.255\.|93\.188\.16\.).*/\1\x22/I" %SystemDrive%\Qoobox\Quarantine\Registry_backups\tcpip.reg >>CregC.dat
DEL /A/F/Q temp370? N_\* >N_\%random% 2>&1

SWREG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion" >temp3700
SED -r "/^H.*\\\CurrentVersion$|^ +kd...\.exe/I!d;" temp3700 >temp3701
SED -r "s/^H.*/\n[&]/; s/^ +(\S*)	.*/\x22\1\x22=-/" temp3701 >>CregC.dat
DEL /A/F/Q temp370? >N_\%random% 2>&1

SWREG QUERY "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion" >temp3700
SED -r "/^H.*\\\CurrentVersion$|^ +kd...\.exe/I!d;" temp3700 >temp3701
SED -r "s/^H.*/\n[&]/; s/^ +(\S*)	.*/\x22\1\x22=-/" temp3701 >>CregC.dat
DEL /A/F/Q temp370? >N_\%random% 2>&1


SWREG EXPORT HKLM\SOFTWARE\Clients\StartMenuInternet StartMenuInternet00 /nt4
SED "/./{H;$!d;};x;/\\shell\\open\\command\]/I!d;" StartMenuInternet00 | SED -r ":a; $!N;s/\n(@=\x22).*(\\\x22.:[^:]*)$/	\1\2/;ta;P;D" | SED -r "/	/!d; s//\n/" >>CregC.dat

SWREG EXPORT "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes" PersistentRoutes00 /nt4
SED -r "/^\[|,(255\.)\1\10,/!d; /^\x22(0|10|172\.(1[6-9]|2.|3[01])\.|192\.168|127|169\.254|224|255)\./d;s/=\x22\x22$/=-/" PersistentRoutes00 >>CregC.dat

SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v BootExecute >BootExecute00
SED -r "/.*	/!d;" BootExecute00 | SED -r "s/.*	//; s/(\\0)*$//; s/\\0/\n/g" | GREP -Eivx "BLc Manager|FCORP|AV" | SED -r ":a; $!N; s/\n/\\0/; ta" >BootExecute01
FOR /F "TOKENS=*" %%G IN ( BootExecute01
	) DO @SWREG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /V BootExecute /T Reg_Multi_Sz /D "%%G"


DEL /A/F/Q temp37* BootExecute0? StartMenuInternet00 PersistentRoutes00 >N_\%random% 2>&1


:STAGE38
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 22000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%

@Echo:%Stage%39 >WowErr.dat
@Echo:%Stage%39

For %%G in (
"%system%\nvrssl.dll"
"%system%\nvrssk.dll"
"%system%\nvrsma32.dll"
"%system%\nvrsol32.dll"
"%system%\nvrsk.dll"
) DO @IF EXIST  %%G FINDSTR -MI "KasperskyLab dolman\.zt" %%G >>d-del_A.dat 2>lockD || GREP -Fq "FINDSTR: Cannot open" lockD &&(
	IF EXIST f_system IF NOT EXIST W6432.dat (
		FileKill -N CFcatchme -l N_\%random% -m %%G KasperskyLab kasperskyLab &&ECHO.%%G>>d-del_A.dat
		FileKill -N CFcatchme -l N_\%random% -m %%G dolman.zt dolman.zt &&ECHO.%%G>>d-del_A.dat
		) ELSE (
		Handle %%G >temp3800
		SED -R "/.* pid: (\d*) +(\S*):.*/I!d;s//@Handle -c \2 -y -p \1/" temp3800 >temp3800.bat
		ECHO.@ECHO.>> temp3800.bat
		CALL temp3800.bat
		DEL /A/F temp3800.bat temp3800
		FINDSTR -MI "KasperskyLab dolman\.zt" %%G >>d-del_A.dat
		)
	IF NOT EXIST f_system (
		Handle %%G >temp3800
		SED -R "/.* pid: (\d*) +(\S*):.*/I!d;s//@Handle -c \2 -y -p \1/" temp3800 >temp3800.bat
		ECHO.@ECHO.>> temp3800.bat
		CALL temp3800.bat
		DEL /A/F temp3800.bat temp3800
		FINDSTR -MI "KasperskyLab dolman\.zt" %%G >>d-del_A.dat
		) )>N_\%random% 2>&1
DEL /A/F/Q lockD temp380? >N_\%random% 2>&1

SED -r "/^HKEY_|..pI..t_Dlls	.*	./I!d; /^ *AppInit_Dlls	/Id; s/^   /\x22/; s/	.*/\x22=-/; s/^HKEY.*/[&]/" MWindows.dat >temp3800
GREP -B2 = temp3800 >>CregC.dat


IF NOT EXIST RcRdy GOTO STAGE39

GREP -q  "A.p.p.I.n.i.t._.D.L.L.s" "%system%\user32.dll" ||(
	@ECHO.copy "%SystemDrive%\Qoobox\Quarantine\%SYSDIR::=%\user32.dll.vir" "%system%\user32.dll">>%SystemRoot%\erdnt\CF_undo.bat
	IF EXIST %SystemRoot%\Help\access.hlp GREP -Fiq acc_cs.rtf %SystemRoot%\Help\access.hlp ||ECHO.%SystemRoot%\Help\access.hlp>>d-del_A.dat
	IF EXIST %SystemRoot%\Help\verifier.hlp GREP -Fiq verifier.rtf %SystemRoot%\Help\verifier.hlp ||ECHO.%SystemRoot%\Help\verifier.hlp>>d-del_A.dat
	ATTRIB -H -R -S "%system%\user32.dll"
	IF EXIST "%system%\dllcache\user32.dll" DEL /A/F "%system%\dllcache\user32.dll"
	MOVE /Y "%system%\user32.dll" "%system%\user32.dll.vir"
	IF EXIST "%system%\user32.dll.vir" (
		GSAR -h -c27 -sp:x00I:x00n:x00i:x00t:x00_:x00D:x00L:x00L:x00s "%system%\user32.dll.vir" >temp3800
		GREP -sq . temp3800 &&(
			SED -r "1!d; s/.{4}$//; s/\./:x00/g; s/^(.{6})(.*)$/@GSAR -f -s\1\2 -rA:x00p\2 \x22%SYSDIR:\=\\%\\user32.dll.vir\x22 \x22%SYSDIR:\=\\%\\user32.dll\x22/" temp3800 >GSAR_user32.bat
			)||(
			GSAR -h -c34 -s:x00t:x00_:x00D:x00L:x00L:x00s "%system%\user32.dll.vir" >temp3800
			SED -r "1!d; s/s\.\..*/s/; s/\./:x00/g; s/.*/@GSAR -f -s& -rA:x00p:x00p:x00I:x00n:x00i:x00t:x00_:x00D:x00L:x00L:x00s \x22%SYSDIR:\=\\%\\user32.dll.vir\x22 \x22%SYSDIR:\=\\%\\user32.dll\x22/" temp3800 >GSAR_user32.bat
			))
	IF EXIST GSAR_user32.bat (
		ECHO.@ECHO.>> GSAR_user32.bat
		Call GSAR_user32.bat
		DEL /A/F GSAR_user32.bat
		)
	GREP -q "A.p.p.I.n.i.t._.D.L.L.s" "%system%\user32.dll" &&(
		%KMD% /D /C MoveIt.bat "%system%\user32.dll.vir"
		ECHO.Infected %system%\user32.dll hex repaired>>user32.dat
		IF EXIST "%system%\dllcache\" COPY /Y /B "%system%\user32.dll" "%system%\dllcache\"
		)||MOVE /Y "%system%\user32.dll.vir" "%system%\user32.dll"
		)>N_\%random% 2>&1

FINDSTR -LI "%system%\mmc.exe" %system%\user32.dll >N_\%random% 2>&1 &&CALL :ND_sub "%system%\user32.dll"


:STAGE39
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 22000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
IF EXIST temp380? DEL /A/F/Q temp380? >N_\%random% 2>&1
@Echo:%Stage%40 >WowErr.dat
@Echo:%Stage%40

GREP -sq MSCORE\.DLL "%system%\svchost.exe" &&(
	CALL :FREE "%system%\svchost.exe"
	COPY /Y /B "%system%\svchost.exe" >N_\%random% 2>&1
	GSAR -o -sMSCORE.DLL -rRPCRT4.dll svchost.exe >N_\%random% 2>&1
	GSAR -o -s45:x00:x00:xFF:xFF:xFF:xFF:xFF:xFF:xFF:xFF:xDE3:x00:x00$:x11:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00ADVAPI32 -r:x105:x00:x00:xFF:xFF:xFF:xFF:xFF:xFF:xFF:xFF:xDE3:x00:x00$:x11:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00:x00ADVAPI32 svchost.exe >N_\%random% 2>&1
	IF EXIST FdsvOK PEV -fs32 -tx15000 -rtf .\svchost.exe -tg >N_\%random% &&(
		%KMD% /D /C MoveIt.bat "%system%\svchost.exe" >N_\%random% 2>&1
		TYPE myNul.dat >CFReboot.dat
		ECHO."%system%\mscore.dll">>d-del_A.dat
		MOVE /Y svchost.exe "%system%" >N_\%random% 2>&1
		ECHO.Infected %system%\svchost.exe hex repaired>>svchostX.dat
	)||(
		DEL /A/F svchost.exe >N_\%random% 2>&1
		CALL :ND_sub "%system%\svchost.exe" "MSCORE\.DLL"
		IF EXIST FdsvOK PEV -fs32 -tx15000 -rtf .\svchost.exe -tg >N_\%random% &&(
				ECHO."%system%\mscore.dll">>d-del_A.dat
			)||(
				%KMD% /D /C MoveIt.bat "%system%\mscore.dll" >N_\%random% 2>&1
				COPY /Y /B "%system%\rpcrt4.dll" "%system%\mscore.dll" >N_\%random% 2>&1
				ECHO."%system%\rpcrt4.dll"| SED "s/\x22//g;s/$/&  -->%SYSDIR:\=\\%\\mscore.dll/" >>svchostX.dat
				)))
IF EXIST temp390? DEL /A/F/Q temp390? >N_\%random% 2>&1

IF EXIST DoStepDel IF EXIST d-del_A.dat GREP -ivq "::::" d-del_A.dat &&( Call :PreRunDel )|| DEL /A/F d-del_A.dat


:STAGE40
@MOVE /Y ncmd.com ncmd.cfxxe >N_\%random% 2>&1
PEV -k NIRKMD.%cfext%
@MOVE /Y ncmd.cfxxe ncmd.com >N_\%random% 2>&1
START NIRKMD CMDWAIT 15000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
IF EXIST d-del_A.dat TYPE d-del_A.dat >> d-delA.dat && DEL /A/F d-del_A.dat
IF EXIST d-del_B.dat TYPE d-del_B.dat >> d-delB.dat && DEL /A/F d-del_B.dat
@Echo:%Stage%41 >WowErr.dat
@Echo:%Stage%41


:: SUB-ROUTINE RELOCATED FROM STAGE_9

PEV -fs32 -tx50000 -tf -dg3m "%ProgFiles%\*" and -preg"\\[a-z]{8}\.dll$" and { -s=40448 or -s=15872 } -output:temp4000
FINDSTR -MIF:temp4000 srvhost >>d-delA.dat 2>N_\%random%

PEV -fs32 -rtf "%ProgFiles%\*22011.exe" -output:temp4000
FINDSTR -MF:temp4000 "Internet.Explorer_Server....Software\\Outcast.LLC" >>d-delA.dat 2>N_\%random%

SED -R "/.*	\d{5}	(%CommonProgFiles:\=\\%\\(.*MS......\.dll|System\QQ....\.exe))	1:.*/I!d; s//\1/" progfile.dat  >temp4000 2>N_\%random%
FINDSTR -MF:temp4000 "MZKERNEL32.DLL" >>d-delA.dat 2>N_\%random%




::::::::::::


:STAGE41
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 10000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%42 >WowErr.dat
@Echo:%Stage%42

PEV -fs32 -rtf -t!o "%system%\*" AND { oldw[ns].tmp or winrc.tmp or wsrec.tmp } -output:temp4100
GREP -sq . temp4100 &&(
	GSAR -s:x003:xC9:x8B:xC09:x02t:x0C:x83:xC2:x049:x0Au:xF5:xE9C:xD2:xFE:xFF3:xC0H "%system%\ws2_32.dll" >temp4101
	GREP -Fsq "match found" temp4101 &&ECHO."%system%\ws2_32.dll" is infected >BankpatchB
	GSAR -s9:xd6:xdd7t:xd4:xd4Vu:xd9:xc6Yt:xd4:x89Tm:xb5:xd4Nz:xd4:xc9 "%system%\wininet.dll" >temp4102
	GREP -Fsq "match found" temp4102 &&(
		%KMD% /D /C MoveIt.bat "%system%\wininet.dll" >N_\%random% 2>&1
		FINDSTR -i "oldwn.tmp winrc.tmp" temp4100 >temp4103
		FOR /F "TOKENS=*" %%G IN ( temp4103 ) DO @(
			CALL :FREE "%%~G"
			CALL :FREE "%system%\wininet.dll"
			MOVE /Y "%%~G" "%system%\wininet.dll"
			ECHO."%%~G"| SED "s/\x22//g;s/$/&  -->wininet.dll/" >>BankpatchB
			TYPE myNul.dat >CFReboot.dat
			))
	FOR /F "TOKENS=*" %%G IN ( temp4100 ) DO @IF EXIST "%%~G" ECHO.%%~FTZAG>>BankpatchB
	)>N_\%random% 2>&1

DEL /A/F/Q temp410? N_\* >N_\%random% 2>&1



:STAGE42
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 10000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%43 >WowErr.dat
@Echo:%Stage%43

@(
echo\.comcastsupport.com
echo\.corel.com
echo\.dellsupportcenter.com
echo\.google.com
echo\.googlevideo.com
echo\.live.com
echo\.microsoft.com
echo\.msn.com
echo\.ncsoft.com
echo\.pandasoftware.com
echo\.pdfcomplete.com
echo\.rr.com
echo\.simplestar.com
echo\.sun.com
echo\.urge.com
echo\.windowsupdate.com
echo\.comcastsupport.com:80
echo\.corel.com:80
echo\.dellsupportcenter.com:80
echo\.google.com:80
echo\.googlevideo.com:80
echo\.live.com:80
echo\.microsoft.com:80
echo\.msn.com:80
echo\.pandasoftware.com:80
echo\.sun.com:80
echo\.urge.com:80
echo\.windowsupdate.com:80
echo\.symantecstore.com
echo\.symantec.com
echo\.hp.com
echo\.threatfire.com
echo\.pctools.com
echo\.intuit.com
echo.\.aim.com
echo.\.kodak.com
echo.\.nationalgeographic.com
echo.\.google.com
echo.\.linksys.com
echo.\.nokia.com
echo\.stanford.edu:80
echo\.adobe.com
echo\.aol.com
echo\.newaol.com
echo\.nero.com
echo.\.verizon.net
echo.\.norton.com

)>BitsStr

IF EXIST "%CommonAppData%\Microsoft\Network\Downloader\qmgr?.dat" (
	TYPE "%CommonAppData%\Microsoft\Network\Downloader\qmgr?.dat" | GSAR -F -s:x1A -r >temp4200
	SED -r "s/[^ -~]//Ig; G; s/(http:|.:\\.)/\n&/Ig;" temp4200 >temp4201
	SED -r "/^http:\/\/[^/]*(\/|$)/I!d; s/http:/hxxp:/Ig; s/([^/:]+)\/.*/\1/" temp4201 >temp4202
	FINDSTR -EVIG:BITSSTR temp4202 >BitsPath
	DEL /A/F/Q temp420?
	)>N_\%random% 2>&1

IF EXIST BitsPath GREP -sq . BitsPath &&(
	PEV SC STOP BITS
	PEV -fs32 -rtf "%CommonAppData%\Microsoft\Network\Downloader\qmgr?.dat" > BitsPath00
	FOR /F "TOKENS=*" %%G IN ( BitsPath00 ) DO @(
		DEL /A/F "%%~G"
		IF EXIST "%%~G" CATCHME -l BitsPath01 -E "%%~G"
		)
	DEL BitsPath00 BitsPath BitsPath01
	)>N_\%random% 2>&1



:STAGE43
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 10000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%44 >WowErr.dat
@Echo:%Stage%44

For %%G in (
"%SystemDrive%\037589.log"
"%system%\com\lsass.exe"
"%system%\com\netcfg.000"
"%system%\com\netcfg.dll"
"%system%\com\smss.exe"
"%system%\dnsq.dll"
) DO @IF EXIST %%G ECHO.%%G>>Xorer

IF EXIST Xorer (
	SWREG QUERY "hklm\system\currentcontrolset\control\session manager" /v pendingfilerenameoperations >temp4300
	SED -r "/.*	/!d;s///; s/(\\0)\1$/*/; s/\\0(!|\\)/*\1/g; s/\\\?.[^?]*\*!\\\?/\n&/g;s/\\\?.[^?]*\*\*/\n&/g" temp4300 >temp4301
	SED -r "/^(.*)!\1$/Id; /%system:\=\\%\\[0-9]*\.log\*!\\.*%CommonStartup:\=\\%\\~\.exe\.[0-9]*\.exe*/Id;" temp4301 >temp4302
	SED ":a; $!N; s/\n//; ta" temp4302 >temp4303
	GREP -sq . temp4303 &&(
		FOR /F "TOKENS=*" %%G IN ( temp4303
			) DO SWREG ADD "hklm\system\currentcontrolset\control\session manager" /v pendingfilerenameoperations /t reg_multi_sz /s * /d "%%G"
		)|| SWREG DELETE "hklm\system\currentcontrolset\control\session manager" /v pendingfilerenameoperations
	PEV -fs32 -rtf -s+90000 -d:G90 %system%\[0-9]*[0-9].log -output:temp4304
	GREP -i "\\[0-9]*\.log" temp4304 >temp4305
	FINDSTR -MF:temp4305 4D36E967-E325 | MTEE /+ d-delA.dat >>Xorer
	FOR /F "TOKENS=*" %%H IN ( Xorer ) DO @%KMD% /D /C MoveIt.bat "%%~H" "MoveEx"
	TYPE myNul.dat >fboot.dat
	Type Xorer >>Catch_k.dat
	IF EXIST XP.mac TYPE myNul.dat >RestoreRun
	)>N_\%random% 2>&1
DEL /A/F/Q temp430? >N_\%random% 2>&1


:STAGE44
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 10000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%45 >WowErr.dat
@Echo:%Stage%45

SWREG QUERY "hklm\software\microsoft\windows nt\currentversion\drivers32" >temp4400
SED -r "/   midi.	.*	[^	]*\.cpx/I!d; /	.*	([^\\]{9,})1(\.cpx)/Is//	%SYSDIR:\=\\%\\\1*\2/" temp4400 >temp4401

FOR /F "TOKENS=1*" %%G in ( temp4401 ) DO @(
	PEV -fs32 -rtf -t!o "%%~H" >>catch_k.dat
	ECHO.[hkey_local_machine\software\microsoft\windows nt\currentversion\drivers32]>>CregC.dat
	ECHO."%%~G"="wdmaud.drv">>CregC.dat
	)
@DEL /A/F/Q temp440? N_\* >N_\%random% 2>&1



:STAGE45
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 10000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%46 >WowErr.dat
@Echo:%Stage%46

@>temp450x ECHO.ACPI	EC
@>>temp450x ECHO.asc	3350p
@>>temp450x ECHO.ASP.NET	_1.1.4322
@>>temp450x ECHO.HTTP	Filter
@>>temp450x ECHO.Imapi	Service
@>>temp450x ECHO.NDIS	Tapi
@>>temp450x ECHO.NetDDE	dsdm
@>>temp450x ECHO.PCI	Dump
@>>temp450x ECHO.perc2	hib
@>>temp450x ECHO.sr	service
@>>temp450x ECHO.Winsock	2
@>>temp450x ECHO.Wmi	ApRpl

SED -n -r ":a; $!N; s/^(.*)\n\1(.*)\'/\1	\2/Ip;D" SvcFull >temp4500
FINDSTR -IXVG:temp450x temp4500 >temp4501

FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp4501 ) DO @(
	SWREG QUERY "HKLM\System\CurrentControlSet\Services\%%~G" /v displayname >temp4502
	Sed "/.*	/!d;s///; s/.*/& %%~G%%~H/" temp4502 >temp4503
	SWREG QUERY "HKLM\System\CurrentControlSet\Services\%%~G%%~H" /v displayname >temp4504
	Sed "/.*	/!d;s///" temp4504 >temp4505
	GREP -Fixsqf temp4503 temp4505 &&(
		SED -r "/^%%~G%%~H	(.:\\.*) srv$/I!d;s//\1/" svcdump >temp4506
		GREP -F :\ temp4506 >>CFiles.dat &&ECHO.%%~G%%~H>>zhSvc.dat
		)
	DEL /A/F temp4502 temp4503 temp4504 temp4505 temp4506
	)>N_\%random% 2>&1
DEL /A/F/Q temp450? N_\* >N_\%random% 2>&1


:STAGE46
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 40000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%47 >WowErr.dat
@Echo:%Stage%47

FINDSTR -BIC:"nwsapagent\parameters	%system%\ipxsap.dll" SvcDump >N_\%random% 2>&1 ||(
	FINDSTR -BIC:"nwsapagent\parameters" SvcDump >temp4600
	SED "s/\\.*//" temp4600 | MTEE /+ SvcTargeted >>zhSvc.dat
	DEL /A/F temp4600
	)>N_\%random% 2>&1

FINDSTR -BIC:"nm	%system%\drivers\nmnt.sys" SvcDump >N_\%random% 2>&1 ||(
	FINDSTR -BIC:"nm	" SvcDump >temp4600
	SED "s/	.*//" temp4600 | MTEE /+ SvcTargeted >>zhSvc.dat
	DEL /A/F temp4600
	)>N_\%random% 2>&1


GREP -Fis "%system%\amcompatx.exe" SvcDump >temp4600
SED "s/	.*//"  temp4600 | MTEE /+ SvcTargeted >>zhSvc.dat


Handle .exe >temp4600
SED -r "/^svchost.exe$/I!d; s/.{37}//" temp4600 | MTEE /+ cfiles.dat >temp4601
SED "s/\\/&&/g" temp4601 >temp4602
FOR /F "TOKENS=*" %%G IN ( temp4602 ) DO @(
	GREP -Fis "%%~G" SvcDump >temp4603
	SED "s/	.*//" temp4603 | MTEE /+ SvcTargeted >>zhSvc.dat
	DEL /A/F temp4603
	)>N_\%random% 2>&1
DEL /A/F/Q temp460? N_\* >N_\%random% 2>&1


ECHO.>temp4600
SWREG QUERY hklm\software\winpcap >N_\%random% && IF EXIST "%ProgFiles%\WinPCap\Uninstall.exe" DEL /A/F temp4600
IF EXIST temp4600 (
	ECHO."%ProgFiles%\WinPCap">>CFolders.dat
	ECHO.[-HKEY_LOCAL_MACHINE\SOFTWARE\WinPcap]>>Creg.dat
	ECHO.npf>>zhSvc.dat
	ECHO."%system%\drivers\npf.sys">>Cfiles.dat
	FOR %%G IN (
		"%system%\Packet.dll"
		"%system%\pthreadVC.dll"
		"%system%\WanPacket.dll"
		"%system%\wpcap.dll"
		"%SystemRoot%\Packet.dll"
		"%SystemRoot%\pthreadVC.dll"
		"%SystemRoot%\WanPacket.dll"
		"%SystemRoot%\wpcap.dll"
		"%SystemRoot%\npptools.dll"
		) DO @IF EXIST %%G ECHO.%%G
	 )>>d-delA.dat


ECHO.>temp4600
SWREG QUERY "hklm\software\WinpkFilter Runtime Libraries" >N_\%random% && IF EXIST "%ProgFiles%\WinpkFilter\uninstall.exe" DEL /A/F temp4600
IF EXIST temp4600 (
	ECHO."%ProgFiles%\WinpkFilter">>CFolders.dat
	ECHO.[-HKEY_LOCAL_MACHINE\SOFTWARE\WinpkFilter Runtime Libraries]>>Creg.dat
	REM ECHO.NDISRD>>zhSvc.dat
	REM ECHO."%system%\drivers\ndisrd.sys">>Cfiles.dat
	IF EXIST "%system%\drivers\snetcfg.exe" ECHO."%system%\drivers\snetcfg.exe"
	IF EXIST "%system%\ndisapi.dll" ECHO."%system%\ndisapi.dll"
	 )>>d-delA.dat

PEV SC delete "Windows NT Service32" >N_\%random% 2>&1
PEV SC delete "wincom32" >N_\%random% 2>&1

IF EXIST "%system%\drivers\0000*.sys" (
	FINDSTR -MI "smmsassist" "%system%\drivers\0000*.sys" 2>N_\%random% | MTEE /+ d-delA.dat >temp4600
	SED "s/sys$/dat/I" temp4600 | MTEE /+ Cfiles.dat >temp4601
	SED -r "s/.*\\//; s/.{4}$//" temp4601 | MTEE /+ SvcTargeted >>zhSvc.dat
	DEL /A/F/Q temp460?
	)>N_\%random% 2>&1


PEV -fs32 -rtf -t!o "%system%\drivers\????????.sys" -output:temp4600
FINDSTR -MIF:temp4600 "cdnprot" 2>N_\%random% | MTEE /+ d-delA.dat >temp4601
SED "s/.*\\//; s/.sys$//I" temp4601 | MTEE /+ SvcTargeted >>zhSvc.dat
DEL /A/F/Q temp460? >N_\%random% 2>&1


GREP -Eis "(Pigeon|windbg48|Microsoft.IE.Updater_.|glok+).*	" SvcDump >temp4600
SED "s/	.*//" temp4600 | MTEE /+ SvcTargeted >>zhSvc.dat
SED "s/.*	//" temp4600 >>Cfiles.dat


@IF NOT EXIST cfdummy (
	SWREG ADD HKLM\Software\Swearware\dump\cf_dummy >N_\%random% 2>&1
	SWREG SAVE HKLM\Software\Swearware\dump\cf_dummy cfdummy >N_\%random% 2>&1
	SWREG DELETE HKLM\Software\Swearware\dump\cf_dummy >N_\%random% 2>&1
	)


TYPE zhsvc.dat svc_wht.dat >SvcCovered 2>N_\%random%
GREP -Fixvf SvcCovered SvcFull >suspectSvc.dat

GREP -Eix "WinH[a-z]{3}32|Wa[k-q][a-z]Svc|[a-z]syn[a-z]Svc|MICROSOFT UPDATE[a-z]{3}\.EXE|\.Net CLR[^ ]{0,6}|.|~+|.*[0-9][0-9]ErrorControl.*|[0-9]{3,4}|123[a-z]{3,}|15[a-z]{3,}|AdobeUpdate.*|SecurityCenterServer.*|fuck.*|.*rejoice20.*|Rspdates Apxp.*|Antivirus[^ ]{2,3}|audieqaa.|Levitate.*|Svchest.*|Pageant.*|lsass.*|.*GrayPigeon.*|.lease Input Service.*|Anosso[0-9]|1+|2+|3+|4+|5+|6+|7+|8+|9+|a+|b+|c+|v+|w+|y+|z+|zzz.*|(National|Natisonal|aspnet_states|MSUpdqte|213123123|WMMNetwork|Debug|wuauserv|VMware Service|Microsoft  Device Managers|Future Terminator|DSLserver|Stereo Service|Distribu|remote access connection handlemanager|DSLserver.)[a-z]{3}" suspectSvc.dat | MTEE /+ SvcTargeted >>zhSvc.dat


GREP -Eisx "[a-z]{3,5}[0-9][0-9]" suspectSvc.dat >temp4602 &&(
	FOR /F "TOKENS=*" %%G IN ( temp4602 ) DO @SED -r "/%%~G	%system:\=\\%(\\|\\drivers\\)%%~G.sys/I!d; s/.*	//" SvcDump )>>temp4603

GREP -Eisx "[a-z]{3,5}[0-9][0-9]" LegacyNoSvc >temp4604 &&(
	FOR /F "TOKENS=*" %%G IN ( temp4604 ) DO @@GREP -lsq . "%system%\%%~G.sys" "%system%\drivers\%%~G.sys" )>>temp4603

IF EXIST temp4603 IF NOT EXIST W6432.dat FOR /F "TOKENS=*" %%H IN ( temp4603 ) DO @(
	IF EXIST "%%H" GREP -sq . "%%~H" &&(
		FINDSTR -MIR "windbg48 runtime3.pdb ZwQuerySystemInformation.*KeServiceDescriptorTable" "%%~H" >>d-delA.dat &&ECHO."%%~NH"| SED "s/\x22//g" | MTEE /+ SvcTargeted >>zhSvc.dat
			)||(
		Catchme -l N_\%random% -c "%%~H" "%SystemDrive%\Qoobox\Test\_%%~NXH_"
		IF EXIST "%SystemDrive%\Qoobox\Test\_%%~NXH_" FINDSTR -MIR "windbg48 runtime3.pdb ZwQuerySystemInformation.*KeServiceDescriptorTable" "%SystemDrive%\Qoobox\Test\_%%~NXH_" &&(
			ECHO.[-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\%%~NXH]>>CregC.dat
			ECHO.[-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\%%~NXH]>>CregC.dat
			ECHO.%%~NH| MTEE /+ SvcTargeted >>zhSvc.dat
			ECHO."%%~H">>catch_k.dat
			)
		IF EXIST "%SystemDrive%\Qoobox\Test\_%%~NXH_" DEL /A/F "%SystemDrive%\Qoobox\Test\_%%~NXH_"
		)
	IF NOT EXIST "%%~H" (
		Catchme -l N_\%random% -c "%%~H" "%SystemDrive%\Qoobox\Test\_%%~NXH_"
		IF EXIST "%SystemDrive%\Qoobox\Test\_%%~NXH_" FINDSTR -MIR "windbg48 runtime3.pdb ZwQuerySystemInformation.*KeServiceDescriptorTable" "%SystemDrive%\Qoobox\Test\_%%~NXH_" &&(
			ECHO.[-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\%%~NXH]>>CregC.dat
			ECHO.[-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\%%~NXH]>>CregC.dat
			ECHO.%%~NH| MTEE /+ SvcTargeted >>zhSvc.dat
			ECHO."%%~H">>catch_k.dat
			)
		IF EXIST "%SystemDrive%\Qoobox\Test\_%%~NXH_" DEL /A/F "%SystemDrive%\Qoobox\Test\_%%~NXH_"
		))>N_\%random% 2>&1

DEL /A/F/Q temp460? N_\* >N_\%random% 2>&1


:: ZLOB rooter
SED -r "/^([a-f0-9]{16})	.*\\\1\\\1$/I!d" svcdump >ZlobRoot
FOR /F "TOKENS=1* DELIMS=	" %%G IN ( ZlobRoot ) DO @(
	IF EXIST f_system SWXCACLS "%%~DPH" | FINDSTR -IC:"Owner: S-1-0 " &&SWXCACLS "%%~DPH" /RESET /Q
	FINDSTR -MIL \kinject. "%%~H" >>d-delA.dat &&(
		CALL :REMDIR "%%~DPH" 3
		ECHO.%%G>>zhSvc.dat
		))>N_\%random% 2>&1
DEL /A/F ZlobRoot


::HIPSRV

SED -r "/^windev-.*-[[:alnum:]]*|^vdo_.*-[[:alnum:]]*\]|lrito.*-.*/I!d; s/	.*//" SvcDump | MTEE /+ SvcTargeted >>zhsvc.dat


:DozhSvc
@SET "Services_=HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services"
@SET "Legacy_=HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root"

GREP -Fixvf 023.dat zhsvc.dat > zhsvc.tmp
MOVE /Y zhsvc.tmp zhsvc.dat >N_\%random% 2>&1

SED "y/ /_/" zhsvc.dat >zhLegacy.dat
GREP -Fixf zhLegacy.dat LegacyFull >LegacyTargeted
DEL /A/F zhLegacy.dat >N_\%random% 2>&1

FOR /F "TOKENS=*" %%G IN ( LegacyTargeted ) DO (
	ECHO."-------\Legacy_%%~G">>SvcTarget.dat
	@ECHO.[-HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%~G]>>CregC.dat
	@SWREG EXPORT "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Legacy_%%~G.reg.dat" >N_\%random%
	@ECHO.[-hkey_users\temphive\%CONTROLSET%\enum\root\Legacy_%%~G]>>erunt.dat
	)
DEL /A/F LegacyTargeted >N_\%random% 2>&1


GREP -Fixf zhSvc.dat SvcFull | SED "s/./&/" >>SvcTargeted
SORT/M 65536  SvcTargeted /T %cd% /O temp4601
SED -r "$!N; /^(.*)\n\1$/I!P; D" temp4601 >SvcTargetedB

FOR /F "TOKENS=*" %%G IN ( SvcTargetedB ) DO (
	@SWREG ACL "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G" /RESET /Q
	@IF /I "%%~G" NEQ "IPRIP" ECHO.[-HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G]>>CregC.dat
	ECHO.[-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\%%~G]>>CregC.dat
	ECHO.[-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\%%~G]>>CregC.dat
	@SWREG export "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Service_%%~G.reg.dat" >N_\%random% 2>&1
	@ECHO.[-hkey_users\temphive\%CONTROLSET%\services\%%~G]>>erunt.dat
	@ECHO.-------\Service_%%G>>SvcTarget.dat
	@SWREG ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_Beep\xx_%%~G_xx" /v ConfigFlags /t reg_dword /d 1 >N_\%random% 2>&1
	@SWREG ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_Beep\xx_%%~G_xx" /v Service /d "%%~G" >N_\%random% 2>&1
	@IF /I "%%~G" NEQ "IPRIP" SWREG restore "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G" cfdummy /f >N_\%random% 2>&1
	)

DEL /A/F/Q temp460? N_\* SvcTargeted* >N_\%random% 2>&1
IF EXIST XPRD.NFO GOTO Stage48


@SWREG ACL "HKLM\System\CurrentControlSet\Services\Bits" /RESET /Q
@SWREG ACL "HKLM\System\CurrentControlSet\Services\wuauserv" /RESET /Q
@SWREG ACL "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\browser helper objects" /RESET /Q
@SWREG ACL "hkcr\clsid\{16b770a0-0e87-4278-b748-2460d64a8386}" /RESET /Q
@SWREG ACL "hkcr\clsid\{296AB8C6-FB22-4D17-8834-064E2BA0A6F0}" /RESET /Q

IF EXIST Vista.krl GOTO STAGE47

SED -r "/   appinit_dlls.*	/I!d; s///; /^ |\.dll$/Id" MWindows.dat >appinit.badX
SED -r "/   appinit_dlls.*	/I!d; s///" MWindows.dat >temp4600
GREP -Eisf appinit.bad temp4600 >>appinit.badX
SED -r "/   appinit_dlls.*	/I!d;s///; /.{40}/!d" MWindows.dat >>appinit.badX

GREP -sq . appinit.badX &&(
	@ECHO.[hkey_users\temphive2\microsoft\windows nt\currentversion\windows]>>erunt.dat
	@ECHO."appinit_dlls"=->>erunt.dat
	@ECHO.[hkey_local_machine\software\microsoft\windows nt\currentversion\windows]>>CregC.dat
	@ECHO."appinit_dlls"=->>CregC.dat
	)

@DEL /A/F/Q appinit.bad? temp460? >N_\%random% 2>&1


@(
ECHO.%system%\append.dll
ECHO.%system%\wowfx.dll
ECHO.%system%\xlibgfl254.dll
)>SecProv

FOR /F "TOKENS=*" %%G IN ( SecProv ) DO @IF EXIST "%%~G" @(
		ECHO."%%~G">>catch_k.dat
		CALL :AppndDLL "%%~G" >N_\%random% 2>&1
		)

ECHO.[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders]>>CregC.dat

SWREG QUERY "hklm\system\currentcontrolset\control\securityproviders" /v securityproviders >temp4600
FINDSTR , temp4600 >temp4601
SED -r "/.*	/!d;s///; s/ //g; s/,/\n/g" temp4601 >temp4602
GREP -Eivx "append.dll|wowfx.dll|xlibgfl254.dll|msansspc.dll|snapapi32.dll|digeste.dll|mcenspc.dll|digiwet.dll|msxuqmeq.dll" temp4602 | GREP -i dll$ >temp4603
SED ":a;$!N; s/\n/, /;ta;s/.*/\x22securityproviders\x22=\x22&\x22/" temp4603 >>CregC.dat
DEL /A/F/Q SecProv temp460? >N_\%random% 2>&1


:STAGE47
PEV -k NIRKMD.%cfext%
@Echo:%Stage%48 >WowErr.dat
@Echo:%Stage%48

GREP -Eisq "^Runtime2	" SvcDump &&(
	@SWREG restore "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\runtime2" cfdummy /f >N_\%random% 2>&1
	@ECHO.%system%\drivers\runtime2.sys>>d-del2AA.dat
	)


:: #############################
:: #############################
:: NEW STUFF GOES HERE

SWREG QUERY "HKLM\software\microsoft\windows nt\currentversion\winlogon" /v taskman >temp4700
GREP -isq WLEntryPoint temp4700 &&CALL :EmbedNul >N_\%random% 2>&1


IF EXIST "%ProfilesDirectory%\!\*" PEV -fs32 -rtf -s+262142 "%ProfilesDirectory%\!\ntuser.dat" >N_\%random% 2>&1 &&ECHO."%ProfilesDirectory%\!">>CFolders.dat

SWREG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductId >temp4700
GREP -Fisq "VIRUS" temp4700 &&(
	SED -R "/ +(ProductId)	.*	(\d*-[\dOEM]*-\d*-\d*)$/!d; s//\n[hkey_local_machine\\software\\microsoft\\windows nt\\currentversion]\n\x22\1\x22=\x22\2\x22/" temp4700
	)>>CregC.dat

SWREG QUERY "hkcu\control panel\international_combofixbackup" /v sTimeFormat >temp4700
GREP -Eisq "VIRUS" temp4700 &&SWREG DELETE "hkcu\control panel\international_combofixbackup" /v sTimeFormat

IF EXIST "%system%\{*}.dll" FINDSTR -MIL "Sidebar.dll" "%system%\{*}.dll" >temp4700 2>N_\%random% && SED "s/.*/&\n&-uninst.exe/" temp4700 >>Cfiles.dat

PEV -fs32 -rtd -d:G10 %SystemDrive%\* and -preg"\\00[\da-f]{6}$" -output:temp4700
FOR /F %%G IN ( temp4700 ) DO @(
	PEV -fs32 -tx50000 -tf %%G\* -output:temp4701
	FINDSTR -IR ":\\.*\\.*[a-z.]" temp4701 ||ECHO.%%G>>CFolders.dat
	DEL /A/F temp4701
	)>N_\%random% 2>&1
DEL /A/F/Q temp470? >N_\%random% 2>&1

IF EXIST "%system%\msxml71.dll" PEV -fs32 -rtf -t!o -c##f#b#d# "%system%\msxml71.dll" | SED "/	------$/!d; s///" >>d-delA.dat

IF EXIST "%systemroot%\AppPatch\Facebook.bat" PEV -tx50000 -tf "%systemroot%\Facebook.bat" >>d-delA.dat

PEV -fs32 -rtd -dc:G30 "%system%\*" -output:temp4700
FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @IF EXIST "%%~G\svchost.exe" (
	FINDSTR -MR "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" "%%~G\svchost.exe" ||(
		ECHO.%%~G\svchost.exe>>d-delA.dat
		DIR /A/S/B "%%~G\*" >temp4701
		GREP -c . temp4701 | GREP -sqx 1 &&ECHO.%%G>>d-delB.dat
		DEL /A/F temp4701
		) )>N_\%random% 2>&1

FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @(
	IF EXIST "%%~G\Update\Update.com" CALL :RemDir "%%G" 3
	IF EXIST "%%~G\explorer.exe" CALL :RemDir "%%G"
	IF EXIST "%%~G\smss.exe" CALL :RemDir "%%G"
	IF EXIST "%%~G\csrss.ini" CALL :RemDir "%%G" 3
	)
DEL /A/F/Q temp470? >N_\%random% 2>&1



DIR /A-D/S/B "%system%\wins\svchost.exe" >temp4700 2>N_\%random% &&(
	ECHO."%system%\wins">>SearchMetoo.dat
	FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @FINDSTR -MR "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" "%%~G" ||(
			ECHO.%%G>>d-delA.dat
			DIR /A-D/S/B "%%~DPG*" >temp4701
			GREP -c . temp4701 | GREP -sqx 1 &&ECHO."%%~DPG"|SED -r "s/(.*)\\/\1/" >>d-delB.dat
			DEL /A/F temp4701
			) )>N_\%random% 2>&1



PEV -fs32 -rtf -t!o -s-46000 -d=2008-04-14 "%system%\????????*.dll" -output:temp4700
PEV -fs32 -rtf -t!o -s+241000 -s-248000 -d=2008-04-14 "%system%\????????*.dll" >>temp4700
FINDSTR -VILXG:v_wht.dat temp4700 >temp4703
FOR /F "TOKENS=*" %%G IN ( temp4703 ) DO @GSAR -s:x22:x22:x22:x22:x22:x22:x22:x2293 "%%~G" >>temp4704 2>N_\%random%
IF EXIST temp4704 SED -R "/: \d+ match found$/!d; s///" temp4704 >>d-delA.dat
DEL /A/F/Q temp470? >N_\%random% 2>&1


PEV -fs32 -rtf -t!o -s-3000000 -d:G30 "%SystemRoot%\[a-z]*[0-9].exe" -output:temp4700 &&(
	GREP -E \\[a-z]{4,5}[0-9]{4,5}.exe temp4700 >temp4701
	PEV -fs32 -rtf -t!o -s-100000 -d:G30 "%system%\??????????*.exe" -output:temp4700
	FINDSTR -E \\[-a-z0-9]*\.exe temp4700 >>temp4701
	FINDSTR -MF:temp4701 NullsoftInst >>d-delA.dat
	)2>N_\%random%

PEV -fs32 -rtf -s-1000000 -d:G60 "%ProgFiles%\Mozilla Firefox\components\*-*-*-*-*.dll" -output:temp4700 &&(
	FINDSTR -MIF:temp4700 "F.i.l.e.V.e.r.s.i.o.n.....4.,. .6.,. .4.,. .7" )>>d-delA.dat 2>N_\%random%

PEV -fs32 -rtf -t!o -t!p -s-11500 -dG120 and { "%system%\*" or "%SystemRoot%\*" or "%SystemDrive%\*" }  AND { *.exe or *.dll } -output:temp4700
FINDSTR -MIF:temp4700 "Blocked.by.Trend.Micro <!DOCTYPE.HTML.PUBLIC <title>Kaspersky <title>ESET.Smart.Security <title>OpenDNS<.title> Trend.Micro.Incorporated h.t.t.p.:.....w.w.w.\..b.i.t.d.e.f.e.n.d.e.r uploading\.net\/?c" >>d-delA.dat 2>N_\%random%

PEV -fs32 -rtf -t!o -dcG30 and { -s=143360 or -s=147456 } and { "%SystemRoot%\system\*" or "%CommonProgFiles%\*" or "%SystemRoot%\*" or "%SystemRoot%\inf\*" or "%SystemRoot%\config\*" or "%system%\*" } and -preg"\\.{3,7}\.exe" -output:temp4700
FINDSTR -MF:temp4700 "a.r.q.u.i.v.o.s.\..e.x.e" >>d-delA.dat 2>N_\%random%



@(
ECHO.26D4FEA8F96FCDCBCC629E7C68D52139
ECHO.768466EA2059580A84F9C0E68D94C644
)>vbs.md5
PEV -fs32 -rtf -md5list:vbs.md5 %system%\*.vbs >>d-delA.dat
DEL /A/F vbs.md5

REM PEV -fs32 -rtf -t!o -tl -s+16000 -s-30000 "%system%\..\*" or "%temp%\..\*" and not { *.com or *.dll or *.pif or *.scr or *.sys or *.exe or *.bin or *.dat or *.drv } -output:temp4700
REM FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @GREP -El "gmer.*bat|O.L.E.3.2. .E.x.t.e.n.s.i.o.n.s. .f.o.r. .W.i.n.3.2|F.i.l.e.D.e.s.c.r.i.p.t.i.o.n.{4,5}[a-z]{32,33}.{3,5}D.....V.a.r.F.i.l.e.I.n.f.o|8Saveu......j.......Ph....j........~........8Mailu" %%~SG >>d-delA.dat 2>N_\%random%

@(
ECHO.390D60C921D418E4CA3F6DD7B111DAA7
ECHO.44F2ADCAA8F1F0D44FB4BE10C69D2C6A
ECHO.4DFA838FEF5927A8D29605524BF3AA51
ECHO.7886BF8E0601DD783B4F0B0717964319
ECHO.8320E8DACC4FBD47CDFB4EA9E4727441
ECHO.86565F587D128266C60C386DA0AB12CF
ECHO.BB03163356C271EAA81797CECF0D394E
ECHO.C45FF85B8D7A42462B0A1F3BFE77126A
ECHO.CE85AA1A4ED0A297059BE80F6182CC11
)>temp4700
PEV -fs32 -rtf -md5listtemp4700 { -s+217300 -s-276000 or -s+207500 -s-212000 } %system%\*.exe >>d-delA.dat


PEV -fs32 -thf -t!o "%system%\????????*.core.dll" -output:temp4700
SED -r "/%system:\=\\%\\\.([^\\]{8,})\\\1.core.dll$/I!d" temp4700 >temp4701
FOR /F "TOKENS=*" %%G IN ( temp4701 ) DO @FINDSTR -MRI "core\.dll <.SafeArrayDestroy..O.SetErrorInfo" "%%~G" >>d-delA.dat 2>N_\%random% &&CALL :REMDIR "%%~DPG*" 6 >N_\%random% 2>&1


PEV -fs32 -tx40000 -rtf -t!o -t!g -tpmz -DG3M -s+30000 -s-40000 %system%\drivers\???????.sys and *[0-9]*.sys | SED -r "/\\[^\\[A-Z]*\.sys$/!d; :a; $!N; s/\n/\x22 \x22/; ta; s/.*/\x22&\x22/" >temp4700
FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @GSAR -bs:xCC:xCC:xCC:x60:xB8:x00:x02:x01:x00:xBB:xB0:x8C:x01:x00:xB9 %%G 2>&1 | SED "/: 0x8cbd/!d; s///" >>d-delA.dat

PEV -fs32 -tx50000 -tf "%ProgFiles%\Mozilla Firefox\extensions\overlay.xul" | SED "/}\\chrome\\content\\overlay.xul$/I!d; s//}/" >temp4700
FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @IF EXIST "%%~G\install.rdf" FINDSTR -IR "em:hidden[>=].*true" "%%~G\install.rdf" >N_\%random% 2>&1 &&ECHO.%%G>>CFolders.dat


PEV -fs32 -t!o -dG30 -s+41300 -s-42500 -tx50000 -tf -ts -th "%ProgFiles%\*.exe" and -preg"%ProgFiles:\=\\%\\[^\\]*\\[^\\]*$" | FINDSTR -MRF:/ "UFKTUDNNCQPAZ...ftitffzwmpfda" >temp4700 &&(
	TYPE temp4700 >>d-delA.dat
	FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @CALL :REMDIR "%%~DPG" 2
	)>N_\%random% 2>&1

PEV -fs32 -dcG30 -tx50000 -tf "%ProgFiles%\*" and -preg"%ProgFiles:\=\\%\\[^\\]{6}\\[^\\]*(sysguard|sftav)\.exe(\d|)*$" -output:temp4700 &&(
	TYPE temp4700 >>d-delA.dat
	FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @CALL :REMDIR "%%~DPG"
	)>N_\%random% 2>&1


PEV -fs32 -rthsd "%CommonAppData%\*" -output:temp4700
PEV -fs32 -tx50000 -tf -dcg30 "%CommonAppData%\*" and { -preg"%CommonAppdata:\=\\%\\([\da-g]{4,})[\da-g]*\\([a-z]{2,4}\1[^\\]*|aasolution|bestantivirus).exe$" } or -preg"%CommonAppData:\=\\%\\[\da-f]*\d[\da-f]*\\[^\\]*Sys(|tem[^\\]*)\\vd952342\.bd$" -output:temp4701 &&(
	SED -r "s/(%CommonAppData:\=\\%\\[^\\]*).*/\1/I" temp4701 >>CFolders.dat
	FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @IF EXIST "%%~G\*.CFG" CALL :REMDIR "%%~DPG"
	)

FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @(
	IF EXIST "%%~G\*.exe" FINDSTR -MIR "A.V.P...I.n.c S.e.c.u.r.i.t.y...W.a.l.l...I.n.c L.i.v.e...P.C.\." "%%~G\*.exe" &&ECHO.%%G>>CFolders.dat
	IF EXIST "%%~G\*.mof" FINDSTR -IRC:"companyName = .AVP Inc" "%%~G\*.mof"  &&ECHO.%%G>>CFolders.dat
	)>N_\%random% 2>&1

PEV -fs32 -t!pmz -dcG30 -tx50000 -tf "%CommonAppData%\*" and -preg"%CommonAppData:\=\\%\\[^\\]*\\Cua.ico$" and -preg"%CommonAppData:\=\\%\\.*\d.*\\.*" -output:temp4701
PEV -fs32 -ths -t!pmz -dcG30 -tx50000 -tf "%CommonAppData%\*" and -preg"%CommonAppData:\=\\%\\CU[^\\]*\\CU[^\\]*.cfg$" >>temp4701
PEV -tx50000 -tf -t!k -t!o "%CommonAppData%\*" -preg"%CommonAppData:\=\\%\\([^\\]{8,})\\\1.exe$" >>temp4701
FOR /F "TOKENS=*" %%G IN ( temp4701 ) DO @CALL :REMDIR "%%~DPG" 2

:: fakeAV
PEV -dcg30 -t!o -tx50000 -tpmz "%CommonAppData%\?????????????????.exe" -preg"%CommonAppData:\=\\%\\(\D\D(\d{3,}).*\2)\\\1.exe$" | SED "s/\\[^\\]*$//" >>CFolders.dat

DEL /A/F/Q temp470? >N_\%random% 2>&1

:: MultiPlug
PEV -rtd -dcG60 "%CommonAppData%\*" -output:temp4700
PEV -rtd -dcG60 "%ProgFiles%\*" >>temp4700
IF EXIST MultiPlug00 DEL /A/F MultiPlug00 >N_\%random% 2>&1
FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @IF EXIST "%%~G\*.tlb" (
	FOR %%H IN ( "%%~G\*.tlb" ) DO @IF EXIST "%%~DPNH.dat" (
		GREP -Fisq "%%~NH.dll" "%%~DPNH.dat" && ECHO."%%~G">>MultiPlug00
		GREP -Eisq "+.*+.*+.*+.*+.*+.*+.*+.*+.*+.*" "%%~DPNH.dat" && GREP -Eisq "IEPluginStorage.*Encrypted" "%%~DPNH.tlb" && ECHO."%%~G">>CFolders.dat && IF EXIST "%CommonAppData%\%%~NXG\" ECHO."%CommonAppData%\%%~NXG">>MultiPlug00
	) ELSE IF EXIST "%%~G\settings.ini" (
		IF EXIST "%%~G\data\%%~NXG.dat" (
			IF EXIST "%%~DPNH.dll" ECHO."%%~G">>MultiPlug00
			) ELSE FINDSTR -MI "uninstall\.justplug\.it jpiproxy\.co\.il japproxy\.net jpionline\.co\.il syncjpionline\.co\.il syncerjpi\.com jpisync\.co\.il" "%%~G\settings.ini" >N_\%random% 2>&1 && ECHO."%%~G">>CFolders.dat
		))

IF EXIST MultiPlug00 (
	TYPE MultiPlug00 >>CFolders.dat
	SED -r "/:\\/!d; s/\x22//g; s/.*\\//;" MultiPlug00 > MultiPlug01
	SORT /M 65536 MultiPlug01 /T %cd% /O MultiPlug02
	SED -r "$!N; /^(.*)\n\1$/I!P; D" MultiPlug02 > MultiPlug03
	GREP -sq .. MultiPlug03 &&(
		FOR /F "TOKENS=*" %%G IN ( profiles.folder.dat ) DO @IF EXIST "%%~G\AppData\LocalLow\" (
			PEV -tf -dcG60 "%%~G\AppData\LocalLow\*.?.*.dat" > MultiPlug04
			GREP -Fif MultiPlug03 MultiPlug04 > MultiPlug05
			SED -r "/(.*\\AppData\\LocalLow\\\{[^\\]*)\\[^\\]*$/I!d; s//\1/; " MultiPlug05 >>CFolders.dat
			)
		FOR /F "TOKENS=*" %%G IN ( LocalAppData.folder.dat ) DO @IF EXIST "%%~G\Packages\windows_ie_ac_001\AC\" (
			PEV -tf -dcG60 "%%~G\Packages\windows_ie_ac_001\AC\*.?.*.dat" > MultiPlug04
			GREP -Fif MultiPlug03 MultiPlug04 > MultiPlug05
			SED -r "/(.*\\Packages\\windows_ie_ac_001\\AC\\\{[^\\]*)\\[^\\]*$/I!d; s//\1/; " MultiPlug05 >>CFolders.dat
			)
			)
	DEL /A/F/Q MultiPlug0?
	)>N_\%random% 2>&1

DEL /A/F/Q temp470?  >N_\%random% 2>&1



IF DEFINED Fonts (
	PEV -fs32 -rtf -s-1751 "%Fonts%\*" and { *.fon or *.dll or *.ttf or *.nls } >>d-delA.dat
	PEV -fs32 -rtf -tpmz "%Fonts%\*" and { *.ttf or *.exe or *.sys or *.com or *.tif } >>d-delA.dat
	PEV -fs32 -rtf -s+1750 -s-10000 "%Fonts%\????????*.ttf" -output:temp4700
	FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @FINDSTR -M "                       " "%%G" >N_\%random% 2>&1 ||ECHO.%%G>>d-delA.dat
	DEL /A/F temp4700
	)

PEV -fs32 -rtf -dG30 and { "%SystemRoot%\*" or "%system%\*" or "%CommonProgFiles%\*" } and { *.inf or *.bat or *.vbs or *.log } | FINDSTR -MRF:/ "                       " >>d-delA.dat 2>N_\%random%

rem PEV -fs32 -rtf -t!o -s+1008000 -s-1200000 %system%\[!aeiou][aeiou][!aeiou][aeiou][!aeiou][aeiou][!aeiou][aeiou].exe | FINDSTR -MRF:/ "bestprotectant.com sisa.exe T:\\o\\i386\\d\.pdb antivirusread.com seesinspect.com" >>d-delA.dat 2>N_\%random%
PEV -fs32 -rtf -t!o -tp -t!k %system%\[!aeiou][aeiou][!aeiou][aeiou][!aeiou][aeiou][!aeiou][aeiou].exe >>d-delA.dat
PEV -fs32 -rtf -tsh -t!o -tp  -tk -tj -c##f#bc:#d#k# { "%system%\*" or "%SystemRoot%\*" } and [!aeiou][aeiou][!aeiou][aeiou][!aeiou][aeiou][!aeiou][aeiou].exe | SED -r "/	c:(-{12}|)$/!d; s///" >>d-delA.dat


REM SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows NT x86\Print Processors" /s > temp4700
REM SED -r "/^  +Driver	.*	/I!d; s//\\/" temp4700 > temp4701
REM ECHO.::::>> temp4701
REM PEV -fs32 -t!o -t!g -rtf -tpmz %system%\spool\prtprocs\w32x86\*.dll not cnmp???.dll | FINDSTR -VIEG:temp4701 >>d-delA.dat 2>N_\%random%
REM DEL /A/F/Q temp470? >N_\%random% 2>&1


PEV -dcg30 -rtpmz "%system%\*" -preg"\\[0-9a-f]{21}$" | Findstr -LMF:/ "QuerySystemInformation"  >>d-delA.dat 2>N_\%random%

SWREG QUERY "HKCU\Software\VB and VBA Program Settings" /S >temp4700
SED "/./{H;$!d;};x;/linkbucks\.com\/url/!d;" temp4700 >temp4701
SED "/^HKEY_/!d; s/.*/[-&]/" temp4701 >>Creg.dat
SED -r "/.*	(.:\\.*\.exe)$/I!d; s//\1/" temp4701 >temp4702
ECHO.::::>>temp4702
PEV -filestemp4702 -tx50000 -tf -c##f#b#d#i#k# >temp4703
SED -r "/	(.*)\1\1\.exe$/I!d; s///" temp4703 >>d-delA.dat

SED -r "/^(.*)\\parameters	(.*\\\1\\\1\....)$/I!d; s//\2/" SvcDump >temp4700
ECHO.::::>>temp4700
PEV -filestemp4700 -t!g -t!o -c##f#b#d#i#k#g#b#y# | SED -r "/	-{24}	|	.*	0x00000000/!d; s/	.*//" >>d-delA.dat

PEV -dcg30 -dg30 -tx50000 -tf -s+1500000 "%systemroot%\*" -preg"%systemroot:\=\\%\\[A-Z]{3}\\[A-Z]{3}.vbe$" -skip"%systemroot%\winsxs" | MTEE temp4700 >>d-delA.dat
PEV -dcg30 -dg30 -tx50000 -tf "%systemroot%\*" -preg"%systemroot:\=\\%\\[A-Z]{3}\\smss.exe$" -skip"%systemroot%\winsxs" | MTEE /+ temp4700 >>d-delA.dat
SED -r "/\\[^\\]*$/!d; s///" temp4700 > temp4701
FOR /F "TOKENS=*" %%G IN ( temp4701 ) DO @CALL :REMDIR "%%G"
DEL /A/F/Q temp470? >N_\%random% 2>&1


IF EXIST "%system%\themed32.dll" GREP -Fisq "themed32.dll" "%system%\uxtheme.dll" &&(
	%KMD% /D /C MoveIt.bat "%system%\uxtheme.dll"  >N_\%random% 2>&1
	CALL :ND_sub "%system%\uxtheme.dll"
	)

PEV -rtp -t!g -t!o "%systemroot%\*" -preg"\\[^.]{6,8}$" and { -t!k or -t!j } >>d-delA.dat
PEV -fs32 -rtf -tpmz -t!o -s8000-16000 -dcg30 "%system%\*[0-9][0-9]*.sys" | FINDSTR -MIF:/ "\\.?.?.\\.C.:.\\.A.r.q.u.i.v.o.s...d.e. .p.r.o.g.r.a.m.a.s.\\.g.b.p.l.u.g.i.n.\\.G.b.p.S.v...e.x.e" >>d-delA.dat 2>N_\%random%
IF EXIST "%temp%\srv???.tmp" PEV -rtf -tcshw "%temp%\srv???.tmp" >>d-delA.dat

IF EXIST "%System%\*.dll.???*" PEV -rtf -t!o "%System%\*.dll.[0-9]??*" -preg"\\(comres|ddraw|dsound|ksuser|olepro32)\.dll.\d{3,}" >>d-delA.dat
IF EXIST "%ProgFiles%\Unlocker\UnlockerAssistant.exe" FINDSTR -MIR "!Require Windows..$PE" "%ProgFiles%\Unlocker\UnlockerAssistant.exe" >>d-delA.dat 2>N_\%random%
IF EXIST "%CommonStartUp%\*.vbs" FINDSTR -MIL "360Safe\SpyerDate" "%CommonStartUp%\*.vbs" >>d-delA.dat 2>N_\%random%
IF EXIST "%ProgFiles%\Arquivos comuns\*" PEV -tx50000 -tf -dcg30 -tpmz -s200000-800000 "%ProgFiles%\Arquivos comuns\*" -preg"%ProgFiles:\=\\%\\Arquivos comuns\\[^\\]*\\0{5}.{5,}\.exe.*" >>d-delA.dat 2>N_\%random%
IF EXIST "%systemdrive%\Program Files\Arquivos comuns\Flash Player\*" PEV -rtf -t!o -tpmz "%systemdrive%\Program Files\Arquivos comuns\Flash Player\*" | FINDSTR -MF:/ -C:"AutoIt script" >>d-delA.dat 2>N_\%random%

PEV -fs32 -tpmz -tx50000 -tf "%systemroot%\assembly\temp\*" and -preg"%systemroot:\=\\%\\assembly\\temp\\[a-f0-9]{8,}\\(X|U\\[0-9]{5,}[^\\]*.@)$" -output:ZA00
TYPE ZA00 >>d-delA.dat
FOR /F "TOKENS=*" %%G IN ( ZA00 ) DO @CALL :REMDIR "%%~DPG" 4
DEL /A/F ZA00 >N_\%random% 2>&1


:: stupid Chinese random folders. Keep till 2012/01/01
PEV -rtd -DCG30 "%Progfiles%\*" -output:temp4700
FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @IF EXIST "%%G\reginfo.xml" IF EXIST "%%G\temp0*.ini" IF EXIST "%%G\un0*.exe" ECHO."%%G">>CFolders.dat
DEL /A/F/Q temp470?

:: remove next 4 lines after 2012/03/25
PEV -t!o -tx50000 -tf -dcg30 "%Systemroot%\Media\*0[0-4][0-9]-md[0-4]" -preg"%Systemroot:\=\\%\\Media\\[^\\]{7}\\[^\\]*$" | SED -r "/\\[A-Z][a-z]*[A-Z]\\[^\\]*$/!d; s/\\[^\\]*$//" >>CFolders.dat
PEV -t!o -tx50000 -tf "%SystemDrive%\ProgramData\*0[0-4][0-9]-md[0-9]" -preg"%SystemDrive:\=\\%\\ProgramData\\[^\\]{7}\\[^\\]{7}\\[^\\]*$" | SED -r "/\\[A-Z][a-z]*[A-Z]\\[A-Z][a-z]*[A-Z]\\[^\\]*$/!d; s/\\[^\\]*\\[^\\]*$//"  >>CFolders.dat
IF EXIST "%SystemDrive%\ProgramData\*" IF NOT EXIST Vista.krl PEV -t!o -tx50000 -td -dcg30 "%SystemDrive%\ProgramData\*" -preg"%SystemDrive:\=\\%\\ProgramData\\[^\\]{7}\\[^\\]{7}$" | SED -r "/\\[A-Z][a-z]*[A-Z]\\[A-Z][a-z]*[A-Z]$/!d; s/\\[^\\]*$//" >>CFolders.dat
PEV -t!o -tx50000 -tf "%SystemDrive%\Arquivos de programas\*0[0-4][0-9]-md[0-9]" -preg"%SystemDrive:\=\\%\\Arquivos de programas\\[^\\]{7}\\[^\\]{7}\\[^\\]*$" | SED -r "/\\[A-Z][a-z]*[A-Z]\\[A-Z][a-z]*[A-Z]\\[^\\]*$/!d; s/\\[^\\]*\\[^\\]*$//"  >>CFolders.dat
IF EXIST "%SystemDrive%\Arquivos de programas\*" PEV -t!o -tx50000 -td -dcg30 "%SystemDrive%\Arquivos de programas\*" -preg"%SystemDrive:\=\\%\\Arquivos de programas\\[^\\]{7}\\[^\\]{7}$" | SED -r "/\\[A-Z][a-z]*[A-Z]\\[A-Z][a-z]*[A-Z]$/!d; s/\\[^\\]*$//" >>CFolders.dat
PEV -rtf -tpmz -dcg30 -t!o -s+240000 "%systemroot%\[a-z][a-z][a-z][a-z][a-z][a-z][a-z]"  | SED -r "/\\[A-Z][a-z]*[A-Z]$/!d;" >>d-delA.dat
PEV -dcg30 -s-3072 -rtf -t!o -t!pMZ "%systemdrive%\???????????????.tmp[0-9]" >>d-delA.dat
IF EXIST "%ProgFiles%\Arquivos comuns" IF /I "%CommonProgFiles%" NEQ "%ProgFiles%\Arquivos comuns" (
	PEV -t!o -tx50000 -tf -dcg30 "%ProgFiles%\Arquivos comuns\*" -preg"%ProgFiles:\=\\%\\Arquivos comuns\\[^\\]{7}\\[^\\]{7}\.exe$" | SED "/\\[A-Z][a-z]*[A-Z]\\[A-Z][a-z]*[A-Z]\....$/!d
	)>>d-delA.dat

PEV -fs32 -c##f#b#d#k# -tpmz -tx50000 -tf "%CommonAppdata%\*" and -preg"%CommonAppdata:\=\\%\\\{[^\\]*\}\\[a-z]{6}.bin$" |  SED -r "/	-{12}$/!d; s///" | FINDSTR -MF:/ "ZwDeviceIoControlFile" 2>N_\%random% | SED -r "s/\\[^\\]*$//;" >>CFolders.dat
PEV -rtf -s16000-36000 -t!o -t!g %system%\drivers\vbma????.sys and *[0-9]*.sys -c##f#b#d#i#k# | SED -r "/	-{18}$/!d; s///" >>d-delA.dat
PEV -rtf -tpmz { "%progfiles%\Internet Explorer\*" or "%progfiles%\Application\*" or "%systemroot%\media\*" } and -preg"\\[0-9a-f]{16,}$" >>d-delA.dat
PEV -rt!g -t!o -tpmz -t!k -c##f#b#k# "%system%\drivers\sst*.sys" | SED -r "/	volsnap\.sys$/I!d; s///" >>d-delA.dat
IF NOT EXIST Vista.krl PEV -rthsf -tp -t!o -c##f#b#d#i#k#g#o#j#l#e#q# "%system%\*[0-9]*.ocx" | SED -r "/	-{54}$/!d; s///" >>d-delA.dat
PEV -tx50000 -tf -t!g -t!o -tp "%systemroot%\security\Database\*" >>d-delA.dat
PEV -tx50000 -tf -t!g -t!o -tp "%systemroot%\security\MiniDump\*" >>d-delA.dat

PEV -rtf -tp "%systemroot%\????.flv" and *[0-9]*.flv >>d-delA.dat &&(
	PEV -rtf -s200000-260000 "%systemroot%\????.exe" and *[0-9]*.exe | FINDSTR -MLF:/ BHO.dll
	)>>d-delA.dat 2>N_\%random%

:: Ardamax
PEV -rtd -dcg30 %system%\* -preg"%system:\=\\%\\[a-z]{6}$" | SED "/\\[A-Z]*$/!d" >temp4700
FOR /F "TOKENS=*" %%G IN ( temp4700 ) DO @IF EXIST "%%~G\AKV.exe" IF EXIST "%%~G\*.00?" (
	ECHO.%%~G\AKV.exe
	PEV -rtf "%%~G\*.00?"
	)>>d-delA.dat
DEL /A/F/Q temp470? >N_\%random% 2>&1


PEV -fs32 -t!o -dcg30 -rtd "%ProgFiles%\*" -output:Bifrost.dat
FOR /F "TOKENS=*" %%G IN ( Bifrost.dat ) DO @IF EXIST "%%~G\logg.dat" CALL :RemDir "%%~G" 2
DEL Bifrost.dat


:: # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:: # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:: # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:: # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


:STAGE48
PEV.exe -k *.%cfExt% and not %Comspec%
@Echo:%Stage%49 >WowErr.dat
@Echo:%Stage%49

IF EXIST DirRoot (
	GREP -Fiv ":\QooBox" DirRoot >>d-delA.dat

	GREP -Eisq "\\_*desktop_*(1|2|).ini$" DirRoot &&IF EXIST Drives.dat (
		FOR /F "TOKENS=*" %%G IN ( Drives.dat ) DO @VOL %%G: &&@(
			PEV -fs32 -tx50000 -tf -s+82439 %%G:\*.exe  -skip"%SystemRoot%" -skip"%systemdrive%\QooBox" -skip"%cd%" >>FujackFiles00
			IF NOT EXIST %%G:\QooBox\BackEnv\ PEV -fs32 -t!o -tx50000 -tf %%G:\* and { _desktop.ini or desktop_.ini or cnsmin* or _install.exe or  desktop_[12].ini or "%computername%.eml" or readme.eml } or { -s+40000 ws2help.dll } >>d-delA.dat
			)
		FOR /F "TOKENS=*" %%Z IN ( FujackFiles00) DO @GSAR -bs:x2E:x6E:x73:x70:x30:x00:x00:x00:x00:xB0:x04:x00:x00:x10:x00:x00:x00:x00:x00:x00:x00:x04:x00:x00:x50:x45:x43:x32:x4D:x4F:x00:x00:x00:x00:x00:x00:x60:x00:x00:xE0:x2E:x6E:x73:x70:x31:x00:x00:x00:x8D:x3A:x01:x00:x00:xC0:x04:x00:x00:x28:x01:x00:x00:x04 "%%~Z" >>temp4800
		SED "/: 0x1f8/!d; s///" temp4800 >>d-delA.dat
		DEL /A/F/Q FujackFiles* temp4800
		)

	GREP -Eisq "\\ws2help\.dll$" DirRoot &&IF EXIST Drives.dat FOR /F "TOKENS=*" %%G IN ( Drives.dat ) DO @VOL %%G: &&@IF NOT EXIST %%G:\QooBox\BackEnv\ PEV -fs32 -tx50000 -tf %%G:\* and { _desktop.ini or desktop_.ini or cnsmin* or _install.exe or  desktop_[12].ini or "%computername%.eml" or readme.eml } or { -s+40000 ws2help.dll } >>d-delA.dat

	DEL /A/F DirRoot
	)>N_\%random% 2>&1


IF EXIST %systemdrive%\*.exe FINDSTR "imissyou@btamail.net.cn www.EEF2BD52-9BCC-43a6-BE3.com www.3-0B6F-415d-B5C7-832F0.com http://vguarder\.91i\.net cmt\.exe.CONFIG\.exe..boottemp\.exe" %systemdrive%\*.exe >Sality00
PEV -fs32 -rtf %system%\* and { runouce.exe or cryptcom.dll or Serverx.exe } >>Sality00
GREP -Fsq :\ Sality00 &&(
	IF EXIST Drives.dat (
		FOR /F "TOKENS=*" %%G IN ( Drives.dat ) DO @VOL %%G: &&@(
			PEV -fs32 -t!o -tx50000 -tf %%G:\* and { *.exe or *.scr or *.com } -skip"%SystemRoot%" -skip"%systemdrive%\QooBox" -skip"%cd%" >>Sality01
			IF NOT EXIST %%G:\QooBox\BackEnv\ PEV -fs32 -t!o -tx50000 -tf %%G:\* and { _desktop.ini or desktop_.ini or cnsmin* or _install.exe or  desktop_[12].ini or "%computername%.eml" or readme.eml } >>d-delA.dat
			)
		FINDSTR -MRF:Sality01 "imissyou@btamail.net.cn www.EEF2BD52-9BCC-43a6-BE3.com www.3-0B6F-415d-B5C7-832F0.com http://vguarder\.91i\.net cmt\.exe.CONFIG\.exe..boottemp\.exe" >>d-delA.dat
		DEL /A/F/Q Sality01
		))>N_\%random% 2>&1
DEL /A/F Sality00 >N_\%random% 2>&1


IF EXIST "%system%\dllcache\lsasvc.dll" IF EXIST Drives.dat (
	FOR /F "TOKENS=*" %%G IN ( Drives.dat ) DO @VOL %%G: &&@PEV -fs32 -t!o -tx50000 -tf -s+27112 %%G:\*.exe -skip"%SystemRoot%" -skip"%systemdrive%\QooBox" -skip"%cd%" >>FujackFilesB00
	FINDSTR -MRF:FujackFilesB00 "GetTempPathA.CloseHandle.Expor.exe.CreateFileA" >>d-delA.dat
	DEL /A/F/Q FujackFilesB00
	)>N_\%random% 2>&1


REM IF EXIST FSmoke.dat
PEV -fs32 -t!k -t!o -rtp %system%\Drivers\* and { *.exe or *.dll } | GREP -c . | GREP -sqx [0-9] || CALL :FSmoke

IF EXIST "%system%\*.exe.vbs" FOR /F "TOKENS=*" %%G IN ( Drives.dat ) DO @(
	VOL %%G: &&@PEV -fs32 -t!o -tx50000 -tf -dg30 -s-650 %%G:\*.exe.vbs | Findstr -MIF:/ "dodo\.vbs" >>d-delA.dat
	)>N_\%random% 2>&1


IF EXIST "%ProgFiles%\eMule\Incoming\*.zip" PEV -dcg30 -s50000-150000 -rtf -limit500 "%ProgFiles%\eMule\Incoming\*.zip" | GREP -c . | GREP -sqx 500 &&CALL :EMULE


:STAGE49
START NIRKMD CMDWAIT 17000 EXEC HIDE PEV.exe -k *.%cfExt% and not %Comspec%
@IF NOT EXIST XPRD.NFO (
@Echo:%Stage%50 >WowErr.dat
@Echo:%Stage%50
)


IF EXIST RenVDel.dat (
	SORT /M 65536 RenVDel.dat /T %cd% /O temp4900
	SED -r "$!N; /^(.*)\n\1$/I!P; D" temp4900 >>d-delA.dat
	)
@ECHO.::::>>d-delA.dat

IF EXIST "%tasks%\{*-*-*}.job" (
	FINDSTR ":.\\."  "%systemroot%\tasks\{*-*-*}.job" | SED -r "s/[^ -~]{2,}/ /Ig; s/[^ -~]//Ig; /.*(%systemroot:\=\\%\\[a-z]{5,6}\.exe).*/I!d; s//\1/" >temp4901
	ECHO.::::::::>>temp4901
	PEV -rt!g -files:temp4901 >>d-delA.dat
	DEL /A/F/Q temp490?
	)>N_\%random% 2>&1

IF EXIST "%tasks%\at*.job" (
	FINDSTR ":.\\."  "%tasks%\at*.job" | SED "s/[^ -~]//Ig" >temp4901
	SED "s/\x22//g; /^$/d" d-del*A* | FINDSTR . >temp490X || ECHO.::\::\::>>temp490X
	GREP -Fif temp490X temp4901 | SED -r "s/^(....[^:]*):.*/\1/" >>d-delA.dat
	DEL /A/F/Q temp490?
	)>N_\%random% 2>&1



IF NOT EXIST DoStepDel CALL :REMDIR_A >N_\%random% 2>&1

IF EXIST "\System Volume Information\" IF EXIST Whistler.dat (
	IF EXIST F_system SWXCACLS "\System Volume Information\"  /E /GA:F /Q
	PEV -rtd -dcg30 "%systemdrive%\System Volume Information\*" and not -preg"\\(_restore[^\\]*|SPP|EfaData|catalog.wci|WindowsImageBackup|Windows Backup)$"  >>CFolders.dat
	)

PEV -fs32 -td "%SystemRoot%\* " -skip"%SystemRoot%\winsxs" | SED "s/.*/\x22&\x22/" >>CFolders.dat
SED -r "s/^\s*//; s/\s*$//; s/\x22//g; /^.:\\/!d; s/\\\\+/\\/g; s/\\$//; /^.:\\/!d; /%systemdrive%\\Qoobox(\\|$)/Id" CFolders.dat >temp4900
GREP -Fixvf dnd.dat temp4900 | GREP -Fixvf whiteAll.dat >temp4901
ECHO.:::::>>temp4901
PEV -filestemp4901 -td -rt!e -output:temp4902
FOR /F "TOKENS=*" %%G IN ( temp4902 ) DO @IF EXIST "%%~G\" (
	ECHO."%%~G">>d-delB.dat
	PEV -fs32 -tx50000 -tf "%%~G\*">>d-delA.dat
	)
DEL /A/F/Q temp490? N_\* >N_\%random% 2>&1

IF DEFINED Fonts IF EXIST "%fonts%\'" ECHO."%fonts%\'">>d-del2B.dat
IF DEFINED Fonts IF EXIST "%fonts%\-" ECHO."%fonts%\-">>d-del2B.dat

SED -r "s/^\s*//g; s/\s*$//g" Cfiles.dat >temp4900
PEV -t!o -tx50000 -tf -filestemp4900 >>d-delA.dat
DEL /A/F/Q temp490? N_\* >N_\%random% 2>&1

SED -r "s/^\s*//g; s/\s*$//g" borlander_file.dat >temp4900
FOR /F "TOKENS=*" %%G IN ( temp4900 ) DO @IF EXIST "%%~G" ECHO."%%~G">>d-del2AA.dat 2>N_\%random%
DEL /A/F/Q temp490? N_\* >N_\%random% 2>&1

SED -r "s/^\s*//g; s/\s*$//g" borlander_folder.dat >temp4900

FOR /F "TOKENS=*" %%G IN ( temp4900 ) DO @IF EXIST "%%~G" @(
	ECHO."%%~G">>d-del2bb.dat
	PEV -td "%%~G\*">>d-del2bb.dat
	PEV -tx50000 -tf "%%~G\*">>d-del2AA.dat
	)

DEL /A/F/Q temp490? borlander_*.dat N_\* >N_\%random% 2>&1


IF EXIST W6432.dat (
		IF EXIST CFoldersx64.dat (
		SED -r "s/^\s*//; s/\s*$//; s/\x22//g; /^.:\\/!d; s/\\\\+/\\/g; s/\\$//; /^.:\\/!d; /%systemdrive%\\Qoobox(\\|$)/Id" CFoldersx64.dat > x64temp4900
		GREP -Fixvf dnd.dat x64temp4900 | GREP -Fixvf whiteAll.dat > x64temp4901
		ECHO.:::::>>x64temp4901
		PEV -filesx64temp4901 -td -rt!e -output:x64temp4902
		SORT /M 65536 x64temp4902 /T %cd% /O x64temp4903
		SED -r "$!N; /^(.*)\n\1$/I!P; D" x64temp4903 > x64temp4904
		SED -r "s/^%SysDir:\=\\%\\(.*)/&\t%SysNative:\=\\%\\\1/I; /	/!s/.*/&\t&/" x64temp4904 > x64temp4905
		FOR /F "TOKENS=1* DELIMS=	" %%G IN ( x64temp4905 ) DO @IF EXIST "%%~H\" (
			ECHO.%%~G	%%~H>>x64delB00
			PEV -tx150000 -tf "%%~G\*" >> d-delAx64.dat
			)
		DEL /A/F/Q CFoldersx64.dat x64temp490?
		)
	IF EXIST CFilesx64.dat (
		SED -r "s/^\s*//g; s/\s*$//g; s/\x22//g" Cfilesx64.dat > x64temp4900
		GREP -Fixvf whiteAll.dat x64temp4900 | SORT /M 65536 /T %cd% /O x64temp4901
		SED -r "$!N; /^(.*)\n\1$/I!P; D" x64temp4901 > x64temp4902
		ECHO.:::: >> x64temp4902
		PEV -t!o -tx150000 -tf -filesx64temp4902 >> x64temp4903
		SED -r "s/^%SysDir:\=\\%\\(.*)/&\t%SysNative:\=\\%\\\1/I; /	/!s/.*/&\t&/" x64temp4903 > x64del00
		DEL /A/F/Q CFilesx64.dat x64temp490?
		)
	)>N_\%random% 2>&1

IF EXIST XPRD.NFO GOTO Stage50

:: Wareout KD file
IF EXIST %system%\kd???.exe PEV -fs32 -rtf -t!o -s=76800 %system%\kd???.exe -output:temp4900 && FINDSTR -MILF:temp4900 "kedr_dns_ver" >>d-delA.dat 2>N_\%random%
SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V "system" >temp4900
FINDSTR -IR "kd...\.exe" temp4900 >temp4901

FOR /F "TOKENS=2*" %%G in ( temp4901 ) DO @IF NOT EXIST "%system%\%%H" (
		REGT /e /s "%SystemDrive%\Qoobox\Quarantine\Registry_backups\winlogon.reg.dat" "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
		ECHO."%system%\%%H">>d-del2AA.dat
		SWREG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v system
		SWREG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v system
		)>N_\%random% 2>&1


IF EXIST xp.mac IF NOT EXIST RcRdy GOTO SkipBaseSrv

DEL /A/F/Q temp490? N_\* >N_\%random% 2>&1
SWREG ACL "HKLM\System\CurrentControlSet\control\session manager\subsystems" /RESET /Q
SWREG QUERY "HKLM\System\CurrentControlSet\control\session manager\subsystems" /v windows >temp4900
GREP -Fisq ServerDll=consrv: temp4900 && SED "/.*	/!d;s///; :a; s/\\$//;ta; s/ServerDll=consrv:/ServerDll=winsrv:/Ig" temp4900 >temp4901

IF EXIST temp4901 IF EXIST "%SYSDIR%\winsrv.dll" (
	PEVB PDUMP >consrv00
	SED "/./{H;$!d;};x;/\ncsrss.exe (/I!d;" consrv00 > consrv01
	SED -R "/^Thread: \((\d*)\) .*\(0x00000000\)$/!d; s//\1/" consrv01 > consrv02
	FOR /F %%G IN ( consrv02 ) DO @PEVB TSUSPEND %%G
	FOR /F "TOKENS=*" %%G IN ( temp4901 ) DO @(
		SWREG ADD "HKLM\System\CurrentControlSet\Control\session manager\subsystems" /v windows /t reg_expand_sz /d "%%G"
		SWREG ADD "HKLM\SOFTWARE\Swearware\subsystems" /v windows /t reg_expand_sz /d "%%G"
		SWREG EXPORT "HKLM\SOFTWARE\Swearware\subsystems" consrv03 /NT4
		ECHO.[hkey_users\temphive\%CONTROLSET%\control\session manager\subsystems]>>erunt.dat
		SED -r ":a;/\\$/N; s/\\\n +//; ta; /^\x22Windows\x22/I!d" consrv03 >>erunt.dat
		SWREG DELETE "HKLM\SOFTWARE\Swearware\subsystems"
		)
	IF EXIST "%SystemRoot%\System64\" IF EXIST "%System%\fsutil.exe" (
		"%System%\fsutil.exe" REPARSEPOINT DELETE "%SystemRoot%\System64"
		ECHO."%SystemRoot%\System64">>d-delB.dat
		)
	SWREG QUERY "HKLM\System\CurrentControlSet\control\session manager\subsystems" /v windows >temp4902
	GREP -Fisq ServerDll=consrv: temp4902 ||IF EXIST "%SYSDIR%\consrv.dll" ECHO."%SYSDIR%\consrv.dll">> d-delA.dat
	IF NOT EXIST CfReboot.dat TYPE myNul.dat >CfReboot.dat
	DEL /A/F/Q consrv0?
)>N_\%random% 2>&1 ELSE @(
	ECHO.%SYSDIR%\winsrv.dll %is missing%
	PEV -tx50000 -tf %SystemRoot%\winsrv.dll
	)>>basesrv.dat


DEL /A/F/Q temp490? N_\* >N_\%random% 2>&1
SWREG QUERY "HKLM\System\CurrentControlSet\control\session manager\subsystems" /v windows >temp4900
GREP -Fisq ServerDll=basesrv,1 temp4900 || SED "/.*	/!d;s///; :a; s/\\$//;ta; s/ServerDll=[^ ,]*,1/ServerDll=basesrv,1/I" temp4900 >temp4901

IF EXIST temp4901 IF EXIST "%SYSDIR%\basesrv.dll" (
	FOR /F "TOKENS=*" %%G IN ( temp4901 ) DO @SWREG ADD "HKLM\System\CurrentControlSet\Control\session manager\subsystems" /v windows /t reg_expand_sz /d "%%G" >N_\%random%
	SWREG QUERY "HKLM\System\CurrentControlSet\control\session manager\subsystems" /v windows >temp4902
	GREP -Fisq ServerDll=basesrv,1 temp4902 &&(
		SED -r "/	/!d;s/.*SubSystemType=\S* ServerDll=([^ ,]*).*$/%SYSDIR:\=\\%\\\1.dll/I" temp4900 | MTEE /+ d-delA.dat >temp4902
		SED -r "s/^(.):(.*)$/copy \x22%Qrntn:\=\\%\\\1\2.vir\x22 \x22&\x22/" temp4902 >>%SystemRoot%\erdnt\CF_undo.bat
		)
) ELSE @(
	ECHO.%SYSDIR%\basesrv.dll %is missing%
	PEV -tx50000 -tf %SystemRoot%\basesrv.dll
	)>>basesrv.dat
DEL /A/F/Q temp4901 >N_\%random% 2>&1


GREP -Fisq ServerDll=consrv: temp4900 || SED "/.*	/!d;s///; :a; s/\\$//;ta; s/ServerDll=consrv:/ServerDll=winsrv:/Ig" temp4900 >temp4901


FINDSTR -MI "KeServiceDescriptorTable WinExec WININET.dll XPTPSW InternetOpen DeleteFile MZKERNEL32.DLL VERSION.DLL http:// notepad\.exe B.i.t.D.e.f.e.n.d.e.r SetLocalTime OpenMutexW GetProcessShutdownParameters DuplicateIcon" "%system%\userinit.exe" >N_\%random% 2>&1 &&CALL :ND_sub "%system%\userinit.exe"

FINDSTR -MR "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" "%system%\userinit.exe" >N_\%random% 2>&1 ||CALL :ND_sub "%system%\userinit.exe"

PEV -fs32 -tx15000 -rtf "%system%\userinit.exe" -t!g AND { -s-18000 or -s+35000 } >N_\%random% &&CALL :ND_sub "%system%\userinit.exe"

PEV -fs32 -tx15000 -s+120000  -t!g -rtf "%system%\Drivers\atapi.sys" >N_\%random% &&CALL :ND_sub "%system%\Drivers\atapi.sys"

GREP -Fisq "Windows NT\CurrentVersion\Bindows" "%system%\user32.dll"  && CALL :ND_sub "%system%\user32.dll"

FINDSTR -MI "LdrSetSessionName" "%system%\lsass.exe" >N_\%random% 2>&1 && CALL :ND_sub "%system%\lsass.exe"

FINDSTR -MIR "\\regedit\.exe PECompact sysws2help B\.text8 XPTPSW \.vmp1 netmarble" "%system%\ws2help.dll" >N_\%random% 2>&1 && CALL :ND_sub "%system%\ws2help.dll"

IF EXIST "%system%\kbdpx.dll" PEV -fs32 -tx15000 -t!g -rtf "%system%\kernel32.dll" >N_\%random% && CALL :ND_sub "%system%\kernel32.dll"

FINDSTR -MI "http" "%system%\ws2_32.dll" >N_\%random% 2>&1 && CALL :ND_sub "%system%\ws2_32.dll"

FINDSTR -MI "s.v.c.h.o.s.t...e.x.e...-.k...n.e.t.s.v.c.s" "%system%\drivers\kbdclass.sys" >N_\%random% 2>&1 && CALL :ND_sub "%system%\drivers\kbdclass.sys"

IF EXIST "%system%\usp10.dll" FINDSTR -MR "IceSword.exe" "%system%\usp10.dll" >N_\%random% 2>&1 && CALL :ND_sub "%system%\usp10.dll"

IF EXIST "%system%\msimg32.dll" FINDSTR -MR "qqlogin.exe" "%system%\msimg32.dll" >N_\%random% 2>&1 && CALL :ND_sub "%system%\msimg32.dll"

IF EXIST "%system%\imm32.dll" GREP -Esq "\.text............................... ..à\.data|t5rc\.dll...jatydimofugclqu|\.reloc..............................@...\.NewIT" "%system%\imm32.dll" && CALL :ND_sub "%system%\imm32.dll"

IF EXIST "%system%\Version.dll" GREP -Esq "\.text............................... ..à\.data|t5rc\.dll...jatydimofugclqu|\.reloc..............................@...\.NewIT" "%system%\Version.dll" && CALL :ND_sub "%system%\Version.dll"

IF EXIST "%system%\wshtcpip.dll" GREP -sq "PECompact2\|MapleStory" "%system%\wshtcpip.dll" && CALL :ND_sub "%system%\wshtcpip.dll"

IF EXIST "%system%\ntdll.dll" GREP -Fsq "mspdb13.dll" "%system%\ntdll.dll" && CALL :ND_sub "%system%\ntdll.dll"

GREP -Fisq "32\iglicd64.dll" "%SYSDIR%\samsrv.dll" && CALL :ND_sub "%SYSDIR%\samsrv.dll"

PEV -tx40000 -t!g -rtf -tpmz -c##y#b#z# %SYSDIR%\Services.exe | SED -r "/(0x0.*)\t\1/d" | GREP -sq . && CALL :ND_sub "%SYSDIR%\Services.exe"

IF EXIST Vista.krl (
	PEV -fs32 -rtf -t!g -s-800000 %system%\drivers\ntfs.sys >N_\%random% 2>&1 && CALL :ND_sub "%system%\drivers\ntfs.sys"
	FINDSTR -MR "S........hlp\.dat" "%system%\wininit.exe" >N_\%random% 2>&1 && CALL :ND_sub "%system%\wininit.exe"
	) ELSE (
	PEV -fs32 -rtf -t!g -s+600000 %system%\drivers\ntfs.sys >N_\%random% 2>&1 && CALL :ND_sub "%system%\drivers\ntfs.sys"
	FINDSTR -MR "S........hlp\.dat X.......k.b.\..d.l.l" "%SystemRoot%\Winlogon.exe" >N_\%random% 2>&1 &&CALL :ND_sub "%SystemRoot%\Winlogon.exe"
	)

@(
ECHO.%system%\lsass.exe
ECHO.%system%\winlogon.exe
ECHO.%system%\services.exe
ECHO.%system%\svchost.exe
ECHO.%system%\spoolsv.exe
ECHO.%SystemRoot%\explorer.exe
ECHO.%system%\ws2_32.dll
ECHO.%system%\powrprof.dll
ECHO.%system%\wininet.dll
ECHO.%system%\imm32.dll
ECHO.%system%\mshtml.dll
ECHO.%system%\msvcrt.dll
ECHO.%system%\msimg32.dll
)>RcRdyList

PEV -fs32 -files:RcRdyList -rtf -t!g -c##y #z#b#f#  | SED -r "/^(0x0.......) \1	/d; s/.*	//" >ND_B
FOR /F "TOKENS=*" %%G IN ( ND_B ) DO @CALL :ND_sub "%%~G"
DEL /A/F ND_B >N_\%random% 2>&1

IF EXIST "%system%\kb.dll" PEV -rtg "%system%\winlogon.exe"  >N_\%random% 2>&1 && ECHO."%system%\kb.dll">>d-delA.dat
IF EXIST "%system%\ms.dll" PEV -rtg "%system%\winlogon.exe"  >N_\%random% 2>&1 && ECHO."%system%\ms.dll">>d-delA.dat
IF EXIST "%system%\nt.dll" PEV -rtg "%system%\winlogon.exe"  >N_\%random% 2>&1 && ECHO."%system%\nt.dll">>d-delA.dat

GREP -Esq "Browser Helper Objects|F69F5FC33D81AAFD|357A474F2D885F6D" "%system%\kernel32.dll" && CALL :ND_sub "%system%\kernel32.dll"


IF EXIST mt_ndis.sys.tmp (	CALL :ND_sub %system%\drivers\ndis.sys
	) ELSE FINDSTR -MI "Protect.pdb OuterDrv.pdb" %system%\drivers\ndis.sys >N_\%random% 2>&1 &&CALL :ND_sub %system%\drivers\ndis.sys


IF NOT EXIST Vista.krl SWREG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "GinaDLL" > temp4900 &&(
	SED "/.*\t/!d; s///; s/^[^\\]*$/%system:\=\\%\\&/" temp4900 > temp4901
	ECHO.::::>> temp4901
	GREP -Fisq "\nwgina.dll" temp4901 || PEV -rtg -filestemp4901 || PEV -rtg "%system%\msgina.dll" &&(
		PEV -rtf -filestemp4901 >> d-delA.dat
		SWREG ACL "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /RESET /Q
		SWREG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "GinaDLL"
		ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]>>CregC.dat
		ECHO."GinaDLL"=->>CregC.dat
		ECHO.[hkey_users\temphive2\microsoft\windows nt\currentversion\winlogon]>>erunt.dat
		ECHO."GinaDLL"=->>erunt.dat
		))>N_\%random% 2>&1

DEL /A/F/Q temp4901 >N_\%random% 2>&1


:SkipBaseSrv
FINDSTR -MI "google" "%system%\svchost.exe" >N_\%random% 2>&1 &&(
	CALL :FREE "%system%\svchost.exe"
	MOVE /Y "%system%\svchost.exe" "%system%\svchost.exe.vir"
	IF EXIST "%system%\svchost.exe.bak" FINDSTR -MI "google" "%system%\svchost.exe.bak" >N_\%random% 2>&1 ||(
		CALL :FREE "%system%\svchost.exe.bak"
		MOVE /Y "%system%\svchost.exe.bak" "%system%\svchost.exe"
		)
	PEV WAIT 2500
	IF NOT EXIST "%system%\svchost.exe" (
		MOVE /Y "%system%\svchost.exe.vir" "%system%\svchost.exe"
		ECHO.%system%\svchost.exe ... Infected -- Win32.Qhost !!>>basesrv.dat
		PEV -fs32 -ltf "%SystemRoot%\svchost.*" >>basesrv.dat
		)
	IF EXIST "%system%\svchost.exe.vir" (
		%KMD% /D /C MoveIt.bat "%system%\svchost.exe.vir" >N_\%random% 2>&1
		ECHO.%system%\svchost.exe ... disinfected -- Win32.Qhost>>basesrv.dat
		TYPE myNul.dat >CfReboot.dat
		))>N_\%random% 2>&1


:STAGE50
DEL /A/F/Q temp490? N_\* >N_\%random% 2>&1
@MOVE /Y ncmd.com ncmd.cfxxe >N_\%random% 2>&1
PEV.exe -k *.%cfExt% and not %Comspec%
@MOVE /Y ncmd.cfxxe ncmd.com >N_\%random% 2>&1
@DEL /A/F WowErr.dat

@ECHO.

IF EXIST %SystemRoot%\clear.bat %KMD% /D /C MoveIt.bat "%SystemRoot%\clear.bat" >N_\%random% 2>&1


IF EXIST BHOQuery.dat SED "/{/!d; s/.*{/{/ " BHOQuery.dat >CLSIDs00
IF EXIST STSQuery.dat SED -r "/^  +(\{[^	]*\})	.*/!d; s//\1/" STSQuery.dat >>CLSIDs00
IF EXIST SEHQuery.dat SED -r "/^  +(\{[^	]*\})	.*/!d; s//\1/" SEHQuery.dat >>CLSIDs00
IF EXIST SSDOLQuery.dat SED "/.*	{/!d; s//{/ " SSDOLQuery.dat >>CLSIDs00
IF EXIST CLSIDs00 FINDSTR -VILG:clsid.dat CLSIDs00 >CLSIDs01
IF EXIST CLSIDs01 FOR /F "TOKENS=*" %%G IN ( CLSIDs01 ) DO @SWREG QUERY "hkcr\clsid\%%G\inprocserver32" /ve | SED "/.*	/!d; s///" >>CLSIDFiles00

IF EXIST NotifyQuery.dat (
	SED -r -f env.sed -e "/notify\\[^\\]*$|DLLName	/I!d; s/.*	/=/;" NotifyQuery.dat | SED ":a; $!N; s/\n=/	/;ta;P;D" >Notify00
	GREP -Fivf notifykeysB.dat Notify00 >Notify01
	FINDSTR -v ? Notify01 >Notify02
	FOR /F "TOKENS=1* DELIMS=	" %%G IN ( Notify02 ) DO @IF EXIST "%%~F$PATH:H" %KMD% /C ECHO.%%~F$PATH:H>>CLSIDFiles00
	DEL /A/F/Q Notify0?
	)>N_\%random% 2>&1

IF EXIST CLSIDFiles00 (
	SORT /M 65536 CLSIDFiles00 /O CLSIDFiles01
	SED -r "$!N; s/^(.*)\n\1$/\1/; t; D" CLSIDFiles01 >CLSIDFiles02
	SED -r "$!N; /^(.*)\n\1$/I!P; D" CLSIDFiles02 >>d-delA.dat
	)>N_\%random% 2>&1
DEL /A/F/Q temp0? CLSIDs0? CLSIDFiles0? >N_\%random% 2>&1


IF DEFINED SysTemp IF EXIST "%SYSTEMP%\" SWXCACLS "%SYSTEMP%" /RESET /Q
IF DEFINED SysTemp DEL /A/S/F/Q "%systemp%.\*" >N_\%random% 2>&1
IF DEFINED Temp DEL /A/S/F/Q "%temp%.\*" >N_\%random% 2>&1
IF DEFINED CommonTemp DEL /A/S/F/Q "%CommonTemp%\*" >N_\%random% 2>&1
IF DEFINED CommonAppData DEL /A/S/F/Q "%CommonAppData%\Temp\*" >N_\%random% 2>&1
IF DEFINED LocalAppData DEL /A/S/F/Q "%LocalAppData%\Temp\*" >N_\%random% 2>&1
IF DEFINED SysTemp PEV -fs32 -tpmz -tx50000 -tf "%systemp%\*" >>d-delA.dat
IF DEFINED Temp PEV -fs32 -tx50000 -tf -tpmz "%temp%\*" and not catchme.dll >>d-delA.dat
IF DEFINED CommonTemp PEV -fs32 -tx50000 -tf -tpmz "%CommonTemp%\*" and not catchme.dll >>d-delA.dat
IF DEFINED CommonAppData PEV -fs32 -tx50000 -tf -tpmz "%CommonAppData%\Temp\*" and not catchme.dll >>d-delA.dat
IF DEFINED AppData PEV -fs32 -tx50000 -tf -tpmz "%AppData%\Temp\*" and not catchme.dll >>d-delA.dat
IF DEFINED LocalAppData PEV -fs32 -tx50000 -tf -tpmz "%LocalAppData%\Temp\*" and not catchme.dll >>d-delA.dat
IF DEFINED Temp_LFN PEV -fs32 -tx50000 -tf -tpmz "%temp_LFN%\*" and not catchme.dll >>d-delA.dat

PV -s -q >MemCheck01
SED -r "/^$|	([4-9][0-9a-f]{7}|[0-9]0*)	[0-9]*	.:\\/Id; s/.*	//" MemCheck01 | SORT /M 65536 |  SED -r "$!N; /^(.*)\n\1$/I!P; D" >MemCheck02
ECHO.:::::>>MemCheck02
PEV -fs32 -filesMemCheck02 -t!o -c##5#b#u#b#f#b1:#d#b8:#i#b7:#k#b3:#g#b4:#o#b5:#j#b6:#l#b2:#e#b0:#q# >>ViPev02
DEL /A/F/Q MemCheck0? >N_\%random% 2>&1

PEV -s-15728641 -fs32 -tx20000 -tpmz -dcG30 -tf -c##5#b#u#b#f#b1:#d#b8:#i#b7:#k#b3:#g#b4:#o#b5:#j#b6:#l#b2:#e#b0:#q# "%CommonAppData%\*" and not -preg"%CommonAppData:\=\\%\\.*\\.*\\.*\\.*\\" >>ViPev02
IF EXIST progfile.dat TYPE progfile.dat >>ViPev02
IF EXIST OriO4Files.dat TYPE OriO4Files.dat >>ViPev02
IF EXIST BHOFiles.dat TYPE BHOFiles.dat >>ViPev02
IF EXIST ServiceFiles.dat TYPE ServiceFiles.dat >>ViPev02

GSAR -o -s:x1a -r:x3F Vipev02 >N_\%random% 2>&1
FINDSTR -BIVG:MDWht.dat Vipev02 > Vipev02_temp00
SORT.EXE /M 65536 Vipev02_temp00 /O Vipev02_temp01
SED "$!N; /^\(.*\)\n\1$/I!P; D" Vipev02_temp01 > Vipev02_temp02
SED -r ":a; $!N;s/\n[A-F0-9]{32}\t/&/; tb; s/\n/?/; ta :b; P;D" Vipev02_temp02 >Vipev02
DEL /A/F/Q Vipev02_temp0?

GREP -Fic ".t	1:" Vipev02 | GREP -Esq ".." && FOR /F "TOKENS=*" %%G IN ( Drives.dat ) DO @(
	VOL %%G: &&@PEV -tpmz %%G:\????????.t >>d-delA.dat
	)>N_\%random% 2>&1


PV -d30000 -xa PEV.EXE >N_\%random% 2>&1
GREP -Fwif srizbi.md5 ViPev02 >Vipev03
@GREP -Esf VInfo3 VIPev02 >>Vipev03
GREP . VInfo2 > VInfo2B && MOVE /Y VInfo2B VInfo2  >N_\%random% 2>&1
@GREP -Fsf VInfo2 VIPev02 >Vipev03a
@GREP -Esf VInfo VIPev02 >>Vipev03a
@GREP -Esq "1:------	8:------	7:------|1:	8:	7:	3:" Vipev03a ||TYPE Vipev03a >>Vipev03
GREP -Eiv "%system:\=\\%\\(Partizan\.exe|drivers\\Partizan\.sys|ATIODCLI\.exe|ATIODE\.exe)" Vipev03 >Vipev04
SED -r "/.*	([c-z]:\\[^	]*)	.*/I!d; s//\1/" Vipev04 >>d-delA.dat


SED -r "/.*(.:\\[^	]*)	.*/!d; s//\1/" ViPev02| SED -r ":a;$!N; s/\n/\x22 \x22/;ta; s/.*/\x22&\x22/;s/(.{3500}[^\x22]*\x22) /\1\n/g" >Vipev05
FOR /F "TOKENS=*" %%G IN ( Vipev05 ) DO @GREP -Elsqf VIPEV.DAT %%G >>d-delA.dat


SED -r "s/[^:]*(.:\\.*)\t(1:.*)/\2\t\1/; /[17]:(-{6}|[^\t]*\?[^\t]*|)	|:ERROR: 0x0	.:ERROR: 0x0/d" Vipev02 | SORT /M 65536 /O Vipev06
ECHO.>>Vipev06
SED -n -r "/7:(IGFXRES\.DLL|Uninstenu\.dll|xxxXRES\.DLL|SATELLITE\.DLL|_setup7\.dll)/d; :a; $!N; s/\n/&/28; tz; $!ba; q; :z; s/^([^\n]*)\t[^\t]*\n.*\n\1[^\n]*\'/&/; tc; D; $!ba; q; :c; N; s/^([^\n]*)\t[^\t]*\n.*\n\1[^\n]*\'/&/; tc; h; s/(.*)\n.*/\1/p; g; s/^([^\n]*)\t[^\t]*\n.*\n([^\n]*)\'/\1\n\2/; D; :k" Vipev06 | SED "s/.*\t//" >Vipev07
ECHO.::::>>Vipev07
PEV -filesVipev07 -c##y#b#f#b#k# | SED -r "/^0x0{8}	/!d; s///; /\\([^	]*)	\1$/Id; s/\t.*//" >>d-delA.dat
GREP -Ei "\\(wsock3[23]|usp10|version|Lpk|ws2help|ws2_32|rundll)\.dll$" Vipev07 > DllJack00
TYPE DllJack00 >>d-delA.dat
DEL /A/F DllJack00


IF EXIST Vipev02 IF NOT EXIST ReplicatorDo (
	SORT.EXE /M 65536 Vipev02 /O Vipev02b
	ECHO.>>Vipev02b
	SED -n -r "/exe	1:------	8:------	7:------	3:------/I!d; :a; $!N; s/\n/&/13; tz; $!ba; q; :z; s/^([^\t]*)\t.*\n\1[^\n]*\'/&/; tc; D; $!ba; q; :c; $!N; s/^([^\t]*)\t.*\n\1[^\n]*\'/&/; tc; s/^([^\t]*)\t.*\n([^\n]*)\'/\1\n\2/ ;P; D;" Vipev02b >ReplicatorDo
	SED -n -r "/exe	1(:(-{6}|)	)8\17\13\14\15\16\12\10\2$/I!d; :a; $!N; s/\n/&/10; tz; $!ba; q; :z; s/^([^\t]*)\t.*\n\1[^\n]*\'/&/; tc; D; $!ba; q; :c; $!N; s/^([^\t]*)\t.*\n\1[^\n]*\'/&/; tc; s/^([^\t]*)\t.*\n([^\n]*)\'/\1\n\2/ ;P; D;" Vipev02b >>ReplicatorDo
	SED -n -r "/\.exe	/I!d; :a; $!N; s/\n/&/50; tz; $!ba; q; :z; s/^([^\t]*)\t.*\n\1[^\n]*\'/&/; tc; D; $!ba; q; :c; N; s/^([^\t]*)\t.*\n\1[^\n]*\'/&/; tc; s/^([^\t]*)\t.*\n([^\n]*)\'/\1\n\2/ ;P; D;" Vipev02b >>ReplicatorDo
	GREP -sq . ReplicatorDo ||DEL /A/F ReplicatorDo
	SED -n -r "/\\(wsock3[23]|usp10|version|Lpk|ws2help|ws2_32|rundll)\.dll	/I!d; :a; $!N; s/\n/&/15; tz; $!ba; q; :z; s/^([^\t]*)\t.*\n\1[^\n]*\'/&/; tc; D; $!ba; q; :c; N; s/^([^\t]*)\t.*\n\1[^\n]*\'/&/; tc; s/^([^\t]*)\t.*\n([^\n]*)\'/\1\n\2/ ;P; D;" Vipev02b >DllJack03
	GREP -sq . DllJack03 && IF NOT EXIST Drives.dat (
		PEV -t!o -md5list:DllJack03 %SystemDrive%\* -preg"\\(wsock3[23]|usp10|version|Lpk|ws2help|ws2_32|rundll)\.dll" >>d-delA.dat
	) ELSE FOR /F "TOKENS=*" %%G IN ( Drives.dat ) DO @VOL %%G: >N_\%random% 2>&1 &&@(
		PEV -t!o -md5list:DllJack03 %%G:\* -preg"\\(wsock3[23]|usp10|version|Lpk|ws2help|ws2_32|rundll)\.dll$" >>d-delA.dat
		)
	DEL /A/F/Q DllJack0? Vipev02b
	)>N_\%random% 2>&1

CALL :Replicator_chk

IF NOT EXIST Vista.krl IF NOT EXIST "%System%\sfcfiles.dll" CALL :WRPcheck d-delA.dat >N_\%random% 2>&1
IF DEFINED SAFEBOOT_OPTION CALL :WRPcheck d-delA.dat >N_\%random% 2>&1

Type d-del_A.dat d-delA.dat d-del4AV.dat drev.dat d-del2A.dat catch_k.dat 2>N_\%random% | SED "s/\x22//g; /^.:\\/!d; s/\\\\+/\\/g; s/\\$//; /^.:\\/!d;" | GREP -Fixvf whiteAll.dat | SED "/:\\/!d; s/\x22//g; s/./	&/" > SvcTempA
ECHO.::::>> SvcTempA
PEV -files:SvcTempA -m -output:SvcTempA.tmp
TYPE SvcTempA.tmp >> SvcTempA
SED -r "s/\x22//g; /^.:\\/!d; s/\\\\+/\\/g; s/\\$//; /^.:\\/!d; /%systemdrive%\\Qoobox(\\|$)/Id" CFolders.dat | GREP -Fixvf whiteAll.dat | SED "/:\\/!d; s/\x22//g; s/$/\\/; s/./	&/" >SvcTempAa
ECHO.::::>> SvcTempAa
PEV -files:SvcTempAa -m -output:SvcTempAa.tmp
TYPE SvcTempAa.tmp >> SvcTempAa
DEL /Q SvcTempA?.tmp >N_\%random% 2>&1

GREP -Fif SvcTempA SvcDump >temp5000
GREP -Fif SvcTempAa SvcDump >>temp5000
SED "s/	.*//; s/\\.*//" temp5000 >temp5001
GREP -Fixvf zhsvc.dat temp5001 >temp5002
GREP -Fixvf svc_wht.dat temp5002 >SvcTempB
SED "y/ /_/" SvcTempB >temp5003
GREP -Fixf LegacyFull temp5003 >LegacyTemp
GREP -Fixvf netsvc.dat zhsvc.dat >>netsvc.bad.dat 2>N_\%random%
DEL /A/F/Q temp500? VInfo Vipev0?? >N_\%random% 2>&1

@SET "Services_=HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services"
@SET "Legacy_=HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root"

FOR /F "TOKENS=*" %%G IN ( LegacyTemp ) DO @(
	ECHO.-------\Legacy_%%G>>SvcTarget.dat
	@ECHO.[-HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%~G]>>CregC.dat
	@SWREG export "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Legacy_%%~G.reg.dat"
	@ECHO.[-HKEY_USERS\temphive\%CONTROLSET%\enum\root\Legacy_%%~G]>>erunt.dat
	)>N_\%random% 2>&1

FOR /F "TOKENS=*" %%G IN ( SvcTempB ) DO @(
	ECHO.-------\Service_%%G>>SvcTarget.dat
	ECHO.[-HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G]>>CregC.dat
	@SWREG export "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Service_%%~NG.reg.dat"
	@ECHO.[-hkey_users\temphive\%CONTROLSET%\services\%%~G]>>erunt.dat
	@SWREG ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_Beep\xx_%%~G_xx" /v ConfigFlags /t reg_dword /d 1
	@SWREG ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_Beep\xx_%%~G_xx" /v Service /d "%%~G"
	@SWREG restore "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G" cfdummy /f
	)>N_\%random% 2>&1

DEL /A/F/Q SvcTemp? LegacyTemp >N_\%random% 2>&1


IF EXIST "\System Volume Information\" IF EXIST F_system SWXCACLS "\System Volume Information\"  /E /GA:F /Q

IF EXIST d-del*.dat CALL :SafetyChk

IF EXIST d-delA.dat (
	GREP -Eis "\\_*desktop_*(1|2|).ini$" d-delA.dat >delNow && FOR /F "TOKENS=*" %%G IN ( delNow ) DO @DEL /A/F "%%~G"
	SED -r "s/^\s*//; s/\s*$//; s/\x22//g; /^.:\\/!d; s/\\\\+/\\/g; s/\\$//; /^.:\\/!d;" d-delA.dat >temp5000
	GREP -Fixvf whiteAll.dat temp5000 | SORT /M 65536 /T %cd% /O temp5001
	SED -r "$!N; /^(.*)\n\1$/I!P; D" temp5001 >del00
	IF EXIST d-del4AV.dat (
		SED -r "/:\\/!d; s/\x22//g" d-del4AV.dat >temp5002
		ECHO.::::>>temp5002
		FINDSTR -LIVXG:temp5002 del00 >temp5003
		MOVE /Y temp5003 del00
		)
	DEL /A/F/Q temp500? d-delA.dat delNow
	)>N_\%random% 2>&1


SETLOCAL
@SET SESSIONNAME=
@SET CLIENTNAME=
@SET COMPUTERNAME=
@SET HOMEDRIVE=
@SET HOMEPATH=
@SET J2D_D3D=
@SET NUMBER_OF_PROCESSORS=
@SET OS=
@SET PROCESSOR_ARCHITECTURE=
@SET PROCESSOR_IDENTIFIER=
@SET PROCESSOR_LEVEL=
@SET PROCESSOR_REVISION=
@SET PROMPT=
@SET USERDOMAIN=
@SET USERNAME=

SET "TEMP=%CD%"
SET Delay_xx=
IF EXIST del00 GREP -c . del00 | GREP -sq "..." && SET "Delay_xx=REM"

GREP -sq . del00 x64del00 &&(
	IF EXIST del00 GREP -ivq "::::" del00 &&(
		REM ECHO.Deleting Files:
		ECHO.
		@ECHO.%Line43%
		ECHO.
		SWREG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V AUTORESTARTSHELL /T REG_DWORD /D 0 >DelFile.mrk
		IF NOT EXIST Vista.krl GREP -Fisq "Settings\Zones\4]" CregC.dat || TYPE ZDomain.dat >>CregC.dat
		PEV -k *explore*.exe or rundll*.exe
		Catchme -l N_\%random% -Iapx > del01 2>N_\%random% &&(
			SED -R "/:\\/!d;s/ \[\d*\].*//; s/\\\?\?\\//" del01 > del02
			)|| PEV PLIST > del02
		GREP -Fisxf del00 del02 >del03
		FOR /F "TOKENS=*" %%G IN ( del03 ) DO @PEV EXEC /S "%CD%\NIRCMD.%cfExt%" KILLPROCESS "%%~G"
		@TITLE .
		)

	IF EXIST x64del00 GREP -ivq "::::" x64del00 &&(
		IF NOT EXIST DelFile.mrk (
			REM ECHO.Deleting Files:
			ECHO.
			@ECHO.%Line43%
			ECHO.
			)
		IF EXIST "%SysNative%\REG.exe" "%SysNative%\REG.exe" ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V AUTORESTARTSHELL /T REG_DWORD /D 0 /F >N_\%random% 2>&1
		IF EXIST "%SysNative%\TaskKill.exe" "%SysNative%\TaskKill.exe" /F /IM explore* /IM rundll* >N_\%random% 2>&1
		)

	IF EXIST del00 FOR /F "TOKENS=*" %%G IN ( del00 ) DO @IF NOT EXIST "%%~G\" (
		ECHO:%%~G
		%KMD% /D /C MoveIt.bat "%%~G" >N_\%random% 2>&1
		DIR /A-D "\\?\%%~G" >N_\%random% 2>&1 &&(
			ECHO.%%~G>>catch_k.dat
			ECHO.%%~G>>d-del2A.dat
			)|| ECHO."%%~G">>drev.dat
		%Delay_xx% PEV WAIT 50
		)

	IF EXIST x64del00 FOR /F "TOKENS=1* DELIMS=	" %%G IN ( x64del00 ) DO @IF NOT EXIST "%%~H\" (
		ECHO:%%~G
		%KMD% /D /C MoveIt.bat "%%~H" >N_\%random% 2>&1
		DIR /A-D "\\?\%%~H" >N_\%random% 2>&1 &&(
			ECHO.%%~G	%%~H>>x64d-del2A.dat
			)|| ECHO."%%~G">>x64drev.dat
		%Delay_xx% PEV WAIT 50
		)

	SED "/appinit_dlls	reg_/I!d" MWindows.dat | GREP -Fiqf del00 &&@(
		ECHO.[hkey_local_machine\software\microsoft\windows nt\currentversion\windows]>>CregC.dat
		ECHO."appinit_dlls"=->>CregC.dat
		)
	DEL /A/F/Q DelFile.mrk  del0? >N_\%random% 2>&1
	)

ENDLOCAL

IF EXIST "%system%\mswsock.dll" FINDSTR -MI "Borland" "%system%\mswsock.dll" >temp5000 2>N_\%random% && @(
	FOR /F "TOKENS=*" %%G IN ( temp5000)  DO @(
		PEV -fs32 -s=%%~ZG -d-2007-04-05 "%system%\*.dll" -output:temp5001
		FINDSTR -MRF:temp5001 m.s.w.s.o.c.k.\..d.l.l 2>N_\%random% | FINDSTR -MRF:/ h.n.e.t.c.f.g.\..d.l.l >temp5002
		FOR /F "TOKENS=*" %%H IN ( temp5002 ) DO @FINDSTR -L "%%~NXH" "%system%\mswsock.dll" &&(
			%KMD% /D /C MoveIt.bat "%system%\mswsock.dll"
			CALL :FREE  "%%~H"
			MOVE /Y "%%~H" "%system%\mswsock.dll"
			)
		DEL /A/F temp5001 temp5002
		))>N_\%random% 2>&1

DEL /A/F/Q temp500? N_\* >N_\%random% 2>&1


IF EXIST f_system IF EXIST "%CommonAppData%.\Microsoft\PCTools" SWXCACLS "%CommonAppData%\Microsoft\PCTools" /RESET /I ENABLE /Q


IF EXIST d-delB.dat (
	SED -r "s/^\s*//; s/\s*$//; s/\x22//g; /^.:\\/!d; s/\\\\+/\\/g; s/\\$//; /^.:\\/!d; /%systemdrive%\\Qoobox(\\|$)/Id" d-delB.dat >temp5000
	SORT /M 65536 temp5000 /T %cd% /O temp5001
	SED -r "$!N; /^(.*)\n\1$/I!P; D" temp5001 >temp5002
	ECHO.::::>> temp5002
	PEV -files:temp5002 -td -rt!e -output:delB00
	DEL /A/F/Q temp500? d-delB.dat
	)>N_\%random% 2>&1


IF EXIST x64delB00 (
	SED -r "s/^\s*//; s/\s*$//; s/\x22//g; /^.:\\/!d; s/\\\\+/\\/g; s/\\$//; /^.:\\/!d; /%systemdrive%\\Qoobox(\\|$)/Id" x64delB00 >temp5000
	SORT /M 65536 temp5000 /T %cd% /O temp5001
	SED -r "$!N; /^(.*)\n\1$/I!P; D" temp5001 >temp5002
	ECHO.::::>> temp5002
	PEV -files:temp5002 -td -rt!e -output:x64delB00
	DEL /A/F/Q temp500?
	)>N_\%random% 2>&1


GREP -sq . delB00 x64delB00 &&(
	REM ECHO.Deleting Folders:
	ECHO.
	@ECHO.%Line43A%
	ECHO.
	)

IF EXIST delB00 (
	FOR /F "TOKENS=*" %%G IN ( delB00 ) DO @IF EXIST "%%~G\" (
		ECHO:%%~G
		SWXCACLS "%%~G" /RESET /Q
		CALL :QooFolder "%%~G" >N_\%random% 2>&1
		RD "%%~G" >N_\%random% 2>&1
		IF EXIST "%%~G" RD /S/Q "%%~G" >N_\%random% 2>&1
		PEV WAIT 70
		IF EXIST "%%~G\" ECHO."%%~G">>d-del2b.dat
		IF NOT EXIST "%%~G\" ECHO."%%~G">>drevF.dat
		)
	DEL /A/F delB00 >N_\%random% 2>&1
	)

IF EXIST x64delB00 (
	FOR /F "TOKENS=1* DELIMS=	" %%G IN ( x64delB00 ) DO @(
		ECHO:%%~G
		SWXCACLS "%%~H" /RESET /Q
		CALL :QooFolder "%%~G" >N_\%random% 2>&1
		RD "%%~H" >N_\%random% 2>&1
		IF EXIST "%%~H" RD /S/Q "%%~H" >N_\%random% 2>&1
		RD /S/Q "%%~H\" >N_\%random% 2>&1
		PEV WAIT 70
		IF EXIST "%%~H\" ECHO.%%~G	%%~H>>x64d-del2b.dat
		IF NOT EXIST "%%~H\" ECHO."%%~G">>x64drevF.dat
		)
	DEL /A/F x64delB00 >N_\%random% 2>&1
	)


IF EXIST W6432.dat IF EXIST "%SysNative%\REG.exe" "%SysNative%\REG.exe" ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V AUTORESTARTSHELL /T REG_DWORD /D 1 /F >N_\%random% 2>&1

IF NOT EXIST W6432.dat FINDSTR -MR "MZKERNEL32\.DLL 360Tray sdfs.F.7888.F..cn oemiglib.dll UPX! FISHPEP S........hlp\.dat" "%SystemRoot%\explorer.exe" >N_\%random% 2>&1 &&CALL :ND_sub "%SystemRoot%\explorer.exe"

FINDSTR -LM "MZKERNEL32.DLL" "%system%\spoolsv.exe" >N_\%random% 2>&1 && CALL :ND_sub "%system%\spoolsv.exe"
FINDSTR -MIR "lpk32.LpkInitialize wmploc.LpkInitialize" "%system%\lpk.dll" >N_\%random% 2>&1 && CALL :ND_sub "%system%\lpk.dll"
FINDSTR -LMI "%system%" "%system%\comres.dll" >N_\%random% 2>&1 && CALL :ND_sub "%system%\comres.dll"
FINDSTR -MI "LdrSetSessionName" "%system%\mfc40u.dll" >N_\%random% 2>&1 && CALL :ND_sub "%system%\mfc40u.dll"
FINDSTR -MI "IPHOST\.dll" "%system%\svchost.exe" >N_\%random% 2>&1 && CALL :ND_sub "%system%\svchost.exe"
FINDSTR -MIR "dllcache\\rpcss t3rpcss.dll rp\.\$css\.dll~\* expl~2~2orer\.exe \\brpcss\.dll RavMonD\.exe cmd./c.del" "%system%\rpcss.dll" >N_\%random% 2>&1 && CALL :ND_sub "%system%\rpcss.dll"
FINDSTR -MIL "ShellExecuteA" "%system%\msgsvc.dll" >N_\%random% 2>&1 && CALL :ND_sub "%system%\msgsvc.dll"
FINDSTR -MIL "msls51\.dll" "%system%\uxtheme.dll" >N_\%random% 2>&1 && CALL :ND_sub "%system%\uxtheme.dll"
FINDSTR -MR "S........hlp\.dat" "%ProgFiles%\internet explorer\iexplore.exe" >N_\%random% 2>&1 && CALL :ND_sub "%ProgFiles%\internet explorer\iexplore.exe"
FINDSTR -MR "MZKERNEL32\.DLL midimap32.DriverProc P.l.a.t.f.o.r.m.W.i.d.g.e.t...d.l.l sxload.tmp" "%system%\midimap.dll" >N_\%random% 2>&1 && CALL :ND_sub "%system%\midimap.dll"

IF EXIST XP.mac PEV -fs32 -rtf -s!4224 %system%\drivers\beep.sys >N_\%random% &&(
	%KMD% /D /C MoveIt.bat "%system%\drivers\beep.sys" >N_\%random% 2>&1
	CALL :ND_sub "%system%\drivers\beep.sys"
	)

IF EXIST "%system%\wuauclt.exe" FINDSTR -MI "ShellExecuteA MZKERNEL32.DLL" "%system%\wuauclt.exe" >N_\%random% 2>&1 &&(
	CALL :ND_sub "%system%\wuauclt.exe" )|| FINDSTR -MI R.e.b.o.o.t.R.e.q.u.i.r.e.d "%system%\wuauclt.exe" >N_\%random% 2>&1 ||@CALL :ND_sub "%system%\wuauclt.exe"

IF EXIST "%system%\comctl32.dll" FINDSTR -MI WinExec "%system%\comctl32.dll" >N_\%random% 2>&1 &&CALL :ND_sub "%system%\comctl32.dll"

IF EXIST %system%\debug.exe FINDSTR -MI MZKERNEL32.DLL %system%\debug.exe >N_\%random% 2>&1 &&CALL :ND_sub "%system%\debug.exe"
IF EXIST %system%\spoolsv.exe FINDSTR -MI s.p.o.o.1.s.v.\..e.x.e %system%\spoolsv.exe >N_\%random% 2>&1 &&CALL :ND_sub "%system%\spoolsv.exe"

IF EXIST %system%\sfcfiles.dll GREP -Esq "`.Sleep|CloseHandle" %system%\sfcfiles.dll &&CALL :ND_sub "%system%\sfcfiles.dll"

IF EXIST %system%\xmlprov.dll GREP -Eisq "tESlortnoCtnerruC|UninstallServer" %system%\xmlprov.dll &&CALL :ND_sub "%system%\xmlprov.dll"

IF EXIST %system%\drivers\acpiec.sys FINDSTR -MI "K.I.L.L.I.B.\..s.y.s" %system%\drivers\acpiec.sys >N_\%random% 2>&1 &&CALL :ND_sub "%system%\drivers\acpiec.sys"

IF EXIST %system%\tlntsvr.exe FINDSTR -MI "LiveUpdate" %system%\tlntsvr.exe >N_\%random% 2>&1 &&CALL :ND_sub "%system%\tlntsvr.exe"

IF EXIST %system%\drivers\aec.sys PEV -fs32 -rtf -s+100000 %system%\drivers\aec.sys >N_\%random% 2>&1 ||CALL :ND_sub "%system%\drivers\aec.sys"

PEV -fs32 -to -rtf -s-75000 "%system%\taskmgr.exe" >N_\%random% 2>&1 &&CALL :ND_sub "%system%\taskmgr.exe"
PEV -fs32 -rtf -s-31000 %system%\hid.dll >N_\%random% 2>&1 ||CALL :ND_sub "%system%\hid.dll"
PEV -fs32 -rtf -s10000-26000 %system%\midimap.dll >N_\%random% 2>&1 ||CALL :ND_sub "%system%\midimap.dll"
PEV -fs32 -tx40000 -rtf -tp { -t!k or -t!j } "%system%\msgsvc.dll" >N_\%random% 2>&1 &&CALL :ND_sub "%system%\msgsvc.dll"
PEV -fs32 -rtf -s+30000 %system%\dsound.dll >N_\%random% 2>&1 ||CALL :ND_sub "%system%\dsound.dll"
IF EXIST %system%\dbghlp.dll PEV -fs32 -rtf -s+30000 %system%\dbghlp.dll >N_\%random% 2>&1 ||CALL :ND_sub "%system%\dbghlp.dll"

IF NOT EXIST Vista.krl IF EXIST "%system%\clipsrv.exe" GSAR -sPE:x00:x00L:x01:x03:x00 "%system%\clipsrv.exe" 2>N_\%random% |GREP -Fsq "match found" ||CALL :ND_sub "%system%\clipsrv.exe"

IF EXIST %system%\rasauto.dll PEV -fs32 -rtf -s+40000 "%system%\rasauto.dll" >N_\%random% ||CALL :ND_sub "%system%\rasauto.dll"

IF EXIST %system%\qmgr.dll PEV -fs32 -rtf -s+250000 -s!179200 "%system%\qmgr.dll" >N_\%random% ||CALL :ND_sub "%system%\qmgr.dll"

IF EXIST "%system%\vssvc.exe" PEV -rtf -s-100000 "%system%\vssvc.exe" >N_\%random% &&CALL :ND_sub "%system%\vssvc.exe"

IF EXIST "%system%\ctfmon.exe" FINDSTR -MR "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" "%system%\ctfmon.exe" >N_\%random% 2>&1 ||CALL :ND_sub "%system%\ctfmon.exe"

IF EXIST "%system%\drivers\AGP440.sys" (
	PEV -fs32 -rtf -t!g and { -s=64696 or -s=94016 or -s=56504 or -s=94432 } and "%system%\drivers\AGP440.sys" >N_\%random% 2>&1 &&CALL :ND_sub "%system%\drivers\AGP440.sys"
	PEV -fs32 -rtf -c##d#b#i#b#k#b#g#b#j# "%system%\drivers\AGP440.sys" | GREP -Fsqe "------" &&CALL :ND_sub "%system%\drivers\AGP440.sys"
	)

PEV -fs32 -r -s+250000 "%system%\netlogon.dll" >N_\%random% || CALL :ND_sub "%system%\netlogon.dll"
PEV -fs32 -rtf -s+100000 "%system%\scecli.dll" >N_\%random% ||CALL :ND_sub "%system%\scecli.dll"

GREP -isq "B.e.i.j.i.n.g. .R.i.s.i.n.g\|Regedit\.EXE" "%system%\linkinfo.dll" && CALL :ND_sub "%system%\linkinfo.dll"

PEV -fs32 -rtf -to -c##5#b#f# and %system%\*.dll and { -s=60928 or -s=60416 or -s=61952 or -s=63488 or -s=62976 or -s=62464 }  or { scecli.dll or netlogon.dll or eventlog.dll or cngaudit.dll } | SED -r "/!HASH: COULD NOT OPEN FILE !!!!!.*	/!d; s///" >temp5000
FOR /F "TOKENS=*" %%G IN ( temp5000 ) DO @CALL :ND_sub "%%G"
DEL /A/F temp5000 >N_\%random% 2>&1

FOR %%G IN (
"%system%\eventlog.dll"
"%system%\cngaudit.dll"
) DO @IF EXIST %%G GREP -sq "\\.D.e.v.i.c.e.\\._._.m.a.x.+.+" %%G >N_\%random% &&CALL :ND_sub %%G

IF EXIST %system%\drivers\asyncmac.sys PEV -fs32 -rtf -t!g -s-12000 "%system%\drivers\asyncmac.sys" >N_\%random% &&CALL :ND_sub "%system%\drivers\asyncmac.sys"

IF EXIST XP.mac PEV -fs32 -r -s+100000 "%system%\srsvc.dll" >N_\%random% || CALL :ND_sub "%system%\srsvc.dll"

PEV -fs32 -r -s+250000 "%system%\comres.dll" >N_\%random% || CALL :ND_sub "%system%\comres.dll"
PEV -fs32 -r -s+10000000 "%system%\comres.dll" >N_\%random% && CALL :ND_sub "%system%\comres.dll"

IF NOT EXIST W8.mac PEV -fs32 -r -s18000-70000 "%system%\lpk.dll" >N_\%random% || CALL :ND_sub "%system%\lpk.dll"

PEV -fs32 -tx40000 -tf -tp -to -t!g { -t!k or -t!j } %SystemRoot%\*.exe -skip"%SystemRoot%\winsxs" -output:temp5000
IF EXIST %system%\msctfime.ime PEV -fs32 -tx40000 -rtf -tp -to -t!g { -t!k or -t!j } %system%\msctfime.ime >>temp5000
PEV -fs32 -tx40000 -rtf -tp -to -t!g { -t!k or -t!j } %system%\*.dll -preg"\\(d3d[89]|dsound|olepro32|ddraw|asycfilt|msimg32|perfctrs|ole32|winrnr|schedsvc|d3d8thk|rasadhlp|dnsapi|hnetcfg|ws2help|comres|ksuser|iphlpapi|mshtml|rasapi32|mspmsnsv)\.dll$" >>temp5000
PEV -fs32 -tx40000 -rtf -tp -to -t!g %system%\*.dll -preg"\\(d3d[89]|dsound|ddraw|asycfilt|msimg32|perfctrs|ole32|winrnr|schedsvc|d3d8thk|rasadhlp|dnsapi|hnetcfg|ws2help|comres|ksuser|iphlpapi|mshtml|rasapi32)\.dll$" | FINDSTR -MIRF:/ "%system:\=\\%\\."  >>temp5000
FOR /F "TOKENS=*" %%G IN ( temp5000 ) DO @CALL :ND_sub "%%G"


FOR %%G IN (
	"%system%\pchsvc.dll"
	"%system%\schedsvc.dll"
	"%system%\regsvc.dll"
	"%system%\ssdpsrv.dll"
	"%system%\upnphost.dll"
	"%system%\shsvcs.dll"
	"%system%\cryptsvc.dll"
	"%system%\browser.dll"
	"%system%\tapisrv.dll"
	"%system%\mswsock.dll"
	"%system%\netman.dll"
	"%system%\es.dll"
	"%system%\mspmsnsv.dll"
	"%system%\xmlprov.dll"
	"%system%\ntmssvc.dll"
	"%system%\drivers\cdrom.sys"
	"%system%\ias.dll"
	"%system%\iprip.dll"
	"%system%\6to4.dll"
	"%system%\ksuser.dll"
	"%system%\termsrv.dll"
	"%system%\usp10.dll"
	"%system%\msimg32.dll"
	"%system%\rasadhlp.dll"
	"%system%\appmgmts.dll"
	"%system%\schedsvc.dll"
	"%system%\srsvc.dll"
	"%system%\w32time.dll"
	"%system%\wiaservc.dll"
	"%system%\winscard.dll"
	"%systemroot%\pchealth\helpctr\binaries\pchsvc.dll"
	"%system%\sethc.exe"
) DO @PEV -fs32 -rt!g -c##d#k# %%G | GREP -Esq "\------------|QVOD" && CALL :ND_sub %%G


@(
ECHO."%SYSDIR%\grpconv.exe"
ECHO."%SYSDIR%\proquota.exe"
ECHO."%SYSDIR%\drivers\null.sys"
ECHO."%SYSDIR%\drivers\afd.sys
ECHO."%SYSDIR%\drivers\ndis.sys
ECHO."%SYSDIR%\drivers\ndisuio.sys
ECHO."%SYSDIR%\drivers\netbios.sys
ECHO."%SYSDIR%\drivers\usbehci.sys
ECHO."%SYSDIR%\drivers\intelppm.sys
ECHO."%SYSDIR%\drivers\tcpip.sys
ECHO."%SYSDIR%\drivers\netbt.sys"
ECHO."%SYSDIR%\cryptsvc.dll"
ECHO."%SYSDIR%\drivers\asyncmac.sys"
ECHO."%SYSDIR%\drivers\cdrom.sys"
ECHO."%SYSDIR%\drivers\Serial.sys"
ECHO."%SYSDIR%\drivers\ndproxy.sys"
ECHO."%SYSDIR%\drivers\ws2ifsl.sys"
ECHO."%SYSDIR%\drivers\i8042prt.sys"

IF EXIST Vista.krl (
	ECHO."%SYSDIR%\drivers\tdx.sys"
		) ELSE (
	ECHO."%SYSDIR%\drivers\ipsec.sys"
	ECHO."%SYSDIR%\drivers\psched.sys"
	)
)>>MissingFiles.dat
FOR /F "TOKENS=*" %%G IN ( MissingFiles.dat ) DO @IF NOT EXIST "%%~G" %KMD% /D /C ND_.bat "%%~G" "MISSING" >N_\%random% 2>&1


IF EXIST max_.dat (
	PEV -fs32 -rtf -t!g -s+40000 -t!g -t!j "%system%\drivers\*.sys" | FINDSTR -MF:/ "release\\ZeroAccess.pdb IoRegisterDriverReinitialization..I.MmIsThisAnNtAsSystem Luke.Skywalker NtQueryDirectoryFile....MmLockPagableImageSection ObFindHandleForObject...WRITE_REGISTER_BUFFER_USHORT" >temp5000
	FOR /F "TOKENS=*" %%G IN ( temp5000 ) DO @CALL :ND_sub "%%G"
	DEL /A/F temp5000 max_.dat
	)2>N_\%random%


FINDSTR -MIRF:ServiceFiles00 "A.C.P.I.#.P.N.P.0.3.0.3.#.2...d.a.1.a.3.f.f" >PatchedSvcFiles 2>N_\%random%
ECHO.::::>>PatchedSvcFiles
PEV -files:PatchedSvcFiles -to -output:PatchedSvcFiles00
PEV -files:PatchedSvcFiles -t!o -output:PatchedSvcFiles01
FOR /F "TOKENS=*" %%G IN ( PatchedSvcFiles00 ) DO @CALL :ND_sub "%%~G"
FOR /F "TOKENS=*" %%G IN ( PatchedSvcFiles01 ) DO @CALL :ND_Patched_sub "%%~G" "NoSig" "A.C.P.I.#.P.N.P.0.3.0.3.#.2...d.a.1.a.3.f.f"
DEL /A/F/Q ServiceFiles00 PatchedSvcFiles* >N_\%random% 2>&1

IF EXIST "%SystemRoot%\temp" RD /S/Q "%SystemRoot%\temp" >N_\%random% 2>&1 && MD "%SystemRoot%\temp" >N_\%random% 2>&1

IF EXIST LocalSettings.folder.dat FOR /F "TOKENS=*" %%G IN ( localsettings.folder.dat
	) DO @IF EXIST "%%~G\temp" RD /S/Q "%%~G\temp" >N_\%random% 2>&1 && MD "%%~G\temp" >N_\%random% 2>&1


IF EXIST Cache.folder.dat FOR /F "TOKENS=*" %%G IN ( Cache.folder.dat ) DO @IF EXIST "%%~G\Content.IE5\index.dat" (
	SWXCACLS "%%~G\Content.IE5" /RESET /Q
	ATTRIB -S -H "%%~G\Content.IE5"
	ATTRIB -S -H "%%~G\Content.IE5\*" /S /D
	RD /S/Q "%%~G\Content.IE5"
	)>N_\%random% 2>&1


PEV -k soundmix.exe

@IF EXIST CregC_.dat (
	TYPE CregC_.dat >>CregC.dat
	DEL /A/F CregC_.dat
	)>N_\%random% 2>&1


CALL :LASTRUN
@IF EXIST ND.mov @SWXCACLS "%SystemDrive%\system volume information" /P /GS:F /I REMOVE /Q
@IF EXIST %SystemDrive%\qoobox\lastrun\d-del?.dat DEL /A/F/Q %SystemDrive%\qoobox\lastrun\d-del?.dat >N_\%random% 2>&1
@DEL /A/Q d-delB.dat Cfiles.dat CFolders.dat borlander_*.dat att*.dat zhsvc.dat miscfile.dat >N_\%random% 2>&1
@TITLE .
@SWREG ACL "HKLM\SOFTWARE\MICROSOFT\OUTLOOK EXPRESS\5.0\SETTING" /RESET /Q
@SWREG ACL "HKCR\CLSID\{385AB8C6-FB22-4D17-8834-064E2BA0A6F0}" /RESET /Q
@SWREG ACL "HKCR\CLSID\{285AB8C6-FB22-4D17-8834-064E2BA0A6F0}" /RESET /Q
@SWREG ACL "HKCR\CLSID\{295AB8C6-FB22-4D17-8834-064E2BA0A6F0}" /RESET /Q
@SWREG ACL "HKCR\CLSID\{296AB1C6-FB22-4D17-8834-064E2BA0A6F0}" /RESET /Q
@SWREG ACL "HKCR\CLSID\{296AB1C7-FB22-4D17-8834-064E2BA0A6F0}" /RESET /Q
@SWREG ACL "HKCR\CLSID\{296AB1B8-FB22-4D17-8834-064E2BA0A6F0}" /RESET /Q
@SWREG ACL "HKLM\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\IMAGE FILE EXECUTION OPTIONS\EXPLORER.EXE" /RESET /Q
@SWREG ACL "HKCU\AVS" /RESET /Q
@IF NOT EXIST Vista.krl CALL RKEY.cmd >N_\%random% 2>&1

@REGT /S cregC.dat >N_\%random% 2>&1
@REGT /S creg.dat >N_\%random% 2>&1

@IF NOT EXIST Vista.krl CALL RKEY.cmd RKEYB >N_\%random% 2>&1

IF NOT EXIST "%system%\verclsid.exe" (
	IF EXIST "%system%\verclsid.exe.bak" REN "%system%\verclsid.exe.bak" verclsid.exe
	IF EXIST "%system%\verclsid.bak" REN "%system%\verclsid.bak" verclsid.exe
	)2>N_\%random%

IF EXIST drev.dat (
	SWXCACLS %sysdir%\drivers\etc\hosts /GE:F /Q
	DEL /A/F/Q %sysdir%\drivers\etc\hosts
	ECHO.127.0.0.1       localhost>%sysdir%\drivers\etc\hosts
	)>N_\%random% 2>&1


:FixLSP
@SWSC QUERY NetBT >N_\%random% 2>&1 || CALL :NetBT >N_\%random% 2>&1
@IF EXIST W7.mac CALL :BridgeMP >N_\%random% 2>&1
@IF EXIST temp0? DEL /A/F/Q temp0? >N_\%random% 2>&1
@IF DEFINED SAFEBOOT_OPTION GOTO FIXLSP2
@SWSC QUERY AFD | GREP -Fsq "STATE              : 4  RUNNING" || TYPE myNul.dat >CfReboot.dat
@IF EXIST Vista.krl (
	SWSC QUERY tdx | GREP -Fsq "STATE              : 4  RUNNING" || CALL :TDX >N_\%random% 2>&1
	SWSC QUERY BFE | GREP -Fsq "STATE              : 4  RUNNING" || CALL :BFE >N_\%random% 2>&1
	SWSC QUERY MpsSvc | GREP -Fsq "STATE              : 4  RUNNING" || CALL :MpsSvc >N_\%random% 2>&1
	SWSC QUERY IpHlpSvc | GREP -Fsq "STATE              : 4  RUNNING" || CALL :IpHlpSvc >N_\%random% 2>&1
	) ELSE (
	SWSC QUERY ipsec | GREP -Fsq "STATE              : 4  RUNNING" || CALL :IPSEC >N_\%random% 2>&1
	)
@DEL /A/F/Q IpHlpSvc.*.dat >N_\%random% 2>&1


:FixLSP2
IF EXIST W6432.dat (
NircmdB.exe EXEC HIDE %KMD% /C FIXLSP64.cmd
) ELSE NircmdB.exe EXEC HIDE %KMD% /C FIXLSP.bat
@IF EXIST WowErr.dat DEL /A/F WowErr.dat >N_\%random% 2>&1
@TYPE myNul.dat >WowDone.dat
@GOTO :EOF

:Tencent
FOR /F "TOKENS=*" %%G IN ( Tencent00 ) DO SET "STRING=%%~G"
ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\shellexecutehooks]>>CregC.dat
ECHO."{%String%}"=->>CregC.dat
ECHO.[-hkey_classes_root\clsid\{%String%}]>>CregC.dat

IF EXIST "%ProgFiles%\%String:~,8%" (
		FINDSTR "MZKERNEL32.DLL" "%ProgFiles%\%String:~,8%\*" &&(
		ECHO."%ProgFiles%\%String:~,8%">>d-delB.dat
		PEV -fs32 -td "%ProgFiles%\%String:~,8%\*" >>d-delB.dat
		PEV -fs32 -tx50000 -tf "%ProgFiles%\%String:~,8%\*" >>d-delA.dat
		))

PEV -fs32 -tx50000 -tf "%CommonProgFiles%\MS%string:~,5%?.DLL" >>d-delA.dat
IF EXIST "%system%\MS%string:~,5%?.CPL" PEV -fs32 -rtf "%system%\MS%string:~,5%?.CPL">>d-delA.dat
IF EXIST "%system%\h%string:~1,7%.log" PEV -fs32 -rtf "%system%\h%string:~1,7%.log" >>d-delA.dat
SET STRING=
GOTO :EOF



:SUB2
@SET sName=%*
IF EXIST "%system%\%sName:~0,-1%.exe" FC "%system%\%sName%.exe" "%system%\%sName:~0,-1%.exe" >N_\%random% ||GOTO :EOF

SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%sName:~0,-1%" | FINDSTR -I %system:\=\\%\\%sName:~0,-1%.exe.-service >N_\%random% &&(
	ECHO.%sName:~0,-1%>>zhSvc.dat
	ECHO."%system%\%sName%.exe">>d-delA.dat
	PEV -fs32 -rtf "%system%\%sName:~0,-1%.*" >>d-delA.dat
	)

@GOTO :EOF



:ListDir
set /a countX+=1 >N_\%random%

@if %countX% gtr %2 (
	set countX=
	rem Helpers couldn't handle it.
	rem ECHO.TimedOut: %1 >>ComboFix.txt
	GOTO :EOF
	)

@PEV WAIT 2000
@GREP -q "^$" %1 || GOTO ListDir
@SET countX=
@GOTO :EOF



:AppndDLL
@SETLOCAL
@SET "tar_=%*"
@SET "tar_B=%tar_:\=\\%
@SET "tar_=\\??\\%tar_B%\\0"
@SET "key_z=hklm\system\currentcontrolset\control\session manager"
@SWREG QUERY "%key_z%" /v pendingfilerenameoperations >Appnd00
@SED "/.*	/!d;s///; s/%tar_%/%tar_:~0,-1%Q/I; s/%tar_%/\\0/I; s/%tar_%//Ig; s/%tar_:~0,-1%Q/%tar_%/I; s/\\0\\0$//" Appnd00 >Appnd01
@FOR /F "TOKENS=*" %%G IN ( Appnd01 ) DO @SWREG ADD "%KEY_Z%" /V PENDINGFILERENAMEOPERATIONS /T REG_MULTI_SZ /D "%%G"
@DEL /A/F/Q Appnd0?
@ENDLOCAL
@GOTO :EOF



:CFRegSvr
:: redundant routine. Prone to hangs
@FOR /F "TOKENS=*" %%G IN ( CFRegSvr00 ) DO @(
	START NIRKMD CMDWAIT 2000 EXEC HIDE PEV -k regsvr32.exe
	regsvr32.exe /u /s %%G
	PEV -k NIRKMD.%cfext%
	)>N_\%random% 2>&1

@DEL /A/F CFRegSvr00 >N_\%random% 2>&1
@GOTO :EOF

:PreRunDel
:: @PEV -fs32 -rtf -md5%ChkSum% .\md5sum.pif >N_\%random% || CALL Kollect.bat List-C.bat ChkSum_Stage10to40
:: @PEV -fs32 -rtf -c:##5#b#f# .\* and { List-C.bat or c.bat } -output:mdCheck00.dat
:: @GREP -vs "^!MD5:" mdCheck00.dat | GREP -vf md5sum.pif >mdCheck01.dat &&CALL Kollect.bat List-C.bat_Stage10to40
:: @DEL /A/Q mdCheck0?.dat


IF NOT EXIST AllSids CALL :REMDIR_A >N_\%random% 2>&1

SED -r "s/^\s*//; s/\s*$//; s/\x22//g; /^.:\\/!d; s/\\\\+/\\/g; s/\\$//; /^.:\\/!d; /%systemdrive%\\Qoobox(\\|$)/Id" CFolders.dat >PreRunDel00
FINDSTR -XVILG:dnd.dat PreRunDel00 | GREP -Fixvf whiteAll.dat >PreRunDel01
ECHO.:::::>>PreRunDel01
PEV -files:PreRunDel01 -td -rt!e -output:PreRunDel02
FOR /F "TOKENS=*" %%G IN ( PreRunDel02 ) DO @IF EXIST "%%~G\" (
	ECHO."%%~G">>d-del_B.dat
	PEV -fs32 -tx50000 -tf "%%~G\*">>d-del_A.dat
	)


SED -r "s/^\s*//g; s/\s*$//g" Cfiles.dat >PreRunDel02
FOR /F "TOKENS=*" %%G IN ( PreRunDel02) DO @IF EXIST "%%~G" IF NOT EXIST "%%~G\" ECHO."%%~G">>d-del_A.dat
IF EXIST PreRunDel0? DEL /A/F/Q PreRunDel0? N_\* >N_\%random% 2>&1

IF EXIST Foreign.dat FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( Foreign.dat
	) DO @FINDSTR -IC:"%%~G" Cfiles.dat >N_\%random% 2>&1 &&ECHO."%%~H">>d-del_A.dat

IF EXIST d-del*.dat CALL :SafetyChk
IF NOT EXIST Vista.krl IF NOT EXIST "%System%\sfcfiles.dll" CALL :WRPcheck d-del_A.dat >N_\%random% 2>&1
IF DEFINED SAFEBOOT_OPTION CALL :WRPcheck d-del_A.dat >N_\%random% 2>&1

IF EXIST d-del_A.dat (
	SED -r "s/^\s*//; s/\s*$//; s/\x22//g; /^.:\\/!d; s/\\\\+/\\/g; s/\\$//; /^.:\\/!d; " d-del_A.dat | GREP -Fixvf whiteAll.dat | SORT /M 65536 | SED -r "$!N; /^(.*)\n\1$/I!P; D" >del00
	IF EXIST d-del4AV.dat (
		SED -r "/:\\/!d; s/\x22//g" d-del4AV.dat >PreRunDel02
		ECHO.::::>>PreRunDel02
		FINDSTR -LIVXG:PreRunDel02 del00 | GREP -Fixvf whiteAll.dat >PreRunDel03
		MOVE /Y PreRunDel03 del00
		)
	DEL /A/F/Q PreRunDel0? d-del_A.dat
	)>N_\%random% 2>&1


IF EXIST del00 GREP -sq . del00 &&(
	GREP -ivq "::::" del00 &&(
			REM ECHO.Deleting Files:
			ECHO.&ECHO.%Line43%&ECHO.
			IF NOT EXIST Vista.krl TYPE ZDomain.dat >>CregC.dat
			SWREG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V AUTORESTARTSHELL /T REG_DWORD /D 0
			PEV -k * -preg"\\(explore[^\\]*|rundll32|firefox|opera|chrome)\.exe$"
			PV -o"%%i\t%%f" >ProcessKiLL00
			GREP -Fisf del00 ProcessKiLL00 >ProcessKiLL01
			SED -r "s/(.*)	.*/@PV -kfi \1/" ProcessKiLL01 >del03.bat
			ECHO.@ECHO.>> del03.bat
			CALL del03.bat >N_\%random% 2>&1
			)
	FOR /F "TOKENS=*" %%G IN ( del00 ) DO @IF NOT EXIST "%%~G\" (
			ECHO:%%~G
			%KMD% /D /C MoveIt.bat "%%~G" >N_\%random% 2>&1
			IF EXIST "%%~G" (ECHO.%%~G>>d-delA.dat) ELSE ECHO.%%~G>>drev.dat
			)
	SED "/appinit_dlls	reg_/I!d" MWindows.dat | GREP -Fiqf del00 &&@(
				ECHO.[hkey_local_machine\software\microsoft\windows nt\currentversion\windows]>>CregC.dat
				ECHO."appinit_dlls"=->>CregC.dat
				ECHO."appinit_dlls"="">>CregC.dat
				)
	DEL /A/F/Q del0? del03.bat >N_\%random% 2>&1
	)
DEL /A/F/Q ProcessKiLL0? N_\* >N_\%random% 2>&1


IF EXIST d-del_B.dat (
	SED -r "s/^\s*//; s/\s*$//; s/\x22//g; /^.:\\/!d; s/\\\\+/\\/g; s/\\$//; /^.:\\/!d; /%systemdrive%\\Qoobox(\\|$)/Id" d-del_B.dat | SORT /M 65536 | SED -r "$!N; /^(.*)\n\1$/I!P; D" >delB00
	GREP -sq . delB00 &&(
		REM ECHO.Deleting Folders:
		ECHO.&ECHO.%Line43A%&ECHO.
		FOR /F "TOKENS=*" %%G IN ( delB00 ) DO @IF EXIST "%%~G\" (
			ECHO:%%~G
			CALL :QooFolder "%%~G" >N_\%random% 2>&1
			RD "%%~G" >N_\%random% 2>&1
			IF EXIST "%%~G" RD /S/Q "%%~G" >N_\%random% 2>&1
			PEV WAIT 70
			IF NOT EXIST "%%~G" ECHO."%%~G">>drevF.dat
			)
		)
	DEL /A/F/Q PreRunDel0? d-del_B.dat delB00 >N_\%random% 2>&1
	)


@DEL /A/F/Q PreRunDel0? N_\* d-del_?.dat >N_\%random% 2>&1


:LASTRUN
@NIRCMD WIN CLOSE CLASS #32770
@IF EXIST drev.dat TYPE drev.dat >\qoobox\lastrun\drev_.dat 2>N_\%random%
@IF EXIST drevF.dat TYPE drevF.dat >\qoobox\lastrun\drev_F.dat 2>N_\%random%
@IF EXIST RenVDel.dat COPY /Y RenVDel.dat %SystemDrive%\qoobox\lastrun\ >N_\%random%
@IF EXIST RenVMove.dat COPY /Y RenVMove.dat %SystemDrive%\qoobox\lastrun\ >N_\%random%
@IF EXIST catch_k*.dat COPY /Y catch_k*.dat %SystemDrive%\qoobox\lastrun\ >N_\%random%
@IF EXIST d-del2*.dat COPY /Y d-del2*.dat %SystemDrive%\qoobox\lastrun\ >N_\%random%
@IF EXIST Foreign.dat COPY /Y Foreign.dat %SystemDrive%\qoobox\lastrun\ >N_\%random%
@COPY /Y erunt.dat %SystemDrive%\qoobox\lastrun\ >N_\%random%
@COPY /Y SvcTarget.dat %SystemDrive%\qoobox\lastrun\ >N_\%random%
@SED -r "/\x3b::@@::/,$!d; /\x3b::@@::|^$/d" zhsvc.dat >\qoobox\lastrun\zhsvc.old
@SED -r "/\x3b::@@::/,$!d; /\x3b::@@::/d" CregC.dat >\qoobox\lastrun\CregC.old
@GOTO :EOF


:Replicator_chk
@IF EXIST License.exe DEL /A/F License.exe
@IF EXIST %CFLDR%.exe DEL /A/F %CFLDR%.exe
PEV -fs32 -rtf "%ProgFiles%%ProgFiles:~2%*.exe" -output:temp500k
GREP -Fis ":\Recycler\Recycler" drev.dat >>temp500k
PEV -fs32 -rtd "%ProgFiles%\*" -output:temp5000
FOR /F "TOKENS=*" %%G IN ( temp5000 ) DO @IF EXIST "%%~DPNG.EXE" ECHO..>>temp5001
TYPE myNul.dat >>temp5001
GREP -c . temp5001 | GREP -Evx ".|1[0-5]" >>temp500k
GREP -sq . temp500k && CALL :Replicator
IF NOT EXIST Replicator.dat IF EXIST ReplicatorDo CALL :Replicator
DEL /A/F/Q temp500? N_\* >N_\%random% 2>&1
@GOTO :EOF


:Replicator
PEV.exe -k *.%cfExt% and not %Comspec%

CLS
@ECHO.&ECHO.
:: @ECHO.ComboFix needs to perform a deeper scan
:: @ECHO.This should not take more than 10-15 minutes
@ECHO.%Line90%
@ECHO.%Line91%
@ECHO.

IF EXIST Replicator0? DEL /A/F/Q Replicator0? N_\* >N_\%random% 2>&1

IF NOT EXIST Drives.dat (
	PEV -fs32 -tx50000 -tf -t!o -c:##u#b#f# %SystemDrive%\*.exe -output:Replicator0A NOT -preg"%systemroot:\=\\%\\.*\\(spuninst|update\\update|\$NtUninstallKB[^\\]*\$\\update)\.exe$|%CD:\=\\%\\.|:\\System Volume Information\\"
) ELSE FOR /F "TOKENS=*" %%G IN ( Drives.dat ) DO @VOL %%G: >N_\%random% 2>&1 &&@(
	PEV -fs32 -tx50000 -tf -t!o -c:##u#b#f# %%G:\*.exe NOT -preg"\\(spuninst|update\\update|\$NtUninstallKB[^\\]*\$\\update)\.exe$|%CD:\=\\%\\.|:\\System Volume Information\\" >>Replicator0A
	)


SORT /M 65536 Replicator0A /T %cd% /O Replicator0B
ECHO.::::>>Replicator0B
SED -n -r ":a; $!N; s/\n/&/35; tz; $!ba; q; :z; s/^([^\t]*\t).*\n\1[^\n]*\'/&/; tc; D; $!ba; q; :c; $!N; s/^([^\t]*\t).*\n\1[^\n]*\'/&/; tc; s/^(.*\n)([^\n]*)\'/\1/p;" Replicator0B | SED "/.*	/!d; s///" >Replicator0C
ECHO.::::>> Replicator0C
PEV -s-15728641 -fs32 -t!o -files:Replicator0C -c:##5#b#f# | SORT /M 65536 /R /T %cd% /O Replicator0D
ECHO.::::>>Replicator0D
SED -n -r ":a; $!N; s/\n/&/35; tz; $!ba; q; :z; s/^([^\t]*\t).*\n\1[^\n]*\'/&/; tc; D; $!ba; q; :c; $!N; s/^([^\t]*\t).*\n\1[^\n]*\'/&/; tc; s/^(.*\n)([^\n]*)\'/\1/p;" Replicator0D >Replicator.dat
IF NOT EXIST %SystemDrive%\QooBox\Quarantine\Replicators MD %SystemDrive%\QooBox\Quarantine\Replicators >N_\%random%


FOR /F "TOKENS=1,*" %%G IN ( Replicator.dat ) DO @(
	ECHO."%%~H"
	IF NOT EXIST "\QooBox\Quarantine\Replicators\%%~G" (
		ATTRIB -H -R -S "%%~H"
		COPY /Y /B "%%~H" "\QooBox\Quarantine\Replicators\%%~G" >N_\%random% 2>&1
		)
	DEL /A/F "%%~H" >N_\%random% 2>&1
	IF EXIST "%%~H" ECHO."%%~H">>d-delA.dat
	)

FOR /F "TOKENS=*" %%G IN ( cfrun ) DO @COPY /Y Replicator.dat "\QooBox\Quarantine\Replicators\Replicator_%%G.txt" >N_\%random% 2>&1
COPY /Y Replicator.dat %SystemDrive%\qoobox\lastrun\ >N_\%random%
DEL /A/F/Q Replicator0? N_\* >N_\%random% 2>&1
@GOTO :EOF


:EmbedNul
@PEV -k rundll32.exe
@SWREG NULL query hkcr\clsid /s /f >embedded
@SED "/./{H;$!d;};x;/start_function.*WLEntry/I!d;" embedded >EmbedNul00
@SED -r "/^(   file_(name|expand|path)	.*	|$)/I!d;s///" EmbedNul00 >EmbedNul01
@SED -r ":a; $!N;s/\n(.)/	\1/;ta;P;D;s/^	//" EmbedNul01 >EmbedNul02
@SED -r -f embedded.sed EmbedNul02 >EmbedNul03
@SED "/	/d" EmbedNul03 >EmbedNul04
@FINDSTR -MIF:EmbedNul04 "exefile\\shell\\open\\command" >>d-delA.dat
@SED "/./{H;$!d;};x;/\nhkey_classes_root\\clsid\\{.*}\\storage\*\\1\n/I!d;" embedded >EmbedNul05
@SED  -r "/^ +reg_name	.*	/I!d;s///;s/.*/\n[hkey_local_machine\\software\\microsoft\\windows\\currentversion\\policies\\explorer\\run]\n\x22&\x22=-/" EmbedNul05 >>CregC.dat
@ECHO.[HKEY_LOCAL_MACHINE\software\microsoft\windows nt\currentversion\winlogon]>>CregC.dat
@ECHO."taskman"=->>CregC.dat
@SED "/^HKEY_CLASSES_ROOT\\clsid\\[^\\]*\\Storage\*/I!d;s/\\[^\\]*\*.*//" embedded >EmbedNul06
@SED -r ":a; N; s/^(.[^\n]*)\n\1.*/\1/; ta; P;D;" EmbedNul06 >embedded.key
@FOR /F "TOKENS=*" %%G IN ( embedded.key ) DO @SWREG ACL "%%G" /DE:F /Q
@DEL /A/F/Q EmbedNul0?
@GOTO :EOF


:Emule
PEV.exe -k *.%cfExt% and not %Comspec%
CLS
@ECHO.&ECHO.
:: @ECHO.ComboFix needs to perform a deeper scan
:: @ECHO.This should not take more than 10-15 minutes
@ECHO.%Line90%
@ECHO.%Line91%
@ECHO.
@PEV -dcg30 -s50000-150000 -rtf "%ProgFiles%\eMule\Incoming\*.zip" | FINDSTR -MLF:/ "Keygen/Keygen.exe" >MuleZips
@GREP -c : MuleZips | GREP -sq "..." || DEL /A/F MuleZips >N_\%random% 2>&1
@CLS
@GOTO :EOF


:Locked
@IF EXIST W6432.dat GOTO :EOF
@IF NOT EXIST Locked GOTO :EOF
@SED "/FINDSTR: Cannot open /I!d; s///" Locked >LockedB
@FOR /F "TOKENS=*" %%G IN ( LockedB ) DO @Catchme -l N_\%random% -c "%%G" "%%~DPG_%%~NG_%%~XG.vir"
@DEL /A/F Locked
@GOTO :EOF

:SafetyChk
@GREP -Fi "%cd%\\" d-del*.dat >SafetyChk00
@GREP -Evis "Desktop.*\.ini|::*" SafetyChk00 >SafetyChk01
@FINDSTR -M ".\\." SafetyChk01 >N_\%random% 2>&1 &&(
	@REM ECHO.ComboFix encountered a terminal error!! Please upload this file - %SystemDrive%\ComboFix_error.dat >>ComboFix.txt
	@REM ECHO.to: http://www.bleepingcomputer.com/submit-malware.php?channel=4 >>ComboFix.txt
	@ECHO.%Line18% >>ComboFix.txt
	@ECHO.%Line19% >>ComboFix.txt
	COPY /Y setpath.bat+suspectSvc.dat+d-del*.dat+combofix.txt+SvcTarget.dat+SvcDump+SvcDiff+Drev.dat+DrevF.dat=\ComboFix_error.dat >N_\%random%
	SET >>\ComboFix_error.dat
	ECHO.--------------------------------->>\ComboFix_error.dat
	TYPE SafetyChk01 >>\ComboFix_error.dat
	GOTO FIXLSP
	)
@DEL /A/F SafetyChk00 SafetyChk01
@GOTO :EOF


:Vun_LSA
SWREG QUERY "hklm\system\currentcontrolset\control\lsa" /v "authentication packages" >VunLSA00
GREP -isq "	msv1_0\\0\\0$" VunLSA00 && GOTO Vun_LSAB
SED "/	/!d;s/.*	//;:a;s/\\0$//;ta;s/\\0/\n/g" VunLSA00 >VunLSA01

FOR /F "TOKENS=*" %%G IN ( VunLSA01 ) DO @IF /I "%%~G" equ "msv1_0" (
	ECHO.%%G>>VunLSA02
) ELSE IF /I "%%~XG" equ "" (
	FOR /F "TOKENS=*" %%X IN ( PathSearch ) DO @PEV -fs32 -limit:1 -rtf "%%~G.dll" or { %%X } and "%%~G.dll" -output:AuthenticationPackages00 &&(
		TYPE AuthenticationPackages00 >>CLSIDFiles00
		FINDSTR -MRG:v_str.dat -F:AuthenticationPackages00 >>d-del_A.dat ||(
			FINDSTR -MRF:AuthenticationPackages00 "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" ||TYPE AuthenticationPackages00 >>d-del_A.dat
			GREP -Fisqf AuthenticationPackages00 BHO.dat && TYPE AuthenticationPackages00 >>d-del_A.dat
			)
		@GREP -Fisf AuthenticationPackages00 d-del_A.dat || ECHO.%%G>>VunLSA02
		)
	DEL /A/F AuthenticationPackages00
	) ELSE (
	FOR /F "TOKENS=*" %%X IN ( PathSearch ) DO @PEV -fs32 -limit:1 -rtf "%%~G" or { %%X } and "%%~G" -output:AuthenticationPackages00 &&(
		TYPE AuthenticationPackages00 >>CLSIDFiles00
		FINDSTR -MRG:v_str.dat -F:AuthenticationPackages00 >>d-del_A.dat ||(
			FINDSTR -MRF:AuthenticationPackages00 "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" ||TYPE AuthenticationPackages00 >>d-del_A.dat
			PEV -fs32 -filesAuthenticationPackages00 -t!o -tp -t!g { -t!k or -t!j } >>d-del_A.dat
			GREP -Fisqf AuthenticationPackages00 BHO.dat && TYPE AuthenticationPackages00 >>d-del_A.dat
			)
		@GREP -Fisf AuthenticationPackages00 d-del_A.dat || ECHO.%%G>>VunLSA02
		)
	DEL /A/F AuthenticationPackages00
	)

IF EXIST VunLSA02 (
	GREP -Fixvsqf VunLSA02 VunLSA01 &&ECHO.;\packages>>erunt.dat
	SED ":a; $!N; s/\n/\\0/g; ta" VunLSA02 >VunLSA03
	FOR /F "TOKENS=*" %%G IN ( VunLSA03 ) DO @(
		SWREG ADD "hklm\system\currentcontrolset\control\lsa" /v "authentication packages" /t reg_multi_sz /d "%%G"
		SWREG ADD "HKLM\Software\Swearware" /v "authentication packages" /t reg_multi_sz /d "%%G"
		)) ELSE (
	SWREG ADD "hklm\system\currentcontrolset\control\lsa" /v "authentication packages" /t reg_multi_sz /d "msv1_0"
	SWREG ADD "HKLM\Software\Swearware" /v "authentication packages" /t reg_multi_sz /d "msv1_0"
	ECHO.;\packages>>erunt.dat
	)

DEL /A/F/Q VunLSA0?


:Vun_LSAB
SWREG QUERY "hklm\system\currentcontrolset\control\lsa" /v "notification packages" >VunLSA00
GREP -isq "	scecli\\0\\0$" VunLSA00 && GOTO :EOF
SED "/	/!d;s/.*	//;:a;s/\\0$//;ta;s/\\0/\n/g" VunLSA00 >VunLSA01
SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" VunLSA01 >VunLSA02

FOR /F "TOKENS=*" %%G IN ( VunLSA02 ) DO @IF /I "%%~G" equ "scecli" (
	ECHO.%%G>>VunLSA03
) ELSE IF /I "%%~XG" equ "" (
	FOR /F "TOKENS=*" %%X IN ( PathSearch ) DO @PEV -fs32 -limit:1 -rtf "%%~G.dll" or { %%X } and "%%~G.dll" -output:NotificationPackages00 &&(
		TYPE NotificationPackages00 >>CLSIDFiles00
		FINDSTR -MRG:v_str.dat -F:NotificationPackages00 >>d-del_A.dat ||(
			FINDSTR -MRF:NotificationPackages00 "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" ||TYPE NotificationPackages00 >>d-del_A.dat
			GREP -Fisqf NotificationPackages00 BHO.dat && TYPE NotificationPackages00 >>d-del_A.dat
			)
		@GREP -Fisf NotificationPackages00 d-del_A.dat || ECHO.%%G>>VunLSA03
		)
	DEL /A/F NotificationPackages00
	) ELSE (
	FOR /F "TOKENS=*" %%X IN ( PathSearch ) DO @PEV -fs32 -limit:1 -rtf "%%~G" or { %%X } and "%%~G"-output:NotificationPackages00 &&(
		TYPE NotificationPackages00 >>CLSIDFiles00
		FINDSTR -MRG:v_str.dat -F:NotificationPackages00 >>d-del_A.dat ||(
			FINDSTR -MRF:NotificationPackages00 "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" ||TYPE NotificationPackages00 >>d-del_A.dat
			PEV -fs32 -filesNotificationPackages00 -t!o -tp -t!g { -t!k or -t!j } >>d-del_A.dat
			GREP -Fisqf NotificationPackages00 BHO.dat && TYPE NotificationPackages00 >>d-del_A.dat
			)
		@GREP -Fisf NotificationPackages00 d-del_A.dat || ECHO.%%G>>VunLSA03
		)
	DEL /A/F NotificationPackages00
	)


IF EXIST VunLSA03 (
	GREP -Fixvsqf VunLSA03 VunLSA02 &&ECHO.;\packages>>erunt.dat
	SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" VunLSA03 >VunLSA04
	SED ":a;$!N; s/\n/\\0/g;ta" VunLSA04 >VunLSA05
	FOR /F "TOKENS=*" %%G IN ( VunLSA05 ) DO @(
		SWREG ADD "hklm\system\currentcontrolset\control\lsa" /v "notification packages" /t reg_multi_sz /d "%%G"
		SWREG ADD "HKLM\Software\Swearware" /v "notification packages" /t reg_multi_sz /d "%%G"
		)
) ELSE (
	SWREG ADD "hklm\system\currentcontrolset\control\lsa" /v "notification packages" /t reg_multi_sz /d "scecli"
	SWREG ADD "HKLM\Software\Swearware" /v "notification packages" /t reg_multi_sz /d "scecli"
	ECHO.;\packages>>erunt.dat
	)
@GOTO :EOF


:VTestA
GSAR -hb -s:088:131:192:008:097:235 "%~1" | GREP -Eisq "0x4(0[6-9a-f]|1[0-9])$" &&GOTO VTestB
GSAR -hb -s:000:000:000:000:000:000:000:000:000:000:xC3P "%~1" | GREP -Eisq "0x937$|0x1537$" &&GOTO VTestB
GSAR -hb -s:000:000:000:000U:x89:xE5:x81:xEC "%~1" | GREP -isq "0x3fc$" &&GOTO VTestB
GSAR -hb -s:x45:x5E:x33:xEE:xE9:xA5:x49:x00:x00:x4D:x54:x8B:xF1:xE9:x12:x26 "%~1" | GREP -Eisq "0x400$" &&GOTO VTestB
GSAR -hb -s:x49:x4F:x81:xF3:x4A:xE4:x0A:x00:xF7:xD1:xE9:x32:x21:x00:x00:x40 "%~1" | GREP -Eisq "0xc00$" &&GOTO VTestB
GSAR -hb -s:xE9:x7D:x10:x00:x00:xE9:x14:x13:x00:x00:xF8:x33:xDB:x33:xF7:x46 "%~1" | GREP -Eisq "0x400$" &&GOTO VTestB

TAIL -1 "%~1" | GSAR -F -s:x1a -r:030 >vTest01
SED -r "/[^\x00]\x00{100}$|[0-9A-F]{44}11D[CD][0-9A-F]{12}FFFF$|\x00{1440}[^\x00]{75,90}$|[24]\x00$|[0-9A-F]{12}11D[CD][0-9A-F]{11}FFFFF[0-9A-F]{32}error/!d" vTest01 >vTest02
GREP -sq . vTest02 &&GOTO VTestB
DEL /A/F/Q vTest0?
@GOTO :EOF


:VTestB
IF EXIST vTest0? DEL /A/F/Q vTest0?
ECHO."%~1">>d-del_A.dat
GOTO :EOF


:SUBMIT
@PEV TIME > time_delf.dat
@FOR /F "TOKENS=1*" %%G IN ( time_delf.dat ) DO @SET "DTT=%%G_%%H"
@SET "DTT=%DTT::=.%"
@ECHO.%DTT%>time_delf.dat

@GREP -Fixvf dnd.dat UploadThese >UploadThese01
@SORT /M 65536 UploadThese01 /T %cd% /O UploadThese02
@SED -r "$!N; /^(.*)\n\1$/I!P; D" UploadThese02 >UploadThese03
@FOR /F "TOKENS=*" %%G IN ( UploadThese03 ) DO @IF /I "%%~ZG" LSS "1024" (
	CATCHME -l "%SystemDrive%\Qoobox\Quarantine\catchme_delf.txt" -Z "%SystemDrive%\Qoobox\Quarantine\[4]-DELF_%DTT%.zip" -k "%%~G" >>CatchSubmit_delf
		) ELSE IF NOT EXIST f_system (
	CATCHME -l "%SystemDrive%\Qoobox\Quarantine\catchme_delf.txt" -c "%%~G" "%%~DPGCollect_%%~NXG.vir"
	IF EXIST "%%~DPGCollect_%%~NXG.vir" CATCHME -l "%SystemDrive%\Qoobox\Quarantine\catchme_delf.txt" -Z "%SystemDrive%\Qoobox\Quarantine\[4]-DELF_%DTT%.zip" -k "%%~DPGCollect_%%~NXG.vir" >>CatchSubmit_delf
	IF EXIST "%%~DPGCollect_%%~NXG.vir" DEL /A/F "%%~DPGCollect_%%~NXG.vir"
		) ELSE FileKill -N CFcatchme -l "%SystemDrive%\Qoobox\Quarantine\catchme_delf.txt" -Z "%SystemDrive%\Qoobox\Quarantine\[4]-DELF_%DTT%.zip" -o "%%~G" combo-fix.sys >>CatchSubmit_delf

@GREP -s "(" CatchSubmit_delf >CatchZipped_delf.dat &&@(
	ZIP -m "%SystemDrive%\Qoobox\Quarantine\[4]-DELF_%DTT%.zip" "%SystemDrive%\Qoobox\Quarantine\catchme_delf.txt"
	ECHO.@ComboFix-Download --connect-timeout 30 -m 900 --retry 1 -# -F "channel=4" -F "userfile=@%SystemDrive%\Qoobox\Quarantine\[4]-DELF_%DTT%.zip" -F "User=ComboFix" -F "MAX_FILE_SIZE=15728640" -H "Host: www.bleepingcomputer.com" http://208.43.87.2/submit-malware.php >>\QooBox\CurlIt.cmd
	)||@IF EXIST "%SystemDrive%\Qoobox\Quarantine\[4]-DELF_%DTT%.zip" DEL "%SystemDrive%\Qoobox\Quarantine\[4]-DELF_%DTT%.zip"

@DEL /A/F/Q UploadThese* CatchZipped_delf.dat CatchSubmit_delf
@SET DTT=
@GOTO :EOF


:REMDIR_A
@IF NOT EXIST AllSids (
	REM SWREG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" | SED -r "1,6d; /^HKEY_.*\\/!d; s//\\\\/" >AllSids
	REM PEV -fs32 -rtd and { "%SystemDrive%\RECYCLER\*" or "%SystemDrive%\RECYCLED\*" or "%SystemDrive%\$RECYCLE.BIN\*" } | FINDSTR -LIVEG:AllSids >>CFolders.dat
	IF EXIST "%ProgFiles%\driver\" CALL :REMDIR "%ProgFiles%\driver" 3
	IF EXIST "%ProgFiles%\Manson\" CALL :REMDIR "%ProgFiles%\Manson" 3
	IF EXIST "%ProgFiles%\Bat\" CALL :RemDir "%ProgFiles%\Bat" 2
	IF EXIST "%ProgFiles%\bifrost\" CALL :RemDir "%ProgFiles%\bifrost" 2
	IF EXIST "%ProgFiles%\Common\" CALL :RemDir "%ProgFiles%\Common" 2
	IF EXIST "%ProgFiles%\Download Plugin\" CALL :RemDir "%ProgFiles%\Download Plugin" 2
	IF EXIST "%ProgFiles%\InternetSoftware\" CALL :RemDir "%ProgFiles%\InternetSoftware" 3
	IF EXIST "%ProgFiles%\ipwindows\" CALL :RemDir "%ProgFiles%\ipwindows" 3
	IF EXIST "%ProgFiles%\Microsoft Common\" CALL :RemDir "%ProgFiles%\Microsoft Common" 2
	IF EXIST "%ProgFiles%\Update\" CALL :RemDir "%ProgFiles%\Update" 3
	IF EXIST "%ProgFiles%\videoplugin\" CALL :RemDir "%ProgFiles%\videoplugin" 2
	IF EXIST "%system%\cipantanah\" CALL :RemDir "%system%\cipantanah" 2
	IF EXIST "%system%\clrprv.oo\" CALL :RemDir "%system%\clrprv.oo"
	IF EXIST "%system%\iefav\" CALL :RemDir "%system%\iefav" 3
	IF EXIST "%system%\zura\" CALL :RemDir "%system%\zura"
	IF EXIST "%system%\inf\" CALL :RemDir "%system%\inf"
	IF EXIST "%SystemDrive%\avg\" CALL :RemDir "%SystemDrive%\avg 3"
	IF EXIST "%SystemDrive%\Backup_Drivers\" CALL :RemDir "%SystemDrive%\Backup_Drivers"
	IF EXIST "%SystemDrive%\conf\" CALL :RemDir "%SystemDrive%\conf" 3
	IF EXIST "%SystemDrive%\Jangan dibuka\" CALL :RemDir "%SystemDrive%\Jangan dibuka"
	IF EXIST "%SystemDrive%\MessengerPlus\" CALL :RemDir "%SystemDrive%\MessengerPlus" 2
	IF EXIST "%SystemDrive%\Microsoft\" CALL :RemDir "%SystemDrive%\Microsoft"
	IF EXIST "%SystemDrive%\Microsoft_drivers\" CALL :RemDir "%SystemDrive%\Microsoft_drivers"
	IF EXIST "%SystemDrive%\phuong tram\" CALL :RemDir "%SystemDrive%\phuong tram"
	IF EXIST "%SystemRoot%\AMD\" CALL :RemDir "%SystemRoot%\AMD"
	IF EXIST "%SystemRoot%\command\" CALL :RemDir "%SystemRoot%\command"
	IF EXIST "%SystemRoot%\desktop\" CALL :RemDir "%SystemRoot%\desktop"
	IF EXIST "%SystemRoot%\dhcp\" CALL :RemDir "%SystemRoot%\dhcp"
	IF EXIST "%SystemRoot%\display\" CALL :RemDir "%SystemRoot%\display"
	IF EXIST "%SystemRoot%\dll\" CALL :RemDir "%SystemRoot%\dll"
	IF EXIST "%SystemRoot%\download\" CALL :RemDir "%SystemRoot%\download"
	IF EXIST "%SystemRoot%\litmus\" CALL :RemDir "%SystemRoot%\litmus" 2
	IF EXIST "%SystemRoot%\nrws\" CALL :RemDir "%SystemRoot%\nrws"
	IF EXIST "%SystemRoot%\OASJJ\" CALL :RemDir "%SystemRoot%\OASJJ"
	IF EXIST "%SystemRoot%\pantek\" CALL :RemDir "%SystemRoot%\pantek"
	IF EXIST "%SystemRoot%\rdrive\" CALL :RemDir "%SystemRoot%\rdrive"
	IF EXIST "%SystemRoot%\sdrive\" CALL :RemDir "%SystemRoot%\sdrive"
	IF EXIST "%SystemRoot%\wadsys\" CALL :RemDir "%SystemRoot%\wadsys"
	IF EXIST "%SystemRoot%\winsock\" CALL :RemDir "%SystemRoot%\winsock"
	IF EXIST "%SystemRoot%\net\" CALL :RemDir "%SystemRoot%\net"
	IF EXIST "%SystemRoot%\use\" CALL :RemDir "%SystemRoot%\use"
	IF EXIST "%system%\Data\" CALL :REMDir "%system%\Data" 0
	IF EXIST "%SystemDrive%\memory\" CALL :REMDIR "%SystemDrive%\memory" 2
	IF EXIST "%SystemDrive%\System\" CALL :REMDIR "%SystemDrive%\System" 2
	IF EXIST "%SystemDrive%\restore\" CALL :REMDIR "%SystemDrive%\restore" 2
	IF EXIST "%SystemDrive%\data\" CALL :REMDIR "%SystemDrive%\data" 2
	IF EXIST "%SystemDrive%\root\" CALL :REMDIR "%SystemDrive%\root" 2
	IF EXIST "%ProgFiles%\sFX\" CALL :RemDir "%ProgFiles%\sFX" 2
	IF EXIST "%system%\html\" CALL :RemDir "%system%\html"
	IF EXIST "%system%\key\" CALL :RemDir "%system%\key"
	IF EXIST "%system%\sounds\" CALL :RemDir "%system%\sounds"
	IF EXIST "%system%\logs\" CALL :RemDir "%system%\logs"
	IF EXIST "%system%\sys\" CALL :RemDir "%system%\sys"
	IF EXIST "%system%\download\" CALL :RemDir "%system%\download"
	IF EXIST "%SystemDrive%\LIN\" CALL :RemDir "%SystemDrive%\LIN"
	IF EXIST "%ProgFiles%\winnt\" CALL :RemDir "%ProgFiles%\winnt"
	IF EXIST "%SystemRoot%\messenger\" CALL :RemDir "%SystemRoot%\messenger"
	IF EXIST "%system%\JSsetup\" CALL :RemDir "%system%\JSsetup"
	IF EXIST "%SystemRoot%\system\jssetup\" CALL :RemDir "%SystemRoot%\system\jssetup"
	IF EXIST "%ProgFiles%\Downloaded Installers\" CALL :RemDir "%ProgFiles%\Downloaded Installers"
	IF EXIST "%AppData%\Windows Networking Service\" CALL :RemDir "%AppData%\Windows Networking Service"
	IF EXIST "%CommonAppData%\Windows Networking Service\" CALL :RemDir "%CommonAppData%\Windows Networking Service"
	IF EXIST "%CommonProgFiles%\Microsoft Shared\HTMLView\" CALL :RemDir "%CommonProgFiles%\Microsoft Shared\HTMLView"
	IF EXIST "%system%\LocalService\" CALL :RemDir "%system%\LocalService"
	IF EXIST "%SystemRoot%\ocxlist\" CALL :RemDir "%SystemRoot%\ocxlist"
	IF EXIST "%SystemDrive%\ProgFiles\" CALL :RemDir "%SystemDrive%\ProgFiles"
	IF EXIST "%SystemDrive%\Images\" CALL :RemDir "%SystemDrive%\Images" 2
	IF EXIST "%ProgFiles%\Shared\" CALL :RemDir "%ProgFiles%\Shared"
	IF EXIST "%ProgFiles%\Company\" CALL: RemDir "%ProgFiles%\Company"
	IF EXIST "%SystemRoot%\Sun\Java\Deployment\logs\" CALL :RemDir "%SystemRoot%\Sun\Java\Deployment\logs"
	IF EXIST "%AppData%\drivers\" CALL: RemDir "%AppData%\drivers"
	IF EXIST ".%SystemRoot%\programs\" CALL :RemDir ".%SystemRoot%\programs"
	IF EXIST "%systemdrive%\Commom Files\" CALL:RemDir "%systemdrive%\Commom Files" 2
	IF EXIST "%CommonAppData%\Defence\" CALL :RemDir "%CommonAppData%\Defence"
	IF EXIST "%SystemRoot%\netaps\" CALL :RemDir "%SystemRoot%\netaps" 2
	IF EXIST "%ProgFiles%\CSec\" CALL :RemDir "%ProgFiles%\CSec"
	IF EXIST "%ProgFiles%\RS\" CALL :RemDir "%ProgFiles%\RS"
	IF EXIST "%system%\Settings\" CALL :RemDir "%system%\Settings"
	IF EXIST "%systemdrive%\WindowsUpdate\" CALL :RemDir "%systemdrive%\WindowsUpdate"
	IF EXIST "%ProgFiles%\First Direct\" CALL :RemDir "%ProgFiles%\First Direct"
	IF EXIST "%ProgFiles%\HostServices\" CALL :RemDir "%ProgFiles%\HostServices"
	IF EXIST "%ProgFiles%\CustomXML\" CALL :RemDir "%ProgFiles%\CustomXML" 2
	IF EXIST "%ProgFiles%\ftpserver\" CALL :RemDir "%ProgFiles%\ftpserver" 2
	IF EXIST "%PERSONAL%\SYS\" CALL :RemDir "%PERSONAL%\SYS" 2
	IF EXIST "%ProgFiles%\prefer\" CALL :RemDir "%ProgFiles%\prefer"
	IF EXIST "%ProgFiles%\BanDai\" CALL :RemDir "%ProgFiles%\BanDai"
	IF EXIST "%ProgFiles%\Favorite\" CALL :RemDir "%ProgFiles%\Favorite"
	IF EXIST "%ProgFiles%\Guage\" CALL :RemDir "%ProgFiles%\Guage"
	IF EXIST "%ProgFiles%\INITECH\" CALL :RemDir "%ProgFiles%\INITECH"
	IF EXIST "%ProgFiles%\Web Publsh\" CALL :RemDir "%ProgFiles%\Web Publsh"
	IF EXIST "%ProgFiles%\WebSiteViewer\" CALL :RemDir "%ProgFiles%\WebSiteViewer"
	IF EXIST "%ProgFiles%\Webwin\" CALL :RemDir "%ProgFiles%\Win" 3
	IF EXIST "%System%\usb\" CALL :RemDir "%System%\usb" 3
	IF EXIST  "%ProgFiles%\SmartToolbar\" CALL :RemDir "%ProgFiles%\SmartToolbar" 2
	IF EXIST "%ProgFiles%\Recover Keys\" CALL :RemDir "%ProgFiles%\Recover Keys"
	IF EXIST "%System%\Sysfonts\" CALL :RemDir "%System%\Sysfonts" 3
	IF EXIST  "%AppData%\whitepixel\" CALL :RemDir "%AppData%\whitepixel" 2
	IF EXIST "%ProgFiles%\SystemPro\" CALL :RemDir "%ProgFiles%\SystemPro" 2
	IF EXIST "%ProgFiles%\FileSystem\" CALL :RemDir "%ProgFiles%\FileSystem"
	IF EXIST "%System%\install\" CALL :RemDir "%System%\install"
	IF EXIST "%ProgFiles%\ktorrent_setup\" CALL :RemDir "%ProgFiles%\ktorrent_setup"
	IF EXIST "%ProgFiles%\ktorrnet\" CALL :RemDir "%ProgFiles%\ktorrnet" 2
	IF EXIST "%ProgFiles%\TTPlayer\" CALL :RemDir "%ProgFiles%\TTPlayer" 2
	IF EXIST "%ProgFiles%\SiL\" CALL :RemDir "%ProgFiles%\SiL"
	IF EXIST "%AppData%\Skipe\logg.dat" CALL :RemDir "%AppData%\Skipe" 2
	IF EXIST "%CommonAppData%\Megic\" CALL :RemDir "%CommonAppData%\Megic"
	IF EXIST "%system%\xpdrivers\" CALL :RemDir "%system%\xpdrivers" 4
	IF EXIST "%ProgFiles%\AVG Antivirus 2011\" CALL :RemDir "%ProgFiles%\AVG Antivirus 2011" 3
	IF EXIST "%ProgFiles%\Scpad\" CALL :RemDir "%ProgFiles%\Scpad" 2
	IF EXIST "%ProgFiles%\lang\" CALL :RemDir "%ProgFiles%\lang" 2
	IF EXIST "%ProgFiles%\WizPop\" CALL :RemDir "%ProgFiles%\WizPop" 2
	IF EXIST "%SystemRoot%\configuration\" CALL :RemDir "%SystemRoot%\configuration" 2
	IF EXIST "%SYSTEMDRIVE%\Internet Explorer\" CALL :RemDir "%SYSTEMDRIVE%\Internet Explorer" 2
	IF EXIST "%SYSTEMDRIVE%\drivesguideinfo\" CALL :RemDir "%SYSTEMDRIVE%\drivesguideinfo" 2
	IF EXIST "%systemroot%\share\" CALL :RemDir "%systemroot%\share" 2
	IF EXIST "%ProgFiles%\Javascript\" CALL :RemDir "%ProgFiles%\Javascript" 2
	IF EXIST "%system%\Projects\" CALL :RemDir "%system%\Projects"
	IF EXIST "%ProgFiles%\ComTime\" CALL :RemDir "%ProgFiles%\ComTime" 2
	IF EXIST "%CommonProgFiles%\Setter\" CALL :RemDir "%CommonProgFiles%\Setter"
	IF EXIST "%ProgFiles%\Registration\" CALL :RemDir "%ProgFiles%\Registration" 2
	IF EXIST "%ProgFiles%\sysload\" CALL :RemDir "%ProgFiles%\sysload" 23
	IF EXIST "%ProgFiles%\Jeek\" CALL :RemDir "%ProgFiles%\Jeek"
	IF EXIST "%ProgFiles%\scheed\" CALL :RemDir "%ProgFiles%\scheed"
	IF EXIST "%ProgFiles%\Nvidia-Driver\" CALL :RemDir "%ProgFiles%\Nvidia-Driver"
	IF EXIST "%ProgFiles%\A1\" CALL :RemDir "%ProgFiles%\A1"
	IF EXIST "%ProgFiles%\info1\" CALL :RemDir "%ProgFiles%\info1"
	IF EXIST "%System%\internet\" CALL :RemDir "%System%\internet"
	IF EXIST "%AppData%\Microsoft Installer\" CALL :RemDir "%AppData%\Microsoft Installer"
	IF EXIST "%system%\sound\" CALL :RemDir "%system%\sound"
	IF EXIST "%SYSTEMDRIVE%\SystemData\" CALL :RemDir "%SYSTEMDRIVE%\SystemData"
	IF EXIST "%ProgFiles%\skplus\" CALL :RemDir "%ProgFiles%\skplus"
	IF EXIST "%SYSTEMDRIVE%\programfiles\" CALL :RemDir "%SYSTEMDRIVE%\programfiles" 3
	IF EXIST "%Progfiles%\start\" CALL :RemDir "%Progfiles%\start" 2
	IF EXIST "%ProgFiles%\AliWang\" CALL :RemDir "%ProgrFiles%\AliWang"
	IF EXIST "%Systemdrive%\ProgramData\BHO\" CALL :RemDir "%Systemdrive%\ProgramData\BHO" 2
	IF EXIST "%ProgFiles%\SunJava\" CALL ;RemDir "%ProgFiles%\SunJava" 2
	IF EXIST "%SYSTEMDRIVE%\program-files\" CALL :RemDir "%SYSTEMDRIVE%\program-files" 2
	IF EXIST "%ProgFiles%\ActiveDeskTop\" CALL :RemDir "%ProgFiles%\ActiveDeskTop" 2
	IF EXIST "%ProgFiles%\photo chop\" CALL :RemDir "%ProgFiles%\photo chop" 2
	IF EXIST "%ProgFiles%\hotmail\" CALL :RemDir "%ProgFiles%\hotmail"
	IF EXIST "%ProgFiles%\a2ttk\" CALL :RemDir "%ProgFiles%\a2ttk"
	IF EXIST "%ProgFiles%\destery" CALL :RemDir "%ProgFiles%\destery"
	IF EXIST "%ProgFiles%\SysFont\" CALL :RemDir "%ProgFiles%\SysFont"
	IF EXIST "%ProgFiles%\woodme\" CALL :RemDir "%ProgFiles%\woodme" 2
	IF EXIST "%ProgFiles%\Business\" CALL :RemDir "%ProgFiles%\Business" 2
	IF EXIST "%systemroot%\bart\" CALL :RemDir "%systemroot%\bart" 3
		)

@FOR /F "TOKENS=*" %%G IN (' PEV -fs32 -t!o -rtd %systemdrive%\???????.Bin ') DO @CALL :RemDir "%%~G" 2
@FOR /F "TOKENS=*" %%G IN (' PEV -fs32 -t!o -rtd %systemdrive%\??????????*.exe ') DO @CALL :RemDir "%%~G" 2
@FOR /F "TOKENS=*" %%G IN (' PEV -fs32 -t!o -rtd %systemdrive%\??????????* not "* *" ') DO @IF EXIST "%%G\config.bin" (
	CALL :RemDir "%%~G" 2
	IF EXIST "%%G\%%~NG.exe" ECHO."%%G\%%~NG.exe">>d-delA.dat
	)

@PEV -fs32 -t!o -rtd "%ProgFiles%\*%%*%%*" | SED "s/%%/&&/g" >remdir00
@FOR /F "TOKENS=*" %%G IN ( remdir00 ) DO @CALL :RemDir "%%~G" 2
@DEL /A/F remdir00

@PEV -tf -tpmz -t!o -dcg30 "%AllUsersProfile%\*.exe" -preg"%AllUsersProfile:\=\\%\\[^\\]*\\[^\\]*\.exe$" >remdir00
SED -r "/\\[0-9a-z]{8,16}\\[0-9a-z]{8,16}\.exe$/I!d;  /\\[^\\]*([a-z][^\\]*[A-Z][^\\]*[a-z]|[A-Z][^\\]*[a-z][^\\]*[A-Z]|[0-9][^\\]*[a-z][^\\]*[A-Z]|[a-z][^\\]*[0-9][^\\]*[A-Z]|[A-Z]{2,}[^\\]*[a-z]|[A-Z][^\\]*[0-9}{2,}[^\\]*[a-z])[^\\]*\\[^\\]*([a-z][^\\]*[A-Z][^\\]*[a-z]|[A-Z][^\\]*[a-z][^\\]*[A-Z]|[0-9][^\\]*[a-z][^\\]*[A-Z]|[a-z][^\\]*[0-9][^\\]*[A-Z]|[A-Z]{2,}[^\\]*[a-z]|[A-Z][^\\]*[0-9}{2,}[^\\]*[a-z])[^\\]*\.exe$/!d; s/\\[^\\]*$//" remdir00 > remdir01
@FOR /F "TOKENS=*" %%G IN ( remdir01 ) DO CALL :RemDir "%%~G"
@DEL /A/F/Q remdir0?
@GOTO :EOF


:REMDIR
@IF "%~1"=="" GOTO :EOF
@SET P@TH="%~1"
@SET P@TH=%P@TH:\"="%
@SET "NOS=%~2"
@IF NOT DEFINED NOS SET NOS=1
REM @PEV -fs32 -tx50000 -tf "%P@TH:"=%\*" >FolderContentCount.0
@ATTRIB "%P@TH:"=%\*" /S >FolderContentCount.0
@GREP -Fc :\ FolderContentCount.0 | GREP -sqx "[0-%NOS%]" &&ECHO.%P@TH%>>CFolders.dat
@DEL /A/F FolderContentCount.0
@GOTO :EOF


:WRPcheck
@SED -r "s/^\s*//; s/\s*$//; s/\x22//g; /^.:\\/!d; s/\\\\+/\\/g; s/\\$//; /^.:\\/!d; /%systemdrive%\\Qoobox(\\|$)/Id" "%~1" >WRPcheck00
@MOVE /Y WRPcheck00 "%~1"
@IF EXIST Vista.krl GOTO :EOF
@IF NOT EXIST "%~1" GOTO :EOF
@IF NOT EXIST "%system%\sfcfiles.dll" %KMD% /D /C ND_.bat "%system%\sfcfiles.dll" "SFC_MISSING"
@IF NOT EXIST "%system%\sfcfiles.dll" (
	ECHO.::::>"%~1"
	GOTO :EOF
	)
@IF NOT EXIST WFPList.dat (
	TYPE %system%\sfcfiles.dll 2>&1| GSAR -F -s:x1a -r > WRPcheck01
	SED -r "s/\x00{2,}/\n/g; s/\x00//g;" WRPcheck01 > WRPcheck02
	GREP  "^%%.*\\." WRPcheck02 > WRPcheck03
	SORT /M 65536 WRPcheck03 /O WRPcheck04
	SED -r "$!N; /^(.*)\n\1$/I!P; D" WRPcheck04 | SED -r "s/%%systemroot\%%/%systemroot:\=\\%/I; s/%%commonProgFiles\%%/%commonProgFiles:\=\\%/I; s/%%ProgFiles\%%/%ProgFiles:\=\\%/I" >WFPList.dat
	ECHO.::::>>WFPList.dat
	DEL /A/F/Q WRPcheck0?
	)
@GREP -Fivxf WFPList.dat "%~1" > TempList
@MOVE /Y TempList "%~1"
@GOTO :EOF

:ND_sub
@IF EXIST "%~NX1.ND_" GOTO :EOF
@ECHO.
@ECHO.System file is infected !! Attempting to restore
@ECHO.  "%~1"
@%KMD% /D /C ND_.bat "%~1" >N_\%random% 2>&1
@IF EXIST "%~NX1.ND_" GREP -Fs ":)" "%~NX1.ND_"
@GOTO :EOF

:ND_Patched_sub
@%KMD% /D /C MoveIt.bat "%~1" ND_ >N_\%random% 2>&1
@ECHO.
@ECHO.File is infected !! Attempting to restore
@ECHO.  "%~1"
@%KMD% /D /C ND_.bat %* >N_\%random% 2>&1
@IF EXIST "%~NX1.ND_" GREP -Fs ":)" "%~NX1.ND_"
@GOTO :EOF


:FSmoke
@PEV -fs32 -t!k -t!o -rtp -c##c#m#h#u#y#b#f#  { %system%\* or %system%\drivers\* or %SystemRoot%\* } and { *.exe or *.dll } | GREP -Fiv 0x00000000 | SORT /M 65536 /O FSmoke00
@PEV -fs32 -t!k -t!o -rt!pmz -c##c#m#h#u#y#b#f#  { %system%\* or %system%\drivers\* or %SystemRoot%\* } and { *.exe or *.dll } | SORT /M 65536 >>FSmoke00
@ECHO.>>FSmoke00
@SED -n -r "$!N; s/^([^\t]*\t).*\1[^\n]*\'/&/; ta; bc; :a; $!N; s/^([^\t]*\t).*\1[^\n]*\'/&/; ta; h; s/(.*)\n.*/\1/; s/[^\n]*\t//gp; g; s/.*\n(.*\n.*)/\1/; :c; D; " FSmoke00 >>d-delA.dat
@ECHO.>>FSmoke00
@DEL FSmoke00
@GOTO :EOF

:SoftAV
@IF "%~1"=="" GOTO :EOF
@SET "TargetX=%~1"
@PEV -fs32 -dcG30 -tx50000 -tf "%~1\*" and -preg"%TargetX:\=\\%\\([^\\]{6,}\\[^\\]{3,}(sysguard|sftav|tssd|shdw|uqiw|lanw)\.exe(\d*|)|[^\\]{3}\\sv.host.exe|[^ \\]{11,}\\([^\\]*Guard Online[^\\]*\.ico|Cloud Protection\.ico|Cloud AV [^\\]*\.ico|[^\\]*Protection Online\.ico|System *Security *2011.ico|csrss\.exe))$" -output:SoftAV00
@TYPE SoftAV00 >>d-delA.dat
@FOR /F "TOKENS=*" %%G IN ( SoftAV00 ) DO @CALL :REMDIR "%%~DPG"
@PEV -fs32 -t!o -tx50000 -tf "%~1\*" and -s100000-176000 -preg"%TargetX:\=\\%\\([a-z]{4,5}\\[a-z]{4,6}|[0-9a-f]{4,8}\\[0-9a-f]{4,8})\.exe$" or { { -s-600 not -preg"\.(log|dat|txt|reg|cmd|bat|bin|reg|vb[se]|ini|lck|cfg|rpb)$" } or { *.exe -tp -t!k or -t!j } and -preg"%TargetX:\=\\%\\([a-z]{4,6}\\[a-z]{4,6}|[0-9a-f]{4,8}\\[0-9a-f]{4,8})\.[a-z]{3}$" } or "* .exe" -output:SoftAV01
@PEV -fs32 -t!o -tx50000 -tf -s89000-400000 -c##f#b#d@#k@#g# "%~1\*" and -preg"%TargetX:\=\\%\\([a-z]{4,6}\\[a-z]{4,6}|[0-9a-f]{4,6}\\[0-9a-f]{4,5})\.exe$" or "* .exe" -output:SoftAV02
@SED -R "/	([a-z]{6,}@@\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|(Agnitum Ltd.|.*@(bdmcon.exe|ACPIHST.EXE|WINHLP32.EXE))@.*|[-@]*)$/!d; s///" SoftAV02 >> SoftAV01
@SED -r "/	[-@]*$|\\([^\\]*)\\[^\\]*	\1/d; s/\t.*//" SoftAV02 >SoftAV03
@ECHO.::::>>SoftAv03
@PEV -rtf -Files:SoftAV03 -t!g >>SoftAV01
@FOR /F "TOKENS=*" %%G IN ( SoftAV01 ) DO @CALL :REMDIR "%%~DPG" 2
@PEV -fs32 -tpmz -tx50000 -tf "%~1\*" and -preg"%TargetX:\=\\%\\[a-f0-9]{8,}\\(X|U\\[0-9]{5,}[^\\]*\..)$" -output:SoftAV04
@TYPE SoftAV04 >>d-delA.dat
@FOR /F "TOKENS=*" %%G IN ( SoftAV04 ) DO @CALL :REMDIR "%%~DPG" 9
@DEL /A/F/Q SoftAV0?
@PEV -dcg25 -tx50000 -tf "%~1\*" -preg"%TargetX:\=\\%\\([^\\]*\\[a-z]{6,}\d\\msfteml.dll|Win[^\\]*[0-9][^\\]*\\(lsass|cssrs)\.create[^\\]*|[^\\]{3,5}\\(minerd.exe|usft_ext.dll|phatk.ptx|scrypt130511.cl|coinutil.dll|service.exe|ltc.exe))$" | SED -r "s/\\[^\\]*$//" >>CFolders.dat
@SET TargetX=
@GOTO :EOF


:LocalAppD
@IF "%~1"=="" GOTO :EOF
@SET "TargetX=%~1"
@PEV -tf -tpmz -t!o "%~1\?" -preg"%TargetX:\=\\%\\\{[^\\]*\}\\.$" | SED -r "s/\\.$//" > ZA_Fld00
@TYPE ZA_Fld00 >>CFolders.dat
@FOR /F "TOKENS=*" %%G IN ( ZA_Fld00 ) DO @IF EXIST "%Systemroot%\Installer\%%~nxG\" ECHO."%Systemroot%\Installer\%%~nxG">>CFolders.dat
@DEL /A/F/Q ZA_Fld00
@GOTO :EOF

:FREE
@SWXCACLS "%~1" /OA
@SWXCACLS "%~1" /P /GE:F /I ENABLE /Q
@ATTRIB -H -R -S -A "%~1"
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

:smtmp
@PEV -tx50000 -tf "%TEMP%\smtmp\1\*.lnk" | GREP -c . | GREP -sq .. || GOTO :EOF

FOR %%G IN ( "%TEMP%\smtmp\4\*" ) DO @IF NOT EXIST "%CommonDESKTOP%\%%~NXG" (
	ATTRIB -H -R -S -A "%%~G"
	COPY /Y "%%~G" "%CommonDESKTOP%"
	)

IF EXIST "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\" FOR %%G IN ( "%TEMP%\smtmp\2\*" ) DO @IF NOT EXIST "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\%%~NXG" (
	ATTRIB -H -R -S -A "%%~G"
	COPY /Y "%%~G" "%APPDATA%\Microsoft\Internet Explorer\Quick Launch"
	)

IF EXIST W?.mac IF EXIST "%AppData%\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\" FOR %%G IN ( "%TEMP%\smtmp\3\*" ) DO @IF NOT EXIST "%AppData%\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\%%~NXG" (
	ATTRIB -H -R -S -A "%%~G"3
	COPY /Y "%%~G" "%AppData%\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
	)

FOR %%G IN ( "%TEMP%\smtmp\1\*.LNK" ) DO @IF NOT EXIST "%CommonSTARTMENU%\%%~NXG" (
	ATTRIB -H -R -S -A "%%~G"
	COPY /Y "%%~G" "%CommonSTARTMENU%"
	)

FOR %%G IN ( "%CommonPROGRAMS%" ) DO @IF EXIST "%TEMP%\smtmp\1\%%~NXG\" (
	PUSHD "%TEMP%\smtmp\1\%%~NXG"
	PEV -tx50000 -tf *.LNK >"%~DP0temp00"
	POPD
	FOR /F "TOKENS=*" %%H IN ( temp00 ) DO @IF NOT EXIST  "%CommonPROGRAMS%\%%H" ECHO.F|XCOPY /c/f/h/r/k/y "%TEMP%\smtmp\1\%%~NXG\%%H" "%CommonPROGRAMS%\%%H"
	DEL temp00
	)

@XCOPY /e/c/i/f/h/r/k/y "%TEMP%\smtmp" "%systemdrive%\Qoobox\Quarantine\%temp::=%\smtmp"
@IF NOT EXIST Vista.krl GOTO :EOF

@(
ECHO.
ECHO.[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
ECHO."Start_TrackProgs"=dword:00000001
ECHO."Start_TrackDocs"=dword:00000001
)>> CregC.dat

@GOTO :EOF

:NetBT
@SWSC delete NetBT
@(
ECHO.REGEDIT4
ECHO.
ECHO.[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\NetBT]
ECHO."Type"=dword:00000001
ECHO."Start"=dword:00000001
ECHO."ErrorControl"=dword:00000001
ECHO."ImagePath"=hex^(2^):73,79,73,74,65,6d,33,32,5c,64,72,69,76,65,72,73,5c,6e,65,74,62,74,2e,73,79,73,00
ECHO."Group"="PNP_TDI"
)>NetBt.reg
@IF EXIST Vista.krl (
	SWSC create NetBT binpath= System32\DRIVERS\netbt.sys type= kernel group= PNP_TDI
	(
	ECHO."DependOnService"=hex^(7^):54,64,78,00,74,63,70,69,70,00,00
	ECHO."DisplayName"="@%%SystemRoot%%\\system32\\drivers\\netbt.sys,-2"
	ECHO."Description"="@%%SystemRoot%%\\system32\\drivers\\netbt.sys,-1"
	ECHO."DependOnGroup"=-
	ECHO."Tag"=-
	)>>NetBt.reg
	) ELSE (
	SWSC create NetBT binpath= System32\DRIVERS\netbt.sys type= kernel tag= yes group= PNP_TDI
	(
	ECHO."DependOnService"=hex^(7^):74,63,70,69,70,00,00
	REM ECHO."DependOnGroup"=hex^(7^):00
	ECHO."DisplayName"="NetBios over Tcpip"
	ECHO."Description"="NetBios over Tcpip"
	)>>NetBt.reg
	)
@(
ECHO.[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\NetBT\Linkage]
ECHO."OtherDependencies"=hex^(7^):54,63,70,69,70,00,00
)>>NetBt.reg
SWREG EXPORT "HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Linkage" tcpipLinkage.reg /NT4
SWREG EXPORT "HKLM\SYSTEM\CurrentControlSet\services\Tcpip6\Linkage" tcpip6Linkage.reg /NT4
SED ":a;/\\$/N; s/\\\n *//; ta; /^\x22/!d; /.{65535}/d;" tcpip*Linkage.reg | SORT /REC 65535 /R | SED -r ":a; $!N; s/^((\x22[^:,]*\):).*),00\n\2/\1/;ta;P;D" >>NetBt.reg
@REGT /s NetBt.reg
@NETSH winsock reset catalog
@NETSH int ip reset %systemdrive%\Qoobox\int_ipreset.log >%systemdrive%\Qoobox\int_ipreset7.log
@DEL /A/F/Q NetBt.reg  tcpip*Linkage.reg
@TYPE myNul.dat >CfReboot.dat
@GOTO :EOF

:IPSEC
@SWREG QUERY HKLM\SYSTEM\CurrentControlSet\Control\GroupOrderList /V PNP_TDI > PNP_TDI_00
@SED -r "/.*\t.{8}(..).*/!d; s//\1/" PNP_TDI_00 > PNP_TDI_01
@FOR /F %%G IN ( PNP_TDI_01 ) DO @SWREG ADD HKLM\SYSTEM\CurrentControlSet\Services\IPSec /v Tag /t reg_dword /d "%%G"
@DEL /A/F/Q PNP_TDI_0?
@TYPE myNul.dat >CfReboot.dat
@GOTO :EOF

:TDX
@SWREG QUERY HKLM\SYSTEM\CurrentControlSet\Control\GroupOrderList /V PNP_TDI > PNP_TDI_00
@SED -r "/.*\t.{8}/!d; s///; :a; s/([^,]{2})[^,]{6}/\1,/; ta" PNP_TDI_00 > PNP_TDI_01
@SWREG QUERY HKLM\SYSTEM\CurrentControlSet\Services\tcpip /v Tag > PNP_TDI_02
@SED -r "/.*\t.*\(0x(.*)\)$/I!d; s//0\1,/; s/.*(...)$/\1/" PNP_TDI_02 > PNP_TDI_03
@FOR /F "TOKENS=*" %%G IN ( PNP_TDI_03 ) DO @SED -r "s/.*%%G(..).*/\1/I" PNP_TDI_01 > PNP_TDI_04
@FOR /F %%G IN ( PNP_TDI_04 ) DO @SWREG ADD HKLM\SYSTEM\CurrentControlSet\Services\TDX /v Tag /t reg_dword /d "%%G"
@DEL /A/F/Q PNP_TDI_0?
@TYPE myNul.dat >CfReboot.dat
@GOTO :EOF

:BFE
@SWSC DELETE BFE
@SWSC CREATE BFE BINPATH= .
@SWREG RESTORE HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\BFE BFE.DAT /F
@TYPE myNul.dat >CfReboot.dat
@GOTO :EOF

:MpsSvc
@SWSC DELETE MpsSvc
@SWSC CREATE MpsSvc BINPATH= .
@SWREG RESTORE HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\MpsSvc MpsSvc.DAT /F
@TYPE myNul.dat >CfReboot.dat
@SWREG EXPORT "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SharedAccess" SharedAccess.dat
@SWREG RESTORE HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\SharedAccess ShAccess.DAT /F
@REGT /s SharedAccess.dat
@DEL /A/F SharedAccess.dat ShAccess.DAT
@GOTO :EOF

:IpHlpSvc
@TYPE myNul.dat >CfReboot.dat
@IF EXIST W7.mac (
	REGT /S IpHlpSvc.w7.dat
) ELSE IF EXIST W8.mac (
	REGT /S IpHlpSvc.w8.dat
) ELSE REGT /S IpHlpSvc.vista.dat
REM @NETSH WINSOCK RESET CATALOG
REM @NETSH INT IPV4 RESET RESET.LOG
REM @NETSH INT IPV6 RESET RESET.LOG
@DEL /A/F RESET.LOG
@GOTO :EOF

:BridgeMP
@SWREG QUERY HKLM\System\CurrentControlSet\Services\BridgeMP /V Device > temp00
@GREP -Fisq "\Device\{E0F6ACC3-F143-4E81-862D-1016A0BB062D}" temp00 || GOTO :EOF
@SWREG QUERY HKLM\System\CurrentControlSet\Services\BridgeMP\Enum /V 0 > temp01 ||(
	SWREG DELETE HKLM\System\CurrentControlSet\Services\BridgeMP /V Device
	GOTO :EOF
	)
@SED -r "/.*\t/!d; s///" temp01 > temp02
@FOR /F "TOKENS=*" %%G IN ( temp02 ) DO @SWREG QUERY "HKLM\System\CurrentControlSet\Enum\%%G" /V Driver| SED -r "/.*\t/!d; s///" > temp03
@IF NOT EXIST temp03 GOTO :EOF
@FOR /F "TOKENS=*" %%H IN ( temp03 ) DO @SWREG QUERY "HKLM\System\CurrentControlSet\Control\Class\%%H" /V NetCfgInstanceId | SED -r "/.*\t/!d; s//\\Device\\/" > temp04
@IF NOT EXIST temp04 GOTO :EOF
@FOR /F "TOKENS=*" %%G IN ( temp04 ) DO @SWREG ADD HKLM\System\CurrentControlSet\Services\BridgeMP /V Device /D "%%G"
@TYPE myNul.dat >CfReboot.dat
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
