function Invoke-TokenManipulation
{


    [CmdletBinding(DefaultParameterSetName="Enumerate")]
    Param(
        [Parameter(ParameterSetName = "Enumerate")]
        [Switch]
        $Enumerate,

        [Parameter(ParameterSetName = "RevToSelf")]
        [Switch]
        $RevToSelf,

        [Parameter(ParameterSetName = "ShowAll")]
        [Switch]
        $ShowAll,

        [Parameter(ParameterSetName = "ImpersonateUser")]
        [Switch]
        $ImpersonateUser,

        [Parameter(ParameterSetName = "CreateProcess")]
        [String]
        $CreateProcess,

        [Parameter(ParameterSetName = "WhoAmI")]
        [Switch]
        $WhoAmI,

        [Parameter(ParameterSetName = "ImpersonateUser")]
        [Parameter(ParameterSetName = "CreateProcess")]
        [String]
        $Username,

        [Parameter(ParameterSetName = "ImpersonateUser")]
        [Parameter(ParameterSetName = "CreateProcess")]
        [Int]
        $ProcessId,

        [Parameter(ParameterSetName = "ImpersonateUser", ValueFromPipeline=$true)]
        [Parameter(ParameterSetName = "CreateProcess", ValueFromPipeline=$true)]
        [System.Diagnostics.Process]
        $Process,

        [Parameter(ParameterSetName = "ImpersonateUser")]
        [Parameter(ParameterSetName = "CreateProcess")]
        $ThreadId,

        [Parameter(ParameterSetName = "CreateProcess")]
        [String]
        $ProcessArgs,

        [Parameter(ParameterSetName = "CreateProcess")]
        [Switch]
        $NoUI,

        [Parameter(ParameterSetName = "CreateProcess")]
        [Switch]
        $PassThru
    )
   
    Set-StrictMode -Version 2

    
    Function Get-DelegateType
    {
        Param
        (
            [OutputType([Type])]
            
            [Parameter( Position = 0)]
            [Type[]]
            $Parameters = (New-Object Type[](0)),
            
            [Parameter( Position = 1 )]
            [Type]
            $ReturnType = [Void]
        )

        $Domain = [AppDomain]::CurrentDomain
        $DynAssembly = New-Object System.Reflection.AssemblyName('ReflectedDelegate')
        $AssemblyBuilder = $Domain.DefineDynamicAssembly($DynAssembly, [System.Reflection.Emit.AssemblyBuilderAccess]::Run)
        $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('InMemoryModule', $false)
        $TypeBuilder = $ModuleBuilder.DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $ConstructorBuilder = $TypeBuilder.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $Parameters)
        $ConstructorBuilder.SetImplementationFlags('Runtime, Managed')
        $MethodBuilder = $TypeBuilder.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $ReturnType, $Parameters)
        $MethodBuilder.SetImplementationFlags('Runtime, Managed')
        
        Write-Output $TypeBuilder.CreateType()
    }


    
    Function Get-ProcAddress
    {
        Param
        (
            [OutputType([IntPtr])]
        
            [Parameter( Position = 0, Mandatory = $True )]
            [String]
            $Module,
            
            [Parameter( Position = 1, Mandatory = $True )]
            [String]
            $Procedure
        )

        
        $SystemAssembly = [AppDomain]::CurrentDomain.GetAssemblies() |
            Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }
        $UnsafeNativeMethods = $SystemAssembly.GetType('Microsoft.Win32.UnsafeNativeMethods')
        
        $GetModuleHandle = $UnsafeNativeMethods.GetMethod('GetModuleHandle')
        $GetProcAddress = $UnsafeNativeMethods.GetMethod('GetProcAddress')
        
        $Kern32Handle = $GetModuleHandle.Invoke($null, @($Module))
        $tmpPtr = New-Object IntPtr
        $HandleRef = New-Object System.Runtime.InteropServices.HandleRef($tmpPtr, $Kern32Handle)

        
        Write-Output $GetProcAddress.Invoke($null, @([System.Runtime.InteropServices.HandleRef]$HandleRef, $Procedure))
    }

    
    
    
    $Constants = @{
        ACCESS_SYSTEM_SECURITY = 0x01000000
        READ_CONTROL = 0x00020000
        SYNCHRONIZE = 0x00100000
        STANDARD_RIGHTS_ALL = 0x001F0000
        TOKEN_QUERY = 8
        TOKEN_ADJUST_PRIVILEGES = 0x20
        ERROR_NO_TOKEN = 0x3f0
        SECURITY_DELEGATION = 3
        DACL_SECURITY_INFORMATION = 0x4
        ACCESS_ALLOWED_ACE_TYPE = 0x0
        STANDARD_RIGHTS_REQUIRED = 0x000F0000
        DESKTOP_GENERIC_ALL = 0x000F01FF
        WRITE_DAC = 0x00040000
        OBJECT_INHERIT_ACE = 0x1
        GRANT_ACCESS = 0x1
        TRUSTEE_IS_NAME = 0x1
        TRUSTEE_IS_SID = 0x0
        TRUSTEE_IS_USER = 0x1
        TRUSTEE_IS_WELL_KNOWN_GROUP = 0x5
        TRUSTEE_IS_GROUP = 0x2
        PROCESS_QUERY_INFORMATION = 0x400
        TOKEN_ASSIGN_PRIMARY = 0x1
        TOKEN_DUPLICATE = 0x2
        TOKEN_IMPERSONATE = 0x4
        TOKEN_QUERY_SOURCE = 0x10
        STANDARD_RIGHTS_READ = 0x20000
        TokenStatistics = 10
        TOKEN_ALL_ACCESS = 0xf01ff
        MAXIMUM_ALLOWED = 0x02000000
        THREAD_ALL_ACCESS = 0x1f03ff
        ERROR_INVALID_PARAMETER = 0x57
        LOGON_NETCREDENTIALS_ONLY = 0x2
        SE_PRIVILEGE_ENABLED = 0x2
        SE_PRIVILEGE_ENABLED_BY_DEFAULT = 0x1
        SE_PRIVILEGE_REMOVED = 0x4
    }

    $Win32Constants = New-Object PSObject -Property $Constants
    


    
    
    
    
    
    $Domain = [AppDomain]::CurrentDomain
    $DynamicAssembly = New-Object System.Reflection.AssemblyName('DynamicAssembly')
    $AssemblyBuilder = $Domain.DefineDynamicAssembly($DynamicAssembly, [System.Reflection.Emit.AssemblyBuilderAccess]::Run)
    $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('DynamicModule', $false)
    $ConstructorInfo = [System.Runtime.InteropServices.MarshalAsAttribute].GetConstructors()[0]

    
    $TypeBuilder = $ModuleBuilder.DefineEnum('TOKEN_INFORMATION_CLASS', 'Public', [UInt32])
    $TypeBuilder.DefineLiteral('TokenUser', [UInt32] 1) | Out-Null
    $TypeBuilder.DefineLiteral('TokenGroups', [UInt32] 2) | Out-Null
    $TypeBuilder.DefineLiteral('TokenPrivileges', [UInt32] 3) | Out-Null
    $TypeBuilder.DefineLiteral('TokenOwner', [UInt32] 4) | Out-Null
    $TypeBuilder.DefineLiteral('TokenPrimaryGroup', [UInt32] 5) | Out-Null
    $TypeBuilder.DefineLiteral('TokenDefaultDacl', [UInt32] 6) | Out-Null
    $TypeBuilder.DefineLiteral('TokenSource', [UInt32] 7) | Out-Null
    $TypeBuilder.DefineLiteral('TokenType', [UInt32] 8) | Out-Null
    $TypeBuilder.DefineLiteral('TokenImpersonationLevel', [UInt32] 9) | Out-Null
    $TypeBuilder.DefineLiteral('TokenStatistics', [UInt32] 10) | Out-Null
    $TypeBuilder.DefineLiteral('TokenRestrictedSids', [UInt32] 11) | Out-Null
    $TypeBuilder.DefineLiteral('TokenSessionId', [UInt32] 12) | Out-Null
    $TypeBuilder.DefineLiteral('TokenGroupsAndPrivileges', [UInt32] 13) | Out-Null
    $TypeBuilder.DefineLiteral('TokenSessionReference', [UInt32] 14) | Out-Null
    $TypeBuilder.DefineLiteral('TokenSandBoxInert', [UInt32] 15) | Out-Null
    $TypeBuilder.DefineLiteral('TokenAuditPolicy', [UInt32] 16) | Out-Null
    $TypeBuilder.DefineLiteral('TokenOrigin', [UInt32] 17) | Out-Null
    $TypeBuilder.DefineLiteral('TokenElevationType', [UInt32] 18) | Out-Null
    $TypeBuilder.DefineLiteral('TokenLinkedToken', [UInt32] 19) | Out-Null
    $TypeBuilder.DefineLiteral('TokenElevation', [UInt32] 20) | Out-Null
    $TypeBuilder.DefineLiteral('TokenHasRestrictions', [UInt32] 21) | Out-Null
    $TypeBuilder.DefineLiteral('TokenAccessInformation', [UInt32] 22) | Out-Null
    $TypeBuilder.DefineLiteral('TokenVirtualizationAllowed', [UInt32] 23) | Out-Null
    $TypeBuilder.DefineLiteral('TokenVirtualizationEnabled', [UInt32] 24) | Out-Null
    $TypeBuilder.DefineLiteral('TokenIntegrityLevel', [UInt32] 25) | Out-Null
    $TypeBuilder.DefineLiteral('TokenUIAccess', [UInt32] 26) | Out-Null
    $TypeBuilder.DefineLiteral('TokenMandatoryPolicy', [UInt32] 27) | Out-Null
    $TypeBuilder.DefineLiteral('TokenLogonSid', [UInt32] 28) | Out-Null
    $TypeBuilder.DefineLiteral('TokenIsAppContainer', [UInt32] 29) | Out-Null
    $TypeBuilder.DefineLiteral('TokenCapabilities', [UInt32] 30) | Out-Null
    $TypeBuilder.DefineLiteral('TokenAppContainerSid', [UInt32] 31) | Out-Null
    $TypeBuilder.DefineLiteral('TokenAppContainerNumber', [UInt32] 32) | Out-Null
    $TypeBuilder.DefineLiteral('TokenUserClaimAttributes', [UInt32] 33) | Out-Null
    $TypeBuilder.DefineLiteral('TokenDeviceClaimAttributes', [UInt32] 34) | Out-Null
    $TypeBuilder.DefineLiteral('TokenRestrictedUserClaimAttributes', [UInt32] 35) | Out-Null
    $TypeBuilder.DefineLiteral('TokenRestrictedDeviceClaimAttributes', [UInt32] 36) | Out-Null
    $TypeBuilder.DefineLiteral('TokenDeviceGroups', [UInt32] 37) | Out-Null
    $TypeBuilder.DefineLiteral('TokenRestrictedDeviceGroups', [UInt32] 38) | Out-Null
    $TypeBuilder.DefineLiteral('TokenSecurityAttributes', [UInt32] 39) | Out-Null
    $TypeBuilder.DefineLiteral('TokenIsRestricted', [UInt32] 40) | Out-Null
    $TypeBuilder.DefineLiteral('MaxTokenInfoClass', [UInt32] 41) | Out-Null
    $TOKEN_INFORMATION_CLASS = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('LARGE_INTEGER', $Attributes, [System.ValueType], 8)
    $TypeBuilder.DefineField('LowPart', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('HighPart', [UInt32], 'Public') | Out-Null
    $LARGE_INTEGER = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('LUID', $Attributes, [System.ValueType], 8)
    $TypeBuilder.DefineField('LowPart', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('HighPart', [Int32], 'Public') | Out-Null
    $LUID = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('TOKEN_STATISTICS', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('TokenId', $LUID, 'Public') | Out-Null
    $TypeBuilder.DefineField('AuthenticationId', $LUID, 'Public') | Out-Null
    $TypeBuilder.DefineField('ExpirationTime', $LARGE_INTEGER, 'Public') | Out-Null
    $TypeBuilder.DefineField('TokenType', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('ImpersonationLevel', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('DynamicCharged', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('DynamicAvailable', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('GroupCount', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('PrivilegeCount', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('ModifiedId', $LUID, 'Public') | Out-Null
    $TOKEN_STATISTICS = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('LSA_UNICODE_STRING', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('Length', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('MaximumLength', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('Buffer', [IntPtr], 'Public') | Out-Null
    $LSA_UNICODE_STRING = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('LSA_LAST_INTER_LOGON_INFO', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('LastSuccessfulLogon', $LARGE_INTEGER, 'Public') | Out-Null
    $TypeBuilder.DefineField('LastFailedLogon', $LARGE_INTEGER, 'Public') | Out-Null
    $TypeBuilder.DefineField('FailedAttemptCountSinceLastSuccessfulLogon', [UInt32], 'Public') | Out-Null
    $LSA_LAST_INTER_LOGON_INFO = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('SECURITY_LOGON_SESSION_DATA', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('Size', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('LoginID', $LUID, 'Public') | Out-Null
    $TypeBuilder.DefineField('Username', $LSA_UNICODE_STRING, 'Public') | Out-Null
    $TypeBuilder.DefineField('LoginDomain', $LSA_UNICODE_STRING, 'Public') | Out-Null
    $TypeBuilder.DefineField('AuthenticationPackage', $LSA_UNICODE_STRING, 'Public') | Out-Null
    $TypeBuilder.DefineField('LogonType', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('Session', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('Sid', [IntPtr], 'Public') | Out-Null
    $TypeBuilder.DefineField('LoginTime', $LARGE_INTEGER, 'Public') | Out-Null
    $TypeBuilder.DefineField('LoginServer', $LSA_UNICODE_STRING, 'Public') | Out-Null
    $TypeBuilder.DefineField('DnsDomainName', $LSA_UNICODE_STRING, 'Public') | Out-Null
    $TypeBuilder.DefineField('Upn', $LSA_UNICODE_STRING, 'Public') | Out-Null
    $TypeBuilder.DefineField('UserFlags', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('LastLogonInfo', $LSA_LAST_INTER_LOGON_INFO, 'Public') | Out-Null
    $TypeBuilder.DefineField('LogonScript', $LSA_UNICODE_STRING, 'Public') | Out-Null
    $TypeBuilder.DefineField('ProfilePath', $LSA_UNICODE_STRING, 'Public') | Out-Null
    $TypeBuilder.DefineField('HomeDirectory', $LSA_UNICODE_STRING, 'Public') | Out-Null
    $TypeBuilder.DefineField('HomeDirectoryDrive', $LSA_UNICODE_STRING, 'Public') | Out-Null
    $TypeBuilder.DefineField('LogoffTime', $LARGE_INTEGER, 'Public') | Out-Null
    $TypeBuilder.DefineField('KickOffTime', $LARGE_INTEGER, 'Public') | Out-Null
    $TypeBuilder.DefineField('PasswordLastSet', $LARGE_INTEGER, 'Public') | Out-Null
    $TypeBuilder.DefineField('PasswordCanChange', $LARGE_INTEGER, 'Public') | Out-Null
    $TypeBuilder.DefineField('PasswordMustChange', $LARGE_INTEGER, 'Public') | Out-Null
    $SECURITY_LOGON_SESSION_DATA = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('STARTUPINFO', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('cb', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('lpReserved', [IntPtr], 'Public') | Out-Null
    $TypeBuilder.DefineField('lpDesktop', [IntPtr], 'Public') | Out-Null
    $TypeBuilder.DefineField('lpTitle', [IntPtr], 'Public') | Out-Null
    $TypeBuilder.DefineField('dwX', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('dwY', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('dwXSize', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('dwYSize', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('dwXCountChars', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('dwYCountChars', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('dwFillAttribute', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('dwFlags', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('wShowWindow', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('cbReserved2', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('lpReserved2', [IntPtr], 'Public') | Out-Null
    $TypeBuilder.DefineField('hStdInput', [IntPtr], 'Public') | Out-Null
    $TypeBuilder.DefineField('hStdOutput', [IntPtr], 'Public') | Out-Null
    $TypeBuilder.DefineField('hStdError', [IntPtr], 'Public') | Out-Null
    $STARTUPINFO = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('PROCESS_INFORMATION', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('hProcess', [IntPtr], 'Public') | Out-Null
    $TypeBuilder.DefineField('hThread', [IntPtr], 'Public') | Out-Null
    $TypeBuilder.DefineField('dwProcessId', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('dwThreadId', [UInt32], 'Public') | Out-Null
    $PROCESS_INFORMATION = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('TOKEN_ELEVATION', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('TokenIsElevated', [UInt32], 'Public') | Out-Null
    $TOKEN_ELEVATION = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('LUID_AND_ATTRIBUTES', $Attributes, [System.ValueType], 12)
    $TypeBuilder.DefineField('Luid', $LUID, 'Public') | Out-Null
    $TypeBuilder.DefineField('Attributes', [UInt32], 'Public') | Out-Null
    $LUID_AND_ATTRIBUTES = $TypeBuilder.CreateType()
        
    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('TOKEN_PRIVILEGES', $Attributes, [System.ValueType], 16)
    $TypeBuilder.DefineField('PrivilegeCount', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('Privileges', $LUID_AND_ATTRIBUTES, 'Public') | Out-Null
    $TOKEN_PRIVILEGES = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('ACE_HEADER', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('AceType', [Byte], 'Public') | Out-Null
    $TypeBuilder.DefineField('AceFlags', [Byte], 'Public') | Out-Null
    $TypeBuilder.DefineField('AceSize', [UInt16], 'Public') | Out-Null
    $ACE_HEADER = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('ACL', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('AclRevision', [Byte], 'Public') | Out-Null
    $TypeBuilder.DefineField('Sbz1', [Byte], 'Public') | Out-Null
    $TypeBuilder.DefineField('AclSize', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('AceCount', [UInt16], 'Public') | Out-Null
    $TypeBuilder.DefineField('Sbz2', [UInt16], 'Public') | Out-Null
    $ACL = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('ACCESS_ALLOWED_ACE', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('Header', $ACE_HEADER, 'Public') | Out-Null
    $TypeBuilder.DefineField('Mask', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('SidStart', [UInt32], 'Public') | Out-Null
    $ACCESS_ALLOWED_ACE = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('TRUSTEE', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('pMultipleTrustee', [IntPtr], 'Public') | Out-Null
    $TypeBuilder.DefineField('MultipleTrusteeOperation', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('TrusteeForm', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('TrusteeType', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('ptstrName', [IntPtr], 'Public') | Out-Null
    $TRUSTEE = $TypeBuilder.CreateType()

    
    $Attributes = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
    $TypeBuilder = $ModuleBuilder.DefineType('EXPLICIT_ACCESS', $Attributes, [System.ValueType])
    $TypeBuilder.DefineField('grfAccessPermissions', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('grfAccessMode', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('grfInheritance', [UInt32], 'Public') | Out-Null
    $TypeBuilder.DefineField('Trustee', $TRUSTEE, 'Public') | Out-Null
    $EXPLICIT_ACCESS = $TypeBuilder.CreateType()
    


    
    
    
    $OpenProcessAddr = Get-ProcAddress kernel32.dll OpenProcess
    $OpenProcessDelegate = Get-DelegateType @([UInt32], [Bool], [UInt32]) ([IntPtr])
    $OpenProcess = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($OpenProcessAddr, $OpenProcessDelegate)

    $OpenProcessTokenAddr = Get-ProcAddress advapi32.dll OpenProcessToken
    $OpenProcessTokenDelegate = Get-DelegateType @([IntPtr], [UInt32], [IntPtr].MakeByRefType()) ([Bool])
    $OpenProcessToken = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($OpenProcessTokenAddr, $OpenProcessTokenDelegate)    

    $GetTokenInformationAddr = Get-ProcAddress advapi32.dll GetTokenInformation
    $GetTokenInformationDelegate = Get-DelegateType @([IntPtr], $TOKEN_INFORMATION_CLASS, [IntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool])
    $GetTokenInformation = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($GetTokenInformationAddr, $GetTokenInformationDelegate)    

    $SetThreadTokenAddr = Get-ProcAddress advapi32.dll SetThreadToken
    $SetThreadTokenDelegate = Get-DelegateType @([IntPtr], [IntPtr]) ([Bool])
    $SetThreadToken = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($SetThreadTokenAddr, $SetThreadTokenDelegate)    

    $ImpersonateLoggedOnUserAddr = Get-ProcAddress advapi32.dll ImpersonateLoggedOnUser
    $ImpersonateLoggedOnUserDelegate = Get-DelegateType @([IntPtr]) ([Bool])
    $ImpersonateLoggedOnUser = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($ImpersonateLoggedOnUserAddr, $ImpersonateLoggedOnUserDelegate)

    $RevertToSelfAddr = Get-ProcAddress advapi32.dll RevertToSelf
    $RevertToSelfDelegate = Get-DelegateType @() ([Bool])
    $RevertToSelf = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($RevertToSelfAddr, $RevertToSelfDelegate)

    $LsaGetLogonSessionDataAddr = Get-ProcAddress secur32.dll LsaGetLogonSessionData
    $LsaGetLogonSessionDataDelegate = Get-DelegateType @([IntPtr], [IntPtr].MakeByRefType()) ([UInt32])
    $LsaGetLogonSessionData = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($LsaGetLogonSessionDataAddr, $LsaGetLogonSessionDataDelegate)

    $CreateProcessWithTokenWAddr = Get-ProcAddress advapi32.dll CreateProcessWithTokenW
    $CreateProcessWithTokenWDelegate = Get-DelegateType @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr], [IntPtr], [IntPtr], [IntPtr]) ([Bool])
    $CreateProcessWithTokenW = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($CreateProcessWithTokenWAddr, $CreateProcessWithTokenWDelegate)

    $memsetAddr = Get-ProcAddress msvcrt.dll memset
    $memsetDelegate = Get-DelegateType @([IntPtr], [Int32], [IntPtr]) ([IntPtr])
    $memset = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($memsetAddr, $memsetDelegate)

    $DuplicateTokenExAddr = Get-ProcAddress advapi32.dll DuplicateTokenEx
    $DuplicateTokenExDelegate = Get-DelegateType @([IntPtr], [UInt32], [IntPtr], [UInt32], [UInt32], [IntPtr].MakeByRefType()) ([Bool])
    $DuplicateTokenEx = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($DuplicateTokenExAddr, $DuplicateTokenExDelegate)

    $LookupAccountSidWAddr = Get-ProcAddress advapi32.dll LookupAccountSidW
    $LookupAccountSidWDelegate = Get-DelegateType @([IntPtr], [IntPtr], [IntPtr], [UInt32].MakeByRefType(), [IntPtr], [UInt32].MakeByRefType(), [UInt32].MakeByRefType()) ([Bool])
    $LookupAccountSidW = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($LookupAccountSidWAddr, $LookupAccountSidWDelegate)

    $CloseHandleAddr = Get-ProcAddress kernel32.dll CloseHandle
    $CloseHandleDelegate = Get-DelegateType @([IntPtr]) ([Bool])
    $CloseHandle = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($CloseHandleAddr, $CloseHandleDelegate)

    $LsaFreeReturnBufferAddr = Get-ProcAddress secur32.dll LsaFreeReturnBuffer
    $LsaFreeReturnBufferDelegate = Get-DelegateType @([IntPtr]) ([UInt32])
    $LsaFreeReturnBuffer = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($LsaFreeReturnBufferAddr, $LsaFreeReturnBufferDelegate)

    $OpenThreadAddr = Get-ProcAddress kernel32.dll OpenThread
    $OpenThreadDelegate = Get-DelegateType @([UInt32], [Bool], [UInt32]) ([IntPtr])
    $OpenThread = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($OpenThreadAddr, $OpenThreadDelegate)

    $OpenThreadTokenAddr = Get-ProcAddress advapi32.dll OpenThreadToken
    $OpenThreadTokenDelegate = Get-DelegateType @([IntPtr], [UInt32], [Bool], [IntPtr].MakeByRefType()) ([Bool])
    $OpenThreadToken = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($OpenThreadTokenAddr, $OpenThreadTokenDelegate)

    $CreateProcessAsUserWAddr = Get-ProcAddress advapi32.dll CreateProcessAsUserW
    $CreateProcessAsUserWDelegate = Get-DelegateType @([IntPtr], [IntPtr], [IntPtr], [IntPtr], [IntPtr], [Bool], [UInt32], [IntPtr], [IntPtr], [IntPtr], [IntPtr]) ([Bool])
    $CreateProcessAsUserW = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($CreateProcessAsUserWAddr, $CreateProcessAsUserWDelegate)

    $OpenWindowStationWAddr = Get-ProcAddress user32.dll OpenWindowStationW
    $OpenWindowStationWDelegate = Get-DelegateType @([IntPtr], [Bool], [UInt32]) ([IntPtr])
    $OpenWindowStationW = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($OpenWindowStationWAddr, $OpenWindowStationWDelegate)

    $OpenDesktopAAddr = Get-ProcAddress user32.dll OpenDesktopA
    $OpenDesktopADelegate = Get-DelegateType @([String], [UInt32], [Bool], [UInt32]) ([IntPtr])
    $OpenDesktopA = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($OpenDesktopAAddr, $OpenDesktopADelegate)

    $ImpersonateSelfAddr = Get-ProcAddress Advapi32.dll ImpersonateSelf
    $ImpersonateSelfDelegate = Get-DelegateType @([Int32]) ([Bool])
    $ImpersonateSelf = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($ImpersonateSelfAddr, $ImpersonateSelfDelegate)

    $LookupPrivilegeValueAddr = Get-ProcAddress Advapi32.dll LookupPrivilegeValueA
    $LookupPrivilegeValueDelegate = Get-DelegateType @([String], [String], $LUID.MakeByRefType()) ([Bool])
    $LookupPrivilegeValue = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($LookupPrivilegeValueAddr, $LookupPrivilegeValueDelegate)

    $AdjustTokenPrivilegesAddr = Get-ProcAddress Advapi32.dll AdjustTokenPrivileges
    $AdjustTokenPrivilegesDelegate = Get-DelegateType @([IntPtr], [Bool], $TOKEN_PRIVILEGES.MakeByRefType(), [UInt32], [IntPtr], [IntPtr]) ([Bool])
    $AdjustTokenPrivileges = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($AdjustTokenPrivilegesAddr, $AdjustTokenPrivilegesDelegate)

    $GetCurrentThreadAddr = Get-ProcAddress kernel32.dll GetCurrentThread
    $GetCurrentThreadDelegate = Get-DelegateType @() ([IntPtr])
    $GetCurrentThread = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($GetCurrentThreadAddr, $GetCurrentThreadDelegate)

    $GetSecurityInfoAddr = Get-ProcAddress advapi32.dll GetSecurityInfo
    $GetSecurityInfoDelegate = Get-DelegateType @([IntPtr], [UInt32], [UInt32], [IntPtr].MakeByRefType(), [IntPtr].MakeByRefType(), [IntPtr].MakeByRefType(), [IntPtr].MakeByRefType(), [IntPtr].MakeByRefType()) ([UInt32])
    $GetSecurityInfo = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($GetSecurityInfoAddr, $GetSecurityInfoDelegate)

    $SetSecurityInfoAddr = Get-ProcAddress advapi32.dll SetSecurityInfo
    $SetSecurityInfoDelegate = Get-DelegateType @([IntPtr], [UInt32], [UInt32], [IntPtr], [IntPtr], [IntPtr], [IntPtr]) ([UInt32])
    $SetSecurityInfo = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($SetSecurityInfoAddr, $SetSecurityInfoDelegate)

    $GetAceAddr = Get-ProcAddress advapi32.dll GetAce
    $GetAceDelegate = Get-DelegateType @([IntPtr], [UInt32], [IntPtr].MakeByRefType()) ([IntPtr])
    $GetAce = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($GetAceAddr, $GetAceDelegate)

    $LookupAccountSidWAddr = Get-ProcAddress advapi32.dll LookupAccountSidW
    $LookupAccountSidWDelegate = Get-DelegateType @([IntPtr], [IntPtr], [IntPtr], [UInt32].MakeByRefType(), [IntPtr], [UInt32].MakeByRefType(), [UInt32].MakeByRefType()) ([Bool])
    $LookupAccountSidW = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($LookupAccountSidWAddr, $LookupAccountSidWDelegate)

    $AddAccessAllowedAceAddr = Get-ProcAddress advapi32.dll AddAccessAllowedAce
    $AddAccessAllowedAceDelegate = Get-DelegateType @([IntPtr], [UInt32], [UInt32], [IntPtr]) ([Bool])
    $AddAccessAllowedAce = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($AddAccessAllowedAceAddr, $AddAccessAllowedAceDelegate)

    $CreateWellKnownSidAddr = Get-ProcAddress advapi32.dll CreateWellKnownSid
    $CreateWellKnownSidDelegate = Get-DelegateType @([UInt32], [IntPtr], [IntPtr], [UInt32].MakeByRefType()) ([Bool])
    $CreateWellKnownSid = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($CreateWellKnownSidAddr, $CreateWellKnownSidDelegate)

    $SetEntriesInAclWAddr = Get-ProcAddress advapi32.dll SetEntriesInAclW
    $SetEntriesInAclWDelegate = Get-DelegateType @([UInt32], $EXPLICIT_ACCESS.MakeByRefType(), [IntPtr], [IntPtr].MakeByRefType()) ([UInt32])
    $SetEntriesInAclW = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($SetEntriesInAclWAddr, $SetEntriesInAclWDelegate)

    $LocalFreeAddr = Get-ProcAddress kernel32.dll LocalFree
    $LocalFreeDelegate = Get-DelegateType @([IntPtr]) ([IntPtr])
    $LocalFree = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($LocalFreeAddr, $LocalFreeDelegate)

    $LookupPrivilegeNameWAddr = Get-ProcAddress advapi32.dll LookupPrivilegeNameW
    $LookupPrivilegeNameWDelegate = Get-DelegateType @([IntPtr], [IntPtr], [IntPtr], [UInt32].MakeByRefType()) ([Bool])
    $LookupPrivilegeNameW = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($LookupPrivilegeNameWAddr, $LookupPrivilegeNameWDelegate)
    


    
    Function Add-SignedIntAsUnsigned
    {
        Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [Int64]
        $Value1,
        
        [Parameter(Position = 1, Mandatory = $true)]
        [Int64]
        $Value2
        )
        
        [Byte[]]$Value1Bytes = [BitConverter]::GetBytes($Value1)
        [Byte[]]$Value2Bytes = [BitConverter]::GetBytes($Value2)
        [Byte[]]$FinalBytes = [BitConverter]::GetBytes([UInt64]0)

        if ($Value1Bytes.Count -eq $Value2Bytes.Count)
        {
            $CarryOver = 0
            for ($i = 0; $i -lt $Value1Bytes.Count; $i++)
            {
                
                [UInt16]$Sum = $Value1Bytes[$i] + $Value2Bytes[$i] + $CarryOver

                $FinalBytes[$i] = $Sum -band 0x00FF
                
                if (($Sum -band 0xFF00) -eq 0x100)
                {
                    $CarryOver = 1
                }
                else
                {
                    $CarryOver = 0
                }
            }
        }
        else
        {
            Throw "Cannot add bytearrays of different sizes"
        }
        
        return [BitConverter]::ToInt64($FinalBytes, 0)
    }


    
    function Enable-SeAssignPrimaryTokenPrivilege
    {   
        [IntPtr]$ThreadHandle = $GetCurrentThread.Invoke()
        if ($ThreadHandle -eq [IntPtr]::Zero)
        {
            Throw "Unable to get the handle to the current thread"
        }
        
        [IntPtr]$ThreadToken = [IntPtr]::Zero
        [Bool]$Result = $OpenThreadToken.Invoke($ThreadHandle, $Win32Constants.TOKEN_QUERY -bor $Win32Constants.TOKEN_ADJUST_PRIVILEGES, $false, [Ref]$ThreadToken)
        $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()

        if ($Result -eq $false)
        {
            if ($ErrorCode -eq $Win32Constants.ERROR_NO_TOKEN)
            {
                $Result = $ImpersonateSelf.Invoke($Win32Constants.SECURITY_DELEGATION)
                if ($Result -eq $false)
                {
                    Throw (New-Object ComponentModel.Win32Exception)
                }
                
                $Result = $OpenThreadToken.Invoke($ThreadHandle, $Win32Constants.TOKEN_QUERY -bor $Win32Constants.TOKEN_ADJUST_PRIVILEGES, $false, [Ref]$ThreadToken)
                if ($Result -eq $false)
                {
                    Throw (New-Object ComponentModel.Win32Exception)
                }
            }
            else
            {
                Throw ([ComponentModel.Win32Exception] $ErrorCode)
            }
        }

        $CloseHandle.Invoke($ThreadHandle) | Out-Null
    
        $LuidSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$LUID)
        $LuidPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($LuidSize)
        $LuidObject = [System.Runtime.InteropServices.Marshal]::PtrToStructure($LuidPtr, [Type]$LUID)
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($LuidPtr)

        $Result = $LookupPrivilegeValue.Invoke($null, "SeAssignPrimaryTokenPrivilege", [Ref] $LuidObject)

        if ($Result -eq $false)
        {
            Throw (New-Object ComponentModel.Win32Exception)
        }

        [UInt32]$LuidAndAttributesSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$LUID_AND_ATTRIBUTES)
        $LuidAndAttributesPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($LuidAndAttributesSize)
        $LuidAndAttributes = [System.Runtime.InteropServices.Marshal]::PtrToStructure($LuidAndAttributesPtr, [Type]$LUID_AND_ATTRIBUTES)
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($LuidAndAttributesPtr)

        $LuidAndAttributes.Luid = $LuidObject
        $LuidAndAttributes.Attributes = $Win32Constants.SE_PRIVILEGE_ENABLED

        [UInt32]$TokenPrivSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$TOKEN_PRIVILEGES)
        $TokenPrivilegesPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TokenPrivSize)
        $TokenPrivileges = [System.Runtime.InteropServices.Marshal]::PtrToStructure($TokenPrivilegesPtr, [Type]$TOKEN_PRIVILEGES)
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenPrivilegesPtr)
        $TokenPrivileges.PrivilegeCount = 1
        $TokenPrivileges.Privileges = $LuidAndAttributes

        $Global:TokenPriv = $TokenPrivileges

        $Result = $AdjustTokenPrivileges.Invoke($ThreadToken, $false, [Ref] $TokenPrivileges, $TokenPrivSize, [IntPtr]::Zero, [IntPtr]::Zero)
        if ($Result -eq $false)
        {
            Throw (New-Object ComponentModel.Win32Exception)
        }

        $CloseHandle.Invoke($ThreadToken) | Out-Null
    }


    
    function Enable-Privilege
    {
        Param(
            [Parameter()]
            [ValidateSet("SeAssignPrimaryTokenPrivilege", "SeAuditPrivilege", "SeBackupPrivilege", "SeChangeNotifyPrivilege", "SeCreateGlobalPrivilege",
                "SeCreatePagefilePrivilege", "SeCreatePermanentPrivilege", "SeCreateSymbolicLinkPrivilege", "SeCreateTokenPrivilege",
                "SeDebugPrivilege", "SeEnableDelegationPrivilege", "SeImpersonatePrivilege", "SeIncreaseBasePriorityPrivilege",
                "SeIncreaseQuotaPrivilege", "SeIncreaseWorkingSetPrivilege", "SeLoadDriverPrivilege", "SeLockMemoryPrivilege", "SeMachineAccountPrivilege",
                "SeManageVolumePrivilege", "SeProfileSingleProcessPrivilege", "SeRelabelPrivilege", "SeRemoteShutdownPrivilege", "SeRestorePrivilege",
                "SeSecurityPrivilege", "SeShutdownPrivilege", "SeSyncAgentPrivilege", "SeSystemEnvironmentPrivilege", "SeSystemProfilePrivilege",
                "SeSystemtimePrivilege", "SeTakeOwnershipPrivilege", "SeTcbPrivilege", "SeTimeZonePrivilege", "SeTrustedCredManAccessPrivilege",
                "SeUndockPrivilege", "SeUnsolicitedInputPrivilege")]
            [String]
            $Privilege
        )

        [IntPtr]$ThreadHandle = $GetCurrentThread.Invoke()
        if ($ThreadHandle -eq [IntPtr]::Zero)
        {
            Throw "Unable to get the handle to the current thread"
        }
        
        [IntPtr]$ThreadToken = [IntPtr]::Zero
        [Bool]$Result = $OpenThreadToken.Invoke($ThreadHandle, $Win32Constants.TOKEN_QUERY -bor $Win32Constants.TOKEN_ADJUST_PRIVILEGES, $false, [Ref]$ThreadToken)
        $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()

        if ($Result -eq $false)
        {
            if ($ErrorCode -eq $Win32Constants.ERROR_NO_TOKEN)
            {
                $Result = $ImpersonateSelf.Invoke($Win32Constants.SECURITY_DELEGATION)
                if ($Result -eq $false)
                {
                    Throw (New-Object ComponentModel.Win32Exception)
                }
                
                $Result = $OpenThreadToken.Invoke($ThreadHandle, $Win32Constants.TOKEN_QUERY -bor $Win32Constants.TOKEN_ADJUST_PRIVILEGES, $false, [Ref]$ThreadToken)
                if ($Result -eq $false)
                {
                    Throw (New-Object ComponentModel.Win32Exception)
                }
            }
            else
            {
                Throw ([ComponentModel.Win32Exception] $ErrorCode)
            }
        }

        $CloseHandle.Invoke($ThreadHandle) | Out-Null
    
        $LuidSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$LUID)
        $LuidPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($LuidSize)
        $LuidObject = [System.Runtime.InteropServices.Marshal]::PtrToStructure($LuidPtr, [Type]$LUID)
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($LuidPtr)

        $Result = $LookupPrivilegeValue.Invoke($null, $Privilege, [Ref] $LuidObject)

        if ($Result -eq $false)
        {
            Throw (New-Object ComponentModel.Win32Exception)
        }

        [UInt32]$LuidAndAttributesSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$LUID_AND_ATTRIBUTES)
        $LuidAndAttributesPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($LuidAndAttributesSize)
        $LuidAndAttributes = [System.Runtime.InteropServices.Marshal]::PtrToStructure($LuidAndAttributesPtr, [Type]$LUID_AND_ATTRIBUTES)
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($LuidAndAttributesPtr)

        $LuidAndAttributes.Luid = $LuidObject
        $LuidAndAttributes.Attributes = $Win32Constants.SE_PRIVILEGE_ENABLED

        [UInt32]$TokenPrivSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$TOKEN_PRIVILEGES)
        $TokenPrivilegesPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TokenPrivSize)
        $TokenPrivileges = [System.Runtime.InteropServices.Marshal]::PtrToStructure($TokenPrivilegesPtr, [Type]$TOKEN_PRIVILEGES)
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenPrivilegesPtr)
        $TokenPrivileges.PrivilegeCount = 1
        $TokenPrivileges.Privileges = $LuidAndAttributes

        $Global:TokenPriv = $TokenPrivileges

        Write-Verbose "Attempting to enable privilege: $Privilege"
        $Result = $AdjustTokenPrivileges.Invoke($ThreadToken, $false, [Ref] $TokenPrivileges, $TokenPrivSize, [IntPtr]::Zero, [IntPtr]::Zero)
        if ($Result -eq $false)
        {
            Throw (New-Object ComponentModel.Win32Exception)
        }

        $CloseHandle.Invoke($ThreadToken) | Out-Null
        Write-Verbose "Enabled privilege: $Privilege"
    }


    
    function Set-DesktopACLs
    {
        Enable-Privilege -Privilege SeSecurityPrivilege

        
        $WindowStationStr = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni("WinSta0")
        $hWinsta = $OpenWindowStationW.Invoke($WindowStationStr, $false, $Win32Constants.ACCESS_SYSTEM_SECURITY -bor $Win32Constants.READ_CONTROL -bor $Win32Constants.WRITE_DAC)

        if ($hWinsta -eq [IntPtr]::Zero)
        {
            Throw (New-Object ComponentModel.Win32Exception)
        }

        Set-DesktopACLToAllowEveryone -hObject $hWinsta
        $CloseHandle.Invoke($hWinsta) | Out-Null

        
        $hDesktop = $OpenDesktopA.Invoke("default", 0, $false, $Win32Constants.DESKTOP_GENERIC_ALL -bor $Win32Constants.WRITE_DAC)
        if ($hDesktop -eq [IntPtr]::Zero)
        {
            Throw (New-Object ComponentModel.Win32Exception)
        }

        Set-DesktopACLToAllowEveryone -hObject $hDesktop
        $CloseHandle.Invoke($hDesktop) | Out-Null
    }


    function Set-DesktopACLToAllowEveryone
    {
        Param(
            [IntPtr]$hObject
            )

        [IntPtr]$ppSidOwner = [IntPtr]::Zero
        [IntPtr]$ppsidGroup = [IntPtr]::Zero
        [IntPtr]$ppDacl = [IntPtr]::Zero
        [IntPtr]$ppSacl = [IntPtr]::Zero
        [IntPtr]$ppSecurityDescriptor = [IntPtr]::Zero
        
        $retVal = $GetSecurityInfo.Invoke($hObject, 0x7, $Win32Constants.DACL_SECURITY_INFORMATION, [Ref]$ppSidOwner, [Ref]$ppSidGroup, [Ref]$ppDacl, [Ref]$ppSacl, [Ref]$ppSecurityDescriptor)
        if ($retVal -ne 0)
        {
            Write-Error "Unable to call GetSecurityInfo. ErrorCode: $retVal"
        }

        if ($ppDacl -ne [IntPtr]::Zero)
        {
            $AclObj = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ppDacl, [Type]$ACL)

            
            [UInt32]$RealSize = 2000
            $pAllUsersSid = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($RealSize)
            $Success = $CreateWellKnownSid.Invoke(1, [IntPtr]::Zero, $pAllUsersSid, [Ref]$RealSize)
            if (-not $Success)
            {
                Throw (New-Object ComponentModel.Win32Exception)
            }

            
            $TrusteeSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$TRUSTEE)
            $TrusteePtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TrusteeSize)
            $TrusteeObj = [System.Runtime.InteropServices.Marshal]::PtrToStructure($TrusteePtr, [Type]$TRUSTEE)
            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TrusteePtr)
            $TrusteeObj.pMultipleTrustee = [IntPtr]::Zero
            $TrusteeObj.MultipleTrusteeOperation = 0
            $TrusteeObj.TrusteeForm = $Win32Constants.TRUSTEE_IS_SID
            $TrusteeObj.TrusteeType = $Win32Constants.TRUSTEE_IS_WELL_KNOWN_GROUP
            $TrusteeObj.ptstrName = $pAllUsersSid

            
            $ExplicitAccessSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$EXPLICIT_ACCESS)
            $ExplicitAccessPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($ExplicitAccessSize)
            $ExplicitAccess = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ExplicitAccessPtr, [Type]$EXPLICIT_ACCESS)
            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($ExplicitAccessPtr)
            $ExplicitAccess.grfAccessPermissions = 0xf03ff
            $ExplicitAccess.grfAccessMode = $Win32constants.GRANT_ACCESS
            $ExplicitAccess.grfInheritance = $Win32Constants.OBJECT_INHERIT_ACE
            $ExplicitAccess.Trustee = $TrusteeObj

            [IntPtr]$NewDacl = [IntPtr]::Zero

            $RetVal = $SetEntriesInAclW.Invoke(1, [Ref]$ExplicitAccess, $ppDacl, [Ref]$NewDacl)
            if ($RetVal -ne 0)
            {
                Write-Error "Error calling SetEntriesInAclW: $RetVal"
            }

            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($pAllUsersSid)

            if ($NewDacl -eq [IntPtr]::Zero)
            {
                throw "New DACL is null"
            }

            
            $RetVal = $SetSecurityInfo.Invoke($hObject, 0x7, $Win32Constants.DACL_SECURITY_INFORMATION, $ppSidOwner, $ppSidGroup, $NewDacl, $ppSacl)
            if ($RetVal -ne 0)
            {
                Write-Error "SetSecurityInfo failed. Return value: $RetVal"
            }

            $LocalFree.Invoke($ppSecurityDescriptor) | Out-Null
        }
    }


    
    function Get-PrimaryToken
    {
        Param(
            [Parameter(Position=0, Mandatory=$true)]
            [UInt32]
            $ProcessId,

            
            [Parameter()]
            [Switch]
            $FullPrivs
        )

        if ($FullPrivs)
        {
            $TokenPrivs = $Win32Constants.TOKEN_ALL_ACCESS
        }
        else
        {
            $TokenPrivs = $Win32Constants.TOKEN_ASSIGN_PRIMARY -bor $Win32Constants.TOKEN_DUPLICATE -bor $Win32Constants.TOKEN_IMPERSONATE -bor $Win32Constants.TOKEN_QUERY 
        }

        $ReturnStruct = New-Object PSObject

        $hProcess = $OpenProcess.Invoke($Win32Constants.PROCESS_QUERY_INFORMATION, $true, [UInt32]$ProcessId)
        $ReturnStruct | Add-Member -MemberType NoteProperty -Name hProcess -Value $hProcess
        if ($hProcess -eq [IntPtr]::Zero)
        {
            
            $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
            Write-Verbose "Failed to open process handle for ProcessId: $ProcessId. ProcessName $((Get-Process -Id $ProcessId).Name). Error code: $ErrorCode . This is likely because this is a protected process."
            return $null
        }
        else
        {
            [IntPtr]$hProcToken = [IntPtr]::Zero
            $Success = $OpenProcessToken.Invoke($hProcess, $TokenPrivs, [Ref]$hProcToken)

            
            if (-not $CloseHandle.Invoke($hProcess))
            {
                $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                Write-Warning "Failed to close process handle, this is unexpected. ErrorCode: $ErrorCode"
            }
            $hProcess = [IntPtr]::Zero

            if ($Success -eq $false -or $hProcToken -eq [IntPtr]::Zero)
            {
                $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                Write-Warning "Failed to get processes primary token. ProcessId: $ProcessId. ProcessName $((Get-Process -Id $ProcessId).Name). Error: $ErrorCode"
                return $null
            }
            else
            {
                $ReturnStruct | Add-Member -MemberType NoteProperty -Name hProcToken -Value $hProcToken
            }
        }

        return $ReturnStruct
    }


    function Get-ThreadToken
    {
        Param(
            [Parameter(Position=0, Mandatory=$true)]
            [UInt32]
            $ThreadId
        )

        $TokenPrivs = $Win32Constants.TOKEN_ALL_ACCESS

        $RetStruct = New-Object PSObject
        [IntPtr]$hThreadToken = [IntPtr]::Zero

        $hThread = $OpenThread.Invoke($Win32Constants.THREAD_ALL_ACCESS, $false, $ThreadId)
        if ($hThread -eq [IntPtr]::Zero)
        {
            $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
            if ($ErrorCode -ne $Win32Constants.ERROR_INVALID_PARAMETER) 
            {
                Write-Warning "Failed to open thread handle for ThreadId: $ThreadId. Error code: $ErrorCode"
            }
        }
        else
        {
            $Success = $OpenThreadToken.Invoke($hThread, $TokenPrivs, $false, [Ref]$hThreadToken)
            if (-not $Success)
            {
                $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                if (($ErrorCode -ne $Win32Constants.ERROR_NO_TOKEN) -and  
                 ($ErrorCode -ne $Win32Constants.ERROR_INVALID_PARAMETER)) 
                {
                    Write-Warning "Failed to call OpenThreadToken for ThreadId: $ThreadId. Error code: $ErrorCode"
                }
            }
            else
            {
                Write-Verbose "Successfully queried thread token"
            }

            
            if (-not $CloseHandle.Invoke($hThread))
            {
                $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                Write-Warning "Failed to close thread handle, this is unexpected. ErrorCode: $ErrorCode"
            }
            $hThread = [IntPtr]::Zero
        }

        $RetStruct | Add-Member -MemberType NoteProperty -Name hThreadToken -Value $hThreadToken
        return $RetStruct
    }


    
    function Get-TokenInformation
    {
        Param(
            [Parameter(Position=0, Mandatory=$true)]
            [IntPtr]
            $hToken
        )

        $ReturnObj = $null

        $TokenStatsSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$TOKEN_STATISTICS)
        [IntPtr]$TokenStatsPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TokenStatsSize)
        [UInt32]$RealSize = 0
        $Success = $GetTokenInformation.Invoke($hToken, $TOKEN_INFORMATION_CLASS::TokenStatistics, $TokenStatsPtr, $TokenStatsSize, [Ref]$RealSize)
        if (-not $Success)
        {
            $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
            Write-Warning "GetTokenInformation failed. Error code: $ErrorCode"
        }
        else
        {
            $TokenStats = [System.Runtime.InteropServices.Marshal]::PtrToStructure($TokenStatsPtr, [Type]$TOKEN_STATISTICS)

            
            $LuidPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$LUID))
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($TokenStats.AuthenticationId, $LuidPtr, $false)

            [IntPtr]$LogonSessionDataPtr = [IntPtr]::Zero
            $ReturnVal = $LsaGetLogonSessionData.Invoke($LuidPtr, [Ref]$LogonSessionDataPtr)
            if ($ReturnVal -ne 0 -and $LogonSessionDataPtr -eq [IntPtr]::Zero)
            {
                Write-Warning "Call to LsaGetLogonSessionData failed. Error code: $ReturnVal. LogonSessionDataPtr = $LogonSessionDataPtr"
            }
            else
            {
                $LogonSessionData = [System.Runtime.InteropServices.Marshal]::PtrToStructure($LogonSessionDataPtr, [Type]$SECURITY_LOGON_SESSION_DATA)
                if ($LogonSessionData.Username.Buffer -ne [IntPtr]::Zero -and 
                    $LogonSessionData.LoginDomain.Buffer -ne [IntPtr]::Zero)
                {
                    
                    $Username = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($LogonSessionData.Username.Buffer, $LogonSessionData.Username.Length/2)
                    $Domain = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($LogonSessionData.LoginDomain.Buffer, $LogonSessionData.LoginDomain.Length/2)

                    
                    
                    
                    if ($Username -ieq "$($env:COMPUTERNAME)`$")
                    {
                        [UInt32]$Size = 100
                        [UInt32]$NumUsernameChar = $Size / 2
                        [UInt32]$NumDomainChar = $Size / 2
                        [UInt32]$SidNameUse = 0
                        $UsernameBuffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Size)
                        $DomainBuffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Size)
                        $Success = $LookupAccountSidW.Invoke([IntPtr]::Zero, $LogonSessionData.Sid, $UsernameBuffer, [Ref]$NumUsernameChar, $DomainBuffer, [Ref]$NumDomainChar, [Ref]$SidNameUse)

                        if ($Success)
                        {
                            $Username = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($UsernameBuffer)
                            $Domain = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($DomainBuffer)
                        }
                        else
                        {
                            $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                            Write-Warning "Error calling LookupAccountSidW. Error code: $ErrorCode"
                        }

                        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($UsernameBuffer)
                        $UsernameBuffer = [IntPtr]::Zero
                        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($DomainBuffer)
                        $DomainBuffer = [IntPtr]::Zero
                    }

                    $ReturnObj = New-Object PSObject
                    $ReturnObj | Add-Member -Type NoteProperty -Name Domain -Value $Domain
                    $ReturnObj | Add-Member -Type NoteProperty -Name Username -Value $Username    
                    $ReturnObj | Add-Member -Type NoteProperty -Name hToken -Value $hToken
                    $ReturnObj | Add-Member -Type NoteProperty -Name LogonType -Value $LogonSessionData.LogonType


                    
                    $ReturnObj | Add-Member -Type NoteProperty -Name IsElevated -Value $false

                    $TokenElevationSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$TOKEN_ELEVATION)
                    $TokenElevationPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TokenElevationSize)
                    [UInt32]$RealSize = 0
                    $Success = $GetTokenInformation.Invoke($hToken, $TOKEN_INFORMATION_CLASS::TokenElevation, $TokenElevationPtr, $TokenElevationSize, [Ref]$RealSize)
                    if (-not $Success)
                    {
                        $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                        Write-Warning "GetTokenInformation failed to retrieve TokenElevation status. ErrorCode: $ErrorCode" 
                    }
                    else
                    {
                        $TokenElevation = [System.Runtime.InteropServices.Marshal]::PtrToStructure($TokenelevationPtr, [Type]$TOKEN_ELEVATION)
                        if ($TokenElevation.TokenIsElevated -ne 0)
                        {
                            $ReturnObj.IsElevated = $true
                        }
                    }
                    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenElevationPtr)


                    
                    $ReturnObj | Add-Member -Type NoteProperty -Name TokenType -Value "UnableToRetrieve"

                    [UInt32]$TokenTypeSize = 4
                    [IntPtr]$TokenTypePtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TokenTypeSize)
                    [UInt32]$RealSize = 0
                    $Success = $GetTokenInformation.Invoke($hToken, $TOKEN_INFORMATION_CLASS::TokenType, $TokenTypePtr, $TokenTypeSize, [Ref]$RealSize)
                    if (-not $Success)
                    {
                        $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                        Write-Warning "GetTokenInformation failed to retrieve TokenImpersonationLevel status. ErrorCode: $ErrorCode"
                    }
                    else
                    {
                        [UInt32]$TokenType = [System.Runtime.InteropServices.Marshal]::PtrToStructure($TokenTypePtr, [Type][UInt32])
                        switch($TokenType)
                        {
                            1 {$ReturnObj.TokenType = "Primary"}
                            2 {$ReturnObj.TokenType = "Impersonation"}
                        }
                    }
                    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenTypePtr)


                    
                    if ($ReturnObj.TokenType -ieq "Impersonation")
                    {
                        $ReturnObj | Add-Member -Type NoteProperty -Name ImpersonationLevel -Value "UnableToRetrieve"

                        [UInt32]$ImpersonationLevelSize = 4
                        [IntPtr]$ImpersonationLevelPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($ImpersonationLevelSize) 
                        [UInt32]$RealSize = 0
                        $Success = $GetTokenInformation.Invoke($hToken, $TOKEN_INFORMATION_CLASS::TokenImpersonationLevel, $ImpersonationLevelPtr, $ImpersonationLevelSize, [Ref]$RealSize)
                        if (-not $Success)
                        {
                            $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                            Write-Warning "GetTokenInformation failed to retrieve TokenImpersonationLevel status. ErrorCode: $ErrorCode"
                        }
                        else
                        {
                            [UInt32]$ImpersonationLevel = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ImpersonationLevelPtr, [Type][UInt32])
                            switch ($ImpersonationLevel)
                            {
                                0 { $ReturnObj.ImpersonationLevel = "SecurityAnonymous" }
                                1 { $ReturnObj.ImpersonationLevel = "SecurityIdentification" }
                                2 { $ReturnObj.ImpersonationLevel = "SecurityImpersonation" }
                                3 { $ReturnObj.ImpersonationLevel = "SecurityDelegation" }
                            }
                        }
                        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($ImpersonationLevelPtr)
                    }


                    
                    $ReturnObj | Add-Member -Type NoteProperty -Name SessionID -Value "Unknown"

                    [UInt32]$TokenSessionIdSize = 4
                    [IntPtr]$TokenSessionIdPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TokenSessionIdSize)
                    [UInt32]$RealSize = 0
                    $Success = $GetTokenInformation.Invoke($hToken, $TOKEN_INFORMATION_CLASS::TokenSessionId, $TokenSessionIdPtr, $TokenSessionIdSize, [Ref]$RealSize)
                    if (-not $Success)
                    {
                        $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                        Write-Warning "GetTokenInformation failed to retrieve Token SessionId. ErrorCode: $ErrorCode"
                    }
                    else
                    {
                        [UInt32]$TokenSessionId = [System.Runtime.InteropServices.Marshal]::PtrToStructure($TokenSessionIdPtr, [Type][UInt32])
                        $ReturnObj.SessionID = $TokenSessionId
                    }
                    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenSessionIdPtr)


                    
                    $ReturnObj | Add-Member -Type NoteProperty -Name PrivilegesEnabled -Value @()
                    $ReturnObj | Add-Member -Type NoteProperty -Name PrivilegesAvailable -Value @()

                    [UInt32]$TokenPrivilegesSize = 1000
                    [IntPtr]$TokenPrivilegesPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TokenPrivilegesSize)
                    [UInt32]$RealSize = 0
                    $Success = $GetTokenInformation.Invoke($hToken, $TOKEN_INFORMATION_CLASS::TokenPrivileges, $TokenPrivilegesPtr, $TokenPrivilegesSize, [Ref]$RealSize)
                    if (-not $Success)
                    {
                        $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                        Write-Warning "GetTokenInformation failed to retrieve Token SessionId. ErrorCode: $ErrorCode"
                    }
                    else
                    {
                        $TokenPrivileges = [System.Runtime.InteropServices.Marshal]::PtrToStructure($TokenPrivilegesPtr, [Type]$TOKEN_PRIVILEGES)
                        
                        
                        [IntPtr]$PrivilegesBasePtr = [IntPtr](Add-SignedIntAsUnsigned $TokenPrivilegesPtr ([System.Runtime.InteropServices.Marshal]::OffsetOf([Type]$TOKEN_PRIVILEGES, "Privileges")))
                        $LuidAndAttributeSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$LUID_AND_ATTRIBUTES)
                        for ($i = 0; $i -lt $TokenPrivileges.PrivilegeCount; $i++)
                        {
                            $LuidAndAttributePtr = [IntPtr](Add-SignedIntAsUnsigned $PrivilegesBasePtr ($LuidAndAttributeSize * $i))

                            $LuidAndAttribute = [System.Runtime.InteropServices.Marshal]::PtrToStructure($LuidAndAttributePtr, [Type]$LUID_AND_ATTRIBUTES)

                            
                            [UInt32]$PrivilegeNameSize = 60
                            $PrivilegeNamePtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($PrivilegeNameSize)
                            $PLuid = $LuidAndAttributePtr 

                            $Success = $LookupPrivilegeNameW.Invoke([IntPtr]::Zero, $PLuid, $PrivilegeNamePtr, [Ref]$PrivilegeNameSize)
                            if (-not $Success)
                            {
                                $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                                Write-Warning "Call to LookupPrivilegeNameW failed. Error code: $ErrorCode. RealSize: $PrivilegeNameSize"
                            }
                            $PrivilegeName = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($PrivilegeNamePtr)

                            
                            $PrivilegeStatus = ""
                            $Enabled = $false

                            if ($LuidAndAttribute.Attributes -eq 0)
                            {
                                $Enabled = $false
                            }
                            if (($LuidAndAttribute.Attributes -band $Win32Constants.SE_PRIVILEGE_ENABLED_BY_DEFAULT) -eq $Win32Constants.SE_PRIVILEGE_ENABLED_BY_DEFAULT) 
                            {
                                $Enabled = $true
                            }
                            if (($LuidAndAttribute.Attributes -band $Win32Constants.SE_PRIVILEGE_ENABLED) -eq $Win32Constants.SE_PRIVILEGE_ENABLED) 
                            {
                                $Enabled = $true
                            }
                            if (($LuidAndAttribute.Attributes -band $Win32Constants.SE_PRIVILEGE_REMOVED) -eq $Win32Constants.SE_PRIVILEGE_REMOVED) 
                            {
                                Write-Warning "Unexpected behavior: Found a token with SE_PRIVILEGE_REMOVED. Please report this as a bug. "
                            }

                            if ($Enabled)
                            {
                                $ReturnObj.PrivilegesEnabled += ,$PrivilegeName
                            }
                            else
                            {
                                $ReturnObj.PrivilegesAvailable += ,$PrivilegeName
                            }

                            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($PrivilegeNamePtr)
                        }
                    }
                    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenPrivilegesPtr)

                }
                else
                {
                    Write-Verbose "Call to LsaGetLogonSessionData succeeded. This SHOULD be SYSTEM since there is no data. $($LogonSessionData.UserName.Length)"
                }

                
                $ntstatus = $LsaFreeReturnBuffer.Invoke($LogonSessionDataPtr)
                $LogonSessionDataPtr = [IntPtr]::Zero
                if ($ntstatus -ne 0)
                {
                    Write-Warning "Call to LsaFreeReturnBuffer failed. Error code: $ntstatus"
                }
            }

            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($LuidPtr)
            $LuidPtr = [IntPtr]::Zero
        }

        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($TokenStatsPtr)
        $TokenStatsPtr = [IntPtr]::Zero

        return $ReturnObj
    }


    
    function Get-UniqueTokens
    {
        Param(
            [Parameter(Position=0, Mandatory=$true)]
            [Object[]]
            $AllTokens
        )

        $TokenByUser = @{}
        $TokenByEnabledPriv = @{}
        $TokenByAvailablePriv = @{}

        
        foreach ($Token in $AllTokens)
        {
            $Key = $Token.Domain + "\" + $Token.Username
            if (-not $TokenByUser.ContainsKey($Key))
            {
                
                
                if ($Token.LogonType -ne 3 -and
                    $Token.Username -inotmatch "^DWM-\d+$" -and
                    $Token.Username -inotmatch "^LOCAL\sSERVICE$")
                {
                    $TokenByUser.Add($Key, $Token)
                }
            }
            else
            {
                
                if($Token.IsElevated -eq $TokenByUser[$Key].IsElevated)
                {
                    if (($Token.PrivilegesEnabled.Count + $Token.PrivilegesAvailable.Count) -gt ($TokenByUser[$Key].PrivilegesEnabled.Count + $TokenByUser[$Key].PrivilegesAvailable.Count))
                    {
                        $TokenByUser[$Key] = $Token
                    }
                }
                
                elseif (($Token.IsElevated -eq $true) -and ($TokenByUser[$Key].IsElevated -eq $false))
                {
                    $TokenByUser[$Key] = $Token
                }
            }
        }

        
        foreach ($Token in $AllTokens)
        {
            $Fullname = "$($Token.Domain)\$($Token.Username)"

            
            foreach ($Privilege in $Token.PrivilegesEnabled)
            {
                if ($TokenByEnabledPriv.ContainsKey($Privilege))
                {
                    if($TokenByEnabledPriv[$Privilege] -notcontains $Fullname)
                    {
                        $TokenByEnabledPriv[$Privilege] += ,$Fullname
                    }
                }
                else
                {
                    $TokenByEnabledPriv.Add($Privilege, @($Fullname))
                }
            }

            
            foreach ($Privilege in $Token.PrivilegesAvailable)
            {
                if ($TokenByAvailablePriv.ContainsKey($Privilege))
                {
                    if($TokenByAvailablePriv[$Privilege] -notcontains $Fullname)
                    {
                        $TokenByAvailablePriv[$Privilege] += ,$Fullname
                    }
                }
                else
                {
                    $TokenByAvailablePriv.Add($Privilege, @($Fullname))
                }
            }
        }

        $ReturnDict = @{
            TokenByUser = $TokenByUser
            TokenByEnabledPriv = $TokenByEnabledPriv
            TokenByAvailablePriv = $TokenByAvailablePriv
        }

        return (New-Object PSObject -Property $ReturnDict)
    }


    function Invoke-ImpersonateUser
    {
        Param(
            [Parameter(Position=0, Mandatory=$true)]
            [IntPtr]
            $hToken
        )

        
        [IntPtr]$NewHToken = [IntPtr]::Zero
        $Success = $DuplicateTokenEx.Invoke($hToken, $Win32Constants.MAXIMUM_ALLOWED, [IntPtr]::Zero, 3, 1, [Ref]$NewHToken) 
        if (-not $Success)
        {
            $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
            Write-Warning "DuplicateTokenEx failed. ErrorCode: $ErrorCode"
        }
        else
        {
            $Success = $ImpersonateLoggedOnUser.Invoke($NewHToken)
            if (-not $Success)
            {
                $Errorcode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                Write-Warning "Failed to ImpersonateLoggedOnUser. Error code: $Errorcode"
            }
        }

        $Success = $CloseHandle.Invoke($NewHToken)
        $NewHToken = [IntPtr]::Zero
        if (-not $Success)
        {
            $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
            Write-Warning "CloseHandle failed to close NewHToken. ErrorCode: $ErrorCode"
        }

        return $Success
    }


    function Create-ProcessWithToken
    {
        Param(
            [Parameter(Position=0, Mandatory=$true)]
            [IntPtr]
            $hToken,

            [Parameter(Position=1, Mandatory=$true)]
            [String]
            $ProcessName,

            [Parameter(Position=2)]
            [String]
            $ProcessArgs,

            [Parameter(Position=3)]
            [Switch]
            $PassThru
        )
        Write-Verbose "Entering Create-ProcessWithToken"
        
        [IntPtr]$NewHToken = [IntPtr]::Zero
        $Success = $DuplicateTokenEx.Invoke($hToken, $Win32Constants.MAXIMUM_ALLOWED, [IntPtr]::Zero, 3, 1, [Ref]$NewHToken)
        if (-not $Success)
        {
            $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
            Write-Warning "DuplicateTokenEx failed. ErrorCode: $ErrorCode"
        }
        else
        {
            $StartupInfoSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$STARTUPINFO)
            [IntPtr]$StartupInfoPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($StartupInfoSize)
            $memset.Invoke($StartupInfoPtr, 0, $StartupInfoSize) | Out-Null
            [System.Runtime.InteropServices.Marshal]::WriteInt32($StartupInfoPtr, $StartupInfoSize) 

            $ProcessInfoSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$PROCESS_INFORMATION)
            [IntPtr]$ProcessInfoPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($ProcessInfoSize)

            $ProcessNamePtr = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni("$ProcessName")
            $ProcessArgsPtr = [IntPtr]::Zero
            if (-not [String]::IsNullOrEmpty($ProcessArgs))
            {
                $ProcessArgsPtr = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni("`"$ProcessName`" $ProcessArgs")
            }
            
            $FunctionName = ""
            if ([System.Diagnostics.Process]::GetCurrentProcess().SessionId -eq 0)
            {
                
                
                
                Write-Verbose "Running in Session 0. Enabling SeAssignPrimaryTokenPrivilege and calling CreateProcessAsUserW to create a process with alternate token."
                Enable-Privilege -Privilege SeAssignPrimaryTokenPrivilege
                $Success = $CreateProcessAsUserW.Invoke($NewHToken, $ProcessNamePtr, $ProcessArgsPtr, [IntPtr]::Zero, [IntPtr]::Zero, $false, 0, [IntPtr]::Zero, [IntPtr]::Zero, $StartupInfoPtr, $ProcessInfoPtr)
                $FunctionName = "CreateProcessAsUserW"
            }
            else
            {
                Write-Verbose "Not running in Session 0, calling CreateProcessWithTokenW to create a process with alternate token."
                $Success = $CreateProcessWithTokenW.Invoke($NewHToken, 0x0, $ProcessNamePtr, $ProcessArgsPtr, 0, [IntPtr]::Zero, [IntPtr]::Zero, $StartupInfoPtr, $ProcessInfoPtr)
                $FunctionName = "CreateProcessWithTokenW"
            }
            if ($Success)
            {
                
                $ProcessInfo = [System.Runtime.InteropServices.Marshal]::PtrToStructure($ProcessInfoPtr, [Type]$PROCESS_INFORMATION)
                $CloseHandle.Invoke($ProcessInfo.hProcess) | Out-Null
                $CloseHandle.Invoke($ProcessInfo.hThread) | Out-Null

        
        if ($PassThru) {
            
            $returnProcess = Get-Process -Id $ProcessInfo.dwProcessId

            
            $null = $returnProcess.Handle

            
            $returnProcess
        }
            }
            else
            {
                $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                Write-Warning "$FunctionName failed. Error code: $ErrorCode"
            }

            
            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($StartupInfoPtr)
            $StartupInfoPtr = [Intptr]::Zero
            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($ProcessInfoPtr)
            $ProcessInfoPtr = [IntPtr]::Zero
            [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($ProcessNamePtr)
            $ProcessNamePtr = [IntPtr]::Zero

            
            $Success = $CloseHandle.Invoke($NewHToken)
            $NewHToken = [IntPtr]::Zero
            if (-not $Success)
            {
                $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                Write-Warning "CloseHandle failed to close NewHToken. ErrorCode: $ErrorCode"
            }
        }
    }


    function Free-AllTokens
    {
        Param(
            [Parameter(Position=0, Mandatory=$true)]
            [PSObject[]]
            $TokenInfoObjs
        )

        foreach ($Obj in $TokenInfoObjs)
        {
            $Success = $CloseHandle.Invoke($Obj.hToken)
            if (-not $Success)
            {
                $ErrorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                Write-Verbose "Failed to close token handle in Free-AllTokens. ErrorCode: $ErrorCode"
            }
            $Obj.hToken = [IntPtr]::Zero
        }
    }


    
    function Enum-AllTokens
    {
        $AllTokens = @()

        
        
        $systemTokenInfo = Get-PrimaryToken -ProcessId (Get-Process wininit | where {$_.SessionId -eq 0}).Id
        if ($systemTokenInfo -eq $null -or (-not (Invoke-ImpersonateUser -hToken $systemTokenInfo.hProcToken)))
        {
            Write-Warning "Unable to impersonate SYSTEM, the script will not be able to enumerate all tokens"
        }

        if ($systemTokenInfo -ne $null -and $systemTokenInfo.hProcToken -ne [IntPtr]::Zero)
        {
            $CloseHandle.Invoke($systemTokenInfo.hProcToken) | Out-Null
            $systemTokenInfo = $null
        }

        $ProcessIds = get-process | where {$_.name -inotmatch "^csrss$" -and $_.name -inotmatch "^system$" -and $_.id -ne 0}

        
        foreach ($Process in $ProcessIds)
        {
            $PrimaryTokenInfo = (Get-PrimaryToken -ProcessId $Process.Id -FullPrivs)

            
            if ($PrimaryTokenInfo -ne $null)
            {
                [IntPtr]$hToken = [IntPtr]$PrimaryTokenInfo.hProcToken

                if ($hToken -ne [IntPtr]::Zero)
                {
                    
                    $ReturnObj = Get-TokenInformation -hToken $hToken
                    if ($ReturnObj -ne $null)
                    {
                        $ReturnObj | Add-Member -MemberType NoteProperty -Name ProcessId -Value $Process.Id

                        $AllTokens += $ReturnObj
                    }
                }
                else
                {
                    Write-Warning "Couldn't retrieve token for Process: $($Process.Name). ProcessId: $($Process.Id)"
                }

                foreach ($Thread in $Process.Threads)
                {
                    $ThreadTokenInfo = Get-ThreadToken -ThreadId $Thread.Id
                    [IntPtr]$hToken = ($ThreadTokenInfo.hThreadToken)

                    if ($hToken -ne [IntPtr]::Zero)
                    {
                        $ReturnObj = Get-TokenInformation -hToken $hToken
                        if ($ReturnObj -ne $null)
                        {
                            $ReturnObj | Add-Member -MemberType NoteProperty -Name ThreadId -Value $Thread.Id
                    
                            $AllTokens += $ReturnObj
                        }
                    }
                }
            }
        }

        return $AllTokens
    }


    function Invoke-RevertToSelf
    {
        Param(
            [Parameter(Position=0)]
            [Switch]
            $ShowOutput
        )

        $Success = $RevertToSelf.Invoke()

        if ($ShowOutput)
        {
            if ($Success)
            {
                Write-Output "RevertToSelf was successful. Running as: $([Environment]::UserDomainName)\$([Environment]::UserName)"
            }
            else
            {
                Write-Output "RevertToSelf failed. Running as: $([Environment]::UserDomainName)\$([Environment]::UserName)"
            }
        }
    }


    
    function Main
    {
        if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
        {
            if (-not ($PsCmdlet.ParameterSetName -ieq "RevToSelf")){
                Write-Error "Script must be run as administrator" -ErrorAction Stop
            }
        }

        
        if ([System.Diagnostics.Process]::GetCurrentProcess().SessionId -eq 0)
        {
            Write-Verbose "Running in Session 0, forcing NoUI (processes in Session 0 cannot have a UI)"
            $NoUI = $true
        }

        if ($PsCmdlet.ParameterSetName -ieq "RevToSelf")
        {
            Invoke-RevertToSelf -ShowOutput
        }
        elseif ($PsCmdlet.ParameterSetName -ieq "CreateProcess" -or $PsCmdlet.ParameterSetName -ieq "ImpersonateUser")
        {
            $AllTokens = Enum-AllTokens
            
            
            [IntPtr]$hToken = [IntPtr]::Zero
            $UniqueTokens = (Get-UniqueTokens -AllTokens $AllTokens).TokenByUser
            if ($Username -ne $null -and $Username -ne '')
            {
                if ($UniqueTokens.ContainsKey($Username))
                {
                    $hToken = $UniqueTokens[$Username].hToken
                    Write-Verbose "Selecting token by username"
                }
                else
                {
                    Write-Error "A token belonging to the specified username was not found. Username: $($Username)" -ErrorAction Stop
                }
            }
            elseif ( $ProcessId -ne $null -and $ProcessId -ne 0)
            {
                foreach ($Token in $AllTokens)
                {
                    if (($Token | Get-Member ProcessId) -and $Token.ProcessId -eq $ProcessId)
                    {
                        $hToken = $Token.hToken
                        Write-Verbose "Selecting token by ProcessID"
                    }
                }

                if ($hToken -eq [IntPtr]::Zero)
                {
                    Write-Error "A token belonging to ProcessId $($ProcessId) could not be found. Either the process doesn't exist or it is a protected process and cannot be opened." -ErrorAction Stop
                }
            }
            elseif ($ThreadId -ne $null -and $ThreadId -ne 0)
            {
                foreach ($Token in $AllTokens)
                {
                    if (($Token | Get-Member ThreadId) -and $Token.ThreadId -eq $ThreadId)
                    {
                        $hToken = $Token.hToken
                        Write-Verbose "Selecting token by ThreadId"
                    }
                }

                if ($hToken -eq [IntPtr]::Zero)
                {
                    Write-Error "A token belonging to ThreadId $($ThreadId) could not be found. Either the thread doesn't exist or the thread is in a protected process and cannot be opened." -ErrorAction Stop
                }
            }
            elseif ($Process -ne $null)
            {
                foreach ($Token in $AllTokens)
                {
                    if (($Token | Get-Member ProcessId) -and $Token.ProcessId -eq $Process.Id)
                    {
                        $hToken = $Token.hToken
                        Write-Verbose "Selecting token by Process object"
                    }
                }

                if ($hToken -eq [IntPtr]::Zero)
                {
                    Write-Error "A token belonging to Process $($Process.Name) ProcessId $($Process.Id) could not be found. Either the process doesn't exist or it is a protected process and cannot be opened." -ErrorAction Stop
                }
            }
            else
            {
                Write-Error "Must supply a Username, ProcessId, ThreadId, or Process object"  -ErrorAction Stop
            }

            
            if ($PsCmdlet.ParameterSetName -ieq "CreateProcess")
            {
                if (-not $NoUI)
                {
                    Set-DesktopACLs
                }

                Create-ProcessWithToken -hToken $hToken -ProcessName $CreateProcess -ProcessArgs $ProcessArgs -PassThru:$PassThru

                Invoke-RevertToSelf
            }
            elseif ($ImpersonateUser)
            {
                Invoke-ImpersonateUser -hToken $hToken | Out-Null
                Write-Output "Running As: $([Environment]::UserDomainName)\$([Environment]::UserName)"
            }

            Free-AllTokens -TokenInfoObjs $AllTokens
        }
        elseif ($PsCmdlet.ParameterSetName -ieq "WhoAmI")
        {
            Write-Output "$([Environment]::UserDomainName)\$([Environment]::UserName)"
        }
        else 
        {
            $AllTokens = Enum-AllTokens

            if ($PsCmdlet.ParameterSetName -ieq "ShowAll")
            {
                Write-Output $AllTokens
            }
            else
            {
                Write-Output (Get-UniqueTokens -AllTokens $AllTokens).TokenByUser.Values
            }

            Invoke-RevertToSelf

            Free-AllTokens -TokenInfoObjs $AllTokens
        }
    }


    
    Main
}
