function Invoke-Utility {
<#
                                          
.SYNOPSIS

	Miscellaneous Utilities.

.PARAMETER Help

	Shows detailed help for each function.
	
.PARAMETER List

	Shows brief command usage list.

	
.PARAMETER TcpScan

	A Simple TCP Port Scanner.
	
.PARAMETER TimeStomp

	Modifies a files' Creation Time to that of C:\windows\system32\cmd.exe. The 'TimeOf' parameter can be used to change the timestamp to match that of some other file.
	
.PARAMETER FindFile

	Search for a file.

.EXAMPLE

	Invoke-Utility -TcpScan -IpAddress 192.168.0.1 -Ports 80,443,3389,22,445
	
.EXAMPLE
	
	(Time Stomps C:\payload.exe to match C:\windows\system32\cmd.exe)
	Invoke-Utility -TimeStomp -File C:\payload.exe
	
	(Time Stomps C:\payload.exe to match C:\Users\user\Documents\foo.doc)
	Invoke-Utility -TimeStomp -File C:\payload.exe -TimeOf C:\Users\user\Documents\foo.doc

	
.EXAMPLE

	Invoke-Utility -FindFile -File passwords.doc -Path C:\Users
	Invoke-Utility -FindFile -File passwords* -Path C:\Users
	
.NOTES

	Author: Fabrizio Siciliano (@0rbz_)
	
#>
[CmdletBinding()]
param (

	[Parameter(Position=1)]
	[Switch]$Help,
	[Switch]$List,
	
	[Parameter(Mandatory = $False)]
	[Switch]$TcpScan,
	[String]$IpAddress,
	$Ports,
	[Switch]$Force,
	
	[Parameter(Mandatory = $False)]
	[Switch]$TimeStomp,
	[String]$File,
	[String]$TimeOf,
	
	[Parameter(Mandatory = $False)]
	[Switch]$FindFile,
	[string]$File2=[string]$File,
	[String]$Path
	
)

$DataDirs = @(
	("C:\ProgramData\Intel"),
	("C:\ProgramData\Microsoft\Crypto\SystemKeys"),
	("C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys"),
	("C:\ProgramData\Microsoft\Crypto\SystemKeys"),
	("C:\ProgramData\Microsoft\Diagnosis"),
	("C:\ProgramData\Microsoft\Diagnosis\FeedbackHub"),
	("C:\ProgramData\Microsoft\Diagnosis\Scripts"),
	("C:\ProgramData\Microsoft\Network\Downloader"),
	("C:\ProgramData\Microsoft\Office\Heartbeat"),
	("C:\ProgramData\Microsoft\Search\Data"),
	("C:\ProgramData\Microsoft\Search\Data\Applications"),
	("C:\ProgramData\Microsoft\Search\Data\Temp"),
	("C:\ProgramData\WindowsHolographicDevices"),
	("C:\Users\Public\Libraries"),
	("C:\Users\Public\AccountPictures"),
	("C:\Users\Public\Documents"),
	("C:\Users\Public\Downloads"),
	("C:\Users\Public\Music"),
	("C:\Users\Public\Pictures"),
	("C:\Users\Public\Videos"),
	("C:\Users\Public\Roaming"),
	("C:\Windows\debug\WIA"),
	("C:\Windows\ServiceProfiles\LocalService"),
	("C:\Windows\ServiceProfiles\LocalService\AppData"),
	("C:\Windows\ServiceProfiles\LocalService\AppData\Local"),
	("C:\Windows\ServiceProfiles\LocalService\AppData\LocalLow"),
	("C:\Windows\Temp"),
	("C:\windows\system32\config"),
	("C:\Windows\System32\LogFiles\WMI"),
	("C:\Windows\System32\Microsoft\Crypto\RSA\MachineKeys")
)

$NewArray = foreach ($datadir in $datadirs) {
	if (Test-Path $datadir) {
	@($datadir)
	}
}
$datadir = ($newarray[(get-random -Maximum ([array]$newarray).count)])



		if ($Help) {
		Write @"

 ### Invoke-Utility Help ###
 --------------------------------
 Available Invoke-Utility Commands:
 --------------------------------
 |---------------------------------------------------------------------|
 | -TcpScan [-IpAddress] ip_address [-Ports] ports [-Force]            |
 |---------------------------------------------------------------------|

   [*] Description: Simple TCP Port Scanner.

   [*] Usage: Invoke-Utility -TcpScan -IpAddress 192.168.0.1 -Ports 80,443,8080
   [*] Usage: Invoke-Utility -TcpScan -IpAddress 192.168.0.1 -Ports 80,443,8080 -Force
       (Will attempt to scan the host in the case ICMP echo request is blocked.)
   
   [*] Mitre ATT&CK Ref: T1423 (Network Service Scanning)
   
 |----------------------------------------------------------------------|
 | -TimeStomp [-File] file.exe [-TimeOf] someotherfile.exe              |
 |----------------------------------------------------------------------|

   [*] Description: Modifies a files' Creation Time to that of 
       C:\windows\system32\cmd.exe. The 'TimeOf' parameter can be used
       to change the timestamp to match that of some other file.

   [*] Usage: Invoke-Utility -TimeStomp -File C:\temp\file.exe
   [*] Usage: Invoke-Utility -TimeStomp -File C:\temp\file.exe -TimeOf C:\windows\system32\calc.exe

   [*] Mitre ATT&CK Ref: T1099 (Timestomp)
   
 |----------------------------------------------------------------------|
 | -FindFile -File file.txt -Path path                                  |
 |----------------------------------------------------------------------|
 
 [*] Description: Search for a file.

 [*] Usage: Invoke-Utility -FindFile -File passwords.xls -Path C:\Users
   
 \---------------------------------------------------------------------/
   
"@
	}
	elseif ($List) {
		Write @"  

 Invoke-Utility Brief Command Usage:
 -----------------------------------
 Invoke-Utility -TcpScan -IpAddress 192.168.0.1 -Ports 80,443,8080
 Invoke-Utility -TimeStomp -File C:\temp\file.exe
 Invoke-Utility -TimeStomp -File C:\temp\file.exe -TimeOf C:\windows\system32\calc.exe
 Invoke-Utility -FindFile -File passwords.xls -Path C:\Users

"@
	}
	elseif ($TCPScan -and $IpAddress) {
	
		if ($PSVersionTable.PSVersion.Major -eq "2") {
			Write "`n [!] This function requires PowerShell version greater than 2.0.`n"
			return
		}
		if ($(Test-Connection -Quiet -Count 1 $IpAddress)) {
	
			foreach ($Port in $Ports) {
			
				$TcpClient = New-Object System.Net.Sockets.TcpClient
				$Connect = $TcpClient.BeginConnect($IpAddress, $Port, $Null, $Null)
				$TimeOut = $Connect.AsyncWaitHandle.WaitOne(5, $True)
			
				if (!$TimeOut) {
					$TcpClient.Close() 
					sleep 1
				}
				else {
					Write "Open: $Port"
					$TcpClient.Close()
					sleep 1
				}
			}
		}
		else {
			Write "Host appears offline."
		}
	}
	elseif ($TCPScan -and $IpAddress -and $Force) {
		if ($PSVersionTable.PSVersion.Major -eq "2") {
		Write "`n [!] This function requires PowerShell version greater than 2.0.`n"
		return
	}
		if (!$(Test-Connection -Quiet -Count 1 $IpAddress)) {
	
			foreach ($Port in $Ports) {
				
				$TcpClient = New-Object System.Net.Sockets.TcpClient
				$Connect = $TcpClient.BeginConnect($IpAddress, $Port, $Null, $Null)
				$TimeOut = $Connect.AsyncWaitHandle.WaitOne(5, $True)
				
				if (!$TimeOut) {
					$TcpClient.Close() 
					sleep 1
				}
				else {
					Write "Open: $Port"
					$TcpClient.Close()
					sleep 1
				}
			}
		}
	}
	elseif ($TimeStomp -and $File -and $TimeOf) {
	
		$TimeSource = (Get-Item $TimeOf).FullName
		[IO.File]::SetCreationTime("$File", [IO.File]::GetCreationTime($TimeSource))
		[IO.File]::SetLastAccessTime("$File", [IO.File]::GetLastAccessTime($TimeSource))
		[IO.File]::SetLastWriteTIme("$File", [IO.File]::GetLastWriteTime($TimeSource))
		
		Write " `n[+] Changed Creation, Last Access, and Last Write Time for $File`:"
		(Get-Item $File)
	}
	elseif ($TimeStomp -and $File -and !$TimeOf) {
	
		[IO.File]::SetCreationTime("$File", [IO.File]::GetCreationTime($TimeSource))
		[IO.File]::SetLastAccessTime("$File", [IO.File]::GetLastAccessTime($TimeSource))
		[IO.File]::SetLastWriteTIme("$File", [IO.File]::GetLastWriteTime($TimeSource))
		
		Write " `n[+] Changed Creation, Last Access, and Last Write Time for $File`:"
		(Get-Item $File)
	}
	elseif ($FindFile -and $File -and $Path) {
		
		Get-ChildItem -Path $Path -Filter $File -Recurse -ErrorAction SilentlyContinue -Force
	}
}