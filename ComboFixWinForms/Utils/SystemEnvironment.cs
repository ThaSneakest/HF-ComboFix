using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace ComboFixWinForms.Utils
{
    public class SystemEnvironment
    {
        public string SystemDrive { get; private set; }
        public string SystemRoot { get; private set; }
        public string System32Path { get; private set; }
        public string TempPath { get; private set; }
        public string ProgramFilesPath { get; private set; }
        public string UserProfilePath { get; private set; }
        public bool IsWindows64Bit { get; private set; }
        public string WindowsVersion { get; private set; }
        
        public Dictionary<string, string> EnvironmentVariables { get; private set; }
        
        public SystemEnvironment()
        {
            EnvironmentVariables = new Dictionary<string, string>();
        }
        
        public async Task InitializeAsync(CancellationToken cancellationToken)
        {
            await Task.Run(() =>
            {
                SetupSystemPaths();
                DetectWindowsVersion();
                SetupEnvironmentVariables();
                CreateWorkingDirectories();
            }, cancellationToken);
        }
        
        private void SetupSystemPaths()
        {
            SystemDrive = Environment.GetEnvironmentVariable("SystemDrive") ?? "C:";
            SystemRoot = Environment.GetFolderPath(Environment.SpecialFolder.Windows);
            System32Path = Environment.GetFolderPath(Environment.SpecialFolder.System);
            TempPath = Path.GetTempPath();
            ProgramFilesPath = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles);
            UserProfilePath = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
            
            IsWindows64Bit = Environment.Is64BitOperatingSystem;
        }
        
        private void DetectWindowsVersion()
        {
            try
            {
                var osVersion = Environment.OSVersion;
                WindowsVersion = $"{osVersion.Version.Major}.{osVersion.Version.Minor}";
                
                // Map to friendly names
                switch (WindowsVersion)
                {
                    case "10.0":
                        WindowsVersion = "Windows 10/11";
                        break;
                    case "6.3":
                        WindowsVersion = "Windows 8.1";
                        break;
                    case "6.2":
                        WindowsVersion = "Windows 8";
                        break;
                    case "6.1":
                        WindowsVersion = "Windows 7";
                        break;
                    case "6.0":
                        WindowsVersion = "Windows Vista";
                        break;
                    case "5.1":
                        WindowsVersion = "Windows XP";
                        break;
                    default:
                        WindowsVersion = $"Windows {osVersion.Version}";
                        break;
                }
            }
            catch
            {
                WindowsVersion = "Unknown";
            }
        }
        
        private void SetupEnvironmentVariables()
        {
            // Core system paths
            EnvironmentVariables["SystemDrive"] = SystemDrive;
            EnvironmentVariables["SystemRoot"] = SystemRoot;
            EnvironmentVariables["System"] = System32Path;
            EnvironmentVariables["SysDir"] = System32Path;
            EnvironmentVariables["Temp"] = TempPath;
            EnvironmentVariables["TMP"] = TempPath;
            EnvironmentVariables["ProgramFiles"] = ProgramFilesPath;
            EnvironmentVariables["UserProfile"] = UserProfilePath;
            
            // Special folder paths
            EnvironmentVariables["Desktop"] = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
            EnvironmentVariables["StartMenu"] = Environment.GetFolderPath(Environment.SpecialFolder.StartMenu);
            EnvironmentVariables["StartUp"] = Environment.GetFolderPath(Environment.SpecialFolder.Startup);
            EnvironmentVariables["AppData"] = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
            EnvironmentVariables["LocalAppData"] = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            EnvironmentVariables["CommonAppData"] = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData);
            EnvironmentVariables["CommonStartup"] = Environment.GetFolderPath(Environment.SpecialFolder.CommonStartup);
            EnvironmentVariables["CommonPrograms"] = Environment.GetFolderPath(Environment.SpecialFolder.CommonPrograms);
            EnvironmentVariables["Personal"] = Environment.GetFolderPath(Environment.SpecialFolder.Personal);
            EnvironmentVariables["Favorites"] = Environment.GetFolderPath(Environment.SpecialFolder.Favorites);
            
            // ComboFix specific paths
            var comboFixPath = AppDomain.CurrentDomain.BaseDirectory;
            EnvironmentVariables["ComboFixHome"] = comboFixPath;
            EnvironmentVariables["QooBox"] = Path.Combine(SystemDrive, "QooBox");
            EnvironmentVariables["Quarantine"] = Path.Combine(SystemDrive, "QooBox", "Quarantine");
            
            // 64-bit specific paths
            if (IsWindows64Bit)
            {
                EnvironmentVariables["SysNative"] = Path.Combine(SystemRoot, "SysNative");
                EnvironmentVariables["ProgramFiles_x86"] = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86);
                EnvironmentVariables["System_x64"] = System32Path;
                EnvironmentVariables["System_x86"] = Path.Combine(SystemRoot, "SysWow64");
            }
        }
        
        private void CreateWorkingDirectories()
        {
            var workingDirs = new[]
            {
                Path.Combine(SystemDrive, "QooBox"),
                Path.Combine(SystemDrive, "QooBox", "Quarantine"),
                Path.Combine(SystemDrive, "QooBox", "BackEnv"),
                Path.Combine(SystemDrive, "QooBox", "LastRun")
            };
            
            foreach (var dir in workingDirs)
            {
                try
                {
                    if (!Directory.Exists(dir))
                    {
                        Directory.CreateDirectory(dir);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error creating directory {dir}: {ex.Message}");
                }
            }
        }
        
        public string ExpandEnvironmentVariables(string input)
        {
            if (string.IsNullOrEmpty(input))
                return input;
                
            var result = input;
            
            foreach (var kvp in EnvironmentVariables)
            {
                var variable = $"%{kvp.Key}%";
                result = result.Replace(variable, kvp.Value, StringComparison.OrdinalIgnoreCase);
            }
            
            // Also expand standard environment variables
            result = Environment.ExpandEnvironmentVariables(result);
            
            return result;
        }
        
        public bool IsProcessRunningElevated()
        {
            try
            {
                var identity = System.Security.Principal.WindowsIdentity.GetCurrent();
                var principal = new System.Security.Principal.WindowsPrincipal(identity);
                return principal.IsInRole(System.Security.Principal.WindowsBuiltInRole.Administrator);
            }
            catch
            {
                return false;
            }
        }
        
        public void SetEnvironmentVariable(string name, string value)
        {
            EnvironmentVariables[name] = value;
        }
        
        public string GetEnvironmentVariable(string name)
        {
            if (EnvironmentVariables.TryGetValue(name, out var value))
            {
                return value;
            }
            
            return Environment.GetEnvironmentVariable(name) ?? string.Empty;
        }
        
        public List<string> GetSystemInformation()
        {
            var info = new List<string>
            {
                $"Computer Name: {Environment.MachineName}",
                $"User Name: {Environment.UserName}",
                $"Domain: {Environment.UserDomainName}",
                $"Operating System: {WindowsVersion}",
                $"Architecture: {(IsWindows64Bit ? "64-bit" : "32-bit")}",
                $"System Drive: {SystemDrive}",
                $"System Root: {SystemRoot}",
                $"Processor Count: {Environment.ProcessorCount}",
                $"Working Set: {Environment.WorkingSet / (1024 * 1024)} MB",
                $"CLR Version: {Environment.Version}",
                $"System Uptime: {TimeSpan.FromMilliseconds(Environment.TickCount):d\\.hh\\:mm\\:ss}"
            };
            
            return info;
        }
        
        public void CleanupWorkingDirectories()
        {
            try
            {
                var tempFiles = Directory.GetFiles(TempPath, "ComboFix_*", SearchOption.TopDirectoryOnly);
                foreach (var file in tempFiles)
                {
                    try
                    {
                        File.Delete(file);
                    }
                    catch
                    {
                        // Ignore errors
                    }
                }
            }
            catch
            {
                // Ignore errors
            }
        }
    }
}