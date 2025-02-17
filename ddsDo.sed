1d

/^([dum](Local Page|Search Page|Search Bar|SearchMigratedDefaultURL|Window Title|Default_Page_URL|Default_Search_URL|Start Page|URLSearchHooks|Internet Connection Wizard,ShellNext|Internet Settings,Proxy(Server|Override)|CustomizeSearch|SearchAssistant|SearchURL,\(Default\)|SearchURL|Search) =|([mu]Winlogon|BHO|TB|EB|[mud]Run|StartupFolder|[mud]Policies-explorer|[mud]ExplorerRun|[mud]Policies-system|IE|LSP|Trusted Zone|DPF|TCP|Filter|Handler|Name-Space Handler|Notify|AppInit_DLLs|SSODL|STS|STS|SEH):)/!d; 

s/^u(Local Page) =.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=hex(2):25,53,79,73,74,65,6d,52,6f,6f,74,25,5c,73,79,73,74,65,6d,33,32,5c,62,6c,61,6e,6b,2e,68,74,6d,00/I;

s/^m(Local Page) =.*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=hex(2):25,53,79,73,74,65,6d,52,6f,6f,74,25,5c,73,79,73,74,65,6d,33,32,5c,62,6c,61,6e,6b,2e,68,74,6d,00/I;

s/^u(Start Page) =.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=69157\x22/I;

s/^m(Start Page) =.*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=69157\x22/I;

s/^u(Search Page) =.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=\x22http:\/\/www.microsoft.com\/isapi\/redir.dll?p\x22/I;

s/^m(Search Page) =.*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=54896\x22/I;

s/^u(Default_Page_URL) =.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=69157\x22/I;

s/^m(Default_Page_URL) =.*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=69157\x22/I;

s/^u(Default_Search_URL) =.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=54896\x22/I;

s/^m(Default_Search_URL) =.*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=\x22http:\/\/go.microsoft.com\/fwlink\/?LinkId=54896\x22/I;

s/^m(Search Bar|SearchMigratedDefaultURL|Window Title|SearchAssistant) =.*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=-/I;

s/^u(Search Bar|SearchMigratedDefaultURL|Window Title|SearchAssistant) =.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main]\n\x22\1\x22=-/I;

s/^uInternet Connection Wizard,(ShellNext) =.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Connection Wizard]\n\x22\1\x22=\x22http:\/\/www.microsoft.com\/isapi\/redir.dll?prd=ie\&pver=6\&ar=msnhome\x22/I;

s/^uInternet Settings,(ProxyServer|ProxyOverride) =.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings]\n\x22\1\x22=-\n\x22ProxyEnable\x22=dword:0/I;

s/^[dum]URLSearchHooks: .* - (\S*) -( (.:\\.*)| .[^:]*|$)/\3/I;
s/^[dum]URLSearchHooks: .*: (\S*) -( (.:\\.*)| .[^:]*|$)/\3/I;

s/u(SearchAssistant|CustomizeSearch) =.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Search]\n\x22\1\x22=-/I;
s/^m(SearchAssistant|CustomizeSearch) =.*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Search]\n\x22\1\x22=-/I;

s/^uSearchURL,\(Default\) =.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\SearchUrl]\n\x22\@\x22=-/I;
s/^mSearchURL,\(Default\) =.*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\SearchUrl]\n\x22\@\x22=-/I;

s/u(SearchURL|Search) =.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer]\n\x22\1\x22=-/I;
s/m(SearchURL|Search) =.*/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer]\n\x22\1\x22=-/I;

s/^(BHO|TB|EB|SEH|STS): (\{[-a-z0-9]*}) -( (.:\\.*)| .[^:]*|$)/\[-HKEY_Browser Helper Objects\\\U\2]\E\n\4/I;
s/^(BHO|TB|EB|SEH|STS): [^:]*: (\{[-a-z0-9]*}) -( (.:\\.*)| .[^:]*|$)/\[-HKEY_Browser Helper Objects\\\U\2]\E\n\4/I;

/^mWinlogon: (Userinit|Shell|SfcDisable)=/Id;

s/^mWinlogon: (UIHost)=.*/\[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon]\n\x22\1\x22=\x22logonui.exe\x22/I;

/^[dum]Ru(n|NOnce|nServices|nServicesOnce): \[/{s/] ; ((\x22.|.):\\.*)/] \1/I; s/(] (\x22.|.):\\.*) \/.*/\1/I; s/(] (\x22.:\\.[^\x22]*\x22)) .*/\1/I;};

s/^([mud](Run|RunOnce|RunServices|RunServicesOnce): \[.*\]) Rundll3\S*( (.:\\.*\....)| \x22(.:\\.*\...)\x22),.*/\1\3/I

s/^([mud](Run|RunOnce|RunServices|RunServicesOnce): \[.*\])( (.:\\.*\....)| \x22(.:\\.*\...)\x22) -[^-.\\]*/\1\3/I

s/^u(Run|RunOnce|RunServices|RunServicesOnce): \[(.*)\] Rundll3\S*( (.:\\.*\....)| \x22(.:\\.*\...)\x22),.*/[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\\1]\n\x22\2\x22=-\n\4\5/I;

s/^u(Run|RunOnce|RunServices|RunServicesOnce): \[(.*)\]( (.:\\.*)$| \x22(.:\\.*)\x22$| [^]]*$|$)/[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\\1]\n\x22\2\x22=-\n\4\5/I;

s/^m(Run|RunOnce|RunServices|RunServicesOnce): \[(.*)\]( (.:\\.*)$| \x22(.:\\.*)\x22$| [^]]*$|$)/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\\1]\n\x22\2\x22=-\n\4\5/I;

s/^d(Run|RunOnce|RunServices|RunServicesOnce): \[(.*)\]( (.:\\.*)$| \x22(.:\\.*)\x22$| [^]]*$|$)/[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\\1]\n\x22\2\x22=-\n\4\5/I;

s/^uExplorerRun: \[(.*)\]( (.:\\.*$)| \x22(.:\\.*)\x22$| [^]]*$|$)/[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\\Run]\n\x22\1\x22=-\n\3\4/I;

s/^mExplorerRun: \[(.*)\]( (.:\\.*$)| \x22(.:\\.*)\x22$| [^]]*$|$)/[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\\Run]\n\x22\1\x22=-\n\3\4/I;

s/^dExplorerRun: \[(.*)\]( (.:\\.*$)| \x22(.:\\.*)\x22$| [^]]*$|$)/[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\\Run]\n\x22\1\x22=-\n\3\4/I;

s/^StartupFolder: (.:\\[^:]*) -( (.:\\.*)$| \x22(.:\\.*)\x22$| [^]]*$|$)/\1\n\3\4/I;

/[udm]Policies-(explorer|system): /Id 

s/^IE: (\{[-a-z0-9]*}) - (\{[-a-z0-9]*}) -( (.:\\.*)| .*|$)/\[-HKEY_Browser Helper Objects\\\U\1\E]\n\[-HKEY_Browser Helper Objects\\\U\2\E]\n\4/I;

s/^IE: (\{[-a-z0-9]*}) -( (.:\\.*)| .*|$)/\[-HKEY_Browser Helper Objects\\\U\1\E]\n\3/I;

s/^IE: ([^{].*) -( (.:\\.*)| .*|$)/[-HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\MenuExt\\\1]\n\3/I;

s/^LSP:( (.:\\.*)| .*|$)/\2/I

s/^DPF: (\{[-a-z0-9]*}).*/\[-HKEY_Browser Helper Objects\\\U\1]/I;

s/^Trusted Zone: (.*)/\[-HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\Currentversion\\Internet settings\\Zonemap\\Domains\\\1]\n\[-HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\Currentversion\\Internet settings\\Zonemap\\Domains\\\1]/I

s/^TCP: (NameServer) =.*/[HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters]\n\x22\1\x22=-\n\x22\1\x22=\x22\x22/I;

s/^TCP: (\{[-a-z0-9]*}) =.*/[HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters\\Interfaces\\\U\1\E]\n\x22NameServer\x22=-\n\x22\NameServer\x22=\x22\x22/I;

s/^(Filter|Handler|Name-Space Handler): (.*) - (\{[-a-z0-9]*}) -( (.:\\.*)| .*|$)/[-HKEY_CLASSES_ROOT\\Protocols\\\1\\\U\2\E]\n[-HKEY_Browser Helper Objects\\\U\3\E]\n\5/I;

s/^(Filter|Handler|Name-Space Handler): (.*) -$/[-HKEY_CLASSES_ROOT\\Protocols\\\1\\\U\2\E]/I;

s/^Notify: (.*) -( (.:\\.*)| .*|$)/\[-HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\\Notify\\\U\1\E]\n\3/I;

s/(AppInit_DLLs): .*/\[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Windows]\n\x22\1\x22=-/I;

s/^SSODL: (.*) - (\{[-a-z0-9]*}) -( (.:\\.*)| .*|$)/[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ShellServiceObjectDelayLoad]\n\x22\1\x22=-\n[-HKEY_Browser Helper Objects\\\U\2\E]\n\4/I;

/^LSA: /Id
/^(SubSystems|SecurityProviders): /Id

/^(.:\\|\[|\x22)/!d
