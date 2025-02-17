
@SETLOCAL
@CD /D "%~dp0"
@IF EXIST F3m.mrk EXIT
@TYPE myNul.dat >F3m.mrk
@CALL VerCF.bat
@CALL setpath.bat >N_\%random% 2>&1
@CALL Lang.bat >N_\%random% 2>&1

@IF EXIST CHCP.bat CALL CHCP.bat >N_\%random% 2>&1
@IF NOT EXIST debug???.dat ECHO OFF
@IF NOT DEFINED ControlSet CALL CCS.bat
@PROMPT $
COLOR 17


@TITLE ComboFix - Find3M
@IF EXIST Combobatch.bat DEL /A/F Combobatch.bat
@IF EXIST C.bat DEL /A/F C.bat
@IF EXIST %SystemDrive%\bug.txt DEL /A/F %SystemDrive%\bug.txt
@IF EXIST desktop.ini DEL /A/F desktop.ini


CLS
:: @ECHO.Preparing Log Report.
:: @ECHO.Do not run any programs until ComboFix has finished
@ECHO.
@ECHO.%Line20%
@ECHO.
@ECHO.%Line21%
@ECHO.


@(
IF EXIST "%system%\CF_init.exe" DEL /A/F "%system%\CF_init.exe"
IF EXIST "%SystemRoot%\erdnt\CFUNDO.dat" DEL /A/F "%SystemRoot%\erdnt\CFUNDO.dat"
IF EXIST %SystemDrive%\32788R22FWJFW\ RD /S/Q %SystemDrive%\32788R22FWJFW
)>N_\%random% 2>&1

:: NIRCMD emptybin
"%KMD%" /c RD /S/Q %SystemDrive%\$RECYCLE.bin %SystemDrive%\RECYCLER %SystemDrive%\RECYCLED >N_\%random% 2>&1



SET "Catchme=Catchme.tmp"
COPY /Y/B catchme.%cfExt% %Catchme% >N_\%random% 2>&1
IF NOT EXIST W6432.dat START HIDEC.%cfExt% %KMD% /c katch.cmd


@SET "Qrntn=%SystemDrive%\Qoobox\Quarantine"

@SWREG QUERY HKLM\Software\Swearware /v limitblankpassworduse >temp00
SED "/.*	/!d;s///" temp00 >temp01
@FOR /F "TOKENS=*" %%G IN ( temp01 ) DO @SWREG ADD "HKLM\system\currentcontrolset\control\lsa" /v limitblankpassworduse /t reg_dword /d "%%G"
DEL /A/F temp0? >N_\%random% 2>&1
@NIRCMD win close class #32770


IF EXIST embedded.key FOR /F "TOKENS=*" %%G IN ( embedded.key ) DO @(
	SWREG ACL "%%G" /GE:F /Q
	SWREG RESTORE "%%G" cfdummy /f
	SWREG DELETE "%%G"
	)>N_\%random% 2>&1


@SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_BEEP" >L_Beep00
@SED "/\\xx_[^\\]*_xx$/!d; s/.*/\n[-&]/" L_Beep00 >>CregC.dat
@IF NOT EXIST Vista.krl CALL RKEY.cmd >N_\%random% 2>&1
@REGT /S cregC.dat >N_\%random% 2>&1
@REGT /S creg.dat >N_\%random% 2>&1
	
@IF NOT EXIST Vista.krl CALL RKEY.cmd RKEYB >N_\%random% 2>&1



IF EXIST %SystemDrive%\QooBox\LogA (
	PEV -rtf %SystemDrive%\QooBox\* -output:temp00
	FINDSTR -VIR "ComboFix.*\.txt snapshot.*\.dat CFScript_" temp00 >temp01
	FOR /F "TOKENS=*" %%G IN ( temp01 ) DO @DEL /A/F "%%~G"
	DEL /A/F/Q temp0?
	)>N_\%random% 2>&1



SWREG QUERY "HKCU\Control Panel\Desktop" /v Wallpaper >wallPaper00
SWREG QUERY "HKCU\Software\Microsoft\Internet Explorer\Desktop\General" /v Wallpaper  >>wallPaper00
SED "/.*	/!d;s///" wallPaper00 >wallPaper01
FOR /F "TOKENS=*" %%G IN ( wallPaper01 ) DO @CALL ECHO.%%G>>WallPaper03
IF EXIST WallPaper03 FOR /F "TOKENS=*" %%G IN ( wallPaper03 ) DO @IF NOT EXIST "%%G" IF NOT EXIST wallPaper02 CALL :WallPaper
DEL /A/F/Q wallPaper0? >N_\%random% 2>&1
NIRCMD exec hide RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

PEV VOLUME >Drives00
SED "s/\r/\n/g; s/:\\//" Drives00 >Drives.dat
FINDSTR -IV "%systemdrive:~,1%" Drives.dat >DrivesB.dat
FOR /F "TOKENS=*" %%G IN ( DrivesB.dat ) DO @IF EXIST "%%~G:\Qoobox\" (
	SWXCACLS "\\.\%%G:\QooBox\*" /P /GE:F /S /Q
	XCOPY.exe /S/C/I/Q/G/H/R/Y "%%~G:\Qoobox" "%SystemDrive%\Qoobox"
	@FOR /F "TOKENS=*" %%I IN ( cfrun ) DO @PEV -tx50000 -tx50000 -tf "%%~G:\Qoobox\*" | zip.exe -!@qDS "\QooBox\Quarantine\%%G\av%%I.zip"
	RD /S /Q "%%G:\Qoobox"
	)>N_\%random% 2>&1
DEL /A/F Drives00

IF EXIST Drives.dat (
	FOR /F %%G IN ( Drives.dat ) DO @PEV -rtd %%G:\* >>AllDrivesFolders
	FOR /F "TOKENS=*" %%G IN ( AllDrivesFolders ) DO @ATTRIB -S -H "%%~G"
	IF EXIST %SystemDrive%\cmdcons\ ATTRIB +H +R +S +A %SystemDrive%\cmdcons
	FOR /F %%G IN ( Drives.dat ) DO @IF EXIST "%%G:\System Volume Information\" ATTRIB +H +S "%%G:\System Volume Information"
	DEL /A/F Drives.dat
	)>N_\%random% 2>&1



IF EXIST AWF FOR /F "TOKENS=*" %%G IN ( AWF ) DO @IF EXIST "%%~DPG" PEV "%%~DPG*" >N_\%random% ||(
	RD "%%~DPG"
	IF EXIST "%%~DPG" RD /S/Q "%%~DPG"
	)>N_\%random% 2>&1
	

IF EXIST RenV2Move.dat (
	FOR /F "TOKENS=1* DELIMS=	" %%G IN ( RenV2Move.dat ) DO @IF EXIST "%%~G" (
		SWXCACLS "%%~G" /OA
		SWXCACLS "%%~G" /GA:F /Q
		MOVE /Y "%%~G" "%%~H"
		IF NOT EXIST "%%~G" ECHO."%%~G" ---^>"%%~H">>RenVMoved.dat
		) )>N_\%random% 2>&1



@SED q whitedir.dat >temp01

FOR /F %%G in ( temp01 ) DO @(
	PEV -rtf "%%~G\*" -output:temp02
	FINDSTR -vi "backup.*\.zip" temp02 >temp03
	FOR /F "TOKENS=*" %%H in ( temp03 ) DO @DEL /A/F "%%~H"
	DIR /A/S/B "%%~G\*" >temp04
	GREP -Fq \ temp04 || RD /S/Q "%%G"
	DEL /A/F TEMP02 TEMP03 TEMP04
	)>N_\%random% 2>&1
DEL /A/F/Q temp0? N_\* >N_\%random% 2>&1



@NIRCMD win close class #32770
@HIDEC IPCONFIG /FLUSHDNS


IF NOT EXIST Vista.krl START NIRCMD regsvr reg %system%\shimgvw.dll
IF NOT EXIST W6432.dat (
	START NIRCMD regsvr reg %system%\urlmon.dll
	START NIRCMD regsvr reg %system%\JScript.dll
	)

IF DEFINED Desktop IF EXIST "%appdata%\TmpRecentIcons\*.lnk" (
	COPY /Y "%appdata%\TmpRecentIcons\*.lnk" "%Desktop%\"
	RD "%appdata%\TmpRecentIcons"
	IF EXIST "%appdata%\TmpRecentIcons" RD /S/Q "%appdata%\TmpRecentIcons"
	)>N_\%random% 2>&1


REM 	IF EXIST W6432.dat (
REM 		NIRCMDC exec hide PEV.exe -c:##c . #m#b#u              #f# -s+1500 "%SystemRoot%\*" -preg"\.(bat|cmd|com|dll|pif|scr|sys|vbs|exe|bin|wsf|vbe|dat|drv|ms[ip])$" -skip"%systemroot%\winsxs" -skip"%sysdir%" >snapshot.00.dat
REM 		NIRCMDC exec hide PEV.exe -c:##c . #m#b#u              #f# -s+1500 "%Sysnative%\*" -preg"\.(bat|cmd|com|dll|pif|scr|sys|vbs|exe|bin|wsf|vbe|dat|drv|ms[ip])$" >x64snapshot.00.dat
REM 	) ELSE NIRCMDC exec hide PEV.exe -sacdate -fs32 -c:##c . #m#b#u              #f# -s+1500 "%SystemRoot%\*" -preg"\.(bat|cmd|com|dll|pif|scr|sys|vbs|exe|bin|wsf|vbe|dat|drv|ms[ip])$" >snapshot.00.dat


SED ":a;$!N;s/\n/|/;ta;s/.*/(&)/" system_ini.dat >temp00
FOR /F "TOKENS=*" %%G IN ( temp00 ) DO @set "_sysIni_=%%G"

IF EXIST "%SystemRoot%\system.ini" @(
	SED "/^$/d;s/^\[/\n&/;" "%SystemRoot%\system.ini" | SED -r "/^\[%_sysIni_%]/I,/^$/d;/^$/d" >system.ini
	DEL /A/F "%SystemRoot%\system.ini"
	MOVE /Y system.ini %SystemRoot%\
	)>N_\%random% 2>&1

Set _sysIni_=
DEL /A/F/Q temp0? N_\* >N_\%random% 2>&1


PEV -rtf -s=0 "%ProgFiles%\internet explorer\iexplore.exe" >N_\%random% && DEL /A/F "%ProgFiles%\internet explorer\iexplore.exe" >N_\%random% 2>&1
:: allow WFP to restore
GREP -isq "msvcrl\.dll\|msdom2\.dll" "%ProgFiles%\internet explorer\iexplore.exe" &&(
	PEV -k iexplore.exe
	PEV -tx50000 -sd:mdate -tf "%SystemRoot%\iexplore.exe" -output:temp00
	FINDSTR -MVIF:temp00 "msvcrl\.dll msdom2\.dll" >ie-found.dat &&(
		SED $!d ie-found.dat >temp01
		FOR /F "TOKENS=*" %%G IN ( temp01 ) DO COPY /Y /B "%%~G" "%ProgFiles%\internet explorer\iexplore.exe"
		)||(
		ECHO."%ProgFiles%\internet explorer\iexplore.exe ... %is infected%"
		ECHO.
		)>>ComboFix.txt
	DEL /A/F/Q temp0?
	)>N_\%random% 2>&1



GREP -Fisq %SystemDrive%\desktop_.ini drev.dat && ECHO.www.ctv163.com >>FKMGen.dat

IF EXIST FKMGen.dat IF EXIST %system%\drivers\mqdrc.sys @(
	GREP -Fiv "www.9344.cn" FKMGen.dat >FKMGenB.dat
	GREP -sq . FKMGenB.dat &&(
		MOVE /Y FKMGenB.dat FKMGen.dat >N_\%random%
		CALL FKMGen.cmd
		DEL /A/F FKMGen.cmd
			)||(
		DEL /A/F FKMGenB.dat >N_\%random% 2>&1
		))


@IF EXIST %system%\drivers\combo*fix.sys DEL /A/F/Q %system%\drivers\combo*fix.sys


@REGT /S region.dat
@START NircmdB.exe sysrefresh intl



@(
ECHO.%Fail2Delete%
ECHO.%SystemDrive%\Deckard\
ECHO.\Quarantine\
)>NoX2del


IF EXIST rootkit.dat (
	SED -r "s/^(.):(.*)$/&	%SystemDrive%\\Qoobox\\Quarantine\\\1\2.vir/" "rootkit.dat" >temp00
	FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp00 ) DO @IF EXIST "%%~H" (
		ECHO."%%~G">>drev.dat
		) ELSE IF EXIST "%%~DPH_%%~NG_%%~XG.zip" ECHO."%%~G">>drev.dat
	DEL /A/F temp00
	)


@IF EXIST RenVDel.dat SORT /M 65536 RenVDel.dat /O temp00 && SED -r "$!N; /^(.*)\n\1$/I!P; D" temp00 >>NoX2del

IF EXIST drev_*.dat GREP -Fsq \ drev_*.dat || DEL /A/F/Q drev_*.dat

IF EXIST drev.dat GREP -Fq \ drev.dat &&(
	GREP -Fivsf NoX2del drev.dat >temp00
	ECHO.::::>>temp00
	PEV -tx50000 -tf -t!o -files:temp00 -output:temp01
	FOR /F "TOKENS=*" %%G IN ( temp01 ) DO @%KMD% /D /C MoveIt.bat "%%~G"
	DEL /A/F temp00 temp01
	)>N_\%random% 2>&1


:: ECHO.(((((((((((((((((((((((((((((((((((((((   Other Deletions   )))))))))))))))))))))))))))))))))))))))))))))))))>dollar_log.dat
@ECHO.%Line41%>dollar_log.dat
ECHO.>>dollar_log.dat


IF EXIST PatchedBrowsers.dat (
	REM ECHO.Some 3rd party browsers were infected and had to be removed. Do not be alarmed. >>dollar_log.dat
	ECHO.%Line101% >>dollar_log.dat
	ECHO.>>dollar_log.dat
	DEL PatchedBrowsers.dat
	)

IF EXIST Replicator.dat GREP -sq . Replicator.dat && (
	FOR /F "TOKENS=1*" %%G in ( Replicator.dat ) DO @IF EXIST "%%~H" ( ECHO."%%~H" .. failed to delete ) ELSE ECHO."%%~H"
	)>Replicator.Log


IF EXIST drevF.dat TYPE drevF.dat >>drev.dat
IF EXIST x64drevF.dat TYPE x64drevF.dat >>drev.dat
IF EXIST x64drev.dat TYPE x64drev.dat >>drev.dat

IF EXIST Replicator.log IF EXIST drev.dat (
	SED -r "s/\x22//g" drev.dat | GREP -Fivxf Replicator.log > drev.tmp
	MOVE /Y drev.tmp drev.dat
	)>N_\%random% 2>&1

IF EXIST drev.dat (
	ECHO.
	SORT /M 65536 drev.dat | SED -r "/:\\Deckard\\|\\Quarantine\\/Id; s/\x22//g" | SED -r -n "$!N; /^(.*)\n\1$/I!P; D"
	)>>dollar_log.dat

IF EXIST drev_*.dat (
	ECHO.
	ECHO.---- %Previous Run% -------
	ECHO.
	TYPE drev_*.dat| SORT /M 65536 | SED -r "/:\\Deckard\\|\\Quarantine\\/Id; s/\x22//g" | SED -r -n "$!N; /^(.*)\n\1$/I!P; D"
	)>>dollar_log.dat 2>N_\%random%

ECHO.>>dollar_log.dat


IF EXIST Replicator.log (
	ECHO.----- %File Replicators% -----
	ECHO.
	SORT /M 65536 Replicator.log /O temp00
	SED -r "s/\x22//g" temp00 | SED -r -n "$!N; /^(.*)\n\1$/I!P; D"
	ECHO.
	)>>dollar_log.dat

IF EXIST RenVMoved.dat (
	ECHO.[code] ^<pre^>
	SED "/:\\/!d; s/\x22//g" RenVMoved.dat
	ECHO.^</pre^> [/code]
	ECHO.
	)>>dollar_log.dat


IF EXIST BitsPath Grep -sq . BitsPath &&(
	ECHO.----- BITS: %Possible infected sites% -----
	ECHO.
	SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" BitsPath
	)>>dollar_log.dat


IF EXIST ND.mov FOR /F "TOKENS=2,3 DELIMS=	" %%G IN ( ND.mov ) DO @FC "%%~G" "%%~H" >N_\%random% 2>&1 &&CALL :ND.mov_sub "%%~G"	"%%~H" >N_\%random% 2>&1
IF EXIST ndis_log.dat TYPE ndis_log.dat >>dollar_log.dat

IF EXIST "\QooBox\32788R22FWJFW\" (
	PEV -c##f#b#d#i#k#g#e#j# "\QooBox\32788R22FWJFW\*" | SED -r "/\t-+$/!d; s///" >Qb327
	FOR /F "TOKENS=*" %%G IN ( Qb327 ) DO @FC "%%G" "%system%\drivers\%%~NXG" ||(
		MOVE /Y "%%G" "\QooBox\Quarantine\%system::=%\Drivers\%%~NXG.vir"
		CALL :HDCntrlB "%system%\drivers\%%~NXG" "Kitty had a snack :p"
		)
	DEL Qb327
	RD /S/Q "\QooBox\32788R22FWJFW"
	)>N_\%random% 2>&1

ECHO.>>dollar_log.dat


IF NOT EXIST Whistler.dat IF EXIST %systemdrive%\Qoobox\LastRun\Whistler.old MOVE /Y %systemdrive%\Qoobox\LastRun\Whistler.old Whistler.dat >N_\%random% 2>&1
IF EXIST %systemdrive%\Qoobox\LastRun\TDL4mbrDone.old (
	ECHO.\\.\PhysicalDrive0 - Bootkit TDL4 was found and disinfected>>Whistler.dat
	ECHO.>>Whistler.dat
	)>N_\%random% 2>&1

IF EXIST Whistler.dat TYPE Whistler.dat >>dollar_log.dat
IF EXIST Cidox.dat TYPE Cidox.dat >>dollar_log.dat

IF EXIST Poweliks.dat GREP -sq ... Poweliks.dat && FOR /F "TOKENS=1* DELIMS=	" %%G IN ( Poweliks.dat ) DO @(
	ECHO.CLSID=%%~G - infected with Poweliks and removed.>>dollar_log.dat
	GREP -Fisq "73e709ea-5d93-4b2e-bbb0-99b7938da9e4" Poweliks.dat ||(
		ECHO.You should verify if current CLSID data is correct: >>dollar_log.dat
		IF EXIST W6432.dat (
			REG.EXE QUERY "HKCR\CLSID\%%~G" /s  >>dollar_log.dat
		) ELSE SWREG QUERY "HKCR\CLSID\%%~G" /s | SED "1, 3d;" >>dollar_log.dat
		)
	ECHO.>>dollar_log.dat
	)>N_\%random% 2>&1
	

Grep -Fisq :\ Fmove &&(
	ECHO.--------------- FMove ---------------
	ECHO.
	FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( Fmove ) DO @IF NOT EXIST "%%~G" @ECHO."%%~G" --^^^> "%%~H"| SED "s/\x22//g"
	ECHO.
	)>>dollar_log.dat

IF EXIST FCopy (
	ECHO.--------------- FCopy ---------------
	ECHO.
	FOR /F "TOKENS=1,2,3 DELIMS=	" %%G IN ( FCopy ) DO @IF NOT EXIST "%%~I" @ECHO."%%~G" --^^^> "%%~H"| SED "s/\x22//g;"
	ECHO.
	)>>dollar_log.dat

IF EXIST SCopy (
	ECHO.--------------- SCopy ---------------
	ECHO.
	FOR /F "TOKENS=1,2,3 DELIMS=	" %%G IN ( SCopy ) DO @IF NOT EXIST "%%~I" @ECHO."%%~G" --^^^> "%%~H"| SED "s/\x22//g; s/.*_restore[^\\]*//I"
	ECHO.
	)>>dollar_log.dat


IF EXIST MuleZips (
	ECHO.-------- P2P Worm Cache  --------
	ECHO.
	REM ECHO.These were found but they are too many and shall take too long to quarantine. 
	REM ECHO.Recommend that you manually delete the folder.
	ECHO.%Line89%
	ECHO.%Line100%
	ECHO.
	TYPE MuleZips
	ECHO.
	)>>dollar_log.dat
	


:Log
GREP -Fsq \ SvcTarget.dat && SED -r "/^$/d; s/\x22//g; s/^\./&\n/ ;$G;$G" SvcTarget.dat >>dollar_log.dat
GREP -Fsq \ dollar_log.dat || DEL /A/F dollar_log.dat

for %%G in (
MBRecord
l2mlog.dat
dollar_log.dat
V1king_log.dat
) DO @IF EXIST "%%~G" TYPE "%%~G" >>ComboFix.txt



@REGT /S region.dat


:: @PEV -rtf -md5%ChkSum% .\md5sum.pif >N_\%random% || CALL Kollect.bat List-C.bat ChkSum_Create.cmd
:: @PEV -rtf -c:##5#b#f# .\* and { Find3M.bat or C.bat or Create.cmd or FD-SV.cmd or GetHive.cmd or whitedir.dat or whitedirCreated.dat or notifykeys.dat } -output:mdCheck00.dat
:: @GREP -vs "^!MD5:" mdCheck00.dat | GREP -vf md5sum.pif >mdCheck01.dat &&CALL Kollect.bat Create.cmd
:: @DEL /A/Q mdCheck0?.dat

CALL Create.cmd >N_\%random% 2>&1
DEL /A/F Create.cmd


IF EXIST "%system%\mswsock.dll" FINDSTR -mi "Borland" "%system%\mswsock.dll" >N_\%random% 2>&1 &&@(
	ECHO.%system%\mswsock.dll ... %is infected% !!
	ECHO.
	)>>ComboFix.txt


IF EXIST user32.dat (TYPE user32.dat & ECHO.)>>ComboFix.txt
IF EXIST svchostX.dat (TYPE svchostX.dat & ECHO.)>>ComboFix.txt
IF EXIST basesrv.dat (TYPE basesrv.dat & ECHO.)>>ComboFix.txt
IF EXIST BankpatchB (TYPE BankpatchB & ECHO.)>>ComboFix.txt



IF EXIST RenV* (
	PEV -tx50000 -tf "%ProgFiles%\* .exe" -output:temp00
	PEV -tx50000 -tf "%SystemRoot%\* .exe" >>temp00
	GREP -Fs :\ temp00 >RenV.dat &&(
		ECHO.[code]^<pre^>
		GREP -Fs :\ temp00
		ECHO.^</pre^>[/code]
		)>>ComboFix.txt || DEL RenV.dat
	DEL /A/F/Q temp0?
	)>N_\%random% 2>&1



IF EXIST Beep_sys.dat GREP -Fsq \ Beep_sys.dat &&@(
	ECHO.%Files Infected - Patched%
	TYPE Beep_sys.dat
	ECHO.
	)>>ComboFix.txt


@ECHO.>>ComboFix.txt


ECHO.((((((((((((((((((((((((((((((((((((((((((((   Look   )))))))))))))))))))))))))))))))))))))))))))))))))))))))))>Look.dat
ECHO.>>Look.dat

IF EXIST FileLook.cfscript PEV -files:FileLook.cfscript -tx50000 -tf -c:##n--- #f ---#nCompany: #d#nFile Description: #e#nFile Version: #g#nProduct Name: #i#nCopyright: #j#nOriginal Filename: #k#nFile size: #u#nCreated time: #c#nModified time: #m#nMD5: #5#nSHA1: #1#n# >>Look.dat

IF EXIST DirLook.cfscript FOR /F "TOKENS=*" %%G IN ( DirLook.cfscript ) DO @(
	ECHO.---- Directory of "%%~G" ---->>Look.dat
	ECHO.>>Look.dat
	PEV -sacdate -tx50000 -tf -c:##c . #m#b#u#b#t#b#f# "%%~G\*" >>Look.dat
	ECHO.>>Look.dat
	)
	
@GREP -Fsq :\ Look.dat &&(
	TYPE Look.dat | SED "s/\x22//g"
	ECHO.
	DEL /A/F Look.dat
	)>>ComboFix.txt


@IF NOT EXIST Vista.krl IF EXIST SrPeek.cfscript FOR /F "TOKENS=*" %%G IN  ( SrPeek.cfscript ) DO CALL :SRPEEK %%G >N_\%random% 2>&1
	

@PEV -k * -preg"\\(thguard|ntvdm|teatimer[^\\]*|ad-watch[^\\]*|SZServer|StopZilla[^\\]*|userinit|procmon|txp1atform)\.exe$"
CALL FD-SV.cmd >N_\%random% 2>&1
DEL /A/F FD-SV.cmd

REM %KMD% /C CALL SnapShot.cmd >N_\%random% 2>&1
REM DEL /A/F SnapShot.cmd


SWREG QUERY "HKLM\software\microsoft\windows\currentversion\run" >temp00
SWREG QUERY  "hkcu\software\microsoft\windows\currentversion\run" >>temp00


SED -r "/:.*\.exe/I!d; /\.exe.*\.dll/Id; s/.*	//g; s/\x3b //g; s/\x22//g; s/\.exe .*/\.exe/I; s/\\[^\\]*$/\\bak&/I"  temp00 >Bak.dat
DEL /A/F/Q temp0? >N_\%random% 2>&1


IF EXIST Bak.dat (
	SED -n "G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/d; s/\n//; h; P" bak.dat >temp01
	FOR /F "TOKENS=*" %%G IN ( temp01 ) DO @IF EXIST "%%~G" ECHO.::>>Bak.dat
	GREP -Fq :: bak.dat &&( CALL AWF.cmd >N_\%random% 2>&1 )|| DEL /A/F bak.dat
	DEL /A/F temp01
	)
DEL /A/F AWF.cmd


@IF NOT EXIST bak.dat IF EXIST RenV.dat TYPE myNul.dat >bak.dat
@IF NOT EXIST bak.dat IF EXIST NoOrphans TYPE myNul.dat >bak.dat

@IF EXIST SysRst CALL SRestore.cmd >N_\%random% 2>&1
@DEL /A/F SRestore.cmd

IF EXIST W6432.dat (
	IF EXIST "%system%\cmd.exe" (
		"%system%\cmd.exe" /c CALL RegScan.cmd >N_\RegScan 2>&1
		) ELSE CALL RegScan.cmd >N_\RegScan 2>&1
	) ELSE CALL RegScan.cmd >N_\RegScan 2>&1
	
DEL /A/F RegScan.cmd
:: SWREG ACL "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components" /DE:F /Q
PEV.exe -k { explorer.exe or *.%cfExt% } and not %ComSpec%
:: START NIRCMD.EXE CMDWAIT 5000 EXEC HIDE SWREG.%cfext% ACL "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components" /RESET /Q

%KMD% /C SuppScan.cmd >N_\SuppScan 2>&1
IF NOT EXIST SuppScan_Completed (
	ECHO.Supplementary scan did not complete!
	ECHO.
	)>>ComboFix.txt
DEL /A/F SuppScan.cmd

IF EXIST Orphans.dat @(
	ECHO.- - - - %ORPHANS REMOVED% - - - -
	ECHO.
	SED "s/- $/- (no file)/" Orphans.dat
	ECHO.
	ECHO.
	)>>ComboFix.txt
	


CLS
:: @ECHO.Almost done . . This window will close in a short while
:: @ECHO.Please wait a few seconds for the report log to pop up
:: @ECHO.ComboFix's log shall be located at %SystemDrive%\COMBOFIX.TXT
@ECHO.
@ECHO.%Line25%
@ECHO.%Line26%
@ECHO.
@ECHO.%Line27%

PEV -tx50000 -tf -thaw -t!s "%Programs%\*.lnk" | GREP -c . | GREP -Esq .. &&FOR /F "TOKENS=*" %%G IN (' PEV VOLUME ') DO @ATTRIB -H %%G* /S /D >N_\%random% 2>&1

%KMD% /c GetHive.cmd >N_\%random% 2>&1
DEL /A/F GetHive.cmd

PEV -sa:cdate -tx50000 -tf -c:##c . #m#s #t  #f#  %SystemDrive%\Qoobox\Quarantine\* -output:\QooBox\ComboFix-quarantined-files.txt
IPCONFIG /FLUSHDNS  >N_\%random% 2>&1


IF EXIST w?.mac GOTO ENDKatch

IF EXIST W6432.dat GOTO ENDKatch

PV -d60000 -xa hidec.%cfExt% >Catchout 2>&1
PV -d15000 -xa %Catchme% >>Catchout 2>&1
@PEV -k %Catchme%
SET Catchme=

SED "/hidden files: /!d;s///" catchlog | SED ":a;$!N;s/\n/+/;ta; s/./set \/a catchsum=&/" >catchsum.bat
@ECHO.@ECHO.^>NULL >> catchsum.bat
CALL Catchsum.bat
DEL /A/F catchsum.bat

SETLOCAL
Set temp=%cd%

ECHO.>>ComboFix.txt
ECHO.**************************************************************************>>ComboFix.txt
SED -r "1,/disk not found .:\\|scanning hidden/!d;x;" catchlog >>ComboFix.txt

:: @ECHO.scanning hidden processes ... >>ComboFix.txt
@ECHO.%Line46% >>ComboFix.txt
@ECHO.>>ComboFix.txt
%KMD% /c Catchme -l N_\%random% -Iqpx >temp00 2>N_\%random%
SED "/]/!d;N" temp00 >>ComboFix.txt

:: @ECHO.scanning hidden autostart entries ...>>ComboFix.txt
@ECHO.%Line47% >>ComboFix.txt
@ECHO.>>ComboFix.txt
%KMD% /c Catchme -l N_\%random% -Iqnr >temp01
SED "/\\/,/^$/!d" temp01 >>ComboFix.txt

:: @ECHO.scanning hidden files ... >>ComboFix.txt
@ECHO.%Line48% >>ComboFix.txt
@ECHO.>>ComboFix.txt

GREP "^.:\\." catchlog >temp02 &&(
	ECHO.
	TYPE temp02
	ECHO.
	)>>ComboFix.txt

IF EXIST Catchout GREP -Esq "pv: Waiting completed|pv: No matching" Catchout &&@(
	ECHO.%scan completed successfully%
	ECHO.%hidden files%: %Catchsum%
	)>>ComboFix.txt

ECHO.>>ComboFix.txt
ECHO.**************************************************************************>>ComboFix.txt
@DEL /A/F/Q catchlog CatchOut temp0? N_\* >N_\%random% 2>&1
ENDLOCAL


:ENDKatch
IF EXIST mbr.txt GREP -Esq "MBR rootkit infection detected|user != kernel MBR !!!|TDL4 rootkit|^\\Driver\\Disk\[.* -> IRP_MJ_CREATE -> 0x|^\\Driver\\[^\\]* DriverStartIo -> 0x|\\Device\\.* -> .* device not found" mbr.txt &&(
	IF EXIST w?.mac ECHO.&ECHO.**************************************************************************
	ECHO.
	TYPE mbr.txt
	ECHO.
	ECHO.**************************************************************************
	)>>ComboFix.txt
	

DEL /A/F/Q mbr0? mbr.log mbr.txt mbr_orphan_files >N_\%random% 2>&1

SET Catchme=


@IF EXIST rawreg.dat TYPE rawreg.dat >>ComboFix.txt
@ECHO.>>ComboFix.txt


@IF EXIST RegLocks.txt (
	ECHO.--------------------- %LOCKED REGISTRY KEYS% ---------------------
	TYPE RegLocks.txt
	ECHO.
	)>>ComboFix.txt


@(
ECHO.%system%\rsaenh.dll
ECHO.%system%\WgaLogon.dll
ECHO.%system%\msprivs.dll
)>>ForeignWht


@(
PV -m winlogon.exe lsass.exe explorer.exe csrss.exe >temp00
FINDSTR -LIVG:ForeignWht temp00 >temp01
SED -R "/[4-9]\S{7}\s*\d* .:\\|^ +Module.*Path$|\.exe$/Id; /%system:\=\\%\\(xpsp2res|Normaliz|urlmon|odbcint)\.dll/Id; s/^  Module information for /\n- - - - - - - >/; s/.*(.:\\)/\1/" temp01 >temp02
SED -e "/./{H;$!d;}" -e "x;/:\\/!d;" temp02 >Modules
DEL /A/F/Q temp0?
)>N_\%random% 2>&1


GREP -Fsq \ Modules &&(
	ECHO.--------------------- %DLLs Loaded Under Running Processes% ---------------------
	TYPE modules
	ECHO.
	)>>ComboFix.txt




IF EXIST RBoot.dat (
ECHO.%SystemRoot%\explorer.exe
ECHO.%system%\smss.exe
ECHO.%system%\csrss.exe
ECHO.%system%\winlogon.exe
ECHO.%system%\services.exe
ECHO.%system%\lsass.exe
ECHO.%system%\svchost.exe
ECHO.%system%\dmadmin.exe
ECHO.%system%\cmd.exe
ECHO.%cd%\catchme.%cfExt%
ECHO.%system%\spoolsv.exe
ECHO.%system%\ctfmon.exe
ECHO.%system%\Fast.exe
ECHO.%system%\alg.exe
ECHO.%system%\wbem\wmiprvse.exe
ECHO.%system%\wuauclt.exe
IF EXIST vista.krl (
	ECHO.%system%\wininit.exe
	ECHO.%system%\lsm.exe
	ECHO.%system%\dwm.exe
	ECHO.%system%\SLsvc.exe
	ECHO.%system%\taskeng.exe
	ECHO.%system%\SearchIndexer.exe
	ECHO.%system%\mobsync.exe
	ECHO.%system%\SearchProtocolHost.exe
	ECHO.%system%\SearchFilterHost.exe
	)
SED -r "/REGEDIT4/,$!d;/:\\/!d;s/.*(.:\\.*)/\1/;s/\x22.*//;s/ \[.*//;s/].*//;s/ +$//;/(\\|sys|dll)$/Id" ComboFix.txt
)>>kiLLNotB



IF EXIST RBoot.dat (
ECHO.------------------------ %Other Running Processes% ------------------------
ECHO.
PEV PLIST >temp01 2>N_\%random%
SED -R "/\\/!d; /%cd:\=\\%/Id; s/^\\\?\?\\//; s/^\\/%SystemDrive%&/; s/^.:\\Systemroot\\/%systemroot:\=\\%\\/I;s/ \[\d*] .*$//" temp01 >temp02
GREP -Fixvf KiLLNotB temp02
ECHO.
ECHO.**************************************************************************
ECHO.
)>>ORP


PEV TIME| SED "s/ /&&/; s/.*/@SET \x22EndTime=&\x22/" > EndTime.bat
@ECHO.@ECHO.^>NULL >> EndTime.bat
CALL EndTime.bat >N_\%random% 2>&1

DEL /A/F/Q temp0? Endtime.bat >N_\%random% 2>&1



IF EXIST RBoot.dat (
	GREP -Fisq :\ ORP && TYPE ORP>>ComboFix.txt
	ECHO."%Completion time%: %EndTime% - %machine was rebooted% %Combobatch-by%"|SED -r "s/\x22//g;s/\s*$//g" >>ComboFix.txt
) ELSE (
	ECHO.%Completion time%: %EndTime%>>ComboFix.txt
	IF EXIST OriO4 (
		GREP -Ei "Lavasoft\\.*\\Ad-Watch(\.|200.\.)exe$|\\Spybot.*\\TeaTimer.exe$" OriO4 >OriO4B
		FOR /F "TOKENS=*" %%G IN ( OriO4B ) DO @IF EXIST "%%~G" start /i /d"%%~DPG" /min "." "%%~G"
		))


@PEV -sd:name -rtf -c:##f  #m# "%SystemDrive%\qoobox\combofix*.txt" -output:temp00
SED "s/.*\\//" temp00 >>ComboFix.txt

IF EXIST DeQuarantine.dat (
	MOVE /Y DeQuarantine.dat %SystemDrive%\DeQuarantine.txt >N_\%random%
	ECHO.%SystemDrive%\DeQuarantine.txt>>ComboFix.txt
	START /D\ /MAX notepad.exe %SystemDrive%\DeQuarantine.txt
	)

@CMD /C ECHO.>>ComboFix.txt
@IF EXIST PreDIR CMD /C TYPE PreDIR >>ComboFix.txt
@CMD /C DIR \ >temp00 && SED -r "$!d;s/ +.*  +/%Post-Run%: /" temp00 >>ComboFix.txt

IF EXIST CF-RC.txt (ECHO.&TYPE CF-RC.txt)>>ComboFix.txt


@ECHO.>>ComboFix.txt


REM SWREG QUERY HKLM\SYSTEM >CSxxx00
REM GREP -ixc "H.*ControlSet..." CSxxx00 | GREP -sq [23] ||(
REM SWREG QUERY HKLM\SYSTEM\Select >CSxxx01
REM 	SED -R "/^   (.*)	.*	(\d*) \(.*/I!d; s//\1=\2/" CSxxx01 >CSxxx02
REM 	ECHO.Sets=>>CSxxx02
REM 	SED -R "/.*\\ControlSe(t0*|t)(\d*)$/I!d; s//\2,/" CSxxx00 >>CSxxx02
REM 	SED -r ":a; $!N;s/\n/ /;ta; s/(,|=) /\1/g; s/,$//" CSxxx02 >>ComboFix.txt
REM 	)
REM DEL /A/F/Q CSxxx0?



@PEV -rtf -c##5# ComboFix.txt -output:temp00
SWREG QUERY "HKLM\software\microsoft\windows\currentversion\windowsupdate\auto update\results\install" >>temp00
SED -R "/^([A-F0-9]{32}$| +LastSuccessTime      )/I!d; s/./- - End Of File - - &/" temp00 | SED -r "N;s/\n.*	/ - - /;" >>ComboFix.txt
DEL /A/F/Q temp0? N_\* >N_\%random% 2>&1

IF NOT EXIST %SystemDrive%\Qoobox\Quarantine\MBR_HardDisk0.mbr (
	dd if="\\.\PhysicalDrive0" bs=512 count=1 of=%SystemDrive%\Qoobox\Quarantine\MBR_HardDisk0.mbr	
	)>N_\%random% 2>&1
	
IF EXIST %SystemDrive%\Qoobox\Quarantine\MBR_HardDisk0.mbr PEV -rtf -s=0 %SystemDrive%\Qoobox\Quarantine\MBR_HardDisk0.mbr >N_\%random% 2>&1 ||(
	dd if=%SystemDrive%\Qoobox\Quarantine\MBR_HardDisk0.mbr of=mbr440.dat bs=440 count=1
	PEV -rtf -c##5# mbr440.dat >>ComboFix.txt
	)>N_\%random% 2>&1


:CLEANUP
HIDEC SWSC START Schedule
:: NIRCMD service start Schedule
@NIRCMD WIN TRANS STITLE "PROCESS EXPLORER" 255
@cd %~dp0


@IF EXIST ComboFix.txt (
	IF EXIST "%temp%\log.txt" DEL /A/F "%temp%\log.txt"
	SED -R "/vkquwexg|Combo-Fix.sys/Id;" ComboFix.txt | SED -R "s/\r/\n/; /  \d\d:\d/!s/(.\d:\d.):../\1/g; s/	0	d/	--------	d/;" >temp01
	SED -R "/(\[\d{4}-\d\d-\d\d )\d\d:.* ([^]]*])$/s//\1\2/; s/^(\[.\] \d{4}-\d\d-\d\d )\d\d:.. (\. .*\. \. \[[^]]*) \([^]]*\)]/\1\2]/; s/(.:\\[^\\]*\\)/\L&\E/g; s/^$/./" temp01 > "%temp%\log.txt"
	IF NOT EXIST "%temp%\log.txt" TYPE ComboFix.txt > "%temp%\log.txt"
	IF NOT EXIST "%temp%\log.txt" (
		TYPE ComboFix.txt > %SystemDrive%\ComboFix.txt
		) ELSE TYPE "%temp%\log.txt" > %SystemDrive%\ComboFix.txt
	)
DEL /A/F/Q temp0? >N_\%random% 2>&1


@PEV TIME > time_.dat
@FOR /F "TOKENS=1*" %%G IN ( time_.dat ) DO @SET "DTT=%%G_%%H"
@SET "DTT=%DTT::=.%"

IF EXIST "Wow#*.zip" (
	ECHO.::>>sUBmit00
	FOR %%G IN ( Wow#*.zip ) DO @ECHO.@ComboFix-Download --connect-timeout 20 -m 900 --retry 0 -# -F "channel=79" -F "userfile=@%CD%\%%G" -F "User=ComboFix" -F "MAX_FILE_SIZE=15728640" -H "Host: www.bleepingcomputer.com" http://208.43.87.2/submit-malware.php >>\QooBox\CurlIt.cmd
	)>N_\%random% 2>&1
		
	
PEV -rtf -dL10 %SystemDrive%\QooBox\CF-Submit.htm >N_\%random% && DEL /A/F/Q %SystemDrive%\QooBox\CF-Submit.htm
IF EXIST %SystemDrive%\QooBox\CF-Submit.htm FINDSTR ":\\." %SystemDrive%\QooBox\CF-Submit.htm >sUBmit00 2>N_\%random% &&(
	SET >SET
	FOR /F "TOKENS=*" %%G IN ( sUBmit00 ) DO @(
		PEV UZIP %%~SG >unzip00
		GREP -sqiv "/catchme.txt$" Unzip00|| DEL /A/F sUBmit00 "%%G"  %SystemDrive%\QooBox\CF-Submit.htm %SystemDrive%\QooBox\CurlIt.cmd
		IF EXIST "%%G" (
			PEV -dg10 -s-350000 and "%SystemDrive%\QooBox\C*[234].txt" or { "%SystemDrive%\QooBox\Quarantine\Registry_backups\*" and Service_*.dat or Notify-*.dat } -output:PackMe
			TYPE Packme | ZIP -S@q "%%~G" ComboFix.txt "\QooBox\Quarantine\*.log" set
			) )
	DEL /A/F SET PackMe
	)>N_\%random% 2>&1


IF EXIST time_delf.dat FOR /F "TOKENS=*" %%G IN ( time_delf.dat ) DO @IF EXIST "\QooBox\Quarantine\[4]-DELF_%%G.zip" (
	PEV UZIP "\QooBox\Quarantine\[4]-DELF_%%G.zip" >unzip00
	GREP -sqiv "/catchme_delf.txt$" Unzip00 &&@(
		PEV -dg10 and "%SystemDrive%\QooBox\C*[234].txt" or { "%SystemDrive%\QooBox\Quarantine\Registry_backups\*" and Service_*.dat or Notify-*.dat } -output:PackMe
		TYPE Packme | ZIP -S@ "\QooBox\Quarantine\[4]-DELF_%%G.zip"  ComboFix.txt index.dat >>sUBmit00
		DEL /A/F SET PackMe
		)|| DEL /A/F "\QooBox\Quarantine\[4]-DELF_%%G.zip"
	)>N_\%random% 2>&1

	
IF EXIST sUBmit00 (
	IF NOT EXIST %SystemDrive%\QooBox\image001.gif ECHO.F|XCOPY /HQRY image001.gif %SystemDrive%\QooBox\ >N_\%random% 2>&1
	IF EXIST %SystemDrive%\QooBox\CF-Submit.htm MOVE /Y %SystemDrive%\QooBox\CF-Submit.htm %SystemDrive%\CF-Submit.htm >N_\%random% 2>&1
	NIRCMD LOOP 2 80 BEEP 3000 200
	REM NIRCMD.exe cmdwait 1000 infobox "ComboFix needs to submit malware files for further analysis.~n~nPlease ensure that you're connected to the internet before clicking OK" "Submit Files for further analysis"
	NIRCMD.EXE CMDWAIT 1000 INFOBOX "%LINE33%" ""
	IF EXIST %SystemDrive%\QooBox\CurlIt.cmd (
		CLS
		ECHO.
		ECHO.%Uploading files to server% ...
		ECHO.
		%KMD% /C %SystemDrive%\QooBox\CurlIt.cmd >CurlIt.dat
		GREP -Fsq "user helping you" CurlIt.dat &&(
			IF NOT EXIST cfscriptFCollect00 IF EXIST %SystemDrive%\CF-Submit.htm (
				ECHO.
				ECHO.%Upload was successful% | MTEE /+ %SystemDrive%\ComboFix.txt /+ "%temp%\log.txt"
				ECHO.
				)
			DEL /A/F %SystemDrive%\CF-Submit.htm >N_\%random% 2>&1
			PEV WAIT 1500
		)||IF EXIST %SystemDrive%\CF-Submit.htm NIRCMD INFOBOX "%Line40%" ""
		REM NIRCMD INFOBOX "Webserver appears to be temporarily inacessible.~nFor your convenience, ComboFix created a submissions form located at:~n~n* %SystemDrive%\CF-Submit.htm~n~nPlease use that to manually upload it later. " "Upload Failed!!"
		DEL /A/F %SystemDrive%\QooBox\CurlIt.cmd >N_\%random% 2>&1
	) ELSE IF EXIST %SystemDrive%\CF-Submit.htm "%ProgFiles%\Internet Explorer\IEXPLORE.EXE" %SystemDrive%\QooBox\CF-Submit.htm
		)



@IF EXIST "%System%\fsutil.exe" FOR %%G IN (
	"%ProgFiles%\Windows Defender"
	"%ProgFiles%\Microsoft Security Client"
	"%ProgramFiles%\Windows Defender"
	"%ProgramFiles%\Microsoft Security Client"
) DO @IF EXIST "%%~G\*" PEV -te "%%~G\*" >RepPoints.dat &&(
	 SWXCACLS "%%~G" /RESET /Q
	FOR /F "TOKENS=*" %%G IN ( RepPoints.dat ) DO @"%System%\fsutil.exe" REPARSEPOINT DELETE "%%~G" 
	SWXCACLS "%%~G" /RESET /Q
	)>NULL 2>&1




@TITLE CFDone
@NIRCMD WIN ACTIVATE ITITLE CFDone
@NIRCMD SENDKEY ENTER PRESS
@NIRCMD WIN HIDE ITITLE CFDone
@ECHO OFF


@IF EXIST "%temp%\log.txt" ( @START /D..\  /max notepad.exe "%temp%\log.txt"
	) ELSE @START /D..\  /max notepad.exe "\ComboFix.txt"



PEV WAIT 1000
%SystemRoot%\REGEDIT.EXE /S FIN.DAT
IF EXIST delclsid00 CALL DelClsid.bat >N_\%random% 2>&1
IF EXIST delclsid00-X64 CALL DelClsid64.bat >N_\%random% 2>&1
IF EXIST %SystemDrive%\qoobox\lastrun RD /S/Q %SystemDrive%\qoobox\lastrun
SWREG COPY "hkcu\console_combofixbackup" "hkcu\console" /s >N_\%random% 2>&1
SWREG COPY "HKLM\system\currentcontrolset\control\servicegrouporder_combofixbackup" "HKLM\system\currentcontrolset\control\servicegrouporder" /s >N_\%random% 2>&1
SWREG DELETE "hkcu\console_combofixbackup" >N_\%random% 2>&1
SWREG DELETE "HKLM\system\currentcontrolset\control\servicegrouporder_combofixbackup" >N_\%random% 2>&1
START NIRCMD.exe sysrefresh intl


IF EXIST "LocalSettings.folder.dat" FOR /F "TOKENS=*" %%G  IN ( LocalSettings.folder.dat ) DO @(
	IF EXIST "%%~G\temp" RD /S/Q "%%~G\temp"
	IF NOT EXIST "%%~G\temp" MD "%%~G\temp"
	)

IF EXIST Cache.folder.dat FOR /F "TOKENS=*" %%G IN ( Cache.folder.dat ) DO @IF EXIST "%%~G\Content.IE5\index.dat" (
	SWXCACLS "%%~G\Content.IE5" /RESET /Q
	RD /S/Q "%%~G\Content.IE5" 
	)>N_\%random% 2>&1

IF EXIST ClearJavaCache FOR /F "TOKENS=*" %%G IN ( ClearJavaCache ) DO @RD /S/Q "%%~G" && MD "%%~G"
IF EXIST "%SystemRoot%\temp" RD /S/Q "%SystemRoot%\temp" && MD "%SystemRoot%\temp"
IF EXIST "%ProfilesDirectory%.\LocalService\Cookies\" RD /S/Q "%ProfilesDirectory%.\LocalService\Cookies"
IF EXIST "%ProfilesDirectory%.\NetworkService\Cookies\" RD /S/Q "%ProfilesDirectory%.\NetworkService\Cookies"
IF EXIST "%ProfilesDirectory%.\Default User\Cookies\" RD /S/Q "%ProfilesDirectory%.\Default User\Cookies"
IF EXIST "%system%\config\systemprofile\Cookies\" RD /S/Q "%system%\config\systemprofile\Cookies"
IF EXIST Vista.krl IF EXIST %system%\ICACLS.exe %system%\ICACLS.exe %SystemRoot% /RESTORE VwinTemp.dacl /C /Q >N_\%random% 2>&1
SWXCACLS %systemdrive%\Qoobox\BackEnv /DE:F /Q

@CALL RKEY.cmd

@%SystemRoot%\REGEDIT.EXE /S CREGC.DAT
@%SystemRoot%\REGEDIT.EXE /S CREG.DAT

IF EXIST Foreign.dat FOR /F "TOKENS=1,2 delims=	" %%G in ( Foreign.dat ) DO @IF EXIST "%%~H" MOVE /Y "%%~H" "%%~G"

PEV -k *.%cfExt% and not %ComSpec%
PEV -k SWSC.*
START NIRKMD CMDWAIT 2000 EXEC HIDE PEV -k Handle.%cfext%
HANDLE "%~dp0" >temp00
PEV -k NIRKMD.%cfext%
GREP -Fivf unhand.dat temp00 | SED -R "/.* pid: (\d*) +(\S*):.*/I!d;s//@Handle -c \2 -y -p \1/" > temp00.bat
ECHO.@ECHO.>> temp00.bat
START NIRKMD CMDWAIT 4000 EXEC HIDE PEV -k Handle.%cfext%
CALL temp00.bat
PEV -k NIRKMD.%cfext%
DEL /A/F/Q temp0? temp00.bat %system%\swsc.exe
RD /S/Q %SystemDrive%\qoobox\test
RD /S/Q %SystemDrive%\qoobox\testC
IF EXIST N_\ RD /S/Q N_\


SWREG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V AutoRestartShell /T REG_DWORD /D 1

IF EXIST temp0? DEL /A/F/Q temp0?
IF EXIST Vista.krl (
	IF NOT EXIST W6432.dat (
		PEV -k Explorer.exe
		PEV WAIT 2500
		PEV PLIST >temp00
		GREP -Fi "%systemroot:~2%\explorer.exe" temp00 || GOTO LaunchGUI
	) ELSE IF EXIST %SYSTEMROOT%\System32\TASKKILL.EXE IF EXIST %SYSTEMROOT%\System32\TASKLIST.EXE (
		%SYSTEMROOT%\System32\TASKKILL.EXE /F /IM Explorer.exe
		PEV WAIT 1000
		%SYSTEMROOT%\System32\TASKLIST.EXE /FI "IMAGENAME EQ EXPLORER.EXE" >temp00
		GREP -Fi "explorer.exe" temp00 || GOTO LaunchGUI
		)
) ELSE (
	PEV PLIST >temp00
	GREP -Fi "%systemroot:~2%\explorer.exe" temp00 || GOTO LaunchGUI
	)

	
:END
DEL /A/F/Q temp0?
CD \
START NIRCMD.exe execmd RD /S/Q "%~DP0"
EXIT


:LaunchGUI
ENDLOCAL
SET Debug=
SET Sfxcmd=
SET Sfxname=
START /D"%userprofile%" /I %SystemRoot%\explorer.exe
@GOTO END


:ND.mov_sub
@CALL ECHO.%Line36% >>ndis_log.dat
@CALL ECHO.%Line36A%>>ndis_log.dat
@GOTO :EOF


:WallPaper
SWREG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\LastTheme" /v Wallpaper >wallPaper02
SED "/.*	/!d; s___" wallPaper02 >wallPaper03
FOR /F "TOKENS=*" %%H IN ( wallPaper03 ) DO @CALL ECHO."%%~H">wallPaper04
IF EXIST wallPaper04 FOR /F "TOKENS=*" %%I IN ( wallPaper04 ) DO IF EXIST %%I IF /I [%%~XI] EQU [.BMP] (
	SWREG ADD "HKCU\Control Panel\Desktop" /v Wallpaper /d %%I
	GOTO :EOF
		) ELSE (
		NIRCMD CONVERTIMAGE %%I "%LocalAppData%\Microsoft\Wallpaper1.bmp"
		SWREG ADD "HKCU\Control Panel\Desktop" /v ConvertedWallpaper /d %%I
		)

IF EXIST "%LocalAppData%\Microsoft\Wallpaper1.bmp" (
	SWREG ADD "HKCU\Control Panel\Desktop" /v TileWallpaper /d 0
	SWREG ADD "HKCU\Control Panel\Desktop" /v WallpaperStyle /d 2
	SWREG ADD "HKCU\Control Panel\Desktop" /v Wallpaper /d "%LocalAppData%\Microsoft\Wallpaper1.bmp"
	SWREG ADD "HKCU\Software\Microsoft\Internet Explorer\Desktop\General" /v Wallpaper /t reg_expand_sz /d "%%USERPROFILE%%\Local Settings\Application Data\Microsoft\Wallpaper1.bmp"
	SWREG ADD "HKCU\Control Panel\Desktop" /v OriginalWallpaper /d "%LocalAppData%\Microsoft\Wallpaper1.bmp"
	)  ELSE SWREG ADD "HKCU\Control Panel\Desktop" /v Wallpaper /d ""

@GOTO :EOF

:HDCntrlB
@REM CALL ECHO.Infected copy of %%~1 was found and disinfected >>dollar_log.dat
@REM CALL ECHO.Restored copy from - %%~2 >>dollar_log.dat
@CALL ECHO.%Line36% >>dollar_log.dat
@CALL ECHO.%Line36A% >>dollar_log.dat
@GOTO :EOF


:SRPEEK
@IF /I "%~1" EQU "" GOTO :EOF
@IF NOT EXIST SRSearch ECHO.((((((((((((((((((((((((((((((((((((((((((   SR_Search   ))))))))))))))))))))))))))))))))))))))))))))))))))))))))>>ComboFix.txt
@IF EXIST F_System SWXCACLS "\System Volume Information\" /E /GA:R /Q
@PEV -samdate -td -dg1M "%systemdrive%\System Volume Information\RP*" -output:Rpts
@IF EXIST Rpts FOR /F "TOKENS=*" %%G IN ( Rpts) DO @CALL :SRPEEK_A "%%G" %1
@IF EXIST F_System SWXCACLS "%systemdrive%\system volume information" /P /GS:F /I REMOVE /Q
@SORT /M 65536 cfscriptSrPeek02 /O cfscriptSrPeek03
@SED -r ":a;$!N; s/(.[^	]*)(	.*)\n\1/\1\2/; ta;P;D;" cfscriptSrPeek03 |SED -r "s/	([^	]*)	.*	/\n\1\n/;s/	/\n/g" >cfscriptSrPeek04
@( FOR /F "TOKENS=*" %%G IN ( cfscriptSrPeek04 ) DO @PEV -rtf -c:#[#v] #5#b#u#b#f# "%%G" || ECHO.%%G [x] )>cfscriptSrPeek05
@SED "/.:\\System Volume Information\\/I!s/^/\n/; s/.:\\System Volume Information\\[^\\]*//" cfscriptSrPeek05 >>ComboFix.txth
@ECHO.>>ComboFix.txt
@GOTO :EOF


:SRPEEK_A
@PUSHD %1
@TYPE change.log* | GSAR -F -s:x1A -r >"%~DP0cfscriptSrPeek01"
@START NircmdB.exe cmdwait 10000 KillProcess SED.%cfExt%
@SED -r "s/\x00//g; s/\x22\x05/\x00/g; s/\\[[:print:]]*\x00A/\n%systemdrive%&/Ig" "%~DP0cfscriptSrPeek01" |(
	SED -r "/^.:\\.*\\(%~2)\x00/I!d; s/\x00(A.{11}).*/	%cd:\=\\%\\\1/" )>>"%~DP0cfscriptSrPeek02"
@PEV -k NircmdB.exe
@DEL /A/F "%~DP0cfscriptSrPeek01"
@POPD
@GOTO :EOF

