

@CD /D "%~DP0"
@IF NOT EXIST W6432.dat GOTO :EOF
@IF EXIST chcp.bat CALL chcp.bat
@PROMPT $
CLS

IF ["%~1"]==[""] GOTO :EOF
IF ["%~2"]==["MISSING"] GOTO MISSING
PEV -rtb "%~1" || GOTO :EOF
IF ["%~3"]==["NDMOV"] GOTO :NDMOV

IF EXIST "%~NX1_X64.ND_" GOTO :EOF
ECHO.%TIME% >"%~NX1_X64.ND_"

IF /I ["%~1"] EQU ["%SysDir%\ntoskrnl.exe"] IF 1%NUMBER_OF_PROCESSORS% GTR 11 GOTO NTKRNLMP
IF /I ["%~1"] EQU ["%SysDir%\ntkrnlpa.exe"] IF 1%NUMBER_OF_PROCESSORS% GTR 11 GOTO NTKRPAMP


IF ["%~2"]==["FINDNOW"] (
	CALL :VSS "%~1"
	GOTO :EOF
	)

IF ["%~2"]==["FINDNOW_X"] (
	CALL :ND_Search "%~1"
	GREP -Fsq :\ ND_05 ||CALL ECHO.%Line37% . . . %Failed to find a valid replacement%.>>ndis_log.dat
	GOTO :EOF
	)

IF /I ["%~1"] EQU ["%SysDir%\winlogon.exe"] (
	PAUSEP 2>&1| SED -r "/^PID\t(.*)\twinlogon.exe$/!d; s//\1/" >PIDit.dat
	FOR /F "TOKENS=*" %%G IN ( PIDit.dat ) DO @PEV EXEC /S "%CD%\PAUSEP.%cfext%" %%G
	DEL PIDit.dat
	)

IF /I ["%~1"] EQU ["%SysDir%\wininit.exe"] (
	PAUSEP 2>&1| SED -r "/^PID\t(.*)\twininit.exe$/!d; s//\1/" >PIDit.dat
	FOR /F "TOKENS=*" %%G IN ( PIDit.dat ) DO @PEV EXEC /S "%CD%\PAUSEP.%cfext%" %%G
	DEL PIDit.dat
	)


REM search machine for other copies; use ONLY latest copy found

CALL :ND_Search "%~1"

:ND_Post-Search
IF EXIST ND_05 (
	SED 1!d ND_05 >ND_06
	FOR /F "TOKENS=*" %%G IN ( ND_06 ) DO @(
		ECHO.>CFReboot.dat
		IF NOT EXIST DIS_WFP CALL :DIS_WFP
		%KMD% /D /C MoveIt.bat "%~1" ND_
		ATTRIB -H -R -S "%%~G"
		COPY /Y "%%~G" "%~1"
		IF NOT EXIST "%~1" COPY /Y "%SystemDrive%\Qoobox\Quarantine\%SysDir:~,1%%~PNX1.vir" "%~1"
		PEV WAIT 500
		Call :ND_SubC "%~1" "%%~G" "%SystemDrive%\Qoobox\Quarantine\%SysDir:~,1%%~PNX1.vir"
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
	COPY /Y/B "%~1" "%cd%\test__test"
	PEV -tx30000 -rtf -tb "test__test" -tg -output:ND_07 &&(
		ECHO."%~1"	"%~2">>ndis_recheck.task
		@REM ECHO.Infected copy of %%~1 was found and disinfected>>ndis_log.dat
		@REM ECHO.Restored copy from - %%~2 >>ndis_log.dat
		CALL ECHO.%Line36% >>ndis_log.dat
		CALL ECHO.%Line36A% >>ndis_log.dat
		IF /I "%~N1" EQU "winlogon" echo.sf %SysDir%\ws2_32.dll ^>^>ndis_log.dat>>Combobatch.bat
		ECHO.>>ndis_log.dat
		ECHO.>>CFReboot.dat
		ECHO.   Successfully restored :^)>>"%~NX1.ND_"
		)||(
		CALL :NDMOV "%~1" "%~2"
		REM ECHO.%%~1 . . . is infected!!>>ndis_log.dat
		CALL ECHO.%Line37% . . .Failed to restore. Attempting to replace on reboot >>ndis_log.dat
		ECHO.>>ndis_log.dat
		)
) ELSE (
	IF /I ["%~1"] EQU ["%SysDir%\LPK.dll"] %KMD% /D /C MoveIt.bat "%SysDir%\lpk.dll"
	REM ECHO.%%~1 . . . is infected!!>>ndis_log.dat
	CALL ECHO.%Line37%>>ndis_log.dat
	ECHO.>>ndis_log.dat
	)


@DEL /A/F ND_07 "%cd%\test__test"
@IF NOT EXIST %SystemDrive%\qoobox\lastrun md %SystemDrive%\qoobox\lastrun
@IF EXIST ndis_log.dat IF EXIST SvcTarget.dat TYPE ndis_log.dat >> %SystemDrive%\qoobox\lastrun\ndis_log.old
@GOTO :EOF


:ND_Search
@REM search machine for other copies; use ONLY latest copy found
PEV -tx60000 -tf -tb -tg "%SystemRoot%\%~nx1" NOT { -preg"%SysDir:\=\\%|:\\Windows\\SysWow64\\|\\winsxs\\(x86|wow64)_" or "%%~1" } -output:ND_05
IF /I ["%~1"] EQU ["%SysDir%\Services.exe"] (
	PEV -tx60000 -tf -tb -tg "%SystemRoot%\%~nx1" NOT { -preg"%SysDir:\=\\%|:\\Windows\\SysWow64\\|\\winsxs\\(x86|wow64)_" or "%%~1" } >> ND_05
	PEV -tx60000 -tf -tb -tg "%SystemRoot%\%~nx1" NOT { -preg"%SysDir:\=\\%|:\\Windows\\SysWow64\\|\\winsxs\\(x86|wow64)_" or "%%~1" } >> ND_05
	)
SED -r "s/^%SysDir:\=\\%(.*)/%SysNative:\=\\%\1/I;" ND_05 > ND_05a
FOR /F "TOKENS=*" %%G IN ( ND_05a ) DO @PEV -rtb "%%~G" >>ND_05b
ECHO.::::>>ND_05b
PEV -limit:1 -samdate -tb -files"ND_05b" -output:ND_05
DEL ND_05a ND_05b

GREP -Fsq :\ ND_05 ||(
	DEL /A/F ND_05
	CALL :VSS_64 %1
	)

GREP -Fsq :\ ND_05 ||(
	IF /I ["%~1"] EQU ["%SysNative%\userinit.exe"] (
		CALL ND_SearchB "1:Microsoft Corporation	7:USERINIT.EXE.MUI"
		IF NOT EXIST ND_05 (
			@ECHO.[hkey_local_machine\software\microsoft\windows nt\currentversion\winlogon]>>CregC.dat
			@ECHO."Userinit"="%systemroot:\=\\%\\explorer.exe,">>CregC.dat
			))
	@IF /I ["%~1"] EQU ["%SysNative%\appmgmts.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:appmgmts.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\cngaudit.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:cngaudit.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\comctl32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:COMCTL32.DLL.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\comres.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:COMRES.DLL.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\ctfmon.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:CTFMON.EXE.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\d3d8thk.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:D3D8THK.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\d3d9.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:D3D9.dll
	@IF /I ["%~1"] EQU ["%SysNative%\dssenh.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:dssenh.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\es.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:ES.DLL"
	@IF /I ["%~1"] EQU ["%SysNative%\hid.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:hid.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\imm32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:imm32"
	@IF /I ["%~1"] EQU ["%SysNative%\IPSECSVC.DLL"] CALL :ND_SearchB "1:Microsoft Corporation	7:ipsecsvc.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\kernel32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:kernel32"
	@IF /I ["%~1"] EQU ["%SysNative%\ksuser.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:ksuser.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\linkinfo.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:LINKINFO.DLL"
	@IF /I ["%~1"] EQU ["%SysNative%\lpk.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:LanguagePack"
	@IF /I ["%~1"] EQU ["%SysNative%\lsass.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:lsass.exe"
	@IF /I ["%~1"] EQU ["%SysNative%\midimap.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:midimap.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\msimg32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:gdiext"
	@IF /I ["%~1"] EQU ["%SysNative%\msprivs.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:mspriv.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\mswsock.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:mswsock.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\netlogon.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:NetLogon.DLL.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\psbase.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:psbase.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\pstorsvc.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:Protected storage server"
	@IF /I ["%~1"] EQU ["%SysNative%\rpcss.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:rpcss.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\scecli.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:scecli"
	@IF /I ["%~1"] EQU ["%SysNative%\schannel.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:schannel.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\services.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:services.exe.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\setupapi.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:SETUPAPI.DLL.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\sfc.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:sfc.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\spoolsv.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:spoolsv.exe.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\svchost.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:svchost.exe.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\tapisrv.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:TAPISRV.EXE.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\termsrv.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:termsrv.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\user32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:user32"
	@IF /I ["%~1"] EQU ["%SysNative%\userinit.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:USERINIT.EXE.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\usp10.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:Uniscribe"
	@IF /I ["%~1"] EQU ["%SysNative%\uxtheme.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:UxTheme.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\wdigest.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:WDIGEST.DLL"
	@IF /I ["%~1"] EQU ["%SysNative%\wininet.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:wininet.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\wininit.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:WinInit.exe.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\winlogon.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:WINLOGON.EXE.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\ws2_32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:ws2_32.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\ws2help.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:ws2help.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\rasadhlp.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:rasadhlp.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\ntdll.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:ntdll.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\msimg32.dll"] CALL :ND_SearchB "1:Microsoft Corporation	7:gdiext"
	@IF /I ["%~1"] EQU ["%SysNative%\sethc.exe"] CALL :ND_SearchB "1:Microsoft Corporation	7:sethc.exe.mui"
	)
		

GREP -Fsq :\ ND_05 ||(
	IF /I ["%~1"] EQU ["%SysDir%\userinit.exe"] (
	CALL ND_SearchC "1:Microsoft Corporation	7:USERINIT.EXE.MUI"
	IF NOT EXIST ND_05 (
		@ECHO.[hkey_local_machine\software\microsoft\windows nt\currentversion\winlogon]>>CregC.dat
		@ECHO."Userinit"="%systemroot:\=\\%\\explorer.exe,">>CregC.dat
		))
	@IF /I ["%~1"] EQU ["%SysNative%\appmgmts.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:appmgmts.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\cngaudit.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:cngaudit.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\comctl32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:COMCTL32.DLL.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\comres.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:COMRES.DLL.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\ctfmon.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:CTFMON.EXE.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\d3d8thk.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:D3D8THK.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\d3d9.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:D3D9.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\dssenh.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:dssenh.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\es.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:ES.DLL"
	@IF /I ["%~1"] EQU ["%SysNative%\hid.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:hid.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\imm32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:imm32"
	@IF /I ["%~1"] EQU ["%SysNative%\IPSECSVC.DLL"] CALL :ND_SearchC "1:Microsoft Corporation	7:ipsecsvc.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\kernel32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:kernel32"
	@IF /I ["%~1"] EQU ["%SysNative%\ksuser.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:ksuser.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\linkinfo.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:LINKINFO.DLL"
	@IF /I ["%~1"] EQU ["%SysNative%\lpk.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:LanguagePack"
	@IF /I ["%~1"] EQU ["%SysNative%\lsass.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:lsass.exe"
	@IF /I ["%~1"] EQU ["%SysNative%\midimap.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:midimap.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\msimg32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:gdiext"
	@IF /I ["%~1"] EQU ["%SysNative%\msprivs.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:mspriv.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\mswsock.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:mswsock.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\netlogon.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:NetLogon.DLL.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\psbase.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:psbase.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\pstorsvc.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:Protected storage server"
	@IF /I ["%~1"] EQU ["%SysNative%\rpcss.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:rpcss.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\scecli.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:scecli"
	@IF /I ["%~1"] EQU ["%SysNative%\schannel.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:schannel.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\services.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:services.exe.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\setupapi.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:SETUPAPI.DLL.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\sfc.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:sfc.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\spoolsv.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:spoolsv.exe.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\svchost.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:svchost.exe.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\tapisrv.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:TAPISRV.EXE.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\termsrv.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:termsrv.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\user32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:user32"
	@IF /I ["%~1"] EQU ["%SysNative%\userinit.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:USERINIT.EXE.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\usp10.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:Uniscribe"
	@IF /I ["%~1"] EQU ["%SysNative%\uxtheme.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:UxTheme.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\wdigest.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:WDIGEST.DLL"
	@IF /I ["%~1"] EQU ["%SysNative%\wininet.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:wininet.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\wininit.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:WinInit.exe.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\winlogon.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:WINLOGON.EXE.MUI"
	@IF /I ["%~1"] EQU ["%SysNative%\ws2_32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:ws2_32.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\ws2help.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:ws2help.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\rasadhlp.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:rasadhlp.dll"
	@IF /I ["%~1"] EQU ["%SysNative%\ntdll.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:ntdll.dll.mui"
	@IF /I ["%~1"] EQU ["%SysNative%\msimg32.dll"] CALL :ND_SearchC "1:Microsoft Corporation	7:gdiext"
	@IF /I ["%~1"] EQU ["%SysNative%\sethc.exe"] CALL :ND_SearchC "1:Microsoft Corporation	7:sethc.exe.mui"
	)
@GOTO :EOF


:ND_SearchB
@IF "%~1"=="" GOTO :EOF
@IF NOT EXIST ND_Legits PEV -rtf -t!o -tb -tg -c##f#b#b1:#d#b7:#k# AND %SysDir%\* -output:ND_Legits
@GREP -F "%~1" ND_Legits >ND_05b &&SED "s/\t.*//; s/%SysDir:\=\\%\\/%SysNative:\=\\%\\/I;" ND_05b >ND_05
@DEL ND_05b
@GOTO :EOF


:ND_SearchC
@IF "%~1"=="" GOTO :EOF
@IF NOT EXIST ND_Legits_QooBox PEV -rtf -t!o -tb -tg -c##f#b#b1:#d#b7:#k# AND %SystemDrive%\Qoobox\Quarantine\%SysDir::=%\* -output:ND_Legits_QooBox
@GREP -F "%~1" ND_Legits_QooBox >ND_05b &&SED "s/	.*//" ND_05b >ND_05
@DEL ND_05b
@GOTO :EOF


:MISSING
REM search machine for other copies; use ONLY latest copy found
@CALL :ND_Search "%~1"

@IF EXIST ND_05 (
	SED 1!d ND_05 >ND_06
	FOR /F "TOKENS=*" %%G IN ( ND_06 ) DO @(
		ATTRIB -H -R -S "%%~G"
		COPY /Y "%%~G" "%~1"
		Call :ND_SubE "%~1" "%%~G"
		)
	) ELSE CALL :ND_SubE "%~1" "NotFound"

@SWXCACLS "%SystemDrive%\system volume information" /P /GS:F /I REMOVE /Q
@DEL /A/Q temp0? ND_0? SRC0?
@GOTO :EOF



:ND_SubE
IF EXIST "%~1" (
	@REM CALL ECHO.%~1 was missing>>ndis_log.dat
	@REM CALL ECHO.Restored copy from - %~2>>ndis_log.dat
	CALL ECHO.%Line78% >>ndis_log.dat
	CALL ECHO.%Line36A%>>ndis_log.dat
	ECHO.>>ndis_log.dat
	ECHO.>>CFReboot.dat
) ELSE (
	@REM ECHO.%~1 . . . is missing!!>>ndis_log.dat
	CALL ECHO.%Line79%>>ndis_log.dat
	ECHO.>>ndis_log.dat
	)

@IF NOT EXIST %SystemDrive%\qoobox\lastrun md %SystemDrive%\qoobox\lastrun
@IF EXIST ndis_log.dat IF EXIST SvcTarget.dat COPY /Y ndis_log.dat %SystemDrive%\qoobox\lastrun\ndis_log.old
@GOTO :EOF



:NTKRNLMP
REM search machine for other copies; use ONLY latest copy found
CALL :ND_Search "%~DP1ntkrnlmp.exe"
GOTO ND_Post-Search
GOTO :EOF


:NTKRPAMP
REM search machine for other copies; use ONLY latest copy found
CALL :ND_Search "%~DP1ntkrpamp.exe"
GOTO ND_Post-Search
GOTO :EOF


:NDMOV
@COPY /Y/B/V "%~2" "%CD%\MT_%~nx1.tmp"
@PEV MOVEEX "%~1"
@PEV MOVEEX "%CD%\MT_%~nx1.tmp" "%~1"
@ECHO."%CD%\MT_%~nx1.tmp"	"%~1"	"%~2">>ND.mov
@GOTO :EOF


:DIS_WFP
@ECHO.>DIS_WFP
@PEV MOVEEX DIS_WFP
@HANDLE %system% | SED -R "/winlogon.exe\s*pid: (\d*)\s*([0-9a-f]*): %SysDir:\=\\%(\\drivers|)$/I!d; s//@HANDLE -p \1 -c \2 -y/" >UNHANDLE.BAT
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


:Vss_64
@PEV DDEV -A| FINDSTR -BI HarddiskVolumeShadowCopy | SORT /M 65536 /R /O Vss00
@FOR /F "TOKENS=*" %%G IN ( Vss00 ) DO @IF NOT EXIST "HarddiskVolumeShadowCopy*%~NX1" (
	PEV DDEV b: "\\?\GlobalRoot\Device\%%~G"
	IF EXIST "b:%~pnx1" PEV -rtf -tb -tg "b:%~pnx1" >Vss01
	GREP -Fisq "b:%~pnx1" Vss01 ||(
		PEV -tx90000 -tf -tb -tg "b:%systemroot:~2%\%~nx1" NOT -preg":\\Windows\\SysWow64\\|\\winsxs\\(x86|wow64)_" -output:Vss01
		IF /I ["%~1"] EQU ["%SysDir%\Services.exe"] (
			PEV -tx90000 -tf -tb -tg "b:%systemroot:~2%\%~nx1" NOT -preg":\\Windows\\SysWow64\\|\\winsxs\\(x86|wow64)_" >> output:Vss01
			PEV -tx90000 -tf -tb -tg "b:%systemroot:~2%\%~nx1" NOT -preg":\\Windows\\SysWow64\\|\\winsxs\\(x86|wow64)_" >> output:Vss01
			)
		FOR /F "TOKENS=*" %%H IN ( Vss01 ) DO @PEV -rtb "%%~H" && ECHO.%%H>>Vss01b
		ECHO.::::>>Vss01b
		PEV -limit:1 -samdate -files"Vss01b" -output:Vss01
		DEL Vss01b
		)
	FOR /F "TOKENS=*" %%I IN ( Vss01 ) DO CALL :VssSource "%%~G" "%%~I"
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
