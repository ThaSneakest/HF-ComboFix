On Error Resume Next
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile("svclist.dat", 2, True)

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colSvcs = objWMIService.ExecQuery("Select * from " & "Win32_SystemDriver",,48 )
EnumSvc
Set colSvcs = objWMIService.ExecQuery("Select * from Win32_Service",,48)
EnumSvc
objLogFile.Close

Wscript.Quit


      
Sub EnumSvc
On Error Resume Next
For Each Svc in colSvcs
   Select Case Svc.State
      Case "Running" State = "R"
      Case "Stopped" State = "S"
      Case "Paused" State = "P"
      Case "Start Pending" State = "R?"
      Case "Stop Pending" State = "S?"
      Case "Continue Pending" State = "C?"
      Case "Pause Pending" State = "P?"
      Case Else  State = "Unknown"
   End Select
      Select Case Svc.StartMode
      Case "Disabled" StartMode = "4"
      Case "Manual" StartMode = "3"
      Case "Auto" StartMode = "2"
      Case "System" StartMode = "1"
      Case "Boot" StartMode = "0"
      Case Else StartMode = "Unknown"
   End Select
   If Svc.PathName <> "0" Then
      g = ""
      e = ""
      z = ""
      f = Svc.PathName
      z = Instr(1, f, Chr(34) + " ", 1)
      If z > "0" then f = Left(f, z)
      f = (Replace(f, Chr(34), vbNullString))
      f = (Replace(f,"\??\", vbNullString))
      If InStr(1, f, SysDir +"svchost.exe -k " , 1) <> 0 then f = Left(f, (Instr(1, f, " -k ", 1)))
      z = Instr(1, f, " /", 1)
      If z > "0" then f = Left(f, z)
      e = objfso.GetFile(f)
      If e > "0" Then            
         g = objfso.GetFile(e).datecreated & " " & objfso.GetFile(e).size
         If g = "0" Then g = " [?]" Else g = " [" & g & "]"
         If InStr(1, e, SysDir +"svchost" , 1) <> 0 Then e = Svc.PathName
      Else 
         e = Svc.PathName & " --> " & f 
         g = " [?]"
      End If
      objLogFile.Write( State & StartMode & vbTab _
         & Svc.Name & ";" & Svc.DisplayName & ";" & e & g  & vbCrLF )
   ELSE objLogFile.Write( State & StartMode & vbTab _
      & Svc.Name & ";" & Svc.DisplayName & ";" & " [x]" & vbCrLF )
   END IF
Next
End Sub
