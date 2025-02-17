
@SWREG QUERY "HKLM\SOFTWARE\swearware\Backup\Winsock2" >N_\%random% 2>&1 ||(
	SWREG ACL "HKLM\SOFTWARE\swearware" /RESET
	SWREG COPY "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2" "HKLM\SOFTWARE\swearware\Backup\Winsock2" /s
	)>N_\%random% 2>&1

@ECHO.%random%	-H "Host: download.bleepingcomputer.com" http://208.43.120.24/sUBs/>Mirrors00
REM @ECHO.%random%	-H "Host: www.infospyware.com" http://216.69.159.122/sUBs/>>Mirrors00
REM @ECHO.%random%	-H "Host: www.compendiate.net" http://69.6.236.82/sUBs/ComboFix.exe/>>Mirrors00
@SORT /M 65536 Mirrors00 /O Mirrors
@DEL /A/F Mirrors00


FOR /F "TOKENS=2 DELIMS=	" %%G IN ( Mirrors ) DO IF NOT EXIST version.txt (
	ComboFix-Download -s --connect-timeout 5 -A "cfcurl/7.15.3 (i586-pc-mingw32msvc) libcurl/7.15.3 zlib/1.2.2" %%Gversion.txt | GREP "^[0-9][0-9].*	[0-9]" >version.txt || DEL /A/F version.txt
	)>N_\%random% 2>&1
	
IF NOT EXIST version.txt (
	ComboFix-Download -s --connect-timeout 5 -A "cfcurl/7.15.3 (i586-pc-mingw32msvc) libcurl/7.15.3 zlib/1.2.2" -H "Host: www.compendiate.net" http://69.6.236.82/sUBs/ComboFix.exe/version.txt | GREP "^[0-9][0-9].*	[0-9]" >version.txt || DEL /A/F version.txt
	)>N_\%random% 2>&1
	
IF NOT EXIST version.txt GOTO :EOF

FOR /F "TOKENS=4" %%G IN ( Version.txt ) DO IF /I "%%G" GEQ "%VER_CF%" (
	REM Start NIRCMD infobox "--- WARNING !! ---~n~nA critical update is required.~n~nComboFix shall now update itself.~n~n--- WARNING !! ---" "Mandatory Update"
	START NIRCMD INFOBOX "%Line63%" ""
	DEL /A/F "%sfxname%" >N_\%random% 2>&1
	NIRCMD BEEP 2000 1000
	GOTO UpdateCFB
	)


@FOR /F %%G IN ( version.txt ) DO (
	IF /I "%%G" EQU "%VER_CF%" ECHO.%%G >LatestVer
	IF /I "%%G" LEQ "%VER_CF%" GOTO :EOF
	)

ECHO.>NoUpdateCF
:: NircmdB.exe QBOXCOMTOP "There's a newer version of ComboFix available.~n~nWould you like to update ComboFix?" "Update" RETURNVAL 1 && GOTO :EOF
NircmdB.exe QBOXCOMTOP "%Line62%" "" FILLDELETE NoUpdateCF
IF EXIST NoUpdateCF GOTO :EOF




:UpdateCFB
FOR /F "TOKENS=2 DELIMS=	" %%G IN ( Mirrors ) DO @(
	DEL /A/F version.txt ComboFix.exe >N_\%random% 2>&1
	CLS
	ECHO.
	ECHO.%Connecting to ComboFix servers% . . .
	ECHO.
	ComboFix-Download -s --connect-timeout 10 -A "cfcurl/7.15.3 (i586-pc-mingw32msvc) libcurl/7.15.3 zlib/1.2.2" %%Gversion.txt | GREP -s "^[0-9][0-9].*	[0-9]" >version.txt &&(
		ComboFix-Download -# -o ComboFix.exe --connect-timeout 10 -A "cfcurl/7.15.3 (i586-pc-mingw32msvc) libcurl/7.15.3 zlib/1.2.2" %%GComboFix.exe
		)
	IF EXIST ComboFix.exe @FOR %%H IN ( ComboFix.exe ) DO @FOR /F "TOKENS=2" %%I IN ( version.txt ) DO @IF [%%~ZH]==[%%I] GOTO UpdateCFC
		)

@IF NOT EXIST ComboFix.exe (
	DEL /A/F version.txt >N_\%random% 2>&1
	CLS
	ECHO.
	ECHO.%Connecting to ComboFix servers% . . .
	ECHO.
	ComboFix-Download -s --connect-timeout 10 -A "cfcurl/7.15.3 (i586-pc-mingw32msvc) libcurl/7.15.3 zlib/1.2.2" -H "Host: www.compendiate.net" http://69.6.236.82/sUBs/ComboFix.exe/version.txt | GREP -s "^[0-9][0-9].*	[0-9]" >version.txt &&(
		ComboFix-Download -# -o ComboFix.exe --connect-timeout 10 -A "cfcurl/7.15.3 (i586-pc-mingw32msvc) libcurl/7.15.3 zlib/1.2.2" -H "Host: www.compendiate.net" http://69.6.236.82/sUBs/ComboFix.exe/IEXPLORE.EXE
		)
	IF EXIST ComboFix.exe @FOR %%H IN ( ComboFix.exe ) DO @FOR /F "TOKENS=2" %%I IN ( version.txt ) DO @IF [%%~ZH]==[%%I] GOTO UpdateCFC
		)
		
@DEL /A/F Mirrors version.txt ComboFix.exe >N_\%random% 2>&1
:: @Start NIRCMD infobox "Failed to download updated copy.~n~nWill continue with existing copy" "Failed Download"
@START NIRCMD INFOBOX "%LINE64%% ""
@GOTO :EOF



:UpdateCFC
@NIRCMD killprocess NIRCMD
@CLS
@DEL /A/F "%sfxname%" >N_\%random% 2>&1
@MOVE /Y ComboFix.exe "%sfxname%" >N_\%random% 2>&1
@ATTRIB +r "%sfxname%" >N_\%random% 2>&1
@REM Start NIRCMD infobox "ComboFix shall now restart" "Updated"
@START NIRCMD INFOBOX "%LINE65%" ""
@PEV WAIT 6000
@NIRCMD KILLPROCESS NIRCMD
@START ComboFix %sfxcmd%
@EXIT



