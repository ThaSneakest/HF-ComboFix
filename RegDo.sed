1d

/^\[.*[^]]$/,/^$/d

/^$/d

/^.:\\/d

/^O1 - Hosts:/Id

s/HKLM\\~\\Startupfolder\\/HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Shared tools\\Msconfig\\Startupfolder\\/I

s/HKLM\\~\\Services\\/HKEY_LOCAL_MACHINE\\System\\Currentcontrolset\\Services\\/I

s/Hkey_local_machine\\~\\Distribution Units\\/HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Code Store Database\\Distribution Units\\/I

s/(\[-Hkey_local_machine\\System\\CurrentControlSet\\Control\\SafeBoot\\)Minimal(\\.*)/&\n\1Network\2/I

/^[OR].* \(file missing\)$/Is/ \(file missing\)$//I

/^O4.*\(User '([^\(]*)'\)$/Is/ \(User '([^\(]*)'\)$//I

/^[OR].*\(no file\)$/Is/ \(no file\)$//I

/^O.*\(no CLSID\) -$/Is/ \(no CLSID\) -$//I

/^O4 -/s/(] (\x22.|.):\\.*) \/.*/\1/

s/^O2 - BHO: .* - (\{[-a-z0-9]*}) -( (.:\\.*)| .[^:]*|$)/\[-HKEY_Browser Helper Objects\\\U\1]\E\n\3/I;

s/^O3 - Toolbar: .* - (\{[-a-z0-9]*}) -( (.:\\.*)| .*|$)/\[-HKEY_Browser Helper Objects\\\U\1\E]\n\3/I;

s/^O4 - HKCU\\\.\.\\(Run|RunOnce|RunServices|RunServicesOnce): \[(.*)\]( (.:\\.*)$| \x22(.:\\.*)\x22$| [^]]*$|$)/[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\\1]\n\x22\2\x22=-\n\4\5/I;

s/^O4 - HKLM\\\.\.\\(Run|RunOnce|RunServices|RunServicesOnce): \[(.*)\]( (.:\\.*)$| \x22(.:\\.*)\x22$| [^]]*$|$)/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\\1]\n\x22\2\x22=-\n\4\5/I;

s/^O4 - HKUS\\(S-1-5-[-0-9]*|.DEFAULT)\\\.\.\\(Run|RunOnce|RunServices|RunServicesOnce): \[(.*)\]( (.:\\.*$)| \x22(.:\\.*)\x22$| [^]]*$|$)/[HKEY_USERS\\\1\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\\2]\n\x22\3\x22=-\n\5\6/I;

s/^O4 - HKCU.*Policies\\Explorer\\Run: \[(.*)\]( (.:\\.*$)| \x22(.:\\.*)\x22$| [^]]*$|$)/[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\\Run]\n\x22\1\x22=-\n\3\4/I;

s/^O4 - HKLM.*Policies\\Explorer\\Run: \[(.*)\]( (.:\\.*$)| \x22(.:\\.*)\x22$| [^]]*$|$)/[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\\Run]\n\x22\1\x22=-\n\3\4/I;

s/^O4 - (StartUp|Global Startup): ([^=]*)$/@:\\\1\\\2/I;

s/^O4 - (StartUp|Global Startup): ([^\\/\x22:?*<>|]*) =( (.:\\.*$)| \x22(.:\\.*)\x22$| [^]]*$|$)/@:\\\1\\\2\n\4\5/I;

s/^O4 - (.DEFAULT Startup|.DEFAULT User Startup): ([^\\/\x22:?*<>|]*) =( (.:\\.*$)| \x22(.:\\.*)\x22$| [^]]*$|$)/#:\\\.DEFAULT Startup\\\2\n\4\5/I;

s/^O8 - Extra context menu item: (.*) - .*/[-HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\MenuExt\\\1]/I;

s/^O8 -: (.*) - .*/[-HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\MenuExt\\\1]/I;

s/^O9 -: (\{[-a-z0-9]*}) - (\{[-a-z0-9]*}) -( (.:\\.*)| .*|$)/\[-HKEY_Browser Helper Objects\\\U\1\E]\n\[-HKEY_Browser Helper Objects\\\U\2\E]\n\4/I;

s/^O9 -: (\{[-a-z0-9]*}) -( (.:\\.*)| .*|$)/\[-HKEY_Browser Helper Objects\\\U\1\E]\n\3/I;

s/^O9 - Extra .*:.* - (\{[-a-z0-9]*}) -( (.:\\.*)| .*|$)/\[-HKEY_Browser Helper Objects\\\U\1\E]\n\3/I;

s/^O10 - Unknown file in Winsock LSP:( (.:\\.*)| .*|$)/\2/I

s/^O15 (-:|-) Trusted Zone: \*\.(.*)/\[-HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\Currentversion\\Internet settings\\Zonemap\\Domains\\\2]\n\[-HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\Currentversion\\Internet settings\\Zonemap\\Domains\\\2]/I

s/^O15 (-:|-) Trusted Zone: (([^*]*)\.([^.]*\.[^.]*\..{2})|([^*]*)\.([^.]*\.[^.]{3,}))$/\[-HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\Currentversion\\Internet settings\\Zonemap\\Domains\\\4\6\\\3\5]\n\[-HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\Currentversion\\Internet settings\\Zonemap\\Domains\\\4\6\\\3\5]/I

s/^O16 -: (\{[-a-z0-9]*}).*/\[-HKEY_Browser Helper Objects\\\U\1]/I;

s/^O16 -: ([^\{].*) - .*/\[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Code Store Database\\Distribution Units\\\1]/I;

s/^O16 - DPF: (\{[-a-z0-9]*}).*/\[-HKEY_Browser Helper Objects\\\U\1]/I;

s/^O16 - DPF: ([^\{].*) \(.*\) - .*/\[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Code Store Database\\Distribution Units\\\1]/I;

s/^O20 - Winlogon Notify: (.*) -( (.:\\.*)| .*|$)/\[-HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\\Notify\\\U\1\E]\n\3/I;

s/^O21 - SSODL: (.*) - (\{[-a-z0-9]*}) -( (.:\\.*)| .*|$)/[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ShellServiceObjectDelayLoad]\n\x22\1\x22=-\n[-HKEY_Browser Helper Objects\\\U\2\E]\n\4/I;

s/^O22 - SharedTaskScheduler: .* - (\{[-a-z0-9]*}) -( (.:\\.*)| .*|$)/\[-HKEY_Browser Helper Objects\\\U\1\E]\n\3/I;

s/^O24 - Desktop Component ([0-9]*): .*/[-HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Desktop\\Components\\\1]/I;

s/^O17 (-:|-) HKLM.*Parameters: (NameServer) .*/[HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters]\n\x22\2\x22=-\n\x22\2\x22=\x22\x22/I;

s/^O17 (-:|-) HKLM.*\\(\{[-a-z0-9]*}): (NameServer) .*/[HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters\\Interfaces\\\U\2\E]\n\x22\3\x22=-\n\x22\3\x22=\x22\x22/I;

# O18 - Filter hijack: text/html - (no CLSID) - (no file)
/^O18/I{
	s/^O18 (-|-:) (.*): (.*) - (\{[-a-z0-9]*}) -( (.:\\.*)| .*|$)/[-HKEY_CLASSES_ROOT\\Protocols\\\2\\\U\3\E]\n[-HKEY_Browser Helper Objects\\\U\4\E]\n\6/I;
	s/^O18 (-|-:) (.*): (.*) -$/[-HKEY_CLASSES_ROOT\\Protocols\\\2\\\U\3\E]/I;
	s/Protocols\\Protocol/Protocols\\Handler/I
	s/Protocols\\Filter hijack/Protocols\\Filter/I
	}

s/^R[01] (-:|-) HKCU[^,]*,(Local Page).*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=hex(2):25,53,79,73,74,65,6d,52,6f,6f,74,25,5c,73,79,73,74,65,6d,33,32,5c,62,6c,61,6e,6b,2e,68,74,6d,00/I;

s/^R[01] (-:|-) HKLM[^,]*,(Local Page).*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=hex(2):25,53,79,73,74,65,6d,52,6f,6f,74,25,5c,73,79,73,74,65,6d,33,32,5c,62,6c,61,6e,6b,2e,68,74,6d,00/I;

s/^R[01] (-:|-) HKCU[^,]*,(Start Page).*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=69157\x22/I;

s/^R[01] (-:|-) HKLM[^,]*,(Start Page).*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=69157\x22/I;

s/^R[01] (-:|-) HKCU[^,]*,(Search Page).*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=\x22http:\/\/www.microsoft.com\/isapi\/redir.dll?p\x22/I;

s/^R[01] (-:|-) HKLM[^,]*,(Search Page).*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=54896\x22/I;

s/^R[01] (-:|-) HKCU[^,]*,(Default_Page_URL).*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=69157\x22/I;

s/^R[01] (-:|-) HKLM[^,]*,(Default_Page_URL).*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=69157\x22/I;

s/^R[01] (-:|-) HKCU[^,]*,(Default_Search_URL).*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=54896\x22/I;

s/^R[01] (-:|-) HKLM[^,]*,(Default_Search_URL).*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=54896\x22/I;

s/^R[01] (-:|-) HKLM[^,]*,(Search Bar|SearchMigratedDefaultURL|Window Title|SearchAssistant).*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=-/I;

s/^R[01] (-:|-) HKCU[^,]*,(Search Bar|SearchMigratedDefaultURL|Window Title|SearchAssistant).*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\2\x22=-/I;

s/^R1 (-:|-) HKCU.*Internet Connection Wizard,(ShellNext).*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Connection Wizard]\n\x22\2\x22=\x22http:\/\/www.microsoft.com\/isapi\/redir.dll?prd=ie\&pver=6\&ar=msnhome\x22/I;

s/^R1 (-:|-) HKCU.*Internet Settings,(ProxyServer|ProxyOverride).*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings]\n\x22\2\x22=-/I;

s/^R3 - Default URLSearchHook is missing.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\URLSearchHooks]\n\x22{CFBFAE00-17A6-11D0-99CB-00C04FD64497}\x22=\x22\x22/I

s/^R3 - URLSearchHook: .* - (\S*) -( (.:\\.*)| .[^:]*|$)/\3/I;

s/^R[01] (-:|-) HKCU.*Search,(SearchAssistant|CustomizeSearch).*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Search]\n\x22\2\x22=-/I;
s/^R[01] (-:|-) HKLM.*Search,(SearchAssistant|CustomizeSearch).*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Search]\n\x22\2\x22=-/I;

s/^R[01] (-:|-) HKCU[^,]*SearchURL,\(Default\).*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\SearchUrl]\n\x22\@\x22=-/I;
s/^R[01] (-:|-) HKLM[^,]*SearchURL,\(Default\).*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\SearchUrl]\n\x22\@\x22=-/I;

s/R1 (-:|-) HKCU.*Internet Explorer,(SearchURL|Search) .*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer]\n\x22\2\x22=-/I;
s/R1 (-:|-) HKLM.*Internet Explorer,(SearchURL|Search) .*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer]\n\x22\2\x22=-/I;

/^[FOR]/Id
