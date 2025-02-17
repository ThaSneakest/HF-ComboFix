
@IF EXIST W6432.dat GOTO :EOF
@IF NOT DEFINED Qrntn GOTO :EOF

@ECHO..%*|GREP -Fsq :\ || GOTO :EOF

@SET "TARGETPATH=%~DP1"

@IF NOT EXIST "%SystemDrive%\Qoobox\Quarantine\%TARGETPATH::=%" MD "%SystemDrive%\Qoobox\Quarantine\%TARGETPATH::=%"

@IF /I "%~X1" NEQ ".SYS" (
	CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -Z "%SystemDrive%\Qoobox\Quarantine\%TARGETPATH::=%_%~N1_%~X1.zip" -k "%~1"
		) ELSE IF "%~Z1" LSS "1024" (
	CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -Z "%SystemDrive%\Qoobox\Quarantine\%TARGETPATH::=%_%~N1_%~X1.zip" -k "%~1"
	CATCHME -l N_\%random% -i "%~1"
	CATCHME -l N_\%random% -E "%~1"
		) ELSE IF NOT EXIST f_system (
	CATCHME -l %SystemDrive%\Qoobox\Quarantine\catchme.log -Z "%SystemDrive%\Qoobox\Quarantine\%TARGETPATH::=%_%~N1_%~X1.zip" -k "%~1"
		) ELSE (
	SWXCACLS "%~1" /OA /Q
	SWXCACLS "%~1" /P /GE:F /Q
	FileKill -N CFcatchme -l %SystemDrive%\Qoobox\Quarantine\catchme.log -Z "%SystemDrive%\Qoobox\Quarantine\%TARGETPATH::=%_%~N1_%~X1.zip" -o "%~1" combo-fix.sys
	)

@SET TARGETPATH=
@GOTO :EOF

