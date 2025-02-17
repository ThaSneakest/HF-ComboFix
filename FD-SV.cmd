

@IF EXIST W6432.dat (
	SET "Systemx86=%SystemRoot%\SysWow64"
	SET "FD_Cache=%Systemroot%\erdnt\cache86"
	SET "FD_Cachex64=%Systemroot%\erdnt\cache64"
) ELSE (
	SET "Systemx86=%SystemRoot%\System32"
	SET "FD_Cache=%Systemroot%\erdnt\cache"
	)


START NIRKMD CMDWAIT 15000 EXEC HIDE PEV.exe -k SWSC.%cfExt%
@SWSC QUERY CRYPTSVC || SWSC START CRYPTSVC

@(

IF EXIST W6432.dat (
	ECHO.%SysNative%\drivers\atapi.sys
	ECHO.%SysNative%\drivers\asyncmac.sys
	ECHO.%SysNative%\drivers\kbdclass.sys
	ECHO.%SysNative%\drivers\ndis.sys
	ECHO.%SysNative%\drivers\ntfs.sys
	ECHO.%SysNative%\drivers\null.sys
	ECHO.%SysNative%\drivers\tcpip.sys
	ECHO.%SysNative%\drivers\tdx.sys
	ECHO.%SysNative%\browser.dll
	ECHO.%SysNative%\lsass.exe
	ECHO.%SysNative%\netman.dll
	ECHO.%SysNative%\qmgr.dll
	ECHO.%SysNative%\rpcss.dll
	ECHO.%SysNative%\services.exe
	ECHO.%SysNative%\spoolsv.exe
	ECHO.%SysNative%\winlogon.exe
	ECHO.%SysNative%\wuauclt.exe
	ECHO.%SysNative%\comctl32.dll
	ECHO.%SysNative%\comres.dll
	ECHO.%SysNative%\cryptsvc.dll
	ECHO.%SysNative%\es.dll
	ECHO.%SysNative%\imm32.dll
	ECHO.%SysNative%\usp10.dll
	ECHO.%SysNative%\kernel32.dll
	ECHO.%SysNative%\linkinfo.dll
	ECHO.%SysNative%\lpk.dll
	ECHO.%SysNative%\hnetcfg.dll
	ECHO.%SysNative%\mshtml.dll
	ECHO.%SysNative%\msvcrt.dll
	ECHO.%SysNative%\mswsock.dll
	ECHO.%SysNative%\netlogon.dll
	ECHO.%SysNative%\powrprof.dll
	ECHO.%SysNative%\scecli.dll
	ECHO.%SysNative%\sfc.dll
	ECHO.%SysNative%\svchost.exe
	ECHO.%SysNative%\tapisrv.dll
	ECHO.%SysNative%\user32.dll
	ECHO.%SysNative%\userinit.exe
	ECHO.%SysNative%\wininet.dll
	ECHO.%SysNative%\ws2_32.dll
	ECHO.%SysNative%\ws2help.dll
	ECHO.%SysNative%\ole32.dll
	ECHO.%SysNative%\cngaudit.dll
	ECHO.%SysNative%\wininit.exe
	ECHO.%SysNative%\ctfmon.exe
	ECHO.%SysNative%\shsvcs.dll
	ECHO.%SysNative%\regsvc.dll
	ECHO.%SysNative%\schedsvc.dll
	ECHO.%SysNative%\ssdpsrv.dll
	ECHO.%SysNative%\termsrv.dll
	ECHO.%SysNative%\ntoskrnl.exe
	ECHO.%SysNative%\ksuser.dll
	ECHO.%SysNative%\msimg32.dll
	FOR %%G IN (
		"%SysNative%\6to4.dll"
		"%SysNative%\appmgmts.dll"
		"%SysNative%\drivers\acpiec.sys"
		"%SysNative%\drivers\aec.sys"
		"%SysNative%\drivers\agp440.sys"
		"%SysNative%\drivers\ip6fw.sys"
		"%SysNative%\ias.dll"
		"%SysNative%\iprip.dll"
		"%SysNative%\mfc40u.dll"
		"%SysNative%\msgsvc.dll"
		"%SysNative%\mspmsnsv.dll"
		"%SysNative%\ntkrnlpa.exe"
		"%SysNative%\ntmssvc.dll"
		"%SysNative%\upnphost.dll"
		"%SysNative%\dbghlp.dll"
		"%SysNative%\dsound.dll"
		"%SysNative%\d3d9.dll"
		"%SysNative%\ddraw.dll"
		"%SysNative%\olepro32.dll"
		"%SysNative%\perfctrs.dll"
		"%SysNative%\version.dll"
		"%SysNative%\drivers\beep.sys"
		"%SysNative%\spoolsv.exe"
	) DO @IF EXIST %%G ECHO.%%~G
) ELSE (
	ECHO.%SystemX86%\drivers\atapi.sys
	ECHO.%SystemX86%\drivers\asyncmac.sys
	ECHO.%SystemX86%\drivers\beep.sys
	ECHO.%SystemX86%\drivers\kbdclass.sys
	ECHO.%SystemX86%\drivers\ndis.sys
	ECHO.%SystemX86%\drivers\ntfs.sys
	ECHO.%SystemX86%\drivers\null.sys
	ECHO.%SystemX86%\drivers\tcpip.sys
	ECHO.%SystemX86%\browser.dll
	ECHO.%SystemX86%\lsass.exe
	ECHO.%SystemX86%\netman.dll
	ECHO.%SystemX86%\comres.dll
	ECHO.%SystemX86%\qmgr.dll
	ECHO.%SystemX86%\rpcss.dll
	ECHO.%SystemX86%\services.exe
	ECHO.%SystemX86%\spoolsv.exe
	ECHO.%SystemX86%\winlogon.exe
	ECHO.%SystemX86%\wuauclt.exe
	IF EXIST Vista.krl ECHO.%SystemX86%\drivers\tdx.sys
	IF NOT EXIST Vista.krl ECHO.%SystemX86%\drivers\ipsec.sys
	)

ECHO.%SystemX86%\comctl32.dll
IF NOT EXIST W8.mac ECHO.%SystemX86%\cryptsvc.dll
ECHO.%SystemX86%\es.dll
ECHO.%SystemX86%\imm32.dll
ECHO.%SystemX86%\kernel32.dll
ECHO.%SystemX86%\linkinfo.dll
ECHO.%SystemX86%\lpk.dll
ECHO.%SystemX86%\mshtml.dll
ECHO.%SystemX86%\msvcrt.dll
ECHO.%SystemX86%\mswsock.dll
ECHO.%SystemX86%\netlogon.dll
ECHO.%SystemX86%\powrprof.dll
ECHO.%SystemX86%\scecli.dll
ECHO.%SystemX86%\sfc.dll
ECHO.%SystemX86%\svchost.exe
ECHO.%SystemX86%\tapisrv.dll
ECHO.%SystemX86%\user32.dll
ECHO.%SystemX86%\userinit.exe
ECHO.%SystemX86%\wininet.dll
ECHO.%SystemX86%\ws2_32.dll
ECHO.%SystemX86%\ws2help.dll
ECHO.%Systemroot%\explorer.exe
ECHO.%Systemroot%\regedit.exe
ECHO.%SystemX86%\ole32.dll
ECHO.%SystemX86%\usp10.dll
ECHO.%SystemX86%\ksuser.dll
ECHO.%SystemX86%\ctfmon.exe
ECHO.%SystemX86%\shsvcs.dll
ECHO.%SystemX86%\msimg32.dll

IF EXIST XP.mac (
	ECHO.%SystemX86%\srsvc.dll
	ECHO.%SystemX86%\wscntfy.exe
	ECHO.%SystemX86%\xmlprov.dll
	ECHO.%SystemX86%\ntdll.dll
	IF EXIST %SystemX86%\msctfime.ime ECHO.%SystemX86%\msctfime.ime
	)

IF EXIST Vista.krl (
	IF NOT EXIST W8.mac ECHO.%SystemX86%\cngaudit.dll
	IF NOT EXIST W8.mac ECHO.%SystemX86%\wininit.exe
) ELSE (
	ECHO.%SystemX86%\eventlog.dll
	ECHO.%SystemX86%\sfcfiles.dll
	ECHO.%SystemX86%\drivers\ipsec.sys
	)

IF NOT EXIST W6432.dat (
	ECHO.%SystemX86%\regsvc.dll
	ECHO.%SystemX86%\schedsvc.dll
	ECHO.%SystemX86%\ssdpsrv.dll
	ECHO.%SystemX86%\termsrv.dll
	ECHO.%SystemX86%\hnetcfg.dll
	)

FOR %%G IN (
	"%SystemX86%\6to4.dll"
	"%SystemX86%\appmgmts.dll"
	"%SystemX86%\drivers\acpiec.sys"
	"%SystemX86%\drivers\aec.sys"
	"%SystemX86%\drivers\agp440.sys"
	"%SystemX86%\drivers\ip6fw.sys"
	"%SystemX86%\ias.dll"
	"%SystemX86%\iprip.dll"
	"%SystemX86%\mfc40u.dll"
	"%SystemX86%\msgsvc.dll"
	"%SystemX86%\mspmsnsv.dll"
	"%SystemX86%\ntkrnlpa.exe"
	"%SystemX86%\ntmssvc.dll"
	"%SystemX86%\upnphost.dll"
	"%SystemX86%\dbghlp.dll"
	"%SystemX86%\dsound.dll"
	"%SystemX86%\d3d9.dll"
	"%SystemX86%\ddraw.dll"
	"%SystemX86%\olepro32.dll"
	"%SystemX86%\perfctrs.dll"
	"%SystemX86%\version.dll"
	"%ProgFiles%\internet explorer\iexplore.exe"
	"%ProgFiles%\mozilla Firefox\firefox.exe"
	"%LocalAppData%\Google\Chrome\Chrome.exe"
	"%ProgFiles%\Opera\Opera.exe"
	"%SystemX86%\ntoskrnl.exe"
	"%SystemX86%\srsvc.dll"
	"%SystemX86%\w32time.dll"
	"%SystemX86%\wiaservc.dll"
	"%SystemX86%\midimap.dll"
	"%SystemX86%\rasadhlp.dll"
	"%SystemX86%\wshtcpip.dll"
	) DO @IF EXIST %%G ECHO.%%~G

)>SigChk.dat


PEV -k NIRKMD.%cfext%
SET CacheSum=
SWREG QUERY "HKLM\SOFTWARE\Swearware" /V CacheSum > CacheSum00 &&(
	SED -r "/.*\t/!d; s///" CacheSum00 > CacheSum01
	FOR /F %%G IN ( CacheSum01 ) DO SET "CacheSum=%%G"
	)
DEL /A/F/Q CacheSum0?
	

IF DEFINED CacheSum IF EXIST W6432.dat (
	IF EXIST "%FD_Cachex64%\FD_Cache.md5" (
		PEV -c##5# "%FD_Cachex64%\FD_Cache.md5" -output:Cache.sum
		FOR /F %%G IN ( Cache.sum ) DO IF /I "%%G" EQU "%CacheSum%" (
			PEV -rtf -files:SigChk.dat -c##5#b#f# -output:SigFilesHash.dat
			FINDSTR -BIVG:"%FD_Cachex64%\FD_Cache.md5" SigFilesHash.dat | SED "s/.*\t//" >SigChk.dat
			))
) ELSE IF EXIST "%FD_Cache%\FD_Cache.md5" (
	PEV -c##5# "%FD_Cache%\FD_Cache.md5" -output:Cache.sum
	FOR /F %%G IN ( Cache.sum ) DO IF /I "%%G" EQU "%CacheSum%" (
		PEV -rtf -files:SigChk.dat -c##5#b#f# -output:SigFilesHash.dat
		FINDSTR -BIVG:"%FD_Cache%\FD_Cache.md5" SigFilesHash.dat | SED "s/.*\t//" >SigChk.dat
		))

ECHO.::::>>SigChk.dat
IF EXIST SigFilesHash.dat DEL /A/F SigFilesHash.dat Cache.Sum


START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k ROUTE.%cfExt%
ROUTE PRINT 0.0.0.0 > Route00
PEV -k NIRKMD.%cfext%
SED -r "/^\s+0\.0\.0\.0\s+0\.0\.0\.0\s+(\S+)\s+.*/!d;s//\1/;" Route00 >FDSV_Gateway
GREP -sq . FDSV_Gateway ||DEL /A/F FDSV_Gateway
IF EXIST FDSV_Gateway (
	START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k ROUTE.%cfExt%
	HIDEC ROUTE DELETE 0.0.0.0
	PEV -k NIRKMD.%cfext%
	)
DEL /A/F Route00 


START NIRKMD CMDWAIT 130000 EXEC HIDE PEV.exe -k PEV.%cfExt%
PEV -tx120000 -files:SigChk.dat -tg -output:fdsv_a0
PEV -k NIRKMD.%cfext%


IF EXIST FDSV_Gateway (
	FOR /F %%G IN ( FDSV_Gateway ) DO @(
		START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k ROUTE.%cfExt%
		ROUTE ADD 0.0.0.0 MASK 0.0.0.0 %%G
		PEV -k NIRKMD.%cfext%
		)
	DEL /A/F FDSV_Gateway
) ELSE IF EXIST \Qoobox\LastRun\Gateway (
	FOR /F %%G in ( \Qoobox\LastRun\gateway ) DO @(
		START NIRKMD CMDWAIT 3000 EXEC HIDE PEV -k ROUTE.%cfExt%
		ROUTE add 0.0.0.0 mask 0.0.0.0 %%G 
		PEV -k NIRKMD.%cfext%
		)
	DEL /A/F Route00 Chk_Gateway
	)	
	
ECHO.::::>>fdsv_a0
GREP -Fivf fdsv_a0 SigChk.dat >fdsv_Aa

IF NOT EXIST "%FD_Cache%\" MD "%FD_Cache%"
SWXCACLS %FD_Cache% /P /RESET /Q


IF EXIST W6432.dat (
	SED -r "s/%sysnative:\=\\%/%sysdir:\=\\%/Ig" SigChk.dat > SigChkx64.dat
	FOR /F "TOKENS=*" %%G IN ( SigChkx64.dat ) DO @IF NOT "%%G" == "::::" IF NOT EXIST "%%~G" ECHO.%%G ... %is missing% !!>>SigChkMissing.dat
	DEL SigChkx64.dat
	IF NOT EXIST "%FD_Cachex64%\" MD "%FD_Cachex64%"
	SWXCACLS %FD_Cachex64% /P /RESET /Q
	IF NOT EXIST "%FD_Cachex64%\FD_Cache.md5" PEV -tpmz -tx50000 -c##5# "%FD_Cachex64%\*" or "%FD_Cache%\*" -output:"%FD_Cachex64%\FD_Cache.md5"
	COPY /Y "%FD_Cachex64%\FD_Cache.md5"
) ELSE (
	IF NOT EXIST "%FD_Cache%\FD_Cache.md5" PEV -tpmz -tx50000 -c##5# "%FD_Cache%\*" -output:"%FD_Cache%\FD_Cache.md5"
	COPY /Y "%FD_Cache%\FD_Cache.md5"
	FOR /F "TOKENS=*" %%G IN ( SigChk.dat ) DO @IF NOT "%%G" == "::::" IF NOT EXIST "%%~G" ECHO.%%G ... %is missing% !!>>SigChkMissing.dat
	)


PEV -tx50000 -fs32 -files:fdsv_a0 -c##f#b#5# -output:Sigged.md5
ECHO.::::>>FD_Cache.md5
GREP -Fivf FD_Cache.md5  Sigged.md5 | SED "s/	.*//" >Fdsv2Copy



IF EXIST W6432.dat (
	CALL :FDSV6432
	PEV -tpmz -tx50000 -c##5# "%FD_Cachex64%\*" or "%FD_Cache%\*" -output:"%FD_Cachex64%\FD_Cache.md5"
	PEV -c##5# "%FD_Cachex64%\FD_Cache.md5" -output:Cache.sum
	SET FD_Cachex64=
) ELSE (
	FOR /F "TOKENS=*" %%G IN ( Fdsv2Copy ) DO @(
		ATTRIB -H -R -S "%%~G"
		COPY /Y "%%~G" "%FD_Cache%"
		)
	PEV -tpmz -tx50000 -c##5# "%FD_Cache%\*" -output:"%FD_Cache%\FD_Cache.md5"
	PEV -c##5# "%FD_Cache%\FD_Cache.md5" -output:Cache.sum
	)
	
SET FD_Cache=

FOR /F %%G IN ( Cache.sum ) DO @SWREG ADD "HKLM\SOFTWARE\Swearware" /V CacheSum /D %%G
DEL Cache.sum


GREP -c . fdsv_A0 | GREP -sqx 1 &&(
	SWSC QUERY CRYPTSVC >temp00
	GREP -q "STATE.*RUNNING" temp00 ||(
		TYPE myNul.dat >fdsv_Aa
		ECHO.
		ECHO.%Cryptography Services Error% !!
		)>fdsv_x
	DEL temp00
	)

	
FOR /F "TOKENS=*" %%G IN ( fdsv_Aa ) DO @(
	ECHO.>>fdsv_E
	IF EXIST W6432.dat (
		PEV -tx50000 -tf -sadate -c:#[#v] #m . #5 . #u . . [#g]#b#f# "%Systemroot%\%%~NXG" -skip"%SysDir%" >Fdsv_Found
		PEV -tx50000 -tf -sadate -c:#[#v] #m . #5 . #u . . [#g]#b#f# "%SysNative%\%%~NXG" >>Fdsv_Found
		PEV -rt!b "%%~G" -output:Fdsv_Foundx86 || DEL /A/F Fdsv_Foundx86
		IF EXIST Fdsv_Foundx86 (
			FOR /F "TOKENS=1* DELIMS=	" %%H IN ( Fdsv_Found ) DO @PEV -rt!b "%%~I" && ECHO.%%H .. %%I>>fdsv_E
			DEL Fdsv_Foundx86
		) ELSE FOR /F "TOKENS=1* DELIMS=	" %%H IN ( Fdsv_Found ) DO @PEV -rtb "%%~I" && ECHO.%%H .. %%I>>fdsv_E
		DEL /A/F Fdsv_Found
		) ELSE PEV -tx50000 -tf -sadate -c:#[#v] #m . #5 . #u . . [#g] . . #f# "%Systemroot%\%%~NXG">>fdsv_E
	)
	

IF EXIST Fdsv_E GREP -Fsq :\ Fdsv_E &&(
	ECHO.------- Sigcheck -------
	ECHO.Note: Unsigned files aren't necessarily malware.
	IF EXIST W6432.dat (
		SED -r "s/%sysnative:\=\\%/%sysdir:\=\\%/Ig" Fdsv_E
		) ELSE TYPE Fdsv_E
	IF EXIST SigChkMissing.dat ECHO.&TYPE SigChkMissing.dat
	ECHO.
	)>>ComboFix.txt

	

IF EXIST Fdsv_x (
	ECHO.------- Sigcheck -------
	ECHO.Note: Unsigned files aren't necessarily malware.
	TYPE Fdsv_x
	IF EXIST SigChkMissing.dat ECHO.&TYPE SigChkMissing.dat
	ECHO.
	)>>ComboFix.txt
DEL /A/F fdsv_?? Fdsv2Copy Sigged.md5 FD_Cache.md5 SigChk.dat /q
IPCONFIG /RENEW
@GOTO :EOF



:FDSV6432
@SED -r "s/^%SysNative:\=\\%(.*)/%SysDir:\=\\%\1\t%FD_Cachex64:\=\\%/I; /\t/!s/.*/&\t%FD_Cache:\=\\%/I" Fdsv2Copy > Fdsv2Copy.dat
@FOR /F "TOKENS=1* DELIMS=	" %%G IN ( Fdsv2Copy.dat ) DO @(
	ATTRIB -H -R -S "%%~G"
	COPY /Y "%%~G" "%%H"
	)

@DEL Fdsv2Copy.dat
@GOTO :EOF

