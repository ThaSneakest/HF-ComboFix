
@IF EXIST RcNo GOTO :EOF
@IF EXIST RcRdy GOTO :EOF
@IF NOT DEFINED LANG_CF GOTO :EOF
@IF NOT EXIST RcLink.dat GOTO :EOF

:: NIRCMD infobox "Boot Partition cannot be enumerated correctly" "" && GOTO AbortRC
IF NOT DEFINED BootDir NIRCMD infobox "%LINE52%" "" && GOTO :EOF

ECHO.
SET SPVER=
SET OSType=
IF EXIST RcVer00 (
	FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( RcVer00 ) DO @(
		IF /I "%%G" GEQ "512" IF /I "%%G" LSS "1024" SET "OSType=HOME"
		IF /I "%%G" LSS "512" IF /I "%%G" GEQ "256" SET "OSType=PRO"
		IF /I "%%H" GTR "1" ( SET "SPVER=2"
			) ELSE IF /I "%%H" EQU "1" ( SET "SPVER=1"
				) ELSE SET "SPVER=0"
				)
	DEL /A/F RcVer00
	)

IF DEFINED OSType GOTO AUTORC-B


SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\ProductOptions" /v ProductSuite >XPHOME00
GREP -isq "Personal" XPHOME00 &&SET "OSType=HOME"


IF NOT DEFINED OSType FOR %%G IN (
"%system%\gpedit.msc"
"%system%\cipher.exe"
"%system%\ntbackup.exe"
"%system%\rsop.msc"
"%system%\secpol.msc"
) DO IF EXIST %%G ECHO.X>>XPHOME00


IF EXIST XPHOME00 (
	GREP -c . XPHOME00 | GREP -sq "[012]" &&(
	GREP -sq "Product=.*Professional" "%system%\prodspec.ini" ||SET "OSType=HOME"
	)
) ELSE SET "OSType=HOME"

DEL /A/F/Q XPHOME00 >N_\%random% 2>&1



:: NIRCMD QBOXCOMTOP "Click 'Yes' if this is a WINDOWS XP *HOME EDITION* machine  " "XP Home Edition" RETURNVAL 1 &&SET OSType=PRO
ECHO.>XPHome
IF NOT DEFINED OSType NIRCMD QBOXCOMTOP "%Line71%" "" FILLDELETE XPHome

IF EXIST XPHome SET "OSType=HOME"
IF NOT DEFINED OSType SET "OSType=PRO"

SWREG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /V CSDVersion >CSDVersion00
GREP -isq "CSDVersion.*Service.Pack.[23]" CSDVersion00 && SET "SPVER=2"

IF NOT DEFINED SPVER GREP -isq "CSDVersion.*Service.Pack.1" CSDVersion00 && SET "SPVER=1"
IF NOT DEFINED SPVER SET "SPVER=0"

DEL /A/F CSDVersion00




:AUTORC-B
GREP -F %LANG_CF%%OSType%%SPVER% RcLink.dat >RcLink.dat00

GREP -Fsq / RcLink.dat00 || GOTO AUTORC-C

:: Nircmd infobox "You do not appear to be connected to the internet. Kindly connect before clicking 'OK' " ""
@PING -n 2 -w 500 photobucket.com >N_\%random% ||NIRCMD INFOBOX "%Line74%" ""


FOR /F "TOKENS=2" %%G in ( RcLink.dat00 ) DO @(
	CLS
	ECHO.
	ECHO.%Connecting to% http://download.microsoft.com . . .
	ECHO.
	ComboFix-Download -# -f --retry 2 -o %%~NXG -A "Mozilla/4.0" http://download.microsoft.com/download/%%G || DEL /A/F %%~NXG

	IF NOT EXIST %%~NXG (
		CLS
		ECHO.
	ComboFix-Download -# -f --retry 2 -o %%~NXG -A "Mozilla/4.0" -H "Host: download.microsoft.com" http://a767.ms.akamai.net/download/%%G || DEL /A/F %%~NXG
		)

	IF EXIST %%~NXG ECHO."%CD%\%%~NXG">InstallRC
	IF NOT EXIST %%~NXG START NIRCMD INFOBOX "%Line72%" ""
	REM NIRCMD INFOBOX "Failed to download required files. Aborting ... ~n~nShall continue scanning for malware" ""
	)


IF EXIST InstallRC (
	IF EXIST f_system SWXCACLS %BootDir%cmdcons /RESET /Q >N_\%random% 2>&1
	IF EXIST %BootDir%cmdcons RD /S/Q %BootDir%cmdcons >N_\%random% 2>&1
	IF EXIST AddDriver02 FOR /F "TOKENS=1,2* DELIMS=	" %%G IN ( AddDriver02 ) DO @(
		IF NOT EXIST %%~H.CFSY_ ComboFix-Download -# --retry 2 -o %%~H.CFSY_ --connect-timeout 10 -A "cfcurl/7.15.3 (i586-pc-mingw32msvc) libcurl/7.15.3 zlib/1.2.2" -H "Host: download.bleepingcomputer.com" http://208.43.120.24/sUBs/rc/%%~H.SY_ || DEL /A/F %%~H.CFSY_
		IF EXIST %%~H.CFSY_ (
			ECHO.%%G	%%H	%%I
			)>>txtsetup._if
			)
	IF EXIST IntelMatrix.dat (
		ComboFix-Download -# --retry 2 -o IntelMatrix.zip --connect-timeout 10 -A "cfcurl/7.15.3 (i586-pc-mingw32msvc) libcurl/7.15.3 zlib/1.2.2" -H "Host: download.bleepingcomputer.com" http://208.43.120.24/sUBs/rc/IntelMatrix.zip || DEL /A/F IntelMatrix.zip
		DEL /A/F IntelMatrix.dat >N_\%random% 2>&1
		)
	IF EXIST Nvidia.dat (
		ComboFix-Download -# --retry 2 -o nvidia.zip --connect-timeout 10 -A "cfcurl/7.15.3 (i586-pc-mingw32msvc) libcurl/7.15.3 zlib/1.2.2" -H "Host: download.bleepingcomputer.com" http://208.43.120.24/sUBs/rc/nvidia.zip || DEL /A/F nvidia.zip
		DEL /A/F nvidia.dat >N_\%random% 2>&1
		)
	IF EXIST Via.dat (
		ComboFix-Download -# --retry 2 -o via.zip --connect-timeout 10 -A "cfcurl/7.15.3 (i586-pc-mingw32msvc) libcurl/7.15.3 zlib/1.2.2" -H "Host: download.bleepingcomputer.com" http://208.43.120.24/sUBs/rc/via.zip || DEL /A/F via.zip
		DEL /A/F nvidia.dat >N_\%random% 2>&1
		)
	IF EXIST SiSscsi.dat (
		ComboFix-Download -# --retry 2 -o sisscsi.zip --connect-timeout 10 -A "cfcurl/7.15.3 (i586-pc-mingw32msvc) libcurl/7.15.3 zlib/1.2.2" -H "Host: download.bleepingcomputer.com" http://208.43.120.24/sUBs/rc/sisscsi.zip || DEL /A/F sisscsi.zip
		DEL /A/F SiSscsi.dat >N_\%random% 2>&1
		)
	)


DEL /A/F/Q RcLink.dat* >N_\%random% 2>&1
IF EXIST InstallRC CALL Install-RC.cmd
GOTO :EOF

ComboFix-Download -# -f --retry 2 -o RCDrivers.exe -A "Mozilla/4.0" http://download.bleepingcomputer.com/sUBs/MiniFixes/RCDrivers.exe || DEL /A/F RCDrivers.exe


:AUTORC-C
:: START NIRCMD INFOBOX "Internal error! Failed to enumerate download path.  ~n~nAborting ... Shall continue scanning for malware" ""
START NIRCMD INFOBOX "%Line73%" ""
GOTO :EOF



