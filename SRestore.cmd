
@SET "ExecXC=bat|cmd|com|dll|pif|reg|scr|sys|vbs|vir|exe|bin|wsf|vbe|zip|tmp|drv"

@(
ECHO.\desktop.ini	
ECHO.\ntuser.ini	
ECHO..lnk	 
ECHO.:\QooBox\
ECHO.\NIRCMD.exe	
ECHO.\SWREG.exe	
ECHO.:\ComboFix
ECHO.\VFIND.exe	
ECHO.\swxcacls.exe	
ECHO.\swsc.exe	
ECHO.%systemroot%\ERDNT\
ECHO.\ComboFix.exe	
ECHO.:\RECYCLER\
ECHO.:\Recycled\
ECHO.:\$Recycle.Bin\
ECHO.%system%\drivers\ComboFix.sys	
ECHO.%system%\drivers\Combo-Fix.sys	
ECHO.:\cmdcons\
ECHO.:\32788R22FWJFW\	
ECHO.%systemroot%\PEV.exe	
ECHO.%systemroot%\sed.exe	
ECHO.%systemroot%\grep.exe	
ECHO.%systemroot%\zip.exe	
)>StrRestore


@IF EXIST F_System swxcacls "\System Volume Information\"  /e /ga:r /q
@PEV -td "\System Volume Information\RP*" -output:temp00
@FOR /F "TOKENS=*" %%G IN ( temp00 ) DO @CALL :SRestore_A "%%G"

@GREP -Fivf StrRestore temp04 >temp05
@SORT /M 65536 temp05 /T %cd% /O temp06

@START NircmdB.exe cmdwait 12000 KillProcess SED.%cfExt%
@SED -r "/%system:\=\\%\\CF[0-9]*\.exe/Id; :a;$!N; s/(.[^	]*)(	.*)\n\1/\1\2/; ta;P;D;" temp06 >temp07
@SED -r "s/	([^	]*)	.*	/\n\1\n/;s/	/\n/g" temp07 >temp08
@PEV -k NIRCMD.%cfExt%

@FOR /F "TOKENS=*" %%G IN (  temp08 ) DO @ECHO.%%~FTZG>>temp09
@IF EXIST F_System swxcacls "%systemdrive%\system volume information" /P /GS:F /I REMOVE /Q
SED "/_restore/I!s/^/\n/; s/.:.System Volume Information\\[^\\]*//" temp09 >temp0A

@Grep -Fisq \ temp0A ||@(
	DEL /A/F/Q temp0? N_\* Restore StrRestore
	GOTO :EOF
	)


@ECHO.(((((((((((((((((((((((((((((((((((((((   System Restore   )))))))))))))))))))))))))))))))))))))))))))))))))))>>ComboFix.txt
@ECHO.>>ComboFix.txt
@Type temp0A >>ComboFix.txt
@ECHO.>>ComboFix.txt

@DEL /A/F/Q temp0? N_\* Restore StrRestore
@GOTO :EOF



:SRestore_A
@PUSHD %*
@TYPE change.log* | GSAR -F -s:x1A -r >"%~dp0temp03"
@START NircmdB.exe cmdwait 10000 KillProcess SED.%cfExt%

@SED -r "s/\x00//g; s/\x22\x05/\x00/g; s/\\[[:print:]]*\x00A/\n%systemdrive%&/Ig" "%~dp0temp03" |(
	SED -r "/^.:\\.*(%ExecXC%)\x00/I!d; s/\x00(A.{11}).*/	%cd:\=\\%\\\1/" )>>"%~dp0temp04"

@PEV -k NIRCMD.%cfExt%
@DEL /A/F "%~dp0temp03"
@POPD
@GOTO :EOF

