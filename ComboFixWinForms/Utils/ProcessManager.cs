using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Management;

namespace ComboFixWinForms.Utils
{
    public class ProcessManager
    {
        public List<string> FindSuspiciousProcesses()
        {
            var suspiciousProcesses = new List<string>();
            
            try
            {
                var processes = Process.GetProcesses();
                
                foreach (var process in processes)
                {
                    try
                    {
                        if (IsSuspiciousProcess(process))
                        {
                            suspiciousProcesses.Add($"{process.ProcessName} (PID: {process.Id})");
                        }
                    }
                    catch
                    {
                        // Ignore access denied errors
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error scanning processes: {ex.Message}");
            }
            
            return suspiciousProcesses;
        }
        
        private bool IsSuspiciousProcess(Process process)
        {
            // Simple heuristics for suspicious processes
            var suspiciousNames = new[]
            {
                "temp", "tmp", "virus", "malware", "trojan", "keylog", "backdoor",
                "miner", "bitcoin", "crypto", "bot", "rat", "hack"
            };
            
            var processName = process.ProcessName.ToLower();
            
            // Check for suspicious names
            if (suspiciousNames.Any(name => processName.Contains(name)))
            {
                return true;
            }
            
            // Check for processes running from temp directories
            try
            {
                var filename = process.MainModule?.FileName?.ToLower();
                if (!string.IsNullOrEmpty(filename))
                {
                    var tempPaths = new[] { "temp", "tmp", "appdata\\local\\temp" };
                    if (tempPaths.Any(path => filename.Contains(path)))
                    {
                        return true;
                    }
                }
            }
            catch
            {
                // Ignore access denied errors
            }
            
            return false;
        }
        
        public void KillProcess(string processName)
        {
            try
            {
                var processes = Process.GetProcessesByName(processName);
                foreach (var process in processes)
                {
                    try
                    {
                        process.Kill();
                        process.WaitForExit(5000);
                    }
                    catch
                    {
                        // Ignore errors if process cannot be killed
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error killing process {processName}: {ex.Message}");
            }
        }
        
        public List<string> GetRunningServices()
        {
            var services = new List<string>();
            
            try
            {
                using var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_Service WHERE State = 'Running'");
                using var results = searcher.Get();
                
                foreach (ManagementObject service in results)
                {
                    var serviceName = service["Name"]?.ToString();
                    var displayName = service["DisplayName"]?.ToString();
                    
                    if (!string.IsNullOrEmpty(serviceName))
                    {
                        services.Add($"{serviceName} - {displayName}");
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting services: {ex.Message}");
            }
            
            return services;
        }
    }
}