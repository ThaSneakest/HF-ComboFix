
:SNAPSHOT
@SET SnapShot=

SWREG QUERY HKLM\Software\Swearware /v SnapShot >temp00
SED "/.*	/!d; s///" temp00 >temp01
FOR /F "TOKENS=*" %%G IN ( temp01 ) DO @IF EXIST "%%~G.dat" (
	GREP -Esq " {14}.:\\." "%%~G.dat" || DEL /A/F "%%~G.dat"
	IF EXIST "%%~G.dat" SET "SnapShot=%%~G"
	)
DEL /A/F/Q temp0?


@(
ECHO.%systemroot%\PEV.exe
ECHO.%systemroot%\SWXCACLS.exe
ECHO.%systemroot%\SWREG.exe
ECHO.%systemroot%\SWSC.exe
ECHO.%systemroot%\zip.exe
ECHO.%systemroot%\sed.exe
ECHO.%systemroot%\grep.exe
ECHO.%systemroot%\Nircmd.exe
ECHO.%systemroot%\MBR.exe
ECHO.%systemroot%\bootstat.dat
ECHO.%system%\SWSC.exe
ECHO.%systemroot%\erdnt\Hiv-backup\ERDNT.EXE
ECHO.%systemroot%\erdnt\subs\ERDNT.EXE
ECHO.%systemroot%\erdnt\cache\
IF EXIST W6432.dat ECHO.%systemroot%\erdnt\cache86\
IF EXIST W6432.dat ECHO.%systemroot%\erdnt\cache64\
)>SnapWhite


IF EXIST Vista.krl (
ECHO.%system%\config\systemprofile\ntuser.dat
ECHO.%systemroot%\ServiceProfiles\NetworkService\ntuser.dat
ECHO.%systemroot%\ServiceProfiles\LocalService\ntuser.dat
ECHO.%systemroot%\ServiceProfiles\LocalService\AppData\Local\Temp\Temporary Internet Files\Content.IE5\index.dat
ECHO.%systemroot%\ServiceProfiles\LocalService\AppData\Local\Temp\Temporary Internet Files\Content.IE5\index.dat
ECHO.%systemroot%\ServiceProfiles\LocalService\AppData\Local\Temp\History\History.IE5\index.dat
ECHO.%systemroot%\ServiceProfiles\LocalService\AppData\Local\Temp\History\History.IE5\index.dat
ECHO.%systemroot%\ServiceProfiles\LocalService\AppData\Local\Temp\Cookies\index.dat
ECHO.%systemroot%\ServiceProfiles\LocalService\AppData\Local\Temp\Cookies\index.dat
ECHO.%systemroot%\ServiceProfiles\LocalService\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\index.dat
ECHO.%systemroot%\ServiceProfiles\LocalService\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\index.dat
)>>SnapWhite


IF EXIST W6432.dat IF EXIST x64snapshot.00.dat (
	TYPE x64snapshot.00.dat snapshot.00.dat | SORT /M 65536 /R /O snapshot.00.dat.tmp
	IF EXIST snapshot.00.dat.tmp SED -r "s/%sysnative:\=\\%/%sysdir:\=\\%/Ig"  snapshot.00.dat.tmp >  snapshot.00.dat
	DEL x64snapshot.00.dat  snapshot.00.dat.tmp
	)

GREP -UFivf SnapWhite SnapShot.00.dat >temp00
SET "Hiv-backup=%systemroot:\=\\%\\erdnt\\(hiv-backup|sUBs)\\users\\000000[01][0-9]\\[^\\]*\.dat"
GREP -Evi "%Hiv-Backup%$|%system:\=\\%\\%kmd%$" temp00 >SnapShot.01.dat
SED "/./!d" SnapShot.01.dat > SnapShot.02.dat

PEV -rtf -c:##c# .\SnapShot.00.dat -output:temp01
SED "y/ :/_./; s/.*/@SET \x22DTime=&\x22/" temp01 >DTime.bat
CALL DTime.bat
@SETLOCAL

DEL /A/F/Q temp0? SnapWhite
SET Hiv-backup=



IF DEFINED SnapShot (
	SED -r "/%systemroot:\=\\%/I!d; s/.*:\\//; /.{127}./s/.*(.{127})$/\1/" ComboFix.txt >SnapRef.dat
	ECHO.::::>>SnapRef.dat
	FINDSTR -EVILG:SnapRef.dat SnapShot.02.dat >temp00
	GREP -Fvixf "%SnapShot%.dat" temp00 >SnapShot.dat ) && (
		CALL :WUpdate
		ECHO."(((((((((((((((((((((((((((((   %SnapShot:~10%   )))))))))))))))))))))))))))))))))))))))))"| SED "s/\x22//g"
		ECHO.
		GREP -Fivf MSnew.dat SnapShot.dat >temp02
		SED "/:\\/!d; s/^/+ /" temp02 >temp03
		ECHO.::::>temp04
		SED "s/.*	//" SnapShot.dat >>temp04
		GREP -Fif temp04 "%SnapShot%.dat" >temp05
		SED "/:\\/!d; s/^/- /" temp05 >>temp03
		SORT /M 65536 /R /+64 temp03
		ECHO.
		DEL /A/F/Q SnapShot.dat temp0?
		)>>ComboFix.txt

GREP -Ec "^[+-] [0-9]" ComboFix.txt | GREP -Evq "^[1-4][0-9]$|^.$" && TYPE myNul.dat >NewSnap.dat
IF NOT DEFINED SnapShot TYPE myNul.dat >CreateSnap
IF EXIST CreateSnap SET "SnapShot=%systemdrive%\qoobox\SnapShot@%Dtime%"


IF EXIST CreateSnap (
	SWREG ADD HKLM\software\swearware /v SnapShot /d "%SnapShot%"
	MOVE /Y SnapShot.01.dat "%SnapShot%.dat"
	DEL /A/F CreateSnap
	)



IF EXIST NewSnap.dat (
	REM @ECHO.-- Snapshot reset to current date -->>ComboFix.txt
	@ECHO.%Line49%>>ComboFix.txt
	ECHO.>>ComboFix.txt
	MOVE /Y SnapShot.01.dat "%systemdrive%\qoobox\SnapShot_%DTime%.dat"
	SWREG ADD HKLM\software\swearware /v SnapShot /d "%systemdrive%\qoobox\SnapShot_%DTime%"
	DEL /A/F NewSnap.dat
	)

@GOTO :EOF



:WUpdate
@DEL /A/F/Q temp0?
@PEV -rtd -dcg1M AND "%systemroot%\$hf_mig$\kb*" OR "%systemroot%\$Nt*" OR "%systemroot%\$MS*" -output:MScreate.dat
@PEV -rtd -dmg1M AND "%systemroot%\$hf_mig$\kb*" OR "%systemroot%\$Nt*" OR "%systemroot%\$MS*" -output:MSMod.dat
@GREP -Fif MScreate.dat MSMod.dat >temp04
@SED -r "s/%systemroot:\=\\%\\//I" temp04 >MSnew.dat
@ECHO.%systemroot%\SoftwareDistribution\Download>>MSnew.dat
@DEL /A/F/Q temp0? MScreate.dat MSMod.dat
@GOTO :EOF

