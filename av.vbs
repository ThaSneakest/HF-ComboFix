
On Error Resume Next

Const ForAppending = 2
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile("Resident.txt", ForAppending, True)

If objFSO.FileExists("Vista.krl") Then
   Set oWMI = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\SecurityCenter2")
      For Each obj in oWMI.ExecQuery("Select * from AntiVirusProduct")
       If InStr(2, Hex(obj.productState), "1", 0) = 2 Then enabled = " *Enabled" Else enabled = " *Disabled"
       If InStr(4, Hex(obj.productState), "0", 0) = 4 Then updated = "/Updated* " Else updated = "/Outdated* "
       objLogFile.Write("AV: " _
           & obj.displayName _
           & Enabled _
           & Updated _
           & obj.instanceGuid _
           & vbCrLf )
   Next
   For Each obj in oWMI.ExecQuery("Select * from AntiSpywareProduct")
      If InStr(2, Hex(obj.productState), "1", 1) = 2 Then enabled = " *Enabled" Else enabled = " *Disabled"
       If InStr(4, Hex(obj.productState), "0", 1) = 4 Then updated = "/Updated* " Else updated = "/Outdated* "
       objLogFile.Write("SP: " _
           & obj.displayName _
           & Enabled _
           & Updated _
           & obj.instanceGuid _
           & vbCrLf )
   Next
   For Each obj in oWMI.ExecQuery("Select * from FirewallProduct")
       If InStr(2, Hex(obj.productState), "1", 1) = 2 Then enabled = " *Enabled* " Else enabled = " *Disabled* "
       objLogFile.Write("FW: " _
           & obj.displayName _
           & Enabled _
           & obj.instanceGuid _
           & vbCrLf )
   Next
   
ELSE

   Set oWMI = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\SecurityCenter")
   For Each obj in oWMI.ExecQuery("Select * from AntiVirusProduct")
       If obj.onAccessScanningEnabled = 0 Then enabled = " *Disabled" Else enabled = " *Enabled" 
       If obj.productUptoDate = 0 Then updated = "/Outdated* " Else updated = "/Updated* "
       objLogFile.Write("AV: " _
           & obj.displayName _
           & enabled _
           & updated _
           & obj.instanceGuid _
           & vbCrLf )
   Next
   For Each obj in oWMI.ExecQuery("Select * from AntiSpywareProduct")
       If obj.ProductEnabled = 0 Then enabled = " *Disabled" Else enabled = " *Enabled" 
       If obj.productUptoDate = 0 Then updated = "/Outdated* " Else updated = "/Updated* "
       objLogFile.Write("SP: " _
           & obj.displayName _
           & enabled _
           & updated _
           & obj.instanceGuid _
           & vbCrLf )
   Next
   For Each obj in oWMI.ExecQuery("Select * from FirewallProduct")
       If obj.Enabled = 0 Then enabled = " *Disabled* " Else enabled = " *Enabled* " 
       objLogFile.Write("FW: " _
           & obj.displayName _
           & enabled _
           & obj.instanceGuid _
           & vbCrLf )
   Next

END IF


objLogFile.Close
wscript.quit
