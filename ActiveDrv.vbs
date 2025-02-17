On Error Resume Next
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile("driverlist.dat", 2, True)

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colSvcs = objWMIService.ExecQuery("Select * from " & "Win32_SystemDriver" _
   & " Where State = 'Running'" _
   & " and StartMode <> 'Boot'" ,,48 )

For Each Svc in colSvcs
   If Svc.PathName <> "0" Then
      e = ""
      f = Svc.PathName
      f = (Replace(f, Chr(34), vbNullString))
      f = (Replace(f,"\??\", vbNullString))
      e = objfso.GetFile(f)
      objLogFile.Write( Svc.Name & vbTab & e & vbCrLF )
   END IF
Next

objLogFile.Close
Wscript.Quit


