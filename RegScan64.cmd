
CD /D "%~DP0"

@(
ECHO.
ECHO.--------- X64 Entries -----------
ECHO.
)>>ComboFix.txt



REG.EXE QUERY "HKLM\software\Microsoft\windows\currentversion\explorer\browser helper objects" >RegBho0A-X64
SED "/{/!d; s/.*{/{/ " RegBho0A-X64 >RegBho0B-X64
FINDSTR -VILG:clsid.dat RegBho0B-X64 >RegBho0C-X64

FOR /F "TOKENS=*" %%G IN ( RegBho0C-X64 ) DO @(
	REG.EXE QUERY "HKCR\CLSID\%%G\InprocServer32" /ve >RegBho0D-X64
	SED "/.*REG_\S*    /!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" RegBho0D-X64 >RegBho0E-X64
	GREP -s . RegBho0E-X64 >RegBho0F-X64 ||(
		ECHO."%%~G">Bho-Orph-X64
		CALL :Bho-Orph
		)>N_\%random%
	FOR /F "TOKENS=*" %%I IN ( RegBho0F-X64 ) DO @ECHO."%%~I"|GREP -Fsq "?" &&(
			ECHO.
			ECHO.[HKEY_LOCAL_MACHINE\~\Browser Helper Objects\%%G]
			ECHO.%%~I [?]
		)|| IF EXIST "%%~F$PATH:I" (
			ECHO.
			ECHO.[HKEY_LOCAL_MACHINE\~\Browser Helper Objects\%%G]
			PEV -rtf -c:##m#b#u#b#t#b#f# "%%~F$PATH:I"
		) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\BHO-%%~G.reg.dat" (
			ECHO.
			ECHO.[HKEY_LOCAL_MACHINE\~\Browser Helper Objects\%%G]
			ECHO.%%~I [BU]
		) ELSE (
			ECHO."%%~G"	"%%~I">Bho-Orph-X64
			CALL :Bho-Orph >N_\%random%
			)
	DEL /A/F RegBho0D-X64 RegBho0E-X64 RegBho0F-X64 >N_\%random%
	)>>ComboFix.txt
DEL /A/F/Q RegBho0?-X64 temp0? N_\*




REGEDIT.EXE /A ToolB-00-X64 "HKEY_LOCAL_MACHINE\software\microsoft\internet explorer\toolbar"
IF EXIST  ToolB-00-X64  (
	SED -r "/^\x22(.*)\x22=.*/!d; s//\1/" ToolB-00-X64 >mToolbar01-X64
	GREP -Fvif clsid.dat mToolbar01-X64 >mToolbar02-X64

	FOR /F "TOKENS=*" %%G IN ( mToolbar02-X64 ) DO @(
		REG.EXE QUERY "HKCR\CLSID\%%G\InprocServer32" /ve >mToolbar03-X64
		SED "/.*REG_\S*    /!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" mToolbar03-X64 >mToolbar04-X64
		GREP -s . mToolbar04-X64 >mToolbar05-X64 ||(
			ECHO."%%~G"	"Toolbar">ToolB-Orph-X64
			CALL :ToolB-Orph
			)
		FOR /F "TOKENS=*" %%H IN ( mToolbar05-X64 ) DO @ECHO."%%~H"|GREP -Fsq "?" &&(
				ECHO."%%G"= "%%~H" [?]>>mToolbar06-X64
			)|| IF EXIST "%%~F$PATH:H" (
				PEV -rtf -c:#"%%G"= "%%~H" [#m #u]# "%%~F$PATH:H" >>mToolbar06-X64
			) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\Toolbar-%%~G.reg.dat" (
				ECHO."%%G"= "%%~H" [BU]>>mToolbar06-X64
			) ELSE (
				ECHO."%%~G"	"Toolbar"	"%%~H">ToolB-Orph-X64
				CALL :ToolB-Orph
				)
		DEL /A/F mToolbar03-X64 mToolbar04-X64 mToolbar05-X64
		)

	IF EXIST mToolbar06-X64 GREP -Fsq = mToolbar06-X64 &&(
		ECHO.>>ComboFix.txt
		ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Toolbar]>>ComboFix.txt
		TYPE mToolbar06-X64 >>ComboFix.txt
		FOR /F "DELIMS==" %%G in ( mToolbar06-X64 ) DO @(
			REG.EXE QUERY "HKCR\CLSID\%%~G" /s >mToolbar07-X64
			SED -n -r -f toolbar.sed mToolbar07-X64 >mToolbar08-X64
			SED "s/^HKEY.*/[&]/" mToolbar08-X64 >>ComboFix.txt
			DEL /A/F mToolbar07-X64 mToolbar08-X64
			) )
	DEL /A/F/Q ToolB-00-X64 mToolbar0?-X64
	)




REGEDIT.EXE /A ToolB-01-X64 "HKEY_CURRENT_USER\software\microsoft\internet explorer\toolbar\webbrowser"
IF EXIST ToolB-01-X64 (
	SED "s/^  //;" ToolB-01-X64 >ToolB-02-X64
	SED ":a;/\\$/N; s/\\\n//; ta" ToolB-02-X64 >ToolB-00-X64
	SED -r "/^\x22({.*})\x22=.*/!d; s//\1/" ToolB-00-X64 >uWebBrowser01-X64
	GREP -Fvif clsid.dat uWebBrowser01-X64 >uWebBrowser02-X64
	DEL /A/F ToolB-01-X64 ToolB-02-X64

	FOR /F "TOKENS=*" %%G IN ( uWebBrowser02-X64 ) DO @(
		REG.EXE QUERY "HKCR\CLSID\%%G\InprocServer32" /ve >uWebBrowser03-X64
		SED "/.*REG_\S*    /!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" uWebBrowser03-X64 >uWebBrowser04-X64
		GREP -s . uWebBrowser04-X64 >uWebBrowser05-X64 ||(
			ECHO."%%~G"	"WebBrowser">ToolB-Orph-X64
			CALL :ToolB-Orph
			)
		FOR /F "TOKENS=*" %%I in ( uWebBrowser05-X64 ) DO @ECHO."%%~I"|GREP -Fsq "?" &&(
			ECHO."%%G"= "%%~I" [?]>>uWebBrowser06-X64
				)|| IF EXIST "%%~F$PATH:I" (
			PEV -rtf -c:#"%%G"= "%%~I" [#m #u]# "%%~F$PATH:I" >>uWebBrowser06-X64
				) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\WebBrowser-%%~G.reg.dat" (
			ECHO."%%G"= "%%~I" [BU]>>uWebBrowser06-X64
				) ELSE (
				ECHO."%%~G"	"WebBrowser"	"%%~I">ToolB-Orph-X64
				CALL :ToolB-Orph
				)
		DEL /A/F uWebBrowser03-X64 uWebBrowser04-X64 uWebBrowser05-X64
		)

	IF EXIST uWebBrowser06 GREP -Fsq = uWebBrowser06 &&(
		ECHO.>>ComboFix.txt
		ECHO.[HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Toolbar\Webbrowser]>>ComboFix.txt
		TYPE uWebBrowser06-X64 >>ComboFix.txt
		FOR /F "DELIMS==" %%G in ( uWebBrowser06-X64 ) DO @(
			REG.EXE QUERY "HKCR\CLSID\%%~G" /s >uWebBrowser07-X64
			SED -n -r -f toolbar.sed uWebBrowser07-X64 >uWebBrowser08-X64
			SED "s/^HKEY.*/[&]/" uWebBrowser08-X64 >>ComboFix.txt
			DEL /A/F uWebBrowser07-X64 uWebBrowser08-X64
			) )
	DEL /A/F/Q ToolB-00 uWebBrowser0?
	)





REGEDIT.EXE /A mSIOI00-X64 "HKEY_LOCAL_MACHINE\software\microsoft\windows\currentversion\explorer\shelliconoverlayidentifiers"
IF EXIST mSIOI00-X64 (
	SED ":a; $!N; s/]\n@=/	/I;ta;P;D" mSIOI00-X64 >mSIOI0A-X64
	SED "/HKEY.*	/I!d; s/\[//; s/\x22//g" mSIOI0A-X64 >mSIOI01-X64
	GREP -Fivf SIOI.dat mSIOI01-X64 >mSIOI02-X64

	FOR /F "TOKENS=1* DELIMS=	" %%G IN ( mSIOI02-X64 ) DO @(
		REG.EXE QUERY "HKCR\CLSID\%%~H\InprocServer32" /ve >mSIOI03-X64
		SED "/.*REG_\S*    /!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" mSIOI03-X64 >mSIOI04-X64
		GREP -s . mSIOI04-X64 >mSIOI05-X64 ||(
			ECHO."%%~H"	"ShellIconOverlayIdentifiers">ToolB-Orph-X64
			CALL :ToolB-Orph
			ECHO.[-%%~G]>>CregCx64.dat
			ECHO.>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\ShellIconOverlayIdentifiers-%%~H.reg.dat"
			ECHO.[%%~G]>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\ShellIconOverlayIdentifiers-%%~H.reg.dat"
			ECHO.@="%%~H">>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\ShellIconOverlayIdentifiers-%%~H.reg.dat"
			)
		FOR /F "TOKENS=*" %%I in ( mSIOI05-X64 ) DO @ECHO."%%~I"|GREP -Fsq "?" &&(
				SED "/./{H;$!d;};x;/%%~H/I!d" mSIOI00-X64 >>ComboFix.txt
				ECHO.[HKEY_CLASSES_ROOT\CLSID\%%~H]>>ComboFix.txt
				ECHO.%%~I [?]>>ComboFix.txt
			)|| IF EXIST "%%~F$PATH:I" (
				SED "/./{H;$!d;};x;/%%H/I!d" mSIOI00-X64 >>ComboFix.txt
				ECHO.[HKEY_CLASSES_ROOT\CLSID\%%~H]>>ComboFix.txt
				PEV -rtf -c:##m#b#u#b#t#b#f# "%%~F$PATH:I" >>ComboFix.txt
			) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\ShellIconOverlayIdentifiers-%%~H.reg.dat" (
				SED "/./{H;$!d;};x;/%%H/I!d" mSIOI00-X64 >>ComboFix.txt
				ECHO.[HKEY_CLASSES_ROOT\CLSID\%%~H]>>ComboFix.txt
				ECHO.%%~I [BU]>>ComboFix.txt
			) ELSE (
				ECHO."%%~H"	"ShellIconOverlayIdentifiers"	"%%~I">ToolB-Orph-X64
				CALL :ToolB-Orph
				ECHO.[-%%~G]>>CregCx64.dat
				ECHO.>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\ShellIconOverlayIdentifiers-%%~H.reg.dat"
				ECHO.[%%~G]>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\ShellIconOverlayIdentifiers-%%~H.reg.dat"
				ECHO.@="%%~H">>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\ShellIconOverlayIdentifiers-%%~H.reg.dat"
				)
		DEL /A/F mSIOI03-X64 mSIOI04-X64 mSIOI05-X64
		)
	DEL /A/F/Q SIOI.dat mSIOI0?-X64
	)



FOR %%G IN (
	"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
	"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
) DO @(
	REGEDIT.EXE /a RegRuns00-X64 %%G
	IF EXIST RegRuns00-X64 (
		SED -r ":a;/\\$/N; s/\\\n  +//; ta" RegRuns00-X64 > RegRunOri-X64
		REG.EXE QUERY %%G > RegRunOriB-X64
		GREP -E ".{600}" RegRunOriB-X64 > RegRunOriC-X64 &&(
			ECHO.[%%~G]>>CregC.dat
			SED -r "/^   ([^\t]*)\t.*/!d; s//\x22\1\x22=-/" RegRunOriC-X64 >>CregC.dat
			)
		SED -r -e "/\\%%~NG$/I,/^$/!d" -f run.sed -e "/	/!d" RegRunOriB-X64 >RegRuns01-X64
		SED -r -e "/?/d;" RegRuns01-X64 | SED -r -e "/\....$|	$/!d; s/./%%~G	&/;" -f run2.sed >RegRuns02-X64
		SED -r "/?/!d;" RegRuns01-X64 | 	SED -r "s/(.*)	(.*)/\x22\1\x22=\x22\2\x22 [?]/" >RegRuns0A-X64
		SED -r "/\....$|	$/d;" RegRuns01-X64 | SED -r "/?/d;" | SED -r "s/(.*)	(.*)/\x22\1\x22=\x22\2\x22 [X]/" >>RegRuns0A-X64
		CALL :RUNParse
		IF EXIST RegRuns0A-X64 FINDSTR = RegRuns0A-X64 &&(
			ECHO.
			ECHO.[%%~G]
			TYPE RegRuns0A-X64
			)>>ComboFix.txt
		IF EXIST RegRuns0B-X64 FINDSTR = RegRuns0B-X64 &&(
			ECHO.
			ECHO.[%%~G]
			SED "s/\\/&&/g" RegRuns0B-X64
			)>>CregCx64.dat
		DEL /A/F/Q RegRuns0?-X64 RegRunOri*-X64
		))




FOR %%G in (
	"hkey_local_machine\software\microsoft\windows\currentversion\explorer\SharedTaskScheduler"
	"hkey_local_machine\software\microsoft\windows\currentversion\explorer\ShellExecuteHooks"
) DO @(
	REG.EXE QUERY %%G  >022Orph0A-X64
	SED -r "/REG_\S*    /!d; s/^ +//; s/    .+//" 022Orph0A-X64 >022Orph0B-X64
	FINDSTR -vilg:clsid.dat 022Orph0B-X64 >022Orph00-X64
	FOR /F "TOKENS=*" %%H in ( 022Orph00-X64 ) DO @(
		REG.EXE QUERY "HKCR\CLSID\%%H\InprocServer32" /ve >022Orph0C-X64
		SED "/.*REG_\S*    /!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" 022Orph0C-X64 >022Orph0D-X64
		GREP -s .  022Orph0D-X64 >022Orph01-X64 ||(
			ECHO."%%~G"	"%%~H">022-Orph-X64
			CALL :022-Orph
			)
		FOR /F "TOKENS=*" %%I in ( 022Orph01-X64 ) DO @ECHO."%%~I"|GREP -Fsq "?" &&(
			ECHO."%%H"= "%%~I" [?]>>022Orph02-X64
				)|| IF EXIST "%%~F$PATH:I" (
			PEV -rtf -c:#"%%H"= "%%~I" [#m #u]# "%%~F$PATH:I" >>022Orph02-X64
				) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~NG-%%~H.reg.dat" (
			ECHO."%%H"= "%%~I" [BU]>>022Orph02-X64
				) ELSE (
			ECHO."%%~G"	"%%~H"	"%%~I">022-Orph-X64
			CALL :022-Orph
			)
		DEL /A/F 022Orph01-X64 022Orph0C-X64 022Orph0D-X64
		)
	@IF EXIST 022Orph02-X64 (
		ECHO.
		ECHO.[%%~G]
		TYPE 022Orph02-X64
		)>>ComboFix.txt
	DEL /A/F/Q 022Orph0?-X64 BHO00-X64
	)




REG.EXE QUERY "HKLM\software\microsoft\windows\currentversion\ShellServiceObjectDelayLoad" >temp0A-X64
SED -r "/REG_\S*    /!d; s/^ +// " temp0A-X64 >temp0B-X64
FINDSTR -vilg:clsid.dat temp0B-X64 >temp00-X64
FOR /F "TOKENS=1,2* DELIMS=	" %%G in ( temp00-X64 ) DO @(
	REG.EXE QUERY "HKCR\CLSID\%%I\InprocServer32" /ve >temp0C-X64
	SED "/.*REG_\S*    /!d; s///; s/%%systemroot\%%/%systemroot:\=\\%/I;" temp0C-X64 >temp0D-X64
	GREP -s .  temp0D-X64 >temp01-X64 ||(
		ECHO."%%~I"	"%%~G">SSODL-Orph-X64
		CALL :SSODL-Orph
		)
	FOR /F "TOKENS=*" %%J IN ( temp01 ) DO @ECHO."%%~J"|GREP -Fsq "?" &&(
		@ECHO."%%G"= %%~I - %%~J [?]>>temp02-X64
			)||IF EXIST "%%~F$PATH:J" (
		PEV -rtf -c:#"%%G"= %%~I - %%~J [#m #u]# "%%~F$PATH:J" >>temp02-X64
			) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\SSODL-%%~G-%%~I.reg.dat" (
		ECHO."%%G"= %%~I - %%~J [BU]>>temp02-X64
			) ELSE (
		ECHO."%%~I"	"%%~G"	"%%~J">SSODL-Orph-X64
		CALL :SSODL-Orph
		)
	DEL /A/F temp01-X64 temp0C-X64 temp0D-X64
	)

@IF EXIST temp02-X64 (
	ECHO.
	ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad]
	TYPE temp02-X64
	)>>ComboFix.txt
DEL /A/F/Q temp0?-X64 BHO00-X64



REG.EXE QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs >temp00-X64
REG.EXE DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /F
SED -r "/.*REG_\S*    /!d; s///; s/[ ,]/\n/g" temp00-X64 >temp01-X64

FOR /F %%G IN ( temp01-X64 ) DO @FINDSTR -MR "V.S._.V.E.R.S.I.O.N._.I.N.F.O VS_VERSION_INFO" "%%~F$PATH:G" >>temp02-X64
IF EXIST temp02-X64 (
	SED ":a;$!N;s/\n/ /;ta" temp02-X64 >temp03-X64
	FOR /F "TOKENS=*" %%G IN ( temp03-X64 ) DO @REG.EXE ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /V AppInit_DLLs /D "%%G" /F
	)
	
REG.EXE QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" >temp00-X64
SED -r "/^HKEY_|pInit_Dlls    .*    ./I!d; s/^    /\x22/; s/    REG\S*    /\x22=/; /^.RequireSignedAppInit_DLLs.=0x1/Id; s/^HKEY.*/\n[&]/ " temp00-X64 | SED "/./{H;$!d;};x;/=/I!d" >>ComboFix.txt
DEL /A/F/Q temp0?-X64



SWREG EXPORT "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes" temp00-X64 /NT4
SED -r "/^\x22(0|10|172\.(1[6-9]|2.|3[01])\.|192\.168|127|169\.254|224|255)\./d; " temp00-X64 | SED "/./{H;$!d;};x;/=/!d" >>ComboFix.txt
DEL /A/F/Q temp0?-X64


REG.EXE QUERY "HKLM\software\microsoft\windows nt\currentversion\Drivers32" >temp00-X64
SED -r "s/^H.*/[&]/; /^ +/{/^ +(aux|mixer|midi|wave)(|[0-9]*)    REG_\S*    /I!d; s//\x22\1\2\x22=/;};$G" temp00-X64 | FINDSTR -EVG:Driver32 >temp02-X64
SED "/./{H;$!d;};x;/=/I!d" temp02-X64 >>ComboFix.txt
DEL /A/F/Q temp0?-X64 Driver32



@SETLOCAL
SET "__=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost"

REG.EXE QUERY "%__%" >temp00-X64
SED -r "/^hkey.*\\svchost$/I,/^$/!d; s/^ +//g; /^(netsvcs|Local(Service|System)NetworkRestricted|(Local|Network)Service)   |^$/Id; s/(\\0)*$//; s/\\0/ /g; s/ +$//; s/HKEY.*/\n[&]/ " temp00-X64 | GREP -xivf svchost.dat >temp01-X64
SED "/./{H;$!d;};x;/	/I!d" temp01-X64 >>ComboFix.txt
DEL /A/F/Q temp0?-X64



REG.EXE QUERY "%__%" /v netsvcs >temp00-X64
SED "/.*   /!d; s///; s/\\0/\n/g; s/\n*$//" temp00-X64 >temp01-X64
ECHO.::::::>>netsvc64.bad.dat
GREP -Fixvf netsvc64.bad.dat temp01-X64 >temp02-X64
SED ":a;$!N; s/\n/\\0/g;ta;" temp02-X64 >temp03-X64
FOR /F "TOKENS=*" %%G IN ( temp03-X64 ) DO @REG.EXE ADD "%__%" /v netsvcs /t reg_multi_sz /d "%%G" /F
SET "NetSvcNmbr_x64=44"
IF EXIST W8.mac (
	SET "NetSvcNmbr_x64=47"
	@ECHO.BDESVC>>netsvc.dat
	@ECHO.DsmSvc>>netsvc.dat
	@ECHO.NcaSvc>>netsvc.dat
	@ECHO.SystemEventsBroker>>netsvc.dat
	@ECHO.wlidsvc>>netsvc.dat
	)
GREP -c . temp01-X64 >count-X64

FOR /F "TOKENS=*" %%G IN (count-X64 ) DO @IF "%%G" LSS "%NetSvcNmbr_x64%" @(
	ECHO.
	ECHO.%__%  - NetSvcs
	REM ECHO.[COLOR=RED]NETSVCS REQUIRES REPAIRS - current entries shown[/COLOR]
	ECHO.%Line83%
	TYPE temp02-X64
	ECHO.
	ECHO.%Line83b%
	REM ECHO.Rebuilding ... You need to reboot your machine for this to take effect.
	ECHO.
	ECHO.::::> temp0a-X64
	TYPE temp02-X64 >> temp0a-X64
	GREP -Fivxf temp0a-X64 netsvc.dat > temp0b-X64
	TYPE temp0b-X64 >> temp0a-X64
	TYPE temp0b-X64 >> temp02-X64
	TYPE temp0b-X64	
	IF EXIST svclist.dat (
		SED -r "/\\system32\\svchost(\.exe|) +-k +netsvcs/I!d; s/^[^\t]*\t([^;]*);.*/\1/;" svclist.dat | GREP -Fivxf temp0a-X64 > temp0c-X64
		TYPE temp0c-X64
		TYPE temp0c-X64 >> temp02-X64
		)
	SED ":a;$!N; s/\n/\\0/g;ta;" temp02-X64 >temp04-X64
	FOR /F "TOKENS=*" %%H IN ( temp04-X64 ) DO @REG.EXE ADD "%__%" /v netsvcs /t reg_multi_sz /d "%%H" /F >NULL
)>>ComboFix.txt ELSE GREP -sqxivf netsvc.dat temp02-X64 &&(
	ECHO.
	ECHO.%__%  - NetSvcs
	GREP -xivf netsvc.dat temp02-X64
	)>>ComboFix.txt

Set NetSvcNmbr_x64=
DEL /A/F/Q temp0?-X64 count-X64


IF EXIST w?.mac (
	@ECHO.homegrouplistener>>LocalSystemNetworkRestricted.dat
	@ECHO.StorSvc>>LocalSystemNetworkRestricted.dat
	@ECHO.WdiServiceHost>>LocalService.dat
	@ECHO.sppuinotify>>LocalService.dat
	@ECHO.lanmanworkstation>>NetworkService.dat
	@ECHO.BthHFSrv>>LocalServiceNetworkRestricted.dat
	@ECHO.homegroupprovider>>LocalServiceNetworkRestricted.dat
	)
IF EXIST w8.mac (
	@ECHO.WiaRpc>>LocalSystemNetworkRestricted.dat
	@ECHO.AllUserInstallAgent>>LocalSystemNetworkRestricted.dat
	@ECHO.svsvc>>LocalSystemNetworkRestricted.dat
	@ECHO.fhsvc>>LocalSystemNetworkRestricted.dat
	@ECHO.DeviceAssociationService>>LocalSystemNetworkRestricted.dat
	@ECHO.vmickvpexchange>>LocalSystemNetworkRestricted.dat
	@ECHO.vmicshutdown>>LocalSystemNetworkRestricted.dat
	@ECHO.vmicvss>>LocalSystemNetworkRestricted.dat
	@ECHO.FontCache>>LocalService.dat
	@ECHO.bthserv>>LocalService.dat
	@ECHO.AppIDSvc>>LocalServiceNetworkRestricted.dat
	@ECHO.wcmsvc>>LocalServiceNetworkRestricted.dat
	@ECHO.vmictimesync>>LocalServiceNetworkRestricted.dat
	)
REG.EXE QUERY "%__%" /v LocalSystemNetworkRestricted >temp00-X64
SED "/.*   /!d; s///; s/\\0$//g; s/\\0/\n/g " temp00-X64 >temp01-X64
GREP -xivf LocalSystemNetworkRestricted.dat temp01-X64 >temp02-X64
GREP -sq . temp02-X64 &&(
	ECHO.
	ECHO.%__%  - LocalSystemNetworkRestricted
	TYPE temp02-X64
	)>>ComboFix.txt
@DEL /A/F/Q temp0?-X64


REG.EXE QUERY "%__%" /v LocalService >temp00-X64
SED "/.*   /!d; s///; s/\\0$//g; s/\\0/\n/g" temp00-X64 >temp01-X64
GREP -xivf LocalService.dat temp01-X64 >temp02-X64
GREP -sq . temp02-X64 &&(
	ECHO.
	ECHO.%__%  - LocalService
	TYPE temp02-X64
	)>>ComboFix.txt
@DEL /A/F/Q temp0?-X64


REG.EXE QUERY "%__%" /v NetworkService >temp00-X64
SED "/.*   /!d; s///; s/\\0$//g; s/\\0/\n/g" temp00-X64 >temp01-X64
GREP -xivf NetworkService.dat temp01-X64 >temp02-X64
GREP -sq . temp02-X64 &&(ECHO.%__%  - NetworkService&TYPE temp02-X64)>>ComboFix.txt
@DEL /A/F/Q temp0?-X64


REG.EXE QUERY "%__%" /v LocalServiceNetworkRestricted >temp00-X64
SED "/.*   /!d; s///; s/\\0$//g; s/\\0/\n/g" temp00-X64 >temp01-X64
GREP -xivf LocalServiceNetworkRestricted.dat temp01-X64 >temp02-X64
GREP -sq . temp02-X64 &&(ECHO.%__%  - LocalServiceNetworkRestricted&TYPE temp02-X64)>>ComboFix.txt
@DEL /A/F/Q temp0?-X64



REG.EXE QUERY "HKLM\software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /s >temp00-X64
SED -r "/^H|^    Debugger    /I!d" temp00-X64 >temp01-X64
SED -r ":a; $!N; s/\n    (debugger)    REG_\S*    /	\x22\1\x22=/I;ta;P;D" temp01-X64 >temp02-X64
SED -r "/^H.*\\Your Image File Name Here without a path/Id" temp02-X64 >temp03-X64
SED -r "/\x22=/!d;" temp03-X64 >temp04-X64
SED -r "s/(.*)	(.*)/\n[\1]\n\2/" temp04-X64 >>ComboFix.txt
DEL /A/F/Q temp0?-X64



REG.EXE QUERY "HKLM\software\microsoft\active setup\installed components" /s >temp00-X64
GREP -Fivf active_setup.dat temp00-X64 >temp01-X64
SED -n -r "/stubpath	.*	.|hkey_/I!d; /stubpath	/I{s/.*	/\t/; H; g; p;} ;h" temp01 | SED -r -f run.sed | SED ":a; $!N;s/\n	/	/;ta;P;D" >temp02-X64
FOR /F "TOKENS=*" %%G IN ( temp02-X64 ) DO @CMD /C ECHO.%%G>>temp03-X64

IF EXIST temp03-X64 @FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( temp03-X64 ) DO @IF EXIST "%%~F$PATH:H" (
		ECHO.&ECHO.[%%~G]
		PEV -rtf -c:##m#b#u#b#t#b#f# "%%~F$PATH:H"
	)>>ComboFix.txt ELSE IF EXIST bak.dat (
		ECHO.&ECHO.[%%~G]
		ECHO.%%H [N/A]
	)>>ComboFix.txt ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\ActiveSetup-%%~NXG.reg.dat" (
		ECHO.[%%~G]
		ECHO.%%H [BU]
	)>>ComboFix.txt ELSE (
		REGEDIT.EXE /a "%SystemDrive%\Qoobox\Quarantine\Registry_backups\ActiveSetup-%%~NXG.reg.dat" "%%~G"
		ECHO."%%~NXG">>delclsid00-X64
		ECHO.[-%%~G]>>CregCx64.dat
		ECHO.ActiveSetup-%%~NXG - %%~H>>Orphans.dat
		)
@DEL /A/F/Q temp0? active_setup.dat
@GOTO :EOF




:RunParse
@FOR /F "TOKENS=1-3 DELIMS=	" %%H IN ( RegRuns02-X64 ) DO @IF EXIST "%%~F$PATH:J" (
		PEV -rtf -c:#"%%~I"="%%~J" [#m #u]# "%%~F$PATH:J" >>RegRuns0A-X64
	) ELSE IF EXIST bak.dat (
		ECHO."%%~I"="%%~J" [N/A]>>RegRuns0A-X64
	) ELSE IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~H-%%~I.reg.dat" (
		ECHO."%%~I"="%%~J" [BU]>>RegRuns0A-X64
	) ELSE (
		ECHO.REGEDIT4>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~H-%%~I.reg.dat"
		ECHO.>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~H-%%~I.reg.dat"
		ECHO.[%%~G]>>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~H-%%~I.reg.dat"
		FINDSTR -BIRC:".%%~I.=" RegRunsOri-X64 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~H-%%~I.reg.dat"
		ECHO."%%~I"=->>RegRuns0B-X64
		ECHO.%%~H-%%~I - %%~J>>Orphans.dat
		)

@DEL /A/F RegRuns02-X64
@GOTO :EOF


:Bho-Orph
@FOR /F "TOKENS=1,2 delims=	" %%G in ( Bho-Orph-X64 ) DO @(
	REGEDIT.EXE /A "%SystemDrive%\Qoobox\Quarantine\Registry_backups\BHO-%%~G.reg.dat" "hkey_local_machine\software\Microsoft\windows\currentversion\explorer\browser helper objects\%%~G"
	REGEDIT.EXE /A BHO00-X64 "HKEY_CLASSES_ROOT\CLSID\%%~G"
	IF EXIST BHO00-X64 (
		TYPE BHO00-X64 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\BHO-%%~G.reg.dat"
		DEL /A/F BHO00-X64
		)
	ECHO."%%~G">>delclsid00-X64
	ECHO.BHO-%%~G - %%~H>>Orphans.dat
	)

@DEL /A/F Bho-Orph-X64
@GOTO :EOF

:ToolB-Orph
@FOR /F "TOKENS=1-3 DELIMS=	" %%G in ( ToolB-Orph-X64 ) DO @(
	ECHO."%%~G">>DelClsid00-X64
	REG.EXE QUERY "HKCR\CLSID\%%~G" /s >ToolB-Orph01-X64
	SED -n -r -f toolbar.sed ToolB-Orph01-X64 >ToolB-Orph02-X64
	SED "s/^HKEY.*/[-&]/" ToolB-Orph02-X64 >>CregCx64.dat
	IF EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~H-%%~G.reg.dat" DEL /A/F "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~H-%%~G.reg.dat"
	FOR /F "TOKENS=*" %%L IN ( ToolB-Orph02-X64 ) DO @(
		ECHO.>ToolB-Orph03-X64
		REGEDIT.EXE /A ToolB-Orph03-X64 "%%L"
		Type ToolB-Orph03-X64 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~H-%%~G.reg.dat"
		DEL /A/F ToolB-Orph03-X64
		)
	FINDSTR -I "^\[ %%~G" ToolB-00-X64 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~H-%%~G.reg.dat"
	ECHO.%%~H-%%~G - %%~I>>Orphans.dat
	)

@DEL /A/F ToolB-Orph-X64 ToolB-Orph01-X64 ToolB-Orph02-X64
@GOTO :EOF


:SSODL-Orph
@FOR /F "TOKENS=1-3 DELIMS=	" %%G in ( SSODL-Orph-X64 ) DO @(
	REGEDIT.EXE /A "%SystemDrive%\Qoobox\Quarantine\Registry_backups\SSODL-%%~H-%%~G.reg.dat" "HKEY_CLASSES_ROOT\CLSID\%%~G"
	IF NOT EXIST BHO00-X64 REGEDIT.EXE /A BHO00-X64 "HKEY_LOCAL_MACHINE\software\microsoft\windows\currentversion\ShellServiceObjectDelayLoad"
	IF EXIST BHO00-X64 FINDSTR -I "^\[ %%~G" BHO00-X64 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\SSODL-%%~H-%%~G.reg.dat"
	ECHO."%%~G">>delclsid00-X64
	ECHO.[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad]>>CregCx64.dat
	ECHO."%%~H"=-| SED "s/\\/&&/g" >>CregCx64.dat
	ECHO.SSODL-%%~H-%%~G - %%~I>>Orphans.dat
	)

@DEL /A/F SSODL-Orph-X64
@GOTO :EOF


:022-Orph
@FOR /F "TOKENS=1-3 delims=	" %%G in ( 022-Orph-X64 ) DO @(
	REGEDIT.EXE /A "%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~NG-%%~H.reg.dat" "HKEY_CLASSES_ROOT\CLSID\%%~H"
	IF NOT EXIST BHO00-X64 REGEDIT.EXE /A BHO00-X64 "%%~G"
	IF EXIST BHO00-X64 FINDSTR -I "^\[ %%~H" BHO00-X64 >>"%SystemDrive%\Qoobox\Quarantine\Registry_backups\%%~NG-%%~H.reg.dat"
	ECHO."%%~H">>delclsid00-X64
	ECHO.%%~NG-%%~H - %%~I>>Orphans.dat
	)

@DEL /A/F 022-Orph-X64
@GOTO :EOF

