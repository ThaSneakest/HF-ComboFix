

@PROMPT $
@CD /D "%~DP0"
@IF EXIST CHCP.bat CALL CHCP.bat
@SET PATHEXT >SETPathExt
@GREP -qi "\.%cfExt%;" SETPathExt || SET "pathext=.%cfExt%;%pathext%"
@DEL /A/F SETPathExt

FOR /F "TOKENS=*" %%G IN ( kmd.dat ) DO SET "kmd=%%G"



SWREG QUERY "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" | SORT /M 65536 /T %cd% /O MachineShellFolders00
SED -r "/^ +Common (StartUp|Programs)	.*	/I!d; s///; " MachineShellFolders00 | SED -r "N; s/^(.*)\n\1/\1	\1/I; /	/!d" | GREP -sq . || CALL :FixStartUp
@DEL /A/F/Q MachineShellFolders00


IF NOT EXIST %systemdrive%\Qoobox\BackEnv\ MD %systemdrive%\Qoobox\BackEnv
PEV -rtf -d:G10 %systemdrive%\qoobox\backenv\SysPath.dat && GREP -Fsq :\ %systemdrive%\qoobox\backenv\appdata.folder.dat && COPY /Y %systemdrive%\qoobox\backenv\


@IF NOT EXIST f_system ECHO.> f_system:test || DEL /A/F f_system
IF EXIST SysPath.dat Grep -c . SysPath.dat | GREP -sq .. && GOTO SetEnvmtB




SWREG SAVE "hklm\software\microsoft\windows\currentversion\explorer\shell folders" MachineShellFolders00
GREP -sq "^regf" machineshellfolders00 &&(
	@DumpHive -e MachineShellFolders00 MachineShellFolders01
	)|| REGT /A MachineShellFolders01 "hkey_local_machine\software\microsoft\windows\currentversion\explorer\shell folders"
@SED -r "/?/d; /=.*:\\/!d;s/\\\\/\\/g;s/\x22//g;:a;s/^(\S*) (.*)(=.*)$/\1\2\3/;ta ;s/.*/@SET \x22&\x22/" MachineShellFolders01 >>SysPath.dat
@DEL /A/Q  MachineShellFolders0?

SWREG SAVE "hku\.default\software\microsoft\windows\currentversion\explorer\shell folders" DefaultUserShellFolders04
GREP -sq "^regf" DefaultUserShellFolders04 &&(
	@DumpHive DefaultUserShellFolders04 DefaultUserShellFolders05
	)|| REGT /a DefaultUserShellFolders05 "hkey_users\.default\software\microsoft\windows\currentversion\explorer\shell folders"
@SED -r "/?/d; /=.*:\\/!d;s/\\\\/\\/g;s/\x22//g;:a;s/^(\S*) (.*)(=.*)$/\1\2\3/;ta ;s/.*/@SET \x22Default&\x22/" DefaultUserShellFolders05 >>SysPath.dat
@DEL /A/Q  DefaultUserShellFolders0?

SWREG SAVE "hklm\software\microsoft\windows\currentversion\internet settings\activex cache" ActiveX00
GREP -sq "^regf" ActiveX00 &&(
	@DumpHive ActiveX00 ActiveX01
	)|| REGT /a ActiveX01 "hkey_local_machine\software\microsoft\windows\currentversion\internet settings\activex cache"
@SED -r "/?/d; /=.*:\\/!d; s/\\\\/\\/g; s/\x22//g; s/.*=/=/; s/.*/@SET \x22ActiveX&\x22/" ActiveX01 >>SysPath.dat
@DEL /A/Q  ActiveX0?

SWREG SAVE "hklm\software\microsoft\SchedulingAgent" SchedulingAgent00
GREP -sq "^regf" SchedulingAgent00 &&(
	@DumpHive -e SchedulingAgent00 SchedulingAgent01
	@SED -r "/?/d; /Tasksfolder/I!d; s/\\\\/\\/g; s/\x22//g; s/folder.*=/=/I; s/expand://I;s/.*/@SET \x22&\x22/" SchedulingAgent01 >>SysPath.dat
	)|| SWREG QUERY "hklm\software\microsoft\SchedulingAgent" /v TasksFolder | SED -r "/.*	(.*)/!d; s//@SET \x22Tasks=\1\x22/" >>SysPath.dat
@DEL /A/Q  SchedulingAgent0?

SWREG QUERY "hklm\system\currentcontrolset\control\session manager\Environment" /v temp >MachineEnvironment00
@SED "/	/!d" MachineEnvironment00 | SED "s/.*	//; s/.*/@SET \x22SysTemp=&\x22/" >>SysPath.dat
DEL /A/F MachineEnvironment00




:SetEnvmtB
@ECHO.@SET "HOME=%~DP0">>SetPath.bat
@ECHO.@SET "KMD=%KMD%">>SetPath.bat
@ECHO.@SET "COMSPEC=%CD%\%KMD%">>SetPath.bat
@ECHO.@SET "PATH=%PATH%">>SetPath.bat
@ECHO.@SET "Qrntn=%SystemDrive%\Qoobox\Quarantine">>SetPath.bat


GREP -qx "@SET .userX=%username%." setpath.bat &&(
	ECHO.@SET "ChkSum=%ChkSum%">>SetPath.bat
	CALL Setpath.bat
	IF NOT EXIST ConEnv.sed (
		SET|SED -r "s/\\/&&/g; s/&/\\&/g; /^(ActiveX|ALLUSERSPROFILE|APPDATA|Cache|CDBurning|Common(AdministrativeTools|AppData|Desktop|Documents|Favorites|ProgramFiles|Programs|StartMenu|StartUp|Templates)|Cookies|Default(AppData|Cache|Cookies|Desktop|Favorites|Fonts|History|LocalAppData|LocalSettings|NetHood|Personal|PrintHood|Recent|SendTo|StartMenu|StartUp|Templates)|Desktop|Fonts|History|HOMEPATH|Local(AppData|Settings)|Personal|PrintHood|ProfilesDirectory|Program(Files|s)|Recent|SendTo|Start(Menu|up)|System(p|Root|)|Tasks|TEMP(_LFN|lates|)|TMP|USERPROFILE|windir)=(.*)/I!d; s__s/^%%\1%%/\9/I;_" 
		ECHO.s/^^^%%systemdrive%%/%systemdrive%/I;
		)>ConEnv.sed
	GOTO :EOF
	)


@ECHO.@IF EXIST CHCP.bat CALL CHCP.bat>>SetPath.bat
@ECHO.@SET "SysDir=%systemroot%\system32">>SetPath.bat
@IF EXIST W6432.dat (
	ECHO.@SET "System=%systemroot%\SysWow64">>SetPath.bat
	ECHO.@SET "SysNative=%SystemRoot%\SysNative">>SetPath.bat
	ECHO.@SET "ProgFiles=%ProgramFiles(x86)%">>SetPath.bat
	ECHO.@SET "CommonProgFiles=%CommonProgramFiles(x86)%">>SetPath.bat
		) ELSE (
	ECHO.@SET "System=%systemroot%\system32">>SetPath.bat
	ECHO.@SET "ProgFiles=%ProgramFiles%">>SetPath.bat
	ECHO.@SET "CommonProgFiles=%CommonProgramFiles%">>SetPath.bat
	)
@ECHO.@SET "ChkSum=%ChkSum%">>SetPath.bat


IF EXIST setpath_N.cmd (
	TYPE SetPath_N.cmd  >>SetPath.bat
) ELSE @(
	SetPath >SetPath00
	SED -r "s/ //g; s/\\\x22$/\x22/; s/^SET/@SET /I" SetPath00 >>SetPath.bat
	DEL /A/F SetPath00
	)


SWREG SAVE "hkcu\software\microsoft\windows\currentversion\explorer\shell folders" UserShellFolders00
GREP -sq "^regf" UserShellFolders00 &&(
	@DumpHive -e UserShellFolders00 UserShellFolders01
	)|| REGT /a UserShellFolders01 "hkey_current_user\software\microsoft\windows\currentversion\explorer\shell folders"
@SED -r "/?/d; /=.*:\\/!d; s/\\\\/\\/g; s/\x22//g;  :a; s/^(\S*) (.*)(=.*)$/\1\2\3/; ta; s/.*/@SET \x22&\x22/" UserShellFolders01 >>SetPath.bat
@DEL /A/Q  UserShellFolders0?


@PEV -exrtd "%temp%" -output:UserEnvironment01
@FINDSTR ? UserEnvironment01 ||FOR /F "TOKENS=*" %%G IN ( UserEnvironment01 ) DO @CALL SET "Temp_LFN=%%G"
@IF DEFINED Temp_LFN ECHO.@SET "Temp_LFN=%Temp_LFN%">>SetPath.bat
@DEL /A/F/Q UserEnvironment0?


ECHO.@SET "userX=%username%">>SetPath.bat
SED "s/\\\x22$/\x22/" SysPath.dat >> SetPath.bat

CALL SetPath.bat
SED "s/=\\=\\\\.*$/=\x22/g" SetPath.bat > SetPathB
MOVE /Y SetPathB SetPath.bat
CALL SetPath.bat


ECHO."%userprofile%" | GREP -q "\?" && FOR /F "TOKENS=*" %%G IN ("%Desktop%\..") DO @SET "userprofile=%%~SG"


SWREG QUERY "hklm\software\microsoft\windows nt\currentversion\profilelist" /v profilesdirectory >ProfilesDirectory00
SED "/.*	/!d;s///;s///;s/.*/@SET \x22ProfilesDirectory=&\x22/" ProfilesDirectory00 >ProfilesDirectory.bat
@ECHO.@ECHO.^>NULL >> ProfilesDirectory.bat
CALL ProfilesDirectory.bat
ECHO.@SET "ProfilesDirectory=%ProfilesDirectory%">>SetPath.bat
CALL SetPath.bat

IF EXIST Vista.krl (
	PEV -rtd -t!e -c:##f#b#8# "%ProfilesDirectory%\*" and not { "All Users" or "Default User" } -output:ProfilesFolder00
	) ELSE PEV -rtd -t!e -c:##f#b#8# "%ProfilesDirectory%\*" -output:ProfilesFolder00

SED "/?/s/\\[^\\]*	.*\\/\\/; s/	.*//" ProfilesFolder00 >Profiles.Folder.cfu
IF EXIST Vista.krl TYPE Profiles.Folder.cfu > Profiles.Folder.cfx
DEL /A/F/Q ProfilesFolder0? ProfilesDirectory*


IF EXIST Profiles.Folder.dat FINDSTR -LIVXG:Profiles.Folder.dat Profiles.Folder.cfu || GOTO SetEnvmtC


@IF EXIST "%system%\config\systemprofile\" ECHO.%system%\config\systemprofile>>Profiles.Folder.cfu



SWREG QUERY "hklm\software\microsoft\windows nt\currentversion\profilelist" /s >ProfileList00
SED "/ProfileImagePath	/I!d;s/.*	/@ECHO.\x22/;s/$/\x22/" ProfileList00 >ProfileList.bat
CALL ProfileList.bat >>Profiles.Folder.cfu
SED "/?/d;s/\x22//g;" Profiles.Folder.cfu >ProfilesFolder02
SED -n "/:\\/!d; G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/Id; s/\n//; h; P" ProfilesFolder02 >Profiles.Folder.dat
GREP -Evn "~[0-9]$|\\(Network|Local)Service$|\\All Users$" Profiles.Folder.dat >ProfilesHive00
IF EXIST Profiles_wo_ntuser.Folder.dat DEL /A/F Profiles_wo_ntuser.Folder.dat
FOR /F "TOKENS=1* DELIMS=:" %%G IN ( ProfilesHive00 ) DO @IF EXIST "%%~H\ntuser.dat" (
	PEV -tx50000 -tf -s+262143 "%%~H\ntuser.dat" &&	SWREG load "hku\@%%~G" "%%~H\ntuser.dat"
	) ELSE @ECHO."%%~H">>Profiles_wo_ntuser.Folder.dat

SWREG QUERY hku >ProfilesLoaded00
SED "/\\/I!d;/_Classes$/Id" ProfilesLoaded00 >ProfilesLoaded01
FOR /F "TOKENS=*" %%H IN ( ProfilesLoaded01 ) DO @SWREG export "%%H\software\microsoft\windows\currentversion\explorer\shell folders" "%%~NXH.re5"

GREP "~[0-9]$" Profiles.Folder.dat >ProfilesToLoad00
FOR /F "TOKENS=*" %%G IN ( ProfilesToLoad00 ) DO @PEV -tx50000 -tf -s+262143 -dg30 "%%~G\ntuser.dat" &&@(
	SWREG load "hku\@%%~NXG" "%%~G\ntuser.dat"
	SWREG export "hku\@%%~NXG\software\microsoft\windows\currentversion\explorer\shell folders" "%%~NXG.re5a"
	TYPE "%%~NXG.re5a" | SED -e "/=..:/!d;s/%ProfilesDirectory:\=\\\\%\\\\[^\\]*/%ProfilesDirectory:\=\\\\%\\\\%%~NXG/I" > "%%~NXG.re5"
	DEL /A/F "%%~NXG.re5a"
	)
	
SWREG QUERY hku >ProfilesToUnload00
GREP "@" ProfilesToUnload00 >ProfilesToUnload01
FOR /F "TOKENS=*" %%G IN ( ProfilesToUnload01 ) DO @SWREG UNLOAD "%%G"
DEL /A/F/Q ProfilesFolder0? ProfileList* ProfilesHive00 ProfilesLoaded0? ProfilesToLoad0? ProfilesToUnload0?


@ECHO./\x22appdata\x22=/Is///wAppData.cfu>Shell.sed
@ECHO./\x22templates\x22=/Is///wTemplates.cfu>>Shell.sed
@ECHO./\x22personal\x22=/Is///wPersonal.cfu>>Shell.sed
@ECHO./\x22local settings\x22=/Is///wLocalSettings.cfu>>Shell.sed
@ECHO./\x22local appdata\x22=/Is///wLocalAppData.cfu>>Shell.sed
@ECHO./\x22programs\x22=/Is///wPrograms.cfu>>Shell.sed
@ECHO./\x22start menu\x22=/Is///wStartMenu.cfu>>Shell.sed
@ECHO./\x22StartUp\x22=/Is///wStartUp.cfu>>Shell.sed
@ECHO./\x22cache\x22=/Is///wCache.cfu>>Shell.sed
@ECHO./\x22desktop\x22=/Is///wDesktop.cfu>>Shell.sed
@ECHO./\x22favorites\x22=/Is///wFavorites.cfu>>Shell.sed
@ECHO./\x22my pictures\x22=/Is///wPictures.cfu>>Shell.sed
@ECHO./\x22Cookies\x22=/Is///wCookies.cfu>>Shell.sed
@ECHO./\x22NetHood\x22=/Is///wNetHood.cfu>>Shell.sed
@ECHO./\x22PrintHood\x22=/Is///wPrintHood.cfu>>Shell.sed
@ECHO./\x22Recent\x22=/Is///wRecent.cfu>>Shell.sed
@ECHO./\x22SendTo\x22=/Is///wSendTo.cfu>>Shell.sed
@ECHO./\x22History\x22=/Is///wHistory.cfu>>Shell.sed
@ECHO./\x22My Music\x22=/Is///wMusic.cfu>>Shell.sed


FOR %%G IN ( *.re5 ) DO @%KMD% /U /C ECHO.>>"%%G"
TYPE *.re5 | SED -e "/\x22\x22/d;s/\\\\/\\/g" -n -f Shell.sed
FOR %%G IN (*.cfu) DO @(
	GREP -Fv "?" "%%G" | GREP -F :\ >VerifyPath00
	FOR /F "TOKENS=*" %%H IN ( VerifyPath00 ) DO @IF EXIST %%H ECHO.%%H>>"%%~NG.folder"
	DEL /A/F/Q VerifyPath00 "%%G"
	)


@IF DEFINED CommonAppData ECHO."%CommonAppData%">>Appdata.folder
@IF DEFINED CommonTemplates ECHO."%CommonTemplates%">>"Templates.folder"
@IF DEFINED CommonDocuments ECHO."%CommonDocuments%">>"Personal.folder"
@IF DEFINED CommonPrograms ECHO."%CommonPrograms%">>"Programs.folder"
@IF DEFINED CommonStartMenu ECHO."%CommonStartMenu%">>"StartMenu.folder"
@IF DEFINED CommonStartUp ECHO."%CommonStartUp%">>"StartUp.folder"
@IF DEFINED CommonDesktop ECHO."%CommonDesktop%">>"Desktop.folder"
@IF DEFINED CommonFavorites ECHO."%CommonFavorites%">>"Favorites.folder"
@IF DEFINED CommonPictures ECHO."%CommonPictures%">>"Pictures.folder"
@IF DEFINED CommonMusic ECHO."%CommonMusic%">>"Music.folder"
@IF DEFINED CommonHistory ECHO."%CommonHistory%">>"History.folder"
@IF DEFINED CommonNetHood ECHO."%CommonNetHood%">>"NetHood.folder"
@IF DEFINED CommonRecent ECHO."%CommonRecent%">>"Recent.folder"
@IF DEFINED CommonSendTo ECHO."%CommonSendTo%">>"SendTo.folder"
@IF DEFINED DefaultAppData ECHO."%DefaultAppData%">>Appdata.folder
@IF DEFINED DefaultTemplates ECHO."%DefaultTemplates%">>"Templates.folder"
@IF DEFINED DefaultPersonal ECHO."%DefaultPersonal%">>Personal.folder
@IF DEFINED DefaultLocalSettings ECHO."%DefaultLocalSettings%">>"LocalSettings.folder"
@IF DEFINED DefaultLocalAppData ECHO."%DefaultLocalAppData%">>"LocalAppData.folder"
@IF DEFINED DefaultPrograms ECHO."%DefaultPrograms%">>Programs.folder
@IF DEFINED DefaultStartMenu ECHO."%DefaultStartMenu%">>"StartMenu.folder"
@IF DEFINED DefaultStartUp ECHO."%DefaultStartUp%">>"StartUp.folder"
@IF DEFINED DefaultCache ECHO."%DefaultCache%">>"Cache.folder"
@IF DEFINED DefaultDesktop ECHO."%DefaultDesktop%">>"Desktop.folder"
@IF DEFINED DefaultFavorites ECHO."%DefaultFavorites%">>"Favorites.folder"
@IF DEFINED DefaultPictures ECHO."%DefaultPictures%">>"Pictures.folder"
@IF DEFINED DefaultHistory ECHO."%DefaultHistory%">>"History.folder"
@IF DEFINED DefaultNetHood ECHO."%DefaultNetHood%">>"NetHood.folder"
@IF DEFINED DefaultPrintHood ECHO."%DefaultPrintHood%">>"PrintHood.folder"
@IF DEFINED DefaultRecent ECHO."%DefaultRecent%">>"Recent.folder"
@IF DEFINED DefaultSendTo ECHO."%DefaultSendTo%">>"SendTo.folder"
@IF EXIST Vista.krl CALL :V-Env

@FOR /F "USEBACKQ TOKENS=*" %%G IN (`CALL ECHO."%%StartUp:%ProfilesDirectory%\%username%=%ProfilesDirectory%\Default User%%"`) DO @IF EXIST "%%~G\" ECHO.%%G>>"StartUp.folder"

SED -n "/:\\/!d; G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/Id; s/\n//; h; P" Profiles.Folder.dat >Profiles.Folder.tmp
MOVE /Y Profiles.Folder.tmp Profiles.Folder.dat

FOR %%G IN (*.folder) DO @SED -n "/:\\/!d; G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/Id; s/\n//; h; P" "%%~G" > "%%~G.dat"
IF EXIST Vista.krl COPY /Y "LocalAppData.folder.dat" "LocalSettings.folder.dat"

@FOR %%G IN (
	"%ProfilesDirectory%\LocalService\Local Settings\Temporary Internet Files"
	"%SystemRoot%\ServiceProfiles\LocalService\AppData\Local\Temporary Internet Files"
	) Do @IF EXIST "%%~G\Content.IE5\index.dat" (ECHO.%%G)>>Cache.folder.dat 
	
COPY /Y *.folder.dat %systemdrive%\Qoobox\BackEnv\


:SetEnvmtC
@ECHO."%AppData%"| FINDSTR ~ >>Appdata.folder.dat
@ECHO."%Templates%"| FINDSTR ~ >>"Templates.folder.dat"
@ECHO."%Personal%"| FINDSTR ~ >>Personal.folder.dat
@ECHO."%LocalSettings%"| FINDSTR ~ >>"LocalSettings.folder.dat"
@ECHO."%LocalAppData%"| FINDSTR ~ >>"LocalAppData.folder.dat"
@ECHO."%Programs%"| FINDSTR ~ >>Programs.folder.dat
@ECHO."%StartMenu%"| FINDSTR ~ >>"StartMenu.folder.dat"
@ECHO."%StartUp%"| FINDSTR ~ >>"StartUp.folder.dat"
@ECHO."%Cache%"| FINDSTR ~ >>"Cache.folder.dat"
@ECHO."%Desktop%"| FINDSTR ~ >>"Desktop.folder.dat"
@ECHO."%Favorites%"| FINDSTR ~ >>"Favorites.folder.dat"
@ECHO."%Cookies%"| FINDSTR ~ >>"Cookies.folder.dat"
@ECHO."%NetHood%"| FINDSTR ~ >>"NetHood.folder.dat"
@ECHO."%PrintHood%"| FINDSTR ~ >>"PrintHood.folder.dat"
@ECHO."%Recent%"| FINDSTR ~ >>"Recent.folder.dat"
@ECHO."%Templates%"| FINDSTR ~ >>"Templates.folder.dat"
@ECHO."%History%"| FINDSTR ~ >>"History.folder.dat"

@IF DEFINED LocalSettings ECHO."%LocalSettings%"|SED -r "/\\/!d; s/\x22//g; s/%UserProfile:\=\\%\\/%AllUsersProfile:\=\\%\\/I" > CommonTemp00
@IF EXIST CommonTemp00 (
	FOR /F "TOKENS=*" %%G IN ( CommonTemp00 ) DO @IF EXIST "%%~G\Temp\" ECHO.@SET "CommonTemp=%%~G\Temp">>Setpath.bat
	DEL /A/F CommonTemp00
	)
	
PEV -samdate -limit1 -tx50000 -tf "%AppData%\Mozilla\Firefox\Profiles\*" -preg"%AppData:\=\\%\\Mozilla\\Firefox\\Profiles\\[^\\]*\\prefs.js" -output:temp00
FOR /F "TOKENS=*" %%G IN ( temp00 ) DO @ECHO.@SET "FF_UserRoot=%%~DPG">>SetPath.bat
CALL Setpath.bat

COPY /Y SysPath.dat %systemdrive%\Qoobox\BackEnv\
COPY /Y SetPath.bat %systemdrive%\Qoobox\BackEnv\

IF NOT EXIST ConEnv.sed (
SET|SED -r "s/\\/&&/g; s/&/\\&/g; /^(ActiveX|ALLUSERSPROFILE|APPDATA|Cache|CDBurning|Common(AdministrativeTools|AppData|Desktop|Documents|Favorites|ProgramFiles|Programs|StartMenu|StartUp|Templates)|Cookies|Default(AppData|Cache|Cookies|Desktop|Favorites|Fonts|History|LocalAppData|LocalSettings|NetHood|Personal|PrintHood|Recent|SendTo|StartMenu|StartUp|Templates)|Desktop|Fonts|History|HOMEPATH|Local(AppData|Settings)|Personal|PrintHood|ProfilesDirectory|Program(Files|s)|Recent|SendTo|Start(Menu|up)|System(p|Root|)|Tasks|TEMP(_LFN|lates|)|TMP|USERPROFILE|windir)=(.*)/I!d; s__s/^%%\1%%/\9/I;_" 
ECHO.s/^^^%%systemdrive%%/%systemdrive%/I;
)>ConEnv.sed

@DEL /A/F/Q Shell.sed *.re5 *.folder Profiles.Folder.cfx
@GOTO :EOF




:FixStartUp
@SWREG QUERY "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /V StartUp | SED -r "/.*	%%USERPROFILE%%/!d; s//%%ALLUSERSPROFILE%%/;" | GREP -s . > FixStartUp00 &&@(
	FOR /F "TOKENS=*" %%G IN ( FixStartUp00 ) DO @SWREG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /V "COMMON StartUp" /T REG_EXPAND_SZ /D "%%~G"
	)||@(
	REM ECHO.[color=red]Manual Fix is required for restoring CommonStartUp[/color]>AbortFixCommonStartUp
	ECHO.
	ECHO.%Line85%
	)>AbortFixCommonStartUp

@DEL /A/F/Q FixStartUp00
@GOTO :EOF


:V-Env
@SED "/:\\/!d; s/.*/\x22&\\AppData\\Roaming\x22/" Profiles.Folder.cfx >>Appdata.folder
@SED "/:\\/!d; s/.*/\x22&\\AppData\\Local\\Microsoft\\Windows\\Temporary Internet Files\x22/" Profiles.Folder.cfx >>Cache.folder
@SED "/:\\/!d; s/.*/\x22&\\AppData\\Local\x22/" Profiles.Folder.cfx >>LocalAppData.folder
@SED "/:\\/!d; s/.*/\x22&\\Desktop\x22/" Profiles.Folder.cfx >>Desktop.folder
@SED "/:\\/!d; s/.*/\x22&\\Favorites\x22/" Profiles.Folder.cfx  >>Favorites.folder
@SED "/:\\/!d; s/.*/\x22&\\Pictures\x22/" Profiles.Folder.cfx >>Pictures.folder
@SED "/:\\/!d; s/.*/\x22&\\Documents\x22/" Profiles.Folder.cfx >>Personal.folder
@SED "/:\\/!d; s/.*/\x22&\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\Programs\x22/" Profiles.Folder.cfx >>Programs.folder
@SED "/:\\/!d; s/.*/\x22&\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\x22/" Profiles.Folder.cfx >>StartMenu.folder
@SED "/:\\/!d; s/.*/\x22&\\AppData\\Roaming\Microsoft\\Windows\\Start Menu\\Programs\\StartUp\x22/" Profiles.Folder.cfx >>StartUp.folder
@SED "/:\\/!d; s/.*/\x22&\\AppData\\Roaming\\Microsoft\\Windows\\Templates\x22/" Profiles.Folder.cfx >>Templates.folder
@GOTO :EOF



