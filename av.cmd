@PROMPT $

@(
ECHO.Malware Catcher
ECHO.Malware Destructor
ECHO.Extra Antivirus
ECHO.Fast Antivirus
ECHO.Virus Shield
ECHO.{28e00e3b-806e-4533-925c-f4c3d79514b9}
ECHO.Coreguard Antivirus
ECHO.Protection System
ECHO.Windows Security Suite
ECHO.Windows Protection Suite
ECHO.AdwareAlert
ECHO.SmitFraudFixTool
ECHO.Smart Virus Eliminator
ECHO.MalwareRemovalBot
ECHO.AdwareBot
ECHO.AntispywareBot
ECHO.AntiMalware
ECHO.Windows PC Defender
ECHO.Windows Enterprise Defender
ECHO.VundoFixTool
ECHO.Windows System Defender
ECHO.Volcano Security Suite
ECHO.System Defender
ECHO.SpywareBot
ECHO.Windows Enterprise Suite
ECHO.Total Security 10
ECHO.Additional Guard
ECHO.Enterprise Suite
ECHO.PC Live Guard
ECHO.Malware Defense
ECHO.Live PC Care
ECHO.Antivirus System PRO
ECHO.Antivirus Live
ECHO.Security Antivirus
ECHO.Security Guard
ECHO.CleanUp Antivirus
ECHO.Digital Protection
ECHO.Antispyware Soft
ECHO.My Security 
ECHO.Security Master
ECHO.Advanced Security Tool 20
ECHO.Antivirus Soft
ECHO.Smart Engine
ECHO.{86868212-25CB-4425-9D0D-D61DAF0B6ED1}
ECHO.Internet Security Suite
ECHO.Internet Antivirus
ECHO.Personal Internet Security 20
ECHO.Smart Internet
ECHO.Internet Security Essentials
ECHO.Best Malware
ECHO.: Smart Security *
ECHO.: Antivirus AntiSpyware 20
ECHO.: Antivir Solution Pro
ECHO.Spy Emergency
ECHO.System Smart Security
ECHO.Strong Malware
ECHO.Home Malware
ECHO.Smart Anti-Malware
ECHO.Antimalware PC Safety
ECHO.PC Cleaner
)>AvBlack

@(
ECHO.{D68DDC3A-831F-4FAE-9E44-DA132C1ACF46}
)>AvWhite


:Av-check
SET /a AVCount+=1

START NIRCMD CMDWAIT 9000 EXEC HIDE PEV -k CSCRIPT.%cfext%
CSCRIPT //NOLOGO //E:VBSCRIPT //B //T:08 av.vbs
PEV -k NIRCMD.%cfext%

CALL RKEY.cmd
REM IF EXIST "%PROGRAMFILES%\AVG\*" CALL :AVG
IF EXIST "%PROGRAMFILES%\CA\*" CALL :CA

IF NOT EXIST AvBlack00 GREP -Fsf AVBlack resident.txt >AvBlack00 &&(
	SED -r "s/\x22//g; s/.*\) //; s/.*(\{.{8}-.{4}-.{4}-.{4}-.{12}\}).*/\1/" AvBlack00 >AvBlack01
	FOR /F "TOKENS=*" %%G IN ( AvBlack01 ) DO @CSCRIPT //NOLOGO //E:VBSCRIPT //T:5 wmi_rem.vbs "%%~G"
	START NIRCMD CMDWAIT 6000 EXEC HIDE PEV -k CSCRIPT.%cfext%
	CSCRIPT //NOLOGO //E:VBSCRIPT //B //T:08 av.vbs
	PEV -k NIRCMD.%cfext%
	)

GREP -Fivf AVWhite resident.txt | GREP -E "^(AV|SP): .*\*Enabled/" >AVChk &&(
SED -r "s/^AV:/antivirus:       /; s/^SP:/antispyware: /; s/ \*Enabled\/.*//" AVChk| SED ":a; $!N;s/\n/~n/;ta" >AVChkB

NIRCMD LOOP 2 80 BEEP 3000 200

REM @NIRCMD INFOBOX "ComboFix has detected the following real time scanner(s) to be active:~n~n%%G~n~nAntivirus and intrusion prevention programs are known to interfere~nwith ComboFix's running. This may lead to unpredictable results or~npossible machine damage.~n~nPlease disable these scanners before clicking 'OK'." "Warning !!"

IF %AVCount% LEQ 1 FOR /F "TOKENS=*" %%G IN ( AVChkB ) DO @NIRCMD INFOBOX "%Line76%" "" &&GOTO Av-check

REM NIRCMD INFOBOX "%%G~n~nThe above real time scanner(s) are still active but ComboFix shall~ncontinue to run. Kindly note that this is at your own risk" "Warning !!"

IF %AVCount% GTR 1 FOR /F "TOKENS=*" %%G IN ( AVChkB ) DO @NIRCMD INFOBOX "%Line77%" ""
)

DEL /A/F/Q AVChk? AvWhite AvBlack AvBlack0?
IF NOT EXIST Vista.krl CALL RKEY.cmd RKEYB
SET AVCount=
@GOTO :EOF

:AVG
IF EXIST sfx.cmd GREP -Eisq "\\CFScript_AVG2011[^:\/\\]*$" sfx.cmd &&(
	NIRCMD LOOP 2 80 BEEP 3000 200
	ECHO.>UninstAVG2011
	REM NIRCMDC QBOXCOMTOP "You have asked ComboFix to remove AVG using brute force methods.~n~nClick 'YES' to continue .. or .. click 'NO' to exit now" "Do you want to remove AVG?" FILLDELETE UninstAVG2011
	NIRCMD INFOBOX "%Line103%"  FILLDELETE UninstAVG2011
	IF NOT EXIST UninstAVG2011 GOTO :EOF
	)
PEV -tx50000 -tpmz "%PROGRAMFILES%\AVG\*" | GREP -c . | GREP -Esqx . ||(
	REM NIRCMD INFOBOX "ComboFix cannot run when AVG is installed.~nThis is due to AVG's targeting of ComboFix's files/processes.~nIt would be dangerous to continue.~n~nPlease uninstall AVG or use another tool" "Warning"
	NIRCMD INFOBOX "%Line104%"
	CD ..
	START %System%\cmd.exe /c RD /S/Q %SystemDrive%\32788R22FWJFW
	EXIT
	)
@GOTO :EOF

:CA
PEV -tx50000 -tpmz and { "%PROGRAMFILES%\CA\CA Anti-Virus Plus\*" or "%PROGRAMFILES%\CA\CA Internet Security Suite\*" } | GREP -c . | GREP -Esqx . ||(
	REM NIRCMD INFOBOX "ComboFix cannot run when CA Anti-Virus is installed.~nIt would be dangerous to continue.~n~nPlease uninstall CA Anti-Virus or use another tool" "Warning"
	NIRCMD INFOBOX "%Line105%"
	CD ..
	START %System%\cmd.exe /c RD /S/Q %SystemDrive%\32788R22FWJFW
	EXIT
	)
@GOTO :EOF

	
	
