
s/^HKEY_C.*CurrentVersionRun/HKCU-Run/I;

s/^HKEY_L.*CurrentVersionRun/HKLM-Run/I;

s/^HKEY_U.*CurrentVersionRun/HKU-Default-Run/I;

s/^HKEY_C.*ExplorerRun/HKCU-Explorer_Run/I;

s/^HKEY_L.*ExplorerRun/HKLM-Explorer_Run/I;

s/^HKEY_U.*ExplorerRun/HKU-Default-Explorer_Run/I;
