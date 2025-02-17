

color 47
cls

@ECHO.
:: @ECHO.Infected HTML files detected.
:: @ECHO.ComboFix will now attempt to disinfect
ECHO.%Line92%
ECHO.%Line93%
@ECHO.
:: @ECHO.This is going to take some time
ECHO.%Line94%
@ECHO.

REM - Bonus removals
@ECHO.var pe=new Array>>FKMGen.dat
@ECHO.tic.9966.org>>FKMGen.dat


FOR /F "TOKENS=*" %%G IN ( temp00 ) DO @(
	IF EXIST %%~SG\index.dat IF EXIST %%~SG\desktop.ini (
		GREP -Fisq "uiclsid={7bd29e00-76c1-11cf-9dd0-00a0c9034933}" %%~SG\desktop.ini &&(
		RD %%~SG
		IF EXIST %%~SG RD /S/Q %%~SG
		)))>N_\%random% 2>&1


PEV -tx50000 -tf %systemdrive%\* and { *.htm* or *.aspx or *.php } -output:temp0A
GREP -Five "%temp%" temp0A >temp01

FOR /F "TOKENS=*" %%G IN ( temp01 ) DO @TYPE "%%G" 2>N_\%random% | GREP -FisqfFKMGen.dat && @(
	%kmd% /d /c MoveIt.bat "%%~G"
	TYPE "%SystemDrive%\Qoobox\Quarantine\%systemdrive:~,1%%%~PNXG.vir" | GREP -FivsfFKMGen.dat >"%%~G"
	ECHO."%%~G" . . . . disinfected>>drev.dat
		)>N_\%random% 2>&1

DEL /A/F FKMGen.dat

color 17
:: ECHO.Disinfection complete !!! ... continuing Log Report preparation
ECHO.%Line95%

