

On Error Resume Next

Const ForAppending = 2
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile("OsId.txt", ForAppending, True)

for each os in GetObject("winmgmts:").InstancesOf ("Win32_OperatingSystem")
    objLogFile.Write(os.Caption _
	& "  " & os.Version _
	& "." & os.ServicePackMajorVersion _
	& "." & os.CodeSet _
	& "." & os.CountryCode _
	&  "." & os.OSLanguage _
	&  "." & os.OSType _
	& "." & Round(os.TotalVisibleMemorySize/1024 ,0) _
	&  "."  & Round(os.FreePhysicalMemory/1024 ,0) _
	&  " [GMT " & os.CurrentTimeZone/60 & ":" & right("00" & os.CurrentTimeZone mod 60, 2) & "]")
  objLogFile.writeline
Next
objLogFile.Close

Set objLogFile = objFSO.OpenTextFile("RcVer00", ForAppending, True)

for each os in GetObject("winmgmts:").InstancesOf ("Win32_OperatingSystem")
    objLogFile.Write(os.SuiteMask &vbtab & os.ServicePackMajorVersion )
  objLogFile.writeline
Next
objLogFile.Close

