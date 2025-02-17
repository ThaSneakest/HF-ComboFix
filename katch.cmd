@ECHO OFF
@SETLOCAL
IF EXIST Win7.mac GOTO :EOF
IF EXIST W6432.dat GOTO :EOF

:: %CATCHME% -l N_\%random% -e pIofCallDriver

SWSC QUERYEX OPTIONS= config TYPE= DRIVER GROUP= "SCSI MINIPORT" | SED -r "/^ +BINARY_PATH_NAME.*\\System32\\drivers\\(.*)/I!d; s//\1/; /\\dtscsi\.sys/Id" >HDCntrl01

IF EXIST NoMbr.dat GOTO SkipMbr
START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k RMBR.%cfExt%

RMBR >mbr.txt
GREP -isqx "\\Device\\.* -> .* device not found" mbr.txt &&RMBR -t -s >mbr.txt
RMBR -u
PEV -k NIRKMD.%cfext%

:SkipMbr
SET @pt_=
PEV -rtf %systemdrive%\Qoobox\ComboFix-quarantined-files.txt -dg48h &&SET "@pt_=REM"

(
NIRCMDC EXEC HIDE %Catchme% -l N_\%random% -Dqf "%system%"

%Catchme% -l N_\%random% -IDqf "%systemroot%"

%Catchme% -l N_\%random% -Iqdf "%system%\drivers"

%@pt_% %Catchme% -l N_\%random% -Iqdf "%system%\wbem"

%@pt_% %Catchme% -l N_\%random% -Idqf "%Temp%"

%@pt_% IF DEFINED SysTemp %Catchme% -l N_\%random% -Idqf "%SysTemp%"

REM IF DEFINED Fonts %Catchme% -l N_\%random% -dqf "%Fonts%"

%@pt_% IF DEFINED ActiveX %Catchme% -l N_\%random% -dqf "%ActiveX%"

IF DEFINED Startup %Catchme% -l N_\%random% -Dqf "%StartUp%"

IF DEFINED CommonStartUp %Catchme% -l N_\%random% -Dqf "%CommonStartup%"

%@pt_% %Catchme% -l N_\%random% -IDqf %systemdrive%

%@pt_% %Catchme% -l N_\%random% -Iqdf "%Appdata%"
)>Catchlog


