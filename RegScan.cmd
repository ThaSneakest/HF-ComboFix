

@IF EXIST W6432.dat (
	SET "RegWow64=Wow6432Node\"
	SET "Orphan64=Wow6432Node-"
	ECHO.REGEDIT4 >CregCx64.dat
	ECHO.>>CregCx64.dat
	)


:: ECHO.(((((((((((((((((((((((((((((((((((((   Reg Loading Points   ))))))))))))))))))))))))))))))))))))))))))))))))))>>ComboFix.txt
@ECHO.%Line42%>>ComboFix.txt
START NIRCMD CMDWAIT 26000 EXEC HIDE PEV -k CSCRIPT.%cfext%
IF NOT EXIST Vista.krl NIRCMD exec hide %KMD% /C CSCRIPT //E:VBSCRIPT //NOLOGO //T:25 SvcDrv.vbs




@ECHO.>>ComboFix.txt
@ECHO.>>ComboFix.txt
:: ECHO.*Note* empty entries ^& legit default entries are not shown >>ComboFix.txt
@ECHO.%Line23% >>ComboFix.txt
@ECHO.REGEDIT4>>ComboFix.txt



@IF NOT EXIST cfdummy REGT /S CregC.dat >N_\%random% 2>&1

SWREG EXPORT "HKCU\Software\Microsoft\Internet Explorer\URLSearchHooks" ToolB-00 /NT4
SED -r "/^\x22(.*)\x22=.*/!d; s//\1/" ToolB-00 >uURLSearchHooks01
GREP -Fvif clsid.dat uURLSearchHooks01 >uURLSearchHooks02

FOR /F "TOKENS=*" %%G IN ( uURLSearchHooks02 ) DO @(
	SWREG QUERY "HKCR\CLSID\%%G\InprocServer32" /ve >uURLSearchHooks03
	SED "/.*	/!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" uURLSearchHooks03 >uURLSearchHooks04
	GREP -s . uURLSearchHooks04 >uURLSearchHooks05 ||(
		ECHO."%%~G"	"URLSearchHooks">ToolB-Orph
		CALL :ToolB-Orph
		)
	FOR /F "TOKENS=*" %%I in ( uURLSearchHooks05 ) DO @ECHO."%%~I"|GREP -Fsq "?" &&(
			ECHO."%%G"= "%%~I" [?]>>uURLSearchHooks06
		)|| IF EXIST "%%~F$PATH:I" (
			PEV -fs32 -rtf -c:#"%%G"= "%%~I" [#m #u]# "%%~F$PATH:I" >>uURLSearchHooks06
		) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\URLSearchHooks-%%~G.reg.dat" (
			ECHO."%%G"= "%%~I" [BU]>>uURLSearchHooks06
		) ELSE (
			ECHO."%%~G"	"URLSearchHooks"	"%%~I">ToolB-Orph
			CALL :ToolB-Orph
			)
	DEL /A/F uURLSearchHooks03  uURLSearchHooks04 uURLSearchHooks05
	)

IF EXIST uURLSearchHooks06 GREP -Fsq = uURLSearchHooks06 &&(
	ECHO.>>ComboFix.txt
	ECHO.[HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\URLSearchHooks]>>ComboFix.txt
	TYPE uURLSearchHooks06 >>ComboFix.txt
	FOR /F "delims==" %%G in ( uURLSearchHooks06 ) DO @(
		SWREG QUERY "HKCR\CLSID\%%~G" /s >uURLSearchHooks07
		SED -n -r -f toolbar.sed uURLSearchHooks07 >uURLSearchHooks08
		SED "s/^HKEY.*/[&]/" uURLSearchHooks08 >>ComboFix.txt
		DEL /A/F uURLSearchHooks07 uURLSearchHooks08
		) )
DEL /A/F/Q ToolB-0? uURLSearchHooks0?




SWREG QUERY "HKLM\software\%RegWow64%microsoft\windows\currentversion\explorer\browser helper objects" >RegBho0A
SED "/{/!d; s/.*{/{/ " RegBho0A >RegBho0B
FINDSTR -VILG:clsid.dat RegBho0B >RegBho0C

FOR /F "TOKENS=*" %%G IN ( RegBho0C ) DO @(
	SWREG QUERY "HKCR\CLSID\%%G\InprocServer32" /ve >RegBho0D
	SED "/.*	/!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" RegBho0D >RegBho0E
	GREP -s . RegBho0E >RegBho0F ||(
		ECHO."%%~G">Bho-Orph
		CALL :Bho-Orph
		)>N_\%random%
	FOR /F "TOKENS=*" %%I IN ( RegBho0F ) DO @ECHO."%%~I"|GREP -Fsq "?" &&(
			ECHO.
			ECHO.[HKEY_LOCAL_MACHINE\~\Browser Helper Objects\%%G]
			ECHO.%%~I [?]
		)|| IF EXIST "%%~F$PATH:I" (
			ECHO.
			ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%~\Browser Helper Objects\%%G]
			PEV -fs32 -rtf -c:##m#b#u#b#t#b#f# "%%~F$PATH:I"
		) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%BHO-%%~G.reg.dat" (
			ECHO.
			ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%~\Browser Helper Objects\%%G]
			ECHO.%%~I [BU]
		) ELSE (
			ECHO."%%~G"	"%%~I">Bho-Orph
			CALL :Bho-Orph >N_\%random%
			)
	DEL /A/F RegBho0D RegBho0E  RegBho0F >N_\%random%
	)>>ComboFix.txt
DEL /A/F/Q RegBho0? temp0? N_\*




SWREG EXPORT "HKLM\software\%RegWow64%microsoft\internet explorer\toolbar" ToolB-00 /NT4
SED -r "/^\x22(.*)\x22=.*/!d; s//\1/" ToolB-00 >mToolbar01
GREP -Fvif clsid.dat mToolbar01 >mToolbar02

FOR /F "TOKENS=*" %%G IN ( mToolbar02 ) DO @(
	SWREG QUERY "HKCR\CLSID\%%G\InprocServer32" /ve >mToolbar03
	SED "/.*	/!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" mToolbar03 >mToolbar04
	GREP -s . mToolbar04 >mToolbar05 ||(
		ECHO."%%~G"	"Toolbar">ToolB-Orph
		CALL :ToolB-Orph
		)
	FOR /F "TOKENS=*" %%H IN ( mToolbar05 ) DO @ECHO."%%~H"|GREP -Fsq "?" &&(
			ECHO."%%G"= "%%~H" [?]>>mToolbar06
		)|| IF EXIST "%%~F$PATH:H" (
			PEV -fs32 -rtf -c:#"%%G"= "%%~H" [#m #u]# "%%~F$PATH:H" >>mToolbar06
		) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%Toolbar-%%~G.reg.dat" (
			ECHO."%%G"= "%%~H" [BU]>>mToolbar06
		) ELSE (
			ECHO."%%~G"	"Toolbar"	"%%~H">ToolB-Orph
			CALL :ToolB-Orph
			)
	DEL /A/F mToolbar03 mToolbar04 mToolbar05
	)

IF EXIST mToolbar06 GREP -Fsq = mToolbar06 &&(
	ECHO.>>ComboFix.txt
	ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Internet Explorer\Toolbar]>>ComboFix.txt
	TYPE mToolbar06 >>ComboFix.txt
	FOR /F "DELIMS==" %%G in ( mToolbar06 ) DO @(
		SWREG QUERY "HKCR\CLSID\%%~G" /s >mToolbar07
		SED -n -r -f toolbar.sed mToolbar07 >mToolbar08
		SED "s/^HKEY.*/[&]/" mToolbar08 >>ComboFix.txt
		DEL /A/F mToolbar07 mToolbar08
		) )
DEL /A/F/Q ToolB-00 mToolbar0?




SWREG EXPORT "hkcu\software\%RegWow64%microsoft\internet explorer\toolbar\webbrowser" ToolB-01 /NT4
SED "s/^  //;" ToolB-01 >ToolB-02
SED ":a;/\\$/N; s/\\\n//; ta" ToolB-02 >ToolB-00
SED -r "/^\x22({.*})\x22=.*/!d; s//\1/" ToolB-00 >uWebBrowser01
GREP -Fvif clsid.dat uWebBrowser01 >uWebBrowser02
DEL /A/F ToolB-01 ToolB-02

FOR /F "TOKENS=*" %%G IN ( uWebBrowser02 ) DO @(
	SWREG QUERY "HKCR\CLSID\%%G\InprocServer32" /ve >uWebBrowser03
	SED "/.*	/!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" uWebBrowser03 >uWebBrowser04
	GREP -s . uWebBrowser04 >uWebBrowser05 ||(
		ECHO."%%~G"	"WebBrowser">ToolB-Orph
		CALL :ToolB-Orph
		)
	FOR /F "TOKENS=*" %%I in ( uWebBrowser05 ) DO @ECHO."%%~I"|GREP -Fsq "?" &&(
		ECHO."%%G"= "%%~I" [?]>>uWebBrowser06
			)|| IF EXIST "%%~F$PATH:I" (
		PEV -fs32 -rtf -c:#"%%G"= "%%~I" [#m #u]# "%%~F$PATH:I" >>uWebBrowser06
			) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%WebBrowser-%%~G.reg.dat" (
		ECHO."%%G"= "%%~I" [BU]>>uWebBrowser06
			) ELSE (
			ECHO."%%~G"	"WebBrowser"	"%%~I">ToolB-Orph
			CALL :ToolB-Orph
			)
	DEL /A/F uWebBrowser03 uWebBrowser04 uWebBrowser05
	)

IF EXIST uWebBrowser06 GREP -Fsq = uWebBrowser06 &&(
	ECHO.>>ComboFix.txt
	ECHO.[HKEY_CURRENT_USER\%RegWow64%Software\Microsoft\Internet Explorer\Toolbar\Webbrowser]>>ComboFix.txt
	TYPE uWebBrowser06 >>ComboFix.txt
	FOR /F "delims==" %%G in ( uWebBrowser06 ) DO @(
		SWREG QUERY "HKCR\CLSID\%%~G" /s >uWebBrowser07
		SED -n -r -f toolbar.sed uWebBrowser07 >uWebBrowser08
		SED "s/^HKEY.*/[&]/" uWebBrowser08 >>ComboFix.txt
		DEL /A/F uWebBrowser07 uWebBrowser08
		) )
DEL /A/F/Q ToolB-00 uWebBrowser0?




@(
ECHO.	{750fdf0e-2a26-11d1-a3ea-080036587f03}
ECHO.	{4E77131D-3629-431c-9818-C5679DC83E81}
ECHO.	{99FD978C-D287-4F50-827F-B2C658EDA8E7}
ECHO.	{AB5C5600-7E6E-4B06-9197-9ECEF74D31CC}
ECHO.	{920E6DB1-9907-4370-B3A0-BAFC03D81399}
ECHO.	{16F3DD56-1AF5-4347-846D-7C10C4192619}
ECHO.	{2916C86E-86A6-43FE-8112-43ABE6BF8DCC}
ECHO.	{b32a6748-f273-4546-b60a-3c5adc239de5}
ECHO.	{36A21736-36C2-4C11-8ACB-D4136F2B57BD}
ECHO.	{EA5A76F7-8138-4B53-B0F5-ADCC730CAFBD}
ECHO.	{666C7833-A9B6-4AB4-94ED-DC238C81E925}
ECHO.	{1F038B9D-83F5-4b28-BA76-8654EC297DD6}
ECHO.	{A825576B-0042-4F0F-8FB0-93CE0F054E69}
ECHO.	{5d1cb710-1c4b-11d4-bed5-005004b1f42f}
ECHO.	{5d1cb711-1c4b-11d4-bed5-005004b1f42f}
ECHO.	{5d1cb712-1c4b-11d4-bed5-005004b1f42f}
ECHO.	{5d1cb713-1c4b-11d4-bed5-005004b1f42f}
ECHO.	{5d1cb714-1c4b-11d4-bed5-005004b1f42f}
ECHO.	{5d1cb715-1c4b-11d4-bed5-005004b1f42f}
ECHO.	{5d1cb716-1c4b-11d4-bed5-005004b1f42f}
ECHO.	{4433A54A-1AC8-432F-90FC-85F045CF383C}
ECHO.	{476D0EA3-80F9-48B5-B70B-05E677C9C148}
ECHO.	{F17C0B1E-EF8E-4AD4-8E1B-7D7E8CB23225}
ECHO.	{30351346-7B7D-4FCC-81B4-1E394CA267EB}
ECHO.	{30351347-7B7D-4FCC-81B4-1E394CA267EB}
ECHO.	{30351348-7B7D-4FCC-81B4-1E394CA267EB}
ECHO.	{3035134B-7B7D-4FCC-81B4-1E394CA267EB}
ECHO.	{3035134C-7B7D-4FCC-81B4-1E394CA267EB}
ECHO.	{3035134D-7B7D-4FCC-81B4-1E394CA267EB}
ECHO.	{3035134E-7B7D-4FCC-81B4-1E394CA267EB}
ECHO.	{D9144DCD-E998-4ECA-AB6A-DCD83CCBA16D}
IF EXIST W7.mac ECHO.	{08244EE6-92F0-47f2-9FC9-929BAA2E7235}
)>SIOI.dat

SWREG EXPORT "HKLM\software\%RegWow64%microsoft\windows\currentversion\explorer\shelliconoverlayidentifiers" mSIOI00 /NT4
SED ":a; $!N; s/]\n@=/	/I;ta;P;D" mSIOI00 >mSIOI0A
SED "/HKEY.*	/I!d; s/\[//; s/\x22//g" mSIOI0A >mSIOI01
GREP -Fivf SIOI.dat mSIOI01 >mSIOI02

FOR /F "TOKENS=1* DELIMS=	" %%G IN ( mSIOI02 ) DO @(
	SWREG QUERY "HKCR\CLSID\%%~H\InprocServer32" /ve >mSIOI03
	SED "/.*	/!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" mSIOI03 >mSIOI04
	GREP -s . mSIOI04 >mSIOI05 ||(
		ECHO."%%~H"	"ShellIconOverlayIdentifiers">ToolB-Orph
		CALL :ToolB-Orph
		ECHO.[-%%~G]>>CregC.dat
		ECHO.>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%ShellIconOverlayIdentifiers-%%~H.reg.dat"
		ECHO.[%%~G]>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%ShellIconOverlayIdentifiers-%%~H.reg.dat"
		ECHO.@="%%~H">>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%ShellIconOverlayIdentifiers-%%~H.reg.dat"
		)
	FOR /F "TOKENS=*" %%I in ( mSIOI05 ) DO @ECHO."%%~I"|GREP -Fsq "?" &&(
			SED "/./{H;$!d;};x;/%%~H/I!d" mSIOI00 >>ComboFix.txt
			ECHO.[HKEY_CLASSES_ROOT\CLSID\%%~H]>>ComboFix.txt
			ECHO.%%~I [?]>>ComboFix.txt
		)|| IF EXIST "%%~F$PATH:I" (
			SED "/./{H;$!d;};x;/%%H/I!d" mSIOI00 >>ComboFix.txt
			ECHO.[HKEY_CLASSES_ROOT\CLSID\%%~H]>>ComboFix.txt
			PEV -fs32 -rtf -c:##m#b#u#b#t#b#f# "%%~F$PATH:I" >>ComboFix.txt
		) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%ShellIconOverlayIdentifiers-%%~H.reg.dat" (
			SED "/./{H;$!d;};x;/%%H/I!d" mSIOI00 >>ComboFix.txt
			ECHO.[HKEY_CLASSES_ROOT\CLSID\%%~H]>>ComboFix.txt
			ECHO.%%~I [BU]>>ComboFix.txt
		) ELSE (
			ECHO."%%~H"	"ShellIconOverlayIdentifiers"	"%%~I">ToolB-Orph
			CALL :ToolB-Orph
			ECHO.[-%%~G]>>CregC.dat
			ECHO.>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%ShellIconOverlayIdentifiers-%%~H.reg.dat"
			ECHO.[%%~G]>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%ShellIconOverlayIdentifiers-%%~H.reg.dat"
			ECHO.@="%%~H">>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%ShellIconOverlayIdentifiers-%%~H.reg.dat"
			)
	DEL /A/F mSIOI03 mSIOI04 mSIOI05
	)

DEL /A/F/Q mSIOI0?




For %%G in (
\Qoobox\Quarantine\Registry_backups\%Orphan64%HKLM-Run-TFncKy.reg.dat
\Qoobox\Quarantine\Registry_backups\%Orphan64%HKLM-Run-NDSTray.exe.reg.dat
\Qoobox\Quarantine\Registry_backups\%Orphan64%HKLM-Run-CFSServ.exe.reg.dat
) DO @IF NOT EXIST %%G TYPE myNul.dat >%%G


IF EXIST RestoreRun CALL :RestoreO4

FOR %%G IN (
	"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
	"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run_CF"
	"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
	"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices"
	"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServicesOnce"
	"HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows\CurrentVersion\Run"
	"HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows\CurrentVersion\Run_CF"
	"HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows\CurrentVersion\RunOnce"
	"HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows\CurrentVersion\RunServices"
	"HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows\CurrentVersion\RunServicesOnce"
	"HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Run"
	"HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\RunOnce"
	"HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\RunServices"
	"HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce"
	"HKEY_LOCAL_MACHINE\software\microsoft\windows\Currentversion\policies\explorer\Run"
	"HKEY_CURRENT_USER\software\microsoft\windows\Currentversion\policies\explorer\Run"
	"HKEY_USERS\.DEFAULT\software\microsoft\windows\Currentversion\policies\explorer\Run"
) DO @(
	SWREG QUERY %%G > RegRunOriB
	GREP -Fsq "REG_NONE" RegRunOriB &&(
		SWREG EXPORT %%G NullReg.dat /NT4
		GREP -Fiv "=hex(0):" NullReg.dat > NullRegB.dat
		SWREG NULL DELETE %%G
		SWREG IMPORT NullRegB.dat
		DEL /A/F NullRegB.dat NullReg.dat RegRunOriB
		SWREG QUERY %%G > RegRunOriB
		)	
	REGT /a RegRuns00 %%G
	IF EXIST RegRuns00 (
		SED -r ":a;/\\$/N; s/\\\n  +//; ta" RegRuns00 > RegRunOri
		REM SWREG NULL QUERY %%G > RegRunOriB
		GREP -E ".{600}" RegRunOriB >RegRunOriC &&(
			ECHO.[%%~G]>>CregC.dat
			SED -r "/^   ([^\t]*)\t.*/!d; s//\x22\1\x22=-/" RegRunOriC >>CregC.dat
			)
		SED -r -e "/\\%%~NG$/I,/^$/!d" -f run.sed -e "/	/!d" RegRunOriB >RegRuns01
		SED -r -e "/?/d;" RegRuns01 | SED -r -e "/\....$|	$/!d; s/./%%~G	&/;" -f run2.sed >RegRuns02
		SED -r "/?/!d;" RegRuns01 | 	SED -r "s/(.*)	(.*)/\x22\1\x22=\x22\2\x22 [?]/" >RegRuns0A
		SED -r "/\....$|	$/d;" RegRuns01 | SED -r "/?/d;" | SED -r "s/(.*)	(.*)/\x22\1\x22=\x22\2\x22 [X]/" >>RegRuns0A
		CALL :RUNParse
		IF EXIST RegRuns0A FINDSTR = RegRuns0A &&(
			ECHO.
			ECHO.[%%~G]
			TYPE RegRuns0A
			)>>ComboFix.txt
		IF EXIST RegRuns0B FINDSTR = RegRuns0B &&(
			ECHO.
			ECHO.[%%~G]
			SED "s/\\/&&/g" RegRuns0B
			)>>CregC.dat
		DEL /A/F/Q RegRuns0? RegRunOri*
		))


For %%G in (
\Qoobox\Quarantine\Registry_backups\%Orphan64%HKLM-Run-TFncKy.reg.dat
\Qoobox\Quarantine\Registry_backups\%Orphan64%HKLM-Run-NDSTray.exe.reg.dat
\Qoobox\Quarantine\Registry_backups\%Orphan64%HKLM-Run-CFSServ.exe.reg.dat
) DO @IF EXIST %%G DEL /A/F %%G




IF EXIST StartupOrphans.txt DEL /A/F StartupOrphans.txt
NircmdB.exe exec hide pv.%cfExt% -d10000 -kf cscript.%cfext%
FOR /F "TOKENS=*" %%G IN ( Startup.folder.dat ) DO @(
	CSCRIPT //E:VBSCRIPT //NOLOGO //T:5 lnkread.vbs "%%~G"
	SED "/^desktop\.ini \[/Id; /./{H;$!d;}; x; /]/!d" StartupFolder00 >>ComboFix.txt
	DEL /A/F StartupFolder00
	)
NIRCMD killprocess NircmdB.exe

IF EXIST StartupOrphans.txt GREP -sq . StartupOrphans.txt &&(
	FOR /F "TOKENS=1 DELIMS=	" %%G IN ( StartupOrphans.txt ) DO @%KMD% /D /C MoveIt.bat "%%~G"
	SED -r "s/	/ - /" StartupOrphans.txt >>Orphans.dat
	DEL /A/F StartupOrphans.txt
	) >N_\%random% 2>&1



FOR %%G IN (
  "HKLM\software\microsoft\windows\currentversion\policies\system"
  "hkcu\software\microsoft\windows\currentversion\policies\system"
  "hku\.default\software\microsoft\windows\currentversion\policies\system"
  "HKLM\software\microsoft\windows\currentversion\policies\explorer"
  "hkcu\software\microsoft\windows\currentversion\policies\explorer"
  "hku\.default\software\microsoft\windows\currentversion\policies\explorer"
  "HKLM\software\microsoft\windows\currentversion\policies\explorer\disallowrun"
  "hkcu\software\microsoft\windows\currentversion\policies\explorer\disallowrun"
  "hku\.default\software\microsoft\windows\currentversion\policies\explorer\disallowrun"
) DO @(
	SWREG QUERY %%G >Policies00
	GREP -vif policies.dat Policies00 >Policies01
	SED -r "/_/!d; /	.*	$/d; s/^\S+/\n[&]/; s/ +/\x22/; s/	.*	/\x22= /" Policies01 >Policies02
	SED "/./{H;$!d;};x;/=/I!d" Policies02 >>ComboFix.txt
	DEL /A/F/Q Policies0?
	)




SWREG QUERY HKLM\software\policies\microsoft\windows\windowsupdate\au /v NoAutoUpdate  >NoAutoUpdate00
SED -r "1,4d;/0x0/Id; s/^H.*/[&]/; s/^ +/\x22/; s/	.*	/\x22= /" NoAutoUpdate00 | SED "/./{H;$!d;};x;/=/I!d" >>ComboFix.txt
DEL /A/F NoAutoUpdate00



SWREG QUERY "hkcu\software\microsoft\internet explorer\desktop\components" /s >DesktopComponents00
SED -r "/HKEY_|FriendlyName|Source.*:\\/I!d; s/	.*	/= /; s/^ +//; s/HKEY_.*/\n[&]/" DesktopComponents00 >DesktopComponents01
SED "/./{H;$!d;};x;/:/I!d" DesktopComponents01 >>ComboFix.txt
DEL /A/F/Q DesktopComponents0?



FOR %%G in (
	"hkey_local_machine\software\%RegWow64%microsoft\windows\currentversion\explorer\SharedTaskScheduler"
	"hkey_local_machine\software\%RegWow64%microsoft\windows\currentversion\explorer\ShellExecuteHooks"
) DO @(
	SWREG QUERY %%G  >022Orph0A
	SED -r "/	/!d; s/^ +//; s/	.+//" 022Orph0A >022Orph0B
	FINDSTR -vilg:clsid.dat 022Orph0B >022Orph00
	FOR /F "TOKENS=*" %%H in ( 022Orph00 ) DO @(
		SWREG QUERY "HKCR\CLSID\%%H\InprocServer32" /ve >022Orph0C
		SED "/.*	/!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" 022Orph0C >022Orph0D
		GREP -s .  022Orph0D >022Orph01 ||(
			ECHO."%%~G"	"%%~H">022-Orph
			CALL :022-Orph
			)
		FOR /F "TOKENS=*" %%I in ( 022Orph01 ) DO @ECHO."%%~I"|GREP -Fsq "?" &&(
			ECHO."%%H"= "%%~I" [?]>>022Orph02
				)|| IF EXIST "%%~F$PATH:I" (
			PEV -fs32 -rtf -c:#"%%H"= "%%~I" [#m #u]# "%%~F$PATH:I" >>022Orph02
				) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%%%~NG-%%~H.reg.dat" (
			ECHO."%%H"= "%%~I" [BU]>>022Orph02
				) ELSE (
			ECHO."%%~G"	"%%~H"	"%%~I">022-Orph
			CALL :022-Orph
			)
		DEL /A/F 022Orph01 022Orph0C 022Orph0D
		)
	@IF EXIST 022Orph02 (
		ECHO.
		ECHO.[%%~G]
		TYPE 022Orph02
		)>>ComboFix.txt
	DEL /A/F/Q 022Orph0? BHO00
	)




SWREG QUERY "HKLM\software\%RegWow64%microsoft\windows\currentversion\ShellServiceObjectDelayLoad" >temp0A
SED -r "/	/!d; s/^ +// " temp0A >temp0B
FINDSTR -vilg:clsid.dat temp0B >temp00
FOR /F "TOKENS=1,2* delims=	" %%G in ( temp00 ) DO @(
	SWREG QUERY "HKCR\CLSID\%%I\InprocServer32" /ve >temp0C
	SED "/.*	/!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" temp0C >temp0D
	GREP -s .  temp0D >temp01 ||(
		ECHO."%%~I"	"%%~G">SSODL-Orph
		CALL :SSODL-Orph
		)
	FOR /F "TOKENS=*" %%J IN ( temp01 ) DO @ECHO."%%~J"|GREP -Fsq "?" &&(
		@ECHO."%%G"= %%~I - %%~J [?]>>temp02
			)||IF EXIST "%%~F$PATH:J" (
		PEV -fs32 -rtf -c:#"%%G"= %%~I - %%~J [#m #u]# "%%~F$PATH:J" >>temp02
			) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%SSODL-%%~G-%%~I.reg.dat" (
		ECHO."%%G"= %%~I - %%~J [BU]>>temp02
			) ELSE (
		ECHO."%%~I"	"%%~G"	"%%~J">SSODL-Orph
		CALL :SSODL-Orph
		)
	DEL /A/F temp01 temp0C temp0D
	)

@IF EXIST temp02 (
	ECHO.
	ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad]
	TYPE temp02
	)>>ComboFix.txt
DEL /A/F/Q temp0? BHO00




@ECHO."Shell"="Explorer.exe">wlgn.dat
@ECHO."Userinit"="%SysDir:\=\\%\\userinit.exe,">>wlgn.dat
@ECHO."Userinit"="userinit.exe,">>wlgn.dat
@ECHO."UIHost"=hex(2):6c,6f,67,6f,6e,75,69,2e,65,78,65,00>>wlgn.dat
@ECHO."UIHost"="logonui.exe">>wlgn.dat
@ECHO."SFCDisable"=dword:00000000>>wlgn.dat
@ECHO."system"="">>wlgn.dat
@ECHO."TaskMan"="Taskmgr.exe">>wlgn.dat

SWREG EXPORT "hkcu\software\microsoft\windows nt\currentversion\winlogon"  temp00 /NT4
GREP -Fivxf wlgn.dat temp00 | SED -r "2,/^$/!d; /]|^\x22(Shell|Userinit|system|SFCDisable|UIHost|TaskMan)\x22=|^$/I!d; s.\\\\.\\.g" | SED "/./{H;$!d;};x;/=/I!d" >>ComboFix.txt
SWREG EXPORT "HKLM\software\microsoft\windows nt\currentversion\winlogon"  temp00 /NT4
GREP -Fivxf wlgn.dat temp00 | SED -r "2,/^$/!d; /]|^\x22(Shell|Userinit|system|SFCDisable|UIHost|TaskMan)\x22=|^$/I!d; s.\\\\.\\.g" | SED "/./{H;$!d;};x;/=/I!d" >>ComboFix.txt
DEL /A/F/Q temp0? wlgn.dat




SWREG QUERY "HKLM\software\microsoft\windows nt\currentversion\winlogon\notify" /s >temp00
SED -r -f env.sed -e "/notify\\[^\\]*$|DLLName	/I!d; s/.*	/=/;" temp00 | SED ":a; $!N; s/\n=/	/;ta;P;D" >temp01
GREP -Fivf notifykeysB.dat temp01 >temp02
SED -r "/?/!d; s/(.*)	(.*)/\n[\1]\n\2 [?]/" temp02 >>ComboFix.txt
FINDSTR -v ? temp02 >temp03

FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp03 ) DO @IF EXIST "%%~F$PATH:H" (
	ECHO.
	ECHO.[%%~G]
	PEV -fs32 -rtf -c:##m#b#u#b#t#b#f# "%%~F$PATH:H"
		)>>ComboFix.txt  ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Notify-%%~NG.reg.dat" (
	ECHO.
	ECHO.[%%~G]
	ECHO.%%~H [BU]
		)>>ComboFix.txt  ELSE (
	REGT /e /s "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Notify-%%~NG.reg.dat" "%%~G"
	ECHO.[-%%~G]>>CregC.dat
	ECHO.Notify-%%~NG - %%~H>>Orphans.dat
	)
DEL /A/F/Q temp0? notifykeys?.dat



SWREG QUERY "hkcu\software\microsoft\windows nt\currentversion\windows" >temp00

SED -r "/^HKEY_|^ +load	.*	./I!d; s/^   /\x22/; s/	.*	/\x22=/; s/^HKEY.*/\n[&]/ " temp00 |(
	SED "/./{H;$!d;};x;/=/I!d" )>>ComboFix.txt

DEL /A/F/Q temp0?

@IF NOT EXIST Vista.krl CALL RKEY.cmd
SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs >temp00
SWREG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs
SED -r "/.*	/!d;s///;s/[ ,]/\n/g" temp00 | GREP -Fiv "winmm.dll"  >temp01

FOR /F %%G IN ( temp01 ) DO @FINDSTR -MR "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" "%%~F$PATH:G" >>temp02
IF EXIST temp02 (
	SED ":a;$!N;s/\n/ /;ta" temp02 >temp03
	FOR /F "TOKENS=*" %%G IN ( temp03 ) DO @SWREG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows NT\CurrentVersion\Windows" /V AppInit_DLLs /D "%%G"
	)

SWREG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows NT\CurrentVersion\Windows" >temp00
@IF NOT EXIST Vista.krl CALL RKEY.cmd RKEYB
SED -r "/^HKEY_|pInit_Dlls	.*	./I!d; s/^   /\x22/; s/	.*	/\x22=/; /^.(RequireSignedAppInit_DLLs.=1|LoadAppInit_DLLs.=0)/Id; s/^HKEY.*/\n[&]/ " temp00 | SED "/./{H;$!d;};x;/=/I!d" >>ComboFix.txt
DEL /A/F/Q temp0?


SWREG EXPORT "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes" temp00 /NT4
SED -r "/^\x22(0|10|172\.(1[6-9]|2.|3[01])\.|192\.168|127|169\.254|224|255)\./d; " temp00 | SED "/./{H;$!d;};x;/=/!d" >>ComboFix.txt
DEL /A/F/Q temp0?


@ECHO.=>Driver32
@ECHO.=cfhd.dll>>Driver32
@ECHO.=ctmm32.dll>>Driver32
@ECHO.=ctsyn32.dll>>Driver32
@ECHO.=ctwdm32.dll>>Driver32
@ECHO.=ff_vfw.dll>>Driver32
@ECHO.=mmdrv.dll>>Driver32
@ECHO.=serwvdrv.dll>>Driver32
@ECHO.=SYNCOR11.DLL>>Driver32
@ECHO.=wdmaud.drv>>Driver32
@ECHO.=usbkt1x1.dll>>Driver32
@ECHO.=mbx2midu.dll>>Driver32

@SWREG ACL "HKLM\SOFTWARE\%RegWow64%Microsoft\Windows NT\CurrentVersion\Drivers32" /RESET /Q
SWREG QUERY "HKLM\software\%RegWow64%microsoft\windows nt\currentversion\Drivers32" >temp00
SED -r "s/^H.*/[&]/; /^ +/{/^ +(aux|mixer|midi|wave)(|[0-9]*)	.*	/I!d; s//\x22\1\2\x22=/;};$G" temp00 | FINDSTR -EVG:Driver32 >temp02
SED "/./{H;$!d;};x;/=/I!d" temp02 >>ComboFix.txt
DEL /A/F/Q temp0?



SWREG QUERY "HKLM\software\%RegWow64%Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /s >temp00
SED -r "/^H|^ +Debugger	/I!d" temp00 >temp01
SED -r ":a; $!N; s/\n +(debugger)	.*	/	\x22\1\x22=/I;ta;P;D" temp01 >temp02
SED -r "/^H.*\\Your Image File Name Here without a path/Id" temp02 >temp03
SED -r "/\x22=/!d;" temp03 >temp04
SED -r "s/(.*)	(.*)/\n[\1]\n\2/" temp04 >>ComboFix.txt
DEL /A/F/Q temp0?



SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" >temp00
SED -r "/^H.*session manager$/I, /^$/!d; /^H|BootExecute	Reg_/I!d ; s/\\0\\0$//; /reg_multi_sz +	autocheck autochk \*($|\\0lsdelete$)/Id; s/^H.*/\n[&]/I; s/^ +//;" temp00 >temp01
SED "/./{H;$!d;};x;/	/I!d" temp01 >>ComboFix.txt
DEL /A/F/Q temp0?



@IF NOT EXIST PathSearch ECHO."%PATH%";| SED "s/\x22//g; s/\(\\\|\);/\\*\n/g" | SED "/.:\\./!d;"| SED ":a; $!N; s/\n/\x22 or \x22/; ta; s/.*/\x22&\x22/" >PathSearch
@(
ECHO.authentication packages	msv1_0
ECHO.notification packages	scecli
)>packages

FOR /F "TOKENS=1,* DELIMS=	" %%G IN ( packages ) DO @(
	SWREG QUERY "hklm\system\currentcontrolset\control\lsa" /v "%%~G" >LSA00
	SED "/	/!d;s/.*	//;:a;s/\\0$//;ta;s/\\0/\n/g" LSA00 |SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" >LSA01
	FOR /F "TOKENS=*" %%I IN ( LSA01 ) DO IF /I "%%~I" equ "%%~H" (
		ECHO.%%~I>>LSA02
	) ELSE IF /I "%%~XI" equ "" (
		FOR /F "TOKENS=*" %%X IN ( PathSearch ) DO @PEV -fs32 -limit:1 -rtf "%%~I.dll" or { %%X } and "%%~I.dll" >AuthenticationPackages00 &&ECHO.%%~I>>LSA02
	) ELSE 	FOR /F "TOKENS=*" %%X IN ( PathSearch ) DO @PEV -fs32 -limit:1 -rtf "%%~I" or { %%X } and "%%~I" >AuthenticationPackages00 &&ECHO.%%~I>>LSA02
	IF EXIST LSA02 (
		SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" LSA02 |SED ":a; $!N; s/\n/\\0/g; ta" >LSA03
		FOR /F "TOKENS=*" %%I IN ( LSA03 ) DO @SWREG ADD "hklm\system\currentcontrolset\control\lsa" /v "%%~G" /t reg_multi_sz /d "%%I"
	) ELSE SWREG ADD "hklm\system\currentcontrolset\control\lsa" /v "%%~G" /t reg_multi_sz /d "%%I"
	DEL /A/F/Q LSA0?
	)
DEL /A/F packages


SWREG QUERY HKLM\system\currentcontrolset\control\lsa >temp00
SED -r "/\\|Packages	/I!d; /lsa\\/d; s/\\0/ /g; s/^ +//; s/ +$//g; /reg_multi_sz +	(msv1_0($| relog_ap$)|kerberos msv1_0 schannel($| wdigest($| tspkg($| pku2u($| livessp$))))|scecli$)/Id; s/HKEY.*/\n[&]/" temp00 >temp01
SED "/./{H;$!d;};x;/	/I!d" temp01 >>ComboFix.txt
DEL /A/F/Q temp0?


SWREG QUERY "HKCU\Keyboard Layout\Preload" >temp01
SED "/.*\t/!d; s///;" temp01 | SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" >temp02
(FOR /F "TOKENS=*" %%G IN ( temp02 ) DO SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%%G" )>temp03
FINDSTR -ELIVG:"imefile.dat" temp03 > temp04
SED -r "/^(HK| +Ime file	|$)/I!d; s/^HK.*/[&]/" temp04 | SED -r "/./{H;$!d;};x;/\n +Ime file\t/I!d;" >>ComboFix.txt
DEL /A/F/Q temp0?


SWREG QUERY "HKLM\software\microsoft\windows\currentversion\group policy\state" /s >temp00
SED -r "/hkey_|script	/I!d; s/^ +/\x22/; s/	.*	/\x22=/; s/HKEY_.*/\n[&]/ " temp00 >temp01
SED "/./{H;$!d;};x;/=/I!d" temp01 >>ComboFix.txt
DEL /A/F/Q temp0?



SWREG QUERY "HKLM\system\currentcontrolset\control\securityproviders" >temp00
SED -r "/	msapsspc.dll, schannel.dll, digest.dll, msnsspc.dll($|, credssp.dll$)|	credssp.dll$/Id; s/^ +//; s/	.*	/	/; s/HKEY.*/\n[&]/ " temp00 >temp01
SED "/./{H;$!d;};x;/	/I!d" temp01 >>ComboFix.txt
DEL /A/F/Q temp0?




SWREG QUERY "HKLM\system\currentcontrolset\control\safeboot\minimal" /s >safeboot00
SED "/hkey.*minimal\\/I!d;{s///; $!N; s/\n/=/; s/=.*	/=/;}" safeboot00 >SafeBootKeys.dat
@ECHO.::::>>SafeBootKeys.dat

FINDSTR -vilxg:SafeBootKeys.dat safeboot.dat >failsafe &&(
	CALL :SAFEBOOTREPAIR
	SWREG QUERY "HKLM\system\currentcontrolset\control\safeboot\minimal" /s >safeboot01
	SED "/hkey.*minimal\\/I!d;{s///; $!N; s/\n/=/; s/=.*	/=/;}" safeboot01 >SafeBootKeys.dat
	@ECHO.::::>>SafeBootKeys.dat
	FINDSTR -vilxg:SafeBootKeys.dat safeboot.dat >failsafe &&(
		REM @ECHO.[COLOR=RED]SafeBoot registry key needs repairs. This machine cannot enter Safe Mode.[/COLOR]
		ECHO.
		@ECHO.[COLOR=RED] %LINE45% [/COLOR]
		SED "s/.*/\n[HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SafeBoot\\Minimal\\&\x22/; s/=/]\n@=\x22/" failsafe
		)>>ComboFix.txt
	)

FINDSTR -vilxg:safeboot.def.dat SafeBootKeys.dat >SafeBoot02

IF EXIST SvcList.dat (
	SED "/=DRIVER$/I!d; s///;" SafeBoot02 >SafeBootUnknownDriver
	FOR /F "TOKENS=*" %%G IN ( SafeBootUnknownDriver ) DO @FINDSTR -RIEC:"\\%%G \[[^]*]" SvcList.dat ||ECHO.%%G=Driver>>SafeBoot03
	)

SED "/=SERVICE$/I!d; s///" SafeBoot02 >SafeBootUnknownService
FOR /F "TOKENS=*" %%G IN ( SafeBootUnknownService
	) DO @SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%%G" ||ECHO.%%G=Service>>SafeBoot03

IF EXIST SafeBoot03 (
	FOR /F "TOKENS=1 DELIMS==" %%G IN ( SafeBoot03 ) DO @IF NOT EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\SafeBoot-%%G.reg.dat" (
		ECHO.SafeBoot-%%G>>Orphans.dat
		ECHO.[-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\%%G]>>CregC.dat
		ECHO.[-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\%%G]>>CregC.dat
		REGT /e /s "A%%G" "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\%%G"
		REGT /e /s "B%%G" "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\%%G"
		COPY /Y "?%%G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\SafeBoot-%%G.reg.dat"
		DEL /A/F/Q "?%%G"
		)
	FINDSTR -IVXG:SafeBoot03 SafeBoot02 >SafeBoot04
	MOVE /Y SafeBoot04 SafeBoot02
	)

SED "s/.*/\n[HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SafeBoot\\Minimal\\&\x22/; s/=/]\n@=\x22/" SafeBoot02 >>ComboFix.txt
@DEL /A/F/Q safeboot0? failsafe SafeBootKeys.dat SafeBootUnknown*

SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Option" /v "UseAlternateShell" >safeboot00
GREP -sC1 "HKEY" temp00 >temp01 &&(
	SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot" /v "AlternateShell" >temp02
	GREP -sC1 "HKEY" temp02 >>temp01
	SED -r "s/^HKEY.*/[&]/I; s/^   //; s/^AlternateShell.*	/\x22AlternateShell\x22= /I" temp01
	)>>ComboFix.txt
DEL /A/F/Q temp0?



SWREG QUERY "HKLM\software\microsoft\shared tools\msconfig\startupfolder" /s >temp00
SED -r "s/^[ ]*//; /folder\\|^path|^backup/I!d; s/	.*	/=/; s/HKEY_.*\\msconfig(.*)$/\n[HKLM\\~\1]/I" temp00 >>ComboFix.txt
DEL /A/F/Q temp0?

SWREG QUERY "HKLM\software\microsoft\shared tools\msconfig\startupreg" /s >temp00
SED -r -f run.sed -e "s/^[?]*//; /startupreg\\|^command/I!d; s/.*	/=/" temp00 | SED "/^HKEY/!d; :a; $!N; s/\n=/	/;ta;P;D" >temp0A
GREP -E "	$|^[^	]*$" temp0A >temp0B
SED "s/	//; s/.*/[-&]/" temp0B >>CregC.dat
SED "/	$/d" temp0A >temp01

SED -r "/?/!d; s/(.*)	(.*)/\n[\1]\n\2 [?]/" temp01 >>ComboFix.txt
SED -r "/?|\....$/d" temp01 >temp02
SED -r "s/(.*)	(.*)/\n[\1]\n\2 [X]/" temp02 >>ComboFix.txt
FINDSTR -v ? temp01| FINDSTR -r "\....$" >temp03

FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp03 ) DO @IF EXIST "%%~F$PATH:H" (
		ECHO.
		ECHO.[%%~G]
		PEV -fs32 -rtf -c:##m#b#u#b#t#b#f# "%%~F$PATH:H"
	)>>ComboFix.txt ELSE IF EXIST bak.dat (
		ECHO.
		ECHO.[%%~G]
		ECHO.%%~H [N/A]
	)>>ComboFix.txt ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\MSConfigStartUp-%%~NG.reg.dat" (
		ECHO.
		ECHO.[%%~G]
		ECHO.%%~H [BU]
	)>>ComboFix.txt ELSE (
		REGT /e /s "%SystemDrive%\Qoobox\Quarantine\Registry_backups\MSConfigStartUp-%%~NG.reg.dat" "%%~G"
		ECHO.[-%%~G]>>CregC.dat
		ECHO.MSConfigStartUp-%%~NG - %%~H>>Orphans.dat
		)
DEL /A/F/Q temp0?


for %%G in (
   "HKLM\software\microsoft\shared tools\msconfig\services"
   "hkcu\software\%RegWow64%microsoft\windows\currentversion\run-"
   "HKLM\software\%RegWow64%microsoft\windows\currentversion\run-"
   "HKLM\software\%RegWow64%microsoft\windows\currentversion\rundisabled"
   "HKLM\software\%RegWow64%microsoft\windows\currentversion\run-disabled"
   "HKLM\software\%RegWow64%microsoft\windows\currentversion\setup\disabledrunkeys"
   "HKLM\software\%RegWow64%microsoft\windows\currentversion\runservicesdisabled"
   "HKLM\software\%RegWow64%microsoft\windows\currentversion\runservices-"
   "hku\.default\software\microsoft\windows\currentversion\runservices-"
) DO @(
	SWREG QUERY %%G >temp00
	SED "/_/!d; s/^   /\x22/; s/	.*	/\x22=/; s/HKEY_.*/\n[&]/ " temp00 >temp01
	SED "/./{H;$!d;};x;/=/I!d" temp01
	DEL /A/F/Q temp0? >N_\%random%
	)>>ComboFix.txt



SWREG QUERY "HKLM\system\currentcontrolset\control\session manager\appcertdlls" >temp00
SED -r "/	|hkey_/I!d;" temp00 >temp01
SED -r "s/^ +//; s/^hkey_.*/[&]/I" temp01 >temp02
SED "/./{H;$!d;};x;/	/I!d" temp02 >>ComboFix.txt
DEL /A/F/Q temp0?



SWREG EXPORT  "HKLM\SOFTWARE\Microsoft\Security Center" temp00 /NT4
sed -r "/FirstRunDisabled|^@|oobe_av|VistaSp[12]|cval|00000000$/d" temp00 | SED "/./{H;$!d;};x;/=/I!d" >>ComboFix.txt
DEL /A/F/Q temp0?



IF EXIST xp.mac @(
	SWREG EXPORT "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\sharedaccess\parameters\firewallpolicy\standardprofile\authorizedapplications\list" temp00 /NT4
	SED -r "/\x22=(.{5}[^:*]*\....):.*/!d; s//\x22=-\t\1\x22/; s/%%commonProgramFiles%%/%commonProgFiles:\=\\%/Ig; s/%%programfiles%%/%ProgFiles:\=\\%/Ig; s/%%windir%%|%%systemroot%%/%systemroot:\=\\%/Ig;"  temp00 >temp01
	GREP -Fi "%CD:\=\\%" temp00 | SED "s/=.*/=-/" >temp02
	IF EXIST temp02 TYPE temp02 >>temp00
	FOR /F "TOKENS=1* DELIMS=	" %%G IN (temp01) DO @IF NOT EXIST %%H ECHO.%%G>>temp00
	SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\sharedaccess\parameters\firewallpolicy\standardprofile\GloballyOpenPorts\List" >temp03
	ECHO.[HKEY_LOCAL_MACHINE\system\currentcontrolset\services\sharedaccess\parameters\firewallpolicy\standardprofile\globallyopenports\list]>>temp00
	SED -r "/^ +(.*)	.*	.*:(browserctl|sfx|podmena|tgexhi|drv|sys|fio32|driver|webserver|ddnsfilter|websrvx|Google Port|MyOKOPort )$/I!d; s//\x22\1\x22=-/" temp03 >>temp00
	REGT /S temp00
	DEL /A/F/Q temp0?
	)




IF EXIST xp.mac @(
ECHO./^^^HKEY_^|	/I!d
ECHO./EnableFirewall.*0x1^|DoNotAllowExceptions^|DisableNotifications.*0x0^|:LocalSubNet:/Id
ECHO./:\*:/s/\\/\\\\/g
ECHO./\\.*:\*:/{s/:\*:.*//I; s/ +^([^^^ ].*^)	.*	\1/\x22\1\x22=/}
ECHO.s/:\*:Enabled//I
ECHO.s/^^^ +/\x22/
ECHO.s/	.*	/\x22= /
ECHO.s/^^^.*^(\\Services\\.*^)$/\n[HKLM\\~\1]/I
)>fwall

IF EXIST fwall SWREG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\sharedaccess\parameters\firewallpolicy\standardprofile" /s  >temp00 &&(
	SED -r -f fwall  temp00 | SED "/./{H;$!d;};x;/=/I!d" )>>ComboFix.txt

IF EXIST vista.krl @(
ECHO.1,4d
ECHO./^^^ +LogFileSize/Id
ECHO./^^^ +LogFilePath/Id
ECHO./^^^ +LogDroppedPackets/Id
ECHO./^^^ +LogSuccessfulConnections/Id
ECHO./^^^ +IPSecExempt/Id
ECHO./^^^ +DisableStatefulFTP.*0x0/Id
ECHO./^^^ +DisableStatefulPPTP.*0x0/Id
ECHO./^^^ +PolicyVersion/Id
ECHO./^^^ +DisableNotifications.*0x0/Id
ECHO./^^^ +EnableFirewall.*0x1/Id
ECHO./\^|Dir=Out\^|/Id
ECHO./\^|Action=Block\^|/Id
ECHO./\^|Svc=EventLog\^|/Id
ECHO./\^|Svc=DHCP\^|/Id
ECHO./\^|Svc=PolicyAgent\^|/Id
ECHO./\^|Svc=SNMPTRAP\^|/Id
ECHO./\^|Svc=PNRPSvc\^|/Id
ECHO./\^|Svc=P2PSvc\^|/Id
ECHO./\^|Svc=HomeGroupProvider^|/Id
ECHO./\^|Svc=PeerDistSvc:Allow incoming WSD to PeerDistSvc^|/Id
ECHO./\^|Svc=PeerDistSvc:Allow incoming TCP to PeerDistSvc^|/Id
ECHO./\^|EmbedCtxt=/d
ECHO.s/^^^.*^(\\Services\\.*^)$/\n[HKLM\\~\1]/I
ECHO.s/^^^ +/\x22/
ECHO.s/	.*	/\x22= /
ECHO.s/v2.0\^|//I
ECHO.s/\^|Edge=FALSE\^|//I
ECHO.s/\^|Edge=TRUE\^|//I
ECHO.s/Action=Allow\^|//I
ECHO.s/Active=TRUE\^|//I
ECHO.s/Active=FALSE\^|/Disabled:/I
ECHO.s/\^|Desc=[^^^|]*//I
ECHO.s/Dir=[^^^\^|]*\^|//I
ECHO.s/App=//I
ECHO.s/LPort=//I
ECHO.s/\^|RA[46]=/:/Ig
ECHO.s/\^|Name=/:/I
ECHO.s/Profile=[^^^\^|]*\^|//I
ECHO.s/Protocol=17\^|/TCP:/I
ECHO.s/Protocol=6\^|/UDP:/I
ECHO.s/=/\n=/
)>Vfwall

IF EXIST Vfwall SWREG QUERY "HKLM\system\currentcontrolset\services\sharedaccess\parameters\firewallpolicy" /s >temp00 &&(
	Sed -r -f Vfwall temp00 | SED "/^\x22/s/\\/\\\\/g;:a; $!N; s/\n=/=/;ta;P;D" | SED "/./{H;$!d;};x;/=/I!d" )>>ComboFix.txt



SWREG QUERY "%CS000%" >temp00
SED -r -e "/%CS000:\=\\%\\[^\\]*$/I!d; s/.*/[&]/wsys_enum.dat" -e "s/.*\\//g; s/]//g " temp00 >Service01
FINDSTR -VILXG:023.dat Service01 >temp02
SED "s/.*/	&;/" temp02 >SuspectSvc
ECHO.[%CS000%\PEVSystemStart]>>sys_enum.dat

IF EXIST Vista.krl (
	CALL :SvcDrvB
) ELSE PEV -fs32 -rtf -s+10000 .\svclist.dat &&(
	FINDSTR . SuspectSvc &&(
		FINDSTR -ILG:SuspectSvc svclist.dat >temp04
		SED -r -e "s/globalroot\\systemroot/%systemroot:\=\\%/I; s/	/ /" temp04 >temp05
		ECHO.>>ComboFix.txt
		SORT /M 65536 temp05 >>ComboFix.txt
		))|| CALL :SvcDrvB



@(
ECHO.fs_rec
ECHO.PROCEXP90
ECHO.GMER
ECHO.Catchme
ECHO.PEVSystemStart
ECHO.InCDrec
ECHO.MBR
ECHO.PROCEXP113
)>temp0K


SWREG QUERY HKLM\SYSTEM\CurrentControlSet\Enum\Root /S >Legacy00
SED -r "/./{H;$!d;};x;/\n +\*NewlyCreated\*	/!d;" Legacy00 >temp0G
SED -r "/^H.*\\Legacy_([^\\]*)\\.*/I!d; s//\1/" temp0G >temp0H
GREP -Fixvf temp0K temp0H >temp0I
SED "/./s/^/*NewlyCreated* - /" temp0I >temp0J


SWSC QUERY TYPE= ALL STATE= ALL | SED "/^SERVICE_NAME: /I!d; s///" >>temp0K
SED -R "/^[\S]*\s*/!d; s///; s/;.*//" svclist.dat >>temp0K
SED -r "/./{H;$!d;};x;/\nH.*\\root\\[^\\]*\\[^\\]*\\control\n/I!d;" Legacy00 >temp0L
SED -r "/^ +ActiveService	.*	/I!d; s///" temp0L >temp0M
SORT /M 65536 temp0M /T %cd% /O temp0N
SED -r "$!N; /^(.*)\n\1$/I!P; D" temp0N >temp0O
GREP -Fixvf temp0K temp0O >temp0P
SED "/./s/^/*Deregistered* - /" temp0P >>temp0J


GREP -sq . temp0J &&(
	ECHO.
	ECHO.--- %Other Services/Drivers In Memory% ---
	ECHO.
	TYPE temp0J
	)>>ComboFix.txt

DEL /A/F/Q temp0? Service01 SuspectSvc SCList SvcRegNotInSC Legacy00


@SETLOCAL
SET "__=HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows NT\CurrentVersion\Svchost"

SWREG QUERY "%__%" >temp00
SED -r "/^hkey.*\\svchost$/I,/^$/!d; s/^ +//g; /^(netsvcs|Local(Service|System)NetworkRestricted|(Local|Network)Service)	|^$/Id; s/(\\0)*$//; s/\\0/ /g; s/ +$//; s/HKEY.*/\n[&]/ " temp00 | GREP -xivf svchost.dat >temp01
SED "/./{H;$!d;};x;/	/I!d" temp01 >>ComboFix.txt
DEL /A/F/Q temp0?


SWREG QUERY "%__%" /v netsvcs >temp00
SED "/.*	/!d; s///; s/\\0/\n/g; s/\n*$//" temp00 >temp01
GREP -Fixvf netsvc.bad.dat temp01 >temp02
SED ":a;$!N; s/\n/\\0/g;ta;" temp02 >temp03
FOR /F "TOKENS=*" %%G IN ( temp03 ) DO @SWREG ADD "%__%" /v netsvcs /t reg_multi_sz /d "%%G"
IF EXIST W6432.dat (
	Set "NetSvcNmbr=35"
	GREP -Ev "IKEEXT|seclogon|AppInfo|MMCSS|browser|EapHost|hkmsvc|wercplsupport|ProfSvc|Themes|BDESVC" netsvc.dat > netsvc_x86.dat
	IF EXIST W8.mac Set "NetSvcNmbr=33"
	IF EXIST W8.mac GREP -Ev "IKEEXT|seclogon|AppInfo|MMCSS|browser|EapHost|hkmsvc|wercplsupport|ProfSvc|Themes|BDESVC|AudioSrv|TermService" netsvc.dat > netsvc_x86.dat
	) ELSE (
	SET "NetSvcNmbr=41"
	IF EXIST W8.mac Set "NetSvcNmbr=44"
	COPY /Y netsvc.dat netsvc_x86.dat
	)
GREP -c . temp02 >count


FOR /F "TOKENS=*" %%G IN (count ) DO @IF "%%G" LSS "%NetSvcNmbr%" (
	ECHO.
	ECHO.%__%  - NetSvcs
	ECHO.%Line83%
	REM ECHO.[COLOR=RED]NETSVCS REQUIRES REPAIRS - current entries shown[/COLOR]
	TYPE temp02
	ECHO.
	ECHO.%Line83b%
	REM ECHO.Rebuilding ... You need to reboot your machine for this to take effect.
	ECHO.
	ECHO.::::> temp0a
	TYPE temp02 >> temp0a
	GREP -Fivxf temp0a netsvc_x86.dat > temp0b
	TYPE temp0b >> temp0a
	TYPE temp0b >> temp02
	TYPE temp0b	
	IF EXIST svclist.dat (
		IF EXIST W6432.dat (
			SED -r "/\\syswow64\\svchost(\.exe|) +-k +netsvcs/I!d; s/^[^\t]*\t([^;]*);.*/\1/;" svclist.dat | GREP -Fivxf temp0a > temp0c
			) ELSE SED -r "/\\system32\\svchost(\.exe|) +-k +netsvcs/I!d; s/^[^\t]*\t([^;]*);.*/\1/;" svclist.dat | GREP -Fivxf temp0a > temp0c
		TYPE temp0c
		TYPE temp0c >> temp02
		)
	SED ":a;$!N; s/\n/\\0/g;ta;" temp02 >temp04
	FOR /F "TOKENS=*" %%H IN ( temp04 ) DO @SWREG ADD "%__%" /v netsvcs /t reg_multi_sz /d "%%H"
)>>ComboFix.txt ELSE GREP -sqxivf netsvc_x86.dat temp02 &&(
		ECHO.
		ECHO.%__%  - NetSvcs
		GREP -xivf netsvc_x86.dat temp02
		)>>ComboFix.txt

Set NetSvcNmbr=
DEL /A/F/Q temp0? count



IF EXIST Vista.krl (
	IF EXIST w7.mac (
		@ECHO.homegrouplistener>>LocalSystemNetworkRestricted.dat
		@ECHO.StorSvc>>LocalSystemNetworkRestricted.dat
		@ECHO.WdiServiceHost>>LocalService.dat
		@ECHO.sppuinotify>>LocalService.dat
		@ECHO.FontCache>>LocalService.dat
		@ECHO.lanmanworkstation>>NetworkService.dat
		@ECHO.BthHFSrv>>LocalServiceNetworkRestricted.dat
		@ECHO.homegroupprovider>>LocalServiceNetworkRestricted.dat
		)
	IF EXIST w8.mac (
		@ECHO.homegrouplistener>>LocalSystemNetworkRestricted.dat
		@ECHO.StorSvc>>LocalSystemNetworkRestricted.dat
		@ECHO.WiaRpc>>LocalSystemNetworkRestricted.dat
		@ECHO.DeviceAssociationService>>LocalSystemNetworkRestricted.dat
		@ECHO.svsvc>>LocalSystemNetworkRestricted.dat
		@ECHO.AllUserInstallAgent>>LocalSystemNetworkRestricted.dat
		@ECHO.fhsvc>>LocalSystemNetworkRestricted.dat
		@ECHO.vmickvpexchange>>LocalSystemNetworkRestricted.dat
		@ECHO.vmicshutdown>>LocalSystemNetworkRestricted.dat
		@ECHO.vmicvss>>LocalSystemNetworkRestricted.dat
		@ECHO.WdiServiceHost>>LocalService.dat
		@ECHO.sppuinotify>>LocalService.dat
		@ECHO.FontCache>>LocalService.dat
		@ECHO.bthserv>>LocalService.dat
		@ECHO.lanmanworkstation>>NetworkService.dat
		@ECHO.BthHFSrv>>LocalServiceNetworkRestricted.dat
		@ECHO.homegroupprovider>>LocalServiceNetworkRestricted.dat
		@ECHO.AppIDSvc>>LocalServiceNetworkRestricted.dat
		@ECHO.wcmsvc>>LocalServiceNetworkRestricted.dat
		@ECHO.vmictimesync>>LocalServiceNetworkRestricted.dat
		)
	SWREG QUERY "%__%" /v LocalSystemNetworkRestricted >temp00
	SED "/.*	/!d; s///; s/\\0$//g; s/\\0/\n/g " temp00 >temp01
	GREP -xivf LocalSystemNetworkRestricted.dat temp01 >temp02
	GREP -sq . temp02 &&(
		ECHO.
		ECHO.%__%  - LocalSystemNetworkRestricted
		TYPE temp02
		)>>ComboFix.txt
	@DEL /A/F/Q temp0?

	SWREG QUERY "%__%" /v LocalService >temp00
	SED "/.*	/!d; s///; s/\\0$//g; s/\\0/\n/g" temp00 >temp01
	GREP -xivf LocalService.dat temp01 >temp02
	GREP -sq . temp02 &&(
		ECHO.
		ECHO.%__%  - LocalService
		TYPE temp02
		)>>ComboFix.txt
	@DEL /A/F/Q temp0?

	SWREG QUERY "%__%" /v NetworkService >temp00
	SED "/.*	/!d; s///; s/\\0$//g; s/\\0/\n/g" temp00 >temp01
	GREP -xivf NetworkService.dat temp01 >temp02
	GREP -sq . temp02 &&(ECHO.%__%  - NetworkService&TYPE temp02)>>ComboFix.txt
	@DEL /A/F/Q temp0?

	SWREG QUERY "%__%" /v LocalServiceNetworkRestricted >temp00
	SED "/.*	/!d; s///; s/\\0$//g; s/\\0/\n/g" temp00 >temp01
	GREP -xivf LocalServiceNetworkRestricted.dat temp01 >temp02
	GREP -sq . temp02 &&(ECHO.%__%  - LocalServiceNetworkRestricted&TYPE temp02)>>ComboFix.txt
	@DEL /A/F/Q temp0?
	)


SWREG QUERY "HKLM\system\currentcontrolset\control\session manager\subsystems" /v windows >temp00
GREP -Fisq ServerDll=basesrv, temp00 || (
	SED -r "/_/!d; s/.*SubSystemType=Windows ServerDll=([^ ,]*).*/\x22Windows\x22= \1.dll/I; s/^H.*/\n[&]/" temp00
	)>>ComboFix.txt
@DEL /A/F/Q temp0? N_\*



Set "mountpoints=HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2"
SWREG QUERY "%mountpoints%" /s >temp00
SED -n -r "/\\command$/I{s/(%mountpoints:\=\\%\\)([^\\]*)(\\.*)/[\1\2]\n \2\3 - /I;$!N; s/ - \n.*	/ - /p;}" temp00 >temp01
SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" temp01 | SED -r "s/^\[/\n&/; s/^ [^\\]*//I" >>ComboFix.txt
DEL /A/F/Q temp0?



IF NOT EXIST Do.dat HIDEC %KMD% /C Assoc.cmd
IF EXIST Do.dat GREP -iq Extra:: Do.dat &&HIDEC %KMD% /C Assoc.cmd



@ECHO.%system%\ieudinit.exe>>active_setup.dat
@ECHO.%systemroot%\inf\unregmp2.exe>>active_setup.dat
@ECHO.rundll32 iedkcs32.dll>>active_setup.dat
@ECHO.%%systemroot%%\system32\shmgrate.exe>>active_setup.dat
@ECHO.%systemroot%\system32\shmgrate.exe>>active_setup.dat
@ECHO.%%systemroot%%\system32\themeui.dll>>active_setup.dat
@ECHO.%%programfiles%%\outlook express\setup50.exe>>active_setup.dat
@ECHO.%systemroot%\inf\msnetmtg.inf>>active_setup.dat
@ECHO.%systemroot%\inf\msmsgs.inf>>active_setup.dat
@ECHO.%systemroot%\inf\wmp.inf>>active_setup.dat
@ECHO.regsvr32.exe /s /n /i:u shell32.dll>>active_setup.dat
@ECHO.%\System32\shell32.dll>>active_setup.dat
@ECHO.%System%\shell32.dll>>active_setup.dat
@ECHO.%system%\mscories.dll>>active_setup.dat
@ECHO.%system%\ie4uinit.exe>>active_setup.dat
@ECHO.%systemroot%\inf\wmp10.inf>>active_setup.dat
@ECHO.%programfiles%\Messenger\msgsc.dll>>active_setup.dat
@ECHO.%systemroot%\inf\fxsocm.inf>>active_setup.dat
@ECHO.%system%\setup\fxsocm.dll>>active_setup.dat
@ECHO.%systemroot%\inf\mswmp.inf>>active_setup.dat
@ECHO.%programfiles%\messenger\msgsc.dll>>active_setup.dat
@ECHO.%%systemroot%%\system32\updcrl.exe>>active_setup.dat
@ECHO.%system%\setup\wmpocm.exe>>active_setup.dat
@ECHO.%systemroot%\INF\mplayer2.inf>>active_setup.dat
@ECHO.%%systemroot%%\system32\ie4uinit.exe>>active_setup.dat
@ECHO.regsvr32.exe /s /n /i:"S 2 true 3 true 4 true 5 true 6 true 7 true" initpki.dll>>active_setup.dat
@ECHO.%%systemroot%%\inf\ie.inf>>active_setup.dat
@ECHO.%systemroot%\INF\wmp11.inf>>active_setup.dat
@ECHO.%%systemroot%%\INF\msmsgs.inf>>active_setup.dat
@ECHO.%%systemroot%%\INF\wpie4x86.inf>>active_setup.dat
@ECHO.%%systemroot%%\inf\mcdftreg.inf>>active_setup.dat
@ECHO.%systemroot%\INF\EasyCDBlock.inf>>active_setup.dat
@ECHO.rundll32 iesetup.dll>>active_setup.dat
@ECHO.RunDLL setupx.dll>>active_setup.dat
@ECHO.%%programfiles%%\windows mail\winmail.exe>>active_setup.dat
@ECHO.%system%\iedkcs32.dll>>active_setup.dat


@IF EXIST Vista.krl (
	ECHO.%system%\unregmp2.exe
	ECHO.%%SystemRoot%%\system32\unregmp2.exe
	IF EXIST W6432.dat (
		ECHO.%SystemRoot%\SysWOW64\ie4uinit.exe
		ECHO.%SystemRoot%\SysWOW64\iedkcs32.dll
		ECHO.%%ProgramFiles^(x86^)%%\Windows Mail\WinMail.exe
		ECHO.%SystemRoot%\SysWOW64\mscories.dll
		))>>active_setup.dat


SWREG QUERY "HKLM\software\%RegWow64%microsoft\active setup\installed components" /s >temp00
GREP -Fivf active_setup.dat temp00 >temp01
SED -n -r "/stubpath	.*	.|hkey_/I!d; /stubpath	/I{s/.*	/\t/; H; g; p;} ;h" temp01 | SED -r -f run.sed | SED ":a; $!N;s/\n	/	/;ta;P;D" >temp02
FOR /F "TOKENS=*" %%G IN ( temp02 ) DO @%KMD% /C ECHO.%%G>>temp03

IF EXIST temp03 @FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( temp03 ) DO @IF EXIST "%%~F$PATH:H" (
		ECHO.&ECHO.[%%~G]
		PEV -fs32 -rtf -c:##m#b#u#b#t#b#f# "%%~F$PATH:H"
	)>>ComboFix.txt ELSE IF EXIST bak.dat (
		ECHO.&ECHO.[%%~G]
		ECHO.%%H [N/A]
	)>>ComboFix.txt ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\HKLM_%Orphan64%ActiveSetup-%%~NXG.reg.dat" (
		ECHO.[%%~G]
		ECHO.%%H [BU]
	)>>ComboFix.txt ELSE (
		REGT /a "%SystemDrive%\Qoobox\Quarantine\Registry_backups\HKLM_%Orphan64%ActiveSetup-%%~NXG.reg.dat" "%%~G"
		ECHO."%%~NXG">>delclsid00
		ECHO.[-%%~G]>>CregC.dat
		ECHO.HKLM_%Orphan64%ActiveSetup-%%~NXG - %%~H>>Orphans.dat
		)
@DEL /A/F/Q temp0? 


:: SWREG QUERY "HKCU\software\microsoft\active setup\installed components" /s >>temp01
:: SED -n -r "/stubpath	.*	.|hkey_/I!d; /stubpath	/I{s/.*	/\t/; H; g; p;} ;h" temp01 | SED -r -f run.sed | SED ":a; $!N;s/\n	/	/;ta;P;D" >temp02
:: FOR /F "TOKENS=*" %%G IN ( temp02 ) DO @%KMD% /C ECHO.%%G>>temp03

IF EXIST temp03 @FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( temp03 ) DO @IF EXIST "%%~F$PATH:H" (
		ECHO.&ECHO.[%%~G]
		PEV -fs32 -rtf -c:##m#b#u#b#t#b#f# "%%~F$PATH:H"
	)>>ComboFix.txt ELSE IF EXIST bak.dat (
		ECHO.&ECHO.[%%~G]
		ECHO.%%H [N/A]
	)>>ComboFix.txt ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\HKCU_%Orphan64%ActiveSetup-%%~NXG.reg.dat" (
		ECHO.[%%~G]
		ECHO.%%H [BU]
	)>>ComboFix.txt ELSE (
		REGT /a "%SystemDrive%\Qoobox\Quarantine\Registry_backups\HKCU_%Orphan64%ActiveSetup-%%~NXG.reg.dat" "%%~G"
		ECHO."%%~NXG">>delclsid00
		ECHO.[-%%~G]>>CregC.dat
		ECHO.HKCU_%Orphan64%ActiveSetup-%%~NXG - %%~H>>Orphans.dat
		)
@DEL /A/F/Q temp0? 



@ECHO.>>ComboFix.txt

IF EXIST "%Tasks%\*.job" (
	ECHO.%Line24%
	PEV -rtf -c:##m  #f# "%tasks%\*.job" >temp00
	FOR /F "TOKENS=1,2*" %%G IN ( temp00 ) DO @(
		TYPE "%%~I" | GSAR -F -s:x1A -r >temp02
		ECHO.>>temp02
		SED -r "s/\x00([^\x00])/\1/g; s/[^ -~]/?/Ig; /:\\/!d;" temp02 >temp03
		GREP -sq . temp03 &&(
			SED -r "s/%system:\=\\%\\rundll32.exe//I; s/:\\/:&/; s/.*(.:):(\\[^?\x22]*).*/\1\2/; s/(\\[^\\]*\....),[^\\]*$/\1/" temp03 >temp04
			FOR /F "TOKENS=*" %%J IN ( temp04 ) DO @PEV -fs32 -rtf -c:##n%%G %%I#n- %%J [#c . #m]# "%%~J"
			)|| DEL /A/F "%%~I"
		DEL /A/F temp02 temp03 >temp04 N_\%random%
		)
	@DEL /A/F/Q temp0?>N_\%random%
	@ECHO.
	)>>ComboFix.txt


SWREG QUERY "HKLM\system\currentcontrolset\control\servicegrouporder" /v list >temp00
SED "/.*	/!d; s///; s/\\0Boot System Extenders\\0/\\0/I; s/\\0\\0$//" temp00 >temp01
FOR /F "TOKENS=*" %%G IN ( temp01 ) DO @SWREG ADD "HKLM\system\currentcontrolset\control\servicegrouporder" /v list /t reg_multi_sz /d "%%G"
@DEL /A/F/Q temp0?>N_\%random%


FOR %%G IN (
	"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace"
	"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"
	"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace"
	"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NetworkNeighborhood\NameSpace"
	"HKLU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace"
	"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"
	"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace"
	"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NetworkNeighborhood\NameSpace"
) DO @SWREG QUERY %%G >>temp00
SED "/HKEY_.*NameSpace\\{/I!d; s//{/" temp00 | GREP -Fixvf clsid.dat >temp01
FOR /F "TOKENS=*" %%G IN ( temp01 ) DO @SWREG QUERY "HKCR\CLSID\%%G" >N_\%random% ||ECHO.%%G>>DelClsid00
@DEL /A/F/Q temp0?>N_\%random%
 
IF EXIST W6432.dat %KMD% /C RegScan64.cmd


DEL /A/F/Q temp0? SIOI.dat Driver32 active_setup.dat
@GOTO :EOF



:RunParse
@FOR /F "TOKENS=1-3 DELIMS=	" %%H IN ( RegRuns02 ) DO @IF EXIST "%%~F$PATH:J" (
		PEV -fs32 -rtf -c:#"%%~I"="%%~J" [#m #u]# "%%~F$PATH:J" >>RegRuns0A
	) ELSE IF EXIST bak.dat (
		ECHO."%%~I"="%%~J" [N/A]>>RegRuns0A
	) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%%%~H-%%~I.reg.dat" (
		ECHO."%%~I"="%%~J" [BU]>>RegRuns0A
	) ELSE (
		ECHO.REGEDIT4>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%%%~H-%%~I.reg.dat"
		ECHO.>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%%%~H-%%~I.reg.dat"
		ECHO.[%%~G]>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%%%~H-%%~I.reg.dat"
		FINDSTR -BI ".%%~I.=" RegRuns00 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%%%~H-%%~I.reg.dat"
		ECHO."%%~I"=->>RegRuns0B
		ECHO.%Orphan64%%%~H-%%~I - %%~J>>Orphans.dat
		)
@DEL /A/F RegRuns02
@GOTO :EOF


:Bho-Orph
@FOR /F "TOKENS=1,2 delims=	" %%G in ( Bho-Orph ) DO @(
	SWREG EXPORT "hkey_local_machine\software\%RegWow64%microsoft\windows\currentversion\explorer\browser helper objects\%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%BHO-%%~G.reg.dat" /NT4
	SWREG EXPORT "HKEY_CLASSES_ROOT\CLSID\%%~G" BHO00 /NT4
	IF EXIST BHO00 (
		TYPE BHO00 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%BHO-%%~G.reg.dat"
		DEL /A/F BHO00
		)
	ECHO."%%~G">>delclsid00
	ECHO.BHO-%%~G - %%~H>>Orphans.dat
	)

@DEL /A/F Bho-Orph
@GOTO :EOF


:SSODL-Orph
@FOR /F "TOKENS=1-3 delims=	" %%G in ( SSODL-Orph ) DO @(
	SWREG EXPORT "HKCR\CLSID\%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%SSODL-%%~H-%%~G.reg.dat" /NT4
	IF NOT EXIST BHO00 SWREG EXPORT "HKLM\software\%RegWow64%microsoft\windows\currentversion\ShellServiceObjectDelayLoad" BHO00 /NT4
	FINDSTR -I "^\[ %%~G" BHO00 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%SSODL-%%~H-%%~G.reg.dat"
	ECHO."%%~G">>delclsid00
	ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\%RegWow64%Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad]>>CregC.dat
	ECHO."%%~H"=-| SED "s/\\/&&/g" >>CregC.dat
	ECHO.SSODL-%%~H-%%~G - %%~I>>Orphans.dat
	)

@DEL /A/F SSODL-Orph
@GOTO :EOF


:022-Orph
@FOR /F "TOKENS=1-3 delims=	" %%G in ( 022-Orph ) DO @(
	SWREG EXPORT "HKCR\CLSID\%%~H" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%%%~NG-%%~H.reg.dat" /NT4
	IF NOT EXIST BHO00 SWREG EXPORT "%%~G" BHO00 /NT4
	FINDSTR -I "^\[ %%~H" BHO00 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%%%~NG-%%~H.reg.dat"
	ECHO."%%~H">>delclsid00
	ECHO.%%~NG-%%~H - %%~I>>Orphans.dat
	)

@DEL /A/F 022-Orph
@GOTO :EOF


:ToolB-Orph
@FOR /F "TOKENS=1-3 DELIMS=	" %%G in ( ToolB-Orph ) DO @(
	ECHO."%%~G">>DelClsid00
	SWREG QUERY "HKCR\CLSID\%%~G" /s >ToolB-Orph01
	SED -n -r -f toolbar.sed ToolB-Orph01 >ToolB-Orph02
	SED "s/^HKEY.*/[-&]/" ToolB-Orph02 >>CregC.dat
	IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~H-%%~G.reg.dat" DEL /A/F "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%%%~H-%%~G.reg.dat"
	FOR /F "TOKENS=*" %%L IN ( ToolB-Orph02 ) DO @(
		SWREG EXPORT "%%L" ToolB-Orph03 /NT4
		Type ToolB-Orph03 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%%%~H-%%~G.reg.dat"
		DEL /A/F ToolB-Orph03
		)
	FINDSTR -I "^\[ %%~G" ToolB-00 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%Orphan64%%%~H-%%~G.reg.dat"
	ECHO.%%~H-%%~G - %%~I>>Orphans.dat
	)

@DEL /A/F ToolB-Orph ToolB-Orph01 ToolB-Orph02
@GOTO :EOF


:SvcDrvB
@echo:s/\x22//g;>svclistB.sed
@echo:s/^^_NAME: (.*;.*);(\d;\d)/\2	\1/;>>svclistB.sed
@echo:s/^^1;/R/;>>svclistB.sed
@echo:s/^^4;/S/;>>svclistB.sed
@echo:s/\\\?\?\\//;>>svclistB.sed
@echo:s/;\\/;/;>>svclistB.sed
@echo:s/^^..  ([^^;]*);.*;$/^&%SysDir:\=\\%\\DRIVERS\\\1.syS/;>>svclistB.sed
@echo:s/;system32\\/;%SysDir:\=\\%\\/I;>>svclistB.sed
@echo:s/;SystemRoot\\/;%systemroot:\=\\%\\/I>>svclistB.sed
@echo:s/;globalroot\\systemroot/;%systemroot:\=\\%/I;>>svclistB.sed

@TYPE svclistB.sed > svclistC.sed
@echo:s/(\\svchos(t^|t\.exe)) -k .*/\1/I;>>svclistC.sed
@echo:s/(.*\\[^^\\]*\....) ([-\/]^|srv).*$/\1/I;>>svclistC.sed
@echo:s/(.*:\\.*\....) .*:\\.*/\1/;>>svclistC.sed

@SWSC queryex type= all state= all options= config >temp0A
@SED -r "/^SERVICE|^DISPLAY_NAME|^ *(STATE|START_TYPE|BINARY_PATH_NAME) +/I!d; s///; /^: [0-4]/s/  .*//" temp0A >temp0B
@SED ":a; $!N; s/\n: /;/;ta;P;D" temp0B >temp0C
@SED -R -f svclistC.sed temp0C >temp0D
@SED -R -f svclistB.sed temp0C > svclist.dat
@FINDSTR -ILG:SuspectSvc temp0D >temp0E
@SORT /M 65536 temp0E | SED "s/	/ /" >temp04


@IF EXIST W6432.dat (
	SED -r "/;/!d; s/(.*;)(.*)/&\t\2/; s/\t%SYSDIR:\=\\%\\/;%systemroot:\=\\%\\SYSNATIVE\\/I; s/\t/;/" temp04 > tempA4
	MOVE /Y tempA4 temp04
	)
	
@FINDSTR . temp04 &&(
	@ECHO.
	@FOR /F "TOKENS=1,2* delims=;" %%G in ( temp04 ) DO @IF EXIST "%%~I" (
		PEV -rtf -c:#%%G;%%H;%%I [#m #u]# "%%~I"
		) ELSE ECHO.%%G;%%H;%%I [x]
	@ECHO.
	)>>ComboFix.txt

:: SED -R "/^\S*	/!d; s///; s/;.*//" svclist.dat >SCList
:: FINDSTR -LIVXG:SCList Service01 >SvcRegNotInSC

@DEL /A/F/Q temp0? svclistB.sed svclistC.sed
@GOTO :EOF


:RestoreO4
@ECHO.REGEDIT4>LMO4.reg
@IF EXIST vista.krl GOTO RestoreO4v
@IF EXIST f_system SWXCACLS "%systemdrive%\System Volume Information" /E /GA:R /Q
@PEV -fs32 -limit1 -sdmdate -tx50000 -tf "\System Volume Information\_registry_machine_software" >LMO400
@FOR /F "TOKENS=*" %%G IN ( LMO400 ) DO @SWREG load "hklm\temphive" "%%G" && @(
	SWREG export "hklm\temphive\microsoft\windows\currentversion\run" LMO4_export /nt4
	SED -r "1d; s/^\[hkey_local_machine\\temphive\\/[HKEY_LOCAL_MACHINE\\Software\\/I" LMO4_export >>LMO4.reg
	DEL /A/F LMO4_export
	SWREG unload "hklm\temphive"
	)
@SWREG QUERY "HKLM\software\microsoft\windows nt\currentversion\profilelist" /s | SED -r "/./{H;$!d;};x;/\n +profileimagepath	[^\n]*%username:&=\&%\n/I!d;" | SED "/^HKEY.*\\/I!d; s///" >MySID
@FOR /F "TOKENS=*" %%G IN ( MySID ) DO @PEV -fs32 -limit1 -sdmdate -tx50000 -tf "\System Volume Information\_registry_user_ntuser_%%G" >CUO400
@FOR /F "TOKENS=*" %%G IN ( CUO400 ) DO @SWREG load "hklm\temphiveB" "%%G" && @(
	SWREG export "hklm\temphiveB\microsoft\windows\currentversion\run" CUO4_export /nt4
	SED -r "1d; s/^\[hkey_local_machine\\temphiveB\\/[HKEY_CURRENT_USER\\Software\\/I" CUO4_export >>LMO4.reg
	DEL /A/F CUO4_export
	SWREG unload "hklm\temphiveB"
	)
@REGT /S LMO4.reg
@IF EXIST f_system SWXCACLS "%systemdrive%\system volume information" /P /GS:F /I REMOVE /Q
@DEL /A/F/Q LMO40? CUO40? MySID n_*
@GOTO :EOF


:RestoreO4v
@PEV DDEV -A| FINDSTR -BI HarddiskVolumeShadowCopy | SORT /M 65536 /R /O Vss00
FOR /F "TOKENS=*" %%G IN ( Vss00 ) DO @(
	PEV DDEV b: "\\?\GlobalRoot\Device\%%~G"
	SWREG load "hklm\temphive" "b%system:~1%\config\software" &&(
		SWREG export "hklm\temphive\microsoft\windows\currentversion\run" LMO4_export /nt4
		SED -r "1d; s/^\[hkey_local_machine\\temphive\\/[HKEY_LOCAL_MACHINE\\Software\\/I" LMO4_export >>LMO4.reg
		DEL /A/F LMO4_export
		SWREG unload "hklm\temphive"
		)
	SWREG load "hklm\temphiveB" "b%userprofile:~1%\ntuser.dat" &&(
		SWREG export "hklm\temphiveB\microsoft\windows\currentversion\run" CUO4_export /nt4
		SED -r "1d; s/^\[hkey_local_machine\\temphiveB\\/[HKEY_CURRENT_USER\\Software\\/I" CUO4_export >>LMO4.reg
		DEL /A/F CUO4_export
		SWREG unload "hklm\temphiveB"
		)
	PEV DDEV -D b:
	)
@REGT /S LMO4.reg
@DEL /A/F/Q LMO40? CUO40? Vss00
@GOTO :EOF

:SAFEBOOTREPAIR
@IF EXIST vista.krl GOTO :EOF
@IF EXIST "%systemdrive%\System Volume Information" SWXCACLS "%systemdrive%\System Volume Information" /E /GA:R /Q
@SWREG ACL "hklm\system\currentcontrolset\control\safeboot" /RESET /Q
@DEL /A/F/Q temp0? safeboot0A safeboot0B
@PEV -fs32 -tx50000 -tf \*system | Findstr -MIBF:/ regf >SafeBoot00
@SWREG QUERY HKLM\System | SED -r "/\\ControlSet/I!d;s/.*\\(.*)$/HKU\\temphive\\\1\\control\\safeboot/" >SafeBoot01
@ECHO.REGEDIT4>SafeBoot.reg
@FOR /F "TOKENS=*" %%G IN ( SafeBoot00 ) DO @(
	SWREG load "hku\temphive" "%%G" && (
		FOR /F "TOKENS=*" %%H IN ( SafeBoot01 ) DO @(
			SWREG export "%%H" SafeBoot_export /NT4
			SED "1d; s/hkey_users\\temphive\\[^\\]*\\/HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\/I" SafeBoot_export >>SafeBoot.reg
			DEL /A/F SafeBoot_export
			)
		SWREG unload "hku\temphive"
		))

@SED 1d XPSboot.reg >>SafeBoot.reg
@REGT /S SafeBoot.reg
@IF EXIST "%systemdrive%\system volume information" SWXCACLS "%systemdrive%\system volume information" /P /GS:F /I REMOVE /Q
@IF EXIST cregC.dat REGT /S cregC.dat
@IF EXIST creg.dat REGT /S creg.dat
@DEL /A/F/Q SafeBoot.reg SafeBoot0? temp0?
@GOTO :EOF


