

@PEV EXEC /S "%CD%\HIDEC.%cfExt%" "%CD%\SWREG.%cfext%" ACL "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_Beep" /RESET /Q

@IF EXIST RHDCntrl IF NOT EXIST W6432.dat IF NOT EXIST NoMbr.dat (
	START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k RMBR.%cfExt%
	RMBR | GREP -Eisqx "\\Device\\.* -> .* device not found|error: Read  A device attached to the system is not functioning." &&GOTO RHDCntrl
	PEV -k NIRKMD.%cfext%
	DEL /A/F/Q MBR.log
	)>N_\%random% 2>&1

@IF EXIST Rboot.dat GOTO BagleB


@IF NOT EXIST W6432.dat (
	COPY /Y/B catchme.%cfExt% Catchme.tmp  >N_\%random% 2>&1
	NIRCMDC EXEC HIDE catchme.tmp -l N_\%random% -xqDf "%system%\drivers" >katchNT-OS
	)

@IF NOT EXIST cf_dummy (
	SWREG ADD HKLM\Software\Swearware\dump\cf_dummy
	SWREG SAVE HKLM\Software\Swearware\dump\cf_dummy cfdummy
	SWREG DELETE HKLM\Software\Swearware\dump\cf_dummy
	)>N_\cfdummy00 2>&1 ELSE GOTO BagleB



:NTOS
FOR %%G IN (
"%system%\ntos.exe"
"%system%\oembios.exe"
"%system%\twext.exe"
"%system%\twex.exe"
"%system%\sdra64.exe"
"%system%\intel64.exe"
"%system%\wsnpoema.exe"
"%AppData%\ntos.exe"
"%AppData%\oembios.exe"
"%AppData%\twext.exe"
"%AppData%\twex.exe"
"%AppData%\sdra64.exe"
"%AppData%\intel64.exe"
"%AppData%\wsnpoema.exe"
"%system%\swin32.exe"
"%AppData%\swin32.exe"
"%SystemRoot%\localsys64.exe"
"%system%\localsys64.exe"
"%AppData%\localsys64.exe"
"%system%\64dlls.exe"
"%AppData%\64dlls.exe"
"%system%\sdra73.exe"
"%AppData%\sdra73.exe"
"%system%\lsjdfh.exe"
"%AppData%\Kernel32.exe"
"%systemroot%\host32.exe"
"%system%\win32avs.exe"
"%AppData%\win32avs.exe"
) DO @IF NOT EXIST  RkDetectB_%%~NG.dat IF NOT EXIST %%G (
	TYPE myNul.dat >%%G
	IF NOT EXIST %%G (
		ECHO.%%G>>Catch_KB.dat
		CALL Catch-sub.cmd "%%~G"
		CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -i %%G >>RkDetectB_%%~NG.dat
		CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -E %%G >>RkDetectB_%%~NG.dat
		)
	DEL /A/F %%G
	)>N_\%random% 2>&1 ELSE (
	ECHO.%%G>>d-delA.dat
	CALL Catch-sub.cmd "%%~G"
	CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -i %%G >>RkDetectB_%%~NG.dat
	CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -E %%G >>RkDetectB_%%~NG.dat
	)>N_\%random% 2>&1


SWXCACLS PV.%cfext% /P /GE:F /Q
PV -m %KMD% 2>N_\%random% | GREP -Eisq "\\(Wininet|iertutil)\.dll$" &&(
	Handle.%cfext% -a -p csrss.exe | GREP -Eic ": Thread {5,}Handle\.%cfext%\(" | GREP -sqx "[^01]" &&(
		SWREG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" >Zbot00
		SED -r "/^ +\{.{36}}	.*%Appdata:\=\\%\\[a-z]{4,6}\\[a-z]{4,5}\.exe/I!d; s/.*	//; s/\x22//g" Zbot00 >Zbot01
		FOR /F "TOKENS=*" %%G IN ( Zbot01 ) DO @(
			IF EXIST "%%~G" ECHO.%%~G>>Catch_KB.dat
			CALL :REMDIR "%%~DPG" 2
			)
		DEL /A/F/Q Zbot0?
		)
	)>N_\%random% 2>&1

@IF NOT EXIST "%system%\userinit.exe" COPY /Y /B "%SystemRoot%\explorer.exe" "%system%\userinit.exe" >N_\%random% 2>&1
IF EXIST Catch_KB.dat COPY /Y Catch_KB.dat %SystemDrive%\Qoobox\LastRun\RK_Catch_KB.dat >N_\%random% 2>&1




:WAREOUT
SWREG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V "system" >WareOut00
FINDSTR -IRXC:".*	kd...\.exe" WareOut00 >WareOut01 &&(
	FOR /F "TOKENS=2*" %%G IN ( WareOut01 ) DO @IF NOT EXIST "%system%\%%H" (
		TYPE myNul.dat >"%system%\%%H"
		IF NOT EXIST "%system%\%%H" (
			ECHO."%system%\%%H">>Catch_KB.dat
			CALL Catch-sub.cmd "%%~H"
			SWREG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v System
			SWREG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v System
			)
		DEL /A/F "%system%\%%H"
		) )>N_\%random% 2>&1
DEL /A/F WareOut0? /Q >N_\%random% 2>&1

IF EXIST Catch_KB.dat COPY /Y Catch_KB.dat %SystemDrive%\Qoobox\LastRun\RK_Catch_KB.dat >N_\%random% 2>&1




:PSYCHE
IF NOT EXIST PSY00 (
	FOR %%G IN (
	Psyche
	PsycheEnqueue
	) DO @(
		SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%G" &&(
			ECHO."-------\Service_%%G">>RKBootSvc
			SWREG EXPORT "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Service_%%G.reg.dat" /NT4
			SWREG DELETE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%G"
			)
		SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_%%G" &&(
			ECHO."-------\Legacy_%%G">>RKBootSvc
			SWREG ACL "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%G" /GE:F /Q
			SWREG EXPORT "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_%%G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Legacy_%%G.reg.dat" /NT4
			SWREG DELETE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_%%G"
			)
	PEV -fs32 -rtf %system%\%%G.exe >>PSY00 &&CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -Z "%SystemDrive%\Qoobox\Quarantine\%system::=%\_%%G_.exe.zip" -k "%system%\%%G.exe"
	) >N_\%random% 2>&1
	)ELSE DEL /A/F PSY00


IF EXIST PSY00 FINDSTR . PSY00 >N_\%random% 2>&1 &&( TYPE PSY00 >>Catch_KB.dat )|| DEL /A/F PSY00
IF EXIST Catch_KB.dat COPY /Y Catch_KB.dat %SystemDrive%\Qoobox\LastRun\RK_Catch_KB.dat >N_\%random% 2>&1




:ZLOB
SWREG QUERY hklm\system\currentcontrolset\services >Zlob00
GREP -Ei \\[a-f0-9]{16}$ Zlob00 >Zlob01

FOR /F %%G IN  ( Zlob01 ) DO @SWREG QUERY %%G >N_\%random% 2>&1 ||(
	SWREG ACL %%G /RESET /Q
	SWREG QUERY %%G /V ImagePath >Zlob02
	SED -r "/.*(.:\\.*\\%%~NXG\\%%~NXG)$/I!d; s//\1/" Zlob02 >Zlob03

	FOR /F "TOKENS=*" %%H IN ( Zlob03 ) DO @(
		SWXCACLS "%%~DPH" | FINDSTR -IC:"Owner: S-1-0 " &&SWXCACLS "%%~DPH" /RESET /Q
		FINDSTR -MIL \kinject. "%%~H" >>Catch_KB.dat &&(
			SWREG EXPORT %%G "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Service_%%~NXG.reg.dat" /NT4
			SWREG DELETE %%G
			SWREG ACL HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_%%~NXG /GE:F /Q
			SWREG EXPORT HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_%%~NXG "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Legacy_%%~NXG.reg.dat" /NT4
			SWREG DELETE HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_%%~NXG
			PEV -fs32 -rtf "%%~DPH*" | GREP -c . | GREP -sqx [0-3] &&ECHO."%%~DPH">>CFolders.dat
			ECHO.%%~NXG>>zhSvc.dat
			))

	DEL /A/F Zlob02 Zlob3
	)>N_\%random% 2>&1
DEL /A/F Zlob00

IF EXIST Catch_KB.dat COPY /Y Catch_KB.dat %SystemDrive%\Qoobox\LastRun\RK_Catch_KB.dat >N_\%random% 2>&1





:Bagle
IF NOT EXIST RkDetectAA_srosa.dat FOR %%G IN (
	"%system%\drivers\srosa.sys"
	"%AppData%\drivers\srosa.sys"
	"%system%\drivers\wfsintwq.sys"
	"%system%\wfsintwq.sys"
	"%AppData%\drivers\wfsintwq.sys"
) DO @DIR /A-D %%G >N_\%random% 2>&1 &&(
	@DEL /A/F %%G
	@IF EXIST %%G (
		SWREG ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Hardware Profiles\Current\System\CurrentControlSet\Enum\Root\LEGACY_SROSA\0000" /v CSConfigFlags /T REG_DWORD /D 1
		SWREG LINK ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\deleteme%arbitrary%" "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\srosa" /temp
		SWREG RESTORE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\deleteme%arbitrary%" cfdummy /F
		CALL Catch-sub.cmd %%G
		ECHO.%%G| MTEE RkDetectA_srosa.dat >>Catch_KB.dat
		) )>N_\%random% 2>&1

IF NOT EXIST RkDetectAA_111111s1ro1s1a.dat FOR %%G IN (
	"%system%\drivers\11s11ro1s1a2.sys"
	"%AppData%\Drivers\11s11ro1s1a2.sys"
) DO @DIR /A-D %%G >N_\%random% 2>&1 &&(
		SWREG ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Hardware Profiles\Current\System\CurrentControlSet\Enum\Root\LEGACY_111111s1ro1s1a\0000" /v CSConfigFlags /T REG_DWORD /D 1
		SWREG LINK ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\deleteme%arbitrary%" "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\111111s1ro1s1a" /temp
		SWREG RESTORE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\deleteme%arbitrary%" cfdummy /F
		CALL Catch-sub.cmd %%G
		ECHO.%%G| MTEE RkDetectA_111111s1ro1s1a.dat >>Catch_KB.dat
		)>N_\%random% 2>&1


IF EXIST W32B_Diag.dat (
	SWREG ACL "HKLM\SYSTEM\CurrentControlSet\Enum\Root\*PNP0296" /RESET /Q
	SWREG DELETE "HKLM\SYSTEM\CurrentControlSet\Enum\Root\*PNP0296"
	IF EXIST "%systemroot%\WinSxS\x86_Microsoft.Windows.Shell.HWEventDetector_6595b64144ccf1df_5.2.2.3_x-ww_5390e909\shsvcs.dll" ECHO."%systemroot%\WinSxS\x86_Microsoft.Windows.Shell.HWEventDetector_6595b64144ccf1df_5.2.2.3_x-ww_5390e909\shsvcs.dll">>Catch_KB.dat
	IF EXIST "%systemroot%\assembly\GAC\__AssemblyInfo__.ini" ECHO."%systemroot%\assembly\GAC\__AssemblyInfo__.ini">>Catch_KB.dat
	rem IF EXIST "%systemroot%\assembly\GAC_MSIL\ " ECHO."%systemroot%\assembly\GAC_MSIL\ ">>Catch_KB.dat
	IF EXIST "%systemroot%\assembly\GAC_MSIL\desktop.ini" ECHO."%systemroot%\assembly\GAC_MSIL\desktop.ini">>Catch_KB.dat
	FOR /F "TOKENS=*" %%G IN ( W32B_Diag.dat ) DO @IF EXIST "%%~G" (
		%KMD% /D /C MoveIt.bat "%%~G"
		ECHO.%%G>>Catch_KB.dat
		)
	DEL /A/F W32B_Diag.dat
	)>N_\%random% 2>&1


IF EXIST Catch_KB.dat COPY /Y Catch_KB.dat %SystemDrive%\Qoobox\LastRun\RK_Catch_KB.dat >N_\%random% 2>&1



GOTO Core_DLL
:: OBSOLETE ::
SET "TDSvar=dgm|uac|tdss|seneka|quadra|msqpdx|gaopdx|ovfsth|gxvxc|kungsf|msivx|wzszx|hjgrui|esqul|geyekr|vsfoce|ytasfw|kbiwkm|rotscx|gasfky|h8srt|_Void|4DW4R3|Pragma"
SWREG SAVE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services" temp00 >N_\%random% 2>&1
IF NOT EXIST temp00 IF NOT EXIST W2k.mac REG.exe SAVE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services" temp00 >N_\%random% 2>&1
PEV -fs32 -rtf -s+250000 temp00 >N_\%random% &&( DumpHive -e temp00 nt-osSvcDump00 >N_\%random% 2>&1 )|| CALL :GetSysHive >N_\%random% 2>&1
SED -r -e "/./{H;$!d;}" -e "x;/@Ace=.ACCESS_DENIED_ACE_TYPE:|@DACL=\(.* 0000\)|\[Services\\(%TDSvar%).[^\\]*\]\n/I!d;" nt-osSvcDump00 >temp02 2>N_\%random%
SED -r "/^\[Services\\([^\\]*)(]|\\.*])$/!d; s::\1:; /tdsshbecr/Id" temp02 >temp03
PEV TDF nt-osSvcDump00 >temp04


FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp04 ) DO @(
	SED -r "/./{H;$!d;};x;/\n\[Services\\%%G%%H\]/!d; s/.*\n\x22imagepath\x22=expand:\x22(\\\\)systemroot\1system32\1drivers\1(%%G[a-z]{8}\.sys)\x22.*/%system:\=\\%\\drivers\\\2/" nt-osSvcDump00 >temp05
	FOR /F "TOKENS=*" %%I IN ( temp05 ) DO @IF NOT EXIST "%%I" (
		ECHO.%%G%%H>>temp03
		CALL :setTDS "%%~G"
		)
	DEL /A/F temp05
	)>N_\%random% 2>&1

SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" temp03 >temp06
FINDSTR -BI "%TDSvar:|= %" temp06 >svctdss
FOR /F "TOKENS=*" %%G IN ( svctdss ) DO @(
	CALL :TDSS_B "%%~G" >N_\%random% 2>&1
	ECHO.%%G
	)>>zhSvc.dat
HANDLE . | SED -r "/.*: (%system:\=\\%\\(drivers\\|)(%TDSvar:*uac|=%))/I!d; s//\1/" | GREP -s . >filetdss && TYPE filetdss >>Catch_KB.dat
IF NOT EXIST Vista.krl FOR /F "TOKENS=*" %%G IN ( temp06 ) DO @SWREG ACL "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%G" /RESET /Q
DEL /A/F/Q temp0? svctdss filetdss >N_\%random% 2>&1
IF EXIST Catch_KB.dat COPY /Y Catch_KB.dat %SystemDrive%\Qoobox\LastRun\RK_Catch_KB.dat >N_\%random% 2>&1




:Core_DLL
:: German Banker
IF EXIST Core_DLL DEL /A/F Core_DLL &&GOTO Win32x
SED -r -e "/./{H;$!d;}" -e "x;/\n.ImagePath.=.*%system:\=\\\\%\\\\\.([^\\]{8,})\\\\\1\.exe.\n/I!d;" nt-osSvcDump00 2>&1|(
	SED -r "/^\[Services\\([^\\]*)(]|\\.*])$|.ImagePath.=expand:/!d; s::\1:; s/\\\\/\\/g" | SED "N;s/\n/	/" )>CoreDLL02

FOR /F "TOKENS=1* DELIMS=	" %%G IN  ( CoreDLL02 ) DO @FINDSTR -MI "i.t.t.e.l.l.i.g.e.n.t.\..n.e.t a.v.2.c.h.e.c.k.\..n.e.t <.SafeArrayDestroy..O.SetErrorInfo" "%%~H" >N_\%random% 2>&1 &&@(
	ECHO.%%H| MTEE Core_DLL RkDetectA_CoreDLL.dat >>Catch_KB.dat
	ECHO."-------\Service_%%~G">>RKBootSvc
	SWREG EXPORT "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Service_%%~G.reg.dat" /NT4
	SWREG DELETE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G"
	SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_%%G" &&(
			ECHO."-------\Legacy_%%~G">>RKBootSvc
			SWREG ACL "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%~G" /GE:F /Q
			SWREG EXPORT "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Legacy_%%~G.reg.dat" /NT4
			SWREG DELETE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_%%~G"
			) )>N_\%random% 2>&1
DEL /A/F/Q CoreDLL0? >N_\%random% 2>&1

IF EXIST Catch_KB.dat COPY /Y Catch_KB.dat %SystemDrive%\Qoobox\LastRun\RK_Catch_KB.dat >N_\%random% 2>&1



:Win32x
SWXCACLS PV.%cfext% /P /GE:F /Q
PV -d10000 -xa Catchme.tmp >N_\%random% 2>&1
IF EXIST KatchNT-OS SED -r "/^(%system:\=\\%\\drivers\\win32x\.sys).*/I!d; s//\1/" KatchNT-OS |GREP -s . >RkDetectA_Win32x.dat &&(
	TYPE RkDetectA_Win32x.dat >>Catch_KB.dat
	)|| DEL /A/F RkDetectA_Win32x.dat

PEV -fs32 -rtf -to -c##5#b#f# and %system%\*.dll and { -s=60928 or -s=60416 or -s=61952 or -s=63488 or -s=62976 or -s=62464 }  or { scecli.dll or netlogon.dll or eventlog.dll or cngaudit.dll } | SED -r "/!HASH: .*	/!d; s///" >ND_NTOS00
FOR /F "TOKENS=*" %%G IN ( ND_NTOS00 ) DO @(
	%KMD% /D /C ND_.bat "%%G"
	ECHO.>ND_NTOS-boot.dat
	)>N_\%random% 2>&1
DEL /A/F ND_NTOS00 >N_\%random% 2>&1

IF EXIST "%system%\drivers\maximo.sys" ECHO."%system%\drivers\maximo.sys">>Catch_KB.dat



IF EXIST wtf_tdssserv* (
	IF EXIST wtf_tdssserv TYPE myNul.dat >"%temp%\RkDetectA_tdssserv.dat"

IF EXIST QuerySvcTDSS FINDSTR REG_ QuerySvcTDSS ||(
	SWREG SAVE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services" temp00
	DumpHive -e temp00 temp01
	SED -r "/^\[Services\\([^\\]*)\\Modules\]$/I!d; s//\1/" temp01 >temp02
	FINDSTR -BLIG:wtf_tdssservB temp02 >temp03
	FOR /F "TOKENS=*" %%G IN ( temp03 ) DO @(
		ECHO."%%~G">>RkDetectA_tdssserv.dat
		CALL :TDSS_B "%%~G"
		)
	DEL /A/F/Q temp0?
	)
IF EXIST QuerySvcTDSS (
	GREP -Eisq "^ +ImagePath	.*\\." QuerySvcTDSS || IF EXIST katchNT-OS SED -r "/(%system:\=\\%\\drivers\\(%TDSvar%).*) [0-9]* bytes .*/I!d; s//\1/" katchNT-OS >TDSFile
	SED -r "/^ +(ImagePath|(%TDSvar%)[^	]*)	.*	.*\\System32((\\|\\Drivers\\)(%TDSvar%)[^\\]*)$/I!d; s//%system:\=\\%\3/" QuerySvcTDSS >>Catch_KB.dat
	SED -r "/^ +(ImagePath|(%TDSvar%)[^\t]*)\t.*\t.*\\Systemroot(\\(%TDSvar%)[^\\]{6,}\\(%TDSvar%)[^\\]*)$/I!d; s//%systemroot:\=\\%\3/" QuerySvcTDSS >>Catch_KB.dat
	IF EXIST TDSFile (
		FOR /F "TOKENS=*" %%Z IN ( TDSFile ) DO @CALL CATCH-SUB.cmd "%%~Z"
		TYPE TDSFile >>Catch_KB.dat
		DEL /A/F TDSFile
		)
	DEL /A/F QuerySvcTDSS
		) )>N_\%random% 2>&1


SET TDSvar=
DEL /A/F nt-osSvcDump00 >N_\%random% 2>&1
IF EXIST Catch_KB.dat COPY /Y Catch_KB.dat %SystemDrive%\Qoobox\LastRun\RK_Catch_KB.dat >N_\%random% 2>&1

IF EXIST W6432.dat GOTO NT-OS_EndA


@PEV -rtf -dcg60 -s+10000000 %system%\config\* -preg"\\[^\\.]{8}(\.sav|)$" not { software or system or default or sam } -output:max_.dat &&IF EXIST W?.mac (
		PEVB PDUMP > max_05
		SED "/./{H;$!d;};x;/\nSYSTEM (The Kernel)/I!d;" max_05 > max_06
		SED -R "/^Thread: \((\d*)\) .*\(0x[^)]*\)$/!d; s//\1/" max_06 > max_07
		GREP -sq . max_07 && CALL :MAX++
		DEL /A/F max_05 max_06 max_07
	)>N_\%random% 2>&1 ELSE (
		Handle -p System > handle_max00
		GREP -Fisqf max_.dat handle_max00 && CALL :MAX++
		DEL /A/F handle_max00
		)>N_\%random% 2>&1


PEV -rtd -te "%systemroot%\$NtUninstallKB*$" -output:KBJunctions00
IF EXIST Vista.krl (
	PEV -rtd "%systemroot%\$NtUninstallKB[0-9][0-9][0-9][0-9][0-9]$" >> KBJunctions00
) ELSE (
	PEV -rtd "%systemroot%\$NtUninstallKB[0-9][0-9][0-9][0-9][0-9]$" > maxKB.dat
	FOR /F "TOKENS=*" %%G IN ( maxKB.dat ) DO IF NOT EXIST "%%~G\spuninst\" ECHO."%%~G" >> KBJunctions00
	DEL /A/F maxKB.dat
	)>N_\%random% 2>&1
	
GREP -Fsq : KBJunctions00 &&(
	FOR /F "TOKENS=*" %%G IN ( KBJunctions00 ) DO @SWXCACLS "%%~G" /RESET /Q
	IF EXIST %System%\fsutil.exe FOR /F "TOKENS=*" %%G IN ( KBJunctions00 ) DO (
		%System%\fsutil.exe REPARSEPOINT DELETE "%%~G"
		ECHO."%%~G">>CFolders.dat
		PEV -tf "%%~G\*" -output:KBJunctions04
		FOR /F "TOKENS=*" %%G IN ( KBJunctions04 ) DO @%KMD% /D /C MoveIt.bat "%%~G"
		TYPE KBJunctions04 >> d-delA.dat
		IF NOT EXIST Max.mov CALL :MAX++
		DEL /A/F/Q KBJunctions0?
		)
	)>N_\%random% 2>&1

IF NOT EXIST Max.mov IF EXIST Max_WinDir_ADS PEV -rtf -t!pmz -s+4000000 "%System%\????????.dll" >> d-delA.dat && CALL :MAX++ >N_\%random% 2>&1
IF EXIST KBJunctions0? DEL /A/F/Q KBJunctions0? >N_\%random% 2>&1


IF NOT EXIST NoMbr.dat (
	CALL :Whistler
	START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k RMBR.%cfExt%
	RMBR
	PEV -k NIRKMD.%cfext%
	GREP -Eisqx "\\Device\\.* -> .* device not found|error: Read  A device attached to the system is not functioning." mbr.log && CALL :HDCntrl
	)>N_\%random% 2>&1

IF EXIST f_system CALL :VBR >N_\%random% 2>&1
	
IF EXIST katchNT-OS GREP -Fis "disk not found %systemdrive%\\" katchNT-OS >CatchmeTest.dat &&(
	CALL :HDCntrl >N_\%random% 2>&1
	)|| DEL /A/F CatchmeTest.dat
DEL /A/F/Q MBR.log HDCntrl0? >N_\%random% 2>&1

DEL /A/F/Q Alcohol0? katchNT-OS >N_\%random% 2>&1

:NT-OS_EndA
IF NOT EXIST TDL4mbr.dat (
IF EXIST RkDetectAA_*.dat GOTO :EOF
IF NOT EXIST CatchmeTest.dat IF NOT EXIST wtf_tdssserv IF NOT EXIST Catch_KB.dat IF NOT EXIST RkDetectA_* IF NOT EXIST Whistler.dat IF NOT EXIST WhistlerVBR.dat GOTO :EOF
)
CALL Boot-RK.cmd
EXIT


:TDSS_B
SWREG ACL "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%~1" /RESET /Q
SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%~1" /S >>QuerySvcTdss &&(
	ECHO."%~1">>Rktdssserv.dat
	SWREG EXPORT "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%~1" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Service_%~1.reg.dat" /NT4
	PEV EXEC /S "%CD%\HIDEC.%cfExt%" "%CD%\SWREG.%cfext%" ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_%~1\0000" /v Service /d "%~1"
	PEV EXEC /S "%CD%\HIDEC.%cfExt%" "%CD%\SWREG.%cfext%" ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_%~1\0000" /v ConfigFlags /t reg_dword /d 1
	SWREG ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_Beep\xx_%~1_xx" /v ConfigFlags /t reg_dword /d 1
	SWREG ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\LEGACY_Beep\xx_%~1_xx" /v Service /d "%~1"
	)
@GOTO :EOF



:BagleB
@FOR %%G IN (
	SROSA
	111111S1RO1S1A
) DO @IF EXIST RkDetectA_%%G.dat @(
	ECHO."-------\Service_%%G">>RKBootSvc
	ECHO."-------\Legacy_%%G">>RKBootSvc
	SWREG DELETE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%G"
	SWREG ACL "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%G" /OA
	SWREG ACL "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%G" /GE:F /Q
	SWREG DELETE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%G"
	MOVE /Y RkDetectA_%%G.dat RkDetectAA_%%G.dat
	)>N_\%random% 2>&1



IF EXIST RkDetectA_tdssserv.dat @(
	@>>Rktdssserv.dat (
	ECHO."TDSSSERV"
	ECHO."TDSSSERV.SYS"
	ECHO."TDSSSERV.SYS)"
	)
	FOR /F "TOKENS=*" %%G IN ( Rktdssserv.dat ) DO @(
		SWREG ACL "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G" /RESET /Q
		SWREG ACL "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%~G" /RESET /Q
		SWREG ACL "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%~G" /GE:F /Q
		SWREG DELETE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%~G" &&ECHO."-------\Service_%%~G">>RKBootSvc
		SWREG DELETE "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\Root\Legacy_%%G" &&ECHO."-------\Legacy_%%~G">>RKBootSvc
		)
	MOVE /Y RkDetectA_tdssserv.dat RkDetectAA_tdssserv.dat
	SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Hardware Profiles\Current\System\CurrentControlSet\Enum\Root" /s >temp00
	SED "/./{H;$!d;};x;/cSCONFIGFLAGs/!d;" temp00 | SED -r "/^(H.*)\\.*/I!d; s//[-\1]/" >>CregC.dat
	DEL /A/F Rktdssserv.dat temp00
	)>N_\%random% 2>&1


@IF EXIST res.bat (
	ECHO.Res.bat>cfReboot.dat
	%KMD% /C res.bat
	DEL /A/F/Q res.bat SW_*.reg
	)>N_\%random% 2>&1

 @IF EXIST "%systemroot%\assembly\GAC_MSIL\desktop.ini\" 	RD /S/Q  "\\?\%systemroot%\assembly\GAC_MSIL\desktop.ini" >N_\%random% 2>&1

@IF EXIST "\QooBox\32788R22FWJFW\" (
	START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k RMBR.%cfExt%
	RMBR -t | GREP -Eisqx "\\Device\\.* -> .* device not found|error: Read  A device attached to the system is not functioning." && GOTO RHDCntrl
	PEV -k NIRKMD.%cfext%
	PEV -c##f#b#d#i#k#g#e#j# "\QooBox\32788R22FWJFW\*" | SED -r "/\t-+$/!d; s///" >Qb327
	FOR /F "TOKENS=*" %%G IN ( Qb327 ) DO @FC "%%G" "%system%\drivers\%%~NXG" ||(
		MOVE /Y "%%G" "\QooBox\Quarantine\%system::=%\Drivers\%%~NXG.vir"
		CALL :HDCntrlB "%system%\drivers\%%~NXG" "Kitty had a snack :p"
		)
	DEL Qb327
	RD /S/Q "\QooBox\32788R22FWJFW"
	IF NOT EXIST %SystemDrive%\qoobox\lastrun\ndis_HDCntrl.old IF NOT EXIST %systemdrive%\Qoobox\LastRun\TDL4mbrDone.old ECHO.>%systemdrive%\Qoobox\LastRun\TDL4mbrDone.old
	)>N_\%random% 2>&1

@GOTO :EOF


:GetSysHive
IF EXIST "%system%\config\Sys_link00" DEL /A/F "%system%\config\Sys_link00"
IF EXIST f_system (
	PEV LINK "%system%\config\System" "%system%\config\Sys_link00"
	IF NOT EXIST "%system%\config\Sys_link00\" PEV MOVEEX "%system%\config\Sys_link00"
	CATCHME -l N_\%random% -c "%system%\config\Sys_link00" System
	) ELSE (
	CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -e pIofCallDriver
	CATCHME -l N_\%random% -c "%system%\config\System" System
	)
SWREG QUERY "hklm\system\select" /v "current"  >CurrentCS00
SED -r "/.*	/!d; s//00/; s/^[0-9]*(...) .*/@SET ControlSet=ControlSet\1/" CurrentCS00 >CS.bat
@ECHO.@ECHO.^>NULL >> CS.bat
CALL CS.bat
DUMPHIVE -e system System.dump
SED "/./{H;$!d;};x;/\[[^\\]*\\%ControlSet%\\Services\\/I!d" System.dump | SED "s/^\[[^\\]*\\[^\\]*\\/[/" >nt-osSvcDump00
IF EXIST "%system%\config\Sys_link00" (
	TYPE myNul.dat >CfReboot.dat
	PEV MOVEEX "%CD%\CfReboot.dat"
	)
DEL /A/F System System.dump CurrentCS00 CS.bat
@GOTO :EOF

:setTDS
@SET "TDSvar=%TDSvar%|%~1"
@GOTO :EOF


:HDCntrl
@IF EXIST katchNT-OS DEL /A/F katchNT-OS
@GOTO :EOF

@HANDLE -p System | SED -r "/: File  \(R--\)   (%systemdrive%(|\\pagefile.sys)$|%system:\=\\%\\drivers\\.)|^System pid: |.* %systemdrive%\\OMFG /I!d; /\\sr\.sys/Id" | SED -n -R "/^System/I!d; N; s/^System pid: (\d*) .*\n +(\S*):.*/Handle -p \1 -c \2 -y/wHDCntrl.bat"
@ECHO.@ECHO.^>NULL >> HDCntrl.bat
@CALL HDCntrl.bat
@DEL /A/F HDCntrl.bat


:HDCntrlC
@IF NOT EXIST "\QooBox\Quarantine\%system::=%\Drivers\" MD "\QooBox\Quarantine\%system::=%\Drivers"

@SWSC QUERYEX OPTIONS= config TYPE= driver  state= ALL >HDCntrlC00
@SED -r "/^(SERVICE_NAME: +|^  +(START_TYPE|BINARY_PATH_NAME) +:)/!d" HDCntrlC00 |SED -r ":a; $!N; s/\n  +/\t/;ta; P;D;" >HDCntrlC01
@SED -r "/SERVICE_NAME: (.*)	.*_TYPE +: [012].*System32(\\Drivers\\)/I!d; s//\1\t%system:\=\\%\2/" HDCntrlC01 >HDCntrl_List
@SED -r "/SERVICE_NAME: (.*)\tSTART_TYPE +: [012] .*: $/!d; s//%System:\=\\%\\drivers\\\1.sys/" HDCntrlC01 > HDCntrlC02
@ECHO.:::::>> HDCntrlC02
@PEV -r -filesHDCntrlC02 >>HDCntrl_List
@SED "s/.*\t//" HDCntrl_List >HDCntrlC03

@GREP -sq . HDCntrlC03 ||(
	@CSCRIPT //NOLOGO //E:VBSCRIPT //B //T:08 RunDrv.vbs
	@IF EXIST HDCntrl_List SED -r "/%system:\=\\%\\Drivers\\/I!d; s/^\\\?\?\\//; s/.*\t//" HDCntrl_List >HDCntrlC03
	)

@ECHO.::::>>HDCntrlC03
PEV -filesHDCntrlC03 -t!k -c##f#b#i#k#g# | SED -r "/	-{18}$/!d; s///" >HDCntrlC04


RMBR -t
@IF EXIST mbr.log GREP -sq "detected hooks:" mbr.log &&(
	GREP -Fsqx "user != kernel MBR !!! " mbr.log && GREP -sqx "sectors [0-9]* (+[0-9]*): user != kernel" mbr.log &&(
		IF NOT EXIST TDL4mbr.dat ECHO.>TDL4mbr.dat
		GOTO :TDLEOF
		)
	GREP -Eixsq "^\\Driver\\Disk\[.* -> IRP_MJ_CREATE -> 0x.{8}" mbr.log && GOTO :TDLEOF
	GREP -Eixsq "^\\Driver\\[^\\]* DriverStartIo -> 0x.{8}" mbr.log || GOTO :TDLEOF
	REM IF NOT EXIST Vista.krl GREP -Eixsq "^\\Driver\\[^\\]* DriverStartIo -> 0x.{8}" mbr.log || GOTO :TDLEOF
	RMBR -c 0 1 %SystemDrive%\Qoobox\Quarantine\MBR_HardDisk0.mbr
	GREP -c . %SystemDrive%\Qoobox\Quarantine\MBR_HardDisk0.mbr | GREP -sqx 1 ||(
		PEVB PDUMP >Pdump00
		SED "s/^[A-Z]/\n&/" Pdump00 | SED -r "/./{H;$!d;};x;/\nThread: \(..\) [^\n]*\\(ntkrnlpa|ntoskrnl).exe.*WaitReason:  \(0x0\) Executive/I!d;" | SED -R "/^Thread: \((\d*)\) .*/!d; s//\1/" | SED "$d; 1,5!d" >Pdump01
		FOR /F %%G IN ( Pdump01 ) DO @PEVB TSUSPEND %%G
		RMBR -w 0 %SystemDrive%\Qoobox\Quarantine\MBR_HardDisk0.mbr
		DEL /A/F/Q Pdump0?
		))


REM NIRCMD INFOBOX "Rootkit is detected~n~nBe patient as this may take some moments" "ROOTKIT"
START NIRCMD INFOBOX "%Line107%"

GREP -Fsq \ HDCntrlC04 &&@(
	IF NOT EXIST Vista.krl CALL :LockDown HDCntrlC04
	FINDSTR -LIEG:HDCntrlC04 HDCntrl_List >>HDCntrl04
	)>N_\%random% 2>&1


@IF NOT EXIST HDCntrl04 (
	IF NOT EXIST DIS_WFP CALL :DIS_WFP
	ECHO.>RkDetectA_HDCntrl.dat
	IF NOT EXIST Vista.krl (CALL :LockDown HDCntrlC03 ) ELSE ECHO.>RHDCntrl
	IF NOT EXIST "\QooBox\32788R22FWJFW" MD "\QooBox\32788R22FWJFW"
	FOR /F "TOKENS=*" %%G IN ( HDCntrlC03 ) DO @IF NOT "%%~G"=="::::" (
		CALL :FREE "%%~G"
		PEV -zip"%%~NXG.zip" "%%~G"
		PEV UZIP "%%~NXG.zip" "%CD%"
		PEV -rtf -s-1500 "%CD%\%%~NXG" && COPY /Y "%%~G"
		MOVE /Y "%%~G" "\QooBox\32788R22FWJFW"
		MOVE /Y "%%~NXG" "%system%\Drivers"
		CATCHME -l N_\%random% -i "%%~G"
		DEL /A/F "%%~NXG.zip"
		))

@PEV -filesHDCntrlC01 -r -s=0 -outputBadSys.dat &&FOR /F "TOKENS=*" %%G IN ( BadSys.dat ) DO @(
	CATCHME -l N_\%random% -i
	DEL /A/F "%%G"
	IF EXIST "\QooBox\32788R22FWJFW\%%~NXG" (
		COPY /Y "\QooBox\32788R22FWJFW\%%~NXG" "%%G"
		PEV -tp "%%G" || MOVE /Y "\QooBox\32788R22FWJFW\%%~NXG" "%%G"
		) )

@DEL /Q HDCntrlC0? BadSys.dat
PEV -k NIRCMD.%cfext%
PEV -k NIRKMD.%cfext%


IF EXIST sfx.cmd GREP -Eisq "\\CFScript[^:\/\\]*$" sfx.cmd && GREP -Fisq "TDL::" %sfxcmd% &&@(
	TYPE %sfxcmd% | SED "s/\r/\n/g" | SED -r "/^$/d; s/^\s*//; s/\s*$//; s/^\S*::/\n&/Ig; $G;" | SED -r "/^TDL::/I,/^$/!d; /::|^$/d" >CfScriptTDL00
	IF NOT EXIST Vista.krl FOR /F "TOKENS=*" %%G IN ( CfScriptTDL00 ) DO @CALL :HDCntrlD "%%~G"
	ECHO.::::>>CfScriptTDL00
	FINDSTR -LIEG:CfScriptTDL00 HDCntrl_List >>HDCntrl04
	DEL /A/F/Q CfScriptTDL0?
	)>N_\%random% 2>&1


:HDCntrl04
@IF EXIST HDCntrl04 SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" HDCntrl04 >HDCntrl05
@IF EXIST HDCntrl05 FOR /F "TOKENS=1* DELIMS=	" %%G IN ( HDCntrl05 ) DO @(
	IF NOT EXIST DIS_WFP CALL :DIS_WFP
	ECHO.%%G>>RkDetectA_HDCntrl.dat
	CALL :FREE "%%~H"
	PEV -ZIP"%%~NXH.123" "%%~H"

	PEV -s+1024 -rtf "%%~NXH.123" >N_\%random% &&(
			PEV UZIP "%%~NXH.123" .\
				)||(
			CATCHME -l N_\%random% -c "%%~H" "%%~NXH"
			PEV -rtf "%%~H" -c##c#b#m# | SED -r "s/(....)-(..)-(..)/\3-\2-\1/g" >dat_E.tmp
			FOR /F "TOKENS=1* DELIMS=	" %%I IN ( dat_E.tmp ) DO @NIRCMD SETFILETIME "%%~NXH" "%%~I" "%%~J"
			DEL /A/F dat_E.tmp
			PEV -ZIP"%%~NXH.123" "%%~NXH"
			)>N_\%random% 2>&1

	PEV -rtg "%%~NXH" &&(
			MOVE /Y "%%~NXH" "%%~DPNH.svs"
			PEV UZIP "%%~NXH.123" .\
			MOVE /Y "%%~NXH" "%%~NH"
			CALL :SwPath "%%~G" "%%~H"
			%KMD% /D /C MoveIt.bat "%%~H" ND_
			PEV UZIP "%%~NXH.123" .\
			MOVE /Y "%%~NXH" "%%~H" &&(
				PEV UZIP "%%~NXH.123" .\
				CATCHME -l N_\%random% -O "%%~H" "%%~NXH"
				CATCHME -l N_\%random% -i "%%~H"
				CALL :HDCntrlB "%%~H" "Kitty ate it :p"
				ECHO.%%G	%%H>>TDL2B.dat
					)|| %KMD% /D /C ND_.bat "%%~H" "HDCntrl"
		)||(
		CALL ND_.bat "%%~H" "FINDNOW_X"
		IF EXIST ND_05 (
			SED 1!d ND_05 >ND_06
			FOR /F "TOKENS=*" %%I IN ( ND_06 ) DO @(
				CALL :HDCntrlB "%%~H" "Kitty had a snack :p"
				ECHO.%%G	%%H>>TDL2B.dat
				CALL :FREE "%%~I"
				COPY /Y "%%~I" "%%~DPNH.svs"
				IF EXIST "%%~DPNH.svs" PEV -rtg "%%~DPNH.svs" &&(
						COPY /Y/B/V "%%~I" "%%~NI"
						CALL :SwPath "%%~G" "%%~H"
						)||DEL /A/F "%%~DPNH.svs"
					)
			DEL /A/F/Q ND0?
			)))


@IF EXIST erunt_sw.dat SED -r "1d; s/^\[.*\\CurrentControlSet\\/\[hkey_users\\temphive\\%CONTROLSET%\\/I" XPSboot.reg >>erunt_sw.dat
@DEL /A/Q/F HDCntrl0?
@GOTO :EOF


:TDLEOF
@PEV -r -to -filesHDCntrlC03 -c##f#b#d#i#k#g#j# >TDLEOF00
@SED -r "/	-{30}$/!d ;s///" TDLEOF00 > TDLEOF01
@ECHO.::::>> TDLEOF01
@PEV -rt!g -filesTDLEOF01 > TDLEOF02
@FOR /F "TOKENS=*" %%G IN ( TDLEOF02 ) DO @%KMD% /D /C ND_.bat "%%~G"
@DEL /A/F/Q TDLEOF0? HDCntrl_List HDCntrlC0?
@GOTO :EOF


:HDCntrlB
@REM CALL ECHO.Infected copy of %%~1 was found and disinfected >>%SystemDrive%\qoobox\lastrun\ndis_HDCntrl.old
@REM CALL ECHO.Restored copy from - %%~2 >>%SystemDrive%\qoobox\lastrun\ndis_HDCntrl.old
@CALL ECHO.%Line36% >>%SystemDrive%\qoobox\lastrun\ndis_HDCntrl.old
@CALL ECHO.%Line36A% >>%SystemDrive%\qoobox\lastrun\ndis_HDCntrl.old
@CALL ECHO..>>%SystemDrive%\qoobox\lastrun\ndis_HDCntrl.old
@GOTO :EOF


:HDCntrlD
@CATCHME -l N_\%random% -i "%~1"
@ECHO.%~1>>RkDetectA_HDCntrl.dat
@PEV WAIT 3200
@CATCHME -l N_\%random% -i
@CALL :FREE "%~1"
@PEV -zip"HDCntrlC.zip" -rtf "%~1"
@MOVE /Y "%~1" "\QooBox\Quarantine\%system::=%\Drivers\%~NX1.vir"
@PEV UZIP "HDCntrlC.zip" "%system%\drivers"
@DEL HDCntrlC.zip
@CALL :HDCntrlB "%~1" "Kitty had a snack :p"
@GOTO :EOF


:SWPATH
@CATCHME -l N_\%random% -i "%~DPN2.svs"
@SETLOCAL
@SET "R_Path=HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%~1"
@REGT /E /S "SW_%~NX1.reg" "%R_Path%"
@IF NOT EXIST erunt_sw.dat ECHO.REGEDIT4 >erunt_sw.dat
@ECHO.[hkey_users\temphive\%CONTROLSET%\services\%~1]>>erunt_sw.dat

@IF /I "%~N2" EQU "AFD" (
	 IF EXIST Vista.krl (
		SWREG ADD "%R_Path%" /v ImagePath /d "System32\Drivers\%~N2.missing"
		ECHO."Imagepath"="System32\\Drivers\\%~N2.missing">>erunt_sw.dat
	) ELSE (
		SWREG ADD "%R_Path%" /v ImagePath /d "System32\Drivers\%~N2.svs"
		ECHO."Imagepath"="System32\\Drivers\\%~N2.svs">>erunt_sw.dat
		)
) ELSE (
	SWREG ADD "%R_Path%" /v ImagePath /d "System32\Drivers\%~N2.svs"
	ECHO."Imagepath"="System32\\Drivers\\%~N2.svs">>erunt_sw.dat
	)


@(
ECHO.@CD /D "%CD%"
ECHO.@REM	%1	%2
ECHO.@SWREG ADD "%R_Path%" /V ImagePath /T REG_EXPAND_SZ /D "System32\Drivers\%~NX2"
ECHO.@REGT.%cfext% /S "%CD%\SW_%~NX1.reg"
ECHO.@IF EXIST "%~DPN2.svs" MOVE /Y "%~DPN2.svs" %2
)>>Res.bat
COPY /Y Res.bat %SystemDrive%\Qoobox\LastRun\
COPY /Y "SW_%~NX1.reg" %SystemDrive%\Qoobox\LastRun\

@IF EXIST Vista.krl (
	NIRCMD EXEC HIDE PEV MoveEx "%SystemDrive%\Qoobox\Quarantine\%system::=%\Drivers\%~NX2.vir_"
	NIRCMD EXEC HIDE PEV MoveEx %2 "%SystemDrive%\Qoobox\Quarantine\%system::=%\Drivers\%~NX2.vir_"
	)

@SWREG ADD "hklm\software\microsoft\windows\currentversion\runonceex" /v "flags" /t reg_dword /d 8
@SWREG ADD "hklm\software\microsoft\windows\currentversion\runonceex\000" /v "*ComboFix_Pre" /D "%CD%\Res.bat"
@SWREG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" /V "ComboFix_Pre" /D "%CD%\Res.bat"
@SWREG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" /V "%~NX1" /D "%SystemRoot%\Regedit.exe /s \"%CD%\SW_%~NX1.reg\""

@(
ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce]
ECHO."%~NX1"=-
)>>Exe.reg

@ENDLOCAL
@GOTO :EOF


:RHDCntrl
@DEL /A/F RHDCntrl Rboot.dat RkDetectA_HDCntrl.dat >N_\%random% 2>&1
@IF EXIST "\QooBox\32788R22FWJFW\" (
	PEV -c##f#b#d#i#k#g#e#j# "\QooBox\32788R22FWJFW\*" | SED -r "/\t-+$/!d; s///" >Qb327
	FOR /F "TOKENS=*" %%G IN ( Qb327 ) DO @FC "%%G" "%system%\drivers\%%~NXG" ||(
		MOVE /Y "%%G" "\QooBox\Quarantine\%system::=%\Drivers\%%~NXG.vir"
		ECHO."%system%\drivers\%%~NXG">>RHDCntrl00
		)
	DEL Qb327
	RD /S/Q "\QooBox\32788R22FWJFW"
	)>N_\%random% 2>&1

@IF EXIST RHDCntrl00 (
		SED "s/\x22//g" RHDCntrl00 >RHDCntrl0A
		ECHO.::::>>RHDCntrl0A
		IF NOT EXIST DriverList.txt (
			SWSC QUERYEX OPTIONS= config TYPE= DRIVER STATE= ALL > RHDCntrl01
			SED -r "/^(SERVICE_NAME: +| +BINARY_PATH_NAME +)/!d; s///" RHDCntrl01 > RHDCntrl02
			SED -r ":a; $!N;s/\n: +.*System32(\\drivers\\.*)/\t%system:\=\\%\1/I;ta;P;D" RHDCntrl02 | SED "/	/!d" > DriverList.txt
			)
		FINDSTR -LIEG:RHDCntrl0A DriverList.txt >HDCntrl04
		DEL /A/F/Q RHDCntrl0?
		)>N_\%random% 2>&1

@IF EXIST HDCntrl04 GREP -Fs :\ HDCntrl04 >TDL2.dat &&(
	CALL :HDCntrl04 >N_\%random% 2>&1
	CALL Boot-RK.cmd
	)||DEL TDL2.dat HDCntrl04 >N_\%random% 2>&1
@GOTO :EOF


:MAX++
@DEL /A/F handle_max00 Max_present
@FOR /F "TOKENS=*" %%G IN ( max_.dat ) DO @GREP -sq "^regf..." "%%~G" ||ECHO.>Max_present
@IF EXIST KBJunctions0? ECHO.>Max_present
@IF NOT EXIST Max_present GOTO :EOF
@DEL /A/F Max_present

REM START NIRCMD INFOBOX "You are infected with Rootkit.ZeroAccess! It has inserted itself into the~ntcp/ip stack. This is a particularly difficult infection.~n~nIf for any reason that you're unable to connect to the internet after~nrunning ComboFix, reboot once and see if that fixes it.~n~nIf it's not fixed, run ComboFix one more time." "ComboFix - ZeroAccess"
@START NIRCMD INFOBOX "%Line108%" "ComboFix - ZeroAccess"
@TYPE mynul.dat >> RkDetectA_HDCntrl.dat

@MD Test4Max
@(
ECHO.usbehci
ECHO.NDIS
ECHO.AFD
ECHO.NetBT
ECHO.Tcpip
ECHO.Ndisuio
ECHO.Psched
ECHO.NetBIOS
ECHO.intelppm
IF EXIST Vista.krl (
	ECHO.tdx
	) ELSE (
	ECHO.IPSec
	)
ECHO.Serial
ECHO.NDProxy
ECHO.WS2IFSL
ECHO.NetBIOS
ECHO.i8042prt
)>max_00

@(
FOR %%G IN ( 
  "NDIS Wrapper"
  "NDIS"
  "NetBIOSGroup"
  "Extended Base"
  "Base"
  "PNP_TDI"
) DO @SWSC QUERY TYPE= DRIVER GROUP= "%%~G"
)>max_01

@SED -r "/SERVICE_NAME: +/!d; s///" max_01 >max_02
@GREP -Fivxf max_00 max_02 >max_03
@SWSC QUERYEX OPTIONS= config TYPE= driver >max_04
@SED -r "/^SERVICE_NAME: +|^ *(START_TYPE|BINARY_PATH_NAME) +/I!d; s///; /^: [0-4]/s/  .*//;" max_04 > max_05
@SED -n -r "$!N;$!N; s/\n: [1-4]\n: +.*system32\\drivers\\/\t%system:\=\\%\\drivers\\/Ip; s/(.*)\n: [1-4]\n: +$/\1\t%system:\=\\%\\drivers\\\1.sys/Ip" max_05 > max_06
@SED "s/.*\t//" max_06 > max_07
@ECHO.::::>> max_07
@PEV -files:max_07 -s+40000 -output:max_08
@ECHO.:::::>> max_08
@GREP -Fif max_08 max_06 > max_09
@SED "/./!d;s/$/\t/" max_00 > max_0A
@FINDSTR -BILG:max_0A max_09 >max_0B
@SED "/./!d;s/$/\t/" max_03 > max_0C
@FINDSTR -BILG:max_0C max_09 >>max_0B
@TYPE max_0A >> max_0C
@FINDSTR -BVILG:max_0C max_09 >>max_0B
@SED "s/.*\t//" max_0B > max_drivertocheck
@PEV -rtf -tpmz -s+40000 "%system%\drivers\*.sys" >max_0D
@GREP -sq . max_drivertocheck &&(
	GREP -Fixvf max_drivertocheck max_0D >max_0E
	TYPE max_0E >> max_drivertocheck
	)|| TYPE max_0D >> max_drivertocheck
@DEL /A/F/Q max_0?

@IF DEFINED SAFEBOOT_OPTION PEV -rt!g -to -files:max_drivertocheck -output:max_drivertocheck0A &&(
	FOR /F "TOKENS=*" %%H IN ( max_drivertocheck0A ) DO @IF NOT EXIST max_found CALL :Max_C++ "%%~H"
	)
	
@SED 1,100!d max_drivertocheck > max_drivertocheck00
@SED 100,$!d max_drivertocheck > max_drivertocheck01
@FOR /F "TOKENS=*" %%H IN ( max_drivertocheck00 ) DO @IF NOT EXIST max_found CALL :Max_B++ "%%~H"

@IF NOT EXIST max_found (
	NIRCMD WIN CLOSE CLASS "#32770"
	START NIRCMD INFOBOX "%Line107%"
	FOR /F "TOKENS=*" %%H IN ( max_drivertocheck01 ) DO @IF NOT EXIST max_found CALL :Max_B++ "%%~H"
	)


REM @IF EXIST max_found (
REM 	PEV -rtpmz -t!g %CD%\Test4Max\*.sys >MaxADS03
REM 	SED -r "s/\x22//g; s/.*\\/\\/" max_found > MaxADS04
REM 	ECHO.::::>>MaxADS04
REM 	GREP -Fivf MaxADS04 MaxADS03 > MaxADS05
REM 	MOVE /Y MaxADS05 MaxADS03
REM 	)
REM @IF NOT EXIST max_found IF EXIST Vista.krl (
REM 	FOR /F "TOKENS=*" %%G IN ( MaxADS03 ) DO @IF NOT EXIST max_found FC "%%~G" "%system%\drivers\%%~NXG" || CALL :Max_C++ "%System%\Drivers\%%~NXG"
REM ) ELSE FOR /F "TOKENS=*" %%G IN ( MaxADS03 ) DO @IF NOT EXIST max_found IF EXIST "%system%\dllcache\%%~NXG" FC "%%~G" "%system%\dllcache\%%~NXG" || CALL :Max_C++ "%System%\Drivers\%%~NXG"
REM @DEL /A/F/Q MaxADS0?

@RD /S/Q Test4Max
@DEL /Q Max_WinDir_ADS max_found max_0? max_drivertocheck0?
@GOTO :EOF


:Max_B++
@IF EXIST Vista.krl (
	PEV LINK "%~1" "%CD%\Test4Max\%~NX1_linked"
	IF NOT EXIST "%CD%\Test4Max\%~NX1" (
		SWXCACLS "%~1" /OA /Q
		SWXCACLS "%~1" /P /GA:F /GS:F /GP:X /GU:X /Q
		PEV LINK "%~1" "%CD%\Test4Max\%~NX1_linked"
		CATCHME -l N_\%random% -c "%CD%\Test4Max\%~NX1_linked" "%CD%\Test4Max\%~NX1"	
		SWXCACLS "%~1" /g SID#S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464:f /GA:X /GS:X /GP:X /GU:X /Q
		SWXCACLS "%~1" /o SID#S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464 /Q
		IF NOT EXIST "%CD%\Test4Max\%~NX1" GOTO :EOF
		)
) ELSE CATCHME -l N_\%random% -c "%~1" "Test4Max\%~NX1"

@FINDSTR -MR "IoRegisterDriverReinitialization..I.MmIsThisAnNtAsSystem Luke.Skywalker NtQueryDirectoryFile....MmLockPagableImageSection ObFindHandleForObject...WRITE_REGISTER_BUFFER_USHORT" "%CD%\Test4Max\%~NX1" &&(
	PEV -c##h# "%CD%\Test4Max\%~NX1" -output:MaxADS01
	PEV "%~1" -c##m# -output:MaxADS02
	FOR /F "TOKENS=*" %%G IN ( MaxADS01 ) DO @FOR /F "TOKENS=*" %%H IN ( MaxADS02 ) DO @IF /I "%%~G" GTR "%%~H" GOTO Max_C++
	DEL /A/F MaxADS02 MaxADS01
	)

@GREP -Esq "ZeroAccess\.pdb|vc5\\release\\InService\.pdb|\\.A.C.P.I.#.P.N.P.0.3.0.3.#.2.&.d.a.1.a.3.f.f.&.0.\\.|\\.s.y.s.t.e.m.3.2.\\.c.o.n.f.i.g.\\.1.2.3.4.5.6.7.8.|\\.s.y.s.t.e.m.r.o.o.t.\\.\$.N.t.U.n.i.n.s.t.a.l.l.K.B.%%" "Test4Max\%~NX1" && GOTO Max_C++
@FC "Test4Max\%~NX1" "%~1" || GOTO Max_C++

@GOTO :EOF


:Max_C++
@ECHO."%~1">>max_found

:: @PEVB PDUMP > max_05
:: @SED "/./{H;$!d;};x;/\nSYSTEM (The Kernel)/I!d;" max_05 | SED -R "/^Thread: \((\d*)\) .*\(0x[^)]*\)$/!d; s//\1/" > max_06
:: @FOR /F %%G IN ( max_06 ) DO @PEVB TSUSPEND %%G
:: @DEL /A/F max_05 max_06

@IF NOT EXIST DIS_WFP CALL :DIS_WFP
IF NOT EXIST "\QooBox\Quarantine\%system::=%\Drivers\" MD "\QooBox\Quarantine\%system::=%\Drivers"
:: @MOVE /Y "Test4Max\%~NX1" "\QooBox\Quarantine\%system::=%\Drivers\%~NX1.vir"

@PEV -rtg "%~1" &&(
	CALL :FREE "%~1"
	COPY /Y "%~1" "MT_%~NX1.tmp"
	PEV -rtg "MT_%~NX1.tmp" || DEL /A/F "MT_%~NX1.tmp"
	)

@IF NOT EXIST "MT_%~NX1.tmp" (
	CALL ND_.bat "%~1" "FINDNOW_X"
	IF EXIST ND_05 (
		SED 1!d ND_05 >ND_06
		FOR /F "TOKENS=*" %%I IN ( ND_06 ) DO @(
			CALL :FREE "%%~I"
			COPY /Y "%%~I" "MT_%~NX1.tmp"
			)
		DEL /A/F/Q ND0?
		))

@IF NOT EXIST "MT_%~NX1.tmp" GOTO :EOF

@TYPE max_.dat | MTEE /+ d-delA.dat >> RkDetectA_HDCntrl.dat
@IF EXIST Vista.krl FOR /F "TOKENS=*" %%I IN ( max_.dat ) DO @ %KMD% /D /C MoveIt.bat "%%~I"

@SWSC QUERYEX OPTIONS= config TYPE= DRIVER STATE= ALL > temp00
@SED -r "/^(SERVICE_NAME: +| +BINARY_PATH_NAME +)/!d; s///" temp00 > temp01
@SED -r ":a; $!N;s/\n: +.*System32(\\drivers\\.*)/\t%system:\=\\%\1/I;ta;P;D" temp01 | SED "/	/!d" > DriverList.txt

@GREP -Fi "%~1" DriverList.txt > MaxService.dat
@COPY /Y "MT_%~NX1.tmp" "%~DPN1.svs"
@PEV -rtg "%~DPN1.svs" && FOR /F "TOKENS=1 DELIMS=	" %%I IN ( MaxService.dat ) DO @CALL :SwPath "%%~I" "%~1"
@DEL /A/F MaxService.dat temp00 temp01

@MOVE /Y "%~1" "\QooBox\Quarantine\%system::=%\Drivers\%~NX1.vir"
@COPY /Y "MT_%~NX1.tmp" "%~1"
@PEV MOVEEX "MT_%~NX1.tmp" "%~1"

@ECHO."%CD%\MT_%~NX1.tmp"	"%~1"	"The cat found it :)">Max.mov
@CALL :HDCntrlB "%~1" "The cat found it :)"


@IF EXIST "%systemroot%\assembly\GAC_MSIL\desktop.ini\" (
	RD /S/Q  "\\?\%systemroot%\assembly\GAC_MSIL\desktop.ini"
) ELSE IF EXIST "%systemroot%\assembly\GAC_MSIL\desktop.ini" (
	%KMD% /D /C MoveIt.bat "%systemroot%\assembly\GAC_MSIL\desktop.ini"
	)

@PEV -tpmz -rtf -t!o -t!g -s4096-6140 "%system%\*.dll" | FINDSTR -MLF:/ "e:\vc5\release" >MaxTemp00 &&(
	TYPE MaxTemp00 >> d-delA.dat
	FOR /F "TOKENS=*" %%G IN ( MaxTemp00 ) DO @%KMD% /D /C MoveIt.bat "%%~G"
	DEL /A/F MaxTemp00
	)

@SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Nls\CodePage" > Nls00
@SED -r "/.*\t(c_.[0-9]*\.nls)$/I!d; s//%system:\=\\%\\\1/" Nls00 > Nls01
@ECHO.::::>> Nls01
@PEV -fs32 -rtf -t!o "%system%\*" -preg"\\c_\d{5}\.nls$" -output:Nls02
@GREP -Fivf Nls01 Nls02 > Nls03
@PEV -rtf -t!o "%system%\*" -preg"\\c_00\d{3}\.nl[s_]$" >> Nls03
@FOR /F "TOKENS=*" %%I IN ( Nls03 ) DO @(
	%KMD% /D /C MoveIt.bat "%%~I"
	ECHO."%%~I">>d-delA.dat
	)

@IF EXIST W6432.dat (
CALL FIXLSP64.cmd
) ELSE CALL FIXLSP.bat
@DEL /A/F/Q LSPDone Nls0?
@SWREG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V AUTORESTARTSHELL /T REG_DWORD /D 1
@GOTO :EOF



:Whistler
SETLOCAL
SET "TEMP=%CD%"
@RMBR -c 0 1 gMBR_sector0.dat
ENDLOCAL
@IF NOT EXIST gMBR_sector0.dat GOTO :EOF

@COPY /Y gmbr_sector0.dat %SystemDrive%\Qoobox\Quarantine\MBR_HardDisk0.mbr
@Grep -Fxsqf mbr.chk gmbr_sector0.dat &&(
	DEL /A/F gmbr_sector0.dat
	GOTO :EOF
	)

REM @GSAR -hb -s:x33:xC0:x8E:xD0:xBC:x00:x7C:x8E:xC0:x8E:xD8:xBE:x00:x7C:xBF:x00:x06:xB9:x00:x02:xFC:xF3:xA4:x50:x68:x1C:x06:xCB:xFB:x60:xB9:x37:x01:xBD:x2A:x06:xD2:x4E:x00:x45:xE2:xFA:x44:x85:x56:x70 gmbr_sector0.dat | GREP -Fisqx 0x0 &&(
@GSAR -hb -s:x33:xC0:x8E:xD0:xBC:x00:x7C:x8E:xC0:x8E:xD8:xBE:x00:x7C:xBF:x00:x06:xB9:x00:x02:xFC:xF3:xA4:x50:x68:x1C:x06:xCB:xFB:x60:xB9 gmbr_sector0.dat | GREP -Fisqx 0x0 &&(
	REM NIRCMD INFOBOX "The Master Boot Record is infected !!~n~nMake sure your antivirus programs are disabled before clicking OK" "Warning !!"
	NIRCMD INFOBOX "%Line88%"
	SWREG ADD "hklm\software\microsoft\windows\currentversion\runonce" /v "combofix" /d "\"%cd%\%KMD%\" /c \"%cd%\C.bat\""
	ECHO.>TDL4mbr.dat
	RMBR -w 9 gmbr_sector0.dat
	MOVE /Y gmbr_sector0.dat %SystemDrive%\Qoobox\Quarantine\MBR_HardDisk0.mbr
	GOTO :EOF
	)

@GSAR -hb -s:x31:xC0:x8E:xD8:x8E:xC0:x8E:xD0:xBC:x00:x7C:xBE:x00:x7C:xBF:x00:x06:xB9 gmbr_sector0.dat | GREP -Fisqx 0x0 ||(
	GSAR -hb -s:xFA:x33:xC0:x8E:xD0:xBC:x00:x7C:x50:x07:x50:x1F:xFB:xEB:x02:x90:x56:xBF:x00:x06:x8B:xF4:xB9:x00:x02:xFC:xF3:xA4:xEA:x21:x06:x00:x00:xB0:x0A:xB4 gmbr_sector0.dat | GREP -Fisqx 0x0 ||(
		GSAR -hb -s:x72:x03:x73:x01:x0A:xFA:x2E:x8C:x06:x00:x06:x2E:x89:x26:x02:x06:x2E:x8C:x16:x04:x06:x2E:x66:xC7:x06:xFC:x7B:x00:x7C:x00:x00:x2E:x0F:xB2:x26:xFC gmbr_sector0.dat | GREP -Fisqx 0x0 ||(
			GSAR -hb -s:x33:xC0:x8E:xD8:x8E:xC0:x8E:xD0:xBC:x00:x7C:xBE:x1A:x7C:xBF:x00:x06:xB9:xE6:x01:x50:x57:xFC:xF3:xA4:xCB:xBE:xA4:x07:xB1:x04 gmbr_sector0.dat | GREP -Fisqx 0x0 ||(
				GSAR -hb -s:xFA:x33:xDB:x8E:xD3:x36:x89:x26:xFE:x7B:xBC:xFE:x7B:x1E:x66:x60:xFC:x8E:xDB:xBE:x13:x04:x83:x2C:x04:xAD:xC1:xE0:x06:x8E:xC0:xBE:x00:x7C:x33:xFF gmbr_sector0.dat | GREP -Fisqx 0x0 ||(
					REM GSAR -hb -s:xFA:x31:xC0:x8E:xD0:xBC:xF0:xFF:xFB:x50:x07:x50:x1F:xFC:xBE:x00:x7C:xBF:x00:x06:xB9:x00:x02:xF3:xA4:xB8:x60:x00:x50:xB8:x24:x00:x50:xCB:x90:x90:x90:x90:x90:x90:x90:x31:xC0:xB2:x80:xCD:x13:xFA gmbr_sector0.dat | GREP -Fisx 0x0 ||(
					DEL /A/F gmbr_sector0.dat
					GOTO :EOF
					)))))


@REM NIRCMD INFOBOX "The Master Boot Record is infected !!~n~nMake sure your antivirus programs are disabled before clicking OK" "Warning !!"
@NIRCMD INFOBOX "%Line88%"

@IF EXIST "%systemroot%\browseui.dll" (
	%KMD% /D /C MoveIt.bat "%systemroot%\browseui.dll"
	ECHO."%systemroot%\browseui.dll">>d-del_A.dat
	)
	
@SET BootCode=
@IF EXIST W7.mac SET "BootCode=w7Mcode.dat"
@IF EXIST W8.mac SET "BootCode=w7Mcode.dat"
@IF EXIST Vista.mac IF EXIST %systemdrive%\Boot\en-US\bootmgr.exe.mui CALL :Vor7
@IF NOT DEFINED BootCode IF EXIST %systemdrive%\Boot\en-US\bootmgr.exe.mui CALL :Vor7
@IF NOT DEFINED BootCode IF EXIST XP.mac SET "BootCode=XPmCode.dat"
@IF NOT DEFINED BootCode IF EXIST W2k.mac SET "BootCode=XPmCode.dat"
@IF NOT DEFINED BootCode GOTO :EOF

@IF EXIST BootDrive.dat DEL /A/F BootDrive.dat
@CSCRIPT //NOLOGO //E:VBSCRIPT //T:15 BootDrv.vbs
@IF EXIST BootDrive.dat SED -r "/^.*drive(.*	)/I!d; s//\1/; /	%systemdrive%/Id;" BootDrive.dat > BootDriveA.dat
@IF EXIST BootDriveA.dat FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( BootDriveA.dat ) DO @(
	RMBR -d%%G -c 0 1 sector%%G-0.dat
	IF EXIST sector%%G-0.dat CALL :dDrive %%G %%H
	)
@DEL /A/F/Q BootDrive?.dat

@IF EXIST MtdDev.dat DEL /A/F MtdDev.dat
@SWREG QUERY HKLM\SYSTEM\MountedDevices >MtdDev00
@SED -r "/^ +\\DosDevices\\([C-Z]:)\t.*\t(..)(..)(..)(..)(0{4}100{10}|007E0{12})$/I!d; s//:x\2:x\3:x\4:x\5\t\1/; /	%systemdrive%/Id;" MtdDev00 > MtdDev.dat
@DEL /A/F/Q MtdDev0?

@FOR /L %%G IN (0,1,9) DO @IF NOT EXIST dd_stop IF NOT EXIST Head%%G.dat (
	RMBR -d%%G -c 0 1 sector%%G-0.dat
	IF NOT EXIST sector%%G-0.dat (
		ECHO.%%G>dd_stop
		) ELSE CALL :dDrive %%G
		)

@DEL /A/F/Q gMBR_sector0.dat dd_stop MtdDev.dat Head?.dat newmbr?.dat ptt?.dat sector?-8.dat gSinowal.dat gTDL4.dat
@SET BootCode=
@SET Bootkit_=
@IF EXIST Whistler.dat (
	ECHO.>>Whistler.dat
	TYPE Whistler.dat >> %systemdrive%\Qoobox\LastRun\Whistler.old
	)
@GOTO :EOF


:dDrive
@IF EXIST gSinowal.dat DEL /A/F gSinowal.dat
@IF EXIST gTDL4.dat DEL /A/F gTDL4.dat
@IF "%~1"=="" GOTO :EOF
@IF EXIST BootDriveA.dat IF "%~2"=="" GOTO :EOF

@GSAR -hb -s:x31:xC0:x8E:xD8:x8E:xC0:x8E:xD0:xBC:x00:x7C:xBE:x00:x7C:xBF:x00:x06:xB9 sector%~1-0.dat | GREP -Fisqx 0x0 ||(
	REM GSAR -hb -s:x33:xC0:x8E:xD0:xBC:x00:x7C:x8E:xC0:x8E:xD8:xBE:x00:x7C:xBF:x00:x06:xB9:x00:x02:xFC:xF3:xA4:x50:x68:x1C:x06:xCB:xFB:x60:xB9:x37:x01:xBD:x2A:x06:xD2:x4E:x00:x45:xE2:xFA:x44:x85:x56:x70 sector%~1-0.dat | GREP -Fisx 0x0 >gTDL4.dat ||(
	GSAR -hb -s:x33:xC0:x8E:xD0:xBC:x00:x7C:x8E:xC0:x8E:xD8:xBE:x00:x7C:xBF:x00:x06:xB9:x00:x02:xFC:xF3:xA4:x50:x68:x1C:x06:xCB:xFB:x60:xB9 sector%~1-0.dat | GREP -Fisx 0x0 >gTDL4.dat ||(
		DEL /A/F gTDL4.dat
		GSAR -hb -s:x33:xC0:x8E:xD8:x8E:xC0:x8E:xD0:xBC:x00:x7C:xBE:x1A:x7C:xBF:x00:x06:xB9:xE6:x01:x50:x57:xFC:xF3:xA4:xCB:xBE:xA4:x07:xB1:x04 sector%~1-0.dat | GREP -Fisx 0x0 >gSinowal.dat ||(
			DEL /A/F gSinowal.dat
			GSAR -hb -s:xFA:x33:xC0:x8E:xD0:xBC:x00:x7C:x50:x07:x50:x1F:xFB:xEB:x02:x90:x56:xBF:x00:x06:x8B:xF4:xB9:x00:x02:xFC:xF3:xA4:xEA:x21:x06:x00:x00:xB0:x0A:xB4 sector%~1-0.dat | GREP -Fisx 0x0 >gUnknownBootkit.dat ||(
				GSAR -hb -s:x72:x03:x73:x01:x0A:xFA:x2E:x8C:x06:x00:x06:x2E:x89:x26:x02:x06:x2E:x8C:x16:x04:x06:x2E:x66:xC7:x06:xFC:x7B:x00:x7C:x00:x00:x2E:x0F:xB2:x26:xFC sector%~1-0.dat | GREP -Fisx 0x0 >gUnknownBootkit.dat ||(
					GSAR -hb -s:xFA:x33:xDB:x8E:xD3:x36:x89:x26:xFE:x7B:xBC:xFE:x7B:x1E:x66:x60:xFC:x8E:xDB:xBE:x13:x04:x83:x2C:x04:xAD:xC1:xE0:x06:x8E:xC0:xBE:x00:x7C:x33:xFF sector%~1-0.dat | GREP -Fisx 0x0 >gUnknownBootkit.dat ||(
						REM GSAR -hb -s:xFA:x31:xC0:x8E:xD0:xBC:xF0:xFF:xFB:x50:x07:x50:x1F:xFC:xBE:x00:x7C:xBF:x00:x06:xB9:x00:x02:xF3:xA4:xB8:x60:x00:x50:xB8:x24:x00:x50:xCB:x90:x90:x90:x90:x90:x90:x90:x31:xC0:xB2:x80:xCD:x13:xFA sector%~1-0.dat | GREP -Fisx 0x0 >gUnknownBootkit.dat ||(
							DEL /A/F gUnknownBootkit.dat
							DEL /A/F sector%~1-0.dat
							GOTO :EOF
							))))))


@IF EXIST gSinowal.dat (
	SET "BootKit_=Sinowal"
) ELSE IF EXIST gTDL4.dat (
	SET "BootKit_=TDL4"
) ELSE IF EXIST gUnknownBootkit.dat (
	SET "BootKit_=Agent"
) ELSE SET "BootKit_=Whistler"


@RMBR -d%~1 -w 9 sector%~1-0.dat
@dd if=sector%~1-0.dat of=ptt%~1.dat bs=440 skip=1 count=1
@IF EXIST BootDriveA.dat (
	IF EXIST newmbr%~1.dat DEL /A/F newmbr%~1.dat
	IF EXIST %~2\Boot\en-US\bootmgr.exe.mui (
		CALL :Vor7B %~2 newmbr%~1.dat
		) ELSE TYPE xpmcode.dat > newmbr%~1.dat
			) ELSE IF EXIST MtdDev.dat IF NOT EXIST newmbr%~1.dat FOR /F "TOKENS=1,2 DELIMS=	" %%J IN ( MtdDev.dat ) DO @GSAR -hb -s%%K ptt%~1.dat | GREP -xisq "0x0" && IF EXIST %%J\Boot\en-US\bootmgr.exe.mui (
				CALL :Vor7B %%J newmbr%~1.dat
				) ELSE TYPE xpmcode.dat > newmbr%~1.dat
@IF NOT EXIST newmbr%~1.dat FC sector%~1-0.dat gMBR_sector0.dat &&(
	TYPE %BootCode% > newmbr%~1.dat
	)||CALL :MbrType %~1
@TYPE ptt%~1.dat >> newmbr%~1.dat
@RMBR -d%~1 -w 0 newmbr%~1.dat &ECHO.\\.\PhysicalDrive%~1 - Bootkit %Bootkit_% was found and disinfected>>Whistler.dat
@IF NOT EXIST %SystemDrive%\Qoobox\Quarantine\MBR_HardDisk%~1.mbr COPY /Y sector%~1-0.dat %SystemDrive%\Qoobox\Quarantine\MBR_HardDisk%~1.mbr
@SET Bootkit_=
@GOTO :EOF


:MbrType
@GSAR -hb -s:x80:x20:x21:x00 ptt%~1.dat | GREP -Eix "0x(.|)6" &&(	TYPE w7Mcode.dat > newmbr%~1.dat )||TYPE xpMcode.dat > newmbr%~1.dat
@GOTO :EOF

:Vor7
@PEV -rtf -c##g# %systemdrive%\Boot\en-US\bootmgr.exe.mui | GREP -sq "^6.1" &&(
	SET "BootCode=w7Mcode.dat"
	)||SET "BootCode=vistaMcode.dat"
@GOTO :EOF

:Vor7B
@PEV -rtf -c##g# %~1\Boot\en-US\bootmgr.exe.mui | GREP -sq "^6.1" &&( TYPE w7Mcode.dat > %2 )|| TYPE vistaMcode.dat > %2
@GOTO :EOF

:VBR
@CATCHME -l N_\%random% -c %systemdrive%\$Boot C@VBR.dat
@GREP -Esq "fiFYhi98.p;..QS.\/......A.._0.Yc\(.w-Z`eaebe|\(S\)...H.L2..\+.\(;.i..,.!.\+..Rzuh.ZZ.Q1K..Y\\Q._.uP.R" C@VBR.dat || GOTO :EOF
@IF EXIST Vista.krl (
	RMBR -c 2048 16 M@VBR.dat
) ELSE RMBR -c 63 16 M@VBR.dat
@FC C@VBR.dat M@VBR.dat || GOTO :EOF
@DEL /A/F M@VBR.dat
@ECHO>NUL ||SWREG DELETE "HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\NULL"
@ECHO.>WhistlerVBR.dat
@MOVE /Y C@VBR.dat %SystemDrive%\Qoobox\Quarantine\VBR.dat
@GOTO :EOF


:DIS_WFP
@IF EXIST Vista.krl GOTO :EOF
@ECHO.>DIS_WFP
@PEV MOVEEX DIS_WFP
@HANDLE %system% | SED -R "/winlogon.exe\s*pid: (\d*)\s*([0-9a-f]*): %system:\=\\%(\\drivers|)$/I!d; s//@HANDLE -p \1 -c \2 -y/" >UNHANDLE.BAT
@CALL UNHANDLE.BAT
@DEL  UNHANDLE.BAT
@GOTO :EOF


:FREE
@SWXCACLS "%~1" /OA
@SWXCACLS "%~1" /P /GE:F /I ENABLE /Q
@ATTRIB -H -R -S -A "%~1"
@GOTO :EOF


:LockDown
@FOR /F "TOKENS=*" %%G IN ( %~1 ) DO @IF NOT "%%~G"=="::::" CATCHME -l N_\%random% -i "%%~G"
@PEV WAIT 3200
@CATCHME -l N_\%random% -i
@GOTO :EOF


:REMDIR
@IF "%~1"=="" GOTO :EOF
@SET P@TH="%~1"
@SET P@TH=%P@TH:\"="%
@SET "NOS=%~2"
@IF NOT DEFINED NOS SET NOS=1
@PEV -fs32 -tx50000 -tf "%P@TH:"=%\*" >FolderContentCount.0
@GREP -Fc :\ FolderContentCount.0 | GREP -sqx "[0-%NOS%]" &&ECHO.%P@TH%>>CFolders.dat
@DEL /A/F FolderContentCount.0
@GOTO :EOF


