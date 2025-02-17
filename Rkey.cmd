
IF NOT DEFINED Ver_CF GOTO :EOF
IF /I "%1" EQU "RKEYB" GOTO RKEYB

@SWREG ACL "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /RESET /Q
@SWREG ACL "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /RO:F /RA:F /Q
@GOTO :EOF

:RKEYB
@SWREG ACL "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /O Guest /Q
@SWREG ACL "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /DE:F /Q
@GOTO :EOF

