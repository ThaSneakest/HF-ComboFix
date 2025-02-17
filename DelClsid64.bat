
@IF EXIST chcp.bat CALL chcp.bat
@IF NOT EXIST delclsid00-X64 GOTO :EOF
@GREP -isq . delclsid00-X64 || GOTO :EOF

@SETLOCAL
SET "U_=HKEY_CURRENT_USER\\"
SET "M_=HKEY_LOCAL_MACHINE\\"
SET "C_=Software\\Microsoft\\Windows\\CurrentVersion\\"
SET "D_=Software\\Microsoft\\Internet Explorer\\"

@SED -r "s/\x22//g; s/.*/\n[-HKEY_CLASSES_ROOT\\CLSID\\&\]\n[-%U_%%C_%Explorer\\ControlPanel\\NameSpace\\&\]\n[-%U_%%C_%Explorer\\Desktop\\NameSpace\\&\]\n[-%U_%%C_%Explorer\\MyComputer\\NameSpace\\&\]\n[-%U_%%C_%Explorer\\networkNeighborhood\\NameSpace\\&\]\n[-%U_%%C_%Ext\\Stats\\&\]\n[-%U_%%C_%Ext\\Settings\\&\]\n[-%U_%%D_%Explorer Bars\\&\]\n[%U_%%D_%URLSearchHooks\]\n\x22&\x22=-\n[%U_%%D_%Toolbar\\Webbrowser\]\n\x22&\x22=-\n[%U_%%D_%Toolbar\]\n\x22&\x22=-\n[%U_%%D_%Extensions\\Cmdmapping\]\n\x22&\x22=-\n[-%M_%SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\&\]\n[-%M_%%D_%Toolbar\\&\]\n[%M_%%D_%Toolbar\]\n\x22&\x22=-\n[-%M_%%D_%Explorer Bars\\&\]\n[-%M_%%D_%Extensions\\&\]\n[-%M_%Software\\Microsoft\\Code Store Database\\Distribution Units\\&\]\n[-%M_%%C_%Explorer\\Browser Helper Objects\\&\]\n[-%M_%%C_%Ext\\PreApproved\\&\]\n[-%M_%%C_%Explorer\\ControlPanel\\NameSpace\\&\]\n[-%M_%%C_%Explorer\\Desktop\\NameSpace\\&\]\n[-%M_%%C_%Explorer\\MyComputer\\NameSpace\\&\]\n[-%M_%%C_%Explorer\\networkNeighborhood\\NameSpace\\&\]\n[%M_%%C_%Explorer\\Sharedtaskscheduler\]\n\x22&\x22=-\n[%M_%%C_%Explorer\\Shellexecutehooks\]\n\x22&\x22=-\n[%M_%%C_%Shell Extensions\\Approved\]\n\x22&\x22=-\n[%M_%%C_%policies\\Ext\\CLSID\]\n\x22&\x22=-\n/" delclsid00-X64 >>CregCx64.dat

@FOR /F "TOKENS=*" %%G IN ( delclsid00-X64 ) DO @REG.EXE QUERY "HKCR\CLSID\%%~G" /s >>ClsidKeys
@SED -r "/^H|^    \(Default\)    REG_\S*    ./!d; s/\x22//g" ClsidKeys | SED -r ":a; $!N;s/(HKEY_CLASSES_ROOT)\\clsid\\[^\\]*(\\ProgID|\\Programmable|(\\TypeLib)|\\VersionIndependentProgID)\n.*REG_\S*    (.*)/[-\1\3\\\4]/I; ta;P;D;" | GREP -F "[-HKEY" >>CregCx64.dat


@DEL /A/F/Q delclsid0?-X64 ClsidKeys


