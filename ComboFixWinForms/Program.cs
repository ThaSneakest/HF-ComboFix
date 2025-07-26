using System;
using System.Threading.Tasks;
using ComboFixWinForms.Demo;

namespace ComboFixWinForms
{
    internal static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static async Task Main(string[] args)
        {
            // For this demo, we'll run the console demo
            // On Windows with WinForms support, this would show the GUI
            Console.WriteLine("ComboFix C# WinForms Conversion");
            Console.WriteLine("Running in console demo mode...");
            Console.WriteLine();
            
            await ComboFixConsoleDemo.RunDemo();
        }

        private static bool IsRunningAsAdministrator()
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
    }
}
