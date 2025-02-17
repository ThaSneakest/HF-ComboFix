

@IF NOT EXIST InstallRC DEL /A/F %0


IF NOT EXIST XP.mac  (
	REM NircmdB.exe INFOBOX "Will only install the Recovery Console for Windows XP" ""
	NIRCMD LOOP 2 80 BEEP 3000 200
	NircmdB.exe INFOBOX "%LINE51%" ""
	GOTO AbortRC
	)


:: NIRCMD infobox "Boot Partition cannot be enumerated correctly" "" && GOTO AbortRC
IF NOT DEFINED BootDir NIRCMD infobox "%LINE52%" "" && GOTO AbortRC


GREP -Eisq "^default( =|=)" %BootDir%Boot.ini ||(
	REM CALL NircmdB.exe INFOBOX "%%BootDir%%Boot.ini is not correctly formated" ""
	NIRCMD LOOP 2 80 BEEP 3000 200
	CALL NircmdB.exe INFOBOX "%Line53%" ""
	GOTO AbortRC
	)


IF NOT EXIST AddDriver03 IF EXIST %BootDir%cmdcons\bootsect.dat GREP -isq "CMDCONS\\BOOTSECT.DAT" %BootDir%Boot.ini &&(
	IF EXIST Rboot.dat GOTO :EOF
	NIRCMD LOOP 2 80 BEEP 3000 200
	REM NircmdB.exe INFOBOX "This machine already has the Recovery Console installed.~n~nAborting operations" ""
	NircmdB.exe INFOBOX "%Line54%" ""
	GOTO AbortRC
	)


SED -r "s/^.*(.:\\.*)$/\1/;s/\x22//" InstallRC >RC00

FOR /F "TOKENS=*" %%G IN ( RC00 ) DO @IF EXIST "%%G" (
	ECHO.%%~NXG>CF-RC.txt
	REM NIRCMD INFOBOX "Please click 'YES' in the End User License Agreement (EULA) dialog that follows ..." "Installing the Recovery Console"
	NIRCMD INFOBOX "%Line55%" ""
	"%%G" /c /t:"%CD%\RC"
) ELSE IF EXIST "%%~SG" (
	ECHO.%%~NXG>CF-RC.txt
	NIRCMD INFOBOX "%Line55%" ""
	"%%~SG" /c /t:"%CD%\RC"
) ELSE (
	REM CALL NircmdB.exe INFOBOX "Installation file - %%~G - cannot be found"
	CALL NircmdB.exe INFOBOX "%Line56%" ""
	GOTO AbortRC
	)

DEL /A/F/Q RC0? N_\* AddDriver0?



IF NOT EXIST "%cd%\RC\cdboot1.img" (
	REM NircmdB.exe INFOBOX "You didn't select YES~n~nInstallation is aborted" ""
	NircmdB.exe INFOBOX "%Line57%" ""
	GOTO AbortRC
	)


IF EXIST %BootDir%cmdcons (
	IF EXIST f_system SWXCACLS %BootDir%cmdcons /RESET /Q
	RD /S/Q %BootDir%cmdcons
	)>N_\%random% 2>&1


MD %BootDir%cmdcons >N_\%random% 2>&1

EXTRACT -ox RC\cdboot?.img %BootDir%cmdcons >N_\%random% 2>&1

COPY /Y /B %system%\autochk.exe %BootDir%cmdcons >N_\%random% 2>&1

COPY /Y /B %system%\autofmt.exe %BootDir%cmdcons >N_\%random% 2>&1

EXPAND.exe -r %BootDir%cmdcons\txtsetup.si_ >N_\%random% 2>&1

IF EXIST IntelMatrix.zip (
	PEV UZIP IntelMatrix.zip "%BootDir%cmdcons"
	TYPE "%BootDir%cmdcons\IASTOR66.SY_" >>"%BootDir%cmdcons\txtsetup.sif"
	DEL IntelMatrix.zip "%BootDir%cmdcons\IASTOR66.SY_"
	)>N_\%random% 2>&1

IF EXIST nvidia.zip (
	PEV UZIP nvidia.zip "%BootDir%cmdcons"
	TYPE "%BootDir%cmdcons\NVGTS4.SY_" >>"%BootDir%cmdcons\txtsetup.sif"
	DEL nvidia.zip "%BootDir%cmdcons\NVGTS4.SY_"
	)>N_\%random% 2>&1

IF EXIST via.zip (
	PEV UZIP via.zip "%BootDir%cmdcons"
	TYPE "%BootDir%cmdcons\VIAPDSK1.SY_" >>"%BootDir%cmdcons\txtsetup.sif"
	DEL via.zip "%BootDir%cmdcons\VIAPDSK1.SY_"
	)>N_\%random% 2>&1

IF EXIST sisscsi.zip (
	PEV UZIP sisscsi.zip "%BootDir%cmdcons"
	TYPE "%BootDir%cmdcons\SISRAID3.SY_" >>"%BootDir%cmdcons\txtsetup.sif"
	DEL sisscsi.zip "%BootDir%cmdcons\SISRAID3.SY_"
	)>N_\%random% 2>&1

IF EXIST txtsetup._if (
	SED -r "/\tBE$/!d; s/.*//" txtsetup._if >txtsetupA._if
	SED -r "/\tBE$/d;" txtsetup._if >txtsetupB._if
	FOR /F "TOKENS=1,2* DELIMS=	" %%G IN ( txtsetupA._if ) DO @IF EXIST "%%~H.CFSY_" (
		MOVE /Y "%%~H.CFSY_" "%BootDir%cmdcons\%%~H.SY_"
		NIRCMD INISETVAL "%BootDir%cmdcons\txtsetup.sif" "HardwareIdsDatabase" "%%G" "%%H"
		NIRCMD INISETVAL "%BootDir%cmdcons\txtsetup.sif" "BusExtenders.Load" "%%H" "%%H.SY_"
		NIRCMD INISETVAL "%BootDir%cmdcons\txtsetup.sif" "BusExtenders" "%%H" "%%H_BE,files.%%H,%%H"
		(ECHO.&ECHO.[files.%%H]&ECHO.pciidex.sys,4&ECHO.%%H.SY_,4)>>"%BootDir%cmdcons\txtsetup.sif"
		)
	FOR /F "TOKENS=1,2* DELIMS=	" %%G IN ( txtsetupB._if ) DO @IF EXIST "%%~H.CFSY_" (
		MOVE /Y "%%~H.CFSY_" "%BootDir%cmdcons\%%~H.SY_"
		NIRCMD INISETVAL "%BootDir%cmdcons\txtsetup.sif" "HardwareIdsDatabase" "%%G" "%%H"
		NIRCMD INISETVAL "%BootDir%cmdcons\txtsetup.sif" "SCSI.Load" "%%H" "%%H.SY_,4"
		NIRCMD INISETVAL "%BootDir%cmdcons\txtsetup.sif" "SCSI" "%%H" "%%H_SCSI"
		)
	DEL /A/F/Q txtsetup*._if
	)>N_\%random% 2>&1

COPY /Y /B %BootDir%cmdcons\setupldr.bin %BootDir%cmldr >N_\%random% 2>&1
ATTRIB +H +S +R %BootDir%cmldr >N_\%random% 2>&1

@(
ECHO.> "%BootDir%f_system!@#_$+__________________     :test"
)>N_\%random% 2>&1 &&(
	dd if=\\.\%bootdir:~,2% of=%BootDir%cmdcons\bootsect.dat bs=8192 count=1
	GSAR -o -sN:x00T:x00L:x00D:x00R:x00 -rC:x00M:x00L:x00D:x00R:x00 %BootDir%cmdcons\bootsect.dat
	DEL /A/F "\\?\%BootDir%f_system!@#_$+__________________     "
)>N_\%random% 2>&1||(
	dd if=\\.\%bootdir:~,2% of=%BootDir%cmdcons\bootsect.dat bs=512 count=1
	GSAR -o -sNTLDR:x20:x20 -rCMLDR:x20:x20 %BootDir%cmdcons\bootsect.dat
	)>N_\%random% 2>&1

REGT /a /s MountedDevices.reg "HKEY_LOCAL_MACHINE\SYSTEM\MountedDevices"


@>%BootDir%cmdcons\migrate.inf (
ECHO.[Version]
ECHO.Signature = "$Windows NT$"
ECHO.
ECHO.[Addreg]
)



SED "1,3d" MountedDevices.reg |(
	SED -r "s/\\\\/\\/g;:a;/\\$/N; s/\\\n  //; ta" | SED "/hex:/I!d; s/=hex:/,0x00030001,\\\n     /;/^\x22/s/./HKLM,\x22SYSTEM\\MountedDevices\x22,&/" |SED -r "/^     /s/[^\\ ]{75}/&\\\n     /g"
	)>>%BootDir%cmdcons\migrate.inf



@>%BootDir%cmdcons\winnt.sif (
ECHO.[data]
ECHO.msdosinitiated="1"
ECHO.floppyless="1"
ECHO.CmdCons="1"
ECHO.LocalSourceOnCD="1"
ECHO.AutoPartition="0"
ECHO.UseSignatures="yes"
ECHO.InstallDir="%systemroot:~2%"
ECHO.EulaComplete="1"
ECHO.winntupgrade="no"
ECHO.win9xupgrade="no"
ECHO.[regionalsettings]
SWREG QUERY "hklm\system\currentcontrolset\control\nls\locale" /v "(default)" | sed "/.*	/!d;s///;s/.*/Language=&/"
ECHO.LanguageGroup=1
ECHO.[setupparams]
ECHO.DynamicUpdatesWorkingDir=%systemroot%\setupupd
ECHO.[unattended]
ECHO.unused=unused
ECHO.[userdata]
ECHO.productid=""
ECHO.productkey=""
ECHO.[OobeProxy]
ECHO.Enable=1
ECHO.Flags=1
ECHO.Autodiscovery_Flag=4
)


DEL /A/F/Q %BootDir%cmdcons\txtsetup.si_ MountedDevices.reg *.CFSY_  AddDriver0? >N_\%random% 2>&1


PEV -rtf %BootDir%cmdcons\VGA.SY_ >N_\%random% 2>&1 ||(
	REM CALL START NircmdB.exe INFOBOX "Contents of %%BootDir%%cmdcons are not in order.~n~nPlease disable your security programs before trying again" ""
	CALL START NircmdB.exe INFOBOX "%Line58%" ""
	RD /S/Q %BootDir%cmdcons
	GOTO AbortRC
	)>N_\%random% 2>&1



IF EXIST %BootDir%Boot.bak DEL /A/F %BootDir%Boot.bak >N_\%random% 2>&1

ATTRIB -H -R -S %BootDir%Boot.ini

COPY /Y %BootDir%Boot.ini %BootDir%Boot.bak >N_\%random% 2>&1

SET "bootsect=\nC:\\CMDCONS\\BOOTSECT.DAT=\x22Microsoft Windows Recovery Console\x22 \/cmdcons\nUnsupportedDebug=\x22do not select this\x22 \/debug"

SED G %BootDir%Boot.bak | SED -r "/cmdcons\\bootsect.dat|^$|^UnsupportedDebug=/Id; s/^\s*//; s/\s*$//" >BootIni00

SED "/^timeout=/Is/=.*/=2/; s/^\[operating systems\]$/&%bootsect%/I" BootIni00 >%BootDir%Boot.ini

DEL /A/F BootIni00 >N_\%random% 2>&1

ATTRIB +H +S +A +R %BootDir%Boot.ini

SET bootsect=

TYPE myNul.dat >RcRdy

TYPE %BootDir%Boot.ini >>CF-RC.txt

@ATTRIB +H +S +A +R %BootDir%cmdcons  /S /D

@IF EXIST f_system SWXCACLS %BootDir%cmdcons /DE:;A732/I /Q

TYPE myNul.dat >AbortC

:: NircmdB.exe QBOXCOMTOP "The Recovery Console was successfully installed.~n~nClick 'Yes' to continue scanning for malware~n~nClick 'No' to exit" "What's next ?" RETURNVAL 1 || GOTO :EOF
NircmdB.exe QBOXCOMTOP "%Line59%" "" FILLDELETE AbortC

IF NOT EXIST AbortC GOTO :EOF

IF EXIST Gateway FOR /F %%G IN ( Gateway ) DO @(
	START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k ROUTE.%cfExt%
	ROUTE ADD 0.0.0.0 MASK 0.0.0.0 %%G
	PEV -k NIRKMD.%cfext%
	)

COPY /Y CF-RC.txt \ >N_\%random% 2>&1

START /D%systemdrive%\ Notepad.exe %systemdrive%\CF-RC.txt

@GOTO :EOF




:AbortRC
:: NircmdB.exe QBOXCOMTOP "Click 'Yes' to continue scanning for malware~n~nClick 'No' to exit" "What's next ?" RETURNVAL 1 && ECHO.>AbortC

@ECHO.>AbortC

NircmdB.exe QBOXCOMTOP "%Line60%" "" FILLDELETE AbortC

IF NOT EXIST AbortC GOTO :EOF

@GOTO :EOF




