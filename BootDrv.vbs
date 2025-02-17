
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile("BootDrive.dat", 2, True)

Set a = GetObject ("winmgmts:{impersonationLevel=Impersonate}!//" & "." )
Set b = a.ExecQuery ("SELECT Caption, DeviceID FROM Win32_DiskDrive")
 
For Each c In b
    strEscapedDeviceID = Replace(c.DeviceID, "\", "\\", 1, -1, vbTextCompare)
    Set d = a.ExecQuery  ("ASSOCIATORS OF {Win32_DiskDrive.DeviceID=""" & strEscapedDeviceID & """} WHERE " & "AssocClass = Win32_DiskDriveToDiskPartition")
 
    For Each e In d
        Set f = a.ExecQuery ("ASSOCIATORS OF {Win32_DiskPartition.DeviceID=""" & e.DeviceID & """} WHERE " & "AssocClass = Win32_LogicalDiskToPartition")
 
         For Each g In f
	If e.Bootable = "True" Then objLogFile.Write (c.DeviceID & vbTab _
	    & g.DeviceID _
	    & vbCrLf )
        Next
    Next
Next

