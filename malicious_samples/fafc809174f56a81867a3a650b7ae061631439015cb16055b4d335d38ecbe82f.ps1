Function Get-DomainInfo {
<#
.SYNOPSIS
    Get basic information about a given Active Directory domain.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-DomainInfo queries domain controller via LDAP protocol for basic information concerning Active Directory configuration.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-DomainInfo -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    Begin {
        $functionalLevels = @{
            0 = 'Windows 2000'
            1 = 'Windows Server 2003 Interim'
            2 = 'Windows Server 2003'
            3 = 'Windows Server 2008'
            4 = 'Windows Server 2008 R2'
            5 = 'Windows Server 2012'
            6 = 'Windows Server 2012 R2'
            7 = 'Windows Server 2016'
        }

        try {
            $rootDSE = Get-LdapRootDSE -Server $Server
            $defaultNC = $rootDSE.defaultNamingContext[0]
            $configurationNC = $rootDSE.configurationNamingContext[0]
        }
        catch {
            Write-Error "Domain controller unreachable" -ErrorAction Stop
        }
    }

    Process {
        $filter = '(objectClass=domain)'
        $properties = 'name','objectsid','ms-ds-machineaccountquota','whenCreated'
        $domain = Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $defaultNC -SearchScope 'Base' -Filter $filter -Properties $properties -Credential $Credential

        $filter = '(objectClass=site)'
        $sites = (Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $configurationNC -Filter $filter -Properties 'name' -Credential $Credential).name

        $filter = '(&(objectCategory=nTDSDSA)(options:1.2.840.113556.1.4.803:=1))'
        $globalCatalogs = (Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $configurationNC -Filter $filter -Properties 'distinguishedname' -Credential $Credential).distinguishedname
        $globalCatalogs = $globalCatalogs -replace 'CN=NTDS Settings,'

        Write-Output ([pscustomobject] @{
            DomainName                      = $defaultNC -replace 'DC=' -replace ',','.'
            NetbiosName                     = $domain.name
            DomainSID                       = (New-Object Security.Principal.SecurityIdentifier($domain.objectsid, 0)).Value
            Forest                          = ($rootDSE.rootDomainNamingContext[0]) -replace 'DC=' -replace ',','.'
            ForestFunctionalLevel           = $functionalLevels[[int] $rootDSE.forestFunctionality[0]]
            DomainFunctionalLevel           = $functionalLevels[[int] $rootDSE.domainFunctionality[0]]
            DomainControllerFunctionalLevel = $functionalLevels[[int] $rootDSE.domainControllerFunctionality[0]]
            GlobalCatalogs                  = $globalCatalogs
            Sites                           = $sites
            MachineAccountQuota             = $domain.'ms-ds-machineaccountquota'
            WhenCreated                     = $domain.whenCreated
        })
    }
}

Function Get-TrustRelationship {
<#
.SYNOPSIS
    Enumerate trust relationships defined in an Active Directory domain.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-TrustRelationship queries domain controller via LDAP protocol for domain trusts.
    It is a slightly modified version of PowerView's Get-DomainTrust by @harmj0y.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-TrustRelationship -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    Begin {
        Function Local:Get-TGTDelegationStatus {
            Param (
                [int] $TrustDirection,
                [uint32] $TrustAttributes
            )

            if (($TrustDirection -eq 0) -or ($TrustDirection -eq 2)) {
                return "N/A"
            }
            if ($TrustAttributes -band 0x00000008) {
                # quarantined ?
                if (-not ($TrustAttributes -band 0x00000200)) {
                    if ($TrustAttributes -band 0x00800000) {
                        return "Yes"
                    }
                }
                return "No"
            }
            return "N/A"
        }

        Function Local:Get-SidFilteringStatus {
            Param (
                [int] $TrustDirection,
                [uint32] $TrustAttributes
            )

            if (($TrustDirection -eq 0) -or ($TrustDirection -eq 1) -or ($TrustAttributes -band 0x00000020) -or ($TrustAttributes -band 0x00000400) -or ($TrustAttributes -band 0x00400000) -or ($trustAttributes -band 0x00800000)) {
                return "N/A"
            }
            if ($TrustAttributes -band 0x00000008) {
                if ($TrustAttributes -band 0x00000004) {
                    # quarantined
                    return "Yes"
                }
                if ($TrustAttributes -band 0x00000040) {
                    # forest trust migration
                    return "No"
                }
                return "Yes"
            }
            if ($TrustAttributes -band 0x00800000) {
                # obsolete tree root which
                return "N/A"
            }
            if ($TrustAttributes -band 0x00000004) {
                # quarantined
                return "Yes"
            }
            return "No"
        }

        $trustAttributes = @{
            [uint32]'0x00000001' = 'NON_TRANSITIVE'
            [uint32]'0x00000002' = 'UPLEVEL_ONLY'
            [uint32]'0x00000004' = 'FILTER_SIDS'
            [uint32]'0x00000008' = 'FOREST_TRANSITIVE'
            [uint32]'0x00000010' = 'CROSS_ORGANIZATION'
            [uint32]'0x00000020' = 'WITHIN_FOREST'
            [uint32]'0x00000040' = 'TREAT_AS_EXTERNAL'
            [uint32]'0x00000080' = 'TRUST_USES_RC4_ENCRYPTION'
            [uint32]'0x00000100' = 'TRUST_USES_AES_KEYS'
            [uint32]'0x00000200' = 'CROSS_ORGANIZATION_NO_TGT_DELEGATION'
            [uint32]'0x00000400' = 'PIM_TRUST'
        }

        try {
            $rootDSE = Get-LdapRootDSE -Server $Server
            $defaultNC = $rootDSE.defaultNamingContext[0]
            $domain = $defaultNC -replace 'DC=' -replace ',','.'
        }
        catch {
            Write-Error "Domain controller unreachable" -ErrorAction Stop
        }
    }

    Process {
        $filter = '(objectCategory=trustedDomain)'
        $properties = 'distinguishedName','trustPartner','securityIdentifier','trustDirection','trustType','trustAttributes','whenCreated','whenChanged'
        Get-LdapObject -Server $Server -SSL:$SSL -SearchBase "CN=System,$defaultNC" -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
            $obj = $_
            $trustType = switch ($obj.trustType) {
                1 { 'WINDOWS_NON_ACTIVE_DIRECTORY' }
                2 { 'WINDOWS_ACTIVE_DIRECTORY' }
                3 { 'MIT' }
            }
            $trustDirection = switch ($obj.trustDirection) {
                0 { 'Disabled' }
                1 { 'Inbound' }
                2 { 'Outbound' }
                3 { 'Bidirectional' }
            }
            $trustAttrib = @()
            $trustAttrib += $trustAttributes.Keys | Where-Object { $obj.trustAttributes -band $_ } | ForEach-Object { $trustAttributes[$_] }
            $sidFiltering = Get-SidFilteringStatus -TrustDirection $obj.trustDirection -TrustAttributes $obj.trustAttributes
            $tgtDelegation = Get-TGTDelegationStatus -TrustDirection $obj.trustDirection -TrustAttributes $obj.trustAttributes
            Write-Output ([pscustomobject] @{
                TrusteeDomainName   = $domain
                TrustedDomainName   = $obj.trustPartner
                TrustedDomainSID    = (New-Object Security.Principal.SecurityIdentifier($obj.securityIdentifier,0)).Value
                TrustType           = $trustType
                TrustDirection      = $trustDirection
                TrustAttributes     = $trustAttrib
                SIDFiltering        = $sidFiltering
                TGTDelegation       = $tgtDelegation
                WhenCreated         = $obj.whenCreated
                WhenChanged         = $obj.whenChanged
            })
        }
    }
}

Function Get-PasswordPolicy {
<#
.SYNOPSIS
    Get password policies defined in an Active Directory domain.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-PasswordPolicy queries domain controller via LDAP protocol for default password policy as well as fine-grained password policies.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-PasswordPolicy -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    Begin {
        try {
            $rootDSE = Get-LdapRootDSE -Server $Server
            $defaultNC = $rootDSE.defaultNamingContext[0]
        }
        catch {
            Write-Error "Domain controller unreachable" -ErrorAction Stop
        }
    }

    Process {
        # Enumerate domain password policy
        $filter = '(objectClass=domain)'
        $properties = 'distinguishedName','displayname','name','minPwdLength','minPwdAge','maxPwdAge','pwdHistoryLength','pwdProperties','lockoutDuration','lockoutThreshold','lockoutObservationWindow'
        Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $defaultNC -SearchScope 'Base' -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
            $complexityEnabled = $false
            if ($_.pwdProperties -band 1) {
                $complexityEnabled = $true
            }
            $reversibleEncryptionEnabled = $false
            if ($_.pwdProperties -band 16) {
                $reversibleEncryptionEnabled = $true
            }
            try {
                $maxPasswordAge = [TimeSpan]::FromTicks([Math]::ABS($_.maxPwdAge)).ToString()
            }
            catch {
                $maxPasswordAge = 'Never expires'
            }
            Write-Output ([pscustomobject] @{
                DisplayName = 'Default Domain Policy'
                DistinguishedName = $_.distinguishedName
                AppliesTo = $_.name
                MinPasswordLength = $_.minPwdLength
                MinPasswordAge = [TimeSpan]::FromTicks([Math]::ABS($_.minPwdAge)).ToString()
                MaxPasswordAge = $maxPasswordAge
                PasswordHistoryCount = $_.pwdHistoryLength
                ComplexityEnabled = $complexityEnabled
                ReversibleEncryptionEnabled = $reversibleEncryptionEnabled
                LockoutThreshold = $_.lockoutThreshold
                LockoutDuration = [TimeSpan]::FromTicks([Math]::ABS($_.lockoutDuration)).ToString()
                LockoutObservationWindow = [TimeSpan]::FromTicks([Math]::ABS($_.lockoutObservationWindow)).ToString()
            })
        }

        # Enumerate fine-grained password policies
        $filter = '(objectClass=msDS-PasswordSettings)'
        $properties = 'distinguishedName','displayname','msds-lockoutthreshold','msds-psoappliesto','msds-minimumpasswordlength','msds-passwordhistorylength','msds-lockoutobservationwindow','msds-lockoutduration','msds-minimumpasswordage','msds-maximumpasswordage','msds-passwordsettingsprecedence','msds-passwordcomplexityenabled','msds-passwordreversibleencryptionenabled'
        Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $defaultNC -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
            try {
                $maxPasswordAge = [TimeSpan]::FromTicks([Math]::ABS($_.'msds-maximumpasswordage')).ToString()
            }
            catch {
                $maxPasswordAge = 'Never expires'
            }
            Write-Output ([pscustomobject] @{
                DisplayName = $_.displayname
                DistinguishedName = $_.distinguishedName
                AppliesTo = $_.'msds-psoappliesto'
                MinPasswordLength = $_.'msds-minimumpasswordlength'
                MinPasswordAge = [TimeSpan]::FromTicks([Math]::ABS($_.'msds-minimumpasswordage')).ToString()
                MaxPasswordAge = $maxPasswordAge
                PasswordHistoryCount = $_.'msds-passwordhistorylength'
                ComplexityEnabled = $_.'msds-passwordcomplexityenabled'
                ReversibleEncryptionEnabled = $_.'msds-passwordreversibleencryptionenabled'
                LockoutThreshold = $_.'msds-lockoutthreshold'
                LockoutDuration = [TimeSpan]::FromTicks([Math]::ABS($_.'msds-lockoutduration')).ToString()
                LockoutObservationWindow = [TimeSpan]::FromTicks([Math]::ABS($_.'msds-lockoutobservationwindow')).ToString()
            })
        }
    }
}

Function Get-PotentiallyEmptyPassword {
<#
.SYNOPSIS
    Get user accounts allowed to have empty password.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-PotentiallyEmptyPassword queries domain controller via LDAP protocol for enabled user accounts configured with the UF_DONT_EXPIRE_PASSWD flag.
    For each account, information about other UAC flags related to password is also retrieved.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-PotentiallyEmptyPassword -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    $properties = 'distinguishedName','sAMAccountName','whenCreated','pwdLastSet','userAccountControl'
    $filter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(samAccountType=805306368)(userAccountControl:1.2.840.113556.1.4.803:=32))"
    Get-LdapObject -Server $Server -SSL:$SSL -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
        [int32] $userAccountControl = $_.userAccountControl

        $isPasswordExpires = $true
        if ($userAccountControl -band 65536) {
            # DONT_EXPIRE_PASSWD
            $isPasswordExpires = $false
        }

        $isPasswordExpired = $false
        if ($userAccountControl -band 8388608) {
            # PASSWORD_EXPIRED
            $isPasswordExpired = $true
        }

        $preauthNotRequired = $false
        if ($userAccountControl -band 4194304) {
            # DONT_REQ_PREAUTH
            $preauthNotRequired = $true
        }

        Write-Output ([pscustomobject] @{
            sAMAccountName          = $_.sAMAccountName
            DistinguishedName       = $_.distinguishedName
            PasswordNotRequired     = $true
            WhenCreated             = $_.whenCreated
            PasswordLastSet         = [datetime]::FromFileTime($_.pwdLastSet)
            IsPasswordExpires       = $isPasswordExpires
            IsPasswordExpired       = $isPasswordExpired
            IsPreauthRequired       = (-not $preauthNotRequired)
        })
    }
}

Function Get-PreCreatedComputer {
<#
.SYNOPSIS
    Get computer accounts that have never been used.
    If the option "Assign this computer account as a pre-Windows 2000 computer" is set for a computer account, its password is the computer name in lowercase and must be changed at next logon.
    If a computer account was created with the legacy tool dsadd, its password is empty. 

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-PreCreatedComputer queries domain controller via LDAP protocol for enabled computer accounts configured with the flags "UF_DONT_EXPIRE_PASSWD" and "WORKSTATION_TRUST_ACCOUNT".
    For each account, information about other UAC flags related to password is also retrieved.
    If you find a computer account that has never been used, you should try the computer name in lowercase as the password or a blank password.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-PreCreatedComputer -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    $properties = 'distinguishedName','sAMAccountName','whenCreated','userAccountControl'
    $filter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=32)(userAccountControl:1.2.840.113556.1.4.803:=4096)(logonCount=0))"
    Get-LdapObject -Server $Server -SSL:$SSL -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
        [int32] $userAccountControl = $_.userAccountControl

        $isPasswordExpires = $true
        if ($userAccountControl -band 65536) {
            # DONT_EXPIRE_PASSWD
            $isPasswordExpires = $false
        }

        $isPasswordExpired = $false
        if ($userAccountControl -band 8388608) {
            # PASSWORD_EXPIRED
            $isPasswordExpired = $true
        }

        $preauthNotRequired = $false
        if ($userAccountControl -band 4194304) {
            # DONT_REQ_PREAUTH
            $preauthNotRequired = $true
        }

        Write-Output ([pscustomobject] @{
            sAMAccountName          = $_.sAMAccountName
            DistinguishedName       = $_.distinguishedName
            WhenCreated             = $_.whenCreated
            PasswordNotRequired     = $true
            IsPasswordExpires       = $isPasswordExpires
            IsPasswordExpired       = $isPasswordExpired
            IsPreauthRequired       = (-not $preauthNotRequired)
        })
    }
}

Function Get-LdapPassword {
<#
.SYNOPSIS
    Get plaintext passwords from Active Directory.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-LdapPassword queries domain controller via LDAP protocol for accounts with common attributes containing passwords (UnixUserPassword, UserPassword, ms-MCS-AdmPwd, msDS-ManagedPassword and more).

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.PARAMETER Attributes
    Specifies specific attributes to search through.

.PARAMETER Keywords
    Specifies specific keywords to search for.

.EXAMPLE
    PS C:\> Get-LdapPassword -Server ADATUM.CORP -Credential ADATUM\testuser

.EXAMPLE
    PS C:\> Get-LdapPassword -Server ADATUM.CORP -Attributes description,comment -Keywords pw,mdp
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty,

        [String[]]
        $Attributes = @("description"),

        [ValidateNotNullOrEmpty()]
        [String[]]
        $Keywords = @("cred", "pass", "pw")
    )

    Begin {
        Function Local:ReadSecureWString {
            Param (
                [byte[]] $Buffer,
                [int] $StartIndex
            )
            $maxLength = $Buffer.Length - $StartIndex;
            $result = New-Object SecureString
            for ($i = $startIndex; $i -lt $buffer.Length; $i += [Text.UnicodeEncoding]::CharSize) {
                $c = [BitConverter]::ToChar($buffer, $i)
                if ($c -eq [Char]::MinValue) {
                    return $result
                }
                $result.AppendChar($c)
            }
        }

        Function Local:ConvertFrom-ADManagedPasswordBlob {
            Param (
                [byte[]] $Blob
            )
            $stream = New-object IO.MemoryStream($Blob)
            $reader = New-Object IO.BinaryReader($stream)
            $version = $reader.ReadInt16()
            $reserved = $reader.ReadInt16()
            $length = $reader.ReadInt32()
            $currentPasswordOffset = $reader.ReadInt16()
            $secureCurrentPassword = ReadSecureWString -Buffer $blob -StartIndex $currentPasswordOffset
            $previousPasswordOffset = $reader.ReadInt16()
            [SecureString] $securePreviousPassword = $null
            if ($previousPasswordOffset > 0) {
                $securePreviousPassword = ReadSecureWString -Buffer $blob -StartIndex $previousPasswordOffset
            }
            $queryPasswordIntervalOffset = $reader.ReadInt16()
            $queryPasswordIntervalBinary = [BitConverter]::ToInt64($blob, $queryPasswordIntervalOffset)
            $queryPasswordInterval = [TimeSpan]::FromTicks($queryPasswordIntervalBinary)
            $unchangedPasswordIntervalOffset = $reader.ReadInt16()
            $unchangedPasswordIntervalBinary = [BitConverter]::ToInt64($blob, $unchangedPasswordIntervalOffset)
            $unchangedPasswordInterval = [TimeSpan]::FromTicks($unchangedPasswordIntervalBinary)
            New-Object PSObject -Property @{
                CurrentPassword = $secureCurrentPassword.ToUnicodeString()
                PreviousPassword = $securePreviousPassword.ToUnicodeString()
                QueryPasswordInterval = $queryPasswordInterval
                UnchangedPasswordInterval = $unchangedPasswordInterval
            }
        }

        Function Local:ConvertTo-NTHash {
            Param (
                [string] $Password
            )
            $ntHash = New-Object byte[] 16
            $unicodePassword = New-Object ADMap.Win32+UNICODE_STRING $Password
            [ADMap.Win32]::RtlCalculateNtOwfPassword([ref] $unicodePassword, $ntHash) | Out-Null
            $unicodePassword.Dispose()
            return (($ntHash | ForEach-Object ToString X2) -join '')
        }

        try {
            $rootDSE = Get-LdapRootDSE -Server $Server
            $defaultNC = $rootDSE.defaultNamingContext[0]
        }
        catch {
            Write-Error "Domain controller unreachable" -ErrorAction Stop
        }
    }

    Process {
        # Searching for password in world-readable attributes
        $filter = ''
        foreach ($attribute in $Attributes) {
            foreach ($keyword in $Keywords) {
                $filter += "($attribute=*$keyword*)"
            }
        }
        $filter = "(&(objectClass=user)(|$filter))"
        Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $defaultNC -Filter $filter -Credential $Credential | ForEach-Object {
            foreach ($attribute in $attributes) {
                if ($_.$attribute) {
                    Write-Output ([pscustomobject] @{
                        SamAccountName = $_.sAMAccountName
                        Attribute = $attribute
                        Value = $_.$attribute
                    })
                }
            }
        }

        # Searching for encoded password attributes
        # Reference: https://www.blackhillsinfosec.com/domain-goodness-learned-love-ad-explorer/
        $filter = ''
        $attributes = @("UnixUserPassword", "UserPassword", "msSFU30Password", "unicodePwd", "os400-password")
        foreach ($attribute in $Attributes) {
            $filter += "($attribute=*)"
        }
        $filter = "(&(objectClass=user)(|$filter))"
        Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $defaultNC -Filter $filter -Credential $Credential | ForEach-Object {
            foreach ($attribute in $attributes) {
                if ($_.$attribute) {
                    Write-Output ([pscustomobject] @{
                        SamAccountName = $_.sAMAccountName
                        Attribute = $attribute
                        Value = [Text.Encoding]::ASCII.GetString($_.$attribute)
                    })
                }
            }
        }

        # Searching for LAPS passwords
        # Reference: https://adsecurity.org/?p=1790
        $filter = "(&(objectCategory=Computer)(ms-MCS-AdmPwd=*))"
        Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $defaultNC -Filter $filter -Credential $Credential | ForEach-Object {
            if ($_.'ms-MCS-AdmPwd') {
                Write-Output ([pscustomobject] @{
                    SamAccountName = $_.sAMAccountName
                    Attribute = 'ms-MCS-AdmPwd'
                    Value = $_.'ms-MCS-AdmPwd'
                })
            }
        }

        # Searching for GMSA passwords
        # Reference: https://www.dsinternals.com/en/retrieving-cleartext-gmsa-passwords-from-active-directory/
        $filter = "(&(objectClass=msDS-GroupManagedServiceAccount)(msDS-ManagedPasswordId=*))"
        Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $defaultNC -Filter $filter -Credential $Credential | ForEach-Object {
            if ($_.'msDS-ManagedPassword') {
                Write-Output ([pscustomobject] @{
                    SamAccountName = $_.sAMAccountName
                    Attribute = 'msDS-ManagedPassword'
                    Value = ConvertTo-NTHash -Password (ConvertFrom-ADManagedPasswordBlob -Blob $_.'msDS-ManagedPassword').CurrentPassword
                })
            }
        }
    }
}

Function Get-KerberoastableUser {
<#
.SYNOPSIS
    Get user accounts vulnerable to Kerberoast and ASREPRoast attacks.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-KerberoastableUser queries domain controller via LDAP protocol for enabled user accounts configured with a SPN attribute or the flag UF_DONT_REQ_PREAUTH.
    For each account, information about password expiration, encryption type supported and granted privileges is also retrieved.
    It is a slightly modified version of RiskySPN's Find-PotentiallyCrackableAccounts by @machosec.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-KerberoastableUser -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    $properties = 'distinguishedName','sAMAccountName','servicePrincipalName','msDS-UserPasswordExpiryTimeComputed','pwdLastSet','msDS-SupportedEncryptionTypes','userAccountControl','msDS-AllowedToDelegateTo','memberOf'
    $filter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(samAccountType=805306368)(|(servicePrincipalName=*)(userAccountControl:1.2.840.113556.1.4.803:=4194304))(!(samAccountName=krbtgt)))"
    Get-LdapObject -Server $Server -SSL:$SSL -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
        [int32] $userAccountControl = $_.userAccountControl

        # Kerberos preauthentication
        $preauthNotRequired = $false
        if ($userAccountControl -band 4194304) {
            # DONT_REQ_PREAUTH
            $preauthNotRequired = $true
        }

        # Password policy
        $currentDate = Get-Date
        $crackingWindow = "N/A"
        if ($_.'msds-UserPasswordExpiryTimeComputed' -ne 9223372036854775807) {
            $passwordExpiryDate = [datetime]::FromFileTime($_.'msds-UserPasswordExpiryTimeComputed')
            $crackingWindow = $passwordExpiryDate.Subtract($currentDate).Days
        }
        $passwordLastSet = [datetime]::FromFileTime($_.pwdLastSet)
        $passwordAge = $currentDate.Subtract($passwordLastSet).Days
        $isPasswordExpires = $true
        if ($userAccountControl -band 65536) {
            # DONT_EXPIRE_PASSWD
            $isPasswordExpires = $false
            $crackingWindow = "Indefinitely"
        }

        # Encryption type
        $encType = "RC4-HMAC"
        [int32] $eType = $_.'msds-supportedencryptiontypes'
        if ($eType) {
            if ($eType -band 16) {
                $encType = "AES256-HMAC"
            }
            elseif ($eType -band 8) {
                $encType = "AES128-HMAC"
            }
        }
        else {
            if ($userAccountControl -band 2097152) {
                # USE_DES_KEY_ONLY
                $encType = "DES"
            }
        }

        # Kerberos delegation
        $kerberosDelegation = $false
        $delegationTargetService = 'None'
        if ($_.userAccountControl -band 524288) {
            # TRUSTED_FOR_DELEGATION
            $kerberosDelegation = 'Unconstrained'
            $delegationTargetService = 'Any'
        }
        elseif ($_.'msDS-AllowedToDelegateTo') {
            $kerberosDelegation = 'Constrained' 
            if ($userAccountControl -band 16777216) {
                # TRUSTED_TO_AUTHENTICATE_FOR_DELEGATION
                $kerberosDelegation = 'Protocol Transition'
            }
            $delegationTargetService = $_.'msDS-AllowedToDelegateTo'
        }

        Write-Output ([pscustomobject] @{
            sAMAccountName          = $_.sAMAccountName
            DistinguishedName       = $_.distinguishedname
            ServicePrincipalName    = $_.servicePrincipalName
            IsPreauthRequired       = (-not $preauthNotRequired)
            EncryptionType          = $encType
            PasswordAge             = $passwordAge
            IsPasswordExpires       = $isPasswordExpires
            CrackingWindow          = $crackingWindow
            MemberOf                = $_.memberOf -replace "CN=" -replace ",.*"
            KerberosDelegation      = $kerberosDelegation
            DelegationTargetService = $delegationTargetService
        })
    }
}

Function Get-KerberosDelegation {
<#
.SYNOPSIS
    Enumerate Kerberos delegations.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-KerberosDelegation queries domain controller via LDAP protocol for enabled accounts granted with Kerberos delegation.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-KerberosDelegation -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    Begin {
        try {
            $rootDSE = Get-LdapRootDSE -Server $Server
            $defaultNC = $rootDSE.defaultNamingContext[0]
        }
        catch {
            Write-Error "Domain controller unreachable" -ErrorAction Stop
        }
    }

    Process {
        $filter = '(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(|(userAccountControl:1.2.840.113556.1.4.803:=524288)(userAccountControl:1.2.840.113556.1.4.803:=16777216)(msDS-AllowedToDelegateTo=*)(msDS-AllowedToActOnBehalfOfOtherIdentity=*)))'
        $properties = 'distinguishedName','sAMAccountName','objectCategory','userAccountControl','msDS-AllowedToActOnBehalfOfOtherIdentity','lastLogon','servicePrincipalName','operatingSystem','operatingSystemVersion','operatingSystemServicePack'
        Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $defaultNC -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
            $obj = $_
            $kerberosDelegation = $false
            $delegationTargetService = 'None'
            $rbcdService = 'None'

            # Unconstrained delegation
            if ($_.userAccountControl -band 524288) {
                # TRUSTED_FOR_DELEGATION
                $kerberosDelegation = 'Unconstrained'
                $delegationTargetService = 'Any'
            }

            # Constrained delegation
            elseif ($_.'msDS-AllowedToDelegateTo') {
                $kerberosDelegation = 'Constrained'
                if ($userAccountControl -band 16777216) {
                    # TRUSTED_TO_AUTHENTICATE_FOR_DELEGATION
                    $kerberosDelegation = 'Protocol Transition'
                }
                $delegationTargetService = $_.'msDS-AllowedToDelegateTo'
            }

            if ($kerberosDelegation) {
                Write-Output ([pscustomobject] @{
                    sAMAccountName          = $_.samAccountName
                    DistinguishedName       = $_.distinguishedname
                    ObjectCategory          = $_.objectcategory
                    ServicePrincipalName    = $_.servicePrincipalName
                    KerberosDelegation      = $kerberosDelegation
                    DelegationTargetService = $delegationTargetService
                    LastLogon               = ([datetime]::FromFileTime(($_.LastLogon)))
                    OperatingSystem         = $_.operatingSystem
                    Version                 = $_.operatingSystemVersion
                    ServicePack             = $_.operatingSystemServicePack
                })
            }

            # Resource-based constrained delegation
            if ($rbcd = $obj.'msDS-AllowedToActOnBehalfOfOtherIdentity') {
                $d = New-Object Security.AccessControl.RawSecurityDescriptor -ArgumentList $rbcd, 0
                $d.DiscretionaryAcl | ForEach-Object {
                    $filter = "(objectsid=$($_.SecurityIdentifier))"
                    Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $defaultNC -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
                        Write-Output ([pscustomobject] @{
                            sAMAccountName          = $_.samAccountName
                            DistinguishedName       = $_.distinguishedname
                            ObjectClass             = $_.objectClass
                            ServicePrincipalName    = $_.servicePrincipalName
                            KerberosDelegation      = 'Resource-Based Constrained'
                            DelegationTargetService = $obj.distinguishedname
                            LastLogon               = ([datetime]::FromFileTime(($_.LastLogon)))
                            OperatingSystem         = $_.operatingSystem
                            Version                 = $_.operatingSystemVersion
                            ServicePack             = $_.operatingSystemServicePack
                        })
                    }
                }
            }
        }
    }
}

Function Get-ServicePrincipal {
<#
.SYNOPSIS
    Discover enabled Kerberos services by searching for SPNs.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-ServicePrincipal queries domain controller via LDAP protocol for SPNs matching criteria.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP server.

.PARAMETER Credential
    Specifies the domain account to use.

.PARAMETER ServiceType
    Specifies SPN service codes to filter for.

.EXAMPLE
    PS C:\> Get-ServicePrincipal -Server ADATUM.CORP -ServiceType MSSQL
#>
    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty,

        [ValidateNotNullOrEmpty()]
        [string[]]
        $ServiceType = ''
    )

    # Get SPNs
    $properties = 'sAMAccountName','servicePrincipalName','lastLogon','description','objectCategory'
    $filter = ''
    foreach ($type in $ServiceType) {
        $filter += "(servicePrincipalName=$type*)"
    }
    $filter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(|$filter))"
    $results = Get-LdapObject -Server $Server -Filter $filter -Properties $properties -Credential $Credential
    $results | ForEach-Object {
        foreach ($spn in $($_.serviceprincipalname)) {
            # Parse SPNs
            $spnService = $spn.split('/')[0]
            $spnServer = $spn.split('/')[1].split(':')[0].split(' ')[0]
            if ($spnPort = $spn.split('/')[1].split(':')[1]) {
                $spnPort = $spnPort.split(' ')[0]
            }
            else {
                $spnPort = '(default)'
            }
            # Skip SPN values which does not match query
            $found = $false
            $ServiceType | ForEach-Object {if ($spnService -like "$_*") {$found = $true}}
            if (-not $found) {
                continue
            }
            # Parse object category
            $accountCategory = $($_.objectcategory).split('=')[1].split(',')[0]
            # Parse last logon
            if ($_.lastlogon) {
                $lastLogon = [datetime]::FromFileTime([string] $_.lastlogon).ToString('g')
            }
            else {
                $lastLogon = ''
            }

            Write-Output ([pscustomobject] @{
                sAMAccountName       = $_.samaccountname
                AccountCategory      = $accountCategory
                LastLogon            = $lastLogon
                Description          = $_.description
                ServicePrincipalName = $spn
                ComputerName         = $spnServer
                Port                 = $spnPort
                ServiceType          = $spnService
            })
        }
    }
}

Function Get-VulnerableSchemaClass {
<#
.SYNOPSIS
    Get vulnerable schema classes that can be used to create arbitrary objects.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-VulnerableSchemaClass queries a domain controller via LDAP protocol for vulnerable schema class.
    It is a modified version of Find-VulnerableSchemas by @IISResetMe.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-VulnerableSchemaClass -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    Begin {
        try {
            $rootDSE = Get-LdapRootDSE -Server $Server
            $schemaNC = $rootDSE.schemaNamingContext[0]
        }
        catch {
            Write-Error "Domain controller unreachable" -ErrorAction Stop
        }
    }

    Process {
        $properties = 'lDAPDisplayName','subClassOf','possSuperiors'
        $classSchemas = Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $schemaNC -Filter '(objectClass=classSchema)' -Properties $properties -Credential $Credential
        $superClass = @{}
        $classSchemas | ForEach-Object {
            $superClass[$_.lDAPDisplayName] = $_.subClassOf
        }
        $classSchemas | Where-Object { ($_.possSuperiors -eq 'computer') -or ($_.possSuperiors -eq 'user') } | ForEach-Object {
            $class = $cursor = $_.lDAPDisplayName
            $vulnerableClass = $null
            while ($superClass[$cursor] -notin 'top') {
                if ($superClass[$cursor] -eq 'container') {
                    $vulnerableClass = $class
                    break
                }
                $cursor = $superClass[$cursor]
            }
            if ($vulnerableClass) {
                if ($_.possSuperiors -eq 'computer') {
                    $vulnerability = 'PossSuperiorComputer'
                }
                if ($_.possSuperiors -eq 'user') {
                    $vulnerability = 'PossSuperiorUser'
                }
                Write-Output ([pscustomobject] @{
                    Vulnerability = $vulnerability
                    Classes = $vulnerableClass
                })
            }
        }
    }
}

Function Get-PrivExchangeStatus {
<#
.SYNOPSIS
    Get PrivExchange exploitability regarding to Active Directory rights granted to the group 'Exchange Windows Permissions'.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-PrivExchangeStatus queries a domain controller via LDAP protocol for WriteDacl ACL granted for the group 'Exchange Windows Permissions'.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-PrivExchangeStatus -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    Begin {
        try {
            $rootDSE = Get-LdapRootDSE -Server $Server
            $defaultNC = $rootDSE.defaultNamingContext[0]
        }
        catch {
            Write-Error "Domain controller unreachable" -ErrorAction Stop
        }
    }

    Process {
        $privExchangeAcl = $false
        $groupId = 'Exchange Windows Permissions'
        if ($objectSid = (Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $defaultNC -Filter "(samAccountName=$groupId)" -Properties objectsid -Credential $Credential).objectsid) {
            $groupSid = (New-Object Security.Principal.SecurityIdentifier($objectSid, 0)).Value
            Write-Verbose "SID of the group 'Exchange Windows Permissions': $groupSid"
            if ($groupSid -and (Get-LdapObjectAcl -Server $Server -SSL:$SSL -SearchBase $defaultNC -Filter "(DistinguishedName=$defaultNC)" -Credential $Credential | ? { ($_.SecurityIdentifier -imatch "$groupSid") -and ($_.ActiveDirectoryRights -imatch 'WriteDacl') -and -not ($_.AceFlags -imatch 'InheritOnly') })) {
                $privExchangeAcl = $true
            }
        }
        Write-Output $privExchangeAcl
    }
}

Function Get-ExchangeServer {
<#
.SYNOPSIS
    Enumerate Exchange servers from Active Directory and check for exploitable vulnerabilities.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-ExchangeServer queries domain controller via LDAP protocol for Exchange information.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-ExchangeServer -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    Begin {
        Function Local:ConvertTo-ExchangeVersion($Version) {
            $versionSizeInBits = 32
            $binaryVersion = [Convert]::ToString([int32]$Version,2)
            for ($i = $($binaryVersion.Length); $i -lt $versionSizeInBits; $i++){
                $binaryVersion = '0' + $binaryVersion
            }
            New-Object PSObject -Property @{
                LegacyVersionStructure = [Convert]::ToInt16($binaryVersion.Substring(0,4),2)
                MajorVersion = [Convert]::ToInt16($binaryVersion.Substring(4,6),2)
                MinorVersion = [Convert]::ToInt16($binaryVersion.Substring(10,6),2)
                Flag = [Convert]::ToInt16($binaryVersion.Substring(16,1),2)
                Build = [Convert]::ToInt16($binaryVersion.Substring(17,15),2)
            }
        }

        try {
            $rootDSE = Get-LdapRootDSE -Server $Server
            $configurationNC = $rootDSE.configurationNamingContext[0]
        }
        catch {
            Write-Error "Domain controller unreachable" -ErrorAction Stop
        }
    }

    Process {
        $roleDictionary = @{2  = "MB"; 4  = "CAS"; 16 = "UM"; 32 = "HT"; 64 = "ET"}
        $properties = 'sAMAccountName', 'msExchCurrentServerRoles', 'networkAddress', 'versionNumber'
        $filter = "(|(objectClass=msExchExchangeServer)(objectClass=msExchClientAccessArray))"
        $exchangeServers = Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $configurationNC -Filter $filter -Properties $properties -Credential $Credential
        foreach ($exchServer in $exchangeServers) {
            $privExchange = $false
            $CVE20200688  = $false
            $proxyLogon = $false
            $exchVersion = ConvertTo-ExchangeVersion $exchServer.versionNumber
            switch ($exchVersion.MajorVersion) {
                "15" {
                    switch ($exchVersion.MinorVersion) {
                        "0" {
                            if ([int]$exchVersion.Build -lt 1473) { $privExchange = $true }
                            if ([int]$exchVersion.Build -lt 1497) { $CVE20200688 = $true; $proxyLogon = $true }
                        }
                        "1" {
                            if ([int]$exchVersion.Build -lt 1713) { $privExchange = $true }
                            if ([int]$exchVersion.Build -lt 1847) { $CVE20200688 = $true }
                            if ([int]$exchVersion.Build -lt 2106) { $proxyLogon = $true }
                        }
                        "2" {
                            if ([int]$exchVersion.Build -lt 330) { $privExchange = $true }
                            if ([int]$exchVersion.Build -lt 464) { $CVE20200688 = $true }
                            if ([int]$exchVersion.Build -lt 721) { $proxyLogon = $true }
                        }
                    }
                }
                "14" {
                    switch ($exchVersion.MinorVersion) {
                        "3" {
                            if ([int]$exchVersion.Build -lt 442) { $privExchange = $true }
                            if ([int]$exchVersion.Build -lt 496) { $CVE20200688 = $true; $proxyLogon = $true }
                        }
                    }
                }
            }
            Write-Output ([pscustomobject] @{
                Fqdn            = ($exchServer.networkAddress | Where-Object -FilterScript {$_ -like "ncacn_ip_tcp*"}).Split(":")[1]
                Roles           = [string] ($roleDictionary.Keys | ?{$_ -band $exchServer.msExchCurrentServerRoles} | %{$roleDictionary.Get_Item($_)})
                Version         = "$($exchVersion.MajorVersion).$($exchVersion.MinorVersion).$($exchVersion.Build)"
                PrivExchange    = $privExchange
                'CVE-2020-0688' = $CVE20200688
                ProxyLogon      = $proxyLogon
            })
        }
    }
}

Function Get-ADCSServer {
<#
.SYNOPSIS
    Enumerate Active Directory Certificate Services.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-ADCSServer queries domain controller via LDAP protocol for PKI enrollment services.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-ADCSServer -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    Begin {
        try {
            $rootDSE = Get-LdapRootDSE -Server $Server
            $configurationNC = $rootDSE.configurationNamingContext[0]
            $defaultNC = $rootDSE.defaultNamingContext[0]
        }
        catch {
            Write-Error "Domain controller unreachable" -ErrorAction Stop
        }
    }

    Process {
        # Get CA info
        $filter = '(objectClass=pKIEnrollmentService)'
        $properties = 'cn', 'certificatetemplates', 'dnsHostname', 'msPKI-Enrollment-Servers'
        Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $configurationNC -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
            $certificateAuthority = $_.cn
            $certificateTemplates = $_.certificateTemplates
            $computerName = $_.dnsHostname
            $cn = $computerName.split(".")[0]
            # Get server info
            $filter = "(&(samAccountType=805306369)(cn=$cn))"
            $properties = 'samAccountName', 'operatingSystem', 'operatingSystemVersion', 'operatingSystemServicePack', 'LastLogon'
            Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $defaultNC -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
                Write-Output ([pscustomobject] @{
                    CertificateAuthority = $certificateAuthority
                    CertificateTemplates = $certificateTemplates
                    EnrollmentWebService = $_.'msPKI-Enrollment-Servers'
                    CAServer = $computerName
                    SamAccountName = $_.samAccountName
                    OperatingSystem = $_.operatingSystem
                    Version = $_.operatingSystemVersion
                    ServicePack = $_.operatingSystemServicePack
                    LastLogon = ([datetime]::FromFileTime(($_.LastLogon)))
                })
            }
        }
    }
}

Function Get-LegacyComputer {
<#
.SYNOPSIS
    Enumerate legacy Windows computers.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-LegacyComputer queries domain controller via LDAP protocol for outdated operating systems.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.EXAMPLE
    PS C:\> Get-LegacyComputer -Server ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    $legacyOS = '2000', '2003', '2008', 'ME', 'XP', 'Vista', 'Windows NT', 'Windows 7', 'Windows 8'
    $filter = ''
    foreach ($os in $legacyOS) {
        $filter += "(operatingsystem=*$os*)"
    }
    $filter = "(&(samAccountType=805306369)(!userAccountControl:1.2.840.113556.1.4.803:=2)(|$filter))"
    $properties = 'dnsHostname', 'samAccountName', 'operatingSystem', 'operatingSystemVersion', 'operatingSystemServicePack', 'LastLogon'
    Get-LdapObject -Server $Server -SSL:$SSL -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
        Write-Output ([pscustomobject] @{
                sAMAccountName = $_.samAccountName
                ComputerName = $_.dnsHostname
                OperatingSystem = $_.operatingSystem
                Version = $_.operatingSystemVersion
                ServicePack = $_.operatingSystemServicePack
                LastLogon = ([datetime]::FromFileTime(($_.LastLogon)))
        })
    }
}

Function Get-DnsRecord {
<#
.SYNOPSIS
    Get Active Directory-Integrated DNS (ADIDNS) records for a given zone.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-DnsRecord queries domain controller via LDAP protocol for DNS records.
    It is a slightly modified version of PowerView's Get-DomainDNSRecord by @harmj0y.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.PARAMETER ZoneName
    Specifies the DNS zone to query for records, defaults to Active Directory domain.

.EXAMPLE
    PS C:\> Get-DnsRecord -Server DC.ADATUM.CORP -Credential ADATUM\testuser
#>

    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty,

        [ValidateNotNullOrEmpty()]
        [String]
        $ZoneName
    )

    Begin {
        Function Local:Get-Name ([Byte[]] $Raw) {
            [Int] $Length = $Raw[0]
            [Int] $Segments = $Raw[1]
            [Int] $Index =  2
            [String] $Name  = ''
            while ($Segments-- -gt 0) {
                [Int]$segmentLength = $Raw[$Index++]
                while ($segmentLength-- -gt 0) {
                    $Name += [Char]$Raw[$Index++]
                }
                $Name += "."
            }
            $Name
        }

        Function Local:ConvertFrom-DNSRecord ([Byte[]]$DNSRecord) {
            $rDataType = [BitConverter]::ToUInt16($DNSRecord, 2)
            $updatedAtSerial = [BitConverter]::ToUInt32($DNSRecord, 8)

            $ttlRaw = $DNSRecord[12..15]
            $null = [array]::Reverse($ttlRaw)
            $ttl = [BitConverter]::ToUInt32($ttlRaw, 0)

            $age = [BitConverter]::ToUInt32($DNSRecord, 20)
            if ($Age -ne 0) {
                $timestamp = ((Get-Date -Year 1601 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0).AddHours($age)).ToString()
            }
            else {
                $timestamp = '[static]'
            }

            $dnsRecordObject = New-Object PSObject

            switch ($rDataType) {
                1 {
                    $IP = "{0}.{1}.{2}.{3}" -f $DNSRecord[24], $DNSRecord[25], $DNSRecord[26], $DNSRecord[27]
                    $data = $IP
                    $dnsRecordObject | Add-Member Noteproperty 'RecordType' 'A'
                }
                2 {
                    $NSName = Get-Name $DNSRecord[24..$DNSRecord.length]
                    $data = $NSName
                    $dnsRecordObject | Add-Member Noteproperty 'RecordType' 'NS'
                }
                5 {
                    $Alias = Get-Name $DNSRecord[24..$DNSRecord.length]
                    $data = $Alias
                    $dnsRecordObject | Add-Member Noteproperty 'RecordType' 'CNAME'
                }
                6 {
                    $data = $([Convert]::ToBase64String($DNSRecord[24..$DNSRecord.length]))
                    $dnsRecordObject | Add-Member Noteproperty 'RecordType' 'SOA'
                }
                12 {
                    $ptr = Get-Name $DNSRecord[24..$DNSRecord.length]
                    $data = $ptr
                    $dnsRecordObject | Add-Member Noteproperty 'RecordType' 'PTR'
                }
                13 {
                    $data = $([Convert]::ToBase64String($DNSRecord[24..$DNSRecord.length]))
                    $dnsRecordObject | Add-Member Noteproperty 'RecordType' 'HINFO'
                }
                15 {
                    $data = $([Convert]::ToBase64String($DNSRecord[24..$DNSRecord.length]))
                    $dnsRecordObject | Add-Member Noteproperty 'RecordType' 'MX'
                }
                16 {
                    [string] $txt  = ''
                    [int] $segmentLength = $DNSRecord[24]
                    $Index = 25
                    while ($segmentLength-- -gt 0) {
                        $txt += [char]$DNSRecord[$index++]
                    }
                    $data = $txt
                    $dnsRecordObject | Add-Member Noteproperty 'RecordType' 'TXT'
                }
                28 {
                    $data = $([Convert]::ToBase64String($DNSRecord[24..$DNSRecord.length]))
                    $dnsRecordObject | Add-Member Noteproperty 'RecordType' 'AAAA'
                }
                33 {
                    $data = $([Convert]::ToBase64String($DNSRecord[24..$DNSRecord.length]))
                    $dnsRecordObject | Add-Member Noteproperty 'RecordType' 'SRV'
                }
                default {
                    $data = $([Convert]::ToBase64String($DNSRecord[24..$DNSRecord.length]))
                    $dnsRecordObject | Add-Member Noteproperty 'RecordType' 'UNKNOWN'
                }
            }
            $dnsRecordObject | Add-Member Noteproperty 'UpdatedAtSerial' $updatedAtSerial
            $dnsRecordObject | Add-Member Noteproperty 'TTL' $ttl
            $dnsRecordObject | Add-Member Noteproperty 'Age' $age
            $dnsRecordObject | Add-Member Noteproperty 'Timestamp' $timestamp
            $dnsRecordObject | Add-Member Noteproperty 'Data' $data
            Write-Output $dnsRecordObject
        }

        try {
            $rootDSE = Get-LdapRootDSE -Server $Server
            $defaultNC = $rootDSE.defaultNamingContext[0]
            if (-not $PSBoundParameters['ZoneName']) {
                $ZoneName = $defaultNC -replace 'DC=' -replace ',', '.'
            }
            $searchBase = "DC=$($ZoneName),CN=MicrosoftDNS,DC=DomainDnsZones,$defaultNC"
        }
        catch {
            Write-Error "Domain controller unreachable" -ErrorAction Stop
        }
    }

    Process {
        $filter = '(objectClass=dnsNode)'
        $properties = 'name', 'distinguishedname', 'dnsrecord', 'whencreated', 'whenchanged'
        Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $searchBase -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
            $obj = $_
            if ($obj.dnsrecord -is [DirectoryServices.ResultPropertyValueCollection]) {
                $record = ConvertFrom-DNSRecord -DNSRecord $obj.dnsrecord[0]
            }
            else {
                $record = ConvertFrom-DNSRecord -DNSRecord $obj.dnsrecord
            }
            if ($record) {
                $record.PSObject.Properties | ForEach-Object {
                    $obj | Add-Member NoteProperty $_.Name $_.Value
                }
            }
            $obj | Add-Member NoteProperty 'ZoneName' $ZoneName
            Write-Output $obj | Select 'ZoneName','RecordType','Name','Data','Timestamp','WhenCreated','WhenChanged'
        }
    }
}

Function Get-DomainSubnet {
<#
.SYNOPSIS
    Get subnets from an Active Directory domain.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Get-DomainSubnet queries domain controller via LDAP protocol for subnet objects related to site objects.

.PARAMETER Server
    Specifies the domain controller to query.

.PARAMETER SSL
    Use SSL connection to LDAP Server.

.PARAMETER Credential
    Specifies the domain account to use.

.PARAMETER Site
    Specifies a target site to search for.

.EXAMPLE
    PS C:\> Get-DomainSubnet -Server ADATUM.CORP -Credential ADATUM\testuser

.EXAMPLE
    PS C:\> Get-DomainSubnet -Site 'Default-First-Site-Name'
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty,

        [ValidateNotNullOrEmpty()]
        [String]
        $Site
    )

    Begin {
        try {
            $rootDSE = Get-LdapRootDSE -Server $Server
            $configurationNC = $rootDSE.configurationNamingContext[0]
        }
        catch {
            Write-Error "Domain controller unreachable" -ErrorAction Stop
        }
    }

    Process {
        $filter = "(objectCategory=subnet)"
        if ($Site) {
            $filter = "(&(objectClass=site)(name=$Site))"
            if ($siteDn = (Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $configurationNC -Filter $filter -Properties 'distinguishedName' -Credential $Credential).distinguishedName) {
                $filter = "(&(objectCategory=subnet)(siteObject=$siteDn))"
            }
            else {
                Write-Error "Site $Site does not exist" -ErrorAction Stop
            }
        }
        $properties = 'name', 'siteObject', 'description'
        Get-LdapObject -Server $Server -SSL:$SSL -SearchBase $configurationNC -Filter $filter -Properties $properties -Credential $Credential | ForEach-Object {
            Write-Output ([pscustomobject] @{
                Site = $_.siteObject -replace ",CN=Sites,$configurationNC" -replace "CN="
                Subnet = $_.name
                Description = $_.description
            })
        }
    }

    End {}
}

Function Local:Get-LdapRootDSE {
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL
    )

    $searchString = "LDAP://$Server/RootDSE"
    if ($SSL) {
        # Note that the server certificate has to be trusted
        $authType = [DirectoryServices.AuthenticationTypes]::SecureSocketsLayer
    }
    else {
        $authType = [DirectoryServices.AuthenticationTypes]::Anonymous
    }
    $rootDSE = New-Object DirectoryServices.DirectoryEntry($searchString, $null, $null, $authType)
    return $rootDSE
}

Function Local:Get-LdapObject {
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [String]
        $SearchBase,

        [ValidateSet('Base', 'OneLevel', 'Subtree')]
        [String]
        $SearchScope = 'Subtree',

        [ValidateNotNullOrEmpty()]
        [String]
        $Filter = '(objectClass=*)',

        [ValidateNotNullOrEmpty()]
        [String[]]
        $Properties = '*',

        [ValidateRange(1,10000)] 
        [Int]
        $PageSize = 200,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    Begin {
        if ((-not $SearchBase) -or $SSL) {
            # Get default naming context
            try {
                $rootDSE = Get-LdapRootDSE -Server $Server
                $defaultNC = $rootDSE.defaultNamingContext[0]
            }
            catch {
                Write-Error "Domain controller unreachable"
                continue
            }
            if (-not $SearchBase) {
                $SearchBase = $defaultNC
            }
        }
    }

    Process {
        try {
            if ($SSL) {
                $results = @()
                $domain = $defaultNC -replace 'DC=' -replace ',','.'
                [Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.Protocols") | Out-Null
                $searcher = New-Object -TypeName System.DirectoryServices.Protocols.LdapConnection -ArgumentList "$($Server):636"
                $searcher.SessionOptions.SecureSocketLayer = $true
                $searcher.SessionOptions.VerifyServerCertificate = {$true}
                $searcher.SessionOptions.DomainName = $domain
                $searcher.AuthType = [DirectoryServices.Protocols.AuthType]::Negotiate
                if ($Credential.UserName) {
                    $searcher.Bind($Credential)
                }
                else {
                    $searcher.Bind()
                }
                if ($Properties -ne '*') {
                    $request = New-Object -TypeName System.DirectoryServices.Protocols.SearchRequest($SearchBase, $Filter, $SearchScope, $Properties)
                }
                else {
                    $request = New-Object -TypeName System.DirectoryServices.Protocols.SearchRequest($SearchBase, $Filter, $SearchScope)
                }
                $pageRequestControl = New-Object -TypeName System.DirectoryServices.Protocols.PageResultRequestControl -ArgumentList $PageSize
                $request.Controls.Add($pageRequestControl) | Out-Null
                $response = $searcher.SendRequest($request)
                while ($true) {
                    $response = $searcher.SendRequest($request)
                    if ($response.ResultCode -eq 'Success') {
                        foreach ($entry in $response.Entries) {
                            $results += $entry
                        }
                    }
                    $pageResponseControl = [DirectoryServices.Protocols.PageResultResponseControl]$response.Controls[0]
                    if ($pageResponseControl.Cookie.Length -eq 0) {
                        break
                    }
                    $pageRequestControl.Cookie = $pageResponseControl.Cookie
                }
                
            }
            else {
                $adsPath = "LDAP://$Server/$SearchBase"
                if ($Credential.UserName) {
                    $domainObject = New-Object DirectoryServices.DirectoryEntry($adsPath, $Credential.UserName, $Credential.GetNetworkCredential().Password)
                    $searcher = New-Object DirectoryServices.DirectorySearcher($domainObject)
                }
                else {
                    $searcher = New-Object DirectoryServices.DirectorySearcher([ADSI]$adsPath)
                }
                $searcher.SearchScope = $SearchScope
                $searcher.PageSize = $PageSize
                $searcher.CacheResults = $false
                $searcher.filter = $Filter
                $propertiesToLoad = $Properties | ForEach-Object {$_.Split(',')}
                $searcher.PropertiesToLoad.AddRange($propertiesToLoad) | Out-Null
                $results = $searcher.FindAll()
            }
        }
        catch {
            Write-Error $_
            continue
        }

        $results | Where-Object {$_} | ForEach-Object {
            if (Get-Member -InputObject $_ -name "Attributes" -Membertype Properties) {
                # Convert DirectoryAttribute object (LDAPS results)
                $p = @{}
                foreach ($a in $_.Attributes.Keys | Sort-Object) {
                    if (($a -eq 'objectsid') -or ($a -eq 'sidhistory') -or ($a -eq 'objectguid') -or ($a -eq 'securityidentifier') -or ($a -eq 'msds-allowedtoactonbehalfofotheridentity') -or ($a -eq 'usercertificate') -or ($a -eq 'ntsecuritydescriptor') -or ($a -eq 'logonhours')) {
                        $p[$a] = $_.Attributes[$a]
                    }
                    elseif ($a -eq 'dnsrecord') {
                        $p[$a] = ($_.Attributes[$a].GetValues([byte[]]))[0]
                    }
                    elseif (($a -eq 'whencreated') -or ($a -eq 'whenchanged')) {
                        $value = ($_.Attributes[$a].GetValues([byte[]]))[0]
                        $format = "yyyyMMddHHmmss.fZ"
                        $p[$a] = [datetime]::ParseExact([Text.Encoding]::UTF8.GetString($value), $format, [cultureinfo]::InvariantCulture)
                    }
                    else {
                        $values = @()
                        foreach ($v in $_.Attributes[$a].GetValues([byte[]])) {
                            $values += [Text.Encoding]::UTF8.GetString($v)
                        }
                        $p[$a] = $values
                    }
                }
            }
            else {
                $p = $_.Properties
            }
            $objectProperties = @{}
            $p.Keys | ForEach-Object {
                if (($_ -ne 'adspath') -and ($p[$_].count -eq 1)) {
                    $objectProperties[$_] = $p[$_][0]
                }
                elseif ($_ -ne 'adspath') {
                    $objectProperties[$_] = $p[$_]
                }
            }
            New-Object -TypeName PSObject -Property ($objectProperties)
        }
    }

    End {
        if ($results -and -not $SSL) {
            $results.dispose()
        }
        if ($searcher) {
            $searcher.dispose()
        }
    }
}

Function Local:Get-LdapObjectAcl {
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $SSL,

        [ValidateNotNullOrEmpty()]
        [String]
        $SearchBase,

        [ValidateSet('Base', 'OneLevel', 'Subtree')]
        [String]
        $SearchScope = 'Subtree',

        [ValidateNotNullOrEmpty()]
        [String]
        $Filter = '(objectClass=domain)',

        [ValidateRange(1,10000)] 
        [Int]
        $PageSize = 200,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    Begin {
        if ((-not $SearchBase) -or $SSL) {
            # Get default naming context
            try {
                $rootDSE = Get-LdapRootDSE -Server $Server
                $defaultNC = $rootDSE.defaultNamingContext[0]
            }
            catch {
                Write-Error "Domain controller unreachable"
                continue
            }
            if (-not $SearchBase) {
                $SearchBase = $defaultNC
            }
        }
        $securityMasks = [DirectoryServices.SecurityMasks]::Dacl
    }

    Process {
        try {
            if ($SSL) {
                $domain = $defaultNC -replace 'DC=' -replace ',','.'
                [Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.Protocols") | Out-Null
                $searcher = New-Object -TypeName System.DirectoryServices.Protocols.LdapConnection -ArgumentList "$($Server):636"
                $searcher.SessionOptions.SecureSocketLayer = $true
                $searcher.SessionOptions.VerifyServerCertificate = {$true}
                $searcher.SessionOptions.DomainName = $domain
                $searcher.AuthType = [DirectoryServices.Protocols.AuthType]::Negotiate
                if ($Credential.UserName) {
                    $searcher.Bind($Credential)
                }
                else {
                    $searcher.Bind()
                }
                $request = New-Object -TypeName System.DirectoryServices.Protocols.SearchRequest($SearchBase, $Filter, $SearchScope)
                $pageRequestControl = New-Object -TypeName System.DirectoryServices.Protocols.PageResultRequestControl -ArgumentList $PageSize
                $request.Controls.Add($pageRequestControl) | Out-Null
                $sdFlagsControl = New-Object -TypeName System.DirectoryServices.Protocols.SecurityDescriptorFlagControl -ArgumentList $securityMasks
                $request.Controls.Add($sdFlagsControl) | Out-Null
                $response = $searcher.SendRequest($request)
                while ($true) {
                    $response = $searcher.SendRequest($request)
                    if ($response.ResultCode -eq 'Success') {
                        foreach ($entry in $response.Entries) {
                            $results += $entry
                        }
                    }
                    $pageResponseControl = [DirectoryServices.Protocols.PageResultResponseControl]$response.Controls[0]
                    if ($pageResponseControl.Cookie.Length -eq 0) {
                        break
                    }
                    $pageRequestControl.Cookie = $pageResponseControl.Cookie
                }
            }
            else {
                $adsPath = "LDAP://$Server/$SearchBase"
                if ($Credential.UserName) {
                    $domainObject = New-Object DirectoryServices.DirectoryEntry($adsPath, $Credential.UserName, $Credential.GetNetworkCredential().Password)
                    $searcher = New-Object DirectoryServices.DirectorySearcher($domainObject)
                }
                else {
                    $searcher = New-Object DirectoryServices.DirectorySearcher([ADSI]$adsPath)
                }
                $searcher.SearchScope = $SearchScope
                $searcher.PageSize = $PageSize
                $searcher.CacheResults = $false
                $searcher.filter = $Filter
                $propertiesToLoad = 'objectsid', 'ntsecuritydescriptor', 'distinguishedname'
                $searcher.PropertiesToLoad.AddRange($propertiesToLoad) | Out-Null
                $searcher.SecurityMasks = $securityMasks
                $results = $searcher.FindAll()
            }
        }
        catch {
            Write-Error $_
            continue
        }

        $results | Where-Object {$_} | ForEach-Object {
            if (Get-Member -InputObject $_ -name "Attributes" -Membertype Properties) {
                # Convert DirectoryAttribute object (LDAPS results)
                $p = @{}
                foreach ($a in $_.Attributes.Keys | Sort-Object) {
                    if (($a -eq 'objectsid') -or ($a -eq 'securityidentifier') -or ($a -eq 'ntsecuritydescriptor')) {
                        $p[$a] = $_.Attributes[$a]
                    }
                    else {
                        $values = @()
                        foreach ($v in $_.Attributes[$a].GetValues([byte[]])) {
                            $values += [Text.Encoding]::UTF8.GetString($v)
                        }
                        $p[$a] = $values
                    }
                }
            }
            else {
                $p = $_.Properties
            }
            $objectSid = $null
            if ($p.objectsid -and $p.objectsid[0]) {
                $objectSid = (New-Object Security.Principal.SecurityIdentifier($p.objectsid[0], 0)).Value
            }
            New-Object Security.AccessControl.RawSecurityDescriptor -ArgumentList $p['ntsecuritydescriptor'][0], 0 | ForEach-Object { $_.DiscretionaryAcl } | ForEach-Object {
                $_ | Add-Member NoteProperty 'ObjectDN' $p.distinguishedname[0]
                $_ | Add-Member NoteProperty 'ObjectSID' $objectSid
                $_ | Add-Member NoteProperty 'ActiveDirectoryRights' ([Enum]::ToObject([DirectoryServices.ActiveDirectoryRights], $_.AccessMask))
                Write-Output $_
            }
        }
    }

    End {
        if ($results -and -not $SSL) {
            $results.dispose()
        }
        if ($searcher) {
            $searcher.dispose()
        }
    }
}

Add-Type @"
using System;
using System.Runtime.InteropServices;
namespace ADMap {
    public class Win32 {
        [DllImport("advapi32.dll", SetLastError = true, EntryPoint = "SystemFunction007", CharSet = CharSet.Unicode)]
        public static extern int RtlCalculateNtOwfPassword(ref UNICODE_STRING password, [MarshalAs(UnmanagedType.LPArray)] byte[] hash);

        [StructLayout(LayoutKind.Sequential)]
        public struct UNICODE_STRING : IDisposable {
            public ushort Length;
            public ushort MaximumLength;
            public IntPtr buffer;

            public UNICODE_STRING(string s) {
                Length = (ushort)(s.Length * 2);
                MaximumLength = (ushort)(Length + 2);
                buffer = Marshal.StringToHGlobalUni(s);
            }

            public void Dispose() {
                Marshal.FreeHGlobal(buffer);
                buffer = IntPtr.Zero;
            }
        }
    }
}
"@
