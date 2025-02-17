


REGT /a APISvc "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services"

SWREG SAVE "HKLM\software\microsoft\windows\currentversion\run" temp00.hiv &&@(
	DumpHive -e temp00.hiv runs.dat "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion"
	SWREG QUERY "HKLM\software\microsoft\windows\currentversion\run" >temp00
	SED -r "/	/!d;s/ +//" temp00 | SED "s/	.*//;s/<NO NAME>/@/;s/.*/\x22&\x22/;s/\\/&&/g" >enum.dat
	ECHO."""">>enum.dat
	SED "/^@/d;/./{H;$!d;};x;/\\Run]/I!d" runs.dat >temp01
	GREP -Fivf enum.dat temp01 >temp02
	SED "/^@/d;/./{H;$!d;};x;/=/I!d" temp02 >>rawreg.dat
	DEL /A/F/Q temp0? N_\* runs.dat temp00.hiv enum.dat
	)


SWREG SAVE "hkcu\software\microsoft\windows\currentversion\run" temp00.hiv &&@(
	DumpHive -e temp00.hiv runs.dat "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion"
	SWREG QUERY "hkcu\software\microsoft\windows\currentversion\run" >temp00
	SED "/	/!d" temp00 | SED "s/^ *//; s/	.*//; s/<NO NAME>/@/; s/.*/\x22&\x22/;s/\\/&&/g" >enum.dat
	ECHO."""">>enum.dat
	SED "/^@/d;/./{H;$!d;};x;/\\Run]/I!d" runs.dat >temp01
	GREP -Fivf enum.dat temp01 >temp02
	SED "/^@/d;/./{H;$!d;};x;/=/I!d" temp02 >>rawreg.dat
	DEL /A/F/Q temp0? N_\* runs.dat temp00.hiv enum.dat
	)



@SET "HIV=%CD%\HIV"
@START /WAIT ERUNT "%HIV%" SYSREG CURUSER OTHERUSERS /NOCONFIRMDELETE /NOPROGRESSWINDOW
@IF NOT EXIST "%HIV%\System" IF NOT EXIST W6432.dat Catchme -l N_\%random% -c "%system%\config\system" "%HIV%\System"
@SET HIV=

DEL /A/F RegLock.dat
SED -r ":a; $!N;s/\n\x22(Users\\0000)/	\x22HIV\\\1/I;ta;P;D" HIV\ERDNT.INF >RegLock01
SED -r "/	/!d;" RegLock01 >RegLock02
SED -r "s/USERS /HIV\\/; s/(.*)	(.*)/@move \/y \2 \1/" RegLock02 >RegLock01.bat
@ECHO.@ECHO.^>NULL >> RegLock01.bat
Call RegLock01.bat

MOVE /Y HIV\default HIV\.Default
@IF EXIST Vista.krl GOTO VistaHIV
DumpHive -e "HIV\System" System.dump HKEY_LOCAL_MACHINE
Dumphive -e HIV\software Software.dump HKEY_LOCAL_MACHINE
Dumphive -e HIV\.Default Default.dump HKEY_USERS\.Default
FOR %%G IN (HIV\S-1*.) DO @Dumphive -e "%%G" "%%~NG.dump" HKEY_USERS

:HIV_DUMPED
RD /S/Q HIV

SET _=%CS000:~-12,1%
SET __=%CS000:~-11,1%
SET ___=%CS000:~-10,1%


SED -R "/./{H;$!d;}; x;/ACCESS_DENIED_ACE_TYPE:(?=.*\(S-1-([13]-0|5-32-544|5-18|5-[0-9]*-[0-9]*-[0-9]*-[0-9]*-5(00|12|19))\))|@DACL=\(.* 0000\)|\n.SymbolicLinkValue.=|\n\[H.*\x00/I!d; /\[H.*\\.[^ -~].[^ -~][^\\]*[^ -~][]\\]|\[H.*\\[^\\]*\x00.\x00.\x00[^\\]*]|\[HKEY_LOCAL_MACHINE\\software\\Microsoft\\(Office|Schema Library)\\|\[HKEY_LOCAL_MACHINE\\software\\Microsoft\\Windows NT\\CurrentVersion\\Windows]|\[HKEY_LOCAL_MACHINE\\system\\ControlSet([^%_%]|[%_%][^%__%]|[%_%][%__%][^%___%])|\[(HKEY_LOCAL_MACHINE|HKEY_USERS)\\CMI-CreateHive\{|\[HKEY_LOCAL_MACHINE\\software\\Classes\\(CLSID\\\{(A483C63A-CDBC-426E-BF93-872502E8144E|0BE09CC1-42E0-11DD-AE16-0800200C9A66|19114156-8E9A-4D4E-9EE9-17A0E48D3BBB|1D4C8A81-B7AC-460A-8C23-98713C41D6B3|3DA165B6-CC41-11d2-BDC6-00C04F79EC6B|8D8763AB-E93B-4812-964E-F04E0008FD50|D27CDB6E-AE6D-11cf-96B8-444553540000|D27CDB70-AE6D-11cf-96B8-444553540000|D4304BCF-B8E9-4B35-BEA0-DC5B522670C2|47629D4B-2AD3-4e50-B716-A66C15C63153|604BB98A-A94F-4a5c-A67C-D8D3582C741C|684373FB-9CD8-4e47-B990-5A4466C16034|74554CCD-F60F-4708-AD98-D0152D08C8B9|7EB537F9-A916-4339-B91B-DED8E83632C0|948395E8-7A56-4fb1-843B-3E52D94DB145|AC3ED30B-6F1A-4bfc-A4F6-2EBDCCD34C19|DE5654CA-EB84-4df9-915B-37E957082D6D|E39C35E8-7488-4926-92B2-2F94619AC1A5|EACAFCE5-B0E2-4288-8073-C02FF9619B6F|F8F02ADD-7366-4186-9488-C21CB8B3DCEC|FEE45DE2-A467-4bf9-BF2D-1411304BCD84|1171A62F-05D2-11D1-83FC-00A0C9089C5A)}|Interface\\\{(E3F2C3CB-5EB8-4A04-B22C-7E3B4B6AF30F|DDF4CE26-4BDA-42BC-B0F0-0E75243AD285|1D4C8A81-B7AC-460A-8C23-98713C41D6B3|2E4BB6BE-A75F-4DC0-9500-68203655A2C4)}|TypeLib\\\{(D27CDB6B-AE6D-11CF-96B8-444553540000|FAB3E735-69C7-453B-A446-B6823C6DF1C9)})/Id" *.dump >RegLock00


SED -r "/INHERITED_ACE|SE_DACL_AUTO_INHERITED|@DACL=(.* 000[^0])/d; s/INHERITED_ACE/Inherited/;" RegLock00 >RegLock03
SED -f RegDacl.sed RegLock03 >RegLock04
SED -r "/./{H;$!d;};x;/\n\x22|\n@/!d;" RegLock04 >RegLocks.txt

FINDSTR . RegLocks.txt || DEL /A/F RegLocks.txt
DEL /A/F/Q S-1*.dump Software.dump Default.dump RegLock0?.*

SET _=
SET __=
SET ___=



SED "/./{H;$!d;};x;/\[%CS000:\=\\%/I!d" System.dump |(
	SED -r "/%CS000:\=\\%\\[^\\]*]$|ImagePath|ServiceDll.=/I!d;/svchost.*-k/Id;s/expand://;s/\\\\/\\/g;s/\[/\n[/"
	)>raw_enum.dat


START NIRKMD CMDWAIT 5000 EXEC HIDE PEV -k Grep.%cfExt%
GREP -B2 ":[^\{]" raw_enum.dat >>rawreg.dat
PEV -k NIRKMD.%cfext%
START NIRKMD CMDWAIT 2000 EXEC HIDE PEV -k Grep.%cfExt%
GREP -Fivxf sys_enum.dat raw_enum.dat >temp00
GREP -FC1 [ temp00 >>rawreg.dat
PEV -k NIRKMD.%cfext%


SED -r -n "/^\[|^$|\x22=\x22..[^\x22/]*\.(sys|exe|dll)[\x22 \\].*/I!{H;g;p;};h;" raw_enum.dat | SED "s/^\[/\n&/" >>rawreg.dat

@ECHO.[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services]>>APISvc
SED -r "/\[HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Service(s\\[^\\]*)]$/I!d; s//\1/" APISvc >temp00
ECHO.[]::\::\::>>temp00
SWREG QUERY HKLM\SYSTEM\CurrentControlSet\Services >temp01
GREP -Fivf temp00 temp01 >temp02
SED -r "/.*(s\\.*)/!d; s//\1]/" temp02 >temp03
ECHO.::::>>temp03
GREP -C1 -Fif temp03 raw_enum.dat >>rawreg.dat
DEL /A/F/Q temp0?
@GOTO :EOF


:VISTAHIV
FOR %%G IN (
"HIV\System"
"HIV\Software"
) DO @(
	Dumphive -e "%%~G" "%%~NXG.dump00"
	SED -r "s/^\[(CsiTool|CMI)-CreateHive[^\\\x5D]*/[/I; s/^\[/[HKEY_LOCAL_MACHINE\\%%~NXG/" "%%~NXG.dump00" >"%%~NXG.dump"
	)

FOR %%G IN (
"HIV\.Default"
"HIV\S-1*"
) DO @(
	Dumphive -e "%%G" "%%~NXG.dump00"
	SED -r "s/^\[(CMI-CreateHive|S-1-)[^\\\x5D]*/[/I; s/^\[/[HKEY_USERS\\%%~NXG/" "%%~NXG.dump00" >"%%~NXG.dump"
	)

Dumphive -e "HIV\BCD" "BCD.dump00"
SED "s/^\[NewStoreRoot[^\\\x5D]*/[/I; s/^\[/[HKEY_LOCAL_MACHINE\\BCD00000000/" "BCD.dump00" >"BCD.dump"

:: Dumphive -e "HIV\Compon~3" "Components.dump00"
:: SED "s/^\[CMI-CreateHive[^\\\x5D]*/[/I; s/^\[/[HKEY_LOCAL_MACHINE\\Components/" "Components.dump00" >"Components.dump"

DEL /A/F/Q *.dump00
@GOTO HIV_DUMPED

