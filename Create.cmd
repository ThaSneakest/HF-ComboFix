
@SETLOCAL
@IF EXIST mdCheck00.dat DEL /A/F mdCheck00.dat
CALL History.bat

IF EXIST SearchDateRange.dat FOR /F "TOKENS=1* DELIMS=	" %%G IN ( SearchDateRange.dat ) DO @(
		SET "Created_CF=%%G"
		SET "Modified_CF=%%HM"
		)


@(
ECHO.%Systemroot:\=\\%\\\$ntuninstall[^^\\]*$
ECHO.%Systemroot:\=\\%\\\$ntservicepackuninstall[^^\\]*$
ECHO.%Systemroot:\=\\%\\\$msi31uninstall[^^\\]*$
ECHO.%Systemroot:\=\\%\\erdnt$
ECHO.:\\autorun.inf$
ECHO.:\\.*:\\.
ECHO.\\Desktop.ini$
)>whitedirB.dat



:: CALL ECHO.(((((((((((((((((((((((((   Files Created from %%thirty%% to %%dateX%%  )))))))))))))))))))))))))))))))>>ComboFix.txt
CALL ECHO.%LINE38%>>ComboFix.txt

@ECHO.>>ComboFix.txt
@ECHO.>>ComboFix.txt

@PEV -sDcdate -rtd -c:##c#  AND { %Systemroot% OR %Systemroot%\tasks } -output:temp00
@SED -r "$!N; s/:.*\n([^:]*):.*/|\1/; s/.*/Set \x22InstallDate=&\x22/" temp00 >temp00.bat
@CALL temp00.bat >N_\%random% 2>&1
@DEL /A/F/Q temp00.bat temp00


@SET "ExecX=*.bak1 or *.bak2 or *.bat or *.cmd or *.com or *.dll or *.ini2 or *.pif or *.reg or *.ren or *.scr or *.sys or *.vbs or *.vir or *.exe or *.bin or *.wsf or *.vbe or *.dat or *.zip or *.drv or *.msi or *.msp or *.js or *.jse"
@SET "ExecXB=%ExecX% OR *.tmp"
@SET "ExecXC=*.bat or *.cmd or *.com or *.dll or *.pif or *.scr or *.sys or *.exe or *.drv or *.js or *.jse"

IF NOT DEFINED Created_CF SET "Created_CF=1M"

PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%Systemdrive%\*" >Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%Systemroot%\*" >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%system%\*" >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%ProfilesDirectory%\*" >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%Programfiles%\*" >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%CommonProgramFiles%\*" >>Create02
FOR /F "TOKENS=*" %%G IN ( profiles.folder.dat ) DO PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%%~G\*" >>Create02

IF EXIST LAEmptyFolders00 DEL /A/F LAEmptyFolders00
FOR /F "TOKENS=*" %%G IN ( localappdata.folder.dat ) DO @(
	IF EXIST Vista.krl PEV -dcg%Created_CF% -rtd -preg"\\\{[^\\]{36}\}$" "%%~G\*" >>LAEmptyFolders00
	PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF%  { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%%~G\*" >>Create02
	)
FOR /F "TOKENS=*" %%G IN ( appdata.folder.dat ) DO PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%%~G\*" >>Create02

PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -td or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%Systemroot%\system\*" >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -td or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" } "%system%\drivers\*" >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -td or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%system%\wbem\*" >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% "%system%\GroupPolicy\Machine\Scripts\Shutdown\*" not *.ini >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% "%system%\GroupPolicy\User\Scripts\Logoff\*" not *.ini >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% -tpmz "%system%\Spool\prtprocs\w32x86\*" >>Create02
REM PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemdrive%\temp\*" >>Create02
IF EXIST "%system%\dllcache\*" PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%system%\dllcache\*" >>Create02
FOR /F "TOKENS=*" %%G IN ( appdata.folder.dat ) DO PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp)$" } "%%~G\Microsoft\*" >>Create02
IF EXIST SearchMetoo.dat FOR /F "TOKENS=*" %%G IN ( SearchMetoo.dat  ) DO @PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% -tf -tpmz "%%~G\*" >>Create02

FOR %%G IN (
"ComPlus Applications"
"DVD Maker"
"Internet Explorer"
"Messenger"
"Microsoft Games"
"Movie Maker"
"Mozilla Firefox"
"MSBuild"
"MSN Gaming Zone"
"MSN"
"NetMeeting"
"Online Services"
"Outlook Express"
"Uninstall Information"
"Windows Defender"
"Windows Journal"
"Windows Mail"
"Windows Media Player"
"Windows NT"
"Windows Photo Viewer"
"Windows Portable Devices"
"Windows Sidebar"
"WindowsUpdate"
"xerox"
) DO IF EXIST "%Programfiles%\%%~G\*" PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Programfiles%\%%~G\*" >>Create02

FOR %%G IN (
"InstallShield"
"Microsoft Shared"
"MSSoap"
"ODBC"
"Services"
"System"
"Windows Live"
"WindowsLiveInstaller"
) DO IF EXIST "%CommonProgramFiles%\%%~G\*" PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%CommonProgramFiles%\%%~G\*" >>Create02


IF NOT EXIST W6432.dat GOTO Create30_2

PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%SysDir%\*" >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%ProgramFiles(x86)%\*" >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -rtd or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%CommonProgramFiles(x86)%\*" >>Create02

PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -td or -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%SysDir%\drivers\*" >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% { -td or -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp)$" } "%SysDir%\wbem\*" >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% "%SysDir%\GroupPolicy\Machine\Scripts\Shutdown\*" not *.ini >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% "%SysDir%\GroupPolicy\User\Scripts\Logoff\*" not *.ini >>Create02
PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% -tf -tpmz "%SysDir%\Spool\prtprocs\x64\*" >>Create02

FOR %%G IN (
"ComPlus Applications"
"DVD Maker"
"Internet Explorer"
"Messenger"
"Microsoft Games"
"Movie Maker"
"Mozilla Firefox"
"MSBuild"
"MSN Gaming Zone"
"MSN"
"NetMeeting"
"Online Services"
"Outlook Express"
"Uninstall Information"
"Windows Defender"
"Windows Journal"
"Windows Mail"
"Windows Media Player"
"Windows NT"
"Windows Photo Viewer"
"Windows Portable Devices"
"Windows Sidebar"
"WindowsUpdate"
"xerox"
) DO IF EXIST "%ProgramFiles(x86)%\%%~G\*" PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%ProgramFiles(x86)%\%%~G\*" >>Create02

FOR %%G IN (
"InstallShield"
"Microsoft Shared"
"MSSoap"
"ODBC"
"Services"
"System"
"Windows Live"
"WindowsLiveInstaller"
) DO IF EXIST "%CommonProgramFiles(x86)%\%%~G\*" PEV -tx50000 -c:##c . #m#b#u#b#t#b#f#b#8# -dcg%Created_CF% -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%CommonProgramFiles(x86)%\%%~G\*" >>Create02

	
:Create30_2
SED -r "s/	[^	]*\?+[^	]//; s/(:\\.*)	.:\\[^	]*$/\1/" Create02 >Create02.dat
s0rt -k8 Create02.dat | SED -n -r ":a; $!N; s/^(.*\t(.:\\.*))\n.*\t\2.*/\1/; ta; P; D" | s0rt -r >Create03

START NIRKMD CMDWAIT 10000 EXEC HIDE PEV -k sed.%cfExt%
SED -R "/^(%InstallDate%)/,$d;" Create03 >Create04
ECHO..>>Create04
SED -n -r ":a; $!N; s/\n/&/12; tz; $!ba; p; q; :z; s/^(.{17}).*\1[^\n]*\'/&/; tc; P; D; :c; $!N; s/^(.{17}).*\1[^\n]*\'/&/; tc; s/^(.*)\n([^\n]*)\'/\2/ ;P" Create04 >Create05
PEV -k NIRKMD.%cfext%

IF EXIST LAEmptyFolders00 (
	FOR /F "TOKENS=*" %%G IN ( LAEmptyFolders00 ) DO @PEV -tf "%%~G\*" ||ECHO.%%G>>whitedircreated.dat
	DEL LAEmptyFolders00
	)
	
SED -r "s/.*(.:\\.*)/\1/; s/\\/\\&/g; s/.*(.{127})$/\1/" whitedir.dat whitedircreated.dat >>whitedircreated00.dat

FINDSTR -evilg:whitedircreated00.dat Create05 >Create06

GREP -vif whitedirB.dat Create06 >30Create2.dat &&(
	SED 125q 30Create2.dat >>ComboFix.txt
	)||(
	REM ECHO.No new files created in this timespan>>ComboFix.txt
	ECHO.%Line22%>>ComboFix.txt
	)
DEL /A/F/Q Create0? Create.AppData00.dat CreateTemp0? Create.folder00.dat 

@ECHO.>>ComboFix.txt
@ECHO.>>ComboFix.txt




:: CALL ECHO.((((((((((((((((((((((((((((((((((((((((   Find3M Report   ))))))))))))))))))))))))))))))))))))))))))))))))))))>>ComboFix.txt
@CALL ECHO.%LINE39%>>ComboFix.txt
@ECHO.>>ComboFix.txt


IF NOT DEFINED Modified_CF SET "Modified_CF=3M"

PEV -c:##m . #c#b#u#b#t#b#f#b#8# -rtf { -tpmz or -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%Programfiles%\*" > temp00
PEV -c:##m . #c#b#u#b#t#b#f#b#8# -rtf { -tpmz or -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%CommonProgramFiles%\*" >> temp00
PEV -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -rtf { -tpmz or -preg"\.(bak\d|bat|cmd|com|ini2|pif|reg|ren|vbs|vir|wsf|vbe|zip|msi|msp|tmp)$" } "%Systemdrive%\*" >>temp00
PEV -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -rtf { -tpmz or -preg"\.(bak\d|bat|cmd|com|ini2|pif|reg|ren|vbs|vir|wsf|vbe|zip|msi|msp|tmp)$" } "%Systemroot%\*" >>temp00
PEV -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -rtf { -tpmz or -preg"\.(bak\d|bat|cmd|com|ini2|pif|reg|ren|vbs|vir|wsf|vbe|zip|msi|msp|tmp)$" } "%system%\*" >>temp00
PEV -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -rtf { -tpmz or -preg"\.(bak\d|bat|cmd|com|ini2|pif|reg|ren|vbs|vir|wsf|vbe|zip|msi|msp|tmp)$" } "%ProfilesDirectory%\*" >>temp00
FOR /F "TOKENS=*" %%G IN ( profiles.folder.dat ) DO PEV -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -rtf { -tpmz or -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%%~G\*" >> temp00
FOR /F "TOKENS=*" %%G IN ( localappdata.folder.dat ) DO PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -rtf { -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%%~G\*" >> temp00
FOR /F "TOKENS=*" %%G IN ( appdata.folder.dat ) DO PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -rtf { -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%%~G\*" >> temp00

PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf { -tpmz or -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%system%\drivers\*" >> temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf { -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp)$" } "%systemroot%\system\*" >> temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf { -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp)$" } "%system%\wbem\*" >> temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%system%\GroupPolicy\Machine\Scripts\Shutdown\*" >> temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%system%\GroupPolicy\User\Scripts\Logoff\*" >> temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz "%system%\Spool\prtprocs\w32x86\*" >> temp00

FOR /F "TOKENS=*" %%G IN ( appdata.folder.dat ) DO PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%%~G\Microsoft\*" >> temp00

PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\java\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\msapps\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\pif\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\security\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\Registration\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\help\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\web\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\pchealth\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\srchasst\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\tasks\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\apppatch\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\Internet Logs\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\Media\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\prefetch\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%Systemroot%\cursors\*" >>temp00
IF DEFINED FONTS PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% and { -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" or -tf -s+1 -s-2000 } "%fonts%\*" >>temp00
PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%SystemRoot%\inf\*" not -preg"\\(unregmp2\.exe|regl3acm\.exe|\.reg)$" >>temp00


IF EXIST W6432.dat (
	PEV -c:##m . #c#b#u#b#t#b#f#b#8# -rtf { -tpmz or -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%ProgramFiles(x86)%\*" >> temp00
	PEV -c:##m . #c#b#u#b#t#b#f#b#8# -rtf { -tpmz or -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%CommonProgramFiles(x86)%\*" >> temp00
	PEV -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -rtf { -tpmz or -tf -preg"\.(bat|cmd|reg|vbs|wsf|vbe|js|jse|msi|msp|com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|drv)$" } "%SysDir%\*" >> temp00
	PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf { -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" or -preg"\.(bak\d|bat|cmd|com|ini2|pif|reg|ren|vbs|vir|wsf|vbe|zip|msi|msp|tmp)$" } "%SysDir%\drivers\*" >> temp00
	PEV -tx50000 -c:##m . #c#b#u#b#t#b#f#b#8# -DG%Modified_CF% -tf -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%SysDir%\wbem\*" >> temp00
	)


SED -r "s/	[^	]*\?+[^	]//; s/(:\\.*)	.:\\[^	]*$/\1/" temp00 >temp00.dat
GREP -vif whitedirB.dat temp00.dat | GSAR -Fud >f3m0.dat
@DEL /A/F/Q temp0? temp00.dat F3M.folder0?.dat

SED -r "s/.*(.:\\)/\1/; s/\\/&&/g" Create02.dat >>whitedircreated00.dat 2>N_\%random%
SED -r "s/.*(.:\\.*)/\1/; s/.*(.{127})$/\1/" whitedircreated00.dat >temp00
REM add -eu8 for Unicode
REM SED -r "s/.*(.:\\.*)/\1/; s/(\$|\.|\[|\]|\{|\}|\^|\(|\)|\?|\+|\|)/\\&/; s/$/$/" whitedircreated00.dat >temp00

ECHO.::::>>temp00
FINDSTR -EVILG:temp00 f3m0.dat >temp01
REM GREP -vif temp00 f3m0.dat >temp01

SORT /M 65536 /r temp01 /O temp02
REM SED -n -r ":a;$!N;s/\n/&/12;tz;$!ba;p;q;:z;s/^(.{17}).*\1[^\n]*\'/&/;tc;P;D;:c;N;s/^(.{17}).*\1[^\n]*\'/&/;tc;s/^(.*)\n([^\n]*)\'/\2/;P" temp02 >temp03
SED 100q temp02 >>ComboFix.txt
@DEL /A/F/Q temp0?

PEV -c:##m . #c#b#u#b#t#b#f#b#8# -rtf "%Programfiles%\mozilla firefox\plugins\*.dll" and not np*.dll >temp00
PEV -c:##m . #c#b#u#b#t#b#f#b#8# -rtf "%Programfiles%\internet explorer\plugins\*.dll" and not np*.dll >>temp00
PEV -c:##m . #c#b#u#b#t#b#f#b#8# -rtf "%Programfiles%\opera\program\plugins\*.dll" and not np*.dll >>temp00
PEV -c:##m . #c#b#u#b#t#b#f#b#8# -rtf "%CommonAppData%\Microsoft\Internet Explorer\DLLs\*.dll" and not np*.dll >>temp00
PEV -c:##m . #c#b#u#b#t#b#f#b#8# -rtf "%Programfiles%\mozilla firefox\components\*.dll" not { browserdirprovider.dll or brwsrcmp.dll or np*.dll } >>temp00
PEV -tx50000 -c:##m#b#u#b#t#b#f#b#8# -DL3M -tf -tsh -tpmz -preg"\.(com|pif|ren|vir|tmp|dll|scr|sys|exe|bin|dat|drv)$" "%SystemRoot%\*" -skip"%SystemRoot%\Winsxs" >>temp00

SED -r "s/	[^	]*\?+[^	]//; s/(:\\.*)	.:\\[^	]*$/\1/" temp00 >>ComboFix.txt
@DEL /A/F/Q temp0? whitedir*.dat 30Create2.dat Create02.dat

IF NOT DEFINED debug DEL /A/F f3m0.dat

@ECHO.>>ComboFix.txt

IF EXIST W6432.dat (
	SED -r "s/%sysnative:\=\\%/%sysdir:\=\\%/Ig" ComboFix.txt > ComboFix.txt.tmp
	IF EXIST ComboFix.txt.tmp MOVE /Y ComboFix.txt.tmp ComboFix.txt
	)

@GOTO :EOF


