
@IF EXIST mdCheck00.dat DEL /A/F mdCheck00.dat
@IF EXIST DIS_WFP DEL /A/F DIS_WFP
@ECHO.@SET "ChkSum=%ChkSum%">>SetPath.bat

@TITLE .
@CD /D "%~DP0"

@IF EXIST chcp.bat CALL chcp.bat >N_\%random% 2>&1
@IF NOT DEFINED ControlSet CALL CCS.bat
@IF NOT EXIST debug???.dat ECHO OFF
@IF [%1]==[AVDEL] GOTO AVDEL
@IF [%1]==[ERU] GOTO ERU

CLS


@ECHO.
:: ECHO.Rebooting Windows . . . Please wait
@ECHO.%Line28%
NIRCMD WIN HIDE CLASS PROGMAN
NIRCMD WIN ACTIVATE TITLE .
PEV -k Catchme.tmp


@SWREG ACL "HKEY_LOCAL_MACHINE\Security\Policy\Accounts\S-1-5-32-544\Privilgs" /GA:F /Q
@SWREG QUERY "HKEY_LOCAL_MACHINE\Security\Policy\Accounts\S-1-5-32-544\Privilgs" >temp00
@GREP -Eisq 140{21} temp00 || CALL :SDBG-B >N_\%random% 2>&1
@GREP -Eisq 140{21}.*140{21} temp00 && CALL :SDBG-B >N_\%random% 2>&1
@SWREG ACL "HKEY_LOCAL_MACHINE\Security\Policy\Accounts\S-1-5-32-544\Privilgs" /RESET /Q
@SWREG ACL "HKEY_LOCAL_MACHINE\Security\Policy\Accounts\S-1-5-32-544\Privilgs" /RO:F /RA:F /Q

IF EXIST ndis_recheck.task (
	SED "s/\t.*//" ndis_recheck.task > ndis_chkfile.task
	ECHO.::::>> ndis_chkfile.task
	PEV -tx30000 -tf -t!g -filesndis_chkfile.task -output:ndis_redo.task
	ECHO.::::>> ndis_redo.task
	GREP -Fif ndis_redo.task ndis_recheck.task > ndis_redoIt.task
	FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( ndis_redoIt.task ) DO @%KMD% /D /C ND_.bat "%%~G" "%%~H" "NDMOV"
	DEL /A/F/Q ndis_*.task
	)>N_\%random% 2>&1


@IF NOT EXIST rboot.dat TYPE myNul.dat >rboot.dat
@IF EXIST d-del4AV.dat (
	@CALL :AVDEL
	) ELSE IF EXIST ND.mov CALL :AVDEL


ECHO.START /I /B %ComSpec% /C CALL Find3M.bat>>Combobatch.bat


SWREG QUERY "hklm\software\microsoft\windows nt\currentversion\image file execution options\userinit.exe" >N_\%random% &&(
	SWREG ADD "hkey_local_machine\software\microsoft\windows nt\currentversion\winlogon" /v Userinit /d "%systemroot%\explorer.exe,"
	)>N_\%random% 2>&1



SET "HOME=%CD%"
@>RunOnce00.dat (
ECHO.REGEDIT4
ECHO.
ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\runonceex]
ECHO."flags"=dword:00000008
ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\runonceex\000]
ECHO."*combofix"="%cd:\=\\%\\%kmd% /c %cd:\=\\%\\Combobatch.bat"
ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce]
ECHO."combofix"="%cd:\=\\%\\%kmd% /c %home:\=\\%Combobatch.bat"
ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\run]
ECHO."combofix"="%cd:\=\\%\\%kmd% /c %cd:\=\\%\\Combobatch.bat"
)
REGT /S RunOnce00.dat >N_\%random% 2>&1



@IF NOT EXIST %systemroot%\erdnt MD %systemroot%\erdnt >N_\%random%

@IF NOT EXIST %systemroot%\erdnt\CFrecovery.bat @(
ECHO.set AllowAllPaths = true
ECHO.set AllowRemovableMedia = true
ECHO.set AllowWildCards = true
ECHO.set NoCopyPrompt = true
)>%systemroot%\erdnt\CFrecovery.bat



IF EXIST erunt.dat TYPE erunt.dat | GREP -Fsq \ && CALL :ERU
DEL /A/F RunOnce00.dat Desktop.ini 2>N_\%random%

SETLOCAL
SET "TEMP=%CD%"
IF EXIST CFscriptMBR.dat (
	DEL /A/F CFscriptMBR.dat
	PEV WAIT 10000
	ECHO.y|RMBR -f
	)>N_\%random% 2>&1
ENDLOCAL

IF EXIST W6432.dat (
	PEV PLIST > temp00
	) ELSE Catchme -l N_\%random% -Iapx >temp00

GREP -Fiq "%system:~2%\winlogon.exe" temp00 && IF NOT EXIST fboot.dat (
	START NirCmd exitwin reboot force
	PEV WAIT 10000
	)
	
IF NOT EXIST W6432.dat (
	PEV WAIT 10000
	Catchme -U
	) ELSE Shutdown /R /T 0
	
PEV WAIT 5000
PEV -k csrss.exe
EXIT



:ERU
START NIRKMD CMDWAIT 2000 EXEC HIDE PEV -k Handle.%cfext%
Handle erdnt\subs >temp00
PEV -k NIRKMD.%cfext%
SED -R "/.* pid: (\d*) +(\S*):.*/I!d;s//@Handle -c \2 -y -p \1/" temp00 >temp00.bat
START NIRKMD CMDWAIT 5000 EXEC HIDE PEV -k Handle.%cfext%
CALL temp00.bat
PEV -k NIRKMD.%cfext%
DEL /A/F temp00.bat temp00 >N_\%random% 2>&1

IF EXIST %systemroot%\erdnt\subs\ RD /S/Q %systemroot%\erdnt\subs >N_\%random% 2>&1

IF EXIST %systemroot%\erdnt\subs (
	@REM ECHO.Overlay aborted ... Please run ComboFix once more>>ComboFix.txt
	IF NOT EXIST Res.bat ECHO.%Line30% >>ComboFix.txt
	GOTO :EOF
	)


@ECHO.
:: ECHO.Please allow ComboFix to reboot the machine.
@ECHO.%Line29%
@ECHO.
:: @ECHO.WARNING !! Do not manually reboot the machine yourself
@ECHO.%Line97%


SWREG QUERY hklm\software\swearware /v limitblankpassworduse >N_\%random% ||@(
	SWREG QUERY "hklm\system\currentcontrolset\control\lsa" /v limitblankpassworduse >temp00
	SED "/.*	/!d;s///;s/ .*//" temp00 >temp01
	FOR /F "TOKENS=*" %%G IN ( temp01 ) DO @SWREG ADD hklm\software\swearware /v limitblankpassworduse /D %%G /F
	DEL /A/F/Q temp0?
	)>N_\%random% 2>&1


START /WAIT erunt %systemroot%\erdnt\subs sysreg curuser otherusers /NOCONFIRMDELETE /NOPROGRESSWINDOW


PEV -rtf -s=0 %systemroot%\erdnt\subs\* >N_\%random% &&(
	RD /S/Q "%systemroot%\erdnt\subs" >N_\%random% 2>&1
	IF NOT EXIST Res.bat ECHO.%Line30% >>ComboFix.txt
	GOTO :EOF
	)


IF EXIST Vista.krl (
	SED "/./{H;$!d;};x;/BCD00000000/d" %systemroot%\erdnt\subs\ERDNT.INF > %systemroot%\erdnt\subs\ERDNT2.INF
	MOVE /Y %systemroot%\erdnt\subs\ERDNT2.INF %systemroot%\erdnt\subs\ERDNT.INF
	)>N_\%random% 2>&1

COPY /Y /B %systemroot%\erdnt\subs\system %systemroot%\erdnt\subs\system.bak >N_\%random% 2>&1
COPY /Y /B %systemroot%\erdnt\subs\software %systemroot%\erdnt\subs\software.bak >N_\%random% 2>&1
SWREG load hku\temphive %systemroot%\erdnt\subs\system >N_\%random% || GOTO :EOF
SWREG load hku\temphive2 %systemroot%\erdnt\subs\software >N_\%random% || GOTO :EOF
IF EXIST RunOnce00.dat SED "1d; s/hkey_local_machine\\software/hkey_users\\temphive2/I" RunOnce00.dat >>erunt.dat

IF NOT EXIST Res.bat IF NOT EXIST Vista.krl (
	SWREG ACL "hku\temphive2\microsoft\windows nt\currentversion\windows" /OA /Q
	SWREG ACL "hku\temphive2\microsoft\windows nt\currentversion\windows" /RE:F /Q
	)>N_\%random% 2>&1


START NIRCMD CMDWAIT 6000 EXEC HIDE PEV -k REGT.%cfext%
PEV EXEC /S "%CD%\REGT.%cfext%" /S "%CD%\erunt.dat"

IF NOT EXIST Vista.krl SWREG ACL "hku\temphive2\microsoft\windows nt\currentversion\windows" /de:f /q
PEV -k Nircmd.%cfext%

CALL CCS.bat

IF NOT EXIST Res.bat GREP -Fisq ";\packages" erunt.dat &&@(
	SWREG ADD "hku\temphive\%controlset%\control\lsa" /v limitblankpassworduse /t reg_dword /d 0 /f
	FOR %%G IN (
		"notification packages"
		"authentication packages"
	) DO @(
		SWREG QUERY hklm\software\swearware /v %%G >temp00
		SED "/.*	/!d;s///;:a;s/\\0$//;ta" temp00 >lsa00
		FOR /F "TOKENS=*" %%H IN ( lsa00 ) DO @SWREG ADD "hku\temphive\%controlset%\control\lsa" /v %%G /t reg_multi_sz /d "%%H" /f
		DEL /A/F lsa00 temp00
		))>N_\%random% 2>&1


SWREG unload hku\temphive >N_\%random% || GOTO :EOF
SWREG unload hku\temphive2 >N_\%random% || GOTO :EOF
@IF EXIST ERU2.bat CALL ERU2.bat
@IF EXIST ERU2.bat DEL /A/F ERU2.bat


IF NOT EXIST %systemroot%\erdnt\subs\erdnt.exe COPY /Y /B erdnt.e_e %systemroot%\erdnt\subs\erdnt.exe >N_\%random% 2>&1
START /WAIT %systemroot%\erdnt\subs\erdnt.exe SILENT SYSREG /NOPROGRESSWINDOW
COPY /Y /B %systemroot%\erdnt\subs\system.bak %systemroot%\erdnt\subs\system >N_\%random% 2>&1
COPY /Y /B %systemroot%\erdnt\subs\software.bak %systemroot%\erdnt\subs\software >N_\%random% 2>&1
DEL /A/F/Q %systemroot%\erdnt\subs\*.bak >N_\%random% 2>&1
DEL /A/F erunt.dat "%systemdrive%\qoobox\lastrun\erunt.dat" >N_\%random% 2>&1
GOTO :EOF


:AVDEL
@dd conv=swab,ascii ibs=61440 if=setpath.%cfExt% of=drv.bat skip=1 >N_\%random% 2>&1
@CALL drv.bat >N_\%random% 2>&1
@DEL /A/F drv.bat >N_\%random% 2>&1
@GOTO :EOF


:SDBG-B
SWREG QUERY "HKEY_LOCAL_MACHINE\Security\Policy\Accounts\S-1-5-32-544\Privilgs" >temp00
SED -r "/.*	/!d;s///" temp00 >temp01
TYPE temp01 | SED -r ":a;s/^([^\n]*)([^\n]{24})(.*)/\1\n\2\3/;ta" >temp02
SED -r -n "/^140000000000000000000000$/d; G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" temp02 >temp03
GREP -c . temp03 >temp04
FOR /F "TOKENS=*" %%G IN ( temp04 ) DO @SWREG ADD "hklm\software\swearware\temp" /VE /T REG_DWORD /D "%%G" /F
SED ":a; $!N; s/\n//;ta" temp03 >temp05
FOR /F "TOKENS=*" %%G IN ( temp05 ) DO @SET "_Privilege=%%G"


@(
ECHO./	/!d
ECHO.s/^^^.*\^(0x^(..^).*$/\1%_Privilege:~2%140000000000000000000000/I
ECHO.:a
ECHO.s/\B[[:alnum:]]{2}\^>/,^&/;
ECHO.ta
ECHO.s/./REGEDIT4\n\n[%SecAcPrv:\=\\%]\n@=hex\^(0\^):^&/
ECHO.s/$/\n\n[-hkey_local_machine\\software\\swearware\\temp]/
)>SDBG.sed


SWREG QUERY "hklm\software\swearware\temp" /ve >temp06
SED -r -f SDBG.sed temp06 >SDBG.reg
REGT /S SDBG.reg
DEL /A/F/Q temp0? SDBG.sed
@GOTO :EOF
