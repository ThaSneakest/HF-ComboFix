using System;
using System.Threading.Tasks;
using ComboFixWinForms.Demo;

namespace ComboFixWinForms
{
    internal static class ProgramConsole
    {
        /// <summary>
        /// Console demo entry point for the ComboFix C# conversion
        /// </summary>
        [STAThread]
        static async Task Main(string[] args)
        {
            Console.WriteLine("ComboFix C# WinForms Conversion");
            Console.WriteLine("Running in console demo mode...");
            Console.WriteLine();
            
            await ComboFixConsoleDemo.RunDemo();
        }
    }
}