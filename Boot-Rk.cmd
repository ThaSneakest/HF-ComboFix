

@TITLE ComboFix.
SWREG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V AUTORESTARTSHELL /T REG_DWORD /D 0

:: @IF EXIST CFReboot.dat DEL /A/F CFReboot.dat

CALL Lang.bat >N_\%random% 2>&1
ECHO.Boot-RK>RBoot.dat
@Nircmd win close class "#32770"

IF EXIST Foreign.dat IF EXIST Cfiles.dat FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( Foreign.dat ) DO @GREP -Fisq "%%~G" Cfiles.dat &&(
	ECHO."%%~H">>d-del_A.dat
	%KMD% /D /C MoveIt.bat "%%~H"
	)>N_\%random% 2>&1


IF EXIST Catch_KB.dat (
	SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" Catch_KB.dat >Catch_KB00
	IF EXIST Catch_KB00 MOVE /Y Catch_KB00 Catch_KB.dat
	TYPE Catch_KB.dat |MTEE /+ d-del_A.dat >%systemdrive%\Qoobox\LastRun\d-del_A.dat
	IF EXIST %systemdrive%\Qoobox\LastRun\RK_Catch_KB.dat DEL /A/F %systemdrive%\Qoobox\LastRun\RK_Catch_KB.dat 
	CALL Boot.bat AVDEL
	PEV -k explorer.exe
	NIRCMD WIN ACTIVATE ITITLE ComboFix.
	NIRCMD SENDKEY ENTER PRESS
	IF NOT EXIST Res.bat NIRCMD WIN HIDE ITITLE ComboFix.
	NIRCMD LOOP 2 80 BEEP 3000 200
	SED "s/\x22//g; :a; $!N;s/\n/~n/;ta;P;D" Catch_KB.dat >RK_Comment
	REM NIRCMD INFOBOX "ComboFix has detected the presence of rootkit activity and needs to reboot the machine~nKindly note down on paper, the name of each file. We may need it later~n~n%%G" "Rootkit !!"
	FOR /F "TOKENS=*" %%G IN ( RK_Comment ) DO @NIRCMD INFOBOX "%Line10%" ""
	)>N_\%random% 2>&1


IF NOT EXIST RK_Comment (
	PEV -k explorer.exe
	NIRCMD WIN ACTIVATE ITITLE ComboFix.
	NIRCMD SENDKEY ENTER PRESS
	IF NOT EXIST Res.bat NIRCMD WIN HIDE ITITLE ComboFix.
	NIRCMD LOOP 2 80 BEEP 3000 200
		IF EXIST TDL2.dat (
			SED -r "/:/!d; s/(.*)\t(.*)/~nService:  \1~nFile:  \2/;" TDL2.dat| SED "s/\x22//g; :a; $!N;s/\n/~n/;ta;P;D" >RK_Comment
			DEL TDL2.dat
			REM NIRCMD INFOBOX "Rootkit activity persist. Have to attempt other methods~nComboFix needs to reboot the machine again~nKindly note down on paper, the data below. We may need it later"
			FOR /F "TOKENS=*" %%G IN ( RK_Comment ) DO @NIRCMD INFOBOX "%Line10B%~n%%G" "Rootkit !! TDL3"	
		) ELSE IF EXIST TDL2B.dat (
			SED -r "/:/!d; s/(.*)\t(.*)/~nService:  \1~nFile:  \2/;" TDL2B.dat| SED ":a; $!N;s/\n/~n/;ta;P;D" >RK_Comment
			DEL TDL2B.dat
			REM NIRCMD INFOBOX "ComboFix has detected the presence of rootkit activity and needs to reboot the machine~nKindly note down on paper, the data below. We may need it later"
			FOR /F "TOKENS=*" %%G IN ( RK_Comment ) DO @NIRCMD INFOBOX "%Line10C%~n%%G" "Rootkit !! TDL3"	
		) ELSE (
			REM NIRCMD INFOBOX "ComboFix has detected the presence of rootkit activity and needs to reboot the machine" "Rootkit !!"
			NIRCMD INFOBOX "%Line10A%" ""
			))


DEL /A/F RK_Comment >N_\%random% 2>&1
IF NOT EXIST ComboDel.txt IF EXIST Res.bat CALL Boot.bat AVDEL >N_\%random% 2>&1
IF NOT EXIST ComboDel.txt IF EXIST Max.mov CALL Boot.bat AVDEL >N_\%random% 2>&1


IF EXIST CregC_.dat REGT /S CregC_.dat >N_\%random% 2>&1
REGT /S CregC.dat >N_\%random% 2>&1


@IF EXIST DIS_WFP DEL /A/F DIS_WFP
@IF EXIST c.mrk DEL /A/F c.mrk

SWREG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V AUTORESTARTSHELL /T REG_DWORD /D 1
IF EXIST wtf_tdssserv GOTO Boot-RKB


IF EXIST CatchmeTest.dat (
	SWREG QUERY "HKLM\HARDWARE\DESCRIPTION\System\MultifunctionAdapter" /s >MultifunctionAdapter00
	SED -R "/HKEY_LOCAL_MACHINE\\hardware\\description\\system\\multifunctionadapter\\\d*\\DiskController\\\d*\\DiskPeripheral\\\d*$/I!d" MultifunctionAdapter00 >MultifunctionAdapter01
	FOR /F "TOKENS=*" %%G IN ( MultifunctionAdapter01 ) DO @SWREG DELETE "%%~G" /v Identifier
	DEL /A/F/Q MultifunctionAdapter0?
	)>N_\%random% 2>&1

SWREG ADD "hklm\software\microsoft\windows\currentversion\runonceex" /v "flags" /t reg_dword /d 8
SWREG ADD "hklm\software\microsoft\windows\currentversion\runonceex\001" /v "*combofix" /d "\"%cd%\%KMD%\" /c \"%cd%\C.bat\""
SWREG ADD "hklm\software\microsoft\windows\currentversion\runonce" /v "combofix" /d "\"%cd%\%KMD%\" /c \"%cd%\C.bat\""
SWREG ADD "hklm\software\microsoft\windows\currentversion\run" /v "combofix" /d "\"%cd%\%KMD%\" /c \"%cd%\C.bat\""
IF DEFINED sfxname IF NOT EXIST W6432.dat CATCHME -l N_\%random% -i "%sfxname%" >N_\%random%

GOTO Boot-RKC



:Boot-RKB
DEL /A/F wtf_tdssserv >N_\%random% 2>&1
MOVE /Y sfx.cmd "\Qoobox\" >N_\%random% 2>&1

SWREG ADD "hklm\software\microsoft\windows\currentversion\runonceex" /v "flags" /t reg_dword /d 8
SWREG ADD "hklm\software\microsoft\windows\currentversion\runonceex\000" /v "*combofix" /d "\"%sfxname%\""


:Boot-RKC
IF EXIST erunt_sw.dat (
	CLS
	NIRCMD WIN HIDE CLASS CONSOLEWINDOWCLASS
	START NIRCMD INFOBOX "%Line29%~n~n%Line97%" "ComboFix"
	MOVE erunt_sw.dat erunt.dat >N_\%random% 2>&1
	CALL Boot.bat ERU
	)

NIRCMD WIN ACTIVATE TITLE .
NIRCMD SENDKEY ENTER PRESS
NIRCMD WIN ACTIVATE ITITLE ":  ."
NIRCMD SENDKEY ENTER PRESS
NIRCMD WIN HIDE ITITLE .
DEL /A/F Desktop.ini
IF EXIST Res.bat ECHO.RD /S/Q "%systemroot%\erdnt\subs">>Res.bat

IF EXIST TDL4mbr.dat (
	MOVE /Y TDL4mbr.dat %systemdrive%\Qoobox\LastRun\TDL4mbrDone.old
	PEV WAIT 10000
	ECHO.y|RMBR -f
	)>N_\%random% 2>&1
	
:: IF EXIST max_.dat Catchme -U
START NIRCMD EXITWIN REBOOT FORCE
PEV WAIT 13000

IF NOT EXIST W6432.dat (
	Catchme -U
	) ELSE Shutdown /R /T 0
	
EXIT

