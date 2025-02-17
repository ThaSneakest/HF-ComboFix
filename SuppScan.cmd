


SET "R_0=Default_Page_URL|Default_Search_URL|Local Page|Start Page|Search Page|Search Bar|SearchMigratedDefaultURL|Window Title"

SWREG QUERY "HKCU\Software\Microsoft\Internet Explorer\Main" >temp00
SED -r "/^ +(%R_0%)	.*	/I!d; s//u\1 = /; s/http:/hxxp:/I" temp00 >temp01

SWREG QUERY "HKLM\Software\Microsoft\Internet Explorer\Main" >temp00
SED -r "/^ +(%R_0%)	.*	/I!d; s//m\1 = /; s/http:/hxxp:/I" temp00 >>temp01
SET R_0=


SWREG QUERY "HKCU\Software\Microsoft\Internet Connection Wizard" /v ShellNext  >temp00
SED "/	.*	./!d; s/.*	/uInternet Connection Wizard,ShellNext = /; s/http:/hxxp:/I" temp00 >>temp01


SWREG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" >temp00
SED -r "/^ +(ProxyServer|ProxyOverride)	.*	([^:])/I!d; s//uInternet Settings,\1 = \2/; s/http:/hxxp:/I" temp00 >>temp01



SWREG QUERY "HKCU\Software\Microsoft\Internet Explorer\Search" >temp00
SED -r "/^ +(SearchAssistant|CustomizeSearch)	.*	/I!d; s//u\1 = /; s/http:/hxxp:/I" temp00 >>temp01


SWREG QUERY "HKCU\Software\Microsoft\Internet Explorer\SearchUrl" /ve >temp00
SED -r "/	.*	./!d; s/.*	/uSearchURL,(Default) = /; s/http:/hxxp:/I" temp00 >>temp01


SWREG QUERY "HKLM\SOFTWARE\Microsoft\Internet Explorer" /v SearchURL >temp00
SED -r "/	.*	./!d; s/.*	/mSearchURL = /; s/http:/hxxp:/I" temp00 >>temp01


SWREG QUERY "HKLM\Software\Microsoft\Internet Explorer\Search" >temp00
SED -r "/^ +(SearchAssistant|CustomizeSearch)	.*	/I!d; s//m\1 = /; s/http:/hxxp:/I" temp00 >>temp01


IF EXIST W6432.dat (
	FINDSTR -iv "://[^/]*\.microsoft\.com/ ://[^/]*\.msn\.com/ %%SystemRoot\%%\\SysWOW64\\blank\.htm %SystemRoot%\\SysWOW64\\blank\.htm" temp01 >ComboFix.tmp
	) ELSE FINDSTR -iv "://[^/]*\.microsoft\.com/ ://[^/]*\.msn\.com/ %%SystemRoot\%%\\system32\\blank\.htm %System:\=\\%\\blank\.htm" temp01 >ComboFix.tmp
DEL /A/F/Q temp0?


SWREG QUERY "HKCU\Software\Microsoft\Internet Explorer\MenuExt" /s >temp00
SED -r "/^H.*menuext\\|   <no name>	[^	]*/I!d; s///; s.res://..I" temp00 | SED ":a; $!N;s/\n	/ - /;ta;P;D" | SED "s/./IE: &/" >>ComboFix.tmp


SWREG QUERY "HKLM\software\microsoft\internet explorer\extensions" /s >temp00
SED -r "/^H.*\\\{|   (Exec|clsidextension|script|bandclsid)	[^	]*/I!d;s///; s/^\S/{&/; s/file:\/\///" temp00 >temp01
SED ":a; $!N;s/\n	/	/;ta;P;D;" temp01 >temp02
FINDSTR -IVG:clsid.dat temp02 >temp03
FINDSTR -C:"	{" temp03 >temp04
SED "/	{/d; s/	/ - /; s/./IE: {&/" temp03 >>ComboFix.tmp

FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp04 ) DO @(
	SWREG QUERY "HKCR\CLSID\%%~H\InprocServer32" /ve >temp05
	SED "/.*	/!d; s///" temp05 >temp06
	FINDSTR . temp06 >N_\%random% ||@ECHO.IE: {%%~G - %%~H -
	FOR /F "TOKENS=*" %%I in ( temp06 ) DO @ECHO.IE: {%%~G - %%~H - %%~I
	DEL /A/F temp05 temp06 >N_\%random%
	)>>ComboFix.tmp
DEL /A/F temp0?



@(
ECHO.^%SystemRoot^%\system32\rsvpsp.dll
ECHO.^%SystemRoot^%\system32\winrnr.dll
ECHO.^%SystemRoot^%\system32\mswsock.dll
)>MSDLL_.dat


@IF EXIST vista.krl (
ECHO.^%SystemRoot^%\system32\NLAapi.dll
ECHO.^%SystemRoot^%\system32\napinsp.dll
ECHO.^%SystemRoot^%\system32\pnrpnsp.dll
)>>MSDLL_.dat
IF EXIST NOWHTLIST ECHO.::::>MSDLL_.dat



SWREG EXPORT HKLM\system\currentcontrolset\services\winsock2\parameters\Protocol_Catalog9\Catalog_Entries LSP00 /NT4
SED ":a; $!N;s/\\\n  //;ta;P;D" LSP00 >LSP01
SED -r "/^\x22.*hex:/I!d; s///; s/00..*//" LSP01 >LSP02
SED -r -n "G; s/\n/&&/; /^([ -~]*\n).*\n\1/d; s/\n//; h; P" LSP02 >LSP03
SED "s/20,/ /Ig;s/21,/!/Ig;s/22,/\x22/Ig;s/23,/#/Ig;s/24,/$/Ig;s/25,/%%/Ig;s/26,/\&/Ig;s/27,/'/Ig;s/28,/(/Ig;s/29,/)/Ig;s/2A,/*/Ig;s/2B,/+/Ig;s/2C,//Ig;s/2D,/-/Ig;s/2E,/./Ig;s/2F,/\//Ig;s/30,/0/Ig;s/31,/1/Ig;s/32,/2/Ig;s/33,/3/Ig;s/34,/4/Ig;s/35,/5/Ig;s/36,/6/Ig;s/37,/7/Ig;s/38,/8/Ig;s/39,/9/Ig;s/3A,/:/Ig;s/3B,/;/Ig;s/3C,/</Ig;s/3D,/=/Ig;s/3E,/>/Ig;s/3F,/?/Ig;s/40,/@/Ig;s/41,/A/Ig;s/42,/B/Ig;s/43,/C/Ig;s/44,/D/Ig;s/45,/E/Ig;s/46,/F/Ig;s/47,/G/Ig;s/48,/H/Ig;s/49,/I/Ig;s/4A,/J/Ig;s/4B,/K/Ig;s/4C,/L/Ig;s/4D,/M/Ig;s/4E,/N/Ig;s/4F,/O/Ig;s/50,/P/Ig;s/51,/Q/Ig;s/52,/R/Ig;s/53,/S/Ig;s/54,/T/Ig;s/55,/U/Ig;s/56,/V/Ig;s/57,/W/Ig;s/58,/X/Ig;s/59,/Y/Ig;s/5A,/Z/Ig;s/5B,/[/Ig;s/5C,/\\/Ig;s/5D,/]/Ig;s/5E,/^/Ig;s/5F,/_/Ig;s/60,/`/Ig;s/61,/a/Ig;s/62,/b/Ig;s/63,/c/Ig;s/64,/d/Ig;s/65,/e/Ig;s/66,/f/Ig;s/67,/g/Ig;s/68,/h/Ig;s/69,/i/Ig;s/6A,/j/Ig;s/6B,/k/Ig;s/6C,/l/Ig;s/6D,/m/Ig;s/6E,/n/Ig;s/6F,/o/Ig;s/70,/p/Ig;s/71,/q/Ig;s/72,/r/Ig;s/73,/s/Ig;s/74,/t/Ig;s/75,/u/Ig;s/76,/v/Ig;s/77,/w/Ig;s/78,/x/Ig;s/79,/y/Ig;s/7A,/z/Ig;s/7B,/{/Ig;s/7C,/|/Ig;s/7D,/}/Ig;s/7E,/~/Ig;s/./LSP: &/" LSP03 >LSP04
FINDSTR -VILG:MSDLL_.dat LSP04 >>ComboFix.tmp
DEL /A/F/Q LSP0? MSDLL_.dat


SWREG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains" /s >ZoneMapDomains00
SWREG QUERY "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains" /s >>ZoneMapDomains00
SED "/./{H;$!d;};x;/.*	.*	2 /!d;" ZoneMapDomains00 >ZoneMapDomains01
SED -r "/^H.*Domains\\/I!d; s//Trusted Zone: /" ZoneMapDomains01 >>ComboFix.tmp
DEL /A/F ZoneMapDomains0?



SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /s >temp00
SED -r "/^(HKEY_| +DhcpNameServe| +NameServer)/I!d;" temp00 > temp01
ECHO.>> temp01
SED -n -r  "$!N; s/HKEY_.*\\Tcpip\\Parameters(\\|)(.*)\n  +(DhcpNameServer|NameServer)	.*	([0-9])/TCP: \2: \3 = \4/Ip; D; " temp01 >temp02
SED -r "s/^(TCP:) :/\1/" temp02 >>ComboFix.tmp

:: SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v NameServer >temp00
:: SED "/	.*	./I!d; s/.*	/TCP: NameServer = /I" temp01 >>ComboFix.tmp

:: SWREG QUERY "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /s >temp00
:: SED -r "/^H|^ +NameServer	.*	./I!d;" temp00 >temp01
:: SED -r "s/^H.*\\/TCP: /I" temp01 >temp02
:: SED ":a; $!N;s/\n .*	/ = /;ta;P;D" temp02 >temp03
:: FINDSTR = temp03 >>ComboFix.tmp
DEL /A/F/Q temp0?


SWREG QUERY "HKCR\Protocols" /s >temp00
SED -r "/^H|   clsid	/I!d" temp00 >temp01
SED ":a; $!N;s/\n.*	/	/;ta;P;D" temp01 >temp02
SED -r "/}/!d; s/[^	]*protocols\\//I;s/\\/: /; s/]	/	/;s/\x22//g;" temp02 >temp03
FINDSTR -IVG:clsid.dat temp03 >temp04
GREP -Ev "Handler: (bw[-+0-9a-z](0|0s)|(offline|bwile)-8876480)	" temp04 >temp05


FOR /F "TOKENS=1* DELIMS=	" %%G IN ( temp05 ) DO @(
	SWREG QUERY "HKCR\CLSID\%%~H\InprocServer32" /ve >temp06
	SED "/.*	/!d;s///" temp06 >temp07
	FOR /F "TOKENS=*" %%I in ( temp07 ) DO @ECHO.%%~G - %%~H - %%~$path:I
	DEL /A/F temp06 temp07 >N_\%random%
	)>>ComboFix.tmp
DEL /A/F/Q temp0?


SWREG QUERY "HKLM\SOFTWARE\Microsoft\Code Store Database\Distribution Units" /s >temp00
SED -r "/^H.*\\distribution units\\([^\\]*)$|^   CodeBase	.*(	)/I!d; s//\1\2/; s/^	htt/	hxx/I; s/^[^	]/DPF: &/" temp00 >temp01
SED ":a; $!N;s/\n	/ - /;ta;P;D;" temp01 >temp02
FINDSTR -LVIG:clsid.dat temp02 | FINDSTR -IVRG:DPF.str >>ComboFix.tmp
DEL /A/F/Q temp0?


SWREG QUERY "HKCR\CLSID\{603D3801-BD81-11d0-A3A5-00C04FD706EC}\InProcServer32" /ve >temp00 &&(
	GREP -Eisq "\\System32\\(browseui|shell32)\.dll" temp00 ||(
		SED -n -r ";/^HKEY_.*$/N; s/HKEY_.*\\(\{.*\})\\InProcServer32\n.*\t/CLSID: \1 - /Ip" temp00 >>ComboFix.tmp
		))
DEL /A/F/Q temp0?



SWREG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe" /V PATH | SED "/.*	/!d; s///; s/\\$//" >FFRootB
FOR /F "TOKENS=*" %%G IN ( FFRootB ) DO @SET "FF_Root=%%G\"
IF NOT EXIST "%FF_Root%Firefox.exe" GOTO SKIPFF

NIRCMD KILLPROCESS FIREFOX.exe
IF EXIST FPlugins* DEL /A/F/Q FPlugins*

For %%G in (
"%FF_Root%components\browserdirprovider.dll"
"%FF_Root%components\brwsrcmp.dll"
"%FF_Root%components\jar50.dll"
"%FF_Root%components\jsd3250.dll"
"%FF_Root%components\myspell.dll"
"%FF_Root%components\NsThunderLoader.dll"
"%FF_Root%components\spellchk.dll"
"%FF_Root%components\ThunderComponent.dll"
"%FF_Root%components\WRSForFireFox.dll"
"%FF_Root%components\xpinstal.dll""%FF_Root%plugins\np-mswmp.dll"
"%FF_Root%plugins\np_gp.dll"
"%FF_Root%plugins\np_prizm32.dll"
"%FF_Root%plugins\np_prizmprint.dll"
"%FF_Root%plugins\np32dsw.dll"
"%FF_Root%plugins\npalambik.dll"
"%FF_Root%plugins\npaxelplayer.dll"
"%FF_Root%plugins\npbitcometagent.dll"
"%FF_Root%plugins\npcpc32.dll"
"%FF_Root%plugins\npdapctrlfirefox.dll"
"%FF_Root%plugins\npdeploytk.dll"
"%FF_Root%plugins\npdevalvr.dll"
"%FF_Root%plugins\npdivx32.dll"
"%FF_Root%plugins\npdivxplayerplugin.dll"
"%FF_Root%plugins\npdnu.dll"
"%FF_Root%plugins\npexview.dll"
"%FF_Root%plugins\npffpreviewer.dll"
"%FF_Root%plugins\npflux.dll"
"%FF_Root%plugins\nphypercosm.dll"
"%FF_Root%plugins\npjp2.dll"
"%FF_Root%plugins\nplegitcheckplugin.dll"
"%FF_Root%plugins\npmapv32.dll"
"%FF_Root%plugins\npmngplg.dll"
"%FF_Root%plugins\npnanoinstaller.dll"
"%FF_Root%plugins\npnanoscanner.dll"
"%FF_Root%plugins\npnul32.dll"
"%FF_Root%plugins\npnwcw32.dll"
"%FF_Root%plugins\npoff12.dll"
"%FF_Root%plugins\npoffice.dll"
"%FF_Root%plugins\nppdf32.dll"
"%FF_Root%plugins\nppl3260.dll"
"%FF_Root%plugins\npqtplugin.dll"
"%FF_Root%plugins\npqtplugin2.dll"
"%FF_Root%plugins\npqtplugin3.dll"
"%FF_Root%plugins\npqtplugin4.dll"
"%FF_Root%plugins\npqtplugin5.dll"
"%FF_Root%plugins\npqtplugin6.dll"
"%FF_Root%plugins\npqtplugin7.dll"
"%FF_Root%plugins\nprescue.dll"
"%FF_Root%plugins\nprjplug.dll"
"%FF_Root%plugins\nprpjplug.dll"
"%FF_Root%plugins\npsibelius.dll"
"%FF_Root%plugins\npswf32.dll"
"%FF_Root%plugins\npupd62.dll"
"%FF_Root%plugins\npxarac.dll"
"%FF_Root%plugins\npym32.dll"
"%FF_Root%plugins\npzzatif.dll"
"%ProgFiles%\curl corporation\surge\plugins\np-curl-surge-6-0.dll"
"%ProgFiles%\curl corporation\surge\plugins\np-curl-surge.dll"
"%ProgFiles%\divx\divx content uploader\npUpload.dll"
"%ProgFiles%\divx\divx player\npdivxplayerplugin.dll"
"%ProgFiles%\divx\divx web player\npdivx32.dll"
"%ProgFiles%\dna\plugins\npbtdna.dll"
"%ProgFiles%\garmin gps plugin\npgarmin.dll"
"%ProgFiles%\hypercosm\hypercosm player\components\nphypercosm.dll"
"%ProgFiles%\itunes\mozilla plugins\npitunes.dll"
"%ProgFiles%\Java\jre6\bin\new_plugin\npdeploytk.dll"
"%ProgFiles%\Java\jre6\bin\new_plugin\npjp2.dll"
"%ProgFiles%\microsoft silverlight\npctrl.dll"
"%ProgFiles%\netscape6\nppl3260.dll"
"%ProgFiles%\netscape6\nprjplug.dll"
"%ProgFiles%\netscape6\nprpjplug.dll"
"%ProgFiles%\opera\program\plugins\npdsplay.dll"
"%ProgFiles%\opera\program\plugins\NPOFF12.DLL"
"%ProgFiles%\opera\program\plugins\npoffice.dll"
"%ProgFiles%\opera\program\plugins\npqtplugin.dll"
"%ProgFiles%\opera\program\plugins\npqtplugin2.dll"
"%ProgFiles%\opera\program\plugins\npqtplugin3.dll"
"%ProgFiles%\opera\program\plugins\npqtplugin4.dll"
"%ProgFiles%\opera\program\plugins\npqtplugin5.dll"
"%ProgFiles%\opera\program\plugins\npqtplugin6.dll"
"%ProgFiles%\opera\program\plugins\npqtplugin7.dll"
"%ProgFiles%\opera\program\plugins\npswf32.dll"
"%ProgFiles%\opera\program\plugins\npwmsdrm.dll"
"%ProgFiles%\panda security\activescan 2.0\npwrapper.dll"
"%ProgFiles%\quicktime\plugins\npqtplugin.dll"
"%ProgFiles%\quicktime\plugins\npqtplugin2.dll"
"%ProgFiles%\quicktime\plugins\npqtplugin3.dll"
"%ProgFiles%\quicktime\plugins\npqtplugin4.dll"
"%ProgFiles%\quicktime\plugins\npqtplugin5.dll"
"%ProgFiles%\quicktime\plugins\npqtplugin6.dll"
"%ProgFiles%\quicktime\plugins\npqtplugin7.dll"
"%ProgFiles%\real alternative\browser\plugins\nppl3260.dll"
"%ProgFiles%\real alternative\browser\plugins\nprpjplug.dll"
"%ProgFiles%\real\realplayer\netscape6\nppl3260.dll"
"%ProgFiles%\real\realplayer\netscape6\nprjplug.dll"
"%ProgFiles%\real\realplayer\netscape6\nprpjplug.dll"
"%ProgFiles%\real\rhapsodyplayerengine\nprhapengine.dll"
"%ProgFiles%\ringz studio\storm codec\plugins\nppl3260.dll"
"%ProgFiles%\ringz studio\storm codec\plugins\npqtplugin.dll"
"%ProgFiles%\ringz studio\storm codec\plugins\npqtplugin2.dll"
"%ProgFiles%\ringz studio\storm codec\plugins\npqtplugin3.dll"
"%ProgFiles%\ringz studio\storm codec\plugins\npqtplugin4.dll"
"%ProgFiles%\ringz studio\storm codec\plugins\npqtplugin5.dll"
"%ProgFiles%\ringz studio\storm codec\plugins\npqtplugin6.dll"
"%ProgFiles%\ringz studio\storm codec\plugins\npqtplugin7.dll"
"%ProgFiles%\ringz studio\storm codec\plugins\nprpjplug.dll"
"%ProgFiles%\Siber Systems\AI RoboForm\Firefox\components\rfproxy_27.dll"
"%ProgFiles%\videolan\vlc\npvlc.dll"
"%ProgFiles%\windows media player\npdrmv2.dll"
"%ProgFiles%\windows media player\npdsplay.dll"
"%ProgFiles%\windows media player\npwmsdrm.dll"
"%SystemRoot%\system32\adobe\director\np32dsw.dll"
"%SystemRoot%\system32\macromed\flash\npswf32.dll"
"%SystemRoot:~1%\Microsoft.NET\Framework\v3.5\Windows Presentation Foundation\NPWPF.dll"
"\extensions\{1650a312-02bc-40ee-977e-83f158701739}\components\FFHook.dll"
"\extensions\{77b819fa-95ad-4f2c-ac7c-486b356188a9}\plugins\npietab.dll"
"\extensions\\{b13721c7-f507-4982-b2e5-502a71474fed}\components\NPComponent.dll"
"\extensions\{b13721c7-f507-4982-b2e5-502a71474fed}\components\PNRComponent.dll"
"\extensions\{FFA36170-80B1-4535-B0E3-A4569E497DD0}\platform\WINNT_x86-msvc\components\mgMouseService.dll"
"\extensions\moveplayer@movenetworks.com\platform\winnt_x86-msvc\plugins\npmnqmp07103010.dll"
"\extensions\{3112ca9c-de6d-4884-a869-9855de68056c}\components\googletoolbarloader.dll"
"\extensions\{3112ca9c-de6d-4884-a869-9855de68056c}\components\metricsloader.dll"
"extensions\{CF40ACC5-E1BB-4aff-AC72-04C2F616BCA7}\plugins\np_gp.dll"
"%ProgFiles%\yahoo!\common\npyaxmpb.dll"
"%ProgFiles%\mozilla firefox\plugins\npcpbrk7.dll"
"%ProgFiles%\mozilla firefox\plugins\NPCpnMgr.dll"
"%ProgFiles%\mozilla firefox\plugins\npsnapfish.dll"
"%ProgFiles%\yahoo!\shared\npYState.dll"
) DO @ECHO.%%~G>>FPlugins


@echo:%ProgFiles:\=\\%\\java\\jre1.6.0_[0-1][0-9]\\bin\\npjava1[1-4].dll>FPluginsB
@echo:%ProgFiles:\=\\%\\java\\jre1.6.0_[0-1][0-9]\\bin\\npjava32.dll>>FPluginsB
@echo:%ProgFiles:\=\\%\\java\\jre1.6.0_[0-1][0-9]\\bin\\npjpi160_[0-1][0-9].dll>>FPluginsB
@echo:%ProgFiles:\=\\%\\java\\jre1.6.0_[0-1][0-9]\\bin\\npoji610.dll>>FPluginsB
@echo:%ProgFiles:\=\\%\\adobe\\reader [^^\\]*\\reader\\browser\\nppdf32.dll>>FPluginsB
@echo:%ProgFiles:\=\\%\\microsoft silverlight\\npctrl.1.0.3[0-9.]*.dll>>FPluginsB
@echo:%ProgFiles:\=\\%\\microsoft silverlight\\[^^\\]*\\npctrl.1.0.3[0-9.]*.dll>>FPluginsB
@echo:%ProgFiles:\=\\%\\microsoft silverlight\\[^^\\]*\\npctrl.dll>>FPluginsB
@echo:\\Google\\Update\\[^^\\]*\\npGoogleOneClick6.dll>>FPluginsB
@echo:%ProgFiles:\=\\%\\google\\google updater\\[^^\\]*\\npCIDetect11.dll>>FPluginsB
@echo:%ProgFiles:\=\\%\\adobe\\acrobat [^^\\]*\\reader\\browser\\nppdf32.dll>>FPluginsB
@echo:%ProgFiles:\=\\%\\adobe\\acrobat [^^\\]*\\acrobat\\browser\\nppdf32.dll>>FPluginsB

PEV -samdate -limit1 -tx50000 -tf "%AppData%\Mozilla\Firefox\Profiles\*" -preg"%AppData:\=\\%\\Mozilla\\Firefox\\Profiles\\[^\\]*\\prefs.js" -output:temp00
FOR /F "TOKENS=*" %%G IN ( temp00 ) DO @(
	SET "FF_UserRoot=%%~DPG"
	ECHO.s/^(user_pref\^(\x22pref.browser.homepage.disable_button.restore_default\x22, ^)true.*/\1false\^);/I>FF.sed
	ECHO./user_pref\^(\x22google.toolbar.linkdoctor.enabled\x22, false/Id;>>FF.sed
	GREP -Fsq "user_pref(\"network.proxy.http_port\", 7171);" "%%~G" &&ECHO./user_pref\^(\x22network.proxy.type\x22,/Id;>>FF.sed
	GREP -Fisq "user_pref(\"browser.search.selectedEngine\", \"search\");" "%%~G" &&ECHO./user_pref\^(\x22browser.search.selectedEngine\x22,/Id;>>FF.sed
	ECHO././!d>>FF.sed
	ATTRIB -H -R -S "%%~G"
	IF EXIST "%%~G.BAK" DEL /A/F "%%~G.BAK"
	COPY /Y "%%~G" "%%~G.BAK"
	ECHO.>>"%%~G.BAK"
	SED -r -f FF.sed "%%~G.BAK" > "%%~G"
	IF EXIST "%%~DPGuser.js" (
		ATTRIB -H -R -S "%%~DPGuser.js"
		IF EXIST "%%~DPGuser.js.BAK" DEL /A/F "%%~DPGuser.js.BAK"
		COPY /Y "%%~DPGuser.js" "%%~DPGuser.js.BAK"
		ECHO.>>"%%~DPGuser.js.BAK"
		SED -r -f FF.sed "%%~DPGuser.js.BAK" > "%%~DPGuser.js"
		)		
	DEL /A/F FF.sed
	)

DEL /A/F/Q temp0?


SET "FF_A=browser.search.defaulturl|browser.startup.homepage|browser.search.selectedEngine|keyword.URL|keyword.enabled"
SET "FF_B=network.proxy.type|network.proxy.ftp|network.proxy.http|network.proxy.socks|network.proxy.ssl|network.proxy.gopher"


ECHO.FF - ProfilePath - "%FF_UserRoot%"| SED "s/\x22//g" >>ComboFix.tmp

SED -r "/user_pref\(\x22(%FF_A%)\x22, (.*)\);/I!d; s//FF - prefs.js: \1 - \2/; s.htt(p|ps)://.hxx\1://.I; s/\x22//g" "%FF_UserRoot%prefs.js" >>ComboFix.tmp

GREP -Fisq network.proxy.type "%FF_UserRoot%prefs.js" &&SED -r "/.*(\x22(%FF_B%)(\x22|_port\x22))/I!d; s//FF - prefs.js: \1/; s/\x22, / - /; s/\);//I; s/\x22//g" "%FF_UserRoot%prefs.js" >>ComboFix.tmp

SED "/:\\/!d; s/|.*//;" "%FF_UserRoot%pluginreg.dat" >temp00
FOR /F "TOKENS=*" %%G IN ( temp00 ) DO @IF EXIST "%%~G" (
	ECHO.FF - plugin: %%G>>temp01
	) ELSE ECHO.%%G>>temp02
IF EXIST temp02 MOVE /Y "%FF_UserRoot%pluginreg.dat" "%FF_UserRoot%pluginreg.dat.bak" >N_\%random% 2>&1

SED -r "/((^rel|abs:).*\.dll),[0-9]{13}$/I!d; s//\1/; s/.*abs://; s/rel:/%FF_Root:\=\\%components\\/I;" "%FF_UserRoot%compreg.dat" >temp02
FOR /F "TOKENS=*" %%G IN ( temp02 ) DO @IF EXIST "%%~G" (
	ECHO.FF - component: %%G>>temp01
	) ELSE ECHO.%%G>>temp03
IF EXIST temp03 MOVE /Y "%FF_UserRoot%compreg.dat" "%FF_UserRoot%compreg.dat.bak" >N_\%random% 2>&1

GREP -Fivf FPlugins temp01 | GREP -ivf FPluginsB >temp02
SORT /M 65536 temp02
DEL /A/F/Q temp0?


IF EXIST "%FF_UserRoot%extensions.sqlite" (
		IF EXIST result.txt DEL /A/F result.txt
		COPY /Y "%FF_UserRoot%extensions.sqlite"
		sqlite3.3xe extensions.sqlite < FFext.pif
		SED -R "/^(\d\d\d\d-[^;]*):..; /!d; s//FF - ExtSQL: \1; /" result.txt >>ComboFix.tmp
		SED -R "/^0; (\d\d\d\d-[^;]*):..; /!d; s//FF - ExtSQL: !HIDDEN! \1; /" result.txt >>ComboFix.tmp
		DEL /A/F result.txt extensions.sqlite
) ELSE IF EXIST "%FF_UserRoot%extensions.cache" (
	SED -r "/user_pref\(.extensions.enabledItems., +/I!d; s///; s/\x22//g; s/:[^:]*$//; s/:[^:]*,/\n/g" "%FF_UserRoot%prefs.js" >enabledExtensions
	ECHO.::::::>>enabledExtensions
	GREP -Fif enabledExtensions "%FF_UserRoot%extensions.cache" | SED -r "s/^app-global	(.*	)rel%%/\1%FF_Root:\=\\%extensions\\/I; s/^app-profile	(.*	)rel%%/\1.\\extensions\\/I; s/^winreg.*	(.*	)abs%%(.:\\)/\1\2/I; s/	[^\\]*$//" >temp09
	DEL /A/F enabledExtensions
	PUSHD "%FF_UserRoot%"
	FOR /F "USEBACKQ TOKENS=1* DELIMS=	" %%H IN ( "%~DP0temp09" ) DO @IF EXIST "%%~I\install.rdf"  (
		SED -r "/em:(requires|localized)/I,/\/em:(requires|localized)>/Id; /em:name/I!d; s/\s+//; s/<\/.*//; s/.*em:name(>|=\x22)//; s/\x22//g;"  "%%~I\install.rdf" >"%~DP0temp0As"
		FOR /F "USEBACKQ TOKENS=*" %%K IN ( "%~DP0temp0As" ) DO @ECHO.FF - Ext: %%K: %%H - %%I>>"%~DP0DDS0K"
		DEL /A/F "%~DP0temp0As"
		)
	POPD
	IF EXIST DDS0K (
		SED -r "/.:\\/!{s/ - .\\extensions\\/ - %%profile%%\\extensions\\/;}" DDS0K >>ComboFix.tmp
		DEL /A/F DDS0K
		))
		
IF EXIST "%FF_UserRoot%user.js" SED -r "s/user_pref\(\x22([^\x22]*)\x22, (.*)\);/FF - user.js: \1 - \2/I; s.htt(p|ps)://.hxx\1://.I; s/\x22//g" "%FF_UserRoot%user.js" >FFPolicyB

IF EXIST FFPolicyB GREP -sq . FFPolicyB &&(
	ECHO.
	ECHO.---- %FIREFOX POLICIES% ----
	TYPE FFpolicyB >>ComboFix.tmp
	)


SET FF_A=
SET FF_B=
SET FF_Root=
DEL /A/F/Q temp0? FPlugins



:SKIPFF
DEL /A/F FFRoot? /Q
GREP -isq "[a-z0-9]" ComboFix.tmp &&@(
	ECHO.
	ECHO.------- %Supplementary Scan% -------
	ECHO.
	TYPE ComboFix.tmp
	ECHO.
	)>>ComboFix.txt

IF EXIST assocs PEV WAIT 2000
IF EXIST AssocsB.txt (
	ECHO.
	ECHO.------- %File Associations% -------
	ECHO.
	TYPE AssocsB.txt
	ECHO.
	)>>ComboFix.txt



SWREG QUERY "HKLM\SOFTWARE\Microsoft\Code Store Database\Distribution Units" >temp00
SED "1,6d; /.*\\/!d;s//	\x22/" temp00 >temp01
ECHO.::::>>temp01
SWREG EXPORT "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ModuleUsage" temp02 /NT4
SED ":a; $!N;s/\n\x22/	\x22/;ta;P;D" temp02 >temp03
GREP -Fivf temp01 temp03 >temp04
GREP "	.*" temp04 >temp05
SED "s///; s/\[/&-/" temp05 >>temp02
REGT /S temp02
DEL /A/F/Q temp0? N_\*



SWREG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s >temp00
SWREG QUERY "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s >>temp00
SED -r "/^   UninstallString	|^HKEY_.*\\Uninstall\\/I!d; s/.*	//; /msiexec(.exe|) \/|\\spuninst\\spuninst.exe|^$/Id; s/^%SystemRoot:\=\\%\\(is|)uninst.exe -f//I; s/%system:\=\\%\\mshta.exe .*(.:\\)/\1/I; s/\s*$//" temp00 | SED -r -f run.sed | SED -r ":a; $!N;s/\n(.:\\)/	\1/;ta;P;D" >temp01
GREP "	"  temp01 >temp02
FOR /F "TOKENS=1,2 DELIMS=	" %%G IN ( temp02 ) DO @IF NOT EXIST "%%~H" IF NOT EXIST "%SystemDrive%\Qoobox\Quarantine\Registry_backups\AddRemove-%%~NXG.reg.dat" (
REGT /E /S "%SystemDrive%\Qoobox\Quarantine\Registry_backups\AddRemove-%%~NXG.reg.dat" "%%G"
ECHO.[-%%G]>>CregC.dat
ECHO.AddRemove-%%~NXG - %%~H>>Orphans.dat
)
SED -r "/\\us\?rinit.exe/I!d; s/(.*)\t.*/[-\1]/" temp02>>CregC.dat
SED -r "/^ +DisplayName	.*	/I!d; s///" temp00 | SORT /M 65536 | SED "$!N; /^\(.*\)\n\1$/I!P; D" >"\QooBox\Add-Remove Programs.txt"
DEL /A/F/Q temp0?
ECHO.>SuppScan_Completed

