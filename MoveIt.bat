

@IF NOT DEFINED QrntnB SET "QrntnB=\Qoobox\Quarantine"

@ECHO..%CMDCMDLINE%>N_\CmdLine00
@GREP -Fsq :\  N_\CmdLine00 || GOTO :EOF
	
@IF NOT EXIST N_\Ampersand.dat (
 	GREP -Fsq %% N_\CmdLine00 && CALL :Ampersand "%~1"
) ELSE DEL /A/F N_\Ampersand.dat

@DIR /A-D "\\?\%~1" ||GOTO :EOF


@SET "TargetX_=%~1"
@SET "Drive=%TargetX_:~,1%"
@IF NOT EXIST "%Drive%:%QrntnB%\%Drive%%~P1" MD "%Drive%:%QrntnB%\%Drive%%~P1"
@IF /I "%~2"=="MoveEx" GOTO MvEx


@IF EXIST f_system (
	SWXCACLS "\\?\%~1" /OA /Q
	SWXCACLS "\\?\%~1" /P /GE:F /Q
	)


@ATTRIB -H -R -S "%~1"
@ATTRIB -H -R -S "\\?\%~1"
@MOVE /Y "\\?\%~1" "\\?\%Drive%:%QrntnB%\%TargetX_::=%.vir"
@DIR /A-D "\\?\%~1" && MOVE /Y "%~s1" "%Drive%:%QrntnB%\%TargetX_::=%.vir"
@SET TargetX_=
@IF /I "%~2"=="ND_" GOTO :EOF
@DIR /A-D "\\?\%~1" || GOTO :EOF

@IF EXIST W6432.dat GOTO :EOF


:MvExB
@IF NOT EXIST CfReboot.dat ECHO.>CfReboot.dat
@ECHO."%~1">>d-del4AV.dat

@IF /I "%~X1" EQU ".SYS" IF "%~z1" GEQ "1025" IF EXIST f_system (
	FileKill -N CFcatchme -l "%QrntnB%\catchme.log" -Z "%QrntnB%\%Drive%%~P1_%~N1_%~X1.zip" -o "%~1" combo-fix.sys
	GOTO :EOF
	)

@CATCHME -l "%QrntnB%\catchme.log" -Z "%QrntnB%\%Drive%%~P1_%~N1_%~X1.zip" -k "%~1"
@GOTO :EOF



:MvEx
@PEV MoveEx "\\?\%Drive%:%QrntnB%\%Drive%%~P1MoveEx_%~NX1.vir"
@PEV MoveEx "\\?\%~1" "\\?\%Drive%:%QrntnB%\%Drive%%~P1MoveEx_%~NX1.vir"

@IF NOT DEFINED System Set "System=%systemroot%\system32"

@IF NOT EXIST pend.txt (
ECHO..:\\\^(0!\^|0\\0\^)
ECHO.%system:\=\\%\\\^(\\\^|0!\^|0\\0\^)
ECHO.%system:\=\\%\\config\\\^(\\\^|0!\^|0\\0\^)
ECHO.%system:\=\\%\\csrss.exe\\\^(0!\^|0\\0\^)
ECHO.%system:\=\\%\\Drivers\\\^(\\\^|0!\^|0\\0\^)
ECHO.%system:\=\\%\\hal.dll\\\^(0!\^|0\\0\^)
ECHO.%system:\=\\%\\lsass.exe\\\^(0!\^|0\\0\^)
ECHO.%system:\=\\%\\ntdll.dll\\\^(0!\^|0\\0\^)
ECHO.%system:\=\\%\\services.exe\\\^(0!\^|0\\0\^)
ECHO.%system:\=\\%\\smss.exe\\\^(0!\^|0\\0\^)
ECHO.%system:\=\\%\\svchost.exe\\\^(0!\^|0\\0\^)
ECHO.%system:\=\\%\\userinit.exe\\\^(0!\^|0\\0\^)
ECHO.%system:\=\\%\\wbem\\\^(\\\^|0!\^|0\\0\^)
ECHO.%system:\=\\%\\winlogon.exe\\\^(0!\^|0\\0\^)
ECHO.%systemDrive%\\boot.ini\\\^(0!\^|0\\0\^)
ECHO.%systemDrive%\\ntdetect.com\\\^(0!\^|0\\0\^)
ECHO.%systemDrive%\\ntldr\\\^(0!\^|0\\0\^)
ECHO.%systemroot:\=\\%\\\^(\\\^|0!\^|0\\0\^)
ECHO.%systemroot:\=\\%\\explorer.exe\\\^(0!\^|0\\0\^)
)>pend.txt


@SWREG QUERY "hklm\system\currentcontrolset\control\session manager" /v pendingfilerenameoperations >temp00
@GREP -iqf pend.txt temp00 &&SWREG delete "hklm\system\currentcontrolset\control\session manager" /v pendingfilerenameoperations

@GOTO :EOF

:Ampersand
@SED -r "s/.* +(\x22*.:\\.*)/\1/;" N_\CmdLine00 >N_\Ampersand.dat
@FOR /F "TOKENS=*" %%G IN ( N_\Ampersand.dat ) DO @%KMD% /D /C MoveIt.bat %%~SG
@DEL /A/F N_\Ampersand.dat
@GOTO :EOF


