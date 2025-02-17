On Error Resume Next

Set ConvertedDate = CreateObject("WbemScripting.SWbemDateTime")
Set CutOff = ConvertedDate
CutOff.SetVarDate (Date -1), False

Set objSR = GetObject("winmgmts:root/default")
Set colSR = objSR.ExecQuery ("Select * from SystemRestore Where CreationTime >= '" & CutOff & "'" )
Set objRP = GetObject("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")

If colSR.Count = 0 Then
    If (objRP.CreateRestorePoint("ComboFix created restore point", 0, 100)) = 0 Then
        wscript.Echo " * Created a new restore point"
    End If
End If
