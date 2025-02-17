
On Error Resume Next

objStartFolder = WScript.Arguments.Item(0)

Set Shell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile("StartupFolder00", 2, True)
Set objLogFileOrph = objFSO.OpenTextFile("StartupOrphans.txt", 8, True)
Set objFolder = objFSO.GetFolder(objStartFolder)
Set colFiles = objFolder.Files

EnumStartup
objLogFile.Write vbCrLf & vbCrLf
objLogFile.Close
Wscript.Quit


Sub EnumStartup
   objLogFile.Write vbCrLf & objFolder.Path & "\" & vbCrLf
   For Each File In objFolder.Files
      Ext = objFSO.GetExtensionName(File)
      Name = objFSO.GetFileName(File)
         If LCase(Ext) = "lnk" Then
            StrA = ""
            Target = Shell.CreateShortcut(File).targetpath
            Args = Shell.CreateShortcut(File).Arguments
            If Args <> "" Then 
               Target_ = Target & " " & Args
            Else Target_ = Target
            End If
            
            If objFSO.FileExists(Target) Then
               Set FileB = objFSO.GetFile(Target)
               StrA = " [" & DatePart("yyyy", FileB.datecreated) _
                  & "-" & DatePart("m", FileB.datecreated) _
                  & "-" & DatePart("d", FileB.datecreated) _
                  & " " & FileB.size & "]"
               objLogFile.Write File.Name & " - " & Target_ & StrA & vbCrLf
            ElseIf objFSO.FolderExists(Target) Then
               Set FolderB = objFSO.GetFolder(Target)
               StrA = " [" & DatePart("yyyy", FolderB.datecreated) _
                  & "-" & DatePart("m", FolderB.datecreated) _
                  & "-" & DatePart("d", FolderB.datecreated) _
                  & "] [Folder]"
               objLogFile.Write File.Name & " - " & Target_ & StrA & vbCrLf
            Else 
               objLogFileOrph.Write objFolder.Path & "\" & File.Name & vbTab & Target_ & vbCrLf
            End If
         ElseIf LCase(Name) <> "desktop.ini" Then
            objLogFile.Write( File.Name _
            & " [" & DatePart("yyyy", File.DateLastModified) _
            & "-" & DatePart("m", File.DateLastModified) _
            & "-" & DatePart("d", File.DateLastModified) _
            & " " & File.Size & "]" _
            & vbCrLf ) 
         End If
   Next
ShowSubFolders
End Sub

Sub ShowSubFolders
   For each Subfolder in objFolder.SubFolders
      Set objFolder = objFSO.GetFolder(Subfolder.Path)
      EnumStartup
      ShowSubFolders Subfolder
   Next
End Sub



