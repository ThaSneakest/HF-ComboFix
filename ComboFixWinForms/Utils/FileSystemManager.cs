using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace ComboFixWinForms.Utils
{
    public class FileSystemManager
    {
        public List<string> FindSuspiciousFiles()
        {
            var suspiciousFiles = new List<string>();
            
            var scanPaths = new[]
            {
                Environment.GetFolderPath(Environment.SpecialFolder.Windows),
                Environment.GetFolderPath(Environment.SpecialFolder.System),
                Environment.GetFolderPath(Environment.SpecialFolder.CommonStartup),
                Environment.GetFolderPath(Environment.SpecialFolder.Startup),
                Path.GetTempPath(),
                Environment.GetFolderPath(Environment.SpecialFolder.InternetCache)
            };
            
            foreach (var path in scanPaths)
            {
                if (Directory.Exists(path))
                {
                    try
                    {
                        var files = Directory.GetFiles(path, "*", SearchOption.TopDirectoryOnly)
                            .Where(IsSuspiciousFile)
                            .ToList();
                            
                        suspiciousFiles.AddRange(files);
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"Error scanning directory {path}: {ex.Message}");
                    }
                }
            }
            
            return suspiciousFiles;
        }
        
        private bool IsSuspiciousFile(string filePath)
        {
            try
            {
                var fileName = Path.GetFileName(filePath).ToLower();
                var fileExtension = Path.GetExtension(filePath).ToLower();
                
                // Check for suspicious file names
                var suspiciousNames = new[]
                {
                    "virus", "malware", "trojan", "keylog", "backdoor",
                    "miner", "bitcoin", "crypto", "bot", "rat", "hack",
                    "temp", "tmp", "download", "update"
                };
                
                if (suspiciousNames.Any(name => fileName.Contains(name)))
                {
                    return true;
                }
                
                // Check for suspicious extensions
                var suspiciousExtensions = new[]
                {
                    ".exe", ".scr", ".bat", ".cmd", ".com", ".pif",
                    ".vbs", ".vbe", ".js", ".jse", ".wsf", ".wsh"
                };
                
                if (suspiciousExtensions.Contains(fileExtension))
                {
                    var fileInfo = new FileInfo(filePath);
                    
                    // Check file size (very small or very large files can be suspicious)
                    if (fileInfo.Length < 1024 || fileInfo.Length > 50 * 1024 * 1024)
                    {
                        return true;
                    }
                    
                    // Check creation time (recently created files in system directories)
                    if (fileInfo.CreationTime > DateTime.Now.AddDays(-7) && 
                        filePath.ToLower().Contains("system"))
                    {
                        return true;
                    }
                }
                
                // Check for files with suspicious attributes
                if (File.GetAttributes(filePath).HasFlag(FileAttributes.Hidden) &&
                    File.GetAttributes(filePath).HasFlag(FileAttributes.System))
                {
                    return true;
                }
            }
            catch
            {
                // Ignore access errors
            }
            
            return false;
        }
        
        public void QuarantineFile(string filePath, string quarantinePath)
        {
            try
            {
                if (!Directory.Exists(quarantinePath))
                {
                    Directory.CreateDirectory(quarantinePath);
                }
                
                var fileName = Path.GetFileName(filePath);
                var quarantineFilePath = Path.Combine(quarantinePath, $"{fileName}.quarantine");
                
                // Move file to quarantine
                File.Move(filePath, quarantineFilePath);
                
                // Set attributes to hidden
                File.SetAttributes(quarantineFilePath, FileAttributes.Hidden);
                
                System.Diagnostics.Debug.WriteLine($"File quarantined: {filePath} -> {quarantineFilePath}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error quarantining file {filePath}: {ex.Message}");
            }
        }
        
        public void DeleteFile(string filePath)
        {
            try
            {
                if (File.Exists(filePath))
                {
                    // Remove read-only attribute if set
                    File.SetAttributes(filePath, FileAttributes.Normal);
                    File.Delete(filePath);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting file {filePath}: {ex.Message}");
            }
        }
        
        public void DeleteDirectory(string directoryPath)
        {
            try
            {
                if (Directory.Exists(directoryPath))
                {
                    // Remove attributes from all files in directory
                    var files = Directory.GetFiles(directoryPath, "*", SearchOption.AllDirectories);
                    foreach (var file in files)
                    {
                        try
                        {
                            File.SetAttributes(file, FileAttributes.Normal);
                        }
                        catch
                        {
                            // Ignore errors
                        }
                    }
                    
                    Directory.Delete(directoryPath, true);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting directory {directoryPath}: {ex.Message}");
            }
        }
        
        public List<string> FindTemporaryFiles()
        {
            var temporaryFiles = new List<string>();
            
            var tempPaths = new[]
            {
                Path.GetTempPath(),
                Environment.GetFolderPath(Environment.SpecialFolder.InternetCache),
                Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Windows), "Temp"),
                Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Temp")
            };
            
            foreach (var tempPath in tempPaths)
            {
                if (Directory.Exists(tempPath))
                {
                    try
                    {
                        var files = Directory.GetFiles(tempPath, "*", SearchOption.AllDirectories);
                        temporaryFiles.AddRange(files);
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"Error scanning temp directory {tempPath}: {ex.Message}");
                    }
                }
            }
            
            return temporaryFiles;
        }
        
        public void CleanTemporaryFiles()
        {
            var tempFiles = FindTemporaryFiles();
            var deletedCount = 0;
            
            foreach (var file in tempFiles)
            {
                try
                {
                    var fileInfo = new FileInfo(file);
                    
                    // Skip files that are currently in use or too recent
                    if (fileInfo.LastAccessTime < DateTime.Now.AddHours(-1))
                    {
                        DeleteFile(file);
                        deletedCount++;
                    }
                }
                catch
                {
                    // Ignore errors (file may be in use)
                }
            }
            
            System.Diagnostics.Debug.WriteLine($"Cleaned {deletedCount} temporary files");
        }
        
        public long GetDirectorySize(string directoryPath)
        {
            try
            {
                if (!Directory.Exists(directoryPath))
                    return 0;
                    
                var files = Directory.GetFiles(directoryPath, "*", SearchOption.AllDirectories);
                return files.Sum(file => new FileInfo(file).Length);
            }
            catch
            {
                return 0;
            }
        }
        
        public void RestoreFromQuarantine(string quarantineFilePath, string originalPath)
        {
            try
            {
                if (File.Exists(quarantineFilePath))
                {
                    // Remove quarantine attributes
                    File.SetAttributes(quarantineFilePath, FileAttributes.Normal);
                    
                    // Move back to original location
                    File.Move(quarantineFilePath, originalPath);
                    
                    System.Diagnostics.Debug.WriteLine($"File restored: {quarantineFilePath} -> {originalPath}");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error restoring file {quarantineFilePath}: {ex.Message}");
            }
        }
    }
}