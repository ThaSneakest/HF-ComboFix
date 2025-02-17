

@CD /D "%~DP0"

@IF EXIST CHCP.bat CALL CHCP.bat

@SET DateX >SetDateX 2>&1
@GREP "[0-9]" SetDateX ||(
	PEV TIME UTC >DateTest.dat
	SED -r "s/ .*//; s/(.*-)(.-)/\10\2/; s/(.*-)(.)$/\10\2/" DateTest.dat >DateTest01.dat
	FOR /F "TOKENS=1" %%G IN ( DateTest01.dat ) DO @SET "DateX=%%G"
	DEL /A/F/Q Datetest??.dat
	)
@DEL /A/F SetDateX

:: used for Lang.bat
@CALL :Hist 1 0
@SET "thirty=%yy%-%mm%-%dd%"

@GOTO :EOF


:Hist
@IF %Datex:~-2% LSS 10 (
	SET dd=%datex:~-1%
		) ELSE (
	SET dd=%datex:~-2%
	)


@IF %Datex:~5,2% LSS 10 (
	SET mm=%datex:~6,1%
		) ELSE (
	SET mm=%datex:~5,2%
	)


@SET yy=%datex:~0,4%


@IF %Dd% GTR %2 (
	SET /a dd=%dd%-%2
		) ELSE (
	SET /a dd=%dd%+30-%2
	SET /a mm=%mm%-1
	)


@if %mm% GTR %1 (
	SET /a mm=%mm%-%1
		) ELSE (
	SET /a mm=%mm%+12-%1
	SET /a yy=%yy%-1
	)


@IF %Dd% LSS 10 SET dd=0%dd%
@IF %mm% LSS 10 SET mm=0%mm%
@IF %Dd% GTR 28 SET dd=28

@GOTO :EOF

