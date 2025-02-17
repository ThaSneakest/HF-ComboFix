
On Error Resume Next

Set A = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")

For each B in A.ExecQuery("Select * from Win32_Process")
   If LCase(B.Name) = "svchost.exe" Then
      If InStr(1, B.CommandLine, "netsvcs" , 1) > 1 Then
         B.Terminate()
      End If
   End If  
Next
