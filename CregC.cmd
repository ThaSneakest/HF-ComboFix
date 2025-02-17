
@IF NOT EXIST badclsid.c GOTO :EOF
REM Buggy PEV
@PEV.exe CLSID d badclsid.c badclsid0
@GREP . badclsid0 > badclsid
rem @GREP . badclsid.dat > badclsid

@PEV.exe CLSID d clsid.c clsid0
@GREP . clsid0 >clsid.dat
@DEL /A/F badclsid.c badclsid0 clsid0

@SWREG QUERY "HKCR\LivePlus.clsLivePlus\Clsid" /ve >LivePlus00
@SED -r "/.*\t/!d; s///" LivePlus00 > LivePlus01
@FOR /F "TOKENS=*" %%G IN ( LivePlus01 ) DO @(
	SWREG QUERY "HKCR\CLSID\%%~G\InprocServer32" /ve >LivePlus02
	GREP -Eisq "%systemroot:\=\\%\\[a-z]{4}[0-9]{3,4}\.dll" LivePlus02 && ECHO.%%~G>>badclsid
	)
@DEL /A/Q LivePlus0?


@IF EXIST W6432.dat (
	REG.EXE SAVE HKCR\CLSID Clsid.hiv
) ELSE SWREG.exe SAVE HKCR\CLSID Clsid.hiv

@(
SWREG.exe QUERY HKCR\CLSID
SWREG.exe QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats"
SWREG.exe QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings"
SWREG.exe QUERY "HKCU\Software\Microsoft\Internet Explorer\Explorer Bars"
REM SWREG.exe QUERY "HKCU\SOFTWARE\Microsoft\Active Setup\Installed Components"
SWREG.exe QUERY "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects"
SWREG.exe QUERY "HKLM\Software\Microsoft\Internet Explorer\Explorer Bars"
SWREG.exe QUERY "HKLM\Software\Microsoft\Internet Explorer\Extensions"
SWREG.exe QUERY "HKLM\Software\Microsoft\Windows\CurrentVersion\Ext\PreApproved"
SWREG.exe QUERY "HKLM\SOFTWARE\Microsoft\Code Store Database\Distribution Units"
SWREG.exe QUERY "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components"
)>CregC_00

@SED.exe "s/./\\&/" badclsid >badclsidB
@GREP.exe -Fif badclsidB CregC_00 >CregC_01

@SED.exe "/^HKEY_CLASSES_ROOT.*\\/!d; s///" CregC_01 >delclsid0x
@FOR /F "TOKENS=*" %%G IN ( delclsid0x ) DO @SWREG.exe QUERY "HKCR\CLSID\%%~G" /s >>ClsidKeys0x

@SED.exe -r "/^H|^ +<NO NAME>	.*	./!d; s/\x22//g" ClsidKeys0x |SED.exe -r ":a; $!N;s/(HKEY_CLASSES_ROOT)\\clsid\\[^\\]*(\\ProgID|\\Programmable|(\\TypeLib)|\\VersionIndependentProgID)\n .*	(.*)/\1\3\\\4/;ta;P;D;" | GREP.exe -Evi "ROOT\\clsid\\|	" >>CregC_01

@ECHO.REGEDIT4 >CregC_.dat
@SED.exe -r "s/.*/\[-&]/" CregC_01 >>CregC_.dat

@SWREG.exe EXPORT "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Sharedtaskscheduler" STS.cfreg /NT4
@SWREG.exe EXPORT "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Shellexecutehooks" SEH.cfreg /NT4
@SWREG.exe EXPORT "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Toolbar" mToolbar.cfreg /NT4
@SWREG.exe EXPORT "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved" ShellExt.cfreg /NT4
@SWREG.exe EXPORT "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\URLSearchHooks" UrlSearchHook.cfreg /NT4
@SWREG.exe EXPORT "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Toolbar\Webbrowser" WebBrowser.cfreg /NT4
@SWREG.exe EXPORT "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Toolbar" uToolbar.cfreg /NT4
@SWREG.exe EXPORT "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Extensions\Cmdmapping" CmdMap.cfreg /NT4
@SWREG.exe EXPORT "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad" SSODL.cfreg /NT4

@COPY /Y badclsid badclsidC
@ECHO.[HKEY>>badclsidC
@GREP.exe -hFif badclsidC *.cfreg | SED.exe "s/\x22=.*/\x22=-/" >>CregC_.dat

@SWREG.exe QUERY "HKLM\software\microsoft\active setup\installed components" > ActiveSetup00
:: @SWREG.exe QUERY "HKCU\software\microsoft\active setup\installed components" >> ActiveSetup00
@SED.exe -R "/\\\{(?=.*[g-z])(?!.*[\\]).{8}-.{4}-.{4}-.{4}-.{12}}$/I!d; s/.*/\[-&]/" ActiveSetup00 >> CregC_.dat

@DEL /A/F/Q CregC_0? *.cfreg badclsidB badclsidC ClsidKeys0x delclsid0x ActiveSetup00
@GOTO :EOF


@FOR /F "TOKENS=*" %%G IN ( delclsid0x ) DO @(
	SWREG.exe QUERY "HKCR\CLSID\%%~G" /s >ClsidKeys0x
	SED.exe -r "/^H|^ +<NO NAME>	.*	./!d; s/\x22//g" ClsidKeys0x |SED.exe -r ":a; $!N;s/(HKEY_CLASSES_ROOT)\\clsid\\[^\\]*(\\ProgID|\\Programmable|(\\TypeLib)|\\VersionIndependentProgID)\n .*	(.*)/\1\3\\\4/;ta;P;D;" | GREP.exe -Evi "ROOT\\clsid\\|	" | MTEE ClsidLinks >>CregC_01
	SWREG.exe EXPORT "HKCR\CLSID\%%~G" "%SystemDrive%\Qoobox\Quarantine\Registry_backups\CLSID_%%~G.reg.dat"
	FOR /F "TOKENS=*" %%H IN ( ClsidLinks ) DO @(		
		SWREG.exe EXPORT "%%~H" ClsidLinks00
		CMD /U /C ECHO.>> "%SystemDrive%\Qoobox\Quarantine\Registry_backups\CLSID_%%~G.reg.dat"
		CMD /U /C TYPE ClsidLinks00 >> "%SystemDrive%\Qoobox\Quarantine\Registry_backups\CLSID_%%~G.reg.dat"
		DEL /A/F ClsidLinks00
		)
	DEL /A/F ClsidKeys0x ClsidLinks
	)
@DEL /A/F delclsid0x





