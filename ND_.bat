
@CD /D "%~DP0"
@IF EXIST chcp.bat CALL chcp.bat
@PROMPT $
CLS

IF ["%~1"]==[""] GOTO :EOF
IF EXIST W6432.dat (
	PEV -rtb "%~1" &&(
		CALL ND_64.bat %*
		GOTO :EOF
		)
	IF ["%~2"]==["MISSING"] ECHO."%~1"|GREP -Fi "%SYSDIR%" &&(
		CALL ND_64.bat %*
		GOTO :EOF
		))

IF ["%~2"]==["SFC_MISSING"] GOTO SFC_MISSING
IF ["%~2"]==["MISSING"] GOTO MISSING
IF ["%~2"]==["HDCntrl"] GOTO ND_SubD
IF ["%~3"]==["NDMOV"] GOTO :NDMOV
IF ["%~2"]==["NoSig"] IF ["%~3"]==[""]  GOTO :EOF
IF EXIST NoSig.dat DEL /A/F NoSig.dat
IF ["%~2"]==["NoSig"] ECHO.>NoSig.dat

IF EXIST "%~NX1.ND_" GOTO :EOF
ECHO.%TIME% >"%~NX1.ND_"
IF /I ["%~1"] EQU ["%system%\drivers\ndis.sys"] GOTO ND_SubD
IF /I ["%~1"] EQU ["%system%\ntoskrnl.exe"] IF 1%NUMBER_OF_PROCESSORS% GTR 11 GOTO NTKRNLMP
IF /I ["%~1"] EQU ["%system%\ntkrnlpa.exe"] IF 1%NUMBER_OF_PROCESSORS% GTR 11 GOTO NTKRPAMP


IF ["%~2"]==["FINDNOW"] (
	IF EXIST XP.mac CALL :SRC "%~1"
	IF EXIST Vista.krl CALL :VSS "%~1"
	GOTO :EOF
	)
	
IF ["%~2"]==["FINDNOW_X"] (
	CALL :ND_Search "%~1"
	GREP -Fsq :\ ND_05 ||CALL ECHO.%Line37% . . . %Failed to find a valid replacement%.>>ndis_log.dat
	GOTO :EOF
	)

IF /I ["%~1"] EQU ["%system%\winlogon.exe"] (
	PAUSEP 2>&1| SED -r "/^PID\t(.*)\twinlogon.exe$/!d; s//\1/" >PIDit.dat
	FOR /F "TOKENS=*" %%G IN ( PIDit.dat ) DO @PEV EXEC /S "%CD%\PAUSEP.%cfext%" %%G
	DEL PIDit.dat
	)

IF /I ["%~1"] EQU ["%system%\wininit.exe"] (
	PAUSEP 2>&1| SED -r "/^PID\t(.*)\twininit.exe$/!d; s//\1/" >PIDit.dat
	FOR /F "TOKENS=*" %%G IN ( PIDit.dat ) DO @PEV EXEC /S "%CD%\PAUSEP.%cfext%" %%G
	DEL PIDit.dat
	)

REM check dllcache first
IF NOT EXIST Vista.krl IF EXIST "%system%\dllcache\%~nx1" (
	FC "%~1" "%system%\dllcache\%~nx1" >N_\%random% && DEL /A/F "%system%\dllcache\%~nx1"
	PEV -tx30000 -rtf -t!b"%system%\dllcache\%~nx1" -tg -output:temp00 
	GREP -Fsq :\ temp00 &&(
		IF NOT EXIST DIS_WFP CALL :DIS_WFP
		ECHO.>CFReboot.dat
		%KMD% /D /C MoveIt.bat "%~1" ND_
		IF EXIST "%~1" (
			COPY /Y/B/V "%~1" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
			IF NOT EXIST "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir" CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%~1" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
			IF /I ["%~x1"] EQU [".dll"] GREP -sq "\\._._.m.a.x.+.+" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir" &&(
				REGSVR32.exe /s "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
				CALL :RemMtPts
				)
			CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -E "%~1"
			IF EXIST "%~1" (
				CALL :NDMOV "%~1" "%system%\dllcache\%~nx1"
				GOTO :EOF
				))
		ATTRIB -H -R -S "%system%\dllcache\%~nx1"
		COPY /Y "%system%\dllcache\%~nx1" "%~1"
		IF NOT EXIST "%~1" CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%system%\dllcache\%~nx1" "%~1"
		IF NOT EXIST "%~1" COPY /Y "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir" "%~1"
		Call :ND_SubC "%~1" "%system%\dllcache\%~nx1" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
		DEL /A/F temp0?
		GOTO :EOF
		))


REM search machine for other copies; use ONLY latest copy found

CALL :ND_Search %*

:ND_Post-Search
IF EXIST ND_05 (
	SED 1!d ND_05 >ND_06
	FOR /F "TOKENS=*" %%G IN ( ND_06 ) DO @(
		ECHO.>CFReboot.dat
		IF NOT EXIST DIS_WFP CALL :DIS_WFP
		%KMD% /D /C MoveIt.bat "%~1" ND_
		IF EXIST "%~1" (
			COPY /Y/B/V "%~1" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
			IF NOT EXIST "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir" CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%~1" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
			IF /I ["%~x1"] EQU [".dll"] GREP -sq "\\._._.m.a.x.+.+" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir" &&(
				REGSVR32.exe /s "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
				CALL :RemMtPts
				)
			CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -E "%~1"
			IF EXIST "%~1" (
				CALL :NDMOV "%~1" "%%~G"
				GOTO :EOF
				))
		ATTRIB -H -R -S "%%~G"
		COPY /Y "%%~G" "%~1"
		IF NOT EXIST "%~1" CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%%~G" "%~1"
		IF NOT EXIST "%~1" COPY /Y "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir" "%~1"
		PEV WAIT 500
		Call :ND_SubC "%~1" "%%~G" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
		)
	) ELSE CALL :ND_SubC "%~1" "%~1"


@SWXCACLS "%SystemDrive%\system volume information" /P /GS:F /I REMOVE /Q
DEL /A/Q temp0? ND_0? SRC0?
GOTO :EOF



:ND_SubC
@(
ECHO.CD "%~DP1"
ECHO.DEL "%~1.undo.vir"
ECHO.REN "%~1" "%~NX1.undo.vir"
ECHO.COPY "%~3" "%~1"
)>>"%SystemRoot%\erdnt\CFUNDO.dat"

IF /I ["%~2"] NEQ ["%~1"] (
	IF EXIST NoSig.dat (
		ECHO."%~1">ND_07
		) ELSE (
		COPY /Y/B "%~1" "%cd%\test__test"
		IF NOT EXIST "%cd%\test__test" CATCHME -l "%cd%\N_\%random%" -c "%~1" "%cd%\test__test"
		PEV -tx30000 -rtf -t!b "test__test" -tg -output:ND_07
		)
	GREP -sq . ND_07 &&(
		IF /I ["%~1"] EQU ["%system%\Drivers\Volsnap.sys"] ECHO..>VolSnp.dat
		ECHO."%~1"	"%~2">>ndis_recheck.task
		@REM ECHO.Infected copy of %%~1 was found and disinfected>>ndis_log.dat
		@REM ECHO.Restored copy from - %%~2 >>ndis_log.dat
		CALL ECHO.%Line36% >>ndis_log.dat
		CALL ECHO.%Line36A% >>ndis_log.dat
		IF /I "%~N1" EQU "winlogon" echo.sf %system%\ws2_32.dll ^>^>ndis_log.dat>>Combobatch.bat
		ECHO.>>ndis_log.dat
		ECHO.>>CFReboot.dat
		ECHO.   %Successfully restored% :^)>>"%~NX1.ND_"
		)||(
		IF /I ["%~1"] EQU ["%system%\Drivers\Volsnap.sys"] ECHO..>VolSnp.dat
		CALL :NDMOV "%~1" "%~2"
		REM ECHO.%%~1 . . . is infected!!>>ndis_log.dat
		CALL ECHO.%Line37% . . .%Failed to restore.% >>ndis_log.dat
		ECHO.>>ndis_log.dat
		)
) ELSE (
	IF /I ["%~1"] EQU ["%system%\LPK.dll"] %KMD% /D /C MoveIt.bat "%system%\lpk.dll"
	REM ECHO.%%~1 . . . is infected!!>>ndis_log.dat
	CALL ECHO.%Line37%>>ndis_log.dat
	IF EXIST NoSig.dat CALL ECHO.%Line37A%>>ndis_log.dat
	ECHO.>>ndis_log.dat
	)


@DEL /A/F ND_07 "%cd%\test__test"
@IF NOT EXIST %SystemDrive%\qoobox\lastrun md %SystemDrive%\qoobox\lastrun
@IF EXIST ndis_log.dat IF EXIST SvcTarget.dat TYPE ndis_log.dat >> %SystemDrive%\qoobox\lastrun\ndis_log.old
@GOTO :EOF


:SRC
@SWXCACLS "\System Volume Information\" /E /GA:R /Q
@GREP -Fsq :\ Rpts || PEV -samdate -td -t!b "%SystemDrive%\System Volume Information\RP*" -output:Rpts
@IF NOT EXIST SrCache.dat IF EXIST Rpts FOR /F "TOKENS=*" %%G IN ( Rpts) DO @CALL :SRC_B "%%G"
@IF NOT EXIST SrCache.dat GOTO :EOF
@GREP -Fi "%~1	" SrCache.dat > SR03 || GREP -Fi "\%~NX1	" SrCache.dat > SR03
@SED -r "s/.*	//" SR03 >SR04
@ECHO.::::>> SR04
@PEV -samdate -tx50000 -tf -t!b -files:SR04 -output:SR05
@IF EXIST NoSig.dat FOR /F "TOKENS=*" %%G IN ( SR05 ) DO @FINDSTR -MI "%~3" "%%~G" ||(
	ECHO."%%~G">ND_05
	GOTO SRC_A
	)

@ECHO.::::>> SR05
@IF NOT EXIST FdsvOk PEV -tx15000 -tg -t!b -rtf "%system%\wintrust.dll" -output:FdsvOK || DEL /A/F FdsvOk
@IF EXIST FdsvOK (
	PEV -tx60000 -limit:1 -files:SR05 -tf -t!b -tg -output:ND_05 || DEL ND_05
) ELSE (
	SED ":a; $!N; s/\n/\x22 \x22/; ta" SR05 >SR05a
	SED "s/.*/\x22&\x22/" SR05a >SR05b
	FOR /F "TOKENS=*" %%G IN ( SR05b ) DO @GREP -Elsq "V.S._.V.E.R.S.I.O.N._.I.N.F.O|VS_VERSION_INFO" %%G >ND_05
	DEL /A/F SR05a SR05b
	GREP -Fsq : ND_05 || DEL /A/F ND_05
	)

:SRC_A
@DEL /A/F/Q SR0?
@GOTO :EOF


:SRC_B
@PUSHD %1
@TYPE change.log* | GSAR -F -s:x1A -r >"%~DP0SR00"
@START NircmdB.exe cmdwait 10000 KillProcess SED.%cfExt%
@SED -r "s/\x00//g; s/\x22\x05/\x00/g; s/\\[[:print:]]*\x00A/\n%SystemDrive%&/Ig" "%~DP0SR00" | SED -r "/^.:\\.*\\[^\\]*\x00/I!d; s/\x00(A.{11}).*/	%cd:\=\\%\\\1/" >>"%~DP0SrCache.dat"
@PEV -k NircmdB.exe
@DEL /A/F "%~DP0SR00"
@POPD
@GOTO :EOF


:ND_Search
@REM search machine for other copies; use ONLY latest copy found
PEV -tx60000 -limit:1 -samdate -tf -t!b -tg "%SystemRoot%\%~nx1" NOT "%~1" -output:ND_05
IF /I ["%~1"] EQU ["%System%\Services.exe"] (
	PEV -tx60000 -tf -tb -tg "%SystemRoot%\%~nx1" NOT { -preg"%SysDir:\=\\%|\\winsxs\\amd64_" or "%%~1" } >> ND_05
	PEV -tx60000 -tf -tb -tg "%SystemRoot%\%~nx1" NOT { -preg"%SysDir:\=\\%|\\winsxs\\amd64_" or "%%~1" } >> ND_05
	)
	
GREP -Fsq :\ ND_05 || IF EXIST "%SystemDrive%\I386\"  PEV -tx30000 -limit:1 -samdate -tf -t!b -tg "%SystemDrive%\I386\%~nx1" -output:ND_05

GREP -Fsq :\ ND_05 ||(
	DEL /A/F ND_05
	IF EXIST XP.mac CALL :SRC %*
	IF EXIST Vista.krl CALL :VSS %*
	)
	
IF EXIST NoSig.dat GREP -Fsq :\ ND_05 || IF EXIST "%~DP1 " IF NOT EXIST "%~DP1 \" (
	CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%~DP1 " test.abc
	IF EXIST test.abc FINDSTR -MI "%~3" test.abc ||(
		ECHO."%~N1"|SED -r "s/\x22//g; s/./&./g" > "%~N1_String.dat"
		FINDSTR -MIRG:"%~N1_String.dat" test.abc &&ECHO."%~DP1 ">ND_05
		DEL /A/F "%~N1_String.dat"
		)
	DEL /A/F test.abc 
	)

GREP -Fsq :\ ND_05 ||(
	IF /I ["%~1"] EQU ["%system%\userinit.exe"] (
		CALL ND_SearchB "1:Microsoft Corporation	7:USERINIT.EXE"
		IF NOT EXIST ND_05 (
			@ECHO.[hkey_local_machine\software\microsoft\windows nt\currentversion\winlogon]>>CregC.dat
			@ECHO."Userinit"="%systemroot:\=\\%\\explorer.exe,">>CregC.dat
			))
	@IF /I ["%~1"] EQU ["%system%\LPK.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:LanguagePack"
	@IF /I ["%~1"] EQU ["%system%\comres.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:------"
	@IF /I ["%~1"] EQU ["%system%\kernel32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:kernel32"
	@IF /I ["%~1"] EQU ["%system%\sfc.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:sfc.dll"
	@IF /I ["%~1"] EQU ["%system%\ntmssvc.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:ntmssvc.dll"
	@IF /I ["%~1"] EQU ["%system%\svchost.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:svchost.exe"
	@IF /I ["%~1"] EQU ["%system%\user32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:user32"
	@IF /I ["%~1"] EQU ["%system%\ws2_32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:ws2_32.dll"
	@IF /I ["%~1"] EQU ["%system%\ws2help.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:ws2help.dll"
	@IF /I ["%~1"] EQU ["%system%\wininet.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:wininet.dll"
	@IF /I ["%~1"] EQU ["%system%\winlogon.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:WINLOGON.EXE"
	@IF /I ["%~1"] EQU ["%system%\comctl32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:COMCTL32.DLL"
	@IF /I ["%~1"] EQU ["%system%\rpcss.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:rpcss.dll"
	@IF /I ["%~1"] EQU ["%system%\termsrv.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:termsrv.exe"
	@IF /I ["%~1"] EQU ["%system%\imm32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:imm32"
	@IF /I ["%~1"] EQU ["%system%\netlogon.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:NetLogon.DLL"
	@IF /I ["%~1"] EQU ["%system%\services.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:services.exe"
	@IF /I ["%~1"] EQU ["%system%\lsass.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:lsass.exe"
	@IF /I ["%~1"] EQU ["%system%\ctfmon.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:CTFMON.EXE"
	@IF /I ["%~1"] EQU ["%system%\spoolsv.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:spoolsv.exe"
	@IF /I ["%~1"] EQU ["%system%\userinit.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:USERINIT.EXE"
	@IF /I ["%~1"] EQU ["%system%\appmgmts.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:appmgmts.dll"
	@IF /I ["%~1"] EQU ["%system%\srsvc.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:SERVICE.DLL"
	@IF /I ["%~1"] EQU ["%system%\scecli.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:scecli"
	@IF /I ["%~1"] EQU ["%system%\dssenh.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:dssenh.dll"
	@IF /I ["%~1"] EQU ["%system%\ipsecsvc.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:ipsecsvc.dll"
	@IF /I ["%~1"] EQU ["%system%\msprivs.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:mspriv.dll"
	@IF /I ["%~1"] EQU ["%system%\oakley.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:oakley.dll"
	@IF /I ["%~1"] EQU ["%system%\psbase.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:psbase.dll"
	@IF /I ["%~1"] EQU ["%system%\pstorsvc.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:Protected storage server
	@IF /I ["%~1"] EQU ["%system%\schannel.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:schannel.dll"
	@IF /I ["%~1"] EQU ["%system%\setupapi.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:SETUPAPI.dll"
	@IF /I ["%~1"] EQU ["%system%\wdigest.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:WDIGEST.dll"
	@IF /I ["%~1"] EQU ["%system%\eventlog.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:Eventlog.DLL"
	@IF /I ["%~1"] EQU ["%system%\es.dll"] CALL :ND_Search "1:Microsoft Corporation	7:------"
	@IF /I ["%~1"] EQU ["%system%\mspmsnsv.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:MsPMSNSv.dll"
	@IF /I ["%~1"] EQU ["%system%\mswsock.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:mswsock.dll"
	@IF /I ["%~1"] EQU ["%system%\tapisrv.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:TAPISRV.EXE"
	@IF /I ["%~1"] EQU ["%system%\xmlprov.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:xmlprov.dll"
	@IF /I ["%~1"] EQU ["%system%\linkinfo.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:LINKINFO.DLL"
	@IF /I ["%~1"] EQU ["%system%\cngaudit.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:cngaudit.dll"
	@IF /I ["%~1"] EQU ["%system%\hid.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:hid.dll"
	@IF /I ["%~1"] EQU ["%system%\clipsrv.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:CLIPSRV.EXE"
	@IF /I ["%~1"] EQU ["%system%\midimap.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:midimap.dll"
	@IF /I ["%~1"] EQU ["%system%\ksuser.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:ksuser.dll"
	@IF /I ["%~1"] EQU ["%system%\d3d8.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:D3D8.dll"
	@IF /I ["%~1"] EQU ["%system%\d3d9.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:D3D9.dll"
	@IF /I ["%~1"] EQU ["%system%\drivers\acpi.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ACPI.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\aec.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:aec.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\afd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:afd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\AGP440.SYS"] CALL :ND_SearchB "1:Microsoft Corporation	7:agp440.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\amdk6.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:amdk6.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\amdk7.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:amdk7.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\arp1394.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ARP1394.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\asyncmac.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ASYNCMAC.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\atapi.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:atapi.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\audstub.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:audstub.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\battc.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:battc.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\beep.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:beep.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\bridge.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:bridge.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\bthport.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:bthport.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\cbidf2k.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:cbidf2k.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\cdaudio.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:cdaudio.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\cdfs.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:cdfs.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\cdrom.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:cdrom.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\classpnp.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:Classpnp.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\CmBatt.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:cmbatt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\compbatt.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:compbatt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\cpqdap01.sys"] CALL :ND_SearchB "1:Compaq Computer Corporation	7:cpqdap01.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\crusoe.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:crusoe.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\disk.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:scsidisk.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\diskdump.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:diskdump.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dmboot.sys"] CALL :ND_SearchB "1:Microsoft Corp., Veritas Software	7:dmboot.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dmio.sys"] CALL :ND_SearchB "1:Microsoft Corp., Veritas Software	7:dmio.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dmload.sys"] CALL :ND_SearchB "1:Microsoft Corp., Veritas Software.	7:dmload.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\DMusic.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:DMusic.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\drmk.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:drmk.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\drmkaud.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:drmkaud.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dxapi.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:dxapi.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dxg.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:dxg.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dxgthk.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:dxgthk.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fastfat.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:FastFAT.Sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fdc.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:fdc.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fips.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:fips.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\flpydisk.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:floppy.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fltMgr.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:fltMgr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fsvga.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:fsvga.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fs_rec.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:fs_rec.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ftdisk.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ftdisk.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\gameenum.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:gameenum.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\hidclass.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:hidclass.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\hidparse.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:hidparse.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\hidusb.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:HIDUSB.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\http.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:http.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\i8042prt.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:i8042prt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\imapi.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:IMAPI.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\intelide.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:intelide.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\intelppm.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:intelppm.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\Ip6Fw.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ip6fw.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ipfltdrv.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ipfltdrv.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ipinip.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:IPINIP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ipnat.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:IPNAT.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ipsec.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ipsec.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\irenum.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:irenum.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\isapnp.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:isapnp.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\kbdclass.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:kbdclass.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\kmixer.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:kmixer.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ks.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ks.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ksecdd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ksecdd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mcd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:Mcd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mf.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:mf.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mnmdd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:videosim.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\modem.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:modem.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mouclass.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:mouclass.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mouhid.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:mouhid.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mountmgr.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:mountmgr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mqac.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:MQAC.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\mrxdav.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:MRxDAV.Sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mrxsmb.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:MRXSMB.Sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\msfs.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:MSFS.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\msgpc.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:MSGPC.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\MSKSSRV.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:mskssrv.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\MSPCLOCK.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:mspclock.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\MSPQM.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:mspqm.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mssmbios.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:smbios.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mup.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:MUP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ndis.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:NDIS.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ndistapi.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:NDISTAPI.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ndisuio.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:NDISUIO.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ndiswan.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:NDISWAN.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ndproxy.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ndproxy.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\netbios.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:NETBIOS.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\netbt.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:netbt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nic1394.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:nic1394.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nikedrv.sys"] CALL :ND_SearchB "1:S3/Diamond Multimedia Systems	7:NikeDrv.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nmnt.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:NMNT.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\npfs.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:npfs.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ntfs.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ntfs.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\null.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:null.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwlnkflt.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:nwlnkflt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwlnkfwd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:nwlnkfwd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwlnkipx.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:nwlnkipx.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwlnknb.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:nwlnknb.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwlnkspx.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:nwlnkspx.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwrdr.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:nwrdr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\oprghdlr.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:oprghdlr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\p3.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:p3.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\parport.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:parport.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\partmgr.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:partmgr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\parvdm.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:parvdm.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\pci.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:pci.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\pciidex.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:pciidex.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\pcmcia.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:pcmcia.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\portcls.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:portcls.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\processr.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:processr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\psched.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:PSCHED.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ptilink.sys"] CALL :ND_SearchB "1:Parallel Technologies, Inc.	7:ptilink.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rasacd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:rasacd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rasl2tp.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:rasl2tp.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\raspppoe.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:raspppoe.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\raspptp.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:RASPPTP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\rasadhlp.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:rasadhlp.dll"
	@IF /I ["%~1"] EQU ["%system%\drivers\raspti.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:raspti.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rawwan.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:RAWWAN.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\rdbss.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:RDBSS.Sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rdpcdd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:RDPCDD.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\rdpdr.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:RDPDR.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\rdpwd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:RDPWD.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\redbook.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:redbook.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rmcast.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:rmcast.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rndismp.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:RNDISMP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\rootmdm.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ROOTMDM.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\scsiport.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:scsiport.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sdbus.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:sdbus.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\serenum.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:serenum.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\serial.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:serial.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sffdisk.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:sffdisk.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sffp_sd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:sdprot.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sfloppy.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:sfloppy.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\smclib.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:smclib.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sonydcam.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:sonydcam.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\splitter.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:splitter.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sr.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:sr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\srv.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:SRV.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\stream.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:stream.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\swenum.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:swenum.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\swmidi.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:swmidi.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sysaudio.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:sysaudio.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tape.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:tape.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\TCPIP.SYS"] CALL :ND_SearchB "1:Microsoft Corporation	7:tcpip.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tcpip6.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:tcpip6.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tdi.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:tdi.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tdpipe.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:tdpipe.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tdtcp.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:tdtcp.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\termdd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:termdd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tosdvd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:tosdvd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tunmp.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:tunmp.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\udfs.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:udfs.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\update.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:update.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usb8023.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:usb8023.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbcamd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:usbcamd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbcamd2.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:usbcamd2.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbccgp.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:USBCCGP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbd.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:usbd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbehci.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:USBEHCI.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbhub.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:usbhub.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbintel.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:usbintel.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbport.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:usbport.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\USBSTOR.SYS"] CALL :ND_SearchB "1:Microsoft Corporation	7:usbstor.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbuhci.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:USBUHCI.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\vga.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:vga.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\videoprt.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:videoprt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\volsnap.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:volsnap.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\wanarp.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:WANARP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\wdmaud.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:WDMAUD.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\wmilib.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:WmiLib.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ws2ifsl.sys"] CALL :ND_SearchB "1:Microsoft Corporation	7:ws2ifsl.sys"
	@IF /I ["%~1"] EQU ["%system%\UxTheme.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:UxTheme.dll"
	@IF /I ["%~1"] EQU ["%system%\usp10.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:Uniscribe"
	@IF /I ["%~1"] EQU ["%system%\msimg32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:gdiext"
	@IF /I ["%~1"] EQU ["%system%\wininit.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:WinInit.exe"
	@IF /I ["%~1"] EQU ["%system%\d3d8thk.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:D3D8THK.dll"
	@IF /I ["%~1"] EQU ["%system%\wshtcpip.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:wshtcpip.dll"
	@IF /I ["%~1"] EQU ["%system%\ntdll.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:ntdll.dll"
	@IF /I ["%~1"] EQU ["%system%\msimg32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:gdiext"
	@IF /I ["%~1"] EQU ["%system%\sethc.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:SETHC.EXE"
	)
	
GREP -Fsq :\ ND_05 ||(
	IF /I ["%~1"] EQU ["%system%\userinit.exe"] (
	CALL ND_SearchC "1:Microsoft Corporation	7:USERINIT.EXE"
	IF NOT EXIST ND_05 (
		@ECHO.[hkey_local_machine\software\microsoft\windows nt\currentversion\winlogon]>>CregC.dat
		@ECHO."Userinit"="%systemroot:\=\\%\\explorer.exe,">>CregC.dat
		))
	@IF /I ["%~1"] EQU ["%system%\LPK.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:LanguagePack"
	@IF /I ["%~1"] EQU ["%system%\comres.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:------"
	@IF /I ["%~1"] EQU ["%system%\kernel32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:kernel32"
	@IF /I ["%~1"] EQU ["%system%\sfc.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:sfc.dll"
	@IF /I ["%~1"] EQU ["%system%\ntmssvc.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:ntmssvc.dll"
	@IF /I ["%~1"] EQU ["%system%\svchost.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:svchost.exe"
	@IF /I ["%~1"] EQU ["%system%\user32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:user32"
	@IF /I ["%~1"] EQU ["%system%\ws2_32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:ws2_32.dll"
	@IF /I ["%~1"] EQU ["%system%\ws2help.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:ws2help.dll"
	@IF /I ["%~1"] EQU ["%system%\wininet.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:wininet.dll"
	@IF /I ["%~1"] EQU ["%system%\winlogon.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:WINLOGON.EXE"
	@IF /I ["%~1"] EQU ["%system%\comctl32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:COMCTL32.DLL"
	@IF /I ["%~1"] EQU ["%system%\rpcss.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:rpcss.dll"
	@IF /I ["%~1"] EQU ["%system%\termsrv.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:termsrv.exe"
	@IF /I ["%~1"] EQU ["%system%\imm32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:imm32"
	@IF /I ["%~1"] EQU ["%system%\netlogon.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:NetLogon.DLL"
	@IF /I ["%~1"] EQU ["%system%\services.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:services.exe"
	@IF /I ["%~1"] EQU ["%system%\lsass.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:lsass.exe"
	@IF /I ["%~1"] EQU ["%system%\ctfmon.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:CTFMON.EXE"
	@IF /I ["%~1"] EQU ["%system%\spoolsv.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:spoolsv.exe"
	@IF /I ["%~1"] EQU ["%system%\userinit.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:USERINIT.EXE"
	@IF /I ["%~1"] EQU ["%system%\appmgmts.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:appmgmts.dll"
	@IF /I ["%~1"] EQU ["%system%\srsvc.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:SERVICE.DLL"
	@IF /I ["%~1"] EQU ["%system%\scecli.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:scecli"
	@IF /I ["%~1"] EQU ["%system%\dssenh.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:dssenh.dll"
	@IF /I ["%~1"] EQU ["%system%\ipsecsvc.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:ipsecsvc.dll"
	@IF /I ["%~1"] EQU ["%system%\msprivs.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:mspriv.dll"
	@IF /I ["%~1"] EQU ["%system%\oakley.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:oakley.dll"
	@IF /I ["%~1"] EQU ["%system%\psbase.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:psbase.dll"
	@IF /I ["%~1"] EQU ["%system%\pstorsvc.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:Protected storage server
	@IF /I ["%~1"] EQU ["%system%\schannel.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:schannel.dll"
	@IF /I ["%~1"] EQU ["%system%\setupapi.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:SETUPAPI.dll"
	@IF /I ["%~1"] EQU ["%system%\wdigest.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:WDIGEST.dll"
	@IF /I ["%~1"] EQU ["%system%\eventlog.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:Eventlog.DLL"
	@IF /I ["%~1"] EQU ["%system%\es.dll"] CALL :ND_Search "1:Microsoft Corporation	7:------"
	@IF /I ["%~1"] EQU ["%system%\mspmsnsv.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:MsPMSNSv.dll"
	@IF /I ["%~1"] EQU ["%system%\mswsock.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:mswsock.dll"
	@IF /I ["%~1"] EQU ["%system%\tapisrv.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:TAPISRV.EXE"
	@IF /I ["%~1"] EQU ["%system%\xmlprov.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:xmlprov.dll"
	@IF /I ["%~1"] EQU ["%system%\linkinfo.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:LINKINFO.DLL"
	@IF /I ["%~1"] EQU ["%system%\cngaudit.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:cngaudit.dll"
	@IF /I ["%~1"] EQU ["%system%\hid.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:hid.dll"
	@IF /I ["%~1"] EQU ["%system%\clipsrv.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:CLIPSRV.EXE"
	@IF /I ["%~1"] EQU ["%system%\midimap.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:midimap.dll"
	@IF /I ["%~1"] EQU ["%system%\ksuser.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:ksuser.dll"
	@IF /I ["%~1"] EQU ["%system%\d3d8.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:D3D8.dll"
	@IF /I ["%~1"] EQU ["%system%\d3d9.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:D3D9.dll"
	@IF /I ["%~1"] EQU ["%system%\drivers\acpi.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ACPI.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\aec.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:aec.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\afd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:afd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\AGP440.SYS"] CALL :ND_SearchC "1:Microsoft Corporation	7:agp440.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\amdk6.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:amdk6.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\amdk7.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:amdk7.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\arp1394.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ARP1394.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\asyncmac.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ASYNCMAC.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\atapi.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:atapi.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\audstub.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:audstub.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\battc.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:battc.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\beep.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:beep.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\bridge.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:bridge.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\bthport.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:bthport.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\cbidf2k.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:cbidf2k.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\cdaudio.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:cdaudio.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\cdfs.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:cdfs.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\cdrom.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:cdrom.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\classpnp.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:Classpnp.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\CmBatt.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:cmbatt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\compbatt.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:compbatt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\cpqdap01.sys"] CALL :ND_SearchC "1:Compaq Computer Corporation	7:cpqdap01.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\crusoe.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:crusoe.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\disk.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:scsidisk.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\diskdump.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:diskdump.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dmboot.sys"] CALL :ND_SearchC "1:Microsoft Corp., Veritas Software	7:dmboot.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dmio.sys"] CALL :ND_SearchC "1:Microsoft Corp., Veritas Software	7:dmio.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dmload.sys"] CALL :ND_SearchC "1:Microsoft Corp., Veritas Software.	7:dmload.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\DMusic.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:DMusic.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\drmk.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:drmk.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\drmkaud.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:drmkaud.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dxapi.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:dxapi.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dxg.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:dxg.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\dxgthk.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:dxgthk.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fastfat.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:FastFAT.Sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fdc.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:fdc.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fips.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:fips.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\flpydisk.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:floppy.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fltMgr.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:fltMgr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fsvga.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:fsvga.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\fs_rec.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:fs_rec.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ftdisk.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ftdisk.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\gameenum.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:gameenum.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\hidclass.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:hidclass.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\hidparse.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:hidparse.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\hidusb.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:HIDUSB.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\http.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:http.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\i8042prt.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:i8042prt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\imapi.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:IMAPI.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\intelide.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:intelide.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\intelppm.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:intelppm.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\Ip6Fw.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ip6fw.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ipfltdrv.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ipfltdrv.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ipinip.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:IPINIP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ipnat.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:IPNAT.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ipsec.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ipsec.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\irenum.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:irenum.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\isapnp.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:isapnp.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\kbdclass.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:kbdclass.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\kmixer.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:kmixer.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ks.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ks.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ksecdd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ksecdd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mcd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:Mcd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mf.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:mf.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mnmdd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:videosim.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\modem.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:modem.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mouclass.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:mouclass.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mouhid.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:mouhid.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mountmgr.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:mountmgr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mqac.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:MQAC.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\mrxdav.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:MRxDAV.Sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mrxsmb.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:MRXSMB.Sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\msfs.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:MSFS.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\msgpc.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:MSGPC.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\MSKSSRV.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:mskssrv.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\MSPCLOCK.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:mspclock.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\MSPQM.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:mspqm.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mssmbios.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:smbios.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\mup.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:MUP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ndis.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:NDIS.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ndistapi.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:NDISTAPI.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ndisuio.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:NDISUIO.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ndiswan.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:NDISWAN.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ndproxy.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ndproxy.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\netbios.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:NETBIOS.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\netbt.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:netbt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nic1394.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:nic1394.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nikedrv.sys"] CALL :ND_SearchC "1:S3/Diamond Multimedia Systems	7:NikeDrv.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nmnt.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:NMNT.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\npfs.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:npfs.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ntfs.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ntfs.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\null.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:null.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwlnkflt.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:nwlnkflt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwlnkfwd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:nwlnkfwd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwlnkipx.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:nwlnkipx.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwlnknb.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:nwlnknb.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwlnkspx.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:nwlnkspx.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\nwrdr.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:nwrdr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\oprghdlr.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:oprghdlr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\p3.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:p3.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\parport.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:parport.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\partmgr.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:partmgr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\parvdm.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:parvdm.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\pci.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:pci.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\pciidex.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:pciidex.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\pcmcia.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:pcmcia.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\portcls.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:portcls.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\processr.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:processr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\psched.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:PSCHED.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\ptilink.sys"] CALL :ND_SearchC "1:Parallel Technologies, Inc.	7:ptilink.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rasacd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:rasacd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rasl2tp.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:rasl2tp.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\raspppoe.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:raspppoe.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\raspptp.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:RASPPTP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\rasadhlp.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:rasadhlp.dll"
	@IF /I ["%~1"] EQU ["%system%\drivers\raspti.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:raspti.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rawwan.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:RAWWAN.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\rdbss.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:RDBSS.Sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rdpcdd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:RDPCDD.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\rdpdr.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:RDPDR.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\rdpwd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:RDPWD.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\redbook.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:redbook.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rmcast.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:rmcast.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\rndismp.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:RNDISMP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\rootmdm.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ROOTMDM.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\scsiport.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:scsiport.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sdbus.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:sdbus.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\serenum.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:serenum.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\serial.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:serial.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sffdisk.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:sffdisk.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sffp_sd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:sdprot.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sfloppy.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:sfloppy.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\smclib.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:smclib.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sonydcam.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:sonydcam.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\splitter.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:splitter.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sr.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:sr.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\srv.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:SRV.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\stream.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:stream.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\swenum.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:swenum.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\swmidi.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:swmidi.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\sysaudio.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:sysaudio.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tape.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:tape.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\TCPIP.SYS"] CALL :ND_SearchC "1:Microsoft Corporation	7:tcpip.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tcpip6.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:tcpip6.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tdi.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:tdi.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tdpipe.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:tdpipe.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tdtcp.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:tdtcp.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\termdd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:termdd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tosdvd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:tosdvd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\tunmp.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:tunmp.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\udfs.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:udfs.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\update.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:update.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usb8023.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:usb8023.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbcamd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:usbcamd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbcamd2.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:usbcamd2.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbccgp.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:USBCCGP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbd.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:usbd.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbehci.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:USBEHCI.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbhub.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:usbhub.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbintel.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:usbintel.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbport.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:usbport.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\USBSTOR.SYS"] CALL :ND_SearchC "1:Microsoft Corporation	7:usbstor.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\usbuhci.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:USBUHCI.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\vga.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:vga.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\videoprt.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:videoprt.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\volsnap.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:volsnap.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\wanarp.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:WANARP.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\wdmaud.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:WDMAUD.SYS"
	@IF /I ["%~1"] EQU ["%system%\drivers\wmilib.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:WmiLib.sys"
	@IF /I ["%~1"] EQU ["%system%\drivers\ws2ifsl.sys"] CALL :ND_SearchC "1:Microsoft Corporation	7:ws2ifsl.sys"
	@IF /I ["%~1"] EQU ["%system%\vssvc.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:VSSVC.EXE"
	@IF /I ["%~1"] EQU ["%system%\UxTheme.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:UxTheme.dll"
	@IF /I ["%~1"] EQU ["%system%\usp10.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:Uniscribe"
	@IF /I ["%~1"] EQU ["%system%\msimg32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:gdiext"
	@IF /I ["%~1"] EQU ["%system%\wininit.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:WinInit.exe"
	@IF /I ["%~1"] EQU ["%system%\d3d8thk.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:D3D8THK.dll"
	@IF /I ["%~1"] EQU ["%system%\wshtcpip.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:wshtcpip.dll"
	@IF /I ["%~1"] EQU ["%system%\ntdll.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:ntdll.dll"
	@IF /I ["%~1"] EQU ["%system%\msimg32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:gdiext"
	@IF /I ["%~1"] EQU ["%system%\sethc.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:SETHC.EXE"
	)
	
@GOTO :EOF


:ND_SearchB
@IF "%~1"=="" GOTO :EOF
@IF NOT EXIST ND_Legits (
	REM START NIRCMD INFOBOX "A readily available replacement was not found.~nComboFix needs to do an intensive search.~n~nThis may take some time." "Disk Search"
	START NIRCMD INFOBOX "%LINE106%"
	PEV -tpmz -rtf -t!o -t!b -tg -c##f#b#b1:#d#b7:#k# AND { %system%\* or %system%\drivers\* } -output:ND_Legits
	)
@GREP -F "%~1" ND_Legits >ND_05b &&SED "s/\t.*//" ND_05b >ND_05
@DEL ND_05b
@GOTO :EOF


:ND_SearchC
@IF "%~1"=="" GOTO :EOF
@IF NOT EXIST ND_Legits_QooBox PEV -rtf -t!o -t!b -tg -c##f#b#b1:#d#b7:#k# AND { %SystemDrive%\Qoobox\Quarantine\%system::=%\* or %SystemDrive%\Qoobox\Quarantine\%system::=%\drivers\* } -output:ND_Legits_QooBox
@GREP -F "%~1" ND_Legits_QooBox >ND_05b &&SED "s/	.*//" ND_05b >ND_05
@DEL ND_05b
@GOTO :EOF


:MISSING
REM check dllcache first
IF EXIST "%system%\dllcache\%~nx1" PEV -tx30000 -rtf -t!b "%system%\dllcache\%~nx1" -tg -output:temp00 &&(
	ATTRIB -H -R -S "%system%\dllcache\%~nx1"
	COPY /Y "%system%\dllcache\%~nx1" "%~1"
	Call :ND_SubE "%~1" "%system%\dllcache\%~nx1"
	DEL /A/F temp0?
	GOTO :EOF
	)


REM search machine for other copies; use ONLY latest copy found
CALL :ND_Search "%~1"


IF EXIST ND_05 (
	SED 1!d ND_05 >ND_06
	FOR /F "TOKENS=*" %%G IN ( ND_06 ) DO @(
		ATTRIB -H -R -S "%%~G"
		COPY /Y "%%~G" "%~1"
		Call :ND_SubE "%~1" "%%~G"
		)
	) ELSE CALL :ND_SubE "%~1" "NotFound"

@SWXCACLS "%SystemDrive%\system volume information" /P /GS:F /I REMOVE /Q	
DEL /A/Q temp0? ND_0? SRC0?
GOTO :EOF



:ND_SubE
IF EXIST "%~1" (
	@REM CALL ECHO.%~1 was missing>>ndis_log.dat
	@REM CALL ECHO.Restored copy from - %~2>>ndis_log.dat
	CALL ECHO.%Line78% >>ndis_log.dat
	CALL ECHO.%Line36A%>>ndis_log.dat
	ECHO.>>ndis_log.dat
	ECHO.>>CFReboot.dat
) ELSE (
	REM ECHO.%~1 . . . is missing!!>>ndis_log.dat
	CALL ECHO.%Line79%>>ndis_log.dat
	ECHO.>>ndis_log.dat
	)

@IF NOT EXIST %SystemDrive%\qoobox\lastrun md %SystemDrive%\qoobox\lastrun
@IF EXIST ndis_log.dat IF EXIST SvcTarget.dat COPY /Y ndis_log.dat %SystemDrive%\qoobox\lastrun\ndis_log.old
@GOTO :EOF


:ND_SubD
COPY /Y/B/V "%~1" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
IF NOT EXIST "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir" CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%~1" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"

IF EXIST "%CD%\MT_%~nx1.tmp" (
	PEV -tx30000 -rtf "%CD%\MT_%~nx1.tmp" -t!b -tg -output:ND_04 &&ECHO."%CD%\MT_%~nx1.tmp"	"%~1"	"The cat ate it :)">NDIS.mov
) ELSE IF EXIST "%system%\dllcache\%~nx1" PEV -tx30000 -rtf -t!b "%system%\dllcache\%~nx1" -tg -output:temp00 &&(
	COPY /Y/B/V "%system%\dllcache\%~nx1" %CD%\MT_%~nx1.tmp
	IF NOT EXIST %CD%\MT_%~nx1.tmp CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%system%\dllcache\%~nx1" %CD%\MT_%~nx1.tmp
	ECHO."%CD%\MT_%~nx1.tmp"	"%~1"	"%system%\dllcache\%~nx1">NDIS.mov
	)

IF EXIST NDIS.mov (
	TYPE NDIS.mov >>ND.mov
	ECHO.>CFReboot.dat
	IF NOT EXIST DIS_WFP CALL :DIS_WFP
	FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( NDIS.mov ) DO @(
		IF EXIST %system%\dllcache\ COPY /Y "%%~G" "%system%\dllcache\%~nx1"
		%KMD% /D /C MoveIt.bat "%%~H" ND_
		IF EXIST "%%~H" (
			COPY /Y/B/V "%%~H" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
			IF NOT EXIST "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir" CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%%~H" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
			CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -E "%%~H"
			)
		COPY /Y "%%~G" "%%~H"
		IF NOT EXIST "%%~H" CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%%~G" "%%~H"
		)
	GOTO :EOF
	)

CALL :ND_Search "%~1"

IF EXIST ND_05 (
	SED 1!d ND_05 >ND_06
	FOR /F "TOKENS=*" %%G IN ( ND_06 ) DO @(
		%KMD% /D /C MoveIt.bat "%~1" ND_
		IF NOT EXIST "%~1" COPY /Y/B/V "%%~G" "%~1%
		COPY /Y/B/V "%%~G" %CD%\MT_%~nx1.tmp
		IF NOT EXIST %CD%\MT_%~nx1.tmp CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%%~G" %CD%\MT_%~nx1.tmp
		ECHO."%CD%\MT_%~nx1.tmp"	"%~1"	"%%~G">>ND.mov
		ECHO.>CFReboot.dat
		)
	) ELSE CALL :ND_SubC "%~1" "%~1"


@SWXCACLS "%SystemDrive%\system volume information" /P /GS:F /I REMOVE /Q
DEL /A/Q temp0? ND_0? SRC0?
GOTO :EOF

:NTKRNLMP
REM check dllcache first
IF EXIST "%system%\dllcache\ntkrnlmp.exe" (
	PEV -tx30000 -rtf -t!b "%system%\dllcache\ntkrnlmp.exe" -tg -output:temp00 
	GREP -Fsq :\ temp00 &&(
		%KMD% /D /C MoveIt.bat "%~1" ND_
		IF EXIST "%~1" (
			COPY /Y/B/V "%~1" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
			CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%~1" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
			CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -E "%~1"
			)
		ECHO.>CFReboot.dat
		IF NOT EXIST DIS_WFP CALL :DIS_WFP
		ATTRIB -H -R -S "%system%\dllcache\ntkrnlmp.exe"
		COPY /Y/B/V "%system%\dllcache\ntkrnlmp.exe" "%~1"
		IF NOT EXIST "%~1" CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%system%\dllcache\ntkrnlmp.exe" "%~1"
		IF NOT EXIST "%~1" COPY /Y "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir" "%~1"
		Call :ND_SubC "%~1" "%system%\dllcache\ntkrnlmp.exe" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
		DEL /A/F temp0?
		GOTO :EOF
		))

REM search machine for other copies; use ONLY latest copy found

CALL :ND_Search "%~DP1ntkrnlmp.exe"
GOTO ND_Post-Search
GOTO :EOF


:NTKRPAMP
REM check dllcache first
IF EXIST "%system%\dllcache\ntkrnlmp.exe" (
	PEV -tx30000 -rtf -t!b "%system%\dllcache\ntkrpamp.exe" -tg -output:temp00 
	GREP -Fsq :\ temp00 &&(
		%KMD% /D /C MoveIt.bat "%~1" ND_
		IF EXIST "%~1" (
			COPY /Y/B/V "%~1" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
			IF NOT EXIST "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir" CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%~1" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
			CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -E "%~1"
			)
		ECHO.>CFReboot.dat
		IF NOT EXIST DIS_WFP CALL :DIS_WFP
		ATTRIB -H -R -S "%system%\dllcache\ntkrpamp.exe"
		COPY /Y "%system%\dllcache\ntkrpamp.exe" "%~1"
		IF NOT EXIST "%~1" CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%system%\dllcache\ntkrpamp.exe" "%~1"
		IF NOT EXIST "%~1" COPY /Y "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir" "%~1"
		Call :ND_SubC "%~1" "%system%\dllcache\ntkrpamp.exe" "%SystemDrive%\Qoobox\Quarantine\%system:~,1%%~PNX1.vir"
		DEL /A/F temp0?
		GOTO :EOF
		))

REM search machine for other copies; use ONLY latest copy found

CALL :ND_Search "%~DP1ntkrpamp.exe"
GOTO ND_Post-Search
GOTO :EOF


:NDMOV
@COPY /Y/B/V "%~2" "%CD%\MT_%~nx1.tmp"
@IF NOT EXIST "%CD%\MT_%~nx1.tmp" CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -c "%~2" "%CD%\MT_%~nx1.tmp"
@IF EXIST Vista.krl PEV MOVEEX "%~1"
@PEV MOVEEX "%CD%\MT_%~nx1.tmp" "%~1"
@CATCHME -i "%CD%\MT_%~nx1.tmp"
@ECHO."%CD%\MT_%~nx1.tmp"	"%~1"	"%~2">>ND.mov
@GOTO :EOF

:DIS_WFP
@ECHO.>DIS_WFP
@PEV MOVEEX DIS_WFP
@HANDLE %system% | SED -R "/winlogon.exe\s*pid: (\d*)\s*([0-9a-f]*): %system:\=\\%(\\drivers|)$/I!d; s//@HANDLE -p \1 -c \2 -y/" >UNHANDLE.BAT
@ECHO.@ECHO.^>NULL >> UNHANDLE.BAT
@CALL UNHANDLE.BAT
@DEL  UNHANDLE.BAT
@GOTO :EOF

:RemMtPts
@ECHO.>W32Diag.dat
@PEV -td -te "%SystemRoot%\*" -output:RemMtPts
@PEV WAIT 3000
@PEV RemMtPts
@FOR /F "TOKENS=*" %%G IN ( RemMtPts ) DO @(
	SWXCACLS "%%~G" /GA:F /Q
	RD "%%~G"
	)
@GOTO :EOF

@ECHO ON
@Prompt $


:Vss
@PEV DDEV -A| FINDSTR -BI HarddiskVolumeShadowCopy | SORT /M 65536 /R /O Vss00
@FOR /F "TOKENS=*" %%G IN ( Vss00 ) DO @IF NOT EXIST "HarddiskVolumeShadowCopy*%~NX1" (
	PEV DDEV b: "\\?\GlobalRoot\Device\%%~G"
	IF EXIST "b:%~pnx1" IF NOT EXIST NoSig.dat (
		PEV -rtf -tg -t!b "b:%~pnx1" >Vss01
		) ELSE FINDSTR -MI "%~3" "b:%~pnx1" ||ECHO."b:%~pnx1">Vss01
	IF NOT EXIST NoSig.dat GREP -Fisq "b:%~pnx1" Vss01 || (
		PEV -tx90000 -limit:1 -samdate -tf -t!b -tg "b:%systemroot:~2%\%~nx1" >Vss01
		IF /I ["%~1"] EQU ["%System%\Services.exe"] (
			PEV -tx90000 -limit:1 -samdate -tf -t!b -tg "b:%systemroot:~2%\%~nx1" >>Vss01
			PEV -tx90000 -limit:1 -samdate -tf -t!b -tg "b:%systemroot:~2%\%~nx1" >>Vss01
			))
	IF EXIST Vss01 FOR /F "TOKENS=*" %%H IN ( Vss01 ) DO CALL :VssSource "%%~G" "%%~H"
	PEV DDEV -D b:
	DEL Vss01
	)
@DEL /A/F/Q Vss0?
@GOTO :EOF


:VssSource
@SET "VSource_=%~1"
@SET "VSourceFile_=%~2"
@SET "VSourceFile_=%VSourceFile_:\=!%"
@IF NOT EXIST Vss\ MD Vss
@XCOPY /Y/H/Q/R %2 "%CD%\Vss\"
@ATTRIB -H -R -S "Vss\%~NX2"
@MOVE /Y "Vss\%~NX2" "%VSource_%_%VSourceFile_:~2%"
@IF EXIST "%VSource_%_%VSourceFile_:~2%" ECHO."%CD%\%VSource_%_%VSourceFile_:~2%">ND_05
@RD Vss
@SET VSource_=
@SET VSourceFile_=
@GOTO :EOF


:SFC_MISSING
@PEV -samdate -tx50000 -tf -t!b -tpmz "%SystemRoot%\sfcfiles.dll" NOT "%system%\sfcfiles.dll" -output:ND_05
@FOR /F "TOKENS=*" %%G IN ( ND_05 ) DO @GREP -Eisq "sfcfiles.dll.SfcGetFiles" "%%G" &&(
	ATTRIB -H -R -S "%%G"
	COPY /Y "%%G" "%system%\sfcfiles.dll"
	Call :ND_SubE "%system%\sfcfiles.dll" "%%G"
	GOTO :EOF
	)
@CALL :ND_SubE "%system%\sfcfiles.dll" "NotFound"
@DEL /A/Q temp0? ND_0?
@GOTO :EOF

