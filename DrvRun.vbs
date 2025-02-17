
On Error Resume Next

Const ForAppending = 8
Set objFSO = CreateObject("Scripting.FileSystemObject")
objFSO.DeleteFile("HDCntrl_List")
Set objLogFile = objFSO.OpenTextFile("HDCntrl_List", ForAppending, True)

Set objWMIService = GetObject("winmgmts:\\" & "." & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_SystemDriver",,48)

For Each objItem in colItems
    If objItem.State = "Running" Then 
        If objItem.StartMode = "Boot" OR objItem.StartMode = "System" Then 
            objLogFile.Write(objItem.Name & vbtab & objItem.PathName & vbcrlf )
            End IF
    End IF
Next
objLogFile.Close