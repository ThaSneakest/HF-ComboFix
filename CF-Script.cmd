
IF NOT DEFINED sfxcmd GOTO :EOF

:: CF-Script
IF EXIST "%Desktop%\catchme.zip" MOVE /Y "%Desktop%\catchme.zip" "%SystemDrive%\Qoobox\Quarantine\catchme%dateX%_%time::=%.zip"



@GREP -Eisq "^{\\rtf1\\ansi" %sfxcmd% && (
		NIRCMD LOOP 2 80 BEEP 3000 200
		NIRCMD INFOBOX "%LINE8%" ""
		REM NIRCMD infobox "Rich text formats (RTF) are unacceptable !!~n~nPlease save CFScript commands as a textfile, using Notepad.exe" "ERROR - Script format is incorrect"
		EXIT
		)



@SETLOCAL
@PEV TIME > time.dat
@FOR /F "TOKENS=1*" %%G IN ( time.dat ) DO @SET "DTT=%%~G_%%~H"
@SET "DTT=%DTT::=.%"

@SET "CFStr=ADS|FileLook|DirLook|Suspect|RenV|KillALL|RecoveryConsole|SnapShot|SysRst|NoOrphans|SkipFix|DeQuarantine|DeQuarantineB|Ignore|MBR|Extra"

TYPE %sfxcmd% | SED "s/\r/\n/g" | SED -r "/^$/d; s/^\s*//; s/\s*$//; s/^(%CFStr%)$/&::/I; s/^(%CFStr%):$/&:/I; s/^\S*::/\n&/Ig; $G;" >Do.dat
@COPY /Y %sfxcmd% "\Qoobox\CFScript_used_%DTT%.txt"
@DEL /A/F %sfxcmd% time.dat

@(
ECHO.%systemroot%\NIRCMD.exe
ECHO.%systemroot%\MBR.exe
ECHO.%systemroot%\PEV.exe
ECHO.%systemroot%\sed.exe
ECHO.%systemroot%\SWREG.exe
ECHO.%systemroot%\SWSC.exe
ECHO.%systemroot%\SWXCACLS.exe
ECHO.%systemroot%\zip.exe
)>Homer.chk

GREP -Fif Homer.chk Do.dat >Homer &&(
	SED ":a; N; s/\n/~n/; ta;" Homer >HomerB
	REM NIRCMD INFOBOX "%%G~n~nThese files are part of ComboFix.~nThis CFScript shall not be processed."
	FOR /F "TOKENS=*" %%G IN ( HomerB ) DO @START NIRCMD INFOBOX "%LINE87%" ""
	DEL /A/F/Q Homer HomerB Do.dat Homer.chk "\Qoobox\CFScript_used_%DTT%.txt"
	GOTO :EOF
	)


@SED 1!d; Do.dat >cfscriptHttp00
@GREP -i "^http:" cfscriptHttp00 | MTEE /+ "%SystemDrive%\Qoobox\Quarantine\catchme.txt" >cfscriptHttp01
@FOR /F "TOKENS=*" %%G IN ( cfscriptHttp01 ) DO @SET "URL_LINK=%%~G"
:: @IF NOT DEFINED URL_LINK GOTO EOF_


@IF EXIST Kill-All.cmd GREP -iq killall:: Do.dat &&CALL Kill-All.cmd
@GREP -iq SnapShot:: Do.dat && SWREG DELETE hklm\software\swearware /v snapshot
@GREP -iq SysRst:: Do.dat && TYPE myNul.dat >SysRst
@GREP -iq RestoreRun:: Do.dat && TYPE myNul.dat >RestoreRun
@GREP -iq Replicator:: Do.dat && TYPE myNul.dat >ReplicatorDo
@GREP -iq StepDel:: Do.dat && TYPE myNul.dat >DoStepDel
@FakeSmoke:: Do.dat && TYPE myNul.dat >FSmoke.dat
@GREP -iq NoOrphans:: Do.dat && TYPE myNul.dat >NoOrphans
@GREP -iq SkipFix:: Do.dat && TYPE myNul.dat >XPRD.NFO
REM @GREP -iq FixCSet:: Do.dat && TYPE myNul.dat | MTEE  CfReboot.dat >FixCSet.dat
@GREP -iq Reboot:: Do.dat && TYPE myNul.dat >CFReboot.dat
@GREP -iq ATJob:: Do.dat && PEV -tf "%Tasks%\at*.job" >>CFiles.dat
@GREP -iq ClearJavaCache:: Do.dat && TYPE myNul.dat >ClearJavaCache

@IF EXIST W6432.dat GREP -iq MBR:: Do.dat &&(
	TYPE myNul.dat | MTEEE CFscriptMBR.dat >CFReboot.dat
	)


@FOR %%G IN ( Collect Suspect RenV RootKit FDelete File Folder Filex64 Folderx64 )  DO @SED -r -e "/^%%~G::/I,/^([^\\]*$|$)/!d; s/\x22//g; /^(%%|[a-z]:\\)/I!d; /*|\?/d" -f ConEnv.sed -e "s/.*/\x22\0\x22/" Do.dat >cfscript%%~G00

:: obsolete
REM @FOR %%G IN ( cfscriptCollect00 ) DO @IF "%%~ZG"=="0" @FOR %%H IN ( cfscriptSuspect00 ) DO @IF "%%~ZH"=="0" (
REM 	SWREG QUERY "hklm\software\swearware" /v runs ||( SET LANG_CF|GREP -Esq "=(PL|CN|TW|FI|IT|ES|CS|NOR|SVE)$" &&TYPE cfscriptCollect00 |MTEE cfscriptFile00 cfscriptFolder00 >cfscriptFDelete00 )
REM 	GREP -sq . cfscriptfile00 && PEV -tx50000 -tpMZ -filescfscriptfile00 -output:cfscriptFCollect00
REM 	GREP -sic . cfscriptFCollect00 | GREP -sq "^[0-2]$" && DEL /A/F cfscriptFCollect00
REM 	IF EXIST cfscriptFCollect00 (
REM 		GREP -Fivf CFILES.DAT cfscriptFCollect00 >>cfscriptCollect00
REM 		IF NOT DEFINED URL_LINK SET "URL_LINK=hxxp://z11.invisionfree.com/sUBs/index.php?showtopic=119467"
REM 		))

GREP -Fixvf dnd.dat cfscriptCollect00 >cfscriptCollect01
SORT /M 65536 cfscriptCollect01 /O cfscriptCollect02
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptCollect02 | MTEE /+ CFiles.dat >cfscriptCollect03
GREP -Fsq :\ cfscriptCollect03 && ECHO.>CfReboot.dat

IF EXIST W6432.dat (
	SED -r "s/%SysDir:\=\\%\\(.*)/%SysNative:\=\\%\\\1/I;" cfscriptCollect03 >cfscriptCollect03a
	FOR /F "TOKENS=*" %%G IN ( cfscriptCollect03a ) DO @(
		SWXCACLS "%%~G" /OA /Q
		SWXCACLS "%%~G" /P /GE:F /Q
		ATTRIB -A -H -R -S "%%~G"
		)
	TYPE cfscriptCollect03a >> %SystemDrive%\Qoobox\Quarantine\catchme.txt 	
	ECHO.:::::>>cfscriptCollect03a
	PEV -ZIP"%SystemDrive%\Qoobox\Quarantine\catchme.zip" -files:cfscriptCollect03a >>CatchSubmit
	DEL /A/F cfscriptCollect03a
) ELSE FOR /F "TOKENS=*" %%G IN ( cfscriptCollect03 ) DO @IF /I "%%~ZG" LSS "1024" (
		CATCHME -l "%SystemDrive%\Qoobox\Quarantine\catchme.txt" -Z "%SystemDrive%\Qoobox\Quarantine\catchme.zip" -k "%%~G" >>CatchSubmit
			) ELSE IF NOT EXIST f_system (
		CATCHME -l "%SystemDrive%\Qoobox\Quarantine\catchme.txt" -c "%%~G" "%%~DPGCollect_%%~NXG.vir"
		IF EXIST "%%~DPGCollect_%%~NXG.vir" CATCHME -l "%SystemDrive%\Qoobox\Quarantine\catchme.txt" -Z "%SystemDrive%\Qoobox\Quarantine\catchme.zip" -k "%%~DPGCollect_%%~NXG.vir" >>CatchSubmit
		IF EXIST "%%~DPGCollect_%%~NXG.vir" DEL /A/F "%%~DPGCollect_%%~NXG.vir"
			) ELSE (
		SWXCACLS "%%~G" /OA /Q
		SWXCACLS "%%~G" /P /GE:F /Q
		FileKill -N CFcatchme -l "%SystemDrive%\Qoobox\Quarantine\catchme.txt" -Z "%SystemDrive%\Qoobox\Quarantine\catchme.zip" -o "%%~G" combo-fix.sys >>CatchSubmit
		)
DEL /A/F/Q cfscriptCollect0? InstallRC cfscriptHttp0?


SORT /M 65536 cfscriptSuspect00 | SED -r "$!N; /^(.*)\n\1$/I!P; D" >cfscriptSuspect01
IF EXIST W6432.dat (
	SED -r "s/%SysDir:\=\\%\\(.*)/%SysNative:\=\\%\\\1/I;" cfscriptSuspect01 >cfscriptSuspect01a
	FOR /F "TOKENS=*" %%G IN ( cfscriptSuspect01a ) DO @(
		SWXCACLS "%%~G" /OA /Q
		SWXCACLS "%%~G" /P /GA:F /Q
		ATTRIB -A -H -R -S "%%~G"
		)
	TYPE cfscriptSuspect01a >> %SystemDrive%\Qoobox\Quarantine\catchme.txt 	
	ECHO.:::::>>cfscriptSuspect01a
	PEV -ZIP"%SystemDrive%\Qoobox\Quarantine\catchme.zip" -files:cfscriptSuspect01a >>CatchSubmit
	DEL /A/F cfscriptSuspect01a
) ELSE FOR /F "TOKENS=*" %%G IN ( cfscriptSuspect01 ) DO @(
		CATCHME -l "%SystemDrive%\Qoobox\Quarantine\catchme.txt" -c "%%~G" "%%~DPGSuspect_%%~NXG.vir"
		CATCHME -l "%SystemDrive%\Qoobox\Quarantine\catchme.txt" -Z "%SystemDrive%\Qoobox\Quarantine\catchme.zip" -k "%%~DPGSuspect_%%~NXG.vir" >>CatchSubmit
		DEL /A/F "%%~DPGSuspect_%%~NXG.vir"
		)
DEL /A/F/Q cfscriptSuspect0?


IF EXIST CatchSubmit GREP -Es "\(|^.:\\." CatchSubmit >CatchZipped.dat &&(
		SED 1!d; Do.dat >cfscriptHttp00
		TYPE cfscriptHttp00 >> "%SystemDrive%\Qoobox\Quarantine\catchme.txt"
		ZIP -m "%SystemDrive%\Qoobox\Quarantine\catchme" "%SystemDrive%\Qoobox\Quarantine\catchme.txt"
		SED -r "/suspect::\[|collect::\[/I!d" Do.dat >cfscriptHttp02
		FOR /F "TOKENS=2 DELIMS=[]" %%G IN ( cfscriptHttp02 ) DO SET "CHANNEL=%%~G"
		DEL /A/F/Q cfscriptHttp0? CatchSubmit
		)||(
		IF EXIST "%SystemDrive%\Qoobox\Quarantine\catchme.zip" DEL "%SystemDrive%\Qoobox\Quarantine\catchme.zip"
		DEL /A/F CatchZipped.dat CatchSubmit
		)


IF NOT DEFINED CHANNEL SET "CHANNEL=4"
IF EXIST "%SystemDrive%\Qoobox\Quarantine\catchme.zip" (
	MOVE /Y "%SystemDrive%\Qoobox\Quarantine\catchme.zip" "%SystemDrive%\Qoobox\Quarantine\[%channel%]-Submit_%DTT%.zip"
	ECHO."%SystemDrive%\Qoobox\Quarantine\[%channel%]-Submit_%DTT%.zip"	"%URL_LINK%">Upload00
	CALL :upload
	ECHO.@ComboFix-Download --connect-timeout 30 -m 900 --retry 1 -# -F "channel=%CHANNEL%" -F "userfile=@%SystemDrive%\Qoobox\Quarantine\[%channel%]-Submit_%DTT%.zip" -F "User=ComboFix" -F "link=%URL_LINK%" -F "MAX_FILE_SIZE=15728640" -H "Host: www.bleepingcomputer.com" http://208.43.87.2/submit-malware.php >>\QooBox\CurlIt.cmd
	)




GREP -Fixvf dnd.dat cfscriptRenV00 >cfscriptRenV01
SORT /M 65536 cfscriptRenV01 /O cfscriptRenV02
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptRenV02 >cfscriptRenV03
GREP -sq :\\. cfscriptRenV03 &&(
	ECHO.@ECHO OFF >RenV.cmd
	ECHO.CD /D "%cd%">>RenV.cmd
	SED -r "/%system:\=\\%\\cmd *\.exe/Id" cfscriptRenV03 >cfscriptRenV04
	SED -r "s/^(.*\S)[ ]*(\.exe\x22)$/IF EXIST & \(\nNircmdB.exe killprocess \1\2\nmove \/y & \1\2\nIF EXIST & PEV MoveEx & \1\2 \&\&TYPE myNul.dat >CfReboot.dat\n\)\n/I" cfscriptRenV04 >>RenV.cmd
	SED -r "/%system:\=\\%\\cmd *\.exe/I!d; s/.*/DEL \/A\/F &/" cfscriptRenV00 >>RenV.cmd
	ECHO.DEL /A/F "%cd%\RenV.cmd">>RenV.cmd
	PEV EXEC /S "%CD%\HIDEC.%cfExt%" "%CD%\%KMD%" /C CALL "%cd%\RenV.cmd"
	)
DEL /A/F/Q cfscriptRenV0?
@title .



GREP -Fixvf dnd.dat cfscriptRootkit00 >cfscriptRootkit01
SORT /M 65536 cfscriptRootkit01 /O cfscriptRootkit02
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptRootkit02 | MTEE /+ Rootkit.dat >>catch_k.dat
GREP -sq :\\. Rootkit.dat || DEL /A/F Rootkit.dat
DEL /A/F/Q cfscriptRootkit0?



GREP -Fixvf dnd.dat cfscriptFDelete00 >cfscriptFDelete01
SORT /M 65536 cfscriptFDelete01 /O cfscriptFDelete02
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptFDelete02 | MTEE /+ rootkit.dat >>catch_E.dat
GREP -sq :\\. rootkit.dat || DEL /A/F rootkit.dat
DEL /A/F/Q cfscriptFDelete0?



GREP -Fixvf dnd.dat cfscriptFILE00 >cfscriptFILE02
SORT /M 65536 cfscriptFILE02 /O cfscriptFILE03
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptFILE03 | MTEE FileCFScript.dat >>CFiles.dat
GREP -Fixf dnd.dat cfscriptFILE00 >cfscriptFILE04
SED "s/$/	:#:/" cfscriptFILE04 >>FileCFScript.dat
DEL /A/F/Q cfscriptFILE0?


GREP -Fixvf dnd.dat cfscriptFOLDER00 >cfscriptFOLDER01
GREP -Fixf dnd.dat cfscriptFOLDER00 >cfscriptFOLDER02
SED "s/$/	-- Whitelisted --/" cfscriptFOLDER02 >>FileCFScript.dat
SORT /M 65536 cfscriptFOLDER01 /O cfscriptFOLDER03
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptFOLDER03 >>Cfolders.dat
DEL /A/F/Q cfscriptFOLDER0?



IF EXIST W6432.dat (
	GREP -Fixvf dnd.dat cfscriptFILEx6400 >cfscriptFILEx6402
	SORT /M 65536 cfscriptFILEx6402 /O cfscriptFILEx6403
	SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptFILEx6403 | MTEE /+ FileCFScript.dat >>CFilesx64.dat
	GREP -Fixf dnd.dat cfscriptFILEx6400 >cfscriptFILEx6404
	SED "s/$/	:#:/" cfscriptFILEx6404 >>FileCFScript.dat
	DEL /A/F/Q cfscriptFILEx640?

	GREP -Fixvf dnd.dat cfscriptFOLDERx6400 >cfscriptFOLDERx6401
	GREP -Fixf dnd.dat cfscriptFOLDERx6400 >cfscriptFOLDERx6402
	SED "s/$/	-- Whitelisted --/" cfscriptFOLDERx6402 >>FileCFScript.dat
	SORT /M 65536 cfscriptFOLDERx6401 /O cfscriptFOLDERx6403
	SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptFOLDERx6403 >>Cfoldersx64.dat
	DEL /A/F/Q cfscriptFOLDERx640?
	)



SED -r "/^System.Ini::/I,/^$/!d; /::|^$/d" Do.dat >cfscriptSystemINI00
SORT /M 65536 cfscriptSystemINI00 /O cfscriptSystemINI01
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptSystemINI01 >>System_Ini.dat
DEL /A/F/Q cfscriptSystemINI0?



SED -r "/^NetSvc::/I,/^$/!d; /::|^$/d" Do.dat >cfscriptNetSvc00
SORT /M 65536 cfscriptNetSvc00 /O cfscriptNetSvc01
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptNetSvc01 >>netsvc.bad.dat
DEL /A/F/Q cfscriptNetSvc0?


SED -r "/^NetSvc64::/I,/^$/!d; /::|^$/d" Do.dat >cfscript64NetSvc00
SORT /M 65536 cfscript64NetSvc00 /O cfscript64NetSvc01
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscript64NetSvc01 >>netsvc64.bad.dat
DEL /A/F/Q cfscript64NetSvc0?


SED -r -e "/^ADS::/I,/^([^\\]*$|$)/!d; s/\x22//g; /^(%%|[a-z]:\\)/I!d; /*|\?/d" -f ConEnv.sed -e "s/.*/\x22\0\x22/" Do.dat >cfscriptADS00
SORT /M 65536 cfscriptADS00 /O cfscriptADS01
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptADS01 >>ADS.dat
DEL /A/F/Q cfscriptADS0?



SED -r "/^Driver::/I,/^$/!d; /::|^$/d; s/\x22//g" Do.dat >cfscriptDriver00
SORT /M 65536 cfscriptDriver00 /O cfscriptDriver01
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptDriver01 >>zhsvc.dat
DEL /A/F/Q cfscriptDriver0?



TYPE myNul.dat >cfscriptDequarantineFile00
TYPE myNul.dat >cfscriptDequarantineFolder00

SED -r "/^DeQuarantineB::/I,/^([^:]{3}|$)/!d; /:\\/!d; /:\\qoobox\\/Id; /*|\?/d; s/\x22//g; s/(.):(.*)/&	%Qrntn:\=\\%\\\1\2/" Do.dat >cfscriptDequarantineB00
FOR /F "TOKENS=1* DELIMS=	" %%G IN ( cfscriptDequarantineB00 ) DO @(
	ECHO.%%G>>whiteAll.dat
	IF EXIST "%%~H\" ( 
	ECHO.%%H>>cfscriptDequarantineFolder00
	) ELSE IF NOT EXIST "%%~DPH_%%~NH_%%~XH.zip" (
		IF EXIST "%%H.vir" (ECHO.%%H.vir>>cfscriptDequarantineFile00) ELSE ECHO.%%G . . cannot be dequarantined. File/Folder not found
	) ELSE (		
		IF EXIST DSearchDone DEL /A/F DSearchDone
		IF EXIST "%%H.vir" PEV -rtf -tpmz "%%~H.vir" &&(
			GREP -sq "NB10....@.cF....T:\\o\\i386\\d.pdb" "%%~H.vir" ||ECHO.%%H.vir|MTEE DSearchDone >>cfscriptDequarantineFile00
			)
		IF NOT EXIST DSearchDone (
			PEV UZIP "%%~DPH_%%~NH_%%~XH.zip" %SystemDrive%\Qoobox\Test
			MOVE /Y "%SystemDrive%\Qoobox\Test\%%~NXH" "%%~G"
			IF EXIST "%%G" ECHO.Unzipped: %%~DPH_%%~NH_%%~XH.zip --to-- %%G >>DeQuarantine.dat
			DEL /A/F/Q "%SystemDrive%\Qoobox\Test\*"
			)))
		
SED -r "/^DeQuarantine::/I,/^([^:]{3}|$)/!d; /:\\qoobox\\quarantine\\.\\/I!d; /*|\?/d" Do.dat >cfscriptDequarantine00
FOR /F "TOKENS=*" %%G IN ( cfscriptDequarantine00 ) DO @IF EXIST "%%~G" IF EXIST "%%~G\" ( ECHO.%%G>>cfscriptDequarantineFolder00
	) ELSE ECHO.%%G>>cfscriptDequarantineFile00

SORT /M 65536 cfscriptDequarantineFile00 /O cfscriptDequarantineFile01
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptDequarantineFile01 >cfscriptDequarantineFile02

SED -r "/\.zip$/I!d; s/.:\\QooBox\\Quarantine\\(.)(\\.*)\\.*/&	\1:\2/I" cfscriptDequarantineFile02 >cfscriptDequarantineFile03
FOR /F "TOKENS=1* DELIMS=	" %%G IN ( cfscriptDequarantineFile03 ) DO @(
	PEV UZIP "%%~G" "%%~H"
	PEV UZIP "%%~G" >Uzip00
	FOR /F "TOKENS=*" %%I IN ( UZIP00) DO @IF EXIST "%%~H\%%~I" ECHO.Unzipped: %%G --to-- %%~H\%%I >>DeQuarantine.dat
	)

SED -r "/\.vir$/I!d; s/.:\\QooBox\\Quarantine\\(.)(\\.*)(\.vir)/&	\1:\2/I" cfscriptDequarantineFile02 | SED -r ":a; s/\.vir$//I; ta" >cfscriptDequarantineFile04
FOR /F "TOKENS=1* DELIMS=	" %%G IN ( cfscriptDequarantineFile04 ) DO @(
	IF NOT EXIST "%%~DPH" MD "%%~DPH"
	IF EXIST W6432.dat (
		SWXCACLS "%%~H" /OA /Q
		SWXCACLS "%%~H" /P /GE:F /Q
		ATTRIB -H -R -S -A "%%~H"
		DEL /A/F "%%~H"
		ECHO.F|XCOPY /c/f/h/r/k/y "%%~G" "%%~H" >>cfscriptDequarantineFile06
		) ELSE CATCHME -l N_\%random% -c "%%~G" "%%~H" >>cfscriptDequarantineFile05
		)
IF EXIST cfscriptDequarantineFile05 SED "/file copied: /!d; s///" cfscriptDequarantineFile05 >>DeQuarantine.dat
IF EXIST cfscriptDequarantineFile06 GREP -UF " -> " cfscriptDequarantineFile06 >>DeQuarantine.dat

SORT /M 65536 cfscriptDequarantineFolder00 /O cfscriptDequarantineFolder01
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptDequarantineFolder01 >cfscriptDequarantineFolder02
SED -r ":a; N; s/^(.[^\n]*)\n\1.*/\1/;ta;P;D" cfscriptDequarantineFolder02 >cfscriptDequarantineFolder03
SED -r "s/.:\\QooBox\\Quarantine\\(.)(\\.*)/&	\1:\2/I" cfscriptDequarantineFolder03 >cfscriptDequarantineFolder04
FOR /F "TOKENS=1* DELIMS=	" %%G IN ( cfscriptDequarantineFolder04 ) DO @(
	PEV -tx50000 -tf "%%~G\*.vir" -output:cfscriptDequarantineFolder05
	FOR /F "TOKENS=*" %%I IN ( cfscriptDequarantineFolder05 ) DO @REN "%%~I" "%%~NI"
	XCOPY /e/c/i/f/h/r/k/y "%%~G\*" "%%~H" >>DeQuarantine.dat 2>&1
	FOR /F "TOKENS=*" %%I IN ( cfscriptDequarantineFolder05 ) DO @REN "%%~DPNI" "%%~NXI"
	)
DEL /A/F/Q cfscriptDequarantineFolder0? cfscriptDequarantineFile0? Uzip00
IF EXIST DeQuarantine.dat GREP -isq Quit:: Do.dat &&(
	MOVE /Y DeQuarantine.dat %systemdrive%\DeQuarantine.txt
	START /D\ /MAX notepad.exe %systemdrive%\DeQuarantine.txt
	ECHO.>AbortC
	GOTO :EOF
	)


	
SED -r "/^Ignore::/I,/^([^:]{3}|$)/!d; /:\\/!d; /:\\qoobox\\/Id; /*|\?/d; s/\x22//g;" Do.dat >>whiteAll.dat



SED -r -e "/^Reglock(:|Del:):/I,/^$/!d; /^\[/!d; s/^\[|]$//g;" Do.dat >cfscriptRegLock00
FOR /F "TOKENS=*" %%G IN ( cfscriptRegLock00 ) DO @SWREG ACL "%%~G" /RESET /Q
DEL /A/F cfscriptRegLock00



SED -e "/^RegNULL::/I,/^$/!d; /^\[/!d; s/^\[\|]$//g" Do.dat >cfscriptRegNull00
SED -r "/^H.*\*/!d; s/\\[^\\]*\x2a.*//;s/^\[//" cfscriptRegNull00 >cfscriptRegNull01
FOR /F "TOKENS=*" %%G IN ( cfscriptRegNull01 ) DO @(
	SWREG NULL QUERY "%%~G" /S /F >cfscriptRegNull02
	SED -r "/^HKEY.*\*/!d" cfscriptRegNull02 >cfscriptRegNull03
	FOR /F "TOKENS=*" %%H IN ( cfscriptRegNull03 ) DO @SWREG NULL DELETE "%%~H" /N *
	DEL /A/F cfscriptRegNull02 cfscriptRegNull03
	)
DEL /A/F/Q cfscriptRegNull0?



SED -r -e "/^DDS::/I,/^$/!d; s/%%programfiles%%/%ProgFiles:\=\\%/I; s/%%windir%%|%%systemroot%%/%systemroot:\=\\%/Ig;" -f ddsDo.sed Do.dat >DDS00
SED -r "/\[-hkey_.*browser.helper.objects\\|^.:\\/Id" DDS00 >>CregC.dat
SED "/^[a-z]:\\/I!d; s/.*/\x22&\x22/" DDS00 >>Cfiles.dat
SED -r "/\[-hkey_.*browser.helper.objects\\/I!d; s///g; s/]//g" DDS00 >delclsid0A
DEL /A/F/Q DDS00 ddsDo.sed



SED -e "/^Registry::/I,/^$/!d; s/^\[/\n&/; s/^[FOR][0-9]* -/\n&/I" Do.dat >cfscriptRegistry00
SED -e "/^ReglockDel::/I,/^$/!d; /^\[H/I!d; s//[-H/" Do.dat >>cfscriptRegistry00
SED -r -e "/^[OR]/{s/%%programfiles%%/%ProgFiles:\=\\%/I; s/%%windir%%|%%systemroot%%/%systemroot:\=\\%/Ig;}" -f regdo.sed cfscriptRegistry00 >RegDo.dat
SED -r "/\[-hkey_.*browser.helper.objects\\|^.:\\/Id" RegDo.dat >>CregC.dat
SED "/^[a-z@]:\\/I!d; s/^@:\\Global Startup\\/%CommonStartUp:\=\\%\\/I; s/^@:\\Startup\\/%StartUp:\=\\%\\/I; s/.*/\x22&\x22/" RegDo.dat >>Cfiles.dat
SED "/^#:\\/I!d; s/^#:\\.DEFAULT Startup\\//I; s/.*/\x22&\x22/" RegDo.dat >>StartUpFileB.dat
SED -r "/\[-hkey_.*browser.helper.objects\\/I!d; s///g; s/]//g" RegDo.dat >>delclsid0A
SORT /M 65536 delclsid0A | SED -r "$!N; /^(.*)\n\1$/I!P; D" >delclsid00
CALL DelClsid.bat
DEL /A/F/Q RegDo.dat cfscriptRegistry0? regdo.sed

@REGT /S CregC.dat 


:: ECHO.((((((((((((((((((((((((((((((((((((((((((((   Look   )))))))))))))))))))))))))))))))))))))))))))))))))))))))))>Look.dat


SED -r -e "/^FileLook::/I,/^([^\\]*$|$)/!d; s/\x22//g; /^(%%|[a-z]:\\)/I!d" -f ConEnv.sed -e "s/.*/\x22\0\x22/" Do.dat >cfscriptFileLook00
SORT /M 65536 cfscriptFileLook00 | SED -r "$!N; /^(.*)\n\1$/I!P; D" > FileLook.cfscript
DEL /A/F/Q cfscriptFileLook00

GREP -Fsq :\  FileLook.cfscript &&(
	COPY /Y FileLook.cfscript %SystemDrive%\Qoobox\LastRun\
	)|| DEL /A/F FileLook.cfscript
	

SED -r -e "/^DirLook::/I,/^([^\\]*$|$)/!d; s/\x22//g; /^(%%|[a-z]:\\)/I!d" -f ConEnv.sed -e ":a; s/\\$//; ta; s/.*/\x22\0\x22/" Do.dat > cfscriptDirLook00
SORT /M 65536 cfscriptDirLook00 /O cfscriptDirLook01
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptDirLook01 > DirLook.cfscript	
DEL /A/F/Q cfscriptDirLook0?

GREP -Fsq :\  DirLook.cfscript &&(
	COPY DirLook.cfscript %SystemDrive%\Qoobox\LastRun\
	)|| DEL /A/F DirLook.cfscript
	
	
IF NOT EXIST Vista.krl (
	SED -r -e "/^SRPEEK::/I,/^([^:%%]{3}|$)/!d; s/\x22//g;" -f ConEnv.sed -e "/.:.*\\/!d; s///; s/\./\\./g;" Do.dat  | SED ":a; $!N; s/\n/|/; ta; s/.*/\x22&\x22/;" > SrPeek.cfscript
	GREP -Fsq :\  SrPeek.cfscript ||(
	COPY SrPeek.cfscript %SystemDrive%\Qoobox\LastRun\		
		)|| DEL /A/F SrPeek.cfscript
			)
	


SED -r "/^SCopy::/I,/^(.:\\|\[|[[:alnum:]]{3}|$)|::/!d; /^\\RP.*\|.*:\\/I!d; /*|\?/d; s/\s+\|/\|/;s/\|\s+/\|/;s/\|/	/" Do.dat >cfscriptSCopy00
IF NOT EXIST XP.mac TYPE myNul.dat >cfscriptSCopy00
GREP -isq :\\. cfscriptSCopy00 (
		IF EXIST F_system SWXCACLS "\System Volume Information\"  /E /GA:F /Q
		PEV -tx120000 -limit:1 -rtd -c:#@SET "SysCache=#f"# "%systemdrive%\System Volume Information\_restore*" -output:cfscriptSCopy.bat
		ECHO.@>> cfscriptSCopy.bat
		CALL cfscriptSCopy.bat
		)
FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( cfscriptSCopy00 ) DO @IF EXIST "%SysCache%%%~G" (
	@IF NOT EXIST "%%~DPH" MD "%%~DPH"
	@COPY /Y /B "%SysCache%%%~G" %SystemDrive%\Qoobox\TestC &&(
		@ECHO."%SysCache%%%~G"	"%%~H"	"%SystemDrive%\Qoobox\TestC\%%~NXG">>SCopy
		@IF EXIST "%%~H" (
			@NIRCMD killprocess "%%~H"
			@%KMD% /D /C MoveIt.bat "%%~H" "ND_"
			)
		@IF NOT EXIST "%%~H" COPY /Y /B "%SystemDrive%\Qoobox\TestC\%%~NXG" "%%~H" && DEL /A/F "%SystemDrive%\Qoobox\TestC\%%~NXG"
		@IF EXIST "%SystemDrive%\Qoobox\TestC\%%~NXG" PEV MoveEx "%SystemDrive%\Qoobox\TestC\%%~NXG" "%%~H" &&TYPE myNul.dat >CFReboot.dat
		) )
IF EXIST SCopy IF EXIST F_System SWXCACLS "%systemdrive%\system volume information" /P /GS:F /I REMOVE /Q
DEL /A/F/Q cfscriptSCopy0? cfscriptSCopy.bat



SED -r "/^FCopy::/I,/^(\{|\[|[[:alnum:]]{3}|$)|::/!d; /.:\\.*\|.*:\\/!d; /*|\?/d; s/\s+\|/\|/;s/\|\s+/\|/;s/\|/	/" Do.dat >cfscriptFCopy00
FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( cfscriptFCopy00 ) DO @IF EXIST "%%~G" IF NOT EXIST "%%~G\" (
	ATTRIB -A -H -R -S "%%~G"
	IF NOT EXIST "%%~DPH" MD "%%~DPH"
	IF EXIST "%%~H" (
		NIRCMD KILLPROCESS "%%~H"
		%KMD% /D /C MoveIt.bat "%%~H" "ND_"
		)
	IF NOT EXIST "%%~H" (
		COPY /Y /B "%%~G" "%%~H" &&ECHO."%%~G"	"%%~H"	"%SystemDrive%\Qoobox\TestC%%~PNXG">>FCopy
			) ELSE (
		MD "%SystemDrive%\Qoobox\TestC%%~PG"
		COPY /Y /B "%%~G" "%SystemDrive%\Qoobox\TestC%%~PNXG" &&ECHO."%%~G"	"%%~H"	"%SystemDrive%\Qoobox\TestC%%~PNXG">>FCopy
		PEV MoveEx "%%~H"
		PEV MoveEx "%SystemDrive%\Qoobox\TestC%%~PNXG" "%%~H" &&TYPE myNul.dat >CFReboot.dat
		) )
IF EXIST FCopy IF NOT EXIST CFReboot.dat (
	SED "1,13!d;s/.*/	\x22&\x22	/" dnd.dat >cfscriptFCopy0k
	GREP -Fisqf cfscriptFCopy0K && TYPE myNul.dat >CFReboot.dat
	)
DEL /A/F/Q cfscriptFCopy0?



SED -r "/^Fmove::/I,/^(\{|\[|[[:alnum:]]{3}|$)|::/!d; /.:\\.*\|.*:\\/!d; /*|\?/d; s/\s+\|/\|/;s/\|\s+/\|/;s/\|/	/" Do.dat >Fmove
SED "s/	/\n/g" Fmove >cfscriptFMove00
GREP -Fisqxf dnd.dat cfscriptFMove00 && TYPE myNul.dat >Fmove
FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( Fmove ) DO @IF EXIST "%%~G" IF NOT EXIST "%%~G\" (
	ATTRIB -A -H -R -S "%%~G"
	IF NOT EXIST "%%~DPH" MD "%%~DPH"
	IF EXIST "%%~H" (
		NIRCMD KILLPROCESS "%%~H"
		%KMD% /D /C MoveIt.bat "%%~H" "ND_"
		)
	IF NOT EXIST "%%~H" COPY /Y /B "%%~G" "%%~H" && DEL /A/F "%%~G"
	IF EXIST "%%~G" (
		PEV MoveEx "%%~H"
		PEV MoveEx "%%~SG" "%%~H"
		IF NOT EXIST CFReboot.dat TYPE myNul.dat >CFReboot.dat
		) )
DEL /A/F/Q cfscriptFMove0?



SED -r "/^AWF::/I,/^(\{|\[|[[:alnum:]]{3}|$)|::/!d; /:\\.*\\bak\\[^\\]*$/I!d" Do.dat >cfscriptAWF00
@GREP -iq Domains:: Do.dat && ECHO."%cd%\0\bak\0.0">>cfscriptAWF00
GREP -Fixvf dnd.dat cfscriptAWF00 >cfscriptAWF01 &&@(
	ECHO.
	ECHO.[-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains]
	ECHO.[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains]
	ECHO.[-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges]
	ECHO.[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges]
	ECHO.[-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains]
	ECHO.[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains]
	ECHO.[-HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains]
	ECHO.[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains]
	ECHO.[-HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges]
	ECHO.[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges]
	ECHO.[-HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains]
	ECHO.[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains]
	)>>CregC.dat
SORT /M 65536 cfscriptAWF01 /O cfscriptAWF02
SED -r "$!N; /^(.*)\n\1$/I!P; D" cfscriptAWF02 >AWF
FOR /F "TOKENS=*" %%G IN ( AWF ) DO @IF EXIST "%%~G" IF NOT EXIST "%%~G\" (
	SWXCACLS "%%~G" /OA
	SWXCACLS "%%~G" /GA:F /Q
	ATTRIB -A -H -R -S "%%~G"
	IF EXIST "%%~DPG..\%%~NXG" (
		NIRCMD KILLPROCESS "%%~DPG..\%%~NXG"
		%KMD% /D /C MoveIt.bat "%%~DPG..\%%~NXG" "ND_"
		)
	IF NOT EXIST "%%~DPG..\%%~NXG" MOVE /Y "%%~G" "%%~DPG..\%%~NXG"
	IF EXIST "%%~G" (
		PEV MoveEx "%%~DPG..\%%~NXG"
		PEV MoveEx "%%~SG" "%%~DPG..\%%~NXG"
		IF NOT EXIST CFReboot.dat TYPE myNul.dat >CFReboot.dat
		) )
DEL /A/F/Q cfscriptAWF0?



SED "/^FireFox::/I,/^$/!d;" Do.dat >cfscriptFireFox00
GREP -i "^FF - ProfilePath -" cfscriptFireFox00 &&PEV -k Firefox.exe
SED -r "/^FF - ProfilePath - /!d; s///; s/^\s*//; s/\s*$//" cfscriptFireFox00 >FFProfilePath.dat
SETLOCAL
SET FFProfile=
FOR /F "TOKENS=*" %%G IN ( FFProfilePath.dat ) DO @SET "FFProfile=%%G"
DEL /A/F FFProfilePath.dat
SED -r "/^FF -/!d; s/FF - ProfilePath - //I; s/^FF - (prefs\.js|user\.js): (\S*) -.*/=\2/I" cfscriptFireFox00 >cfscriptFireFox01
SED ":a; $!N;s/\n=/|/;ta;P;D" cfscriptFireFox01 >cfscriptFireFox02
SED "/^.:\\/!d" cfscriptFireFox02 >cfscriptFireFox03
FOR /F "TOKENS=1* DELIMS=|" %%G IN ( cfscriptFireFox03
) DO @FOR %%I IN ( user.js prefs.js ) DO @IF EXIST "%%~G%%~I" (
	ATTRIB -H -R -S "%%~G%%~I"
	DEL /A/F "%%~G%%~I.BAK"
	COPY /Y "%%~G%%~I" "%%~G%%~I.BAK"
	SED -r "/^user_pref\(\x22(%%~H)\x22/Id" "%%~G%%~I.bak" >"%%~G%%~I"
	)
SED -r "/\.js - .*\x22general.config.filename\x22.*/I!d; s//.js/" cfscriptFireFox00 >cfscriptFireFox04
FOR /F "TOKENS=*" %%G IN ( cfscriptFireFox04 ) DO @(
	ATTRIB -H -R -S "%%~G"
	DEL /A/F "%%~G.BAK"
	COPY /Y "%%~G" "%%~G.BAK"
	SED -r "/\x22general.config.filename\x22/Id" "%%~G.bak" >"%%~G"
	)
	
REM FF - HiddenExtension: that was retired on 10-12-12
SED -r "/FF - HiddenExtension: .*: (.*) - (.:\\.*)/I!d; s//\[HKEY_LOCAL_MACHINE\\SOFTWARE\\Mozilla\\Firefox\\Extensions]\n\x22\1\x22=-\n\2/" cfscriptFireFox00 >cfscriptFireFox05
SED "/^[a-z]:\\/I!d; s/.*/\x22&\x22/" cfscriptFireFox05 >>Cfolders.dat
REM oldish FF -Extension format that was replaced with FF - Ext: on 10-12-12
SED -r "/^FF - Extension: .* - (.:\\.*)/I!d; s//\1/; s/\s*$//; s/.*/\x22&\x22/" cfscriptFireFox00 >>Cfolders.dat
IF DEFINED FFProfile SED -r "/^FF - Ext: /I!d; s/ - %%profile%%\\extensions\\/ - %FFProfile:\=\\%extensions\\/; /.* - (.:\\.*)/!d; s//\1/; s/\s*$//; s/.*/\x22&\x22/" cfscriptFireFox00 >>Cfolders.dat
SED -r "/^FF - ExtSQL: .*; /I!d; s///; /.*(.:\\.*)/!d; s//\1/; s/\s*$//; s/.*/\x22&\x22/" cfscriptFireFox00 >>Cfiles.dat
SED "/^[a-z]:\\/Id;" cfscriptFireFox05 >>CregC.dat
SED -r "/FF - (Plugin|Component):/I!d; s/\x22//g; s/.*(.:\\.*)/\x22\1\x22/" cfscriptFireFox00 >>Cfiles.dat
DEL /A/F/Q cfscriptFireFox0?
ENDLOCAL



SED -r "/^SecCenter::/I,/^$/!d; /::|^$/d; s/\x22//g; s/.*\) //; s/.*(\{.{8}-.{4}-.{4}-.{4}-.{12}\}).*/\1/" Do.dat >cfscriptSecCenter00
FOR /F "TOKENS=*" %%G IN ( cfscriptSecCenter00 ) DO @(
	ECHO.>NewResident
	START NIRKMD CMDWAIT 5000 EXEC HIDE PEV -k CSCRIPT.%cfext%
	CSCRIPT //NOLOGO //E:VBSCRIPT //T:5 wmi_rem.vbs "%%~G"
	PEV -k NIRKMD.%cfext%
	)
IF EXIST NewResident (
	START NIRKMD CMDWAIT 9000 EXEC HIDE PEV -k CSCRIPT.%cfext%
	CSCRIPT //NOLOGO //E:VBSCRIPT //B //T:08 av.vbs
	PEV -k NIRKMD.%cfext%
	)
DEL /A/F/Q cfscriptSecCenter00 NewResident


SED -r -e "/^MIA::/I,/^([^\\]*$|$)/!d; s/\x22//g; /^(%%|[a-z]:\\)/I!d" -f ConEnv.sed -e "s/.*/\x22\0\x22/" Do.dat >MissingFiles.dat

GREP -Eisq "Group(File|Folder)::" Do.dat && CALL :GroupFs


SED -r -e "/^Restore::/I,/^([^\\]*$|$)/!d; s/\x22//g; /^(%%|[a-z]:\\)/I!d; /*|\?/d" -f ConEnv.sed -e "s/.*/\x22\0\x22/" Do.dat >cfscriptRestore00
SORT /M 65536 cfscriptRestore00 | SED -r "$!N; /^(.*)\n\1$/I!P; D" >cfscriptRestore01
FOR /F "TOKENS=*" %%G IN ( cfscriptRestore01 ) DO @%KMD% /D /C ND_.bat "%%~G"
DEL /A/F/Q cfscriptRestore0?


@GREP -iq ClearJavaCache:: Do.dat &&(
	FOR /F "TOKENS=*" %%G IN ( Profiles.Folder.dat ) DO @IF EXIST "%%~G\AppData\LocalLow\Sun\Java\Deployment\cache\" ECHO."%%~G\AppData\LocalLow\Sun\Java\Deployment\cache\">>ClearJavaCache
	FOR /F "TOKENS=*" %%G IN ( AppData.Folder.dat ) DO @IF EXIST "%%~G\Sun\Java\Deployment\cache\" ECHO."%%~G\Sun\Java\Deployment\cache\">>ClearJavaCache
	FOR /F "TOKENS=*" %%G IN ( LocalAppData.Folder.dat ) DO @IF EXIST "%%~G\Sun\Java\Deployment\cache\" ECHO."%%~G\Sun\Java\Deployment\cache\">>ClearJavaCache
	IF EXIST ClearJavaCache FOR /F "TOKENS=*" %%G IN ( ClearJavaCache ) DO @(
			RD /S/Q "%%~G"
			PEV -tf "%%~G\*" >>Cfiles.dat
			IF NOT EXIST "%%~G" MD "%%~G"
			)
		)

@GOTO :EOF




:Upload
@IF NOT EXIST Upload00 GOTO :EOF


@FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( Upload00 ) DO @(
	@ECHO.^<html^>
	@ECHO.^<head^>^<meta http-equiv="content-type" content="text/html;"^>^</head^>
	@ECHO.^<body^>^<b^>^<br^> - - ComboFix - - -^</b^>^<br^>^<br^>
	@ECHO.^<span^>^&nbsp;^&nbsp;^&nbsp;^&nbsp;^</span^>
	@ECHO.^<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&amp;business=combofix%%40live%%2ecom&amp;item_name=ComboFix&amp;no_shipping=0&amp;no_note=1&amp;tax=0&amp;currency_code=USD&amp;bn=PP%%2dDonationsBF&amp;charset=UTF%%2d8"^>
	@ECHO.^<img src="QooBox\image001.gif" v:shapes="_x0000_i1103" width="62" border="0" height="31"^>^</a^>^<br^>^<br^>
	@REM ECHO.Submit malware to Bleeping Computer for analysis.
	@ECHO.%Line34%
	@ECHO.^<br /^>^<br /^>
	@ECHO.^<form enctype="multipart/form-data" action="http://www.bleepingcomputer.com/submit-malware.php" method="post"^>
	 @ECHO.^<input name="MAX_FILE_SIZE" value="5120000" type="hidden"^>
	@ECHO.^<input name="User" value="Submitted via ComboFix." type="hidden"^>
	@ECHO.^<input name="Referer" value="%%~H" type="hidden"^>
	@ECHO.^<input name="channel" value="%channel%" type="hidden"^>
	@ECHO.^<input name="userfile" size="65" type="file"^>
	@ECHO.^<input value="Send" type="submit"^>^<br^>^<br^>
	@REM ECHO.Copy/Paste the filepath below into the box above and click Send
	@ECHO.%Line35%
	@ECHO.^<br /^>^<br /^>^<i^>File path ---^&gt; ^</i^>^<B^>
	@ECHO.%%~G
	@ECHO.^</B^>^</form^>^</body^>^</html^>
	)>\QooBox\CF-Submit.htm

@DEL /A/F Upload00
@GOTO :EOF


:EOF_
@DEL /A/F/Q cfscriptHttp0?
@ECHO.It's dangerous for untrained personel to run CFScript !! -^> >CatchZipped.dat
@GOTO :EOF

:GroupFs
@FOR %%G IN (
Drive
Appdata
cache
Cookies
desktop
favorites
localappdata
localsettings
mypictures
personal
Profiles
programs
startmenu
startup
templates
	) DO @(
	SED -r -e "/^%%GGroupFile::/I,/^([^\\]{2}|$)/!d; s/\x22//g; /^\\/!d; s/\\/&&/g; s/&/\\&/g" Do.dat >cfscript%%GFile00
	SED ":a; $!N; s/\n/\\x22\\n\\x22\&/; ta; s/.*/\\x22\&&\\x22/" cfscript%%GFile00 >cfscript%%GFile01
	FOR /F "TOKENS=*" %%H IN ( cfscript%%GFile01 ) DO @SED "s/\x22//g; s/.*/%%H/" %%G.folder.dat >>cfscriptGroupFiles
	SED -r -e "/^%%GGroupFolder::/I,/^([^\\]{2}|$)/!d; s/\x22//g; /^\\/!d; s/\\/&&/g; s/&/\\&/g" Do.dat >cfscript%%GFolder00
	SED ":a; $!N; s/\n/\\x22\\n\\x22\&/; ta; s/.*/\\x22\&&\\x22/" cfscript%%GFolder00 >cfscript%%GFolder01
	FOR /F "TOKENS=*" %%H IN ( cfscript%%GFolder01 ) DO @SED "s/\x22//g; s/.*/%%H/" %%G.folder.dat >>cfscriptGroupFolders
	DEL /A/F/Q cfscript%%GFile0? cfscript%%GFolder0?
	)
@GREP -Fs :\ cfscriptGroupFiles >>CFiles.dat
@GREP -Fs :\ cfscriptGroupFolders >>CFolders.dat
@DEL /A/F cfscriptGroupFiles cfscriptGroupFolders
@GOTO :EOF


:SRPEEK_A
@PUSHD %1
@TYPE change.log* | GSAR -F -s:x1A -r > "%~DP0cfscriptSrPeek01"
@START NircmdB.exe cmdwait 10000 KillProcess SED.%cfExt%
@SED -r "s/\x00//g; s/\x22\x05/\x00/g; s/\\[[:print:]]*\x00A/\n%systemdrive%&/Ig" "%~DP0cfscriptSrPeek01" |(
	SED -r "/^.:\\.*\\(%~2)\x00/I!d; s/\x00(A.{11}).*/	%cd:\=\\%\\\1/" )>>"%~DP0cfscriptSrPeek02"
@PEV -k NircmdB.exe
@POPD
@DEL /A/F cfscriptSrPeek01
@GOTO :EOF




