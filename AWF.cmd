

@ECHO.(((((((((((((((((((((((((((((((((((((((((((((   AWF   ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))>>ComboFix.txt
@ECHO.>>ComboFix.txt


PEV VOLUME >Drives01
@IF NOT EXIST Drives01 ECHO.%systemdrive%>Drives01

FOR /F %%G in ( Drives01 ) DO @(
	PEV -tx50000 -td %%GBAK -output:awf00
	FOR /F "TOKENS=*" %%H in ( awf00 ) DO @(
		PEV -tx50000 -tf -c:##c . #m#b#u#b#f# "%%H\*" -output:awf01
		FOR /F "TOKENS=*" %%I in ( awf01 ) DO @(
			ECHO.%%I
			PEV -tx50000 -rtf -c:##c . #m#b#u#b#f# "%%~DPH%%~NXI"
			ECHO.
			)
		DEL /A/F awf01
		)
	DEL /A/F awf00
	)>>ComboFix.txt

@ECHO.>>ComboFix.txt
@DEL /A/F Drives0? /Q
@GOTO :EOF