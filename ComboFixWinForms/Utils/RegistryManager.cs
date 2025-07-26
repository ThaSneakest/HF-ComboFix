using System;
using System.Collections.Generic;
using Microsoft.Win32;

namespace ComboFixWinForms.Utils
{
    public class RegistryManager
    {
        public List<string> GetAutostartEntries()
        {
            var autostartEntries = new List<string>();
            
            var runKeys = new[]
            {
                @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
                @"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
                @"SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run",
                @"SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce"
            };
            
            // Check HKEY_LOCAL_MACHINE
            foreach (var keyPath in runKeys)
            {
                try
                {
                    using var key = Registry.LocalMachine.OpenSubKey(keyPath);
                    if (key != null)
                    {
                        foreach (var valueName in key.GetValueNames())
                        {
                            var value = key.GetValue(valueName)?.ToString();
                            if (!string.IsNullOrEmpty(value))
                            {
                                autostartEntries.Add($"HKLM\\{keyPath}\\{valueName} = {value}");
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error reading registry key {keyPath}: {ex.Message}");
                }
            }
            
            // Check HKEY_CURRENT_USER
            foreach (var keyPath in runKeys)
            {
                try
                {
                    using var key = Registry.CurrentUser.OpenSubKey(keyPath);
                    if (key != null)
                    {
                        foreach (var valueName in key.GetValueNames())
                        {
                            var value = key.GetValue(valueName)?.ToString();
                            if (!string.IsNullOrEmpty(value))
                            {
                                autostartEntries.Add($"HKCU\\{keyPath}\\{valueName} = {value}");
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error reading registry key {keyPath}: {ex.Message}");
                }
            }
            
            return autostartEntries;
        }
        
        public List<string> FindMalwareEntries()
        {
            var malwareEntries = new List<string>();
            
            // Common malware registry locations
            var malwareKeys = new[]
            {
                @"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run",
                @"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit",
                @"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell",
                @"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options",
                @"SOFTWARE\Classes\exefile\shell\open\command",
                @"SOFTWARE\Classes\txtfile\shell\open\command"
            };
            
            foreach (var keyPath in malwareKeys)
            {
                try
                {
                    using var key = Registry.LocalMachine.OpenSubKey(keyPath);
                    if (key != null)
                    {
                        foreach (var valueName in key.GetValueNames())
                        {
                            var value = key.GetValue(valueName)?.ToString();
                            if (!string.IsNullOrEmpty(value) && IsSuspiciousRegistryValue(value))
                            {
                                malwareEntries.Add($"HKLM\\{keyPath}\\{valueName} = {value}");
                            }
                        }
                        
                        // Check subkeys for Image File Execution Options
                        if (keyPath.Contains("Image File Execution Options"))
                        {
                            foreach (var subKeyName in key.GetSubKeyNames())
                            {
                                try
                                {
                                    using var subKey = key.OpenSubKey(subKeyName);
                                    if (subKey != null)
                                    {
                                        var debugger = subKey.GetValue("Debugger")?.ToString();
                                        if (!string.IsNullOrEmpty(debugger))
                                        {
                                            malwareEntries.Add($"HKLM\\{keyPath}\\{subKeyName}\\Debugger = {debugger}");
                                        }
                                    }
                                }
                                catch
                                {
                                    // Ignore access errors
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error reading registry key {keyPath}: {ex.Message}");
                }
            }
            
            return malwareEntries;
        }
        
        private bool IsSuspiciousRegistryValue(string value)
        {
            if (string.IsNullOrEmpty(value))
                return false;
                
            var lowerValue = value.ToLower();
            
            // Check for suspicious patterns
            var suspiciousPatterns = new[]
            {
                "temp\\", "tmp\\", "%temp%", "%tmp%",
                "rundll32", "regsvr32", "mshta", "powershell",
                "cmd.exe /c", "wscript", "cscript",
                "appdata\\local\\temp", "documents and settings",
                ".bat", ".cmd", ".vbs", ".js", ".jse", ".wsf"
            };
            
            foreach (var pattern in suspiciousPatterns)
            {
                if (lowerValue.Contains(pattern))
                {
                    return true;
                }
            }
            
            // Check for multiple executables in one value
            if (lowerValue.Split(new[] { ".exe" }, StringSplitOptions.None).Length > 2)
            {
                return true;
            }
            
            return false;
        }
        
        public void DeleteRegistryValue(string keyPath, string valueName, bool isHKLM = true)
        {
            try
            {
                var rootKey = isHKLM ? Registry.LocalMachine : Registry.CurrentUser;
                using var key = rootKey.OpenSubKey(keyPath, true);
                if (key != null)
                {
                    key.DeleteValue(valueName, false);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting registry value {keyPath}\\{valueName}: {ex.Message}");
            }
        }
        
        public void DeleteRegistryKey(string keyPath, bool isHKLM = true)
        {
            try
            {
                var rootKey = isHKLM ? Registry.LocalMachine : Registry.CurrentUser;
                rootKey.DeleteSubKeyTree(keyPath, false);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting registry key {keyPath}: {ex.Message}");
            }
        }
        
        public void BackupRegistry(string backupPath)
        {
            try
            {
                // In a real implementation, this would create a registry backup
                // For now, we'll just log the operation
                System.Diagnostics.Debug.WriteLine($"Registry backup would be created at: {backupPath}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error backing up registry: {ex.Message}");
            }
        }
    }
}