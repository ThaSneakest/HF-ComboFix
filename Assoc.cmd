
@PROMPT $

(
ECHO.batfile="%%1" %%*
ECHO.cmdfile="%%1" %%*
ECHO.comfile="%%1" %%*
ECHO.exefile="%%1" %%*
ECHO.piffile="%%1" %%*
ECHO.scrfile="%%1" /S
ECHO.regedit=regedit.exe %%1
ECHO.regedit=%systemroot%\regedit.exe %%1
ECHO.regedit=%%systemroot%%\regedit.exe %%1
ECHO.regfile=regedit.exe "%%1"
ECHO.regedit="regedit.exe" "%%1"
ECHO.regfile=%systemroot%\regedit.exe %%1
ECHO.regfile=%%systemroot%%\regedit.exe %%1
ECHO.txtfile=NOTEPAD.EXE %%1
ECHO.txtfile=%SystemRoot%\system32\NOTEPAD.EXE %%1
ECHO.txtfile=%%SystemRoot%%\system32\NOTEPAD.EXE %%1
ECHO.chm.file="%SystemRoot%\hh.exe" %%1
ECHO.chm.file="%%SystemRoot%%\hh.exe" %%1
ECHO.inffile=NOTEPAD.EXE %%1
ECHO.inffile=%SystemRoot%\System32\NOTEPAD.EXE %%1
ECHO.inffile=%%SystemRoot%%\System32\NOTEPAD.EXE %%1
ECHO.inifile=NOTEPAD.EXE %%1
ECHO.inifile=%SystemRoot%\System32\NOTEPAD.EXE %%1
ECHO.inifile=%%SystemRoot%%\System32\NOTEPAD.EXE %%1
ECHO.VBEFile=WScript.exe "%%1" %%*
ECHO.VBEFile=%SystemRoot%\System32\WScript.exe "%%1" %%*
ECHO.VBEFile=%%SystemRoot%%\System32\WScript.exe "%%1" %%*
echo.VBEFile="%%SystemRoot%%\System32\WScript.exe" "%%1" %%*
ECHO.VBEFile=CScript.exe "%%1" %%*
ECHO.VBEFile=%SystemRoot%\System32\CScript.exe "%%1" %%*
ECHO.VBEFile=%%SystemRoot%%\System32\CScript.exe "%%1" %%*
echo.VBEFile="%%SystemRoot%%\System32\CScript.exe" "%%1" %%*
ECHO.VBSFile=WScript.exe "%%1" %%*
ECHO.VBSFile=%SystemRoot%\System32\WScript.exe "%%1" %%*
ECHO.VBSFile=%%SystemRoot%%\System32\WScript.exe "%%1" %%*
echo.VBSFile="%%SystemRoot%%\System32\WScript.exe" "%%1" %%*
ECHO.VBSFile=CScript.exe "%%1" %%*
ECHO.VBSFile=%SystemRoot%\System32\CScript.exe "%%1" %%*
ECHO.VBSFile=%%SystemRoot%%\System32\CScript.exe "%%1" %%*
ECHO.VBSFile="%%SystemRoot%%\System32\CScript.exe" "%%1" %%*
ECHO.JSEFile=WScript.exe "%%1" %%*
ECHO.JSEFile=%SystemRoot%\System32\WScript.exe "%%1" %%*
ECHO.JSEFile=%%SystemRoot%%\System32\WScript.exe "%%1" %%*
ECHO.JSEFile=CScript.exe "%%1" %%*
ECHO.JSEFile=%SystemRoot%\System32\CScript.exe "%%1" %%*
ECHO.JSEFile=%%SystemRoot%%\System32\CScript.exe "%%1" %%*
ECHO.JSFFile=WScript.exe "%%1" %%*
ECHO.JSFFile=%SystemRoot%\System32\WScript.exe "%%1" %%*
ECHO.JSFFile=%%SystemRoot%%\System32\CScript.exe "%%1" %%*
ECHO.JSFFile=CScript.exe "%%1" %%*
ECHO.JSFFile=%SystemRoot%\System32\CScript.exe "%%1" %%*
ECHO.JSFFile=%%SystemRoot%%\System32\CScript.exe "%%1" %%*
IF EXIST W6432.dat (
	ECHO.inffile=%SystemRoot%\SysWow64\NOTEPAD.EXE %%1
	ECHO.inffile=%%SystemRoot%%\SysWow64\NOTEPAD.EXE %%1
	ECHO.JSFile=%%SystemRoot%%\SysWow64\WScript.exe "%%1" %%*
	ECHO.JSFile=%SystemRoot%\SysWow64\WScript.exe "%%1" %%*
	ECHO.VBEFile=%%SystemRoot%%\SysWow64\WScript.exe "%%1" %%*
	ECHO.VBEFile=%SystemRoot%\SysWow64\WScript.exe "%%1" %%*
	ECHO.VBSFile=%%SystemRoot%%\SysWow64\WScript.exe "%%1" %%*
	ECHO.VBSFile=%SystemRoot%\SysWow64\WScript.exe "%%1" %%*
	)
)>Assocs


Ftype >Assoc00
GREP -Ei "^(batfile|cmdfile|comfile|exefile|piffile|scrfile|regedit|regfile|txtfile|chm.file|inffile|inifile|VBEFile|VBSFile|JSEFile|JSFFile)=" Assoc00 >Assoc01
GREP -Fixvf Assocs Assoc01 >AssocsB.txt

IF EXIST W6432.dat (SET "ClassKey=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Classes")	ELSE SET "ClassKey=HKEY_CLASSES_ROOT"

FOR %%G IN (
batfile
cmdfile
comfile
exefile
piffile
scrfile
regedit
regfile
txtfile
chm.file
inffile
inifile
VBEFile
VBSFile
JSEFile
JSFFile
) DO @SWREG QUERY "%ClassKey%\%%G\SHELL" /VE >>AssocsC


SED "/^H\|	/!d" AssocsC | SED ":a; $!N;s/\n   .*	/\\/;ta;P;D;" >Assoc02
GREP -Eiv "\\$|\\Open$" Assoc02 >AssocsD

FOR /F "TOKENS=*" %%G IN ( assocsD ) DO @(
	SWREG QUERY "%%G\Command" /VE >Assoc03
	SED ":a; $!N;s/\n.*	/=/;ta;P;D" Assoc03 | SED "/^H/!d; s/%classkey:\=\\%\\//I" >>assocsB.txt
	DEL /A/F Assoc03
	)

FOR %%G IN (
bat
cmd
com
exe
scr
reg
txt
) DO @SWREG QUERY "%ClassKey%\.%%G" /VE >>assocsE
SED ":a; $!N;s/\n  .*	/=/;ta;P;D" assocsE | SED -r "/.*\\/!d; s///; /^\.(...)=\1file$/Id" >>assocsB.txt


GREP . assocsB.txt >Assoc04 || DEL /A/F assocsB.txt
DEL /A/F/Q assocs assocsA assocsC assocsD assocsE assoc0?
SET ClassKey=





