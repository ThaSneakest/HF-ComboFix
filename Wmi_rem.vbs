
If Wscript.arguments.count<1 Then Wscript.quit

On Error Resume Next
Set oWMI = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\SecurityCenter")
Set oWMI2 = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\SecurityCenter2")

For Each obj in oWMI.ExecQuery("Select * from AntiVirusProduct")
    If obj.InstanceGuid = WScript.Arguments.Item(0) Then obj.Delete_
Next

For Each obj in oWMI.ExecQuery("Select * from AntiSpywareProduct")
    If obj.InstanceGuid = WScript.Arguments.Item(0) Then obj.Delete_
Next

For Each obj in oWMI.ExecQuery("Select * from FirewallProduct")
    If obj.InstanceGuid = WScript.Arguments.Item(0) Then obj.Delete_
Next

For Each obj in oWMI2.ExecQuery("Select * from AntiVirusProduct")
    If obj.InstanceGuid = WScript.Arguments.Item(0) Then obj.Delete_
Next

For Each obj in oWMI2.ExecQuery("Select * from AntiSpywareProduct")
    If obj.InstanceGuid = WScript.Arguments.Item(0) Then obj.Delete_
Next

For Each obj in oWMI2.ExecQuery("Select * from FirewallProduct")
    If obj.InstanceGuid = WScript.Arguments.Item(0) Then obj.Delete_
Next
